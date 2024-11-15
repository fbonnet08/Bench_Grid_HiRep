#!/usr/bin/bash
ARGV=`basename -a $1`
set -eu
scrfipt_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!     Code to launch Sombrero Strong benchmarker                        !"
echo "!     $scrfipt_file_name                                            !"
echo "!     [Author]: Frederic Bonnet November 2024                           !"
echo "!     [usage]: launcher_bench_Sombrero_Strong.sh   {Input list}         !"
echo "!     [example]: launcher_bench_Sombrero_Strong.sh /data/local          !"
echo "!                                                                       !"
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
tput sgr0;
#colors
red="tput setaf 1"  ;green="tput setaf 2"  ;yellow="tput setaf 3"
blue="tput setaf 4" ;magenta="tput setaf 5";cyan="tput setaf 6"
white="tput setaf 7";bold=""               ;reset_colors="tput sgr0"
# Global variables
sleep_time=2
#Functions
ProgressBar (){
    _percent=$(awk -vp=$1 -vq=$2 'BEGIN{printf "%0.2f", p*100/q*100/100}')
    _progress=$(awk -vp=$_percent 'BEGIN{printf "%i", p*4/10}')
    _remainder=$(awk -vp=$_progress 'BEGIN{printf "%i", 40-p}')
    _completed=$(printf "%${_progress}s" )
    _left=$(printf "%${_remainder}s"  )
    printf "\rProgress : [-$_completed#$_left-] ";tput setaf 4; tput bold; printf "[= ";
    tput sgr0; tput setaf 6; printf "$1";
    tput sgr0; tput setaf 4; tput bold;printf " <---> ";
    tput sgr0; tput setaf 6; tput bold;printf "(secs)";
    tput sgr0; tput setaf 2; tput bold; printf " ${_percent}%%"
    tput setaf 4; tput bold; printf " =]"
    tput sgr0
}
# Checking the argument list
if [ $# -ne 1 ]; then
  $white; printf "No directory specified : "; $bold;
  $red;printf " we will use the home directory ---> \n";
  $green;printf "${HOME}"; $white; $reset_colors;
  local_dir=${HOME}
else
  $white; printf "Directory specified    : "; $bold;
  $blue; printf '%s'"${1}"; $red;printf " will be the working target dir ...\n";
  $white; $reset_colors;
  local_dir=${HOME}/$1
fi
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------

source ./common_main.sh $1;

#-------------------------------------------------------------------------------
# Now compiling Sombrero
#-------------------------------------------------------------------------------
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
for i in $(seq 0 $sleep_time)
do
  $green;ProgressBar "${i}" "${sleep_time}"; sleep 1;
done
printf "\n"

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Moving Scripts/Batch_Scripts dir and submitting job: "; $bold;
$magenta; printf "${batch_Scripts_dir}\n"; $white; $reset_colors;
cd ${batch_Scripts_dir}
ls -al

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Launching Sombrero Strong benchmark dir: "; $bold;

# TODO: create the automated launching for the jobs using Sombrero Strong case,
# TODO: create loop here for the different cases.

sbatch Run_Sombrero_Strong.sh > out_launcher_bench_Sombrero_Strong.log &

#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  launcher_bench_Sombrero_Strong.sh Done.              -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#exit
#-------------------------------------------------------------------------------
