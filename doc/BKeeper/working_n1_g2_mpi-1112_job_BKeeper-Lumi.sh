#!/bin/bash -l
#SBATCH --job-name=TEST-JOB            # Job name
#SBATCH --output=log/%x.%j.out
#SBATCH --error=log/%x.%j.err
#SBATCH --time=1-12:00:00              # Run time (d-hh:mm:ss)
#SBATCH --partition=standard-g         # partition name
#SBATCH --nodes=1                      # Total number of nodes
#SBATCH --ntasks-per-node=2            # 8 MPI ranks per node, 16 total (2x8)
#SBATCH --gpus-per-node=8              # Allocate one gpu per MPI rank
#SBATCH --time=1-12:00:00              # Run time (d-hh:mm:ss)
#SBATCH --account=project_465001614
#-------------------------------------------------------------------------------
# Module loads and compiler version
#-------------------------------------------------------------------------------
module load cray-mpich cray-fftw
module list;

hipcc --version
#-------------------------------------------------------------------------------
# Variable expoiorts
#-------------------------------------------------------------------------------
export UCX_TLS=self,sm,rc,ud
export OMPI_MCA_PML="ucx"
export OMPI_MCA_osc="ucx"

export GRID_ALLOC_NCACHE_SMALL=16
export GRID_ALLOC_NCACHE_LARGE=2
export GRID_ALLOC_NCACHE_HUGE=0
#-------------------------------------------------------------------------------
# Path structure
#-------------------------------------------------------------------------------
sourcecode_dir=${HOME}/SwanSea/SourceCodes
bkeeper_dir=${sourcecode_dir}/BKeeper
bkeeper_build_dir=${bkeeper_dir}/build
Bench_Grid_HiRep_dir=${sourcecode_dir}/Bench_Grid_HiRep
benchmark_input_dir=${Bench_Grid_HiRep_dir}/benchmarks
#-------------------------------------------------------------------------------
# Getting the gpu select script
#-------------------------------------------------------------------------------
cat << EOF > select_gpu
#!/bin/bash

export ROCR_VISIBLE_DEVICES=\$SLURM_LOCALID
exec \$*
EOF

chmod +x ./select_gpu

CPU_BIND="mask_cpu:7e000000000000,7e00000000000000"
CPU_BIND="${CPU_BIND},7e0000,7e000000"
CPU_BIND="${CPU_BIND},7e,7e00"
CPU_BIND="${CPU_BIND},7e00000000,7e0000000000"

export OMP_NUM_THREADS=8
export MPICH_GPU_SUPPORT_ENABLED=1
#-------------------------------------------------------------------------------
# Path structure
#-------------------------------------------------------------------------------
prefix=${sourcecode_dir}/external_lib/prefix_grid_202410
#-------------------------------------------------------------------------------
# Export path and library paths
#-------------------------------------------------------------------------------
#Extending the library path
export PREFIX_HOME=$prefix
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PREFIX_HOME/lib
#-------------------------------------------------------------------------------
# Launching mechanism
#-------------------------------------------------------------------------------
#wrapper_script=${Bench_Grid_HiRep_dir}/doc/BKeeper/gpu-mpi-wrapper-new-Lumi.sh
# run! #########################################################################
# --mca pml ucx
srun --cpu-bind=${CPU_BIND} \
  ./select_gpu "${bkeeper_build_dir}"/BKeeper  \
  "${benchmark_input_dir}"/BKeeper/input_BKeeper.xml \
  --grid 32.32.32.64 \
  --mpi 1.1.1.2 \
  --accelerator-threads 8 \
  --shm 8192 \
  --device-mem 23000 \
  --log Error,Warning,Message
################################################################################
rm -rf ./select_gpu
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo `date`;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  job_BKeeper-Lumi.sh Done.                            -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
# srun --account=project_465001614 --partition=dev-g --time=00:30:00 --nodes=1 --gres=gpu:8 --pty bash
#-------------------------------------------------------------------------------
