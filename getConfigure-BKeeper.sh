#!/usr/bin/bash

module purge;
module load cuda/12.1 gcc/11.4.0  ucx/1.16.0 openmpi/4.1.5-ucx1.16-gcc mkl/2021.4.0 hdf5/1.14.1-2-gcc-ompi;
module list;

# Start of the script

prefix="/home/swan/swan127136/SwanSea/SourceCodes/external_lib/prefix_grid_202410"

../configure \
        --prefix=${prefix} \
        --with-grid=${prefix} \
        --enable-su2adj \
        --enable-su2fund \
        --enable-su3fund \
        --enable-sp4fund \
        --enable-su3tis \
        --disable-all \
        CXX="nvcc -std=c++17 -x cu"
