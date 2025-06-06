#!/usr/bin/bash
ARGV=`basename -a $1 $2 $3`
set -eu
scrfipt_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!     Code to launch HiRep codes                                        !"
echo "!     $scrfipt_file_name                                            !"
echo "!     [Author]: Frederic Bonnet November 2024                           !"
echo "!     [usage]: launcher_bench_HiRep.sh   {Input list}                   !"
echo "!     [example]: launcher_bench_HiRep.sh /data/local                    !"
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
__project_account=$1
__external_lib_dir=$2
__batch_action=$3
# Overall config file
source ./common_main.sh "$__external_lib_dir";
# System config file to get information from the node
source ./config_system.sh "$__project_account" "$machine_name";
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
cd "${LatticeRuns_dir}"
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
            #-------------------------------------------------------------------
            # Method to launch batch jobs from a given target file
            #-------------------------------------------------------------------
            # Submitting method in:./Scripts/Batch_Scripts/Batch_util_methods.sh;
            Batch_submit_target_file_list_to_queue "${target_file_BKeeper_gpu_small}"      \
                                                    "${max_number_submitted_batch_scripts}"
            printf "${target_file_BKeeper_gpu_small} <--::--> ${target_file_BKeeper_gpu_large}\n"
            #-------------------------------------------------------------------
          ;;
          *"large"*)
            target_file_BKeeper_gpu_large="${LatticeRuns_dir}"/"${target_BKeeper_run_gpu_large_batch_files}"
            find "${LatticeRuns_dir}/" -type f -name "*Run_BKeeper_run_gpu*node*large.sh" \
                  > "$target_file_BKeeper_gpu_large"
            #-------------------------------------------------------------------
            # Method to launch batch jobs from a given target file
            #-------------------------------------------------------------------
            # Submitting method in:./Scripts/Batch_Scripts/Batch_util_methods.sh;
            Batch_submit_target_file_list_to_queue "${target_file_BKeeper_gpu_large}"      \
                                                    "${max_number_submitted_batch_scripts}"
            printf "${target_file_BKeeper_gpu_small} <--::--> ${target_file_BKeeper_gpu_large}\n"
            #-------------------------------------------------------------------
          ;;
        esac
      done
      ;;
    *"Bench_LLR_HB_run_cpu"*)
      pwd
      # First look for directory in LLR_HB directory.
      #target_directories_LLR_HiRep_HB_run_cpu="${LatticeRuns_dir}"/"${target_LLR_HiRep_HB_run_cpu_directories}"
      path_to_run_dir="${cluster_data_disk}/LatticeRuns"
      target_directories_LLR_HiRep_HB_run_cpu="${path_to_run_dir}"/"${target_LLR_HiRep_HB_run_cpu_directories}"
      #find "${LatticeRuns_Hirep_LLR_SP_dir}/LLR_HB/" \
      #        -maxdepth 1 -type d -name "Run_*"   \
      #        > "${target_directories_LLR_HiRep_HB_run_cpu}"
      find "${path_to_run_dir}/${Hirep_LLR_SP}/LLR_HB/" \
              -maxdepth 1 -type d -name "Run_*"   \
              > "${target_directories_LLR_HiRep_HB_run_cpu}"
      # Second getting the bash files in LLR_HB directory.
      #target_bash_files_LLR_HiRep_HB_run_cpu="${LatticeRuns_dir}"/"${target_LLR_HiRep_HB_run_cpu_batch_files}"
      target_bash_files_LLR_HiRep_HB_run_cpu="${path_to_run_dir}"/"${target_LLR_HiRep_HB_run_cpu_batch_files}"
      find "${path_to_run_dir}/${Hirep_LLR_SP}/LLR_HB/" \
              -type f -name "setup_llr_repeat.sh"   \
              > "${target_bash_files_LLR_HiRep_HB_run_cpu}"
      #find "${LatticeRuns_Hirep_LLR_SP_dir}/LLR_HB/" \
      #        -type f -name "setup_llr_repeat.sh"   \
      #        > "${target_bash_files_LLR_HiRep_HB_run_cpu}"
      #-------------------------------------------------------------------------
      # Method to launch batch jobs from a given target file
      #-------------------------------------------------------------------------
      # Submitting method in:./Scripts/Batch_Scripts/Batch_util_methods.sh;
      Bash_LLR_submit_target_file_list_to_queue "${target_bash_files_LLR_HiRep_HB_run_cpu}"  \
                                                "${target_directories_LLR_HiRep_HB_run_cpu}" \
                                                "${max_number_submitted_batch_scripts}"
      printf "${target_bash_files_LLR_HiRep_HB_run_cpu} <--::--> ${target_directories_LLR_HiRep_HB_run_cpu}\n"
      #-------------------------------------------------------------------------
    ;;
esac
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  launcher_bench_HiRep.sh Done.                        -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$white; $reset_colors;
#exit
#-------------------------------------------------------------------------------
