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
module load cuda/12.3 openmpi/4.1.5-cuda12.3 ucx/1.15.0-cuda12.3 gcc/9.3.0;
module list;
#-------------------------------------------------------------------------------
# Run the Sombrero launcher from the src directory
#-------------------------------------------------------------------------------

#echo $sombrero_dir
#echo $LatticeRuns_dir

#cd $LatticeRuns_dir
#cd /home/dp208/dp208/dc-bonn2/SwanSea/SourceCodes/LatticeRuns

#echo `pwd`

#ls -la $sombrero_dir/sombrero.sh
sombrero_dir=/home/dp208/dp208/dc-bonn2/SwanSea/SourceCodes/Sombrero/SOMBRERO
LatticeRuns_dir=/home/dp208/dp208/dc-bonn2/SwanSea/SourceCodes/LatticeRuns
ls -la $sombrero_dir/sombrero.sh
cd $sombrero_dir;
echo `pwd`

echo "SLURM_NTASKS: $SLURM_NTASKS"
./sombrero.sh -n $SLURM_NTASKS -w -s small > $LatticeRuns_dir/weak_$SLURM_NTASKS
