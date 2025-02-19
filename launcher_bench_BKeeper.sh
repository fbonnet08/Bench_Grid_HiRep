#!/usr/bin/bash
ARGV=`basename -a $1 $2`
set -eu
scrfipt_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!     Code to launch BKeeper benchmarker                                !"
echo "!     $scrfipt_file_name                                            !"
echo "!     [Author]: Frederic Bonnet November 2024                           !"
echo "!     [usage]: launcher_bench_BKeeper.sh   {Input list}                 !"
echo "!     [example]: launcher_bench_BKeeper.sh /data/local                  !"
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
$green; printf "Launching BKeeper benchmark dir:\n"; $white; $reset_colors;

case "$__batch_action" in
  *"BKeeper_compile"*)
      sbatch $batch_Scripts_dir/Run_BKeeper_compile.sh \
              > $LatticeRuns_dir/out_launcher_run_BKeeper_compile.log &
      ;;
  *"BKeeper_run_cpu"*)
      ;;
  *"BKeeper_run_gpu"*)
      #sbatch $batch_Scripts_dir/Run_BKeeper_run_gpu.sh \
      #        > $LatticeRuns_dir/out_launcher_run_BKeeper_run_gpu.log &
      # TODO: need to fix the simulation size and pass it into the argument list?
      declare -a simulations_type_array=("small" "large")

      # Initializing the file names to an initial value: empty
      target_file_BKeeper_gpu_small="empty"
      target_file_BKeeper_gpu_large="empty"
      for k in $(seq 0 `expr ${#simulations_type_array[@]} - 1`)
      do
        printf "simulations_type_array[$k]} ----> ${simulations_type_array[k]} ----> "

        simulation_size=${simulations_type_array[k]}
        case $simulation_size in
          *"small"*)
            target_file_BKeeper_gpu_small="${LatticeRuns_dir}"/"${target_BKeeper_run_gpu_small_batch_files}"
            find "${LatticeRuns_dir}/" -type f -name "*Run_BKeeper_run_gpu*node*small.sh" \
                  > "$target_file_BKeeper_gpu_small"
          ;;
          *"large"*)
            target_file_BKeeper_gpu_large="${LatticeRuns_dir}"/"${target_BKeeper_run_gpu_large_batch_files}"
            find "${LatticeRuns_dir}/" -type f -name "*Run_BKeeper_run_gpu*node*large.sh" \
                  > "$target_file_BKeeper_gpu_large"
          ;;
        esac
        printf "${target_file_BKeeper_gpu_small} <--::--> ${target_file_BKeeper_gpu_large}\n"
      done
      ;;
esac
#-------------------------------------------------------------------------------
# Method to launch batch jobs from a given target file
#-------------------------------------------------------------------------------
# Submitting method in:./Scripts/Batch_Scripts/Batch_util_methods.sh;
Batch_submit_target_file_list_to_queue "${target_file_BKeeper_gpu_small}"      \
                                       "${max_number_submitted_batch_scripts}"

#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  launcher_bench_BKeeper.sh Done.                      -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#exit
#-------------------------------------------------------------------------------
