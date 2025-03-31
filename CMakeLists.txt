cmake_minimum_required(VERSION 3.25)
include(CMakePrintHelpers)

project(${CMAKE_SOURCE_DIR}/Grid_HiRep_Benchmarker)

set(CMAKE_CXX_STANDARD 17)

set(SOURCE_FILES
        ${CMAKE_SOURCE_DIR}/Grid_HiRep_Benchmarker/utils/cmd_Line.cpp
        ${CMAKE_SOURCE_DIR}/Grid_HiRep_Benchmarker/src/global_app.cpp
        ${CMAKE_SOURCE_DIR}/Grid_HiRep_Benchmarker/src/common_Helpr_cpu.cpp
        ${CMAKE_SOURCE_DIR}/Grid_HiRep_Benchmarker/utils/get_systemQuery_cpu.cpp
        ${CMAKE_SOURCE_DIR}/Grid_HiRep_Benchmarker/test_codes/gpu/testing_unitTest.cpp
        ${CMAKE_SOURCE_DIR}/Grid_HiRep_Benchmarker/src/Bencher_Grid.cpp
)

add_executable(Grid_HiRep_Benchmarker.cpp ${SOURCE_FILES} )

set(GRID_DIR /mnt/c/cygwin64/home/frede/Swansea/SourceCodes/Grid-UCL-ARC/Grid)
set(GRID_INCLUDE_DIR ${GRID_DIR}/Grid)
set(GRID_INCLUDE_OTHERS_DIR ${GRID_DIR}/build/Grid)

include_directories(${GRID_DIR} ${GRID_INCLUDE_DIR} ${GRID_INCLUDE_OTHERS_DIR} )

# Debug info
message(STATUS "Looking for Grid library in: ${GRID_DIR}/build/Grid")

find_library(GRID_LIBRARY NAMES Grid PATHS ${GRID_DIR}/build/Grid NO_DEFAULT_PATH)

cmake_print_variables(GRID_DIR)
cmake_print_variables(GRID_INCLUDE_DIR)
cmake_print_variables(GRID_INCLUDE_OTHERS_DIR)
cmake_print_variables(GRID_LIBRARY)

if(NOT GRID_LIBRARY)
    message(FATAL_ERROR "Grid library not found! Check build path.")
endif()


