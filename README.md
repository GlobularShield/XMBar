# XMBar

XMBar is a native macOS menu bar app for controlling supported MDR-compatible headphones.

It focuses on a small, native macOS experience: noise control, ambient level, battery status, quick controls, settings, shortcuts, automatic reconnect, optional launch at login, and a drag-to-Applications DMG installer.

## Status

Current public-prep version: **0.84**.

Tested primarily with WH-1000XM5-class headphones. Other MDR-compatible devices may work, but unsupported features are hidden when XMBar can detect that the current model does not expose them.

## Requirements

- macOS
- Xcode Command Line Tools
- CMake 3.31+
- Ninja recommended
- Homebrew `fmt`

Install common dependencies:

```bash
brew install cmake ninja fmt
```

If `brew` is installed but not found, enable it in your shell first:

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## Build the app

From the repository root:

```bash
chmod +x build_app.sh
./build_app.sh
```

The app is copied to:

```text
macos-native/dist/XMBar.app
```

## Build the DMG

```bash
chmod +x build_dmg.sh
./build_dmg.sh
```

The DMG is created at:

```text
macos-native/dist/XMBar-<version>.dmg
```

## Useful build options

```bash
./build_app.sh --clean
./build_app.sh --generator xcode
./build_app.sh --config Debug
./build_dmg.sh --skip-build
./build_dmg.sh --output ~/Desktop/XMBar.dmg
```

If you keep `libmdr` or `fmt` outside this repository, the scripts accept explicit paths:

```bash
./build_app.sh \
  --mdr-root /path/to/include-root-containing-mdr-c \
  --mdr-lib-dir /path/to/folder-containing-libmdr.a \
  --fmt-root /opt/homebrew/include \
  --fmt-lib-dir /opt/homebrew/lib
```

## Runtime permissions

Global shortcuts need macOS Accessibility permission. XMBar will show a prompt and open the correct System Settings page when you try to assign shortcuts without the required permission.

Launch-at-login uses macOS ServiceManagement. XMBar enables launch at login by default on first run, and respects the user's choice after that.

## Repository layout

```text
XMBar/
├── build_app.sh              # root wrapper for macos-native/build_app.sh
├── build_dmg.sh              # root wrapper for macos-native/create_dmg.sh
├── CMakeLists.txt            # macOS-only XMBar build
├── libmdr/                   # minimal native MDR library pieces needed by XMBar
├── macos-native/             # Swift/AppKit menu bar app, app icon, DMG assets
├── LICENSE                   # upstream MIT license text
├── NOTICE.md                 # attribution notes
└── README.md
```

Generated folders such as `build/`, `.build/`, `dist/`, `.app`, `.dmg`, and mounted DMG artifacts are intentionally ignored.

## Acknowledgements

XMBar uses MDR/libmdr support based on the work from the SonyHeadphonesClient project.

Special thanks to:

- [mos9527/SonyHeadphonesClient](https://github.com/mos9527/SonyHeadphonesClient), the current repository used as the MDR reference for this project.
- [Plutoberth/SonyHeadphonesClient](https://github.com/Plutoberth/SonyHeadphonesClient), for earlier work and maintenance of the SonyHeadphonesClient project.

XMBar would not be possible without the reverse-engineering and maintenance work done by the SonyHeadphonesClient community.

## Credits

XMBar is maintained by Globular.

`libmdr` uses `fmt` and includes attribution notes in `libmdr/README.md`. See `LICENSE` and `NOTICE.md` before redistributing.
