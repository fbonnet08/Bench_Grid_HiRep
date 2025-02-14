#!/bin/bash
#SBATCH --job-name=Run_BKeeper_run_gpu_lat24.24.24.32_nodes002_mpi04-01-02-02_small    # output files for the job
#SBATCH --output=%x.out          # %x.%j.out output file
#SBATCH --error=%x.err           # %x.%j.err error file
#SBATCH --time=01:00:00
#SBATCH --partition=standard-g
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=8    # nodes * ntasks
## GPU only
#SBATCH --gpus-per-node=8
#SBATCH --account=project_465001614
#-------------------------------------------------------------------------------
# Getting the common code setup and variables: 
#---> Accelerator type (cpu/gpu)             : gpu
#---> Simulation size in consideration       : small
#---> Machine name that we are working on is : lumi
#-------------------------------------------------------------------------------
#---> this is a Run_BKeeper_run_gpu_lat24.24.24.32_nodes002_mpi04-01-02-02_small job run
#-------------------------------------------------------------------------------
# Start of the batch body
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Module loads and compiler version
#-------------------------------------------------------------------------------
module load cray-mpich cray-fftw; module list;

# Check some versions
#ucx_info -v
hipcc --version
#which mpirun
#-------------------------------------------------------------------------------
# The path structure
#-------------------------------------------------------------------------------
machine_name="lumi"
sourcecode_dir=/users/bonnetfr/SwanSea/SourceCodes
bkeeper_dir=/users/bonnetfr/SwanSea/SourceCodes/BKeeper
bkeeper_build_dir=$bkeeper_dir/build
Bench_Grid_HiRep_dir=$sourcecode_dir/Bench_Grid_HiRep
benchmark_input_dir=/users/bonnetfr/SwanSea/SourceCodes/Bench_Grid_HiRep/benchmarks
#Extending the library path
prefix=/users/bonnetfr/SwanSea/SourceCodes/external_lib/prefix_grid_202410
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
export MPICH_GPU_SUPPORT_ENABLED=1
export OMPI_MCA_PML="ucx"
export OMPI_MCA_osc="ucx"
# UCX
export UCX_TLS=self,sm,rc,ud
# GRID
export GRID_ALLOC_NCACHE_SMALL=16
export GRID_ALLOC_NCACHE_LARGE=2
export GRID_ALLOC_NCACHE_HUGE=0
#-------------------------------------------------------------------------------
# Wrapper scripts Getting the gpu select script
#-------------------------------------------------------------------------------
#wrapper_script=/users/bonnetfr/SwanSea/SourceCodes/Bench_Grid_HiRep/doc/BKeeper/gpu-mpi-wrapper-new-Lumi.sh
CPU_BIND="mask_cpu:7e000000000000,7e00000000000000"
CPU_BIND="${CPU_BIND},7e0000,7e000000"
CPU_BIND="${CPU_BIND},7e,7e00"
CPU_BIND="${CPU_BIND},7e00000000,7e0000000000"

cat << EOF > select_gpu
#!/bin/bash

export ROCR_VISIBLE_DEVICES=\$SLURM_LOCALID
exec \$*
EOF

chmod +x ./select_gpu
#-------------------------------------------------------------------------------
# Output variable.
#-------------------------------------------------------------------------------
LatticeRuns_dir=/users/bonnetfr/SwanSea/SourceCodes/LatticeRuns
path_to_run=/users/bonnetfr/SwanSea/SourceCodes/LatticeRuns/BKeeper_run_gpu/small/Run_BKeeper_run_gpu_lat24.24.24.32_nodes002_mpi04-01-02-02_small
job_name=Run_BKeeper_run_gpu_lat24.24.24.32_nodes002_mpi04-01-02-02_small
#-------------------------------------------------------------------------------
# Launching mechanism
#-------------------------------------------------------------------------------
# run! #########################################################################
device_mem=23000
shm=8192
srun --cpu-bind=${CPU_BIND} \
  ./select_gpu "${bkeeper_build_dir}"/BKeeper  \
  "${benchmark_input_dir}"/BKeeper/input_BKeeper.xml \
  --grid 24.24.24.32 \
  --mpi 4.1.2.2 \
  --accelerator-threads "$OMP_NUM_THREADS" \
  --shm $shm \
  --device-mem $device_mem \
  --log Error,Warning,Message
################################################################################
#rm -rf ./select_gpu
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Finishing up
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo Wed 12 Feb 2025 01:04:56 AM EET;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "- /users/bonnetfr/SwanSea/SourceCodes/LatticeRuns/BKeeper_run_gpu/small/Run_BKeeper_run_gpu_lat24.24.24.32_nodes002_mpi04-01-02-02_small/Run_BKeeper_run_gpu_lat24.24.24.32_nodes002_mpi04-01-02-02_small.sh Done. -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
# srun --account={account_name} --partition={partition} --time=00:30:00 --nodes=1 --gres=gpu:4 --pty bash
##SBATCH --ntasks-per-socket=4
##SBATCH --mem=494000
#export MPICH_GPU_SUPPORT_ENABLED=1
#export UCX_TLS=self,sm,rc,ud
#export OMPI_MCA_PML="ucx"
#export OMPI_MCA_osc="ucx"
#-------------------------------------------------------------------------------
