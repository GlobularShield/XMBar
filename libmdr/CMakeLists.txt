cmake_minimum_required(VERSION 3.31)

add_subdirectory(include)

# libmdr needs fmt. Prefer a system/Homebrew fmt when available, and fall back
# to FetchContent so a clean checkout can still build on macOS with internet.
find_package(fmt CONFIG QUIET)
if (NOT TARGET fmt::fmt)
    include(FetchContent)
    FetchContent_Declare(
        fmt
        GIT_REPOSITORY https://github.com/fmtlib/fmt.git
        GIT_TAG 12.1.0
        GIT_SHALLOW TRUE
    )
    FetchContent_MakeAvailable(fmt)
endif ()

add_subdirectory(src)
