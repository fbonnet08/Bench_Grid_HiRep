#!/bin/bash
#SBATCH --job-name dwf_test
#SBATCH --qos standard
#SBATCH --time 1-23:59:00
#SBATCH --account dp208
#SBATCH --nodes=4
#SBATCH --ntasks=16
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=8
#SBATCH --partition=gpu
#SBATCH --gres=gpu:4
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --mail-type=BEGIN,END,FAIL

module purge
module load /home/y07/shared/tursa-modules/setup-env
module load gcc cuda/11.4.1 openmpi/4.1.1-cuda11.4.1 ucx/1.12.0-cuda11.4.1

export prefix=/home/dp208/dp208/dc-forz1/new_prefix
export LD_LIBRARY_PATH=${prefix}/lib:${LD_LIBRARY_PATH}

export OMP_NUM_THREADS=4
export OMPI_MCA_btl=^uct,openib
export UCX_TLS=gdr_copy,rc,rc_x,sm,cuda_copy,cuda_ipc
export UCX_RNDV_SCHEME=put_zcopy
export UCX_RNDV_THRESH=16384
export UCX_IB_GPU_DIRECT_RDMA=yes
export UCX_MEMTYPE_CACHE=n

VOL=24.24.24.32
MPI=2.2.1.4
TRAJECTORIES=100000
MASS=0.10
#MASS=100
NSTEPS=27
SAVEFREQ=10
BETA=6.9
TLEN=1
DWF_MASS=1.8
MOBIUS_B=1.5
MOBIUS_C=0.5
Ls=18
STARTTRAJ=$(ls -rt ./dwf_trials_verybigR1/ckpoint_EODWF_lat.*[^k] | tail -1 | sed -E 's/.*[^0-9]([0-9]+)$/\1/')
#STARTTRAJ=0
mpirun -np ${SLURM_NTASKS} -x LD_LIBRARY_PATH  \
    --bind-to none ./wrappersimple.sh ./MobiusFundnf2 \
    --StartingType CheckpointStart \
    --beta ${BETA} \
    --starttraj ${STARTTRAJ} \
    --tlen ${TLEN} \
    --grid ${VOL} \
    --dwf_mass ${DWF_MASS} \
    --mobius_b ${MOBIUS_B} \
    --mobius_c ${MOBIUS_C} \
    --Ls ${Ls} \
    --savefreq ${SAVEFREQ} \
    --fermionmass ${MASS} \
    --nsteps ${NSTEPS} \
    --mpi ${MPI} \
    --cnfg_dir "./dwf_trials_verybigR1" \
    --accelerator-threads 8 \
    --Trajectories ${TRAJECTORIES} \
    --Thermalizations 10000 \
    --savefreq ${SAVEFREQ} > ./dwf_trials_verybigR1/hmc_${SLURM_JOB_ID}.out
