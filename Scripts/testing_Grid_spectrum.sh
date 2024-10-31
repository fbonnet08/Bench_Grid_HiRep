#!/bin/bash
#SBATCH --job-name spectrum
#SBATCH --qos standard
#SBATCH --time 48:00:00
#SBATCH --account dp208
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=8
#SBATCH --partition=gpu-a100-80
#SBATCH --gres=gpu:4
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err

module purge
module load /home/y07/shared/tursa-modules/setup-env
module load cuda/12.3 openmpi/4.1.5-cuda12.3 ucx/1.15.0-cuda12.3 gcc/9.3.0

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${HOME}/prefix-gmp/lib:/home/dp208/dp208/dc-bonn2/prefix-dwf/lib

export OMP_NUM_THREADS=4
export OMPI_MCA_btl=^uct,openib
export UCX_TLS=gdr_copy,rc,rc_x,sm,cuda_copy,cuda_ipc
export UCX_RNDV_SCHEME=put_zcopy
export UCX_RNDV_THRESH=16384
export UCX_IB_GPU_DIRECT_RDMA=yes
export UCX_MEMTYPE_CACHE=n

VOL=48.48.48.96
MPI=2.2.1.4

EXE=${HOME}/src/path/to/some/executable
WRAPPER=/home/dp208/dp208/shared/wrappersimple.sh

mpirun -np ${SLURM_NTASKS} -x LD_LIBRARY_PATH \
    --bind-to none \
    ${WRAPPER} ${EXE} \
    --grid ${VOL} --mpi ${MPI} \
    --accelerator-threads 8 \
    --device-mem 50000 \
    --shm 8192 > hadrons_${SLURM_JOB_ID}.out