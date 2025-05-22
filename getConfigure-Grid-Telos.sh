#!/usr/bin/bash
##########################
# MAresNostrum setup
##########################
module purge;
module load cuda/12.1 gcc/11.4.0  ucx/1.16.0 openmpi/4.1.5-ucx1.16-gcc mkl/2021.4.0 hdf5/1.14.1-2-gcc-ompi;
module list;

# Start of the script
prefix="/home/swan/swan127136/SwanSea/SourceCodes/external_lib/prefix_grid_202410"

../configure \
    --prefix=${prefix} \
    --enable-comms=mpi-auto \
    --enable-unified=no \
    --enable-shm=nvlink \
    --enable-accelerator=cuda \
    --enable-gen-simd-width=64 \
    --enable-simd=GPU \
    --enable-accelerator-cshift \
    --with-lime=${prefix} \
    --with-gmp=${prefix} \
    --with-mpfr=${prefix} \
    --disable-fermion-reps \
    --disable-gparity \
    --enable-Sp \
    CXX=nvcc \
    LDFLAGS="-cudart shared -lcublas" \
    CXXFLAGS="-ccbin mpicxx -gencode arch=compute_90,code=sm_90 -std=c++17 -cudart shared --diag-suppress 177,550,611"
