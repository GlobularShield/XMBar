# Changelog

## 0.84

- Restored and clarified the README acknowledgements section for MDR/libmdr and project testers.
- Updated app metadata to version 0.84.

## 0.83

- Build scripts now detect and clean stale CMake caches automatically after moving or cloning the repository to a new path.
- This prevents source-directory mismatch errors when building the DMG from a relocated project folder.

## 0.82

- Cleaned repository structure for GitHub.
- Removed duplicated nested `XMBar/` folder from the distributable source archive.
- Kept only the macOS app, minimal `libmdr` pieces, build scripts, DMG assets, and project documentation.
- Added GitHub-ready README and NOTICE files.
- Removed the last generic visible firmware help reference to a manufacturer name.

## 0.81

- Reverted the menu bar headphones glyph to the native AirPods Max SF Symbol.
