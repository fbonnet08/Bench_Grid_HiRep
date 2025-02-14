#!/bin/bash
#SBATCH --job-name=Run_BKeeper_run_gpu_lat24.24.24.32_nodes002_mpi01-04-02-01_small    # output files for the job
#SBATCH --output=%x.out          # %x.%j.out output file
#SBATCH --error=%x.err           # %x.%j.err error file
#SBATCH --time=01:00:00
#SBATCH --partition=gpu
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=4    # nodes * ntasks
## GPU only
#SBATCH --gpus-per-node=4
#SBATCH --account=dp208
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:4
#SBATCH --qos=standard
#-------------------------------------------------------------------------------
# Getting the common code setup and variables: 
#---> Accelerator type (cpu/gpu)             : gpu
#---> Simulation size in consideration       : small
#---> Machine name that we are working on is : tursa
#-------------------------------------------------------------------------------
#---> this is a Run_BKeeper_run_gpu_lat24.24.24.32_nodes002_mpi01-04-02-01_small job run
#-------------------------------------------------------------------------------
# Start of the batch body
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Module loads and compiler version
#-------------------------------------------------------------------------------
module load cuda/12.3 openmpi/4.1.5-cuda12.3 ucx/1.15.0-cuda12.3 gcc/9.3.0; module list;

# Check some versions
ucx_info -v
nvcc --version
which mpirun
#-------------------------------------------------------------------------------
# The path structure
#-------------------------------------------------------------------------------
machine_name="tursa"
sourcecode_dir=/home/dp208/dp208/dc-bonn2/SwanSea/SourceCodes
bkeeper_dir=/home/dp208/dp208/dc-bonn2/SwanSea/SourceCodes/BKeeper
bkeeper_build_dir=$bkeeper_dir/build
Bench_Grid_HiRep_dir=$sourcecode_dir/Bench_Grid_HiRep
benchmark_input_dir=/home/dp208/dp208/dc-bonn2/SwanSea/SourceCodes/Bench_Grid_HiRep/benchmarks
#Extending the library path
prefix=/home/dp208/dp208/dc-bonn2/SwanSea/SourceCodes/external_lib/prefix_grid_202410
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
# Wrapper scripts Getting the gpu select script
#-------------------------------------------------------------------------------
wrapper_script=${Bench_Grid_HiRep_dir}/doc/BKeeper/gpu-mpi-wrapper-new-Tursa.sh
chmod a+x ${wrapper_script}
#-------------------------------------------------------------------------------
# Output variable.
#-------------------------------------------------------------------------------
LatticeRuns_dir=/home/dp208/dp208/dc-bonn2/SwanSea/SourceCodes/LatticeRuns
path_to_run=/home/dp208/dp208/dc-bonn2/SwanSea/SourceCodes/LatticeRuns/BKeeper_run_gpu/small/Run_BKeeper_run_gpu_lat24.24.24.32_nodes002_mpi01-04-02-01_small
job_name=Run_BKeeper_run_gpu_lat24.24.24.32_nodes002_mpi01-04-02-01_small
#-------------------------------------------------------------------------------
# Launching mechanism
#-------------------------------------------------------------------------------
# run! #########################################################################
device_mem=23000
shm=8192
mpirun -np $SLURM_NTASKS \
  --map-by numa \
  -x LD_LIBRARY_PATH \
  --bind-to none \
  "$wrapper_script" "${bkeeper_build_dir}"/BKeeper  \
  "${benchmark_input_dir}"/BKeeper/input_BKeeper.xml \
  --grid 24.24.24.32 \
  --mpi 1.4.2.1 \
  --accelerator-threads "$OMP_NUM_THREADS" \
  --shm $shm \
  --device-mem $device_mem \
  --log Error,Warning,Message
################################################################################
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Finishing up
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo Wed Feb 12 15:09:24 GMT 2025;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "- /home/dp208/dp208/dc-bonn2/SwanSea/SourceCodes/LatticeRuns/BKeeper_run_gpu/small/Run_BKeeper_run_gpu_lat24.24.24.32_nodes002_mpi01-04-02-01_small/Run_BKeeper_run_gpu_lat24.24.24.32_nodes002_mpi01-04-02-01_small.sh Done. -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
# srun --account={account_name} --partition={partition} --time=00:30:00 --nodes=1 --gres=gpu:4 --pty bash
##SBATCH --ntasks-per-socket=4
##SBATCH --mem=494000
#export MPICH_GPU_SUPPORT_ENABLED=1
#export UCX_TLS=self,sm,rc,ud
#export OMPI_MCA_PML="ucx"
#export OMPI_MCA_osc="ucx"
#-------------------------------------------------------------------------------
