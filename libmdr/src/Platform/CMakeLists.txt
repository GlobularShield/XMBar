cmake_minimum_required(VERSION 3.31)

file(GLOB INCLUDES "${CMAKE_CURRENT_SOURCE_DIR}/*.hpp")
add_library(mdr_Platform INTERFACE ${INCLUDES})

# XMBar only targets macOS.
add_subdirectory(MacOS)
target_link_libraries(mdr_Platform INTERFACE mdr_PlatformMacOS)
