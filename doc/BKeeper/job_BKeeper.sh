#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2050,SC2170

## This set of slurm settings assumes that the AMD chips are using bios setting NPS4 (4 mpi taks per socket).

#SBATCH -J TESTJOB
#SBATCH -A dp208
#SBATCH -t 1:00:00
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=8
#SBATCH --partition=gpu
#SBATCH --gres=gpu:4
#SBATCH --output=log/%x.%j.out
#SBATCH --error=log/%x.%j.err
#SBATCH --qos=standard
#SBATCH --no-requeue

set -e
# Set up ENV
module load gcc/9.3.0
module load cuda/11.4.1
module load openmpi/4.1.1-cuda11.4.1
source /home/y07/shared/grid/env/production/env-base.sh
source /home/y07/shared/grid/env/production/env-gpu.sh

# check some versions
ucx_info -v
nvcc --version
which mpirun

export OMP_NUM_THREADS=8
export OMPI_MCA_btl=^uct,openib
export OMPI_MCA_pml=ucx 
export UCX_TLS=gdr_copy,rc,rc_x,sm,cuda_copy,cuda_ipc
export UCX_RNDV_THRESH=16384
export UCX_RNDV_SCHEME=put_zcopy
export UCX_IB_GPU_DIRECT_RDMA=yes
export UCX_MEMTYPE_CACHE=n

export OMPI_MCA_io=romio321
export OMPI_MCA_btl_openib_allow_ib=true
export OMPI_MCA_btl_openib_device_type=infiniband
export OMPI_MCA_btl_openib_if_exclude=mlx5_1,mlx5_2,mlx5_3

export GRID_ALLOC_NCACHE_SMALL=16
export GRID_ALLOC_NCACHE_LARGE=2
export GRID_ALLOC_NCACHE_HUGE=0

sourcecode_dir=${HOME}/SwanSea/SourceCodes
bkeeper_dir=${sourcecode_dir}/BKeeper
bkeeper_build_dir=${bkeeper_dir}/build
Bench_Grid_HiRep_dir=${sourcecode_dir}/Bench_Grid_HiRep
benchmark_input_dir=${Bench_Grid_HiRep_dir}/benchmarks
#-------------------------------------------------------------------------------
# Path structure
#-------------------------------------------------------------------------------
prefix=${sourcecode_dir}/prefix_grid_202410
#-------------------------------------------------------------------------------
# Export path and library paths
#-------------------------------------------------------------------------------
#Extending the library path
export PREFIX_HOME=$prefix
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PREFIX_HOME/lib
#-------------------------------------------------------------------------------
# Launching mechanism
#-------------------------------------------------------------------------------
wrapper_script=gpu-mpi-wrapper-new.sh
# run! #########################################################################
mpirun -np $SLURM_NTASKS \
 --map-by numa \
 -x LD_LIBRARY_PATH \
 --bind-to none \
 $wrapper_script "${bkeeper_build_dir}"/BKeeper  \
 "${benchmark_input_dir}"/BKeeper/input_BKeeper.xml \
 --grid 48.48.48.96 \
 --mpi 1.2.2.4 \
 --accelerator-threads 8 \
 --shm 8192 \
 --device-mem 23000 \
 --log Error,Warning,Message
################################################################################
