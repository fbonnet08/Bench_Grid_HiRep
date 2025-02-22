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
#sh ./dispatcher_Grid_hiRep.sh frederic  notneeded  137.44.5.215
#-------------------------------------------------------------------------------
# [Sunbird] [scw1813, scw1019] TODO: Sunbird has issues with max_string_array
#-------------------------------------------------------------------------------
#sh ./dispatcher_Grid_hiRep.sh s.frederic.bonnet  scw1813  sunbird.swansea.ac.uk
#-------------------------------------------------------------------------------
# [Tursa]
#-------------------------------------------------------------------------------
#sh ./dispatcher_Grid_hiRep.sh  dc-bonn2  dp208  tursa.dirac.ed.ac.uk
#-------------------------------------------------------------------------------
# [Vega]
#-------------------------------------------------------------------------------
sh ./dispatcher_Grid_hiRep.sh  eufredericb  notneeded  login.vega.izum.si
#-------------------------------------------------------------------------------
# [Lumi]
#-------------------------------------------------------------------------------
sh ./dispatcher_Grid_hiRep.sh  bonnetfr  project_465001614  lumi.csc.fi
#-------------------------------------------------------------------------------
# [Leonardo]: Authentication  procedure.
#-------------------------------------------------------------------------------
# Code block comment for now as the main focus is going to be LUMI for just now

# Booster [GPU]: EUHPC_B17_015
# DCPG    [CPU]: EUHPC_B17_015_0

#: '
step ca bootstrap --ca-url=https://sshproxy.hpc.cineca.it --fingerprint 2ae1543202304d3f434bdc1a2c92eff2cd2b02110206ef06317e70c1c1735ecd
step ssh login 'fbonnet08@gmail.com' --provisioner cineca-hpc
eval "$(ssh-agent)"
step ssh login 'fbonnet08@gmail.com' --provisioner cineca-hpc
step ssh list --raw 'fbonnet08@gmail.com' | step ssh inspect

sh ./dispatcher_Grid_hiRep.sh  fbonnet0  EUHPC_B17_015_0  login.leonardo.cineca.it
#'
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


