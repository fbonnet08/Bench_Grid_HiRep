#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --partition=cpu
#SBATCH --job-name=sombrero_weak
#SBATCH --time=0-0:20
#SBATCH --qos=standard
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------

#set -eu
#source ../../common_main.sh SwanSea/SourceCodes/external_lib;

#-------------------------------------------------------------------------------
# Run the Sombrero launcher from the src directory
#-------------------------------------------------------------------------------

#echo $sombrero_dir
#echo $LatticeRuns_dir

#cd $LatticeRuns_dir
cd /home/dp208/dp208/dc-bonn2/SwanSea/SourceCodes/LatticeRuns

echo `pwd`

#ls -la $sombrero_dir/sombrero.sh

ls -la /home/dp208/dp208/dc-bonn2/SwanSea/SourceCodes/Sombrero/SOMBRERO/sombrero.sh


echo "SLURM_NTASKS: $SLURM_NTASKS"
/home/dp208/dp208/dc-bonn2/SwanSea/SourceCodes/Sombrero/SOMBRERO/sombrero.sh -n $SLURM_NTASKS -w -s small > weak_$n
