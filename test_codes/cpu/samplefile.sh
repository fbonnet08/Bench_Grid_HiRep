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
hello header method file ....

# ---> this is a Sombrero_weak job run

echo "# ---> this works ----<"
echo "TODO: insert the main of each case of the machines"
echo "ls -al /home/frederic/SwanSea/SourceCodes/external_lib/prefix_grid_202410"

module load cuda/12.3 openmpi/4.1.5-cuda12.3 ucx/1.15.0-cuda12.3 gcc/9.3.0;
module list;
#-------------------------------------------------------------------------------
# Run the make procedure                                                        
#-------------------------------------------------------------------------------
machine_name="DESKTOP-GPI5ERK"
bkeeper_dir=/home/frederic/SwanSea/SourceCodes/BKeeper
bkeeper_build_dir=/home/frederic/SwanSea/SourceCodes/BKeeper/build
#-------------------------------------------------------------------------------
# move to the directory in BKeeper directory                                    
#-------------------------------------------------------------------------------
cd /home/frederic/SwanSea/SourceCodes/BKeeper/build


