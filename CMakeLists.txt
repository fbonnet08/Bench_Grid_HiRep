cmake_minimum_required(VERSION 3.30)

set(FIND_CUDA_PATHS C:/Program Files/NVIDIA\ GPU\ Computing\ Toolkit/CUDA/v12.2)
set(FIND_CUDA_BIN_PATHS C:/Program\ Files/NVIDIA\ GPU\ Computing\ Toolkit/CUDA/v12.2/bin/)
set(CUFFT_INCLUDE_DIR C:/Program\ Files/NVIDIA\ GPU\ Computing\ Toolkit/CUDA/v12.2/include)

set(CMAKE_CUDA_HOST_COMPILER "${FIND_CUDA_BIN_PATHS}")
set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -Xcompiler -fPIC --ptxas-options=-v")

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



find_path(CUFFT_INCLUDE_DIR cufft.h PATH_SUFFIXES include PATHS ${FIND_CUDA_PATHS} NO_CACHE)
find_path(CUFFTXT_INCLUDE_DIR cufftXt.h PATH_SUFFIXES include PATHS ${FIND_CUFFTXT_PATHS})

find_library(CUFFT_LIBRARY NAMES cufft PATH_SUFFIXES lib/x64 PATHS ${FIND_CUDA_PATHS})
find_library(CUDA_LIBRARY NAMES cuda PATH_SUFFIXES lib/x64 PATHS ${FIND_CUDA_PATHS})
find_library(CUDART_LIBRARY NAMES cuda cudart PATH_SUFFIXES lib/x64 PATHS ${FIND_CUDA_PATHS})

include_directories(${CUFFT_INCLUDE_DIR})
target_link_libraries(${PROJECT_NAME} LINK_PUBLIC ${CUFFT_LIBRARY} ${CUDA_LIBRARY} ${CUDART_LIBRARY})




set_target_properties(Bench_Grid_HiRep PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
