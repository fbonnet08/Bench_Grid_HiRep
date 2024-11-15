#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks=128
#SBATCH --ntasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --partition=cpu
#SBATCH --job-name=complBKeeper
#SBATCH --time=5:0:0
#SBATCH --qos=standard
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------

#set -eu
#source ../../common_main.sh SwanSea/SourceCodes/external_lib;
module load cuda/12.3 openmpi/4.1.5-cuda12.3 ucx/1.15.0-cuda12.3 gcc/9.3.0;
module list;

#-------------------------------------------------------------------------------
# Run the make procedure
#-------------------------------------------------------------------------------

# first clean up the exist build
machine_name="tursa"
bekeeper_dir=/home/dp208/dp208/dc-bonn2/SwanSea/SourceCodes/BKeeper
bekeeper_build_dir=$bekeeper_dir/build

# move to the directory in BKeeper directory

# TODO: need to fix the logic on the BKeeper run

cd $bekeeper_dir


cd $bekeeper_build_dir
