#!/bin/bash
#SBATCH --job-name test_hirep
#SBATCH --qos standard
#SBATCH --partition=gpu
#SBATCH --time 24:00:00
#SBATCH --account dp208
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:4
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err

module purge
module use /mnt/lustre/tursafs1/apps/cuda-12.3-modulefiles/
module load cuda/12.3 openmpi/4.1.5-cuda12.3 ucx/1.15.0-cuda12.3

export OMPI_MCA_btl=^uct,openib
export UCX_TLS=gdr_copy,rc,rc_x,sm,cuda_copy,cuda_ipc
export UCX_RNDV_SCHEME=get_zcopy
export UCX_RNDV_THRESH=16384
export UCX_IB_GPU_DIRECT_RDMA=yes
export UCX_MEMTYPE_CACHE=n

srun ../hmc \
  -i input_file_${SLURM_JOB_NUM_NODES}nodes \
  -o out_hmc_${SLURM_JOB_PARTITION}_${SLURM_JOB_NUM_NODES}nodes_${SLURM_GPU_FREQ}hz_${SLURM_JOBID}



