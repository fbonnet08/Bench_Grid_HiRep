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
./Grid_HiRep_Benchmarker --benchmark --MobiusSp2f_DWF \
                          --savefreq 2                \
                          --beta 2.13                 \
                          --starttraj 0               \
                          --fermionmass 0.01          \
                          --tlen 1                    \
                          --nsteps 1                  \
                          --serialseed "1 2 3 4 5"    \
                          --parallelseed "6 7 8 9 10" \
                          --Ls 8                      \
                          --dw_mass  1.8              \
                          --mobius_b  1.5             \
                          --mobius_c  0.5             \
                          --cnfg_dir ./
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


