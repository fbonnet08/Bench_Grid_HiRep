

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


