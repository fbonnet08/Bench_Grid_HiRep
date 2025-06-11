#!/usr/bin/bash
script_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!  Code to deploy to various clusters remotely.                         !"
echo "!  $script_file_name                                                !"
echo "!  [Author]: Frederic Bonnet January 2025                               !"
echo "!  [usage]: sh deploy_to_clusters.sh                                    !"
echo "!  [example]: sh deploy_to_clusters.sh                                  !"
echo "!  [comment]: One need to put his/her username for each machine         !"
echo "!                                                                       !"
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
tput sgr0;
#colors
red="tput setaf 1"  ;green="tput setaf 2"  ;yellow="tput setaf 3"
blue="tput setaf 4" ;magenta="tput setaf 5";cyan="tput setaf 6"
white="tput setaf 7";bold=""               ;reset_colors="tput sgr0"
# Global variables
sptr="/"
#-------------------------------------------------------------------------------
# Deploying to clusters
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# [Precision-3571]
#-------------------------------------------------------------------------------
#sh ./dispatcher_Grid_HiRep.sh frederic  not_required  10.44.5.20
#-------------------------------------------------------------------------------
# [Sunbird] [scw1813, scw1019]
#-------------------------------------------------------------------------------
#sh ./dispatcher_Grid_HiRep.sh s.frederic.bonnet  scw1813  sunbird.swansea.ac.uk
#-------------------------------------------------------------------------------
# [Vega]
#-------------------------------------------------------------------------------
#sh ./dispatcher_Grid_HiRep.sh  eufredericb  not_required  login.vega.izum.si
#-------------------------------------------------------------------------------
# [Lumi]
#-------------------------------------------------------------------------------
#sh ./dispatcher_Grid_HiRep.sh  bonnetfr  project_465001614  lumi.csc.fi
#-------------------------------------------------------------------------------
# [Tursa]
#-------------------------------------------------------------------------------
sh ./dispatcher_Grid_HiRep.sh  dc-bonn2  dp208  tursa.dirac.ed.ac.uk
#-------------------------------------------------------------------------------
# [Mi300]
#-------------------------------------------------------------------------------
#sh ./dispatcher_Grid_HiRep.sh  dc-bonn2  not_required  aac6.amd.com
#-------------------------------------------------------------------------------
# [Mi210]
#-------------------------------------------------------------------------------
#sh ./dispatcher_Grid_HiRep.sh  dc-bonn2  not_required  aac1.amd.com
#-------------------------------------------------------------------------------
# [MareNostrum-5]: Authentication  procedure.
#-------------------------------------------------------------------------------
# GPU-Node
#sh ./dispatcher_Grid_HiRep.sh  swan127136  ehpc191  alogin1.bsc.es
# # CPU-Node comon file system with the gpu node
#sh ./dispatcher_Grid_HiRep.sh  swan127136  ehpc191  glogin1.bsc.es
#-------------------------------------------------------------------------------
# [Leonardo]: Authentication  procedure.
#-------------------------------------------------------------------------------
# Code block comment for now as the main focus is going to be LUMI for just now

# Booster [GPU]: EUHPC_B17_015     EUHPC_B22_046
#sh ./dispatcher_Grid_HiRep.sh  fbonnet0  EUHPC_B22_046  login.leonardo.cineca.it
# DCPG    [CPU]: EUHPC_B17_015_0   EUHPC_B22_046_0
#sh ./dispatcher_Grid_HiRep.sh  fbonnet0  EUHPC_B17_015_0  login.leonardo.cineca.it

: '
step ca bootstrap --ca-url=https://sshproxy.hpc.cineca.it --fingerprint 2ae1543202304d3f434bdc1a2c92eff2cd2b02110206ef06317e70c1c1735ecd
step ssh login 'fbonnet08@gmail.com' --provisioner cineca-hpc
eval "$(ssh-agent)"
step ssh login 'fbonnet08@gmail.com' --provisioner cineca-hpc
step ssh list --raw 'fbonnet08@gmail.com' | step ssh inspect

sh ./dispatcher_Grid_HiRep.sh  fbonnet0   EUHPC_B22_046  login.leonardo.cineca.it
'
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  deploy_to_clusters.sh Done.                          -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#exit
#-------------------------------------------------------------------------------


