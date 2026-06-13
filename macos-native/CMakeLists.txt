cmake_minimum_required(VERSION 3.31)
project(XMBar LANGUAGES C CXX Swift)

if (NOT APPLE)
    message(FATAL_ERROR "XMBar is only available on macOS")
endif ()

set(MDR_ROOT "" CACHE PATH "Path to the root of the MDR native library checkout; it must contain mdr-c/Base.h")
set(FMT_ROOT "" CACHE PATH "Path to fmt headers/libs; it must contain fmt/format.h")
set(MDR_SOURCE_ROOT "" CACHE PATH "Path to libmdr source root; optional, used when it contains CMakeLists.txt")
set(MDR_LIB_DIR "" CACHE PATH "Path to a directory that contains libmdr.a or libmdr.dylib")
set(FMT_LIB_DIR "" CACHE PATH "Path to a directory that contains libfmt.a or libfmt.dylib")
set(MDR_PLATFORM_LIBRARY "" CACHE FILEPATH "Optional exact path to the macOS mdr platform library/archive that defines mdrConnectionMacOSCreate")
if (NOT CMAKE_OSX_DEPLOYMENT_TARGET)
    set(CMAKE_OSX_DEPLOYMENT_TARGET "26.0" CACHE STRING "Minimum macOS version for XMBar" FORCE)
endif ()
set(MACOSX_DEPLOYMENT_TARGET "${CMAKE_OSX_DEPLOYMENT_TARGET}")

set(_MDR_INCLUDE_CANDIDATES
    "${MDR_ROOT}"
    "${MDR_ROOT}/include"
    "${CMAKE_CURRENT_SOURCE_DIR}"
    "${CMAKE_CURRENT_SOURCE_DIR}/.."
    "${CMAKE_CURRENT_SOURCE_DIR}/../libmdr/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/../.."
    "/opt/homebrew/include"
    "/usr/local/include"
)

find_path(MDR_C_INCLUDE_DIR
    NAMES mdr-c/Base.h
    PATHS ${_MDR_INCLUDE_CANDIDATES}
    NO_DEFAULT_PATH
)

set(_MDR_LIBRARY_CANDIDATES
    "${MDR_ROOT}"
    "${MDR_ROOT}/.."
    "${MDR_ROOT}/../.."
    "${MDR_ROOT}/build"
    "${MDR_ROOT}/build/Release"
    "${MDR_ROOT}/build/ninja-Release"
    "${MDR_ROOT}/lib"
    "${MDR_ROOT}/.build"
    "${MDR_LIB_DIR}"
)

if (MDR_C_INCLUDE_DIR)
    list(APPEND _MDR_LIBRARY_CANDIDATES
        "${MDR_C_INCLUDE_DIR}"
        "${MDR_C_INCLUDE_DIR}/.."
        "${MDR_C_INCLUDE_DIR}/../build"
        "${MDR_C_INCLUDE_DIR}/../build/Release"
        "${MDR_C_INCLUDE_DIR}/../build/ninja-Release"
        "${MDR_C_INCLUDE_DIR}/../lib"
        "${MDR_C_INCLUDE_DIR}/../.build"
    )
endif ()

if (NOT MDR_C_INCLUDE_DIR)
    message(FATAL_ERROR
        "No encontré mdr-c/Base.h. XMBar necesita la librería nativa mdr-c.
"
        "Solución: compila desde el repo completo que contiene la carpeta mdr-c, "
        "o ejecuta: ./build_app.sh --mdr-root /ruta/al/repo-que-contiene-mdr-c
"
        "También puedes usar: MDR_ROOT=/ruta/al/repo-que-contiene-mdr-c ./build_app.sh"
    )
endif ()


if (TARGET fmt::fmt)
    message(STATUS "Usando fmt desde el target del repo: fmt::fmt")
    set(FMT_LIBRARY fmt::fmt)
else ()
    # libmdr usa fmt. En muchas instalaciones viene por Homebrew (brew install fmt)
    # o como dependencia vendorizada del repo original.
    set(_FMT_INCLUDE_CANDIDATES
        "${FMT_ROOT}"
        "${FMT_ROOT}/include"
        "${MDR_ROOT}"
        "${MDR_ROOT}/include"
        "${MDR_ROOT}/../include"
        "${MDR_ROOT}/../third_party/fmt/include"
        "${MDR_ROOT}/../../third_party/fmt/include"
        "${MDR_ROOT}/../external/fmt/include"
        "${MDR_ROOT}/../../external/fmt/include"
        "${CMAKE_CURRENT_SOURCE_DIR}/third_party/fmt/include"
        "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/fmt/include"
        "/opt/homebrew/include"
        "/usr/local/include"
    )

    find_path(FMT_INCLUDE_DIR
        NAMES fmt/format.h
        HINTS ${_FMT_INCLUDE_CANDIDATES}
    )

    if (NOT FMT_INCLUDE_DIR)
        message(FATAL_ERROR
            "No encontré fmt/format.h, que es dependencia de libmdr.\n"
            "Solución rápida: brew install fmt\n"
            "O indica la ruta: ./build_app.sh --fmt-root /ruta/que/contiene/fmt\n"
            "También sirve: FMT_ROOT=/ruta/que/contiene/fmt ./build_app.sh"
        )
    endif ()

    set(_FMT_LIBRARY_CANDIDATES
        "${FMT_LIB_DIR}"
        "${FMT_ROOT}"
        "${FMT_ROOT}/lib"
        "${FMT_INCLUDE_DIR}/../lib"
        "/opt/homebrew/lib"
        "/usr/local/lib"
    )
    find_library(FMT_LIBRARY
        NAMES fmt libfmt
        HINTS ${_FMT_LIBRARY_CANDIDATES}
    )
    if (FMT_LIBRARY)
        message(STATUS "Usando fmt library: ${FMT_LIBRARY}")
    else ()
        message(FATAL_ERROR
            "Encontré fmt/format.h en ${FMT_INCLUDE_DIR}, pero no encontré libfmt.a/libfmt.dylib.
"
            "Solución: brew install fmt, o indica la carpeta de la librería con --fmt-lib-dir /ruta/que/contiene/libfmt.a"
        )
    endif ()
endif ()

add_library(MDRNativeBridge STATIC
    MDRNativeBridge.cpp
    MDRNativeBridge.h
)
target_compile_features(MDRNativeBridge PRIVATE cxx_std_20)
target_include_directories(MDRNativeBridge PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}"
    "${MDR_C_INCLUDE_DIR}"
)
if (FMT_INCLUDE_DIR)
    target_include_directories(MDRNativeBridge PUBLIC "${FMT_INCLUDE_DIR}")
endif ()
# Cuando XMBar se compila desde la raiz del repo, libmdr ya existe como target.
# Solo buscamos librerias externas en builds standalone.
if (TARGET mdr)
    set(_MDR_LINK_LIBS mdr)
elseif (TARGET libmdr)
    set(_MDR_LINK_LIBS libmdr)
else ()
    find_library(MDR_LIBRARY
        NAMES mdr libmdr
        HINTS
            ${_MDR_LIBRARY_CANDIDATES}
            "${CMAKE_CURRENT_SOURCE_DIR}/../build"
            "${CMAKE_CURRENT_SOURCE_DIR}/../build/Release"
            "/opt/homebrew/lib"
            "/usr/local/lib"
    )

    if (MDR_LIBRARY)
        message(STATUS "Usando libmdr: ${MDR_LIBRARY}")
        set(_MDR_LINK_LIBS "${MDR_LIBRARY}")
    else ()
    # Solo si no hay libmdr.a/libmdr.dylib, intenta añadir/compilar libmdr desde fuente.
        set(_MDR_SOURCE_CANDIDATES
            "${MDR_SOURCE_ROOT}"
            "${MDR_ROOT}"
            "${MDR_ROOT}/.."
            "${MDR_ROOT}/../.."
            "${CMAKE_CURRENT_SOURCE_DIR}/../libmdr"
            "${MDR_C_INCLUDE_DIR}/.."
            "${MDR_C_INCLUDE_DIR}/../.."
        )
        foreach (_candidate IN LISTS _MDR_SOURCE_CANDIDATES)
            if (_candidate AND EXISTS "${_candidate}/CMakeLists.txt")
                get_filename_component(_candidate_abs "${_candidate}" ABSOLUTE)
                if (NOT _candidate_abs STREQUAL CMAKE_CURRENT_SOURCE_DIR)
                    message(STATUS "Intentando compilar libmdr desde ${_candidate_abs}")
                    add_subdirectory("${_candidate_abs}" "${CMAKE_BINARY_DIR}/libmdr-build" EXCLUDE_FROM_ALL)
                    break()
                endif ()
            endif ()
        endforeach ()

        if (TARGET mdr)
            set(_MDR_LINK_LIBS mdr)
        elseif (TARGET libmdr)
            set(_MDR_LINK_LIBS libmdr)
        else ()
            message(FATAL_ERROR
                "Encontré los headers de mdr-c en ${MDR_C_INCLUDE_DIR}, pero no encontré libmdr.a/libmdr.dylib ni pude añadir libmdr como subproyecto.\n"
                "Soluciones:\n"
                "  1) Indica la carpeta con la librería: ./build_app.sh --mdr-lib-dir /ruta/que/contiene/libmdr.a\n"
                "  2) Indica la fuente de libmdr: ./build_app.sh --mdr-source-root /ruta/al/repo/libmdr"
            )
        endif ()
    endif ()
endif ()


# libmdr depende de fmt y la conexión macOS puede vivir en otra archive/library.
if (MDR_PLATFORM_LIBRARY)
    if (EXISTS "${MDR_PLATFORM_LIBRARY}")
        message(STATUS "Usando plataforma mdr macOS: ${MDR_PLATFORM_LIBRARY}")
        list(APPEND _MDR_LINK_LIBS "${MDR_PLATFORM_LIBRARY}")
    else ()
        message(FATAL_ERROR "MDR_PLATFORM_LIBRARY apunta a un archivo que no existe: ${MDR_PLATFORM_LIBRARY}")
    endif ()
endif ()

# fmt debe ir después de libmdr en el linkado porque libmdr.a referencia símbolos fmt::v12::*.
list(APPEND _MDR_LINK_LIBS "${FMT_LIBRARY}")
target_link_libraries(MDRNativeBridge PUBLIC ${_MDR_LINK_LIBS})

find_library(APPKIT_FRAMEWORK AppKit REQUIRED)
find_library(FOUNDATION_FRAMEWORK Foundation REQUIRED)
find_library(IOBLUETOOTH_FRAMEWORK IOBluetooth REQUIRED)
find_library(SERVICEMANAGEMENT_FRAMEWORK ServiceManagement REQUIRED)

set_source_files_properties(Resources/AppIcon.icns PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")

add_executable(XMBar MACOSX_BUNDLE
    Sources/XMBar/main.swift
    Resources/AppIcon.icns
)

target_link_libraries(XMBar PRIVATE
    MDRNativeBridge
    ${APPKIT_FRAMEWORK}
    ${FOUNDATION_FRAMEWORK}
    ${IOBLUETOOTH_FRAMEWORK}
    ${SERVICEMANAGEMENT_FRAMEWORK}
)

set_target_properties(XMBar PROPERTIES
    OUTPUT_NAME "XMBar"
    MACOSX_BUNDLE_BUNDLE_NAME "XMBar"
    MACOSX_BUNDLE_GUI_IDENTIFIER "com.globular.xmbar"
    MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/Info.plist"
    MACOSX_DEPLOYMENT_TARGET "${CMAKE_OSX_DEPLOYMENT_TARGET}"
    Swift_LANGUAGE_VERSION 5
)
