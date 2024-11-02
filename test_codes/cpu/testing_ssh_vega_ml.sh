#!/usr/bin/bash

# Testing the Vega connection
ssh -t eufredericb@login.vega.izum.si "
    source /etc/profile.d/modules.sh ; \
    source /ceph/hpc/software/cvmfs_env.sh ; \
    module list ; \
    module load CUDA/12.3.0 OpenMPI/4.1.5-GCC-12.3.0 UCX/1.15.0-GCCcore-12.3.0 GCC/12.3.0 ; \
    module list
"

