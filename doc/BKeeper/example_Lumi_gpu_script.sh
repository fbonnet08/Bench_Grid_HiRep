#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2050,SC2170
## This set of slurm settings assumes that the AMD chips are using bios setting NPS4 (4 mpi taks per socket).
###SBATCH --qos=standard
####SBATCH -A eufredericb

# srun --account=project_465001614 --partition=dev-g --time=00:30:00 --nodes=1 --gres=gpu:8 --pty bash

# --------------------------------------------------------------------
#!/bin/bash -l
#SBATCH --job-name=examplejob   # Job name
#SBATCH --output=examplejob.o%j # Name of stdout output file
#SBATCH --error=examplejob.e%j  # Name of stderr error file
#SBATCH --partition=standard-g  # partition name
#SBATCH --nodes=2               # Total number of nodes
#SBATCH --ntasks-per-node=8     # 8 MPI ranks per node, 16 total (2x8)
#SBATCH --gpus-per-node=8       # Allocate one gpu per MPI rank
#SBATCH --time=1-12:00:00       # Run time (d-hh:mm:ss)
#SBATCH --account=project_<id>  # Project for billing

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

export OMP_NUM_THREADS=6
export MPICH_GPU_SUPPORT_ENABLED=1

srun --cpu-bind=${CPU_BIND} ./select_gpu <executable> <args>
rm -rf ./select_gpu
# --------------------------------------------------------------------
