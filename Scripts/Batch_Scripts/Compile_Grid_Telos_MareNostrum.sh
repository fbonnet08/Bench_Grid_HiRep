#!/bin/bash
#SBATCH --job-name=cmpl_Grid_Telos
#SBATCH --output=./%x.out
#SBATCH --error=./%x.err
#SBATCH --time=02:00:00
#SBATCH --partition=acc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4    # nodes * ntasks
## GPU only
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:1
#SBATCH --qos=acc_ehpc
#SBATCH --gpus-per-node=4
#SBATCH --account=ehpc191
#-------------------------------------------------------------------------------
# Getting the common code setup and variables:
#---> Accelerator type (cpu/gpu)             : gpu
#---> Simulation size in consideration       : small
#---> Machine name that we are working on is : MareNostrum
#-------------------------------------------------------------------------------
#---> this is a compilation script
#-------------------------------------------------------------------------------
# Start of the batch body
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Module loads and compiler version
#-------------------------------------------------------------------------------
#set -eu
module load cuda/12.1 gcc/11.4.0 ucx/1.16.0 openmpi/4.1.5-ucx1.16-gcc mkl/2021.4.0 hdf5/1.14.1-2-gcc-ompi;
module list;

# Check some versions
ucx_info -v
nvcc --version
which mpirun
#-------------------------------------------------------------------------------
# Run the make procedure
#-------------------------------------------------------------------------------
# first clean up the exist build
machine_name="MareNostrum"
grid_telos_dir=${HOME}/SwanSea/SourceCodes/Grid-Telos/Grid
grid_telos_build_dir=$grid_telos_dir/build

# move to the directory in Grid_Telos build directory

cd $grid_telos_build_dir
pwd

if [[ $machine_name =~ "Precision-3571"  ||
      $machine_name =~ "DESKTOP-GPI5ERK" ||
      $machine_name =~ "desktop-dpr4gpr" ]]; then
    make -k -j 16 > Grid_Telos_"$SLURM_NTASKS".log;
    make -k install;
else
    make -k -j 32 > Grid_Telos_"$SLURM_NTASKS".log;
    make -k install;
fi
