#!/bin/bash

if [ -f ~/.ssh/known_hosts ]; then rm ~/.ssh/known_hosts; fi

step ca bootstrap --ca-url=https://sshproxy.hpc.cineca.it --fingerprint 2ae1543202304d3f434bdc1a2c92eff2cd2b02110206ef06317e70c1c1735ecd

step ssh login 'fbonnet08@gmail.com' --provisioner cineca-hpc

eval "$(ssh-agent)"

step ssh login 'fbonnet08@gmail.com' --provisioner cineca-hpc
step ssh list --raw 'fbonnet08@gmail.com' | step ssh inspect

scp -r fbonnet0@login.leonardo.cineca.it:/leonardo_work/EUHPC_B22_046_0/LatticeRuns/Hirep_LLR_SP_07Jun25.tar.gz \
                                          /mnt/d/EHPC-BEN-2025B03-046/LatticeRuns/Clusters/Leonardo/LatticeRuns

#~/Downloads/Globus-Downloads/
