



target_link_libraries(Grid_HiRep_Benchmarker LINK_PUBLIC ${GRID_LIBRARY})





-------------------------------------------------------------------


project(Grid_HiRep_Benchmarker)


project(./Grid_HiRep_Benchmarker/Grid_HiRep_Benchmarker)


find_library(GRID_LIBRARY NAMES Grid PATH_SUFFIXES build/Grid PATHS ${GRID_DIR})



set(GRID_DIR /mnt/c/cygwin64/home/frede/Swansea/SourceCodes/Grid-UCL-ARC/Grid/)
set(GRID_INCLUDE_DIR /mnt/c/cygwin64/home/frede/Swansea/SourceCodes/Grid-UCL-ARC/Grid//Grid)

include_directories(${GRID_DIR})
include_directories(${GRID_INCLUDE_DIR})


find_library(GRID_LIBRARY NAMES Grid PATHS ${GRID_DIR}/build)


cmake_print_variables(GRID_DIR)
cmake_print_variables(GRID_INCLUDE_DIR)
cmake_print_variables(GRID_LIBRARY)

target_link_libraries(${PROJECT_NAME} LINK_PUBLIC ${GRID_LIBRARY})

-------------------------------------------------------------------















set(CMAKE_CXX_STANDARD 17)



 -fPIC


        test_codes/cpu/moved_code/common_systemProg.cuh

        include(FindPkgConfig)
        find_package(cufft REQUIRED)
        find_package(cufftXt REQUIRED)

        -ccbin ${FIND_CUDA_PATHS}

        set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -ccbin ${FIND_CUFFT_PATHS}")


        find_library(CUFFTXT_LIBRARY NAMES cufftXt PATH_SUFFIXES lib/x64 PATHS ${FIND_CUFFT_PATHS})
        find_library(CUDART_LIBRARY NAMES cuda cudart PATH_SUFFIXES lib/x64 PATHS ${FIND_CUFFT_PATHS})


        ${CUFFTXT_LIBRARY} ${CUDART_LIBRARY}


        --ptxas-options=-v 3.5 -O3 -Xcompiler -fPIC

        NVCCFLAGS= --ptxas-options=-v $(PUSHMEM_GPU) -O3 -DADD_ -DBENCH -DCUDA \
        -DMAGMA -DGSL
        NVCCFLAGS+= -m${TARGET_SIZE} -D_FORCE_INLINES -ccbin=$(CXX) -Xcompiler \
        -fPIC $(COMMON_FLAGS)


