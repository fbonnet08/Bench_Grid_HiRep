#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2050,SC2170
## This set of slurm settings assumes that the AMD chips are using bios setting NPS4 (4 mpi taks per socket).
###SBATCH --qos=standard
####SBATCH -A eufredericb

# srun --account=project_465001614 --partition=dev-g --time=00:30:00 --nodes=1 --gres=gpu:8 --pty bash

# --------------------------------------------------------------------
#!/bin/bash -l
#SBATCH --job-name=examplejob   # Job name
#SBATCH --output=examplejob.o%j # Name of stdout output file
#SBATCH --error=examplejob.e%j  # Name of stderr error file
#SBATCH --partition=standard-g  # partition name
#SBATCH --nodes=2               # Total number of nodes
#SBATCH --ntasks-per-node=8     # 8 MPI ranks per node, 16 total (2x8)
#SBATCH --gpus-per-node=8       # Allocate one gpu per MPI rank
#SBATCH --time=1-12:00:00       # Run time (d-hh:mm:ss)
#SBATCH --account=project_<id>  # Project for billing

cat << EOF > select_gpu
#!/bin/bash

export ROCR_VISIBLE_DEVICES=\$SLURM_LOCALID
exec \$*
EOF

chmod +x ./select_gpu

CPU_BIND="mask_cpu:7e000000000000,7e00000000000000"
CPU_BIND="${CPU_BIND},7e0000,7e000000"
CPU_BIND="${CPU_BIND},7e,7e00"
CPU_BIND="${CPU_BIND},7e00000000,7e0000000000"

export OMP_NUM_THREADS=6
export MPICH_GPU_SUPPORT_ENABLED=1

srun --cpu-bind=${CPU_BIND} ./select_gpu <executable> <args>
rm -rf ./select_gpu
# --------------------------------------------------------------------


#SBATCH --account=
#SBATCH -J TESTJOB
#SBATCH -t 1:00:00
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=8
#SBATCH --partition=gpu
#SBATCH --gres=gpu:4
#SBATCH --output=log/%x.%j.out
#SBATCH --error=log/%x.%j.err
#SBATCH --no-requeue

set -e
# Set up ENV
#module purge;
#module load CUDA/12.3.0 OpenMPI/4.1.5-GCC-12.3.0 UCX/1.15.0-GCCcore-12.3.0 GCC/12.3.0;
#module load FFTW/3.3.10-GCC-12.3.0;
module load cray-mpich cray-fftw
module list;

#source /home/y07/shared/grid/env/production/env-base.sh
#source /home/y07/shared/grid/env/production/env-gpu.sh

# check some versions
#ucx_info -v
hipcc --version
#which mpirun

export OMP_NUM_THREADS=8
#export OMPI_MCA_btl=^uct,openib
#export OMPI_MCA_pml=ucx

#export OMPI_MCA_osc="ucx".

#export UCX_TLS=gdr_copy,rc,rc_x,sm,cuda_copy,cuda_ipc
#export UCX_RNDV_THRESH=16384
#export UCX_RNDV_SCHEME=put_zcopy
#export UCX_IB_GPU_DIRECT_RDMA=yes
#export UCX_MEMTYPE_CACHE=n

#export OMPI_MCA_io=romio321
#export OMPI_MCA_btl_openib_allow_ib=true
#export OMPI_MCA_btl_openib_device_type=infiniband
#export OMPI_MCA_btl_openib_if_exclude=mlx5_1,mlx5_2,mlx5_3

export UCX_TLS=self,sm,rc,ud
export OMPI_MCA_PML="ucx"
export OMPI_MCA_osc="ucx"

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
prefix=${sourcecode_dir}/external_lib/prefix_grid_202410
#-------------------------------------------------------------------------------
# Export path and library paths
#-------------------------------------------------------------------------------
#Extending the library path
export PREFIX_HOME=$prefix
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PREFIX_HOME/lib
#-------------------------------------------------------------------------------
# Launching mechanism
#-------------------------------------------------------------------------------
wrapper_script=${Bench_Grid_HiRep_dir}/doc/BKeeper/gpu-mpi-wrapper-new-Lumi.sh
# run! #########################################################################
# --mca pml ucx
srun \
  "$wrapper_script" "${bkeeper_build_dir}"/BKeeper  \
  "${benchmark_input_dir}"/BKeeper/input_BKeeper.xml \
  --grid 48.48.48.96 \
  --mpi 1.2.2.4 \
  --accelerator-threads 8 \
  --shm 8192 \
  --device-mem 23000 \
  --log Error,Warning,Message
################################################################################
