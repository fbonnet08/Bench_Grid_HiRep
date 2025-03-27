cmake_minimum_required(VERSION 3.30)
include(CMakePrintHelpers)


project(Bench_Grid_HiRep CUDA)

set(CMAKE_CUDA_STANDARD 17)

add_definitions(-DWINDOWS -DCUDA)

set(SOURCE_FILES
        include/dataDeviceManag.cuh
        include/Exception.cuh
        include/common.cuh
        include/GetPID.h
        include/common_krnl.cuh
        include/carte_mesh_3D.cuh
        include/cuAtomics.cuh
        include/timming.cuh
        include/get_deviceQuery_gpu.cuh
        include/get_systemQuery_cpu.cuh
        include/cmdLine.cuh
        include/resmap_Sizes.cuh
        include/common_Helpr_gpu.cuh
        include/deviceTools_gpu.cuh
        include/testing_unitTest.cuh
        utils/cmdLine.cu
        utils/deviceTools_gpu.cu
        utils/get_deviceQuery_gpu.cu
        utils/get_systemQuery_cpu.cu
        utils/timming.cu
        src/GetPID.cpp
        src/carte_mesh_3D.cu
        src/dataDeviceManag.cu
        src/resmap_Sizes.cu
        src/common_Helpr_gpu.cu
        src/common_krnl_gpu.cu
        test_codes/cpu/testing_ChronoTime.cpp
        test_codes/gpu/cuda/testing_unitTest.cu
        test_codes/cpu/testing_Network.cu
        test_codes/cpu/testing_Network.cuh
        global.cu
        global.cuh
)

add_executable(Bench_Grid_HiRep main.cu ${SOURCE_FILES} )


set_target_properties(Bench_Grid_HiRep PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
