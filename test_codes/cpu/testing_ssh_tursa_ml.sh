#!/usr/bin/bash

# testing the Tursa connection
ssh -t dc-bonn2@tursa.dirac.ed.ac.uk "
    source /etc/profile.d/modules.sh; \
    module load /mnt/lustre/tursafs1/home/y07/shared/tursa-modules/setup-env; \
    module list; \
    module load cuda/12.3 openmpi/4.1.5-cuda12.3 ucx/1.15.0-cuda12.3 gcc/9.3.0; \
    module list;
"

