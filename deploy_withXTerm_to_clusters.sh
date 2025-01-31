#!/usr/bin/bash
scrfipt_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!  Code to deploy to various clusters remotely.                         !"
echo "!  $scrfipt_file_name                                                !"
echo "!  [Author]: Frederic Bonnet January 2025                               !"
echo "!  [usage]: sh deploy_withXTerm_to_clusters.sh                          !"
echo "!  [example]: sh deploy_withXTerm_to_clusters.sh                        !"
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
# bash -s < ./dispatcher_Grid_hiRep.sh s.frederic.bonnet sunbird.swansea.ac.uk
#-------------------------------------------------------------------------------
# TODO: put the username as input in the ARGV=`basename -a $1` at later stage
#-------------------------------------------------------------------------------
# [Sunbird]
#-------------------------------------------------------------------------------
#xterm -bg black -fg white -cr red -geometry 120x70  -e "sh ./dispatcher_Grid_hiRep.sh  s.frederic.bonnet  sunbird.swansea.ac.uk" &
#xterm -bg black -fg white -cr red -geometry 120x70  -e "sh ./dispatcher_Grid_hiRep.sh  eufredericb        login.vega.izum.si" &
#-------------------------------------------------------------------------------
# [Lumi]
#-------------------------------------------------------------------------------
#xterm -bg black -fg white -cr red -geometry 120x70  -e "sh ./dispatcher_Grid_hiRep.sh  bonnetfr           lumi.csc.fi" &
#-------------------------------------------------------------------------------
# [Leonardo]: Authentication  procedure.
#-------------------------------------------------------------------------------
xterm -bg black -fg white -cr red -geometry 120x70  -e "sh ./dispatcher_Grid_hiRep.sh  fbonnet0           login.leonardo.cineca.it" &

#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  deploy_withXTerm_to_clusters.sh Done.                -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#exit
#-------------------------------------------------------------------------------


