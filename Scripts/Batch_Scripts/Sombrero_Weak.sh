#!/bin/bash
#
#SBATCH --ntasks=128
#SBATCH --job-name=sombrero_strong
#SBATCH --time=0-0:20
#SBATCH --ntasks-per-node=32

cd $SLURM_SUBMIT_DIR

./sombrero.sh -n $SLURM_NTASKS -w -s small > weak_$n
