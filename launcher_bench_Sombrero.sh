#!/usr/bin/bash
ARGV=`basename -a $1 $2`
set -eu
scrfipt_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!     Code to launch Sombrero Weak benchmarker                          !"
echo "!     $scrfipt_file_name                                            !"
echo "!     [Author]: Frederic Bonnet November 2024                           !"
echo "!     [usage]: launcher_bench_Sombrero_Weak.sh   {Input list}           !"
echo "!     [example]: launcher_bench_Sombrero_Weak.sh /data/local            !"
echo "!                                                                       !"
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
tput sgr0;
#colors
red="tput setaf 1"  ;green="tput setaf 2"  ;yellow="tput setaf 3"
blue="tput setaf 4" ;magenta="tput setaf 5";cyan="tput setaf 6"
white="tput setaf 7";bold=""               ;reset_colors="tput sgr0"
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
# Global variables
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
__external_lib_dir=$1
__batch_action=$2
# Overall config file
source ./common_main.sh "$__external_lib_dir";
# The Batch content creators methods
source ./Scripts/Batch_Scripts/Batch_util_methods.sh;
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
$green; printf "Screening the directory and moving to it: "; $bold;
$magenta; printf "${LatticeRuns_dir}\n"; $white; $reset_colors;
cd ${LatticeRuns_dir}
ls -al

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Launching Sombrero Weak benchmark dir:\n"; $white; $reset_colors;

# TODO: create the automated launching for the jobs using Sombrero Strong case,
# TODO: need to fix the simulation size and pass it into the argument list?

declare -a simulations_type_array=("small" "large")

case "$__batch_action" in
  *"Sombrero_weak"*)
      # Initializing the file names to an initial value: empty
      target_Sombrero_weak_cpu_small="empty"
      target_Sombrero_weak_cpu_large="empty"
      for k in $(seq 0 `expr ${#simulations_type_array[@]} - 1`)
      do
        printf "simulations_type_array[$k]} ----> ${simulations_type_array[k]} ----> "
        simulation_size=${simulations_type_array[k]}
        case $simulation_size in
          *"small"*)
            target_Sombrero_weak_cpu_small="${LatticeRuns_dir}"/"${target_Sombrero_weak_cpu_small_batch_files}"
            find "${LatticeRuns_dir}/" -type f -name "*Run_Sombrero_weak*node*small.sh" \
                  > "$target_Sombrero_weak_cpu_small"
          ;;
          *"large"*)
            target_Sombrero_weak_cpu_large="${LatticeRuns_dir}"/"${target_Sombrero_weak_cpu_large_batch_files}"
            find "${LatticeRuns_dir}/" -type f -name "*Run_Sombrero_weak*node*large.sh" \
                  > "$target_Sombrero_weak_cpu_large"
          ;;
        esac
        printf "${target_Sombrero_weak_cpu_small} <--::--> ${target_Sombrero_weak_cpu_large}\n"
      done
      #-------------------------------------------------------------------------------
      # Method to launch batch jobs from a given target file
      #-------------------------------------------------------------------------------
      # Submitting method in:./Scripts/Batch_Scripts/Batch_util_methods.sh;
      Batch_submit_target_file_list_to_queue  "${target_Sombrero_weak_cpu_small}"      \
                                              "${max_number_submitted_batch_scripts}"
      Batch_submit_target_file_list_to_queue  "${target_Sombrero_weak_cpu_large}"      \
                                              "${max_number_submitted_batch_scripts}"
      #-------------------------------------------------------------------------------
      ;;
  *"Sombrero_strong"*)
      # Initializing the file names to an initial value: empty
      target_Sombrero_strg_cpu_small="empty"
      target_Sombrero_strg_cpu_large="empty"
      for k in $(seq 0 `expr ${#simulations_type_array[@]} - 1`)
      do
        printf "simulations_type_array[$k]} ----> ${simulations_type_array[k]} ----> "
        simulation_size=${simulations_type_array[k]}
        case $simulation_size in
          *"small"*)
            target_Sombrero_strg_cpu_small="${LatticeRuns_dir}"/"${target_Sombrero_strg_cpu_small_batch_files}"
            find "${LatticeRuns_dir}/" -type f -name "*Run_Sombrero_strong*node*small.sh" \
                  > "$target_Sombrero_strg_cpu_small"
          ;;
          *"large"*)
            target_Sombrero_strg_cpu_large="${LatticeRuns_dir}"/"${target_Sombrero_strg_cpu_large_batch_files}"
            find "${LatticeRuns_dir}/" -type f -name "*Run_Sombrero_strong*node*large.sh" \
                  > "$target_Sombrero_strg_cpu_large"
          ;;
        esac
        printf "${target_Sombrero_strg_cpu_small} <--::--> ${target_Sombrero_strg_cpu_large}\n"
      done
      #-------------------------------------------------------------------------------
      # Method to launch batch jobs from a given target file
      #-------------------------------------------------------------------------------
      Batch_submit_target_file_list_to_queue  "${target_Sombrero_strg_cpu_small}"      \
                                              "${max_number_submitted_batch_scripts}"
      Batch_submit_target_file_list_to_queue  "${target_Sombrero_strg_cpu_large}"      \
                                              "${max_number_submitted_batch_scripts}"
      #-------------------------------------------------------------------------------
      ;;
esac
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  launcher_bench_Sombrero_Weak.sh Done.                -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$reset_colors
#exit
#-------------------------------------------------------------------------------
