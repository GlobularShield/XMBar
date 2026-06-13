cmake_minimum_required(VERSION 3.31 FATAL_ERROR)
project(XMBar LANGUAGES C CXX Swift)

if (NOT APPLE)
    message(FATAL_ERROR "XMBar only builds on macOS")
endif ()

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# XMBar only ships the macOS native menu-bar app. The old SDL/Web client,
# Emscripten build and cross-platform packaging have intentionally been removed.
set(MDR_PLATFORM_OS "MACOS" CACHE STRING "MDR platform used by XMBar" FORCE)
add_compile_definitions(MDR_PLATFORM_MACOS)

option(MDR_BUILD_SWIFT_MENU "Build XMBar" ON)

add_subdirectory(libmdr)

if (MDR_BUILD_SWIFT_MENU)
    add_subdirectory(macos-native)
endif ()
