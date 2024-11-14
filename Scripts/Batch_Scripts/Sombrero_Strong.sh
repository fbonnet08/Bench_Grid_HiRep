#!/bin/bash
#
#SBATCH --nodes=2
#SBATCH --ntasks=256
#SBATCH --ntasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --partition=cpu
#SBATCH --job-name=sombrero_strong
#SBATCH --time=0-0:20
#SBATCH --qos=standard
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

#cd $SLURM_SUBMIT_DIR

./sombrero.sh -n $SLURM_NTASKS -s medium > strong_$n



