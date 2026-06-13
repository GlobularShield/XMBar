#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This build script only works on macOS." >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

CONFIG="${CONFIG:-Release}"
TARGET="${TARGET:-XMBar}"
APP_NAME="${APP_NAME:-XMBar}"
DIST_DIR="${DIST_DIR:-$SCRIPT_DIR/dist}"
DEPLOYMENT_TARGET="${MACOSX_DEPLOYMENT_TARGET:-26.0}"
ARCHS="${CMAKE_OSX_ARCHITECTURES:-arm64}"
FORCE_GENERATOR="${GENERATOR:-}"
CLEAN_BUILD="${CLEAN_BUILD:-0}"

MDR_ROOT="${MDR_ROOT:-}"
FMT_ROOT="${FMT_ROOT:-}"
FMT_LIB_DIR="${FMT_LIB_DIR:-}"
MDR_PLATFORM_LIBRARY="${MDR_PLATFORM_LIBRARY:-}"
MDR_LIB_DIR="${MDR_LIB_DIR:-}"
MDR_SOURCE_ROOT="${MDR_SOURCE_ROOT:-}"
EXTRA_USER_ARGS=()

usage() {
  cat <<EOF
Usage: macos-native/build_app.sh [options] [-- extra cmake args]

Options:
  --generator ninja|xcode
  --config Debug|Release
  --build-dir PATH
  --dist-dir PATH
  --deployment-target VERSION
  --archs ARCHS
  --clean
  --no-clean
  --mdr-root PATH
  --mdr-source-root PATH
  --mdr-lib-dir PATH
  --mdr-platform-library PATH
  --fmt-root PATH
  --fmt-lib-dir PATH
EOF
}

BUILD_DIR=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h)
      usage
      exit 0
      ;;
    --generator)
      FORCE_GENERATOR="${2:-}"
      shift 2
      ;;
    --config)
      CONFIG="${2:-}"
      shift 2
      ;;
    --build-dir)
      BUILD_DIR="${2:-}"
      shift 2
      ;;
    --dist-dir)
      DIST_DIR="${2:-}"
      shift 2
      ;;
    --deployment-target)
      DEPLOYMENT_TARGET="${2:-}"
      shift 2
      ;;
    --archs)
      ARCHS="${2:-}"
      shift 2
      ;;
    --clean)
      CLEAN_BUILD=1
      shift
      ;;
    --no-clean)
      CLEAN_BUILD=0
      shift
      ;;
    --mdr-root)
      MDR_ROOT="${2:-}"
      shift 2
      ;;
    --mdr-source-root)
      MDR_SOURCE_ROOT="${2:-}"
      shift 2
      ;;
    --mdr-lib-dir)
      MDR_LIB_DIR="${2:-}"
      shift 2
      ;;
    --mdr-platform-library)
      MDR_PLATFORM_LIBRARY="${2:-}"
      shift 2
      ;;
    --fmt-root)
      FMT_ROOT="${2:-}"
      shift 2
      ;;
    --fmt-lib-dir)
      FMT_LIB_DIR="${2:-}"
      shift 2
      ;;
    --)
      shift
      EXTRA_USER_ARGS+=("$@")
      break
      ;;
    *)
      EXTRA_USER_ARGS+=("$1")
      shift
      ;;
  esac
done

if ! command -v cmake >/dev/null 2>&1; then
  echo "CMake is required. Install it with Homebrew or from https://cmake.org/download/." >&2
  exit 1
fi

GENERATOR_NORMALIZED="$(printf '%s' "$FORCE_GENERATOR" | tr '[:upper:]' '[:lower:]')"
EXTRA_CMAKE_ARGS=()
GENERATOR_LABEL=""
case "$GENERATOR_NORMALIZED" in
  ""|ninja)
    if command -v ninja >/dev/null 2>&1; then
      BUILD_DIR="${BUILD_DIR:-$REPO_ROOT/build/macos-native-$CONFIG}"
      EXTRA_CMAKE_ARGS=(-G Ninja -DCMAKE_BUILD_TYPE="$CONFIG")
      GENERATOR_LABEL="Ninja"
    else
      BUILD_DIR="${BUILD_DIR:-$REPO_ROOT/build/macos-native-xcode}"
      EXTRA_CMAKE_ARGS=(-G Xcode)
      GENERATOR_LABEL="Xcode"
    fi
    ;;
  xcode)
    BUILD_DIR="${BUILD_DIR:-$REPO_ROOT/build/macos-native-xcode}"
    EXTRA_CMAKE_ARGS=(-G Xcode)
    GENERATOR_LABEL="Xcode"
    ;;
  *)
    echo "Unsupported generator: $FORCE_GENERATOR. Use ninja or xcode." >&2
    exit 1
    ;;
esac

if [[ "$CLEAN_BUILD" == "1" ]]; then
  rm -rf "$BUILD_DIR"
fi

# CMake caches are tied to the absolute source/build paths. If the project is
# moved (for example from Downloads to a Projects folder), a stale cache causes:
#   The source ... does not match the source ... used to generate cache.
# Detect that and clean automatically so the scripts work after moving/cloning.
if [[ -f "$BUILD_DIR/CMakeCache.txt" ]]; then
  CACHED_SOURCE="$(awk -F= '/^CMAKE_HOME_DIRECTORY:INTERNAL=/{print $2; exit}' "$BUILD_DIR/CMakeCache.txt" 2>/dev/null || true)"
  CACHED_BUILD="$(awk -F= '/^CMAKE_CACHEFILE_DIR:INTERNAL=/{print $2; exit}' "$BUILD_DIR/CMakeCache.txt" 2>/dev/null || true)"
  if [[ -n "$CACHED_SOURCE" && "$CACHED_SOURCE" != "$REPO_ROOT" ]]; then
    echo "Stale CMake cache detected for another source path:"
    echo "  cached: $CACHED_SOURCE"
    echo "  current: $REPO_ROOT"
    echo "Cleaning $BUILD_DIR ..."
    rm -rf "$BUILD_DIR"
  elif [[ -n "$CACHED_BUILD" && "$CACHED_BUILD" != "$BUILD_DIR" ]]; then
    echo "Stale CMake cache detected for another build path:"
    echo "  cached: $CACHED_BUILD"
    echo "  current: $BUILD_DIR"
    echo "Cleaning $BUILD_DIR ..."
    rm -rf "$BUILD_DIR"
  fi
fi

export CLANG_MODULE_CACHE_PATH="${CLANG_MODULE_CACHE_PATH:-$BUILD_DIR/module-cache}"
mkdir -p "$CLANG_MODULE_CACHE_PATH"

echo "Configuring $APP_NAME with CMake ($GENERATOR_LABEL)..."

CMAKE_CONFIGURE_CMD=(cmake -S "$REPO_ROOT" -B "$BUILD_DIR")
CMAKE_CONFIGURE_CMD+=("${EXTRA_CMAKE_ARGS[@]}")
CMAKE_CONFIGURE_CMD+=(
  -DMDR_BUILD_CLIENT=OFF
  -DMDR_BUILD_SWIFT_MENU=ON
  -DMDR_ENABLE_CODEGEN=OFF
  -DCMAKE_OSX_ARCHITECTURES="$ARCHS"
  -DCMAKE_OSX_DEPLOYMENT_TARGET="$DEPLOYMENT_TARGET"
)

[[ -n "$MDR_ROOT" ]] && CMAKE_CONFIGURE_CMD+=(-DMDR_ROOT="$MDR_ROOT")
[[ -n "$MDR_SOURCE_ROOT" ]] && CMAKE_CONFIGURE_CMD+=(-DMDR_SOURCE_ROOT="$MDR_SOURCE_ROOT")
[[ -n "$MDR_LIB_DIR" ]] && CMAKE_CONFIGURE_CMD+=(-DMDR_LIB_DIR="$MDR_LIB_DIR")
[[ -n "$MDR_PLATFORM_LIBRARY" ]] && CMAKE_CONFIGURE_CMD+=(-DMDR_PLATFORM_LIBRARY="$MDR_PLATFORM_LIBRARY")
[[ -n "$FMT_ROOT" ]] && CMAKE_CONFIGURE_CMD+=(-DFMT_ROOT="$FMT_ROOT")
[[ -n "$FMT_LIB_DIR" ]] && CMAKE_CONFIGURE_CMD+=(-DFMT_LIB_DIR="$FMT_LIB_DIR")

if [[ ${#EXTRA_USER_ARGS[@]} -gt 0 ]]; then
  CMAKE_CONFIGURE_CMD+=("${EXTRA_USER_ARGS[@]}")
fi

"${CMAKE_CONFIGURE_CMD[@]}"
cmake --build "$BUILD_DIR" --target "$TARGET" --config "$CONFIG"

APP_PATH="$(find "$BUILD_DIR" -path "*/$APP_NAME.app" -type d -print -quit)"
if [[ -z "$APP_PATH" ]]; then
  echo "Could not find $APP_NAME.app inside $BUILD_DIR." >&2
  exit 1
fi

mkdir -p "$DIST_DIR"
rm -rf "$DIST_DIR/$APP_NAME.app"
cp -R "$APP_PATH" "$DIST_DIR/$APP_NAME.app"

echo "App built: $DIST_DIR/$APP_NAME.app"
