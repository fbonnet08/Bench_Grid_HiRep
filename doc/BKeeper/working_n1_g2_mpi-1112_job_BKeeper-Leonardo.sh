#!/bin/bash -l
#SBATCH --job-name=TEST-JOB            # Job name
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --time=00:30:00                # Run time (d-hh:mm:ss)
#SBATCH --partition=boost_usr_prod
#SBATCH --mem=494000
#SBATCH --nodes=1                      # Total number of nodes
#SBATCH --cpus-per-task=4
#SBATCH --ntasks-per-node=2
#SBATCH --gres=gpu:2
#SBATCH --gpus-per-node=2
#SBATCH --gpus-per-task=1
#SBATCH --account=EUHPC_B17_015
#-------------------------------------------------------------------------------
# Module loads and compiler version
#-------------------------------------------------------------------------------
module load cuda/12.2 nvhpc/23.11 fftw/3.3.10--openmpi--4.1.6--gcc--12.2.0 hdf5
module list;

ucx_info -v
nvcc --version
which mpirun
#-------------------------------------------------------------------------------
# Variable exports
#-------------------------------------------------------------------------------
# OpenMP
export OMP_NUM_THREADS=8
# MPI
export OMPI_MCA_btl=^uct,openib
export OMPI_MCA_pml=ucx
export OMPI_MCA_io=romio321
export OMPI_MCA_btl_openib_allow_ib=true
export OMPI_MCA_btl_openib_device_type=infiniband
export OMPI_MCA_btl_openib_if_exclude=mlx5_1,mlx5_2,mlx5_3
# UCX
export UCX_TLS=gdr_copy,rc,rc_x,sm,cuda_copy,cuda_ipc
export UCX_RNDV_THRESH=16384
export UCX_RNDV_SCHEME=put_zcopy
export UCX_IB_GPU_DIRECT_RDMA=yes
export UCX_MEMTYPE_CACHE=n
# GRID
export GRID_ALLOC_NCACHE_SMALL=16
export GRID_ALLOC_NCACHE_LARGE=2
export GRID_ALLOC_NCACHE_HUGE=0
#-------------------------------------------------------------------------------
# Path structure
#-------------------------------------------------------------------------------
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

export MY_CUDA_HOME=$CUDA_HOME
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MY_CUDA_HOME/lib64
#-------------------------------------------------------------------------------
# Launching mechanism
#-------------------------------------------------------------------------------
ls -al "${bkeeper_build_dir}"/BKeeper
ls -al "${benchmark_input_dir}"/BKeeper/input_BKeeper.xml
#-------------------------------------------------------------------------------
# The wrapper file
#-------------------------------------------------------------------------------
wrapper_script=${Bench_Grid_HiRep_dir}/doc/BKeeper/gpu-mpi-wrapper-new-Leonardo.sh
# run! #########################################################################
# --mca pml ucx
#   --mpi 1.2.2.4 \
mpirun -np $SLURM_NTASKS \
  --map-by numa \
  -x LD_LIBRARY_PATH \
  --bind-to none \
  "$wrapper_script" "${bkeeper_build_dir}"/BKeeper  \
  "${benchmark_input_dir}"/BKeeper/input_BKeeper.xml \
  --grid 32.32.32.64 \
  --mpi 1.1.1.2 \
  --accelerator-threads "$OMP_NUM_THREADS" \
  --shm 8192 \
  --device-mem 23000 \
  --log Error,Warning,Message
################################################################################
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo `date`;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  job_BKeeper-Leonardo.sh Done.                        -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
# srun --account=EUHPC_B17_015 --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:4 --pty bash
##SBATCH --ntasks-per-socket=4
##SBATCH --mem=494000
#export MPICH_GPU_SUPPORT_ENABLED=1
#export UCX_TLS=self,sm,rc,ud
#export OMPI_MCA_PML="ucx"
#export OMPI_MCA_osc="ucx"
#-------------------------------------------------------------------------------
