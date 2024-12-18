#!/usr/bin/bash
ARGV=`basename -a $1 $2`
set -eu
scrfipt_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!     Code to create the batch script                                   !"
echo "!     $scrfipt_file_name                                            !"
echo "!     [Author]: Frederic Bonnet November 2024                           !"
echo "!     [usage]: creator_bench_case_batch.sh   {Input list}               !"
echo "!     [example]: creator_bench_case_batch.sh /data/local                !"
echo "!                                                                       !"
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
tput sgr0;
#colors
red="tput setaf 1"  ;green="tput setaf 2"  ;yellow="tput setaf 3"
blue="tput setaf 4" ;magenta="tput setaf 5";cyan="tput setaf 6"
white="tput setaf 7";bold=""               ;reset_colors="tput sgr0"
# Global variables
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
__batch_action=$2
# Overall config file
source ./common_main.sh $1;
# System config file to get information from the node
source ./config_system.sh;
# The config for the batch_action needs information from the system_config call
source ./config_Run_Batchs.sh
source ./config_batch_action.sh
# The Batch content creators methods
source ./Scripts/Batch_Scripts/Batch_util_methods.sh;
source ./Scripts/Batch_Scripts/Batch_header_methods.sh
source ./Scripts/Batch_Scripts/Batch_body_methods.sh
# Batch file out constructor variable
__batch_file_out=${batch_Scripts_dir}/"Run_${__batch_action}.sh"
#-------------------------------------------------------------------------------
# Getting the slurm values for the batch job
#-------------------------------------------------------------------------------
# Function defined in ./config_batch_action.sh
case $__batch_action in
  *"Sombrero_weak"*)        config_Batch_Sombrero_weak_cpu    ;;
  *"Sombrero_strong"*)      config_Batch_Sombrero_strong_cpu  ;;
  *"BKeeper_run_cpu"*)      config_Batch_BKeeper_run_cpu      ;;
  *"BKeeper_run_gpu"*)      config_Batch_BKeeper_run_gpu      ;;
  *"HiRep-LLR-master-cpu"*) config_Batch_HiRep-LLR-master_cpu ;;
  *"HiRep-LLR-master-gpu"*) config_Batch_HiRep-LLR-master_gpu ;;
  *"BKeeper_compile"*)      config_Batch_BKeeper_compile_cpu  ;;
  *)
    echo
    $red; printf "The batch action is either incorrect or missing: \n";
    $yellow; printf "[BKeeper_compile, BKeeper_run, Sombrero_weak, Sombrero_strong,";
             printf " HiRep-LLR-master-cpu]\n";
    $cyan; printf "[try: bash -s < ./creator_batch.sh SwanSea/SourceCodes/external_lib BKeeper_compile]\n"; $reset_colors;
    read -p "Would you like to continue (yes/no): " continue;
    if [[ $continue =~ "yes" || $continue =~ "Yes" ]]
    then
      config_Batch_default;
    else
      $red;printf "Exiting, try again with the correct batch action.\n"; $reset_colors;
      echo
      echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
      $cyan; echo `date`; $reset_colors;
      echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
      exit;
    fi
    ;;
esac
#-------------------------------------------------------------------------------
# Now creating the batch script for a case in question
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
#ls -al

echo "machine name ----> $machine_name"
echo "module list  ----> $module_list"
echo "batch action ----> $__batch_action"
echo "batch file   ----> $__batch_file_out"
echo "qos          ----> $_qos"

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Creating batch file for batch action: ";
$magenta;printf "$__batch_action\n"; $white; $reset_colors;

#sbatch Run_BKeeper.sh > out_launcher_bench_BKeeper.log &
$green; printf "Creating the Batch script from the methods: "; $bold;
$cyan; printf "$__batch_file_out\n"; $white; $reset_colors;

cat << EOF > $__batch_file_out
$(Batch_header ${_nodes} ${_ntask} ${_ntasks_per_node} ${_cpus_per_task} ${_partition} ${_job_name} ${_time} ${_qos})
$(
case $__batch_action in
  *"Sombrero_weak"*)        echo "#---> this is a Sombrero_weak job run"        ;;
  *"Sombrero_strong"*)      echo "#---> this is a Sombrero_strong job run"      ;;
  *"BKeeper"*)              echo "#---> this is a BKeeper job run"              ;;
  *"HiRep-LLR-master-cpu"*) echo "#---> this is a HiRep-LLR-master-cpu job run" ;;
  *"HiRep-LLR-master-gpu"*) echo "#---> this is a HiRep-LLR-master-gpu job run" ;;
esac
)

$module_list

EOF

case "$__batch_action" in
  *"BKeeper_compile"*)
      Batch_body_Compile_BKeeper \
      ${machine_name} ${bkeeper_dir} ${LatticeRuns_dir} \
      ${__batch_file_out} ${_job_name};;
  *"BKeeper_run_cpu"*)
      Batch_body_Run_BKeeper_cpu \
      ${machine_name} ${bkeeper_dir} ${LatticeRuns_dir} ${benchmark_input_dir} \
      ${__batch_file_out} ${_job_name};;
  *"BKeeper_run_gpu"*)
      Batch_body_Run_BKeeper_gpu \
      ${machine_name} ${bkeeper_dir} ${LatticeRuns_dir} ${benchmark_input_dir} \
      ${__batch_file_out} ${_job_name};;
  *"Sombrero_weak"*)
      Batch_body_Run_Sombrero_weak \
      ${machine_name} ${sombrero_dir} ${LatticeRuns_dir} \
      ${__batch_file_out} ${_job_name};;
  *"Sombrero_strong"*)
      Batch_body_Run_Sombrero_strong \
      ${machine_name} ${sombrero_dir} ${LatticeRuns_dir} \
      ${__batch_file_out} ${_job_name};;
  *"HiRep-LLR-master-cpu"*)
      Batch_body_Run_HiRep-LLR-master-cpu \
      ${machine_name} ${HiRep_LLR_master_HMC_dir} ${LatticeRuns_dir} \
      ${__batch_file_out} ${_job_name};;
  *"HiRep-LLR-master-gpu"*)
      #TODO: insert the method for the gpu batch script creation
      ;;
esac

echo "core_count --->: $_core_count"
echo "mem_total  --->: $_mem_total"
echo "gpu_count  --->: $_gpu_count"

#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  creator_bench_case_batch.sh Done.                    -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$reset_colors
#exit
#-------------------------------------------------------------------------------
