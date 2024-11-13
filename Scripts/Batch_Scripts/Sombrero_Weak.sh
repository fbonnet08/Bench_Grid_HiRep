#!/bin/bash
#
#SBATCH --ntasks=128
#SBATCH --job-name=sombrero_strong
#SBATCH --time=0-0:20
#SBATCH --ntasks-per-node=32

#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------

source ../../common_main.sh $1;

#-------------------------------------------------------------------------------
# Run the Sombrero launcher from the src directory
#-------------------------------------------------------------------------------

echo $sombrero_dir
echo $LatticeRuns_dir

cd $LatticeRuns_dir
echo `pwd`
ls -la

$sombrero_dir/sombrero.sh -n $SLURM_NTASKS -w -s small > weak_$n
