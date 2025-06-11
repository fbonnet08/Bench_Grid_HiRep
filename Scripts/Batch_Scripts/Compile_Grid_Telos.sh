#!/bin/bash
#SBATCH --job-name=cmpl_Grid_Telos
#SBATCH --output=./%x.out
#SBATCH --error=./%x.err
#SBATCH --time=02:00:00
#SBATCH --partition=boost_usr_prod
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4    # nodes * ntasks
## GPU only
#SBATCH --gpus-per-node=4
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:1
#SBATCH --account=EUHPC_B22_046
#-------------------------------------------------------------------------------
# Getting the common code setup and variables:
#---> Accelerator type (cpu/gpu)             : gpu
#---> Simulation size in consideration       : small
#---> Machine name that we are working on is : leonardo
#-------------------------------------------------------------------------------
#---> this is a compilation script
#-------------------------------------------------------------------------------
# Start of the batch body
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Module loads and compiler version
#-------------------------------------------------------------------------------
#set -eu
module load cuda/12.2 nvhpc/23.11 fftw/3.3.10--openmpi--4.1.6--gcc--12.2.0 hdf5;
module list;
#-------------------------------------------------------------------------------
# Run the make procedure
#-------------------------------------------------------------------------------
# first clean up the exist build
machine_name="leonardo"
grid_telos_dir=${HOME}/SwanSea/SourceCodes/Grid-Telos/Grid
grid_telos_build_dir=$grid_telos_dir/build

# move to the directory in Grid_Telos build directory

cd $grid_telos_build_dir
pwd

if [[ $machine_name =~ "Precision-3571"  ||
      $machine_name =~ "DESKTOP-GPI5ERK" ||
      $machine_name =~ "desktop-dpr4gpr" ]]; then
    make -k -j16 > Grid_Telos_"$SLURM_NTASKS".log;
    make install;
else
    make -k -j32 > Grid_Telos_"$SLURM_NTASKS".log;
    make install;
fi
