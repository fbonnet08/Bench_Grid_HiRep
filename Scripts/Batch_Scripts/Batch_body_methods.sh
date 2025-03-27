#!/bin/bash
################################################################################
# Run Finishing up method
################################################################################
Batch_body_Run_finishing_up_method (){
_batch_file_out=$1
#-------------------------------------------------------------------------------
# Finishing up
#-------------------------------------------------------------------------------
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Finishing up
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo `date`;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "- $_batch_file_out Done. -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
# srun --account={account_name} --partition={partition} --time=00:30:00 --nodes=1 --gres=gpu:4 --pty bash
##SBATCH --ntasks-per-socket=4
##SBATCH --mem=494000
#export MPICH_GPU_SUPPORT_ENABLED=1
#export UCX_TLS=self,sm,rc,ud
#export OMPI_MCA_PML="ucx"
#export OMPI_MCA_osc="ucx"
#-------------------------------------------------------------------------------
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
_simulation_size=$5
_batch_file_construct=$6
_prefix=$7
_path_to_run=$8
# TODO: insert the difference between small, medium and large
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
job_name=$_batch_file_construct
prefix=$_prefix
path_to_run=$_path_to_run
#-------------------------------------------------------------------------------
# move to the directory in Sombrero directory
#-------------------------------------------------------------------------------
cd \$sombrero_dir;

echo "SLURM_NTASKS: \$SLURM_NTASKS"
slrm_ntasks=\$(printf "%04d" \$SLURM_NTASKS)

\$sombrero_dir/sombrero.sh \\
        -n \$SLURM_NTASKS \\
        -w \\
        -s $_simulation_size
EOF
#-------------------------------------------------------------------------------
# Finishing up
#-------------------------------------------------------------------------------
Batch_body_Run_finishing_up_method "${_batch_file_out}"
}
################################################################################
# Run Sombrero strong
################################################################################
Batch_body_Run_Sombrero_strong (){
_machine_name=$1
_sombrero_dir=$2
_LatticeRuns_dir=$3
_batch_file_out=$4
_simulation_size=$5
_batch_file_construct=$6
_prefix=$7
_path_to_run=$8
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
job_name=$_batch_file_construct
prefix=$_prefix
path_to_run=$_path_to_run
#-------------------------------------------------------------------------------
# move to the directory in Sombrero directory
#-------------------------------------------------------------------------------
cd \$sombrero_dir;

echo "SLURM_NTASKS: \$SLURM_NTASKS"
slrm_ntasks=\$(printf "%04d" \$SLURM_NTASKS)

\$sombrero_dir/sombrero.sh \\
        -n \$SLURM_NTASKS \\
        -s $_simulation_size
EOF
#-------------------------------------------------------------------------------
# Finishing up
#-------------------------------------------------------------------------------
Batch_body_Run_finishing_up_method "${_batch_file_out}"
}
################################################################################
# Compile BKeeper
################################################################################
Batch_body_Compile_BKeeper (){
_machine_name=$1
_bkeeper_dir=$2
_LatticeRuns_dir=$3
_batch_file_out=$4
_batch_file_construct=$5
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
LatticeRuns_dir=$_LatticeRuns_dir
job_name=$_batch_file_construct
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

if [[ \$machine_name =~ "Precision-3571" || \$machine_name =~ "DESKTOP-GPI5ERK" || \$machine_name =~ "desktop-dpr4gpr" ]]; then
  make -k -j16 > \$LatticeRuns_dir/\$job_name/Bkeeper_compile_\$SLURM_NTASKS.log;
else
  make -k -j32 > \$LatticeRuns_dir/\$job_name/Bkeeper_compile_\$SLURM_NTASKS.log;
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
_LatticeRuns_dir=$3
_benchmark_input_dir=$4
_batch_file_out=$5
_lattice_size_cpu=$6
_mpi_distribution=$7
_simulation_size=$8
_batch_file_construct=$9
_prefix=${10}
_path_to_run=${11}
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Start of the batch body
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# The path structure
#-------------------------------------------------------------------------------
machine_name="$_machine_name"
bkeeper_dir=$_bkeeper_dir
bkeeper_build_dir=\$bkeeper_dir/build
benchmark_input_dir=$_benchmark_input_dir
LatticeRuns_dir=$_LatticeRuns_dir
job_name=$_batch_file_construct
prefix=$_prefix
path_to_run=$_path_to_run
#-------------------------------------------------------------------------------
# Export path and library paths
#-------------------------------------------------------------------------------
#Extending the library path
export PREFIX_HOME=\$prefix
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$PREFIX_HOME/lib
#-------------------------------------------------------------------------------
# move to the directory in BKeeper directory
#-------------------------------------------------------------------------------
cd \$bkeeper_build_dir

if [ -d \${path_to_run} ]
then
  printf "Directory              : ";
  printf '%s'"\${path_to_run}"; printf " exist, nothing to do.\n";
else
  printf "Directory              : ";
  printf '%s'"\${path_to_run}";printf " doesn't exist, will create it...\n";
  mkdir -p \${path_to_run}
  printf "                       : "; printf "done.\n";
fi

mpirun \$bkeeper_build_dir/BKeeper \\
        --grid $_lattice_size_cpu \\
        --mpi $_mpi_distribution \\
        \$benchmark_input_dir/BKeeper/input_BKeeper.xml \\
        > \$path_to_run/bkeeper_run_cpu.log &

EOF
}
#TODO: need to fix the log file output file
################################################################################
# Run BKeeper_run_gpu
################################################################################
Batch_body_Run_BKeeper_gpu (){
_machine_name=$1
_bkeeper_dir=$2
_LatticeRuns_dir=$3
_benchmark_input_dir=$4
_batch_file_out=$5
_lattice_size_cpu=$6
_mpi_distribution=$7
_simulation_size=$8
_batch_file_construct=$9
_prefix=${10}
_path_to_run=${11}
_module_list=${12}
_sourcecode_dir=${13}
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Start of the batch body
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Module loads and compiler version
#-------------------------------------------------------------------------------
$_module_list

EOF
#-------------------------------------------------------------------------------
# Compiler queries
#-------------------------------------------------------------------------------
if [[ $_machine_name = "lumi"  ||
      $_machine_name = "mi300" ||
      $_machine_name = "mi210" ]];
then
cat << EOF >> "$_batch_file_out"
# Check some versions
#ucx_info -v
hipcc --version
#which mpirun
EOF
elif [[ $_machine_name = "leonardo" || $_machine_name = "vega" || $_machine_name = "tursa" ]];
then
cat << EOF >> "$_batch_file_out"
# Check some versions
ucx_info -v
nvcc --version
which mpirun
EOF
fi
#-------------------------------------------------------------------------------
# Path structure
#-------------------------------------------------------------------------------
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# The path structure
#-------------------------------------------------------------------------------
machine_name="$_machine_name"
sourcecode_dir=$_sourcecode_dir
bkeeper_dir=$_bkeeper_dir
bkeeper_build_dir=\$bkeeper_dir/build
Bench_Grid_HiRep_dir=\$sourcecode_dir/Bench_Grid_HiRep
benchmark_input_dir=$_benchmark_input_dir
#Extending the library path
prefix=$_prefix
EOF
#-------------------------------------------------------------------------------
# Export path and library paths
#-------------------------------------------------------------------------------
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Export path and library paths
#-------------------------------------------------------------------------------
#Extending the library path
export PREFIX_HOME=\$prefix
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$PREFIX_HOME/lib

echo "\$LD_LIBRARY_PATH"

ls -al "\$PREFIX_HOME/lib"
#-------------------------------------------------------------------------------
# Probing the file systems and getting some info
#-------------------------------------------------------------------------------
ls -al "\${bkeeper_build_dir}"/BKeeper
ls -al "\${benchmark_input_dir}"/BKeeper/input_BKeeper.xml
EOF
#-------------------------------------------------------------------------------
# Export variables for the run
#-------------------------------------------------------------------------------
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Variable exports
#-------------------------------------------------------------------------------
EOF
#-------------------------------------------------------------------------------
# Variable exports
#-------------------------------------------------------------------------------
if [[ $_machine_name = "lumi" ]];
then
cat << EOF >> "$_batch_file_out"
# OpenMP
export OMP_NUM_THREADS=8
# MPI
export MPICH_GPU_SUPPORT_ENABLED=1
export OMPI_MCA_PML="ucx"
export OMPI_MCA_osc="ucx"
# UCX
export UCX_TLS=self,sm,rc,ud
# GRID
export GRID_ALLOC_NCACHE_SMALL=16
export GRID_ALLOC_NCACHE_LARGE=2
export GRID_ALLOC_NCACHE_HUGE=0
EOF
elif [[ $_machine_name = "leonardo" ]]
then
cat << EOF >> "$_batch_file_out"
# OpenMP
export OMP_NUM_THREADS=8
# MPI
export OMPI_MCA_btl=^uct,openib
export OMPI_MCA_pml=ucx
export OMPI_MCA_io=romio321
export OMPI_MCA_btl_openib_allow_ib=true
export OMPI_MCA_btl_openib_device_type=infiniband
export OMPI_MCA_btl_openib_if_exclude=mlx5_1,mlx5_2,mlx5_3
# UCX
export UCX_TLS=gdr_copy,rc,rc_x,sm,cuda_copy,cuda_ipc
export UCX_RNDV_THRESH=16384
export UCX_RNDV_SCHEME=put_zcopy
export UCX_IB_GPU_DIRECT_RDMA=yes
export UCX_MEMTYPE_CACHE=n
# GRID
export GRID_ALLOC_NCACHE_SMALL=16
export GRID_ALLOC_NCACHE_LARGE=2
export GRID_ALLOC_NCACHE_HUGE=0
EOF
elif [[ $_machine_name = "vega" ]]
then
cat << EOF >> "$_batch_file_out"
# OpenMP
export OMP_NUM_THREADS=8
# MPI
#export OMPI_MCA_btl=^uct,openib
#export OMPI_MCA_pml=ucx
#export OMPI_MCA_osc="ucx".
#export OMPI_MCA_io=romio321
#export OMPI_MCA_btl_openib_allow_ib=true
#export OMPI_MCA_btl_openib_device_type=infiniband
#export OMPI_MCA_btl_openib_if_exclude=mlx5_1,mlx5_2,mlx5_3
export OMPI_MCA_PML="ucx"
export OMPI_MCA_osc="ucx"
# UCX
export UCX_TLS=self,sm,rc,ud
#export UCX_TLS=gdr_copy,rc,rc_x,sm,cuda_copy,cuda_ipc
#export UCX_RNDV_THRESH=16384
#export UCX_RNDV_SCHEME=put_zcopy
#export UCX_IB_GPU_DIRECT_RDMA=yes
#export UCX_MEMTYPE_CACHE=n
# GRID
export GRID_ALLOC_NCACHE_SMALL=16
export GRID_ALLOC_NCACHE_LARGE=2
export GRID_ALLOC_NCACHE_HUGE=0
EOF
elif [[ $_machine_name = "tursa" ]]
then
cat << EOF >> "$_batch_file_out"
# OpenMP
export OMP_NUM_THREADS=8
# MPI
export OMPI_MCA_btl=^uct,openib
export OMPI_MCA_pml=ucx
export OMPI_MCA_io=romio321
export OMPI_MCA_btl_openib_allow_ib=true
export OMPI_MCA_btl_openib_device_type=infiniband
export OMPI_MCA_btl_openib_if_exclude=mlx5_1,mlx5_2,mlx5_3
# UCX
export UCX_TLS=gdr_copy,rc,rc_x,sm,cuda_copy,cuda_ipc
export UCX_RNDV_THRESH=16384
export UCX_RNDV_SCHEME=put_zcopy
export UCX_IB_GPU_DIRECT_RDMA=yes
export UCX_MEMTYPE_CACHE=n
# GRID
export GRID_ALLOC_NCACHE_SMALL=16
export GRID_ALLOC_NCACHE_LARGE=2
export GRID_ALLOC_NCACHE_HUGE=0
EOF
elif [[ $_machine_name = "mi300" ]]
then
cat << EOF >> "$_batch_file_out"
# OpenMP
export OMP_NUM_THREADS=8
# MPI
export OMPI_MCA_btl=^uct,openib
export OMPI_MCA_pml=ucx
export OMPI_MCA_io=romio321
export OMPI_MCA_btl_openib_allow_ib=true
export OMPI_MCA_btl_openib_device_type=infiniband
export OMPI_MCA_btl_openib_if_exclude=mlx5_1,mlx5_2,mlx5_3
# UCX
export UCX_TLS=gdr_copy,rc,rc_x,sm,cuda_copy,cuda_ipc
export UCX_RNDV_THRESH=16384
export UCX_RNDV_SCHEME=put_zcopy
export UCX_IB_GPU_DIRECT_RDMA=yes
export UCX_MEMTYPE_CACHE=n
# GRID
export GRID_ALLOC_NCACHE_SMALL=16
export GRID_ALLOC_NCACHE_LARGE=2
export GRID_ALLOC_NCACHE_HUGE=0
EOF
elif [[ $_machine_name = "mi210" ]]
then
cat << EOF >> "$_batch_file_out"
# OpenMP
export OMP_NUM_THREADS=8
# MPI
export OMPI_MCA_btl=^uct,openib
export OMPI_MCA_pml=ucx
export OMPI_MCA_io=romio321
export OMPI_MCA_btl_openib_allow_ib=true
export OMPI_MCA_btl_openib_device_type=infiniband
export OMPI_MCA_btl_openib_if_exclude=mlx5_1,mlx5_2,mlx5_3
# UCX
export UCX_TLS=gdr_copy,rc,rc_x,sm,cuda_copy,cuda_ipc
export UCX_RNDV_THRESH=16384
export UCX_RNDV_SCHEME=put_zcopy
export UCX_IB_GPU_DIRECT_RDMA=yes
export UCX_MEMTYPE_CACHE=n
# GRID
export GRID_ALLOC_NCACHE_SMALL=16
export GRID_ALLOC_NCACHE_LARGE=2
export GRID_ALLOC_NCACHE_HUGE=0
EOF
fi
#-------------------------------------------------------------------------------
# Job description
#-------------------------------------------------------------------------------
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Output variable.
#-------------------------------------------------------------------------------
LatticeRuns_dir=$_LatticeRuns_dir
path_to_run=$_path_to_run
job_name=$_batch_file_construct
EOF
#-------------------------------------------------------------------------------
# Wrapper scripts Getting the gpu select script
#-------------------------------------------------------------------------------
if [[ $_machine_name = "lumi" ]];
then
eof_end_string="EOF"
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Wrapper scripts Getting the gpu select script
#-------------------------------------------------------------------------------
#wrapper_script=${Bench_Grid_HiRep_dir}/doc/BKeeper/gpu-mpi-wrapper-new-Lumi.sh
CPU_BIND="mask_cpu:7e000000000000,7e00000000000000"
CPU_BIND="\${CPU_BIND},7e0000,7e000000"
CPU_BIND="\${CPU_BIND},7e,7e00"
CPU_BIND="\${CPU_BIND},7e00000000,7e0000000000"

cat << EOF > ./select_gpu
#!/bin/bash

export ROCR_VISIBLE_DEVICES=\\\$SLURM_LOCALID
exec \\\$*
$eof_end_string

chmod +x ./select_gpu
EOF
elif [[ $_machine_name = "leonardo" ]]
then
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Wrapper scripts Getting the gpu select script
#-------------------------------------------------------------------------------
wrapper_script=\${Bench_Grid_HiRep_dir}/doc/BKeeper/gpu-mpi-wrapper-new-Leonardo.sh
chmod a+x \${wrapper_script}
EOF
elif [[ $_machine_name = "vega" ]]
then
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Wrapper scripts Getting the gpu select script
#-------------------------------------------------------------------------------
wrapper_script=\${Bench_Grid_HiRep_dir}/doc/BKeeper/gpu-mpi-wrapper-new-Vega.sh
chmod a+x \${wrapper_script}
EOF
elif [[ $_machine_name = "tursa" ]]
then
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Wrapper scripts Getting the gpu select script
#-------------------------------------------------------------------------------
wrapper_script=\${Bench_Grid_HiRep_dir}/doc/BKeeper/gpu-mpi-wrapper-new-Tursa.sh
chmod a+x \${wrapper_script}
EOF
elif [[ $_machine_name = "mi300" ]]
then
eof_end_string="EOF"
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Wrapper scripts Getting the gpu select script
#-------------------------------------------------------------------------------
wrapper_script=\${Bench_Grid_HiRep_dir}/doc/BKeeper/gpu-mpi-wrapper-new-Mi300.sh
chmod a+x \${wrapper_script}
EOF
elif [[ $_machine_name = "mi210" ]]
then
eof_end_string="EOF"
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Wrapper scripts Getting the gpu select script
#-------------------------------------------------------------------------------
wrapper_script=\${Bench_Grid_HiRep_dir}/doc/BKeeper/gpu-mpi-wrapper-new-Mi210.sh
chmod a+x \${wrapper_script}
EOF
fi
#-------------------------------------------------------------------------------
# Launching mechanism
#-------------------------------------------------------------------------------
if [[ $_machine_name = "lumi" ]];
then
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Launching mechanism
#-------------------------------------------------------------------------------
# run! #########################################################################
device_mem=23000
shm=8192
srun --cpu-bind=\${CPU_BIND} \\
  ./select_gpu "\${bkeeper_build_dir}"/BKeeper  \\
  "\${benchmark_input_dir}"/BKeeper/input_BKeeper.xml \\
  --grid $_lattice_size_cpu \\
  --mpi $_mpi_distribution \\
  --accelerator-threads "\$OMP_NUM_THREADS" \\
  --shm \$shm \\
  --device-mem \$device_mem \\
  --log Error,Warning,Message
################################################################################
#-------------------------------------------------------------------------------
EOF
elif [[ $_machine_name = "mi300" ]];
then
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
   # Launching mechanism
   #-------------------------------------------------------------------------------
   # run! #########################################################################
   device_mem=23000
   shm=8192
   srun --exclusive bash \\
     "\$wrapper_script" "\${bkeeper_build_dir}"/BKeeper  \\
     "\${benchmark_input_dir}"/BKeeper/input_BKeeper_mi300.xml \\
     --grid $_lattice_size_cpu \\
     --mpi $_mpi_distribution \\
     --accelerator-threads "\$OMP_NUM_THREADS" \\
     --shm \$shm \\
     --device-mem \$device_mem \\
     --log Error,Warning,Message
   ################################################################################
   #-------------------------------------------------------------------------------
EOF
elif [[ $_machine_name = "mi210" ]];
then
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
   # Launching mechanism
   #-------------------------------------------------------------------------------
   # run! #########################################################################
   device_mem=23000
   shm=8192
   srun --exclusive bash \\
     "\$wrapper_script" "\${bkeeper_build_dir}"/BKeeper  \\
     "\${benchmark_input_dir}"/BKeeper/input_BKeeper_mi210.xml \\
     --grid $_lattice_size_cpu \\
     --mpi $_mpi_distribution \\
     --accelerator-threads "\$OMP_NUM_THREADS" \\
     --shm \$shm \\
     --device-mem \$device_mem \\
     --log Error,Warning,Message
   ################################################################################
   #-------------------------------------------------------------------------------
EOF
elif [[ $_machine_name = "tursa"    || \
        $_machine_name = "vega"     || \
        $_machine_name = "sunbird"  || \
        $_machine_name = "leonardo" ]]
then
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Launching mechanism
#-------------------------------------------------------------------------------
# run! #########################################################################
device_mem=23000
shm=8192
mpirun -np \$SLURM_NTASKS \\
  --map-by numa \\
  -x LD_LIBRARY_PATH \\
  --bind-to none \\
  "\$wrapper_script" "\${bkeeper_build_dir}"/BKeeper  \\
  "\${benchmark_input_dir}"/BKeeper/input_BKeeper.xml \\
  --grid $_lattice_size_cpu \\
  --mpi $_mpi_distribution \\
  --accelerator-threads "\$OMP_NUM_THREADS" \\
  --shm \$shm \\
  --device-mem \$device_mem \\
  --log Error,Warning,Message
################################################################################
#-------------------------------------------------------------------------------
EOF
elif [[ $_machine_name = "Precision-3571"  || \
        $_machine_name = "desktop-dpr4gpr" || \
        $_machine_name = "DESKTOP-GPI5ERK" ]]
then
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Launching mechanism
#-------------------------------------------------------------------------------
# run! #########################################################################
device_mem=23000
shm=8192
mpirun \$bkeeper_build_dir/BKeeper \\
        --grid $_lattice_size_cpu \\
        --mpi $_mpi_distribution \\
        --accelerator-threads 8 \\
        \$benchmark_input_dir/BKeeper/input_BKeeper.xml \\
        > \$path_to_run/bkeeper_run_gpu.log &
################################################################################
#-------------------------------------------------------------------------------
EOF
fi
#-------------------------------------------------------------------------------
# Finishing up
#-------------------------------------------------------------------------------
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Finishing up
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo `date`;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "- $_batch_file_out Done. -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
# srun --account={account_name} --partition={partition} --time=00:30:00 --nodes=1 --gres=gpu:4 --pty bash
##SBATCH --ntasks-per-socket=4
##SBATCH --mem=494000
#export MPICH_GPU_SUPPORT_ENABLED=1
#export UCX_TLS=self,sm,rc,ud
#export OMPI_MCA_PML="ucx"
#export OMPI_MCA_osc="ucx"
#-------------------------------------------------------------------------------
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
_batch_file_construct=$5
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
job_name=$_batch_file_construct
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
     -o \$LatticeRuns_dir/\$job_name/out_llr-hmc_\${SLURM_JOB_NUM_NODES}nodes_\${SLURM_JOBID}_slurmTasks_\$SLURM_NTASKS.log &

EOF
}
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  Batch_body_methods.sh Done.                          -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$reset_colors
#exit
#-------------------------------------------------------------------------------







