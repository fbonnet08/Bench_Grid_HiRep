#!/usr/bin/bash

# Testing the Sunbird connection
ssh -t s.frederic.bonnet@sunbird.swansea.ac.uk "
    source /etc/profile.d/modules.sh; \
    module load /mnt/lustre/tursafs1/home/y07/shared/tursa-modules/setup-env; \
    module list; \
    module module load CUDA/11.7 compiler/gnu/11/3.0; \
    module list;
"
