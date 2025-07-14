#!/usr/bin/bash
ARGV=`basename -a $1 $2`
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
__project_account=$1
__external_lib_dir=$2
# Overall config file
source ./common_main.sh "$__external_lib_dir";
# System config file to get information from the node
source ./config_system.sh "$__project_account" "$machine_name";
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
#move_runs_to="${logged_runs_dir}/${LLR_HiRep_heatbath_input}_${timestamp}"
# ${cluster_data_disk}                 declared in config_system.sh
# ${euroHPC_call}/${previous_runs_dir} declared in common_main.sh
move_runs_to="${cluster_data_disk}/${euroHPC_call}/${previous_runs_dir}/${LLR_HiRep_heatbath_input}_${timestamp}"
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
  $white; printf "Moving directories     : ";$cyan; printf "%s\n" "$move_runs_from";
  $reset_colors;
  directory_exists "${move_runs_from}"; dir_move_runs_from_exists="$directory_exists";
  $white; printf "Target and source dir  : ";$green; printf "%s\n" "exist, moving directory ...";
  $reset_colors;
  mv "$move_runs_from" "${move_runs_to}"
else
  $white; printf "Nothing to move        : ";$cyan; printf "%s\n" "$move_runs_from"; $reset_colors;
  $white; printf "                       : ";$red;  printf "%s\n" "does not exists"; $reset_colors;
fi
#-------------------------------------------------------------------------------
# Setting the path to run directory
#-------------------------------------------------------------------------------
# Checking if the target directory exists May be removed later as not really needed
path_to_run_dir="${LatticeRuns_dir}/${Hirep_LLR_SP}/LLR_HB"
case $machine_name in
  *"Precision-3571"*)  path_to_run_dir="${cluster_data_disk}/LatticeRuns" ;;
  *"DESKTOP-GPI5ERK"*) ;;
  *"desktop-dpr4gpr"*) ;;
  *"tursa"*)           ;;
  *"sunbird"*)         ;;
  *"vega"*)            path_to_run_dir="${cluster_data_disk}/LatticeRuns" ;;
  *"lumi"*)            path_to_run_dir="${cluster_data_disk}/LatticeRuns" ;;
  *"leonardo"*)        path_to_run_dir="${cluster_data_disk}/LatticeRuns" ;;
  *"mi300"*)           ;;
  *"mi210"*)           ;;
  *"MareNostrum"*)     path_to_run_dir="${cluster_data_disk}/LatticeRuns" ;;
esac
#-------------------------------------------------------------------------------
# Secondly deflating the tar ball to target directory
#-------------------------------------------------------------------------------
# If target dir does not exiist create it
directory_exists "${path_to_run_dir}"; dir_path_to_run_dir_exists="$directory_exists";
# If the directory does not exist create it.
if [ "$dir_path_to_run_dir_exists" == "no" ]; then Batch_util_create_path "${path_to_run_dir}"; fi

# moving to the latticerun directory
cd "${LatticeRuns_dir}"

# Check again then deflate tarball to target directory
directory_exists "${path_to_run_dir}"; dir_path_to_run_dir_exists="$directory_exists";
if [ "$dir_path_to_run_dir_exists" == "yes" ]
then
  cp "${ball_llr_LatticeRuns}.gz" "${path_to_run_dir}"
  $white; printf "Moving to directory    : ";$cyan;    printf "%s\n" "$path_to_run_dir";
  $reset_colors;
  cd "${path_to_run_dir}"
  pwd
  $white; printf "Deflating tarball      : ";$cyan;    printf "%s\n" "${ball_llr_LatticeRuns_name}.gz";
  $reset_colors;
  tar xfz "${ball_llr_LatticeRuns_name}.gz"
fi

# moving back to the source directory
$white; printf "Moving to directory    : ";$cyan;    printf "%s\n" "$sourcecode_dir";
$reset_colors;
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

