#!/usr/bin/bash
ARGV=`basename -a $1`
set -eu
scrfipt_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!     Code to deflate tar balls                                         !"
echo "!     $scrfipt_file_name                                            !"
echo "!     [Author]: Frederic Bonnet May 2025                                !"
echo "!     [usage]: deflator_tarball_HiRep-LLR-HB_Runs.sh   {Input list}      !"
echo "!     [example]: deflator_tarball_HiRep-LLR-HB_Runs.sh                   !"
echo "!                                      SwanSea/SourceCodes/external_lib !"
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
tput sgr0;
#colors
red="tput setaf 1"  ;green="tput setaf 2"  ;yellow="tput setaf 3"
blue="tput setaf 4" ;magenta="tput setaf 5";cyan="tput setaf 6"
white="tput setaf 7";bold=""               ;reset_colors="tput sgr0"
# Checking the argument list
if [ $# -ne 1 ]; then
  $white; printf "No directory specified : "; $bold;
  $red;printf " we will use the home directory ---> \n"; $green;printf "${HOME}";
  $white; $reset_colors;
  local_dir=${HOME}
else
  $white; printf "Directory specified    : "; $bold;
  $blue; printf '%s'"${1}"; $red;printf " will be the working target dir ...\n";
  $white; $reset_colors;
  local_dir=${HOME}/$1
fi
# Global variables
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
__external_lib_dir=$1
# Overall config file
source ./common_main.sh "$__external_lib_dir";
# The Batch content creators methods
source ./Scripts/Batch_Scripts/Batch_util_methods.sh;
#-------------------------------------------------------------------------------
# Creating a current time stamp
#-------------------------------------------------------------------------------
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$white; printf "Current timestamp      : ";$cyan;    printf "%s\n" "$timestamp"; $reset_colors;
#-------------------------------------------------------------------------------
# First moving the the previous runs to the appropriate place
#-------------------------------------------------------------------------------
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
for i in $(seq 0 $sleep_time)
do
  $green;ProgressBar "${i}" "${sleep_time}"; sleep 1;
done
printf "\n"

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Screening the directory and moving to it: "; $bold;
$magenta; printf "${sourcecode_dir}\n"; $white; $reset_colors;

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Launching HiRep tar ball deflator:\n"; $white; $reset_colors;

#Checking if the tar ball exists
$white; printf "Tarball name           : ";$red; printf "%s\n" "${ball_llr_LatticeRuns_name}.gz";
$reset_colors;
$white; printf "Path to tarball        : ";$red; printf "%s\n" "${ball_llr_LatticeRuns}.gz";
$reset_colors;

file_exists "${ball_llr_LatticeRuns}.gz"

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
move_runs_from="${LatticeRuns_Hirep_LLR_SP_dir}"
$white; printf "Moving previous runs   : ";$cyan;    printf "%s\n" "$move_runs_from"; $reset_colors;
directory_exists "${move_runs_from}"; dir_move_runs_from_exists="$directory_exists";
if [ "$dir_move_runs_from_exists" == "yes" ]; then ls -al "${move_runs_from}"; fi

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
move_runs_to="${logged_runs_dir}/${LLR_HiRep_heatbath_input}_${timestamp}"
$white; printf "Moving previous runs to: ";$cyan;    printf "%s\n" "$move_runs_to"; $reset_colors;
# Checking if directory exists or not
directory_exists "${move_runs_to}"; dir_move_runs_to_exists="$directory_exists";
# If the directory does not exist create it.
if [ "$dir_move_runs_to_exists" == "no" ] && [ -d "$move_runs_from" ]
then
  Batch_util_create_path "${move_runs_to}"
fi

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
if [ -d "$move_runs_from" ] && [ -d "${move_runs_to}" ]
then
  $white; printf "Moving directories     : ";$cyan;  printf "%s\n" "$move_runs_from";
  $reset_colors;
  directory_exists "${move_runs_from}"; dir_move_runs_from_exists="$directory_exists";
  $white; printf "Target and source dir  : ";$green; printf "%s\n" "exist, moving directory ...";
  $reset_colors;
  mv "$move_runs_from" "${move_runs_to}"
else
  $white; printf "Nothing to move        : ";$cyan;    printf "%s\n" "$move_runs_from"; $reset_colors;
  $white; printf "                       : ";$red;     printf "%s\n" "does not exists"; $reset_colors;
fi
#-------------------------------------------------------------------------------
# Secondly deflating the tar ball to target directory
#-------------------------------------------------------------------------------

cd "${LatticeRuns_dir}"
cp "${ball_llr_LatticeRuns}.gz" .
tar xfz "${ball_llr_LatticeRuns_name}.gz"
cd "${sourcecode_dir}"
ls -al
pwd

#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  deflator_tarball_HiRep-LLR-HB_Runs.sh Done.          -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$white; $reset_colors;
#exit
#-------------------------------------------------------------------------------

