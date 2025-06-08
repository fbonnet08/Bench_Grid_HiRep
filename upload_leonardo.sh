#!/bin/bash

if [ -f ~/.ssh/known_hosts ]; then rm ~/.ssh/known_hosts; fi

step ca bootstrap --ca-url=https://sshproxy.hpc.cineca.it --fingerprint 2ae1543202304d3f434bdc1a2c92eff2cd2b02110206ef06317e70c1c1735ecd

step ssh login 'fbonnet08@gmail.com' --provisioner cineca-hpc

eval "$(ssh-agent)"

step ssh login 'fbonnet08@gmail.com' --provisioner cineca-hpc
step ssh list --raw 'fbonnet08@gmail.com' | step ssh inspect

scp -r ~/data fbonnet0@login.leonardo.cineca.it:~/

