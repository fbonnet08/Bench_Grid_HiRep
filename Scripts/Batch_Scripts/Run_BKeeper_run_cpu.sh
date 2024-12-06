#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks=128
#SBATCH --ntasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --partition=cpu
#SBATCH --job-name=run_BKeeper_cpu
#SBATCH --time=15:0:0
#SBATCH --qos=standard
#-------------------------------------------------------------------------------
# Getting the common code setup and variables
#-------------------------------------------------------------------------------
#---> this is a BKeeper job run

#---> no modules on DESKTOP-GPI5ERK; module list;

#-------------------------------------------------------------------------------
# Start of gf the batch body
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Run the make procedure
#-------------------------------------------------------------------------------
machine_name="DESKTOP-GPI5ERK"
bkeeper_dir=/home/frederic/SwanSea/SourceCodes/BKeeper
bkeeper_build_dir=$bkeeper_dir/build
#-------------------------------------------------------------------------------
# move to the directory in BKeeper directory
#-------------------------------------------------------------------------------

cd $bkeeper_build_dir

if [ -d ${LatticeRuns_dir} ]
then
  printf "Directory              : ";
  printf '%s'"${LatticeRuns_dir}"; printf " exist, nothing to do.\n";
else
  printf "Directory              : ";
  printf '%s'"${LatticeRuns_dir}";printf " doesn't exist, will create it...\n";
  mkdir -p ${LatticeRuns_dir}
  printf "                       : "; printf "done.\n";
fi

mpirun $bkeeper_build_dir/BKeeper \
        --grid 32.32.32.32 \
        --mpi 1.1.1.4 \
        $benchmark_input_dir/BKeeper/input_BKeeper.xml \
        > $LatticeRuns_dir/bkeeper_run_cpu.log &
