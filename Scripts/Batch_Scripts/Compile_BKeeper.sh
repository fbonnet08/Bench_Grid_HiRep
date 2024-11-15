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
cd $bekeeper_dir

# check if build directory exists after having deleted it.
if [ -d ${bekeeper_build_dir} ]
then
  printf "Directory              : ";
  printf '%s'"${bekeeper_build_dir}"; printf " exist, nothing to do.\n";
else
  printf "Directory              : ";
  printf '%s'"${bekeeper_build_dir}"; printf " does not exist, We will create it ...\n";
  mkdir -p ${bekeeper_build_dir}
  printf "                       : "; printf "done.\n";
fi

cd $bekeeper_build_dir

if [[ $machine_name =~ "Precision-3571" ]]; then
  make -k -j16 > Bekkeper_$SLURM_NTASKS.log;
else
  make -k -j32 > Bekkeper_$SLURM_NTASKS.log;
fi

