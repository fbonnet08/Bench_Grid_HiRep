#!/usr/bin/bash
ARGV=`basename -a $1 $2 $3`
set -eu
script_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!     Code to create the batch script                                   !"
echo "!     $script_file_name                                                 !"
echo "!     [Author]: Frederic Bonnet November 2024                           !"
echo "!     [usage]: creator_bench_controller_batch.sh   {Input list}         !"
echo "!     [example]: creator_bench_controller_batch.sh /data/local          !"
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
__project_account=$1
__external_lib_dir=$2
__batch_action=$3
# Overall config file
source ./common_main.sh "$__external_lib_dir";
# System config file to get information from the node
source ./config_system.sh "$__project_account" "$machine_name";
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
# Getting the slurm values for the batch job initialized
#-------------------------------------------------------------------------------
case $__batch_action in
  *"Sombrero_weak"*)          config_Batch_Sombrero_weak_cpu      ;;
  *"Sombrero_strong"*)        config_Batch_Sombrero_strong_cpu    ;;
  *"BKeeper_run_cpu"*)        config_Batch_BKeeper_run_cpu        ;;
  *"BKeeper_run_gpu"*)        config_Batch_BKeeper_run_gpu        ;;
  *"HiRep-LLR-master-cpu"*)   config_Batch_HiRep-LLR-master_cpu   ;;
  *"HiRep-LLR-master-gpu"*)   config_Batch_HiRep-LLR-master_gpu   ;;
  *"BKeeper_compile"*) bash -s < ./creator_bench_case_batch.sh \
                                         "$__project_account"  \
                                         "$__external_lib_dir" \
                                         "$__batch_action";       ;;
  *"Grid_DWF_run_gpu"*)       config_Batch_Grid_DWF_run_gpu       ;;
  *"Grid_DWF_Telos_run_gpu"*) config_Batch_Grid_DWF_Telos_run_gpu ;;
  *)
    echo
    $red; printf "The batch action is either incorrect or missing: \n";
    $yellow; printf "[BKeeper_compile, BKeeper_run, Sombrero_weak, Sombrero_strong,";
             printf " HiRep-LLR-master-cpu, HiRep-LLR-master-gpu, Grid_DWF_run_gpu, Grid_DWF_Telos_run_gpu]\n";
    $cyan; printf "[try: bash -s < ./creator_bench_case_batch.sh SwanSea/SourceCodes/external_lib BKeeper_compile]\n";
    $white; $reset_colors;
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
# Now marking a sleep_time pause and printing variables to screen
#-------------------------------------------------------------------------------
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
for i in $(seq 0 $sleep_time)
do
  $green;ProgressBar "${i}" "${sleep_time}"; sleep 1;
done
printf "Moving on ... \n"

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Moving Batch_Scripts_dir dir and creating batch scripts: "; $bold;
$magenta; printf "${batch_Scripts_dir}\n"; $white; $reset_colors;
cd ${batch_Scripts_dir}
#ls -al

echo "machine name                ----> $machine_name"
echo "module list                 ----> $module_list"
echo "batch action                ----> $__batch_action"
echo "batch file basic construct  ----> $__batch_file_out"

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Creating batch file for batch action: ";
$magenta;printf "$__batch_action\n"; $white; $reset_colors;
#-------------------------------------------------------------------------------
# Now creating the batch script for a case in question
#-------------------------------------------------------------------------------
case "$__batch_action" in
  *"Sombrero_weak"*)
    #---------------------------------------------------------------------------
    # Sombrero[Weak-Small]:
    #---------------------------------------------------------------------------
    $yellow;
    printf "#----------------------------------------------------------------\n";
    printf "# Sombrero[Weak-Small]:\n"
    printf "#----------------------------------------------------------------\n";
    $white; $reset_colors;
    #__batch_action="Sombrero_weak" #$2
    # constructing the files and directory structure
    __accelerator="cpu"
    __strength="weak"
    __simulation_size="small"
    #-------------------------------------------------------------------------------
    if [[ $machine_name = "leonardo" ]]
    then
      $cyan; printf "Switching to the configuration          ---->: "; $bold;
      $magenta; printf "${machine_name}\n"; $white; $reset_colors;
      $cyan; printf "Array elements           ntasks_per_node --->: ";
      $green; printf "${ntasks_per_node[*]}\n"; $white; $reset_colors;
      $cyan; printf "        ntasks_per_node_leonardo_special --->: ";
      $yellow;printf "${ntasks_per_node_leonardo_special[*]}\n"; $white; $reset_colors;
      ntasks_per_node=()
      for k in $(seq 0 `expr ${#ntasks_per_node_leonardo_special[@]} - 1`)
      do
        ntasks_per_node=(${ntasks_per_node[@]} ${ntasks_per_node_leonardo_special[$k]})
      done
    fi
    #-------------------------------------------------------------------------------
    H=1
    L=1
    for j in $(seq 0 `expr ${#ntasks_per_node[@]} - 1`)
    do
      if [[ ${ntasks_per_node[j]} -le ${max_cores_per_node_cpu} ]]
      then
    for i in $(seq 0 `expr ${#sombrero_small_weak_n_nodes[@]} - 1`)
    do
      cnt=$(printf "%03d" $H)
      index=$(printf "%03d" $i)
      n_nodes=$(printf "nodes%03d" ${sombrero_small_weak_n_nodes[$i]};)
      ntpn=$(printf "ntpns%03d" ${ntasks_per_node[$j]};)
      # Orchestrating the file construction
      #__batch_file_construct=$(printf "Run_${__batch_action}_${n_nodes}_${__simulation_size}")
      __batch_file_construct=$(printf "Run_${__batch_action}_${n_nodes}_${ntpn}_${__simulation_size}")
      __batch_file_out=$(printf "${__batch_file_construct}.sh")
      __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_action}/${__simulation_size}/${__batch_file_construct}")

      $cyan;printf "                       : $n_nodes, $ntpn, $__batch_file_out, $__path_to_run\n"; $reset_colors

      # Creating the path in question
      Batch_util_create_path "${__path_to_run}"

      # Now creating the Batch file: __batch_file_out in __path_to_run
      $green; printf "Creating the Batch script from the methods: "; $bold;
      $cyan; printf "$__batch_file_out\n"; $white; $reset_colors;

      # Here need to invoke the configuration method config_Batch_with_input_from_system_config
      #ntasks_per_node=$(expr "${sombrero_small_weak_n_nodes[$i]}" \* "${_core_count}")
      ntasks_per_node=${ntasks_per_node[$j]} #$(expr ${sombrero_small_weak_n_nodes[$i]} \* ${_core_count})
      config_Batch_with_input_from_system_config \
        "${sombrero_small_weak_n_nodes[$i]}"     \
        "${_core_count}"                         \
        "$ntasks_per_node"                       \
        "$gpus_per_node"                         \
        "$target_partition_cpu"                  \
        "${__batch_file_construct}"              \
        "02:00:00"                               \
        "$qos"

      # Writting the header to files
      cat << EOF > "${__path_to_run}${sptr}${__batch_file_out}"
$(Batch_header ${__path_to_run} ${__accelerator} ${__project_account} ${gpus_per_node} ${__accelerator} ${__simulation_size} ${machine_name} ${_nodes} ${_ntask} ${_ntasks_per_node} ${_cpus_per_task} ${_partition} ${_job_name} ${_time} ${_qos})
$(
      case $__batch_action in
        *"Sombrero_weak"*)        echo "#---> this is a ${__batch_file_construct} job run"        ;;
        *"Sombrero_strong"*)      echo "#---> this is a Sombrero_strong job run"      ;;
        *"BKeeper"*)              echo "#---> this is a BKeeper job run"              ;;
        *"HiRep-LLR-master-cpu"*) echo "#---> this is a HiRep-LLR-master-cpu job run" ;;
        *"HiRep-LLR-master-gpu"*) echo "#---> this is a HiRep-LLR-master-gpu job run" ;;
      esac
)

$module_list

EOF
      # Now let's get the body in for the batch file
      Batch_body_Run_Sombrero_weak                       \
            "${machine_name}"                            \
            "${sombrero_dir}"                            \
            "${LatticeRuns_dir}"                         \
            "${__path_to_run}${sptr}${__batch_file_out}" \
            "${__simulation_size}"                       \
            "${__batch_file_construct}"                  \
            "${prefix}"                                  \
            "${__path_to_run}"

      # incrementing the counter
      H=$(expr $H + 1)
    done
    fi
      L=$(expr $L + 1)
    done
    #-------------------------------------------------------------------------------
    # Sombrero[Weak-Large]:
    #-------------------------------------------------------------------------------
    $yellow;
    printf "#----------------------------------------------------------------\n";
    printf "# Sombrero[Weak-Large]:\n"
    printf "#----------------------------------------------------------------\n";
    $white; $reset_colors;
    #__batch_action="Sombrero_weak" #$2
    # constructing the files and directory structure
    __strength="weak"
    __simulation_size="large"
    #-------------------------------------------------------------------------------
    if [[ $machine_name = "leonardo" ]]
    then
      $cyan; printf "Switching to the configuration          ---->: "; $bold;
      $magenta; printf "${machine_name}\n"; $white; $reset_colors;
      $cyan; printf "Array elements           ntasks_per_node --->: ";
      $green; printf "${ntasks_per_node[*]}\n"; $white; $reset_colors;
      $cyan; printf "        ntasks_per_node_leonardo_special --->: ";
      $yellow;printf "${ntasks_per_node_leonardo_special[*]}\n"; $white; $reset_colors;
      ntasks_per_node=()
      for k in $(seq 0 `expr ${#ntasks_per_node_leonardo_special[@]} - 1`)
      do
        ntasks_per_node=(${ntasks_per_node[@]} ${ntasks_per_node_leonardo_special[$k]})
      done
    fi
    #-------------------------------------------------------------------------------
    H=1
    L=1
    for j in $(seq 0 `expr ${#ntasks_per_node[@]} - 1`)
    do
      if [[ ${ntasks_per_node[j]} -le ${max_cores_per_node_cpu} ]]
      then
    for i in $(seq 0 `expr ${#sombrero_large_weak_n_nodes[@]} - 1`)
    do
      cnt=$(printf "%03d" "$H")
      index=$(printf "%03d" "$i")
      n_nodes=$(printf "nodes%03d" "${sombrero_large_weak_n_nodes[$i]}";)
      ntpn=$(printf "ntpns%03d" "${ntasks_per_node[$j]}";)
      # Orchestrating the file construction
      #__batch_file_construct=$(printf "Run_${__batch_action}_${n_nodes}_${__simulation_size}")
      __batch_file_construct=$(printf "Run_${__batch_action}_${n_nodes}_${ntpn}_${__simulation_size}")
      __batch_file_out=$(printf "${__batch_file_construct}.sh")
      __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_action}/${__simulation_size}/${__batch_file_construct}")

      $cyan;printf "                       : $n_nodes, $ntpn, $__batch_file_out, $__path_to_run\n"; $reset_colors

      # Creating the path in question
      Batch_util_create_path "${__path_to_run}"

      # Now creating the Batch file: __batch_file_out in __path_to_run
      $green; printf "Creating the Batch script from the methods: "; $bold;
      $cyan; printf "$__batch_file_out\n"; $white; $reset_colors;

      # Here need to invoke the configuration method config_Batch_with_input_from_system_config
      #ntasks_per_node=$(expr "${sombrero_large_weak_n_nodes[$i]}" \* "${_core_count}")
      ntasks_per_node=${ntasks_per_node[$j]} #$(expr ${sombrero_small_weak_n_nodes[$i]} \* ${_core_count})
      config_Batch_with_input_from_system_config \
        "${sombrero_large_weak_n_nodes[$i]}"     \
        "${_core_count}"                         \
        "$ntasks_per_node"                       \
        "$gpus_per_node"                         \
        "$target_partition_cpu"                  \
        "${__batch_file_construct}"              \
        "01:00:00"                               \
        "$qos"

      # Writting the header to files
      cat << EOF > "${__path_to_run}${sptr}${__batch_file_out}"
$(Batch_header ${__path_to_run} ${__accelerator} ${__project_account} ${gpus_per_node} ${__accelerator} ${__simulation_size} ${machine_name} ${_nodes} ${_ntask} ${_ntasks_per_node} ${_cpus_per_task} ${_partition} ${_job_name} ${_time} ${_qos})
$(
      case $__batch_action in
        *"Sombrero_weak"*)        echo "#---> this is a ${__batch_file_construct} job run"        ;;
        *"Sombrero_strong"*)      echo "#---> this is a Sombrero_strong job run"      ;;
        *"BKeeper"*)              echo "#---> this is a BKeeper job run"              ;;
        *"HiRep-LLR-master-cpu"*) echo "#---> this is a HiRep-LLR-master-cpu job run" ;;
        *"HiRep-LLR-master-gpu"*) echo "#---> this is a HiRep-LLR-master-gpu job run" ;;
      esac
)

$module_list

EOF
      # Now let's get the body in for the batch file
      Batch_body_Run_Sombrero_weak \
      "${machine_name}" "${sombrero_dir}" "${LatticeRuns_dir}" "${__path_to_run}${sptr}${__batch_file_out}" \
      "${__simulation_size}" "${__batch_file_construct}" "${prefix}" "${__path_to_run}"

      # incrementing the counter
      H=$(expr $H + 1)
    done
    fi
      L=$(expr $L + 1)
    done
      ;;
  *"Sombrero_strong"*)
    #-------------------------------------------------------------------------------
    # Sombrero[Strong-Small]:
    #-------------------------------------------------------------------------------
    $yellow;
    printf "#----------------------------------------------------------------\n";
    printf "# Sombrero[Strong-Small]:\n"
    printf "#----------------------------------------------------------------\n";
    $white; $reset_colors;
    # constructing the files and directory structure
    __accelerator="cpu"
    __strength="strong"
    __simulation_size="small"
    #-------------------------------------------------------------------------------
    if [[ $machine_name = "leonardo" ]]
    then
      $cyan; printf "Switching to the configuration          ---->: "; $bold;
      $magenta; printf "${machine_name}\n"; $white; $reset_colors;
      $cyan; printf "Array elements           ntasks_per_node --->: ";
      $green; printf "${ntasks_per_node[*]}\n"; $white; $reset_colors;
      $cyan; printf "        ntasks_per_node_leonardo_special --->: ";
      $yellow;printf "${ntasks_per_node_leonardo_special[*]}\n"; $white; $reset_colors;
      ntasks_per_node=()
      for k in $(seq 0 `expr ${#ntasks_per_node_leonardo_special[@]} - 1`)
      do
        ntasks_per_node=(${ntasks_per_node[@]} ${ntasks_per_node_leonardo_special[$k]})
      done
    fi
    #-------------------------------------------------------------------------------
    H=1
    L=1
    for j in $(seq 0 `expr ${#ntasks_per_node[@]} - 1`)
    do
      if [[ ${ntasks_per_node[j]} -le ${max_cores_per_node_cpu} ]]
      then
    for i in $(seq 0 `expr ${#sombrero_small_strong_n_nodes[@]} - 1`)
    do
      cnt=$(printf "%03d" "$H")
      index=$(printf "%03d" "$i")
      n_nodes=$(printf "nodes%03d" "${sombrero_small_strong_n_nodes[$i]}";)
      ntpn=$(printf "ntpns%03d" "${ntasks_per_node[$j]}";)
      # Orchestrating the file construction
      #__batch_file_construct=$(printf "Run_${__batch_action}_${n_nodes}_${__simulation_size}")
      __batch_file_construct=$(printf "Run_${__batch_action}_${n_nodes}_${ntpn}_${__simulation_size}")
      __batch_file_out=$(printf "${__batch_file_construct}.sh")
      __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_action}/${__simulation_size}/${__batch_file_construct}")

      $cyan;printf "                       : $n_nodes, $ntpn, $__batch_file_out, $__path_to_run\n"; $reset_colors

      # Creating the path in question
      Batch_util_create_path "${__path_to_run}"

      # Now creating the Batch file: __batch_file_out in __path_to_run
      $green; printf "Creating the Batch script from the methods: "; $bold;
      $cyan; printf "$__batch_file_out\n"; $white; $reset_colors;

      # Here need to invoke the configuration method config_Batch_with_input_from_system_config
      #ntasks_per_node=$(expr ${sombrero_small_strong_n_nodes[$i]} \* ${_core_count})
      ntasks_per_node=${ntasks_per_node[$j]} #$(expr ${sombrero_small_weak_n_nodes[$i]} \* ${_core_count})
      config_Batch_with_input_from_system_config \
        "${sombrero_small_strong_n_nodes[$i]}"   \
        "${_core_count}"                         \
        "$ntasks_per_node"                       \
        "$gpus_per_node"                         \
        "$target_partition_cpu"                  \
        "${__batch_file_construct}"              \
        "02:00:00"                               \
        "$qos"

      # Writting the header to files
      cat << EOF > "${__path_to_run}${sptr}${__batch_file_out}"
$(Batch_header ${__path_to_run} ${__accelerator} ${__project_account} ${gpus_per_node} ${__accelerator} ${__simulation_size} ${machine_name} ${_nodes} ${_ntask} ${_ntasks_per_node} ${_cpus_per_task} ${_partition} ${_job_name} ${_time} ${_qos})
$(
      case $__batch_action in
        *"Sombrero_weak"*)        echo "#---> this is a ${__batch_file_construct} job run"  ;;
        *"Sombrero_strong"*)      echo "#---> this is a ${__batch_file_construct} run"      ;;
        *"BKeeper"*)              echo "#---> this is a BKeeper job run"                    ;;
        *"HiRep-LLR-master-cpu"*) echo "#---> this is a HiRep-LLR-master-cpu job run"       ;;
        *"HiRep-LLR-master-gpu"*) echo "#---> this is a HiRep-LLR-master-gpu job run"       ;;
      esac
)

$module_list

EOF
      # Constructing the rest of the batch file body
      Batch_body_Run_Sombrero_strong               \
      "${machine_name}"                            \
      "${sombrero_dir}"                            \
      "${LatticeRuns_dir}"                         \
      "${__path_to_run}${sptr}${__batch_file_out}" \
      "${__simulation_size}"                       \
      "${__batch_file_construct}"                  \
      "${prefix}"                                  \
      "${__path_to_run}"

      # incrementing the counter
      H=$(expr $H + 1)
    done
    fi
      L=$(expr $L + 1)
    done
    #-------------------------------------------------------------------------------
    # Sombrero[Strong-Large]:
    #-------------------------------------------------------------------------------
    $yellow;
    printf "#----------------------------------------------------------------\n";
    printf "# Sombrero[Strong-Large]:\n"
    printf "#----------------------------------------------------------------\n";
    $white; $reset_colors;
    # constructing the files and directory structure
    __strength="strong"
    __simulation_size="large"
    #-------------------------------------------------------------------------------
    if [[ $machine_name = "leonardo" ]]
    then
      $cyan; printf "Switching to the configuration          ---->: "; $bold;
      $magenta; printf "${machine_name}\n"; $white; $reset_colors;
      $cyan; printf "Array elements           ntasks_per_node --->: ";
      $green; printf "${ntasks_per_node[*]}\n"; $white; $reset_colors;
      $cyan; printf "        ntasks_per_node_leonardo_special --->: ";
      $yellow;printf "${ntasks_per_node_leonardo_special[*]}\n"; $white; $reset_colors;
      ntasks_per_node=()
      for k in $(seq 0 `expr ${#ntasks_per_node_leonardo_special[@]} - 1`)
      do
        ntasks_per_node=(${ntasks_per_node[@]} ${ntasks_per_node_leonardo_special[$k]})
      done
    fi
    #-------------------------------------------------------------------------------
    H=1
    L=1
    for j in $(seq 0 `expr ${#ntasks_per_node[@]} - 1`)
    do
      if [[ ${ntasks_per_node[j]} -le ${max_cores_per_node_cpu} ]]
      then
    for i in $(seq 0 `expr ${#sombrero_large_strong_n_nodes[@]} - 1`)
    do
      cnt=$(printf "%03d" "$H")
      index=$(printf "%03d" "$i")
      n_nodes=$(printf "nodes%03d" "${sombrero_large_strong_n_nodes[$i]}";)
      ntpn=$(printf "ntpns%03d" "${ntasks_per_node[$j]}";)
      # Orchestrating the file construction
      #__batch_file_construct=$(printf "Run_${__batch_action}_${n_nodes}_${__simulation_size}")
      __batch_file_construct=$(printf "Run_${__batch_action}_${n_nodes}_${ntpn}_${__simulation_size}")
      __batch_file_out=$(printf "${__batch_file_construct}.sh")
      __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_action}/${__simulation_size}/${__batch_file_construct}")

      $cyan;printf "                       : $n_nodes, $ntpn, $__batch_file_out, $__path_to_run\n"; $reset_colors

      # Creating the path in question
      Batch_util_create_path "${__path_to_run}"

      # Now creating the Batch file: __batch_file_out in __path_to_run
      $green; printf "Creating the Batch script from the methods: "; $bold;
      $cyan; printf "$__batch_file_out\n"; $white; $reset_colors;

      # Here need to invoke the configuration method config_Batch_with_input_from_system_config
      #ntasks_per_node=$(expr ${sombrero_large_strong_n_nodes[$i]} \* ${_core_count})
      ntasks_per_node=${ntasks_per_node[$j]} #$(expr ${sombrero_small_weak_n_nodes[$i]} \* ${_core_count})
      config_Batch_with_input_from_system_config \
        "${sombrero_large_strong_n_nodes[$i]}"   \
        "${_core_count}"                         \
        "$ntasks_per_node"                       \
        "$gpus_per_node"                         \
        "$target_partition_cpu"                  \
        "${__batch_file_construct}"              \
        "02:00:00"                               \
        "$qos"

      # Writting the header to files
      cat << EOF > "${__path_to_run}${sptr}${__batch_file_out}"
$(Batch_header ${__path_to_run} ${__accelerator} ${__project_account} ${gpus_per_node} ${__accelerator} ${__simulation_size} ${machine_name} ${_nodes} ${_ntask} ${_ntasks_per_node} ${_cpus_per_task} ${_partition} ${_job_name} ${_time} ${_qos})
$(
      case $__batch_action in
        *"Sombrero_weak"*)        echo "#---> this is a ${__batch_file_construct} job run"  ;;
        *"Sombrero_strong"*)      echo "#---> this is a ${__batch_file_construct} run"      ;;
        *"BKeeper"*)              echo "#---> this is a BKeeper job run"                    ;;
        *"HiRep-LLR-master-cpu"*) echo "#---> this is a HiRep-LLR-master-cpu job run"       ;;
        *"HiRep-LLR-master-gpu"*) echo "#---> this is a HiRep-LLR-master-gpu job run"       ;;
      esac
)

$module_list

EOF
      # Constructing the rest of the batch file body
      Batch_body_Run_Sombrero_strong               \
      "${machine_name}"                            \
      "${sombrero_dir}"                            \
      "${LatticeRuns_dir}"                         \
      "${__path_to_run}${sptr}${__batch_file_out}" \
      "${__simulation_size}"                       \
      "${__batch_file_construct}"                  \
      "${prefix}"                                  \
      "${__path_to_run}"

      # incrementing the counter
      H=$(expr $H + 1)
    done
    fi
      L=$(expr $L + 1)
    done
      ;;
  *"BKeeper_run_cpu"*)
    #-------------------------------------------------------------------------------
    # BKeeper [Small-CPU]:
    #-------------------------------------------------------------------------------
    $yellow;
    printf "#----------------------------------------------------------------\n";
    printf "# BKeeper [Small-CPU]:\n"
    printf "#----------------------------------------------------------------\n";
    $white; $reset_colors;
    __simulation_size="small"
    # constructing the files and directory structure
    H=1
    L=1
    T=1
    M=1
    for l in $(seq 0 `expr ${#mpi_distribution[@]} - 1`)
    do
    mpi_distr=$(printf "mpi%s" "${mpi_distribution[$l]}"| sed -E 's/([0-9]+)/0\1/g' | sed 's/\./\-/g')
    for k in $(seq 0 `expr ${#ntasks_per_node[@]} - 1`)
    do
      ntpn=$(printf "ntpn%03d" "${ntasks_per_node[$k]}";)
    for j in $(seq 0 `expr ${#bkeeper_lattice_size_cpu[@]} - 1`)
    do
      lattice=$(printf "lat%s" "${bkeeper_lattice_size_cpu[$j]}";)

      for i in $(seq 0 `expr ${#bkeeper_small_n_nodes_cpu[@]} - 1`)
      do
        cnt=$(printf "%03d" $H)
        index=$(printf "%03d" $i)
        n_nodes=$(printf "nodes%03d" "${bkeeper_small_n_nodes_cpu[$i]}";)
        # Orchestrating the file construction
        #__batch_file_construct=$(printf "Run_${__batch_action}_${lattice}_${n_nodes}_${__simulation_size}")
        __mpi_distr_FileTag=$(printf "${mpi_distr}")
        __batch_file_construct=$(printf "Run_${__batch_action}_${lattice}_${n_nodes}_${ntpn}_${__mpi_distr_FileTag}_${__simulation_size}")
        __batch_file_out=$(printf "${__batch_file_construct}.sh")
        #__path_to_run=$(printf "${LatticeRuns_dir}/${__batch_file_construct}")
        __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_action}/${__simulation_size}/${__batch_file_construct}")

        #$cyan;printf "bkeeper_small_n_nodes_cpu[$index] : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors
        $cyan;printf "                       : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors

        # Creating the path in question
        Batch_util_create_path "${__path_to_run}"

        # Now creating the Batch file: __batch_file_out in __path_to_run
        $green; printf "Creating the Batch script from the methods: "; $bold;
        $cyan; printf "$__batch_file_out\n"; $white; $reset_colors;

        # Here need to invoke the configuration method config_Batch_with_input_from_system_config
        #ntasks_per_node=$(expr ${bkeeper_small_n_nodes_cpu[$i]} \* ${_core_count})
        ntasks_per_node=${ntasks_per_node[$k]} #$(expr ${sombrero_small_weak_n_nodes[$i]} \* ${_core_count})
        config_Batch_with_input_from_system_config \
          "${bkeeper_small_n_nodes_cpu[$i]}"       \
          "${_core_count}"                         \
          "$ntasks_per_node"                       \
          1                                        \
          "cpu"                                    \
          "${__batch_file_construct}"              \
          "2:0:0"                                  \
          "standard"

        # Writing the header to files
        cat << EOF > "${__path_to_run}${sptr}${__batch_file_out}"
$(Batch_header ${_nodes} ${_ntask} ${_ntasks_per_node} ${_cpus_per_task} ${_partition} ${_job_name} ${_time} ${_qos})
$(
          case $__batch_action in
            *"Sombrero_weak"*)        echo "#---> this is a ${__batch_file_construct} job run"  ;;
            *"Sombrero_strong"*)      echo "#---> this is a ${__batch_file_construct} job run"  ;;
            *"BKeeper"*)              echo "#---> this is a ${__batch_file_construct} job run"  ;;
            *"HiRep-LLR-master-cpu"*) echo "#---> this is a HiRep-LLR-master-cpu job run"       ;;
            *"HiRep-LLR-master-gpu"*) echo "#---> this is a HiRep-LLR-master-gpu job run"       ;;
          esac
    )

$module_list

EOF
      # Constructing the rest of the batch file body
      Batch_body_Run_BKeeper_cpu                                                        \
      "${machine_name}" "${sombrero_dir}" "${LatticeRuns_dir}" "${benchmark_input_dir}" \
      "${__path_to_run}${sptr}${__batch_file_out}"                                      \
      "${bkeeper_lattice_size_cpu[$j]}"                                                 \
      "${mpi_distribution[$l]}"                                                         \
      "${__simulation_size}" "${__batch_file_construct}" "${prefix}" "${__path_to_run}"

      # incrementing the counter
      H=$(expr $H + 1)
    done
    L=$(expr $L + 1)
    done
      T=$(expr $T + 1)
    done
      M=$(expr $M + 1)
    done
    #-------------------------------------------------------------------------------
    # BKeeper [Large-CPU]:
    #-------------------------------------------------------------------------------
    $yellow;
    printf "#----------------------------------------------------------------\n";
    printf "# BKeeper [Large-CPU]:\n"
    printf "#----------------------------------------------------------------\n";
    $white; $reset_colors;
    __simulation_size="large"
    # constructing the files and directory structure
    H=1
    L=1
    T=1
    M=1
    for l in $(seq 0 `expr ${#mpi_distribution[@]} - 1`)
    do
    mpi_distr=$(printf "mpi%s" "${mpi_distribution[$l]}"| sed -E 's/([0-9]+)/0\1/g' | sed 's/\./\-/g')
    for k in $(seq 0 `expr ${#ntasks_per_node[@]} - 1`)
    do
      ntpn=$(printf "ntpn%03d" "${ntasks_per_node[$k]}";)
    for j in $(seq 0 `expr ${#bkeeper_lattice_size_cpu[@]} - 1`)
    do
      lattice=$(printf "lat%s" "${bkeeper_lattice_size_cpu[$j]}";)

      for i in $(seq 0 `expr ${#bkeeper_large_n_nodes_cpu[@]} - 1`)
      do
        cnt=$(printf "%03d" "$H")
        index=$(printf "%03d" "$i")
        n_nodes=$(printf "nodes%03d" "${bkeeper_large_n_nodes_cpu[$i]}";)
        # Orchestrating the file construction
        #__batch_file_construct=$(printf "Run_${__batch_action}_${lattice}_${n_nodes}_${__simulation_size}")
        __mpi_distr_FileTag=$(printf "${mpi_distr}")
        __batch_file_construct=$(printf "Run_${__batch_action}_${lattice}_${n_nodes}_${ntpn}_${__mpi_distr_FileTag}_${__simulation_size}")
        __batch_file_out=$(printf "${__batch_file_construct}.sh")
        __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_action}/${__simulation_size}/${__batch_file_construct}")

        $cyan;printf "                       : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors

        # Creating the path in question
        Batch_util_create_path "${__path_to_run}"

        # Now creating the Batch file: __batch_file_out in __path_to_run
        $green; printf "Creating the Batch script from the methods: "; $bold;
        $cyan; printf "$__batch_file_out\n"; $white; $reset_colors;

        # Here need to invoke the configuration method config_Batch_with_input_from_system_config
        #ntasks_per_node=$(expr ${bkeeper_large_n_nodes_cpu[$i]} \* ${_core_count})
        ntasks_per_node=${ntasks_per_node[$k]} #$(expr ${sombrero_small_weak_n_nodes[$i]} \* ${_core_count})
        config_Batch_with_input_from_system_config \
          "${bkeeper_large_n_nodes_cpu[$i]}"       \
          "${_core_count}"                         \
          "$ntasks_per_node"                       \
          1                                        \
          "cpu"                                    \
          "${__batch_file_construct}"              \
          "2:0:0"                                  \
          "standard"

        # Writing the header to files
        cat << EOF > ${__path_to_run}${sptr}${__batch_file_out}
$(Batch_header ${_nodes} ${_ntask} ${_ntasks_per_node} ${_cpus_per_task} ${_partition} ${_job_name} ${_time} ${_qos})
$(
      case $__batch_action in
        *"Sombrero_weak"*)        echo "#---> this is a ${__batch_file_construct} job run"  ;;
        *"Sombrero_strong"*)      echo "#---> this is a ${__batch_file_construct} job run"  ;;
        *"BKeeper"*)              echo "#---> this is a ${__batch_file_construct} job run"  ;;
        *"HiRep-LLR-master-cpu"*) echo "#---> this is a HiRep-LLR-master-cpu job run"       ;;
        *"HiRep-LLR-master-gpu"*) echo "#---> this is a HiRep-LLR-master-gpu job run"       ;;
      esac
)

$module_list

EOF
      # Constructing the rest of the batch file body
      Batch_body_Run_BKeeper_cpu                                                        \
      "${machine_name}" "${sombrero_dir}" "${LatticeRuns_dir}" "${benchmark_input_dir}" \
      "${__path_to_run}${sptr}${__batch_file_out}"                                      \
      "${bkeeper_lattice_size_cpu[$j]}"                                                 \
      "${mpi_distribution[$l]}"                                                         \
      "${__simulation_size}" "${__batch_file_construct}" "${prefix}" "${__path_to_run}"

        # incrementing the counter
        H=$(expr $H + 1)
      done
      L=$(expr $L + 1)
    done
      T=$(expr $T + 1)
    done
      M=$(expr $M + 1)
    done
      ;;
  *"BKeeper_run_gpu"*)
    #-------------------------------------------------------------------------------
    # BKeeper [Small-GPU]:
    #-------------------------------------------------------------------------------
    $yellow;
    printf "#----------------------------------------------------------------\n";
    printf "# BKeeper [Small-GPU]:\n"
    printf "#----------------------------------------------------------------\n";
    $white; $reset_colors;
    __accelerator="gpu"
    __simulation_size="small"
    # constructing the files and directory structure
    H=1
    L=1
    T=1
    M=1
    #for k in $(seq 0 `expr ${#ntasks_per_node[@]} - 1`)
    #do
    #  ntpn=$(printf "ntpn%03d" "${ntasks_per_node[$k]}";)
    for j in $(seq 0 `expr ${#bkeeper_small_lattice_size_gpu[@]} - 1`)
    do
      lattice=$(printf "lat%s" "${bkeeper_small_lattice_size_gpu[$j]}";)

      for i in $(seq 0 `expr ${#bkeeper_small_n_nodes_gpu[@]} - 1`)
      do
        # Generate all unique 4-number combinations
        nodes_x_gpus_per_node=$(echo "${bkeeper_small_n_nodes_gpu[$i]}*$gpus_per_node"|bc);

# Combinatorics loop over MPI distributions
K=1
_mpi_distr=""
for ((ix = 1; ix <= gpus_per_node; ix++)); do
  for ((iy = 1; iy <= gpus_per_node; iy++)); do
    for ((iz = 1; iz <= gpus_per_node; iz++)); do
      for ((it = 1; it <= gpus_per_node; it++)); do
        # Calculate the product of the four numbers
        product=$((ix * iy * iz * it))
        #echo "product --->: $product"
        # Check if the product is equals to number of nodes nodes
        if ((product == nodes_x_gpus_per_node)); then
          _mpi_distr="${ix}.${iy}.${iz}.${it}"
          #echo "_mpi_distr --->: $_mpi_distr"
          K=$(expr $K + 1)
          mpi_distr=$(printf "mpi%s" "${_mpi_distr}"| sed -E 's/([0-9]+)/0\1/g' | sed 's/\./\-/g')

          cnt=$(printf "%03d" "$H")
          index=$(printf "%03d" "$i")
          n_nodes=$(printf "nodes%03d" "${bkeeper_small_n_nodes_gpu[$i]}";)
          __mpi_distr_FileTag=$(printf "${mpi_distr}")
          __batch_file_construct=$(printf "Run_${__batch_action}_${lattice}_${n_nodes}_${__mpi_distr_FileTag}_${__simulation_size}")
          __batch_file_out=$(printf "${__batch_file_construct}.sh")
          __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_action}/${__simulation_size}/${__batch_file_construct}")

          $cyan;printf "                       : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors

          # Creating the path in question
          Batch_util_create_path "${__path_to_run}"
          # Now creating the Batch file: __batch_file_out in __path_to_run
          $white; printf "                       : ";
          $yellow; printf "Creating the Batch script from the methods: "; $bold;
          $cyan; printf "$__batch_file_out\n"; $white; $reset_colors;

          # Specifying the number of cpus_per_task which can be machine dependent
          # Defaulting to the number of gpu on the node MareNostrum is a special case with 20
          cpus_per_task=${gpus_per_node}
          if [[ $machine_name = "MareNostrum" ]]
          then
            #cpus_per_task=$(expr ${gpus_per_node} \* 20)
            cpus_per_task=$(expr 1 \* 20)
          fi

          # ntasks_per_node=$(expr ${bkeeper_small_n_nodes_gpu[$i]} \* ${_core_count})
          #ntasks_per_node=${ntasks_per_node[$k]} #$(expr ${sombrero_small_weak_n_nodes[$i]} \* ${_core_count})
          # Here need to invoke the configuration method config_Batch_with_input_from_system_config
          ntasks_per_node="$gpus_per_node"
          config_Batch_with_input_from_system_config \
            "${bkeeper_small_n_nodes_gpu[$i]}"       \
            "${_core_count}"                         \
            "$ntasks_per_node"                       \
            "$cpus_per_task"                         \
            "$target_partition_gpu"                  \
            "${__batch_file_construct}"              \
            "01:00:00"                               \
            "$qos"

          # Writing the header to files
          cat << EOF > "${__path_to_run}${sptr}${__batch_file_out}"
$(Batch_header ${__path_to_run} ${__accelerator} ${__project_account} ${gpus_per_node} ${__accelerator} ${__simulation_size} ${machine_name} ${_nodes} ${_ntask} ${_ntasks_per_node} ${_cpus_per_task} ${_partition} ${_job_name} ${_time} ${_qos})
$(
          case $__batch_action in
            *"Sombrero_weak"*)        echo "#---> this is a ${__batch_file_construct} job run"  ;;
            *"Sombrero_strong"*)      echo "#---> this is a ${__batch_file_construct} job run"  ;;
            *"BKeeper"*)              echo "#---> this is a ${__batch_file_construct} job run"  ;;
            *"HiRep-LLR-master-cpu"*) echo "#---> this is a HiRep-LLR-master-cpu job run"       ;;
            *"HiRep-LLR-master-gpu"*) echo "#---> this is a HiRep-LLR-master-gpu job run"       ;;
          esac
    )
EOF
          #-------------------------------------------------------------------------
          # Constructing the rest of the batch file body
          #-------------------------------------------------------------------------
          Batch_body_Run_BKeeper_gpu                                                          \
            "${machine_name}" "${bkeeper_dir}" "${LatticeRuns_dir}" "${benchmark_input_dir}"  \
            "${__path_to_run}${sptr}${__batch_file_out}"                                      \
            "${bkeeper_small_lattice_size_gpu[$j]}"                                                 \
            "${_mpi_distr}"                                                                   \
            "${__simulation_size}" "${__batch_file_construct}" "${prefix}" "${__path_to_run}" \
            "${module_list}" "${sourcecode_dir}"

        fi

      done
    done
  done
done
        # incrementing the counter
        #L=$(expr $L + 1)
      #done
      H=$(expr $H + 1)
    done
    #  T=$(expr $T + 1)
    #done
      M=$(expr $M + 1)
    done
    #-------------------------------------------------------------------------------
    # BKeeper [Large-GPU]:
    #-------------------------------------------------------------------------------
    $yellow;
    printf "#----------------------------------------------------------------\n";
    printf "# BKeeper [Large-GPU]:\n"
    printf "#----------------------------------------------------------------\n";
    $white; $reset_colors;
    __accelerator="gpu"
    __simulation_size="large"
    # constructing the files and directory structure
    H=1
    L=1
    T=1
    M=1
    #for k in $(seq 0 `expr ${#ntasks_per_node[@]} - 1`)
    #do
    #  ntpn=$(printf "ntpn%03d" "${ntasks_per_node[$k]}";)
    for j in $(seq 0 `expr ${#bkeeper_large_lattice_size_gpu[@]} - 1`)
    do
      lattice=$(printf "lat%s" "${bkeeper_large_lattice_size_gpu[$j]}";)

      for i in $(seq 0 `expr ${#bkeeper_large_n_nodes_gpu[@]} - 1`)
      do
        # Generate all unique 4-number combinations
        nodes_x_gpus_per_node=$(echo "${bkeeper_large_n_nodes_gpu[$i]}*$gpus_per_node"|bc);

# Combinatorics loop over MPI distributions
K=1
_mpi_distr=""
for ((ix = 1; ix <= gpus_per_node; ix++)); do
  for ((iy = 1; iy <= gpus_per_node; iy++)); do
    for ((iz = 1; iz <= gpus_per_node; iz++)); do
      for ((it = 1; it <= gpus_per_node; it++)); do
        # Calculate the product of the four numbers
        product=$((ix * iy * iz * it))
        #echo "product --->: $product"
        # Check if the product is equals to number of nodes nodes
        if ((product == nodes_x_gpus_per_node)); then
          _mpi_distr="${ix}.${iy}.${iz}.${it}"
          #echo "_mpi_distr --->: $_mpi_distr"
          K=$(expr $K + 1)
          mpi_distr=$(printf "mpi%s" "${_mpi_distr}"| sed -E 's/([0-9]+)/0\1/g' | sed 's/\./\-/g')

          cnt=$(printf "%03d" "$H")
          index=$(printf "%03d" "$i")
          n_nodes=$(printf "nodes%03d" "${bkeeper_large_n_nodes_gpu[$i]}";)
          __mpi_distr_FileTag=$(printf "${mpi_distr}")
          __batch_file_construct=$(printf "Run_${__batch_action}_${lattice}_${n_nodes}_${__mpi_distr_FileTag}_${__simulation_size}")
          __batch_file_out=$(printf "${__batch_file_construct}.sh")
          __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_action}/${__simulation_size}/${__batch_file_construct}")

          $cyan;printf "                       : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors
          # Creating the path in question
          Batch_util_create_path "${__path_to_run}"
          # Now creating the Batch file: __batch_file_out in __path_to_run
          $white; printf "                       : ";
          $yellow; printf "Creating the Batch script from the methods: "; $bold;
          $cyan; printf "$__batch_file_out\n"; $white; $reset_colors;

          # Specifying the number of cpus_per_task which can be machine dependent
          # Defaulting to the number of gpu on the node MareNostrum is a special case with 20
          cpus_per_task=${gpus_per_node}
          if [[ $machine_name = "MareNostrum" ]]
          then
            #cpus_per_task=$(expr ${gpus_per_node} \* 20)
            cpus_per_task=$(expr 1 \* 20)
          fi

          #ntasks_per_node=$(expr ${bkeeper_large_n_nodes_gpu[$i]} \* ${_core_count})
          #ntasks_per_node=${ntasks_per_node[$k]} #$(expr ${sombrero_small_weak_n_nodes[$i]} \* ${_core_count})
          # Here need to invoke the configuration method config_Batch_with_input_from_system_config
          ntasks_per_node="$gpus_per_node"
          config_Batch_with_input_from_system_config \
            "${bkeeper_large_n_nodes_gpu[$i]}"       \
            "${_core_count}"                         \
            "$ntasks_per_node"                       \
            "$cpus_per_task"                         \
            "$target_partition_gpu"                  \
            "${__batch_file_construct}"              \
            "01:00:00"                               \
            "$qos"

          # Writing the header to files
          cat << EOF > "${__path_to_run}${sptr}${__batch_file_out}"
$(Batch_header ${__path_to_run} ${__accelerator} ${__project_account} ${gpus_per_node} ${__accelerator} ${__simulation_size} ${machine_name} ${_nodes} ${_ntask} ${_ntasks_per_node} ${_cpus_per_task} ${_partition} ${_job_name} ${_time} ${_qos})
$(
          case $__batch_action in
            *"Sombrero_weak"*)        echo "#---> this is a ${__batch_file_construct} job run"  ;;
            *"Sombrero_strong"*)      echo "#---> this is a ${__batch_file_construct} job run"  ;;
            *"BKeeper"*)              echo "#---> this is a ${__batch_file_construct} job run"  ;;
            *"HiRep-LLR-master-cpu"*) echo "#---> this is a HiRep-LLR-master-cpu job run"       ;;
            *"HiRep-LLR-master-gpu"*) echo "#---> this is a HiRep-LLR-master-gpu job run"       ;;
          esac
    )
EOF
          #-------------------------------------------------------------------------
          # Constructing the rest of the batch file body
          #-------------------------------------------------------------------------
          Batch_body_Run_BKeeper_gpu                                                          \
            "${machine_name}" "${bkeeper_dir}" "${LatticeRuns_dir}" "${benchmark_input_dir}"  \
            "${__path_to_run}${sptr}${__batch_file_out}"                                      \
            "${bkeeper_large_lattice_size_gpu[$j]}"                                                 \
            "${_mpi_distr}"                                                                   \
            "${__simulation_size}" "${__batch_file_construct}" "${prefix}" "${__path_to_run}" \
            "${module_list}" "${sourcecode_dir}"

        fi

      done
    done
  done
done
        # incrementing the counter
        #L=$(expr $L + 1)
      #done
      H=$(expr $H + 1)
    done
    #  T=$(expr $T + 1)
    #done
      M=$(expr $M + 1)
    done

      ;;

  *"Grid_DWF_run_gpu"*)
    #-------------------------------------------------------------------------------
    # Grid_DWF_run_gpu [Small-GPU]:
    #-------------------------------------------------------------------------------
    $yellow;
    printf "#----------------------------------------------------------------\n";
    printf "# Grid_DWF_run_gpu [Small-GPU]:\n"
    printf "#----------------------------------------------------------------\n";
    $white; $reset_colors;
    __accelerator="gpu"
    __simulation_size="small"

    # Values to be looped over
    for m in ${beta[@]}; do echo $m; done
    for m in ${mass[@]}; do echo $m; done
    for m in ${Ls[@]}; do echo $m; done
    # Values not looped over and kept hardcoded for now.
    for m in ${trajectories[@]}; do echo $m; done
    for m in ${nsteps[@]}; do echo $m; done
    for m in ${savefreq[@]}; do echo $m; done
    for m in ${tlen[@]}; do echo $m; done
    for m in ${dwf_mass[@]}; do echo $m; done
    for m in ${Mobius_b[@]}; do echo $m; done
    for m in ${Mobius_c[@]}; do echo $m; done


    # insert the loop structure here


    #---------------------------------------------------------------------------
    # Extracting the parameters from the configuration files
    #---------------------------------------------------------------------------
    $white; printf "Simulation size        : "; $bold;
    $magenta; printf '%s'"${__simulation_size}"; $green; printf "\n";
    $white; $reset_colors;
    $yellow; printf "                       ------------------------------------------\n"; $white; $reset_colors;
    #---------------------------------------------------------------------------
    # Get beta array values 6.9
    beta_segment=${beta[0]}    #$(echo "$substring" | grep -oP 'b\K\d+p\d+' | sed 's/p/./')
    # # Get mass array values 0.08
    mass_segment=${mass[0]}    #$(echo "$substring" | grep -oP 'm\K\d+p\d+' | sed 's/p/./')
    # Get Ls array values 8
    Ls_segment=${Ls[0]}        #$(echo "$substring" | grep -oP 'Ls\d+' | sed 's/Ls//')
    #---------------------------------------------------------------------------
    # Extracted data from the substring
    $white; printf "Beta                   : "; $bold; $yellow; printf '%s'"${beta_segment}"; printf "\n"; $white; $reset_colors;
    $white; printf "Mass (ex: 0.08)        : "; $bold; $yellow; printf '%s'"${mass_segment}"; printf "\n"; $white; $reset_colors;
    $white; printf "Ls (Domain Wall)       : "; $bold; $yellow; printf '%s'"${Ls_segment}"; printf "\n"; $white; $reset_colors;
    $yellow; printf "                       ------------------------------------------\n"; $white; $reset_colors;



    # constructing the files and directory structure
    H=1
    L=1
    T=1
    M=1
    #for k in $(seq 0 `expr ${#ntasks_per_node[@]} - 1`)
    #do
    #  ntpn=$(printf "ntpn%03d" "${ntasks_per_node[$k]}";)
    for j in $(seq 0 `expr ${#grid_small_lattice_size_gpu[@]} - 1`)
    do
      lattice=$(printf "lat%s" "${grid_small_lattice_size_gpu[$j]}";)

      for i in $(seq 0 `expr ${#grid_small_n_nodes_gpu[@]} - 1`)
      do
        # Generate all unique 4-number combinations
        nodes_x_gpus_per_node=$(echo "${grid_small_n_nodes_gpu[$i]}*$gpus_per_node"|bc);

# Combinatorics loop over MPI distributions
K=1
_mpi_distr=""
for ((ix = 1; ix <= gpus_per_node; ix++)); do
  for ((iy = 1; iy <= gpus_per_node; iy++)); do
    for ((iz = 1; iz <= gpus_per_node; iz++)); do
      for ((it = 1; it <= gpus_per_node; it++)); do
        # Calculate the product of the four numbers
        product=$((ix * iy * iz * it))
        #echo "product --->: $product"
        # Check if the product is equals to number of nodes nodes
        if ((product == nodes_x_gpus_per_node)); then
          _mpi_distr="${ix}.${iy}.${iz}.${it}"
          #echo "_mpi_distr --->: $_mpi_distr"
          K=$(expr $K + 1)
          mpi_distr=$(printf "mpi%s" "${_mpi_distr}"| sed -E 's/([0-9]+)/0\1/g' | sed 's/\./\-/g')

          cnt=$(printf "%03d" "$H")
          index=$(printf "%03d" "$i")
          n_nodes=$(printf "nodes%03d" "${grid_small_n_nodes_gpu[$i]}";)
          __mpi_distr_FileTag=$(printf "${mpi_distr}")
          __batch_file_construct=$(printf "Run_${__batch_action}_${lattice}_${n_nodes}_${__mpi_distr_FileTag}_${__simulation_size}")
          __batch_file_out=$(printf "${__batch_file_construct}.sh")
          __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_action}/${__simulation_size}/${__batch_file_construct}")

          $cyan;printf "                       : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors

          # TODO: continue from here: first check the file convention is correct.
          # Creating the path in question
          Batch_util_create_path "${__path_to_run}"
          # Now creating the Batch file: __batch_file_out in __path_to_run
          $white; printf "                       : ";
          $yellow; printf "Creating the Batch script from the methods: "; $bold;
          $cyan; printf "$__batch_file_out\n"; $white; $reset_colors;

          # Specifying the number of cpus_per_task which can be machine dependent
          # Defaulting to the number of gpu on the node MareNostrum is a special case with 20
          cpus_per_task=${gpus_per_node}
          if [[ $machine_name = "MareNostrum" ]]
          then
            #cpus_per_task=$(expr ${gpus_per_node} \* 20)
            cpus_per_task=$(expr 1 \* 20)
          fi

          # Here need to invoke the configuration method config_Batch_with_input_from_system_config
          #ntasks_per_node=$(expr ${grid_small_n_nodes_gpu[$i]} \* ${_core_count})
          #ntasks_per_node=${ntasks_per_node[$k]} #$(expr ${sombrero_small_weak_n_nodes[$i]} \* ${_core_count})
          ntasks_per_node="$gpus_per_node"
          config_Batch_with_input_from_system_config \
            "${grid_small_n_nodes_gpu[$i]}"          \
            "${_core_count}"                         \
            "$ntasks_per_node"                       \
            "$gpus_per_node"                         \
            "$target_partition_gpu"                  \
            "${__batch_file_construct}"              \
            "10:00:00"                               \
            "$qos"

          # Writing the header to files
          cat << EOF > "${__path_to_run}${sptr}${__batch_file_out}"
$(Batch_header ${__path_to_run} ${__accelerator} ${__project_account} ${gpus_per_node} ${__accelerator} ${__simulation_size} ${machine_name} ${_nodes} ${_ntask} ${_ntasks_per_node} ${_cpus_per_task} ${_partition} ${_job_name} ${_time} ${_qos})
$(
          case $__batch_action in
            *"Sombrero_weak"*)        echo "#---> this is a ${__batch_file_construct} job run"  ;;
            *"Sombrero_strong"*)      echo "#---> this is a ${__batch_file_construct} job run"  ;;
            *"BKeeper"*)              echo "#---> this is a ${__batch_file_construct} job run"  ;;
            *"HiRep-LLR-master-cpu"*) echo "#---> this is a HiRep-LLR-master-cpu job run"       ;;
            *"HiRep-LLR-master-gpu"*) echo "#---> this is a HiRep-LLR-master-gpu job run"       ;;
            *"Grid_DWF_run_gpu"*)     echo "#---> this is a Grid_DWF_run_gpu job run"           ;;
          esac
    )
EOF
          #-------------------------------------------------------------------------
          # Constructing the rest of the batch file body
          #-------------------------------------------------------------------------

          Batch_body_Run_Grid_DWF_gpu                                                         \
            "${machine_name}" "${grid_DWF_Telos_dir}" "${LatticeRuns_dir}"                    \
            "${benchmark_input_dir}"                                                          \
            "${__path_to_run}${sptr}${__batch_file_out}"                                      \
            "${grid_small_lattice_size_gpu[$j]}"                                              \
            "${_mpi_distr}"                                                                   \
            "${__simulation_size}" "${__batch_file_construct}" "${prefix}" "${__path_to_run}" \
            "${module_list}" "${sourcecode_dir}"                                              \
            "${beta_segment}" "${mass_segment}" "${Ls_segment}"

        fi

      done
    done
  done
done
        # incrementing the counter
        #L=$(expr $L + 1)
      #done
      H=$(expr $H + 1)
    done
    #  T=$(expr $T + 1)
    #done
      M=$(expr $M + 1)
    done
    #-------------------------------------------------------------------------------
    # Grid_DWF_run_gpu [Large-GPU]:
    #-------------------------------------------------------------------------------
    $yellow;
    printf "#----------------------------------------------------------------\n";
    printf "# Grid_DWF_run_gpu [Large-GPU]:\n"
    printf "#----------------------------------------------------------------\n";
    $white; $reset_colors;
    __accelerator="gpu"
    __simulation_size="large"


    # insert the loop structure here

    #---------------------------------------------------------------------------
    # Extracting the parameters from the configuration files
    #---------------------------------------------------------------------------
    $white; printf "Simulation Size        : "; $bold;
    $magenta; printf '%s'"${__simulation_size}"; $green; printf "\n";
    $white; $reset_colors;
    $yellow; printf "                       ------------------------------------------\n"; $white; $reset_colors;
    #---------------------------------------------------------------------------
    # Get beta array values 6.9
    beta_segment=${beta[0]}    #$(echo "$substring" | grep -oP 'b\K\d+p\d+' | sed 's/p/./')
    # # Get mass array values 0.08
    mass_segment=${mass[0]}    #$(echo "$substring" | grep -oP 'm\K\d+p\d+' | sed 's/p/./')
    # Get Ls array values 8
    Ls_segment=${Ls[0]}        #$(echo "$substring" | grep -oP 'Ls\d+' | sed 's/Ls//')
    #---------------------------------------------------------------------------
    # Extracted data from the substring
    $white; printf "Beta                   : "; $bold; $yellow; printf '%s'"${beta_segment}"; printf "\n"; $white; $reset_colors;
    $white; printf "Mass (ex: 0.08)        : "; $bold; $yellow; printf '%s'"${mass_segment}"; printf "\n"; $white; $reset_colors;
    $white; printf "Ls (Domain Wall)       : "; $bold; $yellow; printf '%s'"${Ls_segment}"; printf "\n"; $white; $reset_colors;
    $yellow; printf "                       ------------------------------------------\n"; $white; $reset_colors;

    # constructing the files and directory structure
    H=1
    L=1
    T=1
    M=1
    #for k in $(seq 0 `expr ${#ntasks_per_node[@]} - 1`)
    #do
    #  ntpn=$(printf "ntpn%03d" "${ntasks_per_node[$k]}";)
    for j in $(seq 0 `expr ${#grid_large_lattice_size_gpu[@]} - 1`)
    do
      lattice=$(printf "lat%s" "${grid_large_lattice_size_gpu[$j]}";)

      for i in $(seq 0 `expr ${#grid_large_n_nodes_gpu[@]} - 1`)
      do
        # Generate all unique 4-number combinations
        nodes_x_gpus_per_node=$(echo "${grid_large_n_nodes_gpu[$i]}*$gpus_per_node"|bc);

# Combinatorics loop over MPI distributions
K=1
_mpi_distr=""
for ((ix = 1; ix <= gpus_per_node; ix++)); do
  for ((iy = 1; iy <= gpus_per_node; iy++)); do
    for ((iz = 1; iz <= gpus_per_node; iz++)); do
      for ((it = 1; it <= gpus_per_node; it++)); do
        # Calculate the product of the four numbers
        product=$((ix * iy * iz * it))
        #echo "product --->: $product"
        # Check if the product is equals to number of nodes nodes
        if ((product == nodes_x_gpus_per_node)); then
          _mpi_distr="${ix}.${iy}.${iz}.${it}"
          #echo "_mpi_distr --->: $_mpi_distr"
          K=$(expr $K + 1)
          mpi_distr=$(printf "mpi%s" "${_mpi_distr}"| sed -E 's/([0-9]+)/0\1/g' | sed 's/\./\-/g')

          cnt=$(printf "%03d" "$H")
          index=$(printf "%03d" "$i")
          n_nodes=$(printf "nodes%03d" "${grid_large_n_nodes_gpu[$i]}";)
          __mpi_distr_FileTag=$(printf "${mpi_distr}")
          __batch_file_construct=$(printf "Run_${__batch_action}_${lattice}_${n_nodes}_${__mpi_distr_FileTag}_${__simulation_size}")
          __batch_file_out=$(printf "${__batch_file_construct}.sh")
          __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_action}/${__simulation_size}/${__batch_file_construct}")

          $cyan;printf "                       : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors

          # TODO: continue from here: first check the file convention is correct.

          # Creating the path in question
          Batch_util_create_path "${__path_to_run}"
          # Now creating the Batch file: __batch_file_out in __path_to_run
          $white; printf "                       : ";
          $yellow; printf "Creating the Batch script from the methods: "; $bold;
          $cyan; printf "$__batch_file_out\n"; $white; $reset_colors;

          # Specifying the number of cpus_per_task which can be machine dependent
          # Defaulting to the number of gpu on the node MareNostrum is a special case with 20
          cpus_per_task=${gpus_per_node}
          if [[ $machine_name = "MareNostrum" ]]
          then
            #cpus_per_task=$(expr ${gpus_per_node} \* 20)
            cpus_per_task=$(expr 1 \* 20)
          fi

          # Here need to invoke the configuration method config_Batch_with_input_from_system_config
          #ntasks_per_node=$(expr ${grid_large_n_nodes_gpu[$i]} \* ${_core_count})
          #ntasks_per_node=${ntasks_per_node[$k]} #$(expr ${sombrero_small_weak_n_nodes[$i]} \* ${_core_count})
          ntasks_per_node="$gpus_per_node"
          config_Batch_with_input_from_system_config \
            "${grid_large_n_nodes_gpu[$i]}"          \
            "${_core_count}"                         \
            "$ntasks_per_node"                       \
            "$gpus_per_node"                         \
            "$target_partition_gpu"                  \
            "${__batch_file_construct}"              \
            "10:00:00"                               \
            "$qos"

          # Writing the header to files
          cat << EOF > "${__path_to_run}${sptr}${__batch_file_out}"
$(Batch_header ${__path_to_run} ${__accelerator} ${__project_account} ${gpus_per_node} ${__accelerator} ${__simulation_size} ${machine_name} ${_nodes} ${_ntask} ${_ntasks_per_node} ${_cpus_per_task} ${_partition} ${_job_name} ${_time} ${_qos})
$(
          case $__batch_action in
            *"Sombrero_weak"*)        echo "#---> this is a ${__batch_file_construct} job run"  ;;
            *"Sombrero_strong"*)      echo "#---> this is a ${__batch_file_construct} job run"  ;;
            *"BKeeper"*)              echo "#---> this is a ${__batch_file_construct} job run"  ;;
            *"HiRep-LLR-master-cpu"*) echo "#---> this is a HiRep-LLR-master-cpu job run"       ;;
            *"HiRep-LLR-master-gpu"*) echo "#---> this is a HiRep-LLR-master-gpu job run"       ;;
          esac
    )
EOF
          #-------------------------------------------------------------------------
          # Constructing the rest of the batch file body
          #-------------------------------------------------------------------------
          Batch_body_Run_Grid_DWF_gpu                                                         \
            "${machine_name}" "${grid_DWF_Telos_dir}" "${LatticeRuns_dir}"                    \
            "${benchmark_input_dir}"                                                          \
            "${__path_to_run}${sptr}${__batch_file_out}"                                      \
            "${grid_large_lattice_size_gpu[$j]}"                                              \
            "${_mpi_distr}"                                                                   \
            "${__simulation_size}" "${__batch_file_construct}" "${prefix}" "${__path_to_run}" \
            "${module_list}" "${sourcecode_dir}"                                              \
            "${beta_segment}" "${mass_segment}" "${Ls_segment}"

        fi

      done
    done
  done
done
        # incrementing the counter
        #L=$(expr $L + 1)
      #done
      H=$(expr $H + 1)
    done
    #  T=$(expr $T + 1)
    #done
      M=$(expr $M + 1)
    done

      ;;
  *"Grid_DWF_Telos_run_gpu"*)
    #-------------------------------------------------------------------------------
    # First fill in the DWF_ensembles_GRID_array
    #-------------------------------------------------------------------------------
    DWF_ensembles_GRID_array=()
    for dir in "${DWF_ensembles_GRID_dir}"/*;
    do
      DWF_ensembles_GRID_array+=("$(basename "$dir")")
    done
    #-------------------------------------------------------------------------------
    # Grid_DWF_Telos_run_gpu [Small-GPU]:
    #-------------------------------------------------------------------------------
    $yellow;
    printf "#----------------------------------------------------------------\n";
    printf "# Grid_DWF_Telos_run_gpu [Small-GPU]:\n"
    printf "#----------------------------------------------------------------\n";
    $white; $reset_colors;
    __accelerator="gpu"
    __simulation_size="small"

    for m in ${beta_telos[@]}; do echo $m; done
    for m in ${mass_telos[@]}; do echo $m; done
    for m in ${Ls[@]}; do echo $m; done

    for m in ${trajectories[@]}; do echo $m; done
    for m in ${nsteps[@]}; do echo $m; done
    for m in ${savefreq[@]}; do echo $m; done
    for m in ${tlen[@]}; do echo $m; done
    for m in ${dwf_mass[@]}; do echo $m; done
    for m in ${Mobius_b[@]}; do echo $m; done
    for m in ${Mobius_c[@]}; do echo $m; done
    for m in ${grid_dwf_telos_lattice_size_gpu[@]}; do echo $m; done
    # Number of numbers to looped over and executed for the [Small-GPU] case
    printf "#----------------------------------------------------------------\n";
    for m in ${grid_small_n_nodes_gpu[@]}; do echo $m; done
    printf "#----------------------------------------------------------------\n";

    ls -al "${DWF_ensembles_GRID_dir}"

    # constructing the files and directory structure
    H=1
    L=1
    T=1
    M=1


# Looping over the array
for idir in $(seq 0 `expr ${#DWF_ensembles_GRID_array[@]} - 1`)
do

  parent_dir="${DWF_ensembles_GRID_dir}"
  substring="${DWF_ensembles_GRID_array[$idir]}"

  #echo "echo --->: $parent_dir"
  #echo "echo --->: $substring"
  $yellow; printf "                       ------------------------------------------\n"; $white; $reset_colors;
  $white; printf "Parent directory       : "; $bold; $yellow; printf '%s'"${parent_dir}"; printf "\n"; $white; $reset_colors;
  $white; printf "Substring              : "; $bold; $cyan; printf '%s'"${substring}";  printf "\n"; $white; $reset_colors;

  found=0
  for dir in "$parent_dir"/*/; do
    if [[ -d "$dir" && "$dir" == *"$substring"* ]]; then
      #echo "Found matching directory: $dir"
      $white; printf "Found matching dir     : "; $bold; $yellow; printf '%s'"${dir}"; printf "\n"; $white; $reset_colors;
      found=1
      break
    fi
  done

  if [ "$found" -eq 1 ]; then
    #---------------------------------------------------------------------------
    # Extracting the parameters from the configuration files
    #---------------------------------------------------------------------------
    $white; printf "Directory substring    : "; $bold;
    $magenta; printf '%s'"${substring}"; $green; printf " exist.\n";
    $white; $reset_colors;
    $yellow; printf "                       ------------------------------------------\n"; $white; $reset_colors;
    #---------------------------------------------------------------------------
    # Extract and convert 6p9 to 6.9
    beta_telos_segment=$(echo "$substring" | grep -oP 'b\K\d+p\d+' | sed 's/p/./')
    # Extract and convert LNt32L24 to 24.24.24.32
    lattice_segment=$(echo "$substring" | grep -oP 'LNt\d+L\d+' | sed -E 's/LNt([0-9]+)L([0-9]+)/\2.\2.\2.\1/')
    # Extract and convert m0p08 to 0.08
    mass_segment=$(echo "$substring" | grep -oP 'm\K\d+p\d+' | sed 's/p/./')
    # Extract and convert Ls8 to Ls=8
    Ls_segment=$(echo "$substring" | grep -oP 'Ls\d+' | sed 's/Ls//')
    #---------------------------------------------------------------------------
    # Extracted data from the substring
    $white; printf "6p9                    : "; $bold; $yellow; printf '%s'"${beta_telos_segment}"; printf "\n"; $white; $reset_colors;
    $white; printf "m0p08                  : "; $bold; $yellow; printf '%s'"${mass_segment}"; printf "\n"; $white; $reset_colors;
    $white; printf "LNt32L24               : "; $bold; $yellow; printf '%s'"${lattice_segment}"; printf "\n"; $white; $reset_colors;
    $white; printf "Ls8                    : "; $bold; $yellow; printf '%s'"${Ls_segment}"; printf "\n"; $white; $reset_colors;
    $yellow; printf "                       ------------------------------------------\n"; $white; $reset_colors;
    #---------------------------------------------------------------------------
    # Starting the looping structure
    #---------------------------------------------------------------------------
    #for k in $(seq 0 `expr ${#ntasks_per_node[@]} - 1`)
    #do
    #  ntpn=$(printf "ntpn%03d" "${ntasks_per_node[$k]}";)
    #for j in $(seq 0 `expr ${#grid_dwf_telos_lattice_size_gpu[@]} - 1`)
    #do
      #lattice=$(printf "lat%s" "${grid_dwf_telos_lattice_size_gpu[$j]}";)

      lattice=$(printf "lat%s" "${lattice_segment}";)

      for i in $(seq 0 `expr ${#grid_small_n_nodes_gpu[@]} - 1`)
      do
        # Generate all unique 4-number combinations
        nodes_x_gpus_per_node=$(echo "${grid_small_n_nodes_gpu[$i]}*$gpus_per_node"|bc);

# Combinatorics loop over MPI distributions
K=1
_mpi_distr=""
for ((ix = 1; ix <= gpus_per_node; ix++)); do
  for ((iy = 1; iy <= gpus_per_node; iy++)); do
    for ((iz = 1; iz <= gpus_per_node; iz++)); do
      for ((it = 1; it <= gpus_per_node; it++)); do
        # Calculate the product of the four numbers
        product=$((ix * iy * iz * it))
        #echo "product --->: $product"
        # Check if the product is equals to number of nodes nodes
        if ((product == nodes_x_gpus_per_node)); then
          _mpi_distr="${ix}.${iy}.${iz}.${it}"
          #echo "_mpi_distr --->: $_mpi_distr"
          K=$(expr $K + 1)
          mpi_distr=$(printf "mpi%s" "${_mpi_distr}"| sed -E 's/([0-9]+)/0\1/g' | sed 's/\./\-/g')

          cnt=$(printf "%03d" "$H")
          index=$(printf "%03d" "$i")
          n_nodes=$(printf "nodes%03d" "${grid_small_n_nodes_gpu[$i]}";)
          __mpi_distr_FileTag=$(printf "${mpi_distr}")
          #_${__batch_action}_${substring}_${n_nodes}_${__mpi_distr_FileTag}_${__simulation_size}
          #_${beta_telos_segment}_${mass_segment}_${lattice}_${Ls_segment}
          __batch_file_construct=$(printf "Run_${__batch_action}_${substring}_${n_nodes}_${__mpi_distr_FileTag}_${__simulation_size}")
          __batch_file_out=$(printf "${__batch_file_construct}.sh")
          __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_action}/${__simulation_size}/${__batch_file_construct}")

          $cyan;printf "                       : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors

          # TODO: continue from here: first check the file convention is correct.
          # Creating the path in question
          Batch_util_create_path "${__path_to_run}"
          # Now creating the Batch file: __batch_file_out in __path_to_run
          $white; printf "                       : ";
          $yellow; printf "Creating the Batch script from the methods: "; $bold;
          $cyan; printf "$__batch_file_out\n"; $white; $reset_colors;

          # Specifying the number of cpus_per_task which can be machine dependent
          # Defaulting to the number of gpu on the node MareNostrum is a special case with 20
          cpus_per_task=${gpus_per_node}
          if [[ $machine_name = "MareNostrum" ]]
          then
            #cpus_per_task=$(expr ${gpus_per_node} \* 20)
            cpus_per_task=$(expr 1 \* 20)
          fi

          # Here need to invoke the configuration method config_Batch_with_input_from_system_config
          #ntasks_per_node=$(expr ${grid_small_n_nodes_gpu[$i]} \* ${_core_count})
          #ntasks_per_node=${ntasks_per_node[$k]} #$(expr ${sombrero_small_weak_n_nodes[$i]} \* ${_core_count})
          ntasks_per_node="$gpus_per_node"
          config_Batch_with_input_from_system_config \
            "${grid_small_n_nodes_gpu[$i]}"          \
            "${_core_count}"                         \
            "$ntasks_per_node"                       \
            "$gpus_per_node"                         \
            "$target_partition_gpu"                  \
            "${__batch_file_construct}"              \
            "10:00:00"                               \
            "$qos"

          # Writing the header to files
          cat << EOF > "${__path_to_run}${sptr}${__batch_file_out}"
$(Batch_header ${__path_to_run} ${__accelerator} ${__project_account} ${gpus_per_node} ${__accelerator} ${__simulation_size} ${machine_name} ${_nodes} ${_ntask} ${_ntasks_per_node} ${_cpus_per_task} ${_partition} ${_job_name} ${_time} ${_qos})
$(
          case $__batch_action in
            *"Sombrero_weak"*)          echo "#---> this is a ${__batch_file_construct} job run" ;;
            *"Sombrero_strong"*)        echo "#---> this is a ${__batch_file_construct} job run" ;;
            *"BKeeper"*)                echo "#---> this is a ${__batch_file_construct} job run" ;;
            *"HiRep-LLR-master-cpu"*)   echo "#---> this is a HiRep-LLR-master-cpu job run"      ;;
            *"HiRep-LLR-master-gpu"*)   echo "#---> this is a HiRep-LLR-master-gpu job run"      ;;
            *"Grid_DWF_run_gpu"*)       echo "#---> this is a Grid_DWF_run_gpu job run"          ;;
            *"Grid_DWF_Telos_run_gpu"*) echo "#---> this is a Grid_DWF_Telos_run_gpu job run"    ;;
          esac
    )
EOF
          #-------------------------------------------------------------------------
          # Constructing the rest of the batch file body
          #-------------------------------------------------------------------------
          Batch_body_Run_Grid_DWF_Telos_gpu                                                   \
            "${machine_name}" "${grid_DWF_Telos_dir}" "${LatticeRuns_dir}"                    \
            "${benchmark_input_dir}" "${__path_to_run}${sptr}${__batch_file_out}"             \
            "${lattice_segment}" "${_mpi_distr}"  "${__simulation_size}"  \
            "${__batch_file_construct}" "${prefix}" "${__path_to_run}"                        \
            "${module_list}" "${sourcecode_dir}" "${DWF_ensembles_GRID_dir}" "${substring}"   \
            "${beta_telos_segment}" "${mass_segment}" "${Ls_segment}"

          #"${grid_dwf_telos_lattice_size_gpu[$j]}"
        fi

      done
    done
  done
done
        # incrementing the counter
        #L=$(expr $L + 1)
      #done
      H=$(expr $H + 1)
    done # [end-for-loop] ${#grid_small_n_nodes_gpu[@]}
    #  T=$(expr $T + 1)
    #done
      M=$(expr $M + 1)
    #done # [end-for-loop] grid_dwf_telos_lattice_size_gpu[@]}


  else
    $white; printf "Directory substring    : "; $bold;
    $magenta; printf '%s'"${substring}"; $red; printf " does not exist.\n";
    $white; $reset_colors;
    $yellow; printf "                       ------------------------------------------\n"; $white; $reset_colors;
  fi

done
    #-------------------------------------------------------------------------------
    # Grid_DWF_Telos_run_gpu [Large-GPU]:
    #-------------------------------------------------------------------------------
    $yellow;
    printf "#----------------------------------------------------------------\n";
    printf "# Grid_DWF_Telos_run_gpu [Large-GPU]:\n"
    printf "#----------------------------------------------------------------\n";
    $white; $reset_colors;
    __accelerator="gpu"
    __simulation_size="large"


    for m in ${beta_telos[@]}; do echo $m; done
    for m in ${mass_telos[@]}; do echo $m; done
    for m in ${Ls[@]}; do echo $m; done

    for m in ${trajectories[@]}; do echo $m; done
    for m in ${nsteps[@]}; do echo $m; done
    for m in ${savefreq[@]}; do echo $m; done
    for m in ${tlen[@]}; do echo $m; done
    for m in ${dwf_mass[@]}; do echo $m; done
    for m in ${Mobius_b[@]}; do echo $m; done
    for m in ${Mobius_c[@]}; do echo $m; done
    for m in ${grid_dwf_telos_lattice_size_gpu[@]}; do echo $m; done
    # Number of numbers to looped over and executed for the [Small-GPU] case
    printf "#----------------------------------------------------------------\n";
    for m in ${grid_large_n_nodes_gpu[@]}; do echo $m; done
    printf "#----------------------------------------------------------------\n";

    ls -al "${DWF_ensembles_GRID_dir}"

    # constructing the files and directory structure
    H=1
    L=1
    T=1
    M=1


# Looping over the array
for idir in $(seq 0 `expr ${#DWF_ensembles_GRID_array[@]} - 1`)
do

  parent_dir="${DWF_ensembles_GRID_dir}"
  substring="${DWF_ensembles_GRID_array[$idir]}"

  #echo "echo --->: $parent_dir"
  #echo "echo --->: $substring"
  $yellow; printf "                       ------------------------------------------\n"; $white; $reset_colors;
  $white; printf "Parent directory       : "; $bold; $yellow; printf '%s'"${parent_dir}"; printf "\n"; $white; $reset_colors;
  $white; printf "Substring              : "; $bold; $cyan; printf '%s'"${substring}";  printf "\n"; $white; $reset_colors;

  found=0
  for dir in "$parent_dir"/*/; do
    if [[ -d "$dir" && "$dir" == *"$substring"* ]]; then
      #echo "Found matching directory: $dir"
      $white; printf "Found matching dir     : "; $bold; $yellow; printf '%s'"${dir}"; printf "\n"; $white; $reset_colors;
      found=1
      break
    fi
  done

  if [ "$found" -eq 1 ]; then
    #---------------------------------------------------------------------------
    # Extracting the parameters from the configuration files
    #---------------------------------------------------------------------------
    $white; printf "Directory substring    : "; $bold;
    $magenta; printf '%s'"${substring}"; $green; printf " exist.\n";
    $white; $reset_colors;
    $yellow; printf "                       ------------------------------------------\n"; $white; $reset_colors;
    #---------------------------------------------------------------------------
    # Extract and convert 6p9 to 6.9
    beta_telos_segment=$(echo "$substring" | grep -oP 'b\K\d+p\d+' | sed 's/p/./')
    # Extract and convert LNt32L24 to 24.24.24.32
    lattice_segment=$(echo "$substring" | grep -oP 'LNt\d+L\d+' | sed -E 's/LNt([0-9]+)L([0-9]+)/\2.\2.\2.\1/')
    # Extract and convert m0p08 to 0.08
    mass_segment=$(echo "$substring" | grep -oP 'm\K\d+p\d+' | sed 's/p/./')
    # Extract and convert Ls8 to Ls=8
    Ls_segment=$(echo "$substring" | grep -oP 'Ls\d+' | sed 's/Ls//')
    #---------------------------------------------------------------------------
    # Extracted data from the substring
    $white; printf "6p9                    : "; $bold; $yellow; printf '%s'"${beta_telos_segment}"; printf "\n"; $white; $reset_colors;
    $white; printf "m0p08                  : "; $bold; $yellow; printf '%s'"${mass_segment}"; printf "\n"; $white; $reset_colors;
    $white; printf "LNt32L24               : "; $bold; $yellow; printf '%s'"${lattice_segment}"; printf "\n"; $white; $reset_colors;
    $white; printf "Ls8                    : "; $bold; $yellow; printf '%s'"${Ls_segment}"; printf "\n"; $white; $reset_colors;
    $yellow; printf "                       ------------------------------------------\n"; $white; $reset_colors;
    #---------------------------------------------------------------------------
    # Starting the looping structure
    #---------------------------------------------------------------------------
    #for k in $(seq 0 `expr ${#ntasks_per_node[@]} - 1`)
    #do
    #  ntpn=$(printf "ntpn%03d" "${ntasks_per_node[$k]}";)
    #for j in $(seq 0 `expr ${#grid_dwf_telos_lattice_size_gpu[@]} - 1`)
    #do
      #lattice=$(printf "lat%s" "${grid_dwf_telos_lattice_size_gpu[$j]}";)

      lattice=$(printf "lat%s" "${lattice_segment}";)

      for i in $(seq 0 `expr ${#grid_large_n_nodes_gpu[@]} - 1`)
      do
        # Generate all unique 4-number combinations
        nodes_x_gpus_per_node=$(echo "${grid_large_n_nodes_gpu[$i]}*$gpus_per_node"|bc);

# Combinatorics loop over MPI distributions
K=1
_mpi_distr=""
for ((ix = 1; ix <= gpus_per_node; ix++)); do
  for ((iy = 1; iy <= gpus_per_node; iy++)); do
    for ((iz = 1; iz <= gpus_per_node; iz++)); do
      for ((it = 1; it <= gpus_per_node; it++)); do
        # Calculate the product of the four numbers
        product=$((ix * iy * iz * it))
        #echo "product --->: $product"
        # Check if the product is equals to number of nodes nodes
        if ((product == nodes_x_gpus_per_node)); then
          _mpi_distr="${ix}.${iy}.${iz}.${it}"
          #echo "_mpi_distr --->: $_mpi_distr"
          K=$(expr $K + 1)
          mpi_distr=$(printf "mpi%s" "${_mpi_distr}"| sed -E 's/([0-9]+)/0\1/g' | sed 's/\./\-/g')

          cnt=$(printf "%03d" "$H")
          index=$(printf "%03d" "$i")
          n_nodes=$(printf "nodes%03d" "${grid_large_n_nodes_gpu[$i]}";)
          __mpi_distr_FileTag=$(printf "${mpi_distr}")
          #_${__batch_action}_${substring}_${n_nodes}_${__mpi_distr_FileTag}_${__simulation_size}
          #_${beta_telos_segment}_${mass_segment}_${lattice}_${Ls_segment}
          __batch_file_construct=$(printf "Run_${__batch_action}_${substring}_${n_nodes}_${__mpi_distr_FileTag}_${__simulation_size}")
          __batch_file_out=$(printf "${__batch_file_construct}.sh")
          __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_action}/${__simulation_size}/${__batch_file_construct}")

          $cyan;printf "                       : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors

          # TODO: continue from here: first check the file convention is correct.
          # Creating the path in question
          Batch_util_create_path "${__path_to_run}"
          # Now creating the Batch file: __batch_file_out in __path_to_run
          $white; printf "                       : ";
          $yellow; printf "Creating the Batch script from the methods: "; $bold;
          $cyan; printf "$__batch_file_out\n"; $white; $reset_colors;

          # Specifying the number of cpus_per_task which can be machine dependent
          # Defaulting to the number of gpu on the node MareNostrum is a special case with 20
          cpus_per_task=${gpus_per_node}
          if [[ $machine_name = "MareNostrum" ]]
          then
            #cpus_per_task=$(expr ${gpus_per_node} \* 20)
            cpus_per_task=$(expr 1 \* 20)
          fi

          # Here need to invoke the configuration method config_Batch_with_input_from_system_config
          #ntasks_per_node=$(expr ${grid_large_n_nodes_gpu[$i]} \* ${_core_count})
          #ntasks_per_node=${ntasks_per_node[$k]} #$(expr ${sombrero_small_weak_n_nodes[$i]} \* ${_core_count})
          ntasks_per_node="$gpus_per_node"
          config_Batch_with_input_from_system_config \
            "${grid_large_n_nodes_gpu[$i]}"          \
            "${_core_count}"                         \
            "$ntasks_per_node"                       \
            "$gpus_per_node"                         \
            "$target_partition_gpu"                  \
            "${__batch_file_construct}"              \
            "10:00:00"                               \
            "$qos"

          # Writing the header to files
          cat << EOF > "${__path_to_run}${sptr}${__batch_file_out}"
$(Batch_header ${__path_to_run} ${__accelerator} ${__project_account} ${gpus_per_node} ${__accelerator} ${__simulation_size} ${machine_name} ${_nodes} ${_ntask} ${_ntasks_per_node} ${_cpus_per_task} ${_partition} ${_job_name} ${_time} ${_qos})
$(
          case $__batch_action in
            *"Sombrero_weak"*)          echo "#---> this is a ${__batch_file_construct} job run" ;;
            *"Sombrero_strong"*)        echo "#---> this is a ${__batch_file_construct} job run" ;;
            *"BKeeper"*)                echo "#---> this is a ${__batch_file_construct} job run" ;;
            *"HiRep-LLR-master-cpu"*)   echo "#---> this is a HiRep-LLR-master-cpu job run"      ;;
            *"HiRep-LLR-master-gpu"*)   echo "#---> this is a HiRep-LLR-master-gpu job run"      ;;
            *"Grid_DWF_run_gpu"*)       echo "#---> this is a Grid_DWF_run_gpu job run"          ;;
            *"Grid_DWF_Telos_run_gpu"*) echo "#---> this is a Grid_DWF_Telos_run_gpu job run"    ;;
          esac
    )
EOF
          #-------------------------------------------------------------------------
          # Constructing the rest of the batch file body
          #-------------------------------------------------------------------------
          Batch_body_Run_Grid_DWF_Telos_gpu                                                   \
            "${machine_name}" "${grid_DWF_Telos_dir}" "${LatticeRuns_dir}"                    \
            "${benchmark_input_dir}" "${__path_to_run}${sptr}${__batch_file_out}"             \
            "${lattice_segment}" "${_mpi_distr}"  "${__simulation_size}"  \
            "${__batch_file_construct}" "${prefix}" "${__path_to_run}"                        \
            "${module_list}" "${sourcecode_dir}" "${DWF_ensembles_GRID_dir}" "${substring}"   \
            "${beta_telos_segment}" "${mass_segment}" "${Ls_segment}"

          #"${grid_dwf_telos_lattice_size_gpu[$j]}"
        fi

      done
    done
  done
done
        # incrementing the counter
        #L=$(expr $L + 1)
      #done
      H=$(expr $H + 1)
    done # [end-for-loop] ${#grid_large_n_nodes_gpu[@]}
    #  T=$(expr $T + 1)
    #done
      M=$(expr $M + 1)
    #done # [end-for-loop] grid_dwf_telos_lattice_size_gpu[@]}


  else
    $white; printf "Directory substring    : "; $bold;
    $magenta; printf '%s'"${substring}"; $red; printf " does not exist.\n";
    $white; $reset_colors;
    $yellow; printf "                       ------------------------------------------\n"; $white; $reset_colors;
  fi

done


      ;;
  *"HiRep-LLR-master-cpu"*)
      ;;
  *"HiRep-LLR-master-gpu"*)
      ;;
esac

echo ""
echo "project_account --->: $__project_account"
echo "core_count      --->: $_core_count"
echo "mem_total       --->: $_mem_total"
echo "gpu_count       --->: $_gpu_count"

#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  creator_bench_controller_batch.sh Done.              -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$reset_colors
#exit
#-------------------------------------------------------------------------------
