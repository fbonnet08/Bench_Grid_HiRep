#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=3
#SBATCH --cpus-per-task=1
#SBATCH --partition=cpu
#SBATCH --job-name=sombrero_weak
#SBATCH --time=5:0:0
#SBATCH --qos=standard
#-------------------------------------------------------------------------------
# Getting the common code setup and variables
#-------------------------------------------------------------------------------
# hello this is the rest of the code ....

# ---> this is a Sombrero_weak job run

echo "# ---> this works ----<"
echo "TODO: insert the main of each case of the machines"
echo "ls -al /home/frederic/SwanSea/SourceCodes/external_lib/prefix_grid_202410"

