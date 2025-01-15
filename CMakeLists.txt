cmake_minimum_required(VERSION 3.30)
project(Bench_Grid_HiRep CUDA)

set(CMAKE_CUDA_STANDARD 14)

add_executable(Bench_Grid_HiRep main.cu
        include/insert_include_files_here.hpp)

set_target_properties(Bench_Grid_HiRep PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)
