# Set the minimum required version of CMake
cmake_minimum_required(VERSION 3.12...3.29)

# CMake called variable
option(SC_LOAD_LIBRARY_SRC "Use source code to build dependent libraries instead of precompiled libraries" OFF)

set(SC_PROJECT_BUILD_ONLY "" CACHE STRING "A semi-colon delimited list of the projects to build")

get_filename_component(SC_PROJECT_NATIVE_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/src" ABSOLUTE)

# Set project name
project(ScProjects LANGUAGES CXX)

# Set up C++
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set the name of the predefined target folder
set_property(GLOBAL PROPERTY PREDEFINED_TARGETS_FOLDER "Built-In")

# Set CMake module path
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

# Import CMake script
include(projects_ide)
include(projects_initialize)
include(projects_detect_platform)
include(projects_utilities)
include(projects)
