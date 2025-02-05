#!/usr/bin/env bash
#SBATCH --job-name=TEST-JOB            # Job name
#SBATCH --output=log/%x.%j.out
#SBATCH --error=log/%x.%j.err
#SBATCH --time=01:00:00                # Run time (d-hh:mm:ss) 1-12:00:00
#SBATCH --partition=gpu
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=4
#SBATCH --gpus-per-node=4              # Allocate one gpu per MPI rank
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:4
#-------------------------------------------------------------------------------
# Module loads and compiler version
#-------------------------------------------------------------------------------
module purge;
module load CUDA/12.3.0 OpenMPI/4.1.5-GCC-12.3.0 UCX/1.15.0-GCCcore-12.3.0 GCC/12.3.0;
module load FFTW/3.3.10-GCC-12.3.0;
module list;

# Check some versions
ucx_info -v
nvcc --version
which mpirun
#-------------------------------------------------------------------------------
# Path structure
#-------------------------------------------------------------------------------
sourcecode_dir=${HOME}/SwanSea/SourceCodes
bkeeper_dir=${sourcecode_dir}/BKeeper
bkeeper_build_dir=${bkeeper_dir}/build
Bench_Grid_HiRep_dir=${sourcecode_dir}/Bench_Grid_HiRep
benchmark_input_dir=${Bench_Grid_HiRep_dir}/benchmarks
#Extending the library path
prefix=${sourcecode_dir}/external_lib/prefix_grid_202410
#-------------------------------------------------------------------------------
# Export path and library paths
#-------------------------------------------------------------------------------
#Extending the library path
export PREFIX_HOME=$prefix
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PREFIX_HOME/lib

echo "$LD_LIBRARY_PATH"

ls -al "$PREFIX_HOME/lib"
#-------------------------------------------------------------------------------
# Probing the file systems and getting some info
#-------------------------------------------------------------------------------
ls -al "${bkeeper_build_dir}"/BKeeper
ls -al "${benchmark_input_dir}"/BKeeper/input_BKeeper.xml
#-------------------------------------------------------------------------------
# Variable exports
#-------------------------------------------------------------------------------
# OpenMP
export OMP_NUM_THREADS=8
# MPI
#export OMPI_MCA_btl=^uct,openib
#export OMPI_MCA_pml=ucx
#export OMPI_MCA_osc="ucx".
#export OMPI_MCA_io=romio321
#export OMPI_MCA_btl_openib_allow_ib=true
#export OMPI_MCA_btl_openib_device_type=infiniband
#export OMPI_MCA_btl_openib_if_exclude=mlx5_1,mlx5_2,mlx5_3
export OMPI_MCA_PML="ucx"
export OMPI_MCA_osc="ucx"
# UCX
export UCX_TLS=self,sm,rc,ud
#export UCX_TLS=gdr_copy,rc,rc_x,sm,cuda_copy,cuda_ipc
#export UCX_RNDV_THRESH=16384
#export UCX_RNDV_SCHEME=put_zcopy
#export UCX_IB_GPU_DIRECT_RDMA=yes
#export UCX_MEMTYPE_CACHE=n
# GRID
export GRID_ALLOC_NCACHE_SMALL=16
export GRID_ALLOC_NCACHE_LARGE=2
export GRID_ALLOC_NCACHE_HUGE=0
#-------------------------------------------------------------------------------
# Wrapper scripts Getting the gpu select script
#-------------------------------------------------------------------------------
wrapper_script=${Bench_Grid_HiRep_dir}/doc/BKeeper/gpu-mpi-wrapper-new-Vega.sh
#-------------------------------------------------------------------------------
# Launching mechanism
#-------------------------------------------------------------------------------
# run! #########################################################################
# --mca pml ucx
device_mem=23000
shm=8192
mpirun -np $SLURM_NTASKS \
 --map-by numa \
 -x LD_LIBRARY_PATH \
 --bind-to none \
 "$wrapper_script" "${bkeeper_build_dir}"/BKeeper  \
 "${benchmark_input_dir}"/BKeeper/input_BKeeper.xml \
 --grid 48.48.48.96 \
 --mpi 1.2.2.4 \
 --accelerator-threads "$OMP_NUM_THREADS" \
 --shm $shm \
 --device-mem $device_mem \
 --log Error,Warning,Message
################################################################################
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo `date`;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  job_BKeeper-Vega.sh Done.                            -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
# srun --partition=gpu --time=00:30:00 --nodes=1 --gres=gpu:4 --pty bash
#-------------------------------------------------------------------------------
