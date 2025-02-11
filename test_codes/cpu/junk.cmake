


set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -Xcompiler -fPIC --ptxas-options=-v")




find_path(CUFFT_INCLUDE_DIR cufft.h PATH_SUFFIXES include PATHS ${FIND_CUDA_PATHS} NO_CACHE)
find_path(CUFFTXT_INCLUDE_DIR cufftXt.h PATH_SUFFIXES include PATHS ${FIND_CUDA_PATHS})
find_path(GRID_INCLUDE_DIR Grid.h PATH_SUFFIXES Grid PATHS ${GRID_DIR})
cmake_print_variables(CUFFT_INCLUDE_DIR)
cmake_print_variables(CUFFTXT_INCLUDE_DIR)
cmake_print_variables(GRID_INCLUDE_DIR)



include_directories(${CUFFT_INCLUDE_DIR})




target_link_libraries(${PROJECT_NAME} LINK_PUBLIC ${CUFFT_LIBRARY} ${CUDA_LIBRARY} ${CUDART_LIBRARY} ${GRID_LIBRARY})




        include/Sockets.cuh
        include/Network.cuh
        include/Adapters.cuh
        src/Sockets.cu
        src/Network.cu
        src/Adapters.cu
        test_codes/cpu/system2-Linux.cpp




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





