#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks=128
#SBATCH --ntasks-per-node=256
#SBATCH --cpus-per-task=1
#SBATCH --partition=cpu
#SBATCH --job-name=run_HiRep-LLR-master_cpu
#SBATCH --time=0:0:20
#SBATCH --qos=standard
#-------------------------------------------------------------------------------
# Getting the common code setup and variables
#-------------------------------------------------------------------------------
#---> this is a HiRep-LLR-master-cpu job run

#---> no modules on DESKTOP-GPI5ERK; module list;

#-------------------------------------------------------------------------------
# Start of the batch body
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Run the make procedure
#-------------------------------------------------------------------------------
machine_name="DESKTOP-GPI5ERK"
HiRep_LLR_master_HMC_dir=/home/frederic/SwanSea/SourceCodes/HiRep-LLR-master/HiRep/LLR_HMC
LatticeRuns_dir=/home/frederic/SwanSea/SourceCodes/LatticeRuns
#-------------------------------------------------------------------------------
# move to the directory in ${HiRep_LLR_master_HMC_dir} directory
#-------------------------------------------------------------------------------
cd $HiRep_LLR_master_HMC_dir;

if [ -f ./${HiRep_LLR_master_HMC_dir}/input_file ]
then
  printf "File                   : ";
  printf '%s'"./${HiRep_LLR_master_HMC_dir}/input_file"; printf " exist, let's submit.\n";
  ls -la ./$HiRep_LLR_master_HMC_dir/input_file
else
  printf "Directory              : ";
  printf '%s'"./${HiRep_LLR_master_HMC_dir}/input_file"; printf " does not exist, exiting ...\n";
  printf "                       : "; printf "done.\n";
  exit
fi

echo /home/frederic/SwanSea/SourceCodes/Bench_Grid_HiRep/Scripts/Batch_Scripts

echo "SLURM_NTASKS: $SLURM_NTASKS"

srun ./llr_hmc \
     -i ./${HiRep_LLR_master_HMC_dir}/input_file \
     -o $LatticeRuns_dir/out_llr-hmc_${SLURM_JOB_NUM_NODES}nodes_${SLURM_JOBID}_slurmTasks_$SLURM_NTASKS.log

