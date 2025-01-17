#!/usr/bin/bash

set -eu

basedir=${HOME}/grid_test_202410
prefix=${HOME}/prefix_grid_202410

mkdir ${basedir}
mkdir ${prefix}

module load cuda/12.3  openmpi/4.1.5-cuda12.3  ucx/1.15.0-cuda12.3 gcc/9.3.0

cd ${basedir}
wget http://usqcd-software.github.io/downloads/c-lime/lime-1.3.2.tar.gz
tar xzf lime-1.3.2.tar.gz
cd lime-1.3.2
./configure --prefix=${prefix}
make -j16 all install

sleep 2

cd ${basedir}
wget https://gmplib.org/download/gmp/gmp-6.3.0.tar.xz
tar xf gmp-6.3.0.tar.xz
cd gmp-6.3.0
./configure --prefix=${prefix}
make -j16
make all install

sleep 2

cd ${basedir}
wget https://www.mpfr.org/mpfr-current/mpfr-4.2.1.tar.gz
tar xvzf mpfr-4.2.1.tar.gz
cd mpfr-4.2.1
./configure --prefix=${prefix} --with-gmp=${prefix}
make -j16
make all install

sleep 2

cd ${basedir}
git clone https://paboyle@github.com/paboyle/Grid
cd Grid
git checkout 557fa48
./bootstrap.sh

mkdir build
cd build



../configure \
	--prefix=${prefix} \
	--enable-comms=mpi \
	--enable-simd=GPU \
	--enable-shm=nvlink \
	--enable-accelerator=cuda \
	--enable-gen-simd-width=64 \
	--disable-gparity \
	--disable-zmobius \
	--disable-fermion-reps \
	--enable-Sp \
	--enable-Nc=4 \
	--with-lime=${prefix} \
	--with-gmp=${prefix} \
	--with-mpfr=${prefix} \
	--disable-unified \
	CXX=nvcc \
	LDFLAGS="-cudart shared -lcublas " \
	CXXFLAGS="-ccbin mpicxx -gencode arch=compute_80,code=sm_80 -std=c++17 -cudart shared --diag-suppress 177,550,611"


make -j32
