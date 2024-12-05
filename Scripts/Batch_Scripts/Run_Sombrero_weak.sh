#!/bin/bash
#SBATCH --nodes=4
#SBATCH --ntasks=128
#SBATCH --ntasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --partition=cpu
#SBATCH --job-name=run_Sombrero_weak
#SBATCH --time=0:0:20
#SBATCH --qos=standard
#-------------------------------------------------------------------------------
# Getting the common code setup and variables
#-------------------------------------------------------------------------------

#---> no modules on DESKTOP-GPI5ERK; module list;

#-------------------------------------------------------------------------------
# Start of the batch body
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Run the make procedure
#-------------------------------------------------------------------------------
machine_name="DESKTOP-GPI5ERK"
sombrero_dir=/home/frederic/SwanSea/SourceCodes/BKeeper
LatticeRuns_dir=/home/frederic/SwanSea/SourceCodes/LatticeRuns
#-------------------------------------------------------------------------------
# move to the directory in Sombrero directory
#-------------------------------------------------------------------------------
cd $sombrero_dir;

if [ -f ./${sombrero_dir}/sombrero.sh ]
then
  printf "File                   : ";
  printf '%s'"./${sombrero_dir}/sombrero.sh"; printf " exist, let's submit.\n";
  ls -la ./$sombrero_dir/sombrero.sh
else
  printf "Directory              : ";
  printf '%s'"./${sombrero_dir}/sombrero.sh"; printf " does not exist, exiting ...\n";
  printf "                       : "; printf "done.\n";
  exit
fi

echo /home/frederic/SwanSea/SourceCodes/Bench_Grid_HiRep/Scripts/Batch_Scripts

echo "SLURM_NTASKS: $SLURM_NTASKS"

$sombrero_dir/sombrero.sh \
        -n $SLURM_NTASKS \
        -w \
        -s small \
        > $LatticeRuns_dir/weak_$SLURM_NTASKS &
