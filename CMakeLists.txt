cmake_minimum_required(VERSION 3.30)
project(Bench_Grid_HiRep CUDA)

set(CMAKE_CUDA_STANDARD 20)

add_executable(Bench_Grid_HiRep main.cu)

set_target_properties(Bench_Grid_HiRep PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)
