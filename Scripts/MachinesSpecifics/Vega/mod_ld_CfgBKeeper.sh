#!/usr/bin/bash

set -eu

sourcecode_dir=${HOME}/SwanSea/SourceCodes

prefix=${sourcecode_dir}/external_lib/prefix_grid_202410

export PREFIX_HOME=$prefix
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PREFIX_HOME/lib

user_remote_home_dir=$(cd ~/; pwd -P)
SCRIPT_DIR="${user_remote_home_dir}"/SwanSea/SourceCodes/Bench_Grid_HiRep/Scripts/MachinesSpecifics/Vega

module purge;
module load CUDA/12.3.0 OpenMPI/4.1.5-GCC-12.3.0 UCX/1.15.0-GCCcore-12.3.0 GCC/12.3.0;
module load FFTW/3.3.10-GCC-12.3.0;
module list;

BKeeper_UCL_ARC_dir="${HOME}"/SwanSea/SourceCodes/BKeeper/

cd "${BKeeper_UCL_ARC_dir}"/build

ls -al

_core_count=$(grep -c ^processor /proc/cpuinfo)
#_use_core_count=$(( "${_core_count}" / 2 ))
_use_core_count=$(( "${_core_count}"))

echo "${_core_count}"
echo "${_use_core_count}"

#exit
#  --enable-su4fund \
#  --enable-sp4tis \
#  --enable-su3tis \
#  --enable-su2adj \
#  --enable-su2fund \
#  --enable-su3fund \
#  --enable-fermion-reps \

../configure \
  --prefix=${prefix} \
  --with-grid=${prefix} \
  --enable-su2adj \
  --enable-su2fund \
  --enable-su3fund \
  --disable-all \
  CXX="nvcc -std=c++17 -x cu"

# Bui;dong code tryoing to do it really fast
make -k -j "${_use_core_count}"

# Moving back home
cd "$SCRIPT_DIR"
ls -al
