#!/bin/bash
################################################################################
# Compile BKeeper
################################################################################
Batch_body_Compile_BKeeper (){
_machine_name=$1
_bkeeper_dir=$2
_batch_file_out=$3
#-------------------------------------------------------------------------------
# Start of the batch body
#-------------------------------------------------------------------------------
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Start of the batch body
#-------------------------------------------------------------------------------
#------------------------------------------------------------------------------
# Run the make procedure
# ------------------------------------------------------------------------------
machine_name="${_machine_name}"
bkeeper_dir=${_bkeeper_dir}
bkeeper_build_dir=${_bkeeper_dir}/build
#-------------------------------------------------------------------------------
# move to the directory in BKeeper directory
#-------------------------------------------------------------------------------

cd \$bkeeper_dir

# check if build directory exists after having deleted it.
if [ -d \${bkeeper_build_dir} ]
then
  printf "Directory              : ";
  printf '%s'"\${bkeeper_build_dir}"; printf " exist, nothing to do.\n";
else
  printf "Directory              : ";
  printf '%s'"\${bkeeper_build_dir}"; printf " does not exist, We will create it ...\n";
  mkdir -p \${bkeeper_build_dir}
  printf "                       : "; printf "done.\n";
fi

cd \$bkeeper_build_dir

if [[ \$machine_name =~ "Precision-3571" || \$machine_name =~ "DESKTOP-GPI5ERK" ]]; then
  make -k -j16 > Bkeeper_compile_\$SLURM_NTASKS.log;
else
  make -k -j32 > Bkeeper_compile_\$SLURM_NTASKS.log;
fi
EOF
}
################################################################################
# Run BKeeper_run_gpu
################################################################################
#
# TODO: make the difference between the accelerator_thread business for CPU and GPU
#
Batch_body_Run_BKeeper_cpu (){
_machine_name=$1
_bkeeper_dir=$2
_batch_file_out=$3
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Start of gf the batch body
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Run the make procedure
#-------------------------------------------------------------------------------
machine_name="$_machine_name"
bkeeper_dir=$_bkeeper_dir
bkeeper_build_dir=$_bkeeper_dir/build
#-------------------------------------------------------------------------------
# move to the directory in BKeeper directory
#-------------------------------------------------------------------------------

cd \$bkeeper_build_dir

if [ -d \${LatticeRuns_dir} ]
then
  printf "Directory              : ";
  printf '%s'"\${LatticeRuns_dir}"; printf " exist, nothing to do.\n";
else
  printf "Directory              : ";
  printf '%s'"\${LatticeRuns_dir}";printf " doesn't exist, will create it...\n";
  mkdir -p \${LatticeRuns_dir}
  printf "                       : "; printf "done.\n";
fi

mpirun \$bkeeper_build_dir/BKeeper \\
        --grid 32.32.32.32 \\
        --mpi 1.1.1.4 \\
        \$benchmark_input_dir/BKeeper/input_BKeeper.xml \\
        > \$LatticeRuns_dir/bkeeper_run_cpu.log &
EOF
}
################################################################################
# Run BKeeper_run_gpu
################################################################################
Batch_body_Run_BKeeper_gpu (){
_machine_name=$1
_bkeeper_dir=$2
_batch_file_out=$3
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Start of gf the batch body
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Run the make procedure
#-------------------------------------------------------------------------------
machine_name="$_machine_name"
bkeeper_dir=$_bkeeper_dir
bkeeper_build_dir=$_bkeeper_dir/build
#-------------------------------------------------------------------------------
# move to the directory in BKeeper directory
#-------------------------------------------------------------------------------

cd \$bkeeper_build_dir

if [ -d \${LatticeRuns_dir} ]
then
  printf "Directory              : ";
  printf '%s'"\${LatticeRuns_dir}"; printf " exist, nothing to do.\n";
else
  printf "Directory              : ";
  printf '%s'"\${LatticeRuns_dir}";printf " doesn't exist, will create it...\n";
  mkdir -p \${LatticeRuns_dir}
  printf "                       : "; printf "done.\n";
fi

mpirun \$bkeeper_build_dir/BKeeper \\
        --grid 32.32.32.32 \\
        --mpi 1.1.1.4 \\
        --accelerator-threads 8 \\
        \$benchmark_input_dir/BKeeper/input_BKeeper.xml \\
        > \$LatticeRuns_dir/bkeeper_run_gpu.log &
EOF
}
################################################################################
# Run Sombrero weak
################################################################################
Batch_body_Run_Sombrero_weak (){
_machine_name=$1
_sombrero_dir=$2
_LatticeRuns_dir=$3
_batch_file_out=$4
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Start of the batch body
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Run the make procedure
#-------------------------------------------------------------------------------
machine_name="$_machine_name"
sombrero_dir=$_sombrero_dir
LatticeRuns_dir=$_LatticeRuns_dir
#-------------------------------------------------------------------------------
# move to the directory in Sombrero directory
#-------------------------------------------------------------------------------
cd \$sombrero_dir;

if [ -f ./\${sombrero_dir}/sombrero.sh ]
then
  printf "File                   : ";
  printf '%s'"./\${sombrero_dir}/sombrero.sh"; printf " exist, let's submit.\n";
  ls -la ./\$sombrero_dir/sombrero.sh
else
  printf "Directory              : ";
  printf '%s'"./\${sombrero_dir}/sombrero.sh"; printf " does not exist, exiting ...\n";
  printf "                       : "; printf "done.\n";
  exit
fi

echo `pwd`

echo "SLURM_NTASKS: \$SLURM_NTASKS"

\$sombrero_dir/sombrero.sh \\
        -n \$SLURM_NTASKS \\
        -w \\
        -s small \\
        > \$LatticeRuns_dir/weak_\$SLURM_NTASKS &
EOF
}
################################################################################
# Run Sombrero strong
################################################################################
Batch_body_Run_Sombrero_strong (){
_machine_name=$1
_sombrero_dir=$2
_LatticeRuns_dir=$3
_batch_file_out=$4
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Start of the batch body
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Run the make procedure
#-------------------------------------------------------------------------------
machine_name="$_machine_name"
sombrero_dir=$_sombrero_dir
LatticeRuns_dir=$_LatticeRuns_dir
#-------------------------------------------------------------------------------
# move to the directory in Sombrero directory
#-------------------------------------------------------------------------------
cd \$sombrero_dir;

if [ -f ./\${sombrero_dir}/sombrero.sh ]
then
  printf "File                   : ";
  printf '%s'"./\${sombrero_dir}/sombrero.sh"; printf " exist, let's submit.\n";
  ls -la ./\$sombrero_dir/sombrero.sh
else
  printf "Directory              : ";
  printf '%s'"./\${sombrero_dir}/sombrero.sh"; printf " does not exist, exiting ...\n";
  printf "                       : "; printf "done.\n";
  exit
fi

echo `pwd`

echo "SLURM_NTASKS: \$SLURM_NTASKS"

\$sombrero_dir/sombrero.sh \\
        -n \$SLURM_NTASKS \\
        -s medium \\
        > \$LatticeRuns_dir/strong_\$SLURM_NTASKS &

EOF
}
################################################################################
# Run HiRep-LLR-master-cpu
################################################################################
Batch_body_Run_HiRep-LLR-master-cpu (){
_machine_name=$1
_HiRep_LLR_master_HMC_dir=$2
_LatticeRuns_dir=$3
_batch_file_out=$4
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Start of the batch body
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Run the make procedure
#-------------------------------------------------------------------------------
machine_name="$_machine_name"
HiRep_LLR_master_HMC_dir=$_HiRep_LLR_master_HMC_dir
LatticeRuns_dir=$_LatticeRuns_dir
#-------------------------------------------------------------------------------
# move to the directory in \${HiRep_LLR_master_HMC_dir} directory
#-------------------------------------------------------------------------------
cd \$HiRep_LLR_master_HMC_dir;

if [ -f ./\${HiRep_LLR_master_HMC_dir}/input_file ]
then
  printf "File                   : ";
  printf '%s'"./\${HiRep_LLR_master_HMC_dir}/input_file"; printf " exist, let's submit.\n";
  ls -la ./\$HiRep_LLR_master_HMC_dir/input_file
else
  printf "Directory              : ";
  printf '%s'"./\${HiRep_LLR_master_HMC_dir}/input_file"; printf " does not exist, exiting ...\n";
  printf "                       : "; printf "done.\n";
  exit
fi

echo `pwd`

echo "SLURM_NTASKS: \$SLURM_NTASKS"

# locally: mpirun -n 4 ./llr_hmc -i input_hmc_llr -o out_llr_hmc_run_02DecDec24.log

srun ./llr_hmc \\
     -i ./\${HiRep_LLR_master_HMC_dir}/input_file \\
     -o \$LatticeRuns_dir/out_llr-hmc_\${SLURM_JOB_NUM_NODES}nodes_\${SLURM_JOBID}_slurmTasks_\$SLURM_NTASKS.log

EOF
}






