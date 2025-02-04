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
# Getting the slurm values for the batch job
#-------------------------------------------------------------------------------
case $__batch_action in
  *"Sombrero_weak"*)        config_Batch_Sombrero_weak_cpu    ;;
  *"Sombrero_strong"*)      config_Batch_Sombrero_strong_cpu  ;;
  *"BKeeper_run_cpu"*)      config_Batch_BKeeper_run_cpu      ;; # backup default value in case the following fails
  *"BKeeper_run_gpu"*)      config_Batch_BKeeper_run_gpu      ;; # to avoid incomplete fields and blank variable
  *"HiRep-LLR-master-cpu"*) config_Batch_HiRep-LLR-master_cpu ;;
  *"HiRep-LLR-master-gpu"*) config_Batch_HiRep-LLR-master_gpu ;;
  *"BKeeper_compile"*)      bash -s < ./creator_bench_case_batch.sh "$__project_account" "$__external_lib_dir" "$__batch_action"; ;;
  *)
    echo
    $red; printf "The batch action is either incorrect or missing: \n";
    $yellow; printf "[BKeeper_compile, BKeeper_run, Sombrero_weak, Sombrero_strong,";
             printf " HiRep-LLR-master-cpu]\n";
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
$green; printf "Moving Scripts/Batch_Scripts dir and submitting job: "; $bold;
$magenta; printf "${batch_Scripts_dir}\n"; $white; $reset_colors;
cd ${batch_Scripts_dir}
#ls -al

echo "machine name                ----> $machine_name"
echo "module list                 ----> $module_list"
echo "batch action                ----> $__batch_action"
echo "batch file basinc construct ----> $__batch_file_out"

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Creating batch file for batch action: ";
$magenta;printf "$__batch_action\n"; $white; $reset_colors;
#-------------------------------------------------------------------------------
# Now creating the batch script for a case in question
#-------------------------------------------------------------------------------
# TODO: create loop here for the different cases.
case "$__batch_action" in
  *"Sombrero_weak"*)
    #-------------------------------------------------------------------------------
    # Sombrero[Weak-Small]:
    #-------------------------------------------------------------------------------
    #__batch_action="Sombrero_weak" #$2
    # constructing the files and directory structure
    __simulation_size="small"
    H=1
    #L=1
    #for j in $(seq 0 `expr ${#ntasks_per_node[@]} - 1`)
    #do
    for i in $(seq 0 `expr ${#sombrero_small_weak_n_nodes[@]} - 1`)
    do
      cnt=$(printf "%03d" $H)
      index=$(printf "%03d" $i)
      n_nodes=$(printf "nodes%03d" ${sombrero_small_weak_n_nodes[$i]};)
      #ntpn=$(printf "ntpn%03d" ${ntasks_per_node[$j]};)
      # Orchestrating the file construction
      __batch_file_construct=$(printf "Run_${__batch_action}_${n_nodes}_${__simulation_size}")
      #__batch_file_construct=$(printf "Run_${__batch_action}_${n_nodes}_${ntpn}_${__simulation_size}")
      __batch_file_out=$(printf "${__batch_file_construct}.sh")
      #__path_to_run=$(printf "${LatticeRuns_dir}/${__batch_file_construct}")
      __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_action}/${__simulation_size}/${__batch_file_construct}")

      #$cyan;printf "bkeeper_large_n_nodes_cpu[$index] : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors
      $cyan;printf "                       : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors

      # Creating the path in question
      Batch_util_create_path "${__path_to_run}"

      # Now creating the Batch file: __batch_file_out in __path_to_run
      $green; printf "Creating the Batch script from the methods: "; $bold;
      $cyan; printf "$__batch_file_out\n"; $white; $reset_colors;

      # Here need to invoke the configuration method config_Batch_with_input_from_system_config
      ntasks_per_node=$(expr "${sombrero_small_weak_n_nodes[$i]}" \* "${_core_count}")
      #ntasks_per_node=${ntasks_per_node[$j]} #$(expr ${sombrero_small_weak_n_nodes[$i]} \* ${_core_count})
      config_Batch_with_input_from_system_config \
        "${sombrero_small_weak_n_nodes[$i]}"     \
        "${_core_count}"                         \
        "$ntasks_per_node"                       \
        1                                        \
        "cpu"                                    \
        "${__batch_file_construct}"              \
        "2:0:0"                                  \
        "standard"

      # Writting the header to files
      cat << EOF > "${__path_to_run}${sptr}${__batch_file_out}"
$(Batch_header ${_nodes} ${_ntask} ${_ntasks_per_node} ${_cpus_per_task} ${_partition} ${_job_name} ${_time} ${_qos})
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
    #  L=$(expr $L + 1)
    #done
    #-------------------------------------------------------------------------------
    # Sombrero[Weak-Large]:
    #-------------------------------------------------------------------------------
    #__batch_action="Sombrero_weak" #$2
    # constructing the files and directory structure
    __simulation_size="large"
    H=1
    #L=1
    #for j in $(seq 0 `expr ${#ntasks_per_node[@]} - 1`)
    #do
    for i in $(seq 0 `expr ${#sombrero_large_weak_n_nodes[@]} - 1`)
    do
      cnt=$(printf "%03d" $H)
      index=$(printf "%03d" $i)
      n_nodes=$(printf "nodes%03d" "${sombrero_large_weak_n_nodes[$i]}";)
      #ntpn=$(printf "ntpn%03d" "${ntasks_per_node[$j]}";)
      # Orchestrating the file construction
      __batch_file_construct=$(printf "Run_${__batch_action}_${n_nodes}_${__simulation_size}")
      #__batch_file_construct=$(printf "Run_${__batch_action}_${n_nodes}_${ntpn}_${__simulation_size}")
      __batch_file_out=$(printf "${__batch_file_construct}.sh")
      #__path_to_run=$(printf "${LatticeRuns_dir}/${__batch_file_construct}")
      __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_action}/${__simulation_size}/${__batch_file_construct}")

      #$cyan;printf "bkeeper_large_n_nodes_cpu[$index] : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors
      $cyan;printf "                       : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors

      # Creating the path in question
      Batch_util_create_path "${__path_to_run}"

      # Now creating the Batch file: __batch_file_out in __path_to_run
      $green; printf "Creating the Batch script from the methods: "; $bold;
      $cyan; printf "$__batch_file_out\n"; $white; $reset_colors;

      # Here need to invoke the configuration method config_Batch_with_input_from_system_config
      ntasks_per_node=$(expr "${sombrero_large_weak_n_nodes[$i]}" \* "${_core_count}")
      #ntasks_per_node=${ntasks_per_node[$j]} #$(expr ${sombrero_small_weak_n_nodes[$i]} \* ${_core_count})
      config_Batch_with_input_from_system_config \
        "${sombrero_large_weak_n_nodes[$i]}"     \
        "${_core_count}"                         \
        "$ntasks_per_node"                       \
        1                                        \
        "cpu"                                    \
        "${__batch_file_construct}"              \
        "2:0:0"                                  \
        "standard"

      # Writting the header to files
      cat << EOF > "${__path_to_run}${sptr}${__batch_file_out}"
$(Batch_header ${_nodes} ${_ntask} ${_ntasks_per_node} ${_cpus_per_task} ${_partition} ${_job_name} ${_time} ${_qos})
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
    #  L=$(expr $L + 1)
    #done
      ;;
  *"Sombrero_strong"*)
    #-------------------------------------------------------------------------------
    # Sombrero[Strong-Small]:
    #-------------------------------------------------------------------------------
    # constructing the files and directory structure
    __simulation_size="small"
    H=1
    #L=1
    #for j in $(seq 0 `expr ${#ntasks_per_node[@]} - 1`)
    #do
    for i in $(seq 0 `expr ${#sombrero_small_strong_n_nodes[@]} - 1`)
    do
      cnt=$(printf "%03d" $H)
      index=$(printf "%03d" $i)
      n_nodes=$(printf "nodes%03d" "${sombrero_small_strong_n_nodes[$i]}";)
      #ntpn=$(printf "ntpn%03d" "${ntasks_per_node[$j]}";)
      # Orchestrating the file construction
      __batch_file_construct=$(printf "Run_${__batch_action}_${n_nodes}_${__simulation_size}")
      #__batch_file_construct=$(printf "Run_${__batch_action}_${n_nodes}_${ntpn}_${__simulation_size}")
      __batch_file_out=$(printf "${__batch_file_construct}.sh")
      #__path_to_run=$(printf "${LatticeRuns_dir}/${__batch_file_construct}")
      __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_action}/${__simulation_size}/${__batch_file_construct}")

      #$cyan;printf "bkeeper_large_n_nodes_cpu[$index] : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors
      $cyan;printf "                       : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors

      # Creating the path in question
      Batch_util_create_path "${__path_to_run}"

      # Now creating the Batch file: __batch_file_out in __path_to_run
      $green; printf "Creating the Batch script from the methods: "; $bold;
      $cyan; printf "$__batch_file_out\n"; $white; $reset_colors;

      # Here need to invoke the configuration method config_Batch_with_input_from_system_config
      ntasks_per_node=$(expr ${sombrero_small_strong_n_nodes[$i]} \* ${_core_count})
      #ntasks_per_node=${ntasks_per_node[$j]} #$(expr ${sombrero_small_weak_n_nodes[$i]} \* ${_core_count})
      config_Batch_with_input_from_system_config \
        "${sombrero_small_strong_n_nodes[$i]}"   \
        "${_core_count}"                         \
        "$ntasks_per_node"                       \
        1                                        \
        "cpu"                                    \
        "${__batch_file_construct}"              \
        "2:0:0"                                  \
        "standard"

      # Writting the header to files
      cat << EOF > "${__path_to_run}${sptr}${__batch_file_out}"
$(Batch_header ${_nodes} ${_ntask} ${_ntasks_per_node} ${_cpus_per_task} ${_partition} ${_job_name} ${_time} ${_qos})
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
      Batch_body_Run_Sombrero_strong \
      "${machine_name}" "${sombrero_dir}" "${LatticeRuns_dir}" "${__path_to_run}${sptr}${__batch_file_out}" \
      "${__simulation_size}" "${__batch_file_construct}" "${prefix}" "${__path_to_run}"

      # incrementing the counter
      H=$(expr $H + 1)
    done
    #  L=$(expr $L + 1)
    #done
    #-------------------------------------------------------------------------------
    # Sombrero[Strong-Large]:
    #-------------------------------------------------------------------------------
    # constructing the files and directory structure
    __simulation_size="large"
    H=1
    #L=1
    #for j in $(seq 0 `expr ${#ntasks_per_node[@]} - 1`)
    #do
    for i in $(seq 0 `expr ${#sombrero_large_strong_n_nodes[@]} - 1`)
    do
      cnt=$(printf "%03d" $H)
      index=$(printf "%03d" $i)
      n_nodes=$(printf "nodes%03d" "${sombrero_large_strong_n_nodes[$i]}";)
      #ntpn=$(printf "ntpn%03d" "${ntasks_per_node[$j]}";)
      # Orchestrating the file construction
      __batch_file_construct=$(printf "Run_${__batch_action}_${n_nodes}_${__simulation_size}")
      #__batch_file_construct=$(printf "Run_${__batch_action}_${n_nodes}_${ntpn}_${__simulation_size}")
      __batch_file_out=$(printf "${__batch_file_construct}.sh")
      #__path_to_run=$(printf "${LatticeRuns_dir}/${__batch_file_construct}")
      __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_action}/${__simulation_size}/${__batch_file_construct}")

      #$cyan;printf "bkeeper_large_n_nodes_cpu[$index] : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors
      $cyan;printf "                       : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors

      # Creating the path in question
      Batch_util_create_path "${__path_to_run}"

      # Now creating the Batch file: __batch_file_out in __path_to_run
      $green; printf "Creating the Batch script from the methods: "; $bold;
      $cyan; printf "$__batch_file_out\n"; $white; $reset_colors;

      # Here need to invoke the configuration method config_Batch_with_input_from_system_config
      ntasks_per_node=$(expr ${sombrero_large_strong_n_nodes[$i]} \* ${_core_count})
      #ntasks_per_node=${ntasks_per_node[$j]} #$(expr ${sombrero_small_weak_n_nodes[$i]} \* ${_core_count})
      config_Batch_with_input_from_system_config \
        "${sombrero_large_strong_n_nodes[$i]}"   \
        "${_core_count}"                         \
        "$ntasks_per_node"                       \
        1                                        \
        "cpu"                                    \
        "${__batch_file_construct}"              \
        "2:0:0"                                  \
        "standard"

      # Writting the header to files
      cat << EOF > "${__path_to_run}${sptr}${__batch_file_out}"
$(Batch_header ${_nodes} ${_ntask} ${_ntasks_per_node} ${_cpus_per_task} ${_partition} ${_job_name} ${_time} ${_qos})
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
      Batch_body_Run_Sombrero_strong \
      "${machine_name}" "${sombrero_dir}" "${LatticeRuns_dir}" "${__path_to_run}${sptr}${__batch_file_out}" \
      "${__simulation_size}" "${__batch_file_construct}" "${prefix}" "${__path_to_run}"

      # incrementing the counter
      H=$(expr $H + 1)
    done
    #  L=$(expr $L + 1)
    #done
      ;;
  *"BKeeper_run_cpu"*)
    #-------------------------------------------------------------------------------
    # BKeeper [Large-CPU]:
    #-------------------------------------------------------------------------------
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
        cnt=$(printf "%03d" $H)
        index=$(printf "%03d" $i)
        n_nodes=$(printf "nodes%03d" "${bkeeper_large_n_nodes_cpu[$i]}";)
        # Orchestrating the file construction
        #__batch_file_construct=$(printf "Run_${__batch_action}_${lattice}_${n_nodes}_${__simulation_size}")
        __mpi_distr_FileTag=$(printf "${mpi_distr}")
        __batch_file_construct=$(printf "Run_${__batch_action}_${lattice}_${n_nodes}_${ntpn}_${__mpi_distr_FileTag}_${__simulation_size}")
        __batch_file_out=$(printf "${__batch_file_construct}.sh")
        __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_action}/${__simulation_size}/${__batch_file_construct}")

        #$cyan;printf "bkeeper_large_n_nodes_cpu[$index] : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors
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



    # TODO: continue from here ..............
    __accelerator="gpu"
    __simulation_size="small"
    # constructing the files and directory structure
    H=1
    L=1
    T=1
    M=1
    for l in $(seq 0 `expr ${#bkeeper_mpi_clock_gpu[@]} - 1`)
    do
    mpi_distr=$(printf "mpi%s" "${bkeeper_mpi_clock_gpu[$l]}"| sed -E 's/([0-9]+)/0\1/g' | sed 's/\./\-/g')
    for k in $(seq 0 `expr ${#ntasks_per_node[@]} - 1`)
    do
      ntpn=$(printf "ntpn%03d" "${ntasks_per_node[$k]}";)
    for j in $(seq 0 `expr ${#bkeeper_lattice_size_gpu[@]} - 1`)
    do
      lattice=$(printf "lat%s" "${bkeeper_lattice_size_gpu[$j]}";)

      for i in $(seq 0 `expr ${#bkeeper_small_n_nodes_gpu[@]} - 1`)
      do
        cnt=$(printf "%03d" "$H")
        index=$(printf "%03d" "$i")
        n_nodes=$(printf "nodes%03d" "${bkeeper_small_n_nodes_gpu[$i]}";)
        # Orchestrating the file construction
        #__batch_file_construct=$(printf "Run_${__batch_action}_${lattice}_${n_nodes}_${__simulation_size}")
        __mpi_distr_FileTag=$(printf "${mpi_distr}")
        __batch_file_construct=$(printf "Run_${__batch_action}_${lattice}_${n_nodes}_${ntpn}_${__mpi_distr_FileTag}_${__simulation_size}")
        __batch_file_out=$(printf "${__batch_file_construct}.sh")
        #__path_to_run=$(printf "${LatticeRuns_dir}/${__batch_file_construct}")
        __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_action}/${__simulation_size}/${__batch_file_construct}")

        #$cyan;printf "bkeeper_small_n_nodes_gpu[$index] : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors
        $cyan;printf "                       : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors

        # Creating the path in question
        Batch_util_create_path "${__path_to_run}"

        # Now creating the Batch file: __batch_file_out in __path_to_run
        $green; printf "Creating the Batch script from the methods: "; $bold;
        $cyan; printf "$__batch_file_out\n"; $white; $reset_colors;

        # Here need to invoke the configuration method config_Batch_with_input_from_system_config
        #ntasks_per_node=$(expr ${bkeeper_small_n_nodes_gpu[$i]} \* ${_core_count})
        ntasks_per_node=${ntasks_per_node[$k]} #$(expr ${sombrero_small_weak_n_nodes[$i]} \* ${_core_count})
        config_Batch_with_input_from_system_config \
          "${bkeeper_small_n_nodes_gpu[$i]}"       \
          "${_core_count}"                         \
          "$ntasks_per_node"                       \
          "$gpus_per_node"                         \
          "$target_partition_gpu"                  \
          "${__batch_file_construct}"              \
          "01:00:00"                               \
          "$qos"
          # TODO: need to take of the time for each jobs
          # TODO: need to take care of the qos on different systems
          # TODO: to be inserted in config_systems.sh
        # Writing the header to files
        cat << EOF > "${__path_to_run}${sptr}${__batch_file_out}"
$(Batch_header ${__accelerator} ${__project_account} ${gpus_per_node} ${__accelerator} ${__simulation_size} ${machine_name} ${_nodes} ${_ntask} ${_ntasks_per_node} ${_cpus_per_task} ${_partition} ${_job_name} ${_time} ${_qos})
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
      Batch_body_Run_BKeeper_gpu                                                        \
      "${machine_name}" "${sombrero_dir}" "${LatticeRuns_dir}" "${benchmark_input_dir}" \
      "${__path_to_run}${sptr}${__batch_file_out}"                                      \
      "${bkeeper_lattice_size_cpu[$j]}"                                                 \
      "${bkeeper_mpi_clock_gpu[$l]}"                                                    \
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

   echo "__project_account: $__project_account"





    #-------------------------------------------------------------------------------
    # BKeeper [Large-GPU]:
    #-------------------------------------------------------------------------------



      ;;
  *"HiRep-LLR-master-cpu"*)
      ;;
  *"HiRep-LLR-master-gpu"*)
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
echo "-                  creator_bench_controller_batch.sh Done.              -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$reset_colors
#exit
#-------------------------------------------------------------------------------
