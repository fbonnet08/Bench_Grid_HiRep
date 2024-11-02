#!/usr/bin/bash

# Testing the Vega connection
ssh -t eufredericb@login.vega.izum.si "
    source /etc/profile.d/modules.sh ; \
    source /ceph/hpc/software/cvmfs_env.sh ; \
    module list ; \
    module load CUDA/12.3.0 OpenMPI/4.1.5-GCC-12.3.0 UCX/1.15.0-GCCcore-12.3.0 GCC/12.3.0 ; \
    module list
"

# testing the Tursa connection
ssh -t dc-bonn2@tursa.dirac.ed.ac.uk "
    source /etc/profile.d/modules.sh; \
    module load /mnt/lustre/tursafs1/home/y07/shared/tursa-modules/setup-env; \
    module list; \
    module load cuda/12.3 openmpi/4.1.5-cuda12.3 ucx/1.15.0-cuda12.3 gcc/9.3.0; \
    module list;
"

# Testing the Sunbird connection
ssh -t s.frederic.bonnet@sunbird.swansea.ac.uk "
    source /etc/profile.d/modules.sh; \
    module load /mnt/lustre/tursafs1/home/y07/shared/tursa-modules/setup-env; \
    module list; \
    module module load CUDA/11.7 compiler/gnu/11/3.0; \
    module list;
"

