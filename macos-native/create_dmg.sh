#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "DMG creation only works on macOS because it requires hdiutil." >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_NAME="XMBar"
VOL_NAME="XMBar"
DIST_DIR="${DIST_DIR:-$SCRIPT_DIR/dist}"
APP_PATH="$DIST_DIR/$APP_NAME.app"
SKIP_BUILD=0
DMG_OUTPUT=""
BUILD_ARGS=()

usage() {
  cat <<EOF
Usage: build_dmg.sh [options] [build_app.sh options]

Options:
  --skip-build        Package the existing macos-native/dist/XMBar.app
  --output PATH       Write the DMG to PATH
  --help, -h          Show this help

Any other option is forwarded to macos-native/build_app.sh.
Examples:
  ./build_dmg.sh
  ./build_dmg.sh --output ~/Desktop/XMBar.dmg
  ./build_dmg.sh --skip-build
  ./build_dmg.sh --config Debug --no-clean
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h)
      usage
      exit 0
      ;;
    --skip-build)
      SKIP_BUILD=1
      shift
      ;;
    --output)
      DMG_OUTPUT="${2:-}"
      shift 2
      ;;
    *)
      BUILD_ARGS+=("$1")
      shift
      ;;
  esac
done

if [[ "$SKIP_BUILD" != "1" ]]; then
  # macOS still ships Bash 3.x, where expanding an empty array with
  # `set -u` can fail with: BUILD_ARGS[@]: unbound variable. Temporarily
  # relax nounset for this one expansion so calling build_dmg.sh with no
  # forwarded build options works.
  set +u
  "$SCRIPT_DIR/build_app.sh" "${BUILD_ARGS[@]}"
  set -u
fi

if [[ ! -d "$APP_PATH" ]]; then
  echo "Could not find $APP_PATH." >&2
  echo "Build the app first with macos-native/build_app.sh or run build_dmg.sh without --skip-build." >&2
  exit 1
fi

if ! command -v hdiutil >/dev/null 2>&1; then
  echo "hdiutil is missing. This script must run on macOS." >&2
  exit 1
fi

# Finder can reuse an old window layout if another DMG with the same volume name
# is mounted. Detach it first so AppleScript customizes the new temporary volume.
while IFS= read -r mounted_xmbar_volume; do
  if [[ -n "$mounted_xmbar_volume" && -d "$mounted_xmbar_volume" ]]; then
    echo "Detaching previous XMBar volume: $mounted_xmbar_volume"
    hdiutil detach "$mounted_xmbar_volume" >/dev/null 2>&1 || diskutil eject "$mounted_xmbar_volume" >/dev/null 2>&1 || true
  fi
done < <(find /Volumes -maxdepth 1 \( -name "$VOL_NAME" -o -name "$VOL_NAME [0-9]*" \) -print 2>/dev/null)

VERSION="0.0"
if /usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$APP_PATH/Contents/Info.plist" >/tmp/xmbar-version.$$ 2>/dev/null; then
  VERSION="$(cat /tmp/xmbar-version.$$)"
fi
rm -f /tmp/xmbar-version.$$

FINAL_DMG="${DMG_OUTPUT:-$DIST_DIR/$APP_NAME-$VERSION.dmg}"
STAGE_DIR="$SCRIPT_DIR/.dmg-stage"
TMP_DMG="$SCRIPT_DIR/.dmg-tmp.dmg"

rm -rf "$STAGE_DIR" "$TMP_DMG" "$FINAL_DMG"
mkdir -p "$STAGE_DIR"

cp -R "$APP_PATH" "$STAGE_DIR/$APP_NAME.app"
ln -s /Applications "$STAGE_DIR/Applications"

BACKGROUND_SOURCE="$SCRIPT_DIR/Resources/DMGBackground.png"
HAS_BACKGROUND=0
if [[ -f "$BACKGROUND_SOURCE" ]]; then
  HAS_BACKGROUND=1
  mkdir -p "$STAGE_DIR/.background"
  cp "$BACKGROUND_SOURCE" "$STAGE_DIR/.background/background.png"
fi

hdiutil create \
  -volname "$VOL_NAME" \
  -srcfolder "$STAGE_DIR" \
  -fs HFS+ \
  -format UDRW \
  "$TMP_DMG" >/dev/null

DEVICE=""
ATTACH_OUTPUT="$(hdiutil attach -readwrite -noverify -noautoopen "$TMP_DMG")"
DEVICE="$(printf '%s\n' "$ATTACH_OUTPUT" | awk '/\/Volumes\// {print $1; exit}')"
MOUNT_DIR="$(printf '%s\n' "$ATTACH_OUTPUT" | awk '/\/Volumes\// {for (i=1; i<=NF; i++) if ($i ~ /^\/Volumes\//) {print substr($0, index($0, $i)); exit}}')"

if [[ -z "$DEVICE" || -z "$MOUNT_DIR" || ! -d "$MOUNT_DIR" ]]; then
  echo "Could not mount the temporary DMG." >&2
  printf '%s\n' "$ATTACH_OUTPUT" >&2
  exit 1
fi

echo "Temporary DMG mounted at: $MOUNT_DIR"
if [[ -d "$MOUNT_DIR/.background" ]]; then
  chflags hidden "$MOUNT_DIR/.background" 2>/dev/null || true
fi

# Finder can ignore the layout if it is applied before the DMG window exists.
# Open it first, wait, then use an absolute POSIX path for the background image.
open "$MOUNT_DIR" || true
sleep 1

osascript <<OSA
set volumeName to "$VOL_NAME"
set mountPath to "$MOUNT_DIR"
set appName to "$APP_NAME.app"
set hasBackground to $HAS_BACKGROUND
set bgFileAlias to missing value
if hasBackground is 1 then
  set bgFileAlias to (POSIX file (mountPath & "/.background/background.png")) as alias
end if

tell application "Finder"
  activate
  tell disk volumeName
    open
    delay 0.4
    set current view of container window to icon view
    set toolbar visible of container window to false
    set statusbar visible of container window to false
    set the bounds of container window to {180, 120, 1140, 660}

    set viewOptions to the icon view options of container window
    set arrangement of viewOptions to not arranged
    set icon size of viewOptions to 112
    set text size of viewOptions to 13

    if hasBackground is 1 then
      set background picture of viewOptions to bgFileAlias
    end if

    try
      set position of item appName of container window to {300, 390}
    on error
      set position of item "$APP_NAME" of container window to {300, 390}
    end try
    set position of item "Applications" of container window to {660, 390}

    update without registering applications
    delay 1
    close
  end tell
end tell
OSA

# Give Finder time to write .DS_Store inside the DMG.
sync
sleep 1
hdiutil detach "$DEVICE" >/dev/null

hdiutil convert "$TMP_DMG" \
  -format UDZO \
  -imagekey zlib-level=9 \
  -o "$FINAL_DMG" >/dev/null

rm -rf "$STAGE_DIR" "$TMP_DMG"

echo "DMG created: $FINAL_DMG"
