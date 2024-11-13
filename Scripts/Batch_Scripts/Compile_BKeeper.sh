#!/bin/bash
#
#SBATCH --ntasks=32
#SBATCH --job-name=compile_BKeeper
#SBATCH --time=0-0:20
#SBATCH --ntasks-per-node=32

#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------

source ../../common_main.sh $1;

#-------------------------------------------------------------------------------
# Checking if the libraries have been installed properly
#-------------------------------------------------------------------------------

cd $SLURM_SUBMIT_DIR

if [[ $machine_name =~ "Precision-3571" ]]; then
  make -k -j16 > Bekkeper_$n.log;
else
  make -k -j32 > Bekkeper_$n.log;
fi


