#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks=128
#SBATCH --ntasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --partition=cpu
#SBATCH --job-name=compile_BKeeper
#SBATCH --time=15:0:0
#SBATCH --qos=standard
#-------------------------------------------------------------------------------
# Getting the common code setup and variables
#-------------------------------------------------------------------------------
#---> this is a BKeeper job run
#---> no modules on DESKTOP-GPI5ERK; module list;
#-------------------------------------------------------------------------------
# Start of the batch body
#-------------------------------------------------------------------------------
#------------------------------------------------------------------------------
# Run the make procedure
# ------------------------------------------------------------------------------
machine_name="DESKTOP-GPI5ERK"
bkeeper_dir=/home/frederic/SwanSea/SourceCodes/BKeeper
bkeeper_build_dir=/home/frederic/SwanSea/SourceCodes/BKeeper/build
#-------------------------------------------------------------------------------
# move to the directory in BKeeper directory
#-------------------------------------------------------------------------------

cd $bkeeper_dir

# check if build directory exists after having deleted it.
if [ -d ${bkeeper_build_dir} ]
then
  printf "Directory              : ";
  printf '%s'"${bkeeper_build_dir}"; printf " exist, nothing to do.\n";
else
  printf "Directory              : ";
  printf '%s'"${bkeeper_build_dir}"; printf " does not exist, We will create it ...\n";
  mkdir -p ${bkeeper_build_dir}
  printf "                       : "; printf "done.\n";
fi

cd $bkeeper_build_dir

if [[ $machine_name =~ "Precision-3571" || $machine_name =~ "DESKTOP-GPI5ERK" ]]; then
  make -k -j16 > Bkeeper_compile_$SLURM_NTASKS.log;
else
  make -k -j32 > Bkeeper_compile_$SLURM_NTASKS.log;
fi