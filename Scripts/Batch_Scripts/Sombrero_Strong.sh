#!/bin/bash
#
#SBATCH --ntasks=256
#SBATCH --job-name=sombrero_strong
#SBATCH --time=0-0:20
#SBATCH --ntasks-per-node=32

cd $SLURM_SUBMIT_DIR

./sombrero.sh -n $SLURM_NTASKS -s medium > strong_$n



