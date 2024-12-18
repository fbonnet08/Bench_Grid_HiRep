#!/bin/bash
ARGV=`basename -a $1`
set -eu
scrfipt_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!     Code to launch BKeeper benchmarker                                !"
echo "!     $scrfipt_file_name                                            !"
echo "!     [Author]: Frederic Bonnet December 2024                           !"
echo "!     [usage]: testing_array.sh   {Input list}                          !"
echo "!     [example]: testing_array.sh /data/local                           !"
echo "!                                                                       !"
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
tput sgr0;
#-------------------------------------------------------------------------------
# Setting up the arrays for the benchmarks.
# Sombrero, BKeeper, grid and HiRep LLR-HMC CPU
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#                          The Benches
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
# TODO fix the path to the common block file at integration time
source ../../common_main.sh $1;
source ../../Scripts/Batch_Scripts/Batch_util_methods.sh;
source ../../config_system.sh
#-------------------------------------------------------------------------------
# SOMBRERO:
#-------------------------------------------------------------------------------
# In all cases, fill entire node
#Small, strong scaling, n_nodes=1, 2, 3, 4, 6, 8, 12
#Large, strong scaling; small/large, weak scaling, n_nodes=1, 2, 3, 4, 6, 8, 12, 16, 24, 32
declare -a sombrero_small_strong_n_nodes=(1 2 3 4 6 8 12)
declare -a sombrero_large_strong_n_nodes=(1 2 3 4 6 8 12 16 24 32)
declare -a sombrero_small_weak_n_nodes=(1 2 3 4 6 8 12 16 24 32)
declare -a sombrero_large_weak_n_nodes=(1 2 3 4 6 8 12 16 24 32)
#-------------------------------------------------------------------------------
# BKeeper CPU:
#-------------------------------------------------------------------------------
#--grid 24.24.24.32, use a sensible --mpi and ntasks-per-node, n_nodes=1, 2, 3, 4, 6, 8, 12, 16
#--grid 64.64.64.96, use a sensible --mpi and ntasks-per-node, n_nodes=1, 2, 3, 4, 6, 8, 12, 16, 24, 32
#--grid 24.24.24.{number of MPI ranks} --mpi 1.1.2.{number of MPI ranks/2}, n_nodes=1, 2, 3, 4, 6, 8, 12, 16, 24, 32
declare -a bkeeper_lattice_size_cpu=("24.24.24.32" "32.32.32.64" "64.64.64.96")
declare -a bkeeper_small_n_nodes_cpu=(1 2 3 4 6 8 12 16)
declare -a bkeeper_large_n_nodes_cpu=(1 2 3 4 6 8 12 16 24 32)
#-------------------------------------------------------------------------------
# BKeeper GPU:
#-------------------------------------------------------------------------------
#--grid 24.24.24.32, use a sensible --mpi from above, one task per GPU, nodes=1, 2, 3, 4, 6, 8, 12, 16
#--grid 64.64.64.96, use a sensible --mpi from above, one task per GPU, nodes=1, 2, 3, 4, 6, 8, 12, 16, 24, 32
#--grid 24.24.24.{number of MPI ranks} --mpi 1.1.2.{number of MPI ranks/2}, nodes=1, 2, 3, 4, 6, 8, 12, 16, 24, 32
#--grid 48.48.48.64 --mpi 1.1.1.4, scan GPU clock frequency
declare -a bkeeper_lattice_size_gpu=("24.24.24.32" "32.32.32.64" "64.64.64.96")
declare -a bkeeper_mpi_gpu=("24.24.24.32" "32.32.32.64" "64.64.64.96")
declare -a bkeeper_lattice_size_clock_gpu=("48.48.48.64")
declare -a bkeeper_mpi_clock_gpu=("1.1.1.4")
declare -a bkeeper_small_n_nodes_gpu=(1 2 3 4 6 8 12 16)
declare -a bkeeper_large_n_nodes_gpu=(1 2 3 4 6 8 12 16 24 32)



#-------------------------------------------------------------------------------
# Grid GPU:
#-------------------------------------------------------------------------------
#tests/sp2n/Test_hmc_Sp_WF_2_Fund_3_2AS.cc, using a thermalised starting configuration
#--grid 32.32.32.64, use a sensible --mpi, one task per GPU, nodes=1, 2, 4, 8, 16, 32
declare -a grid_large_n_nodes=(1 2 4 8 16 32)
declare -a grid_lattice_size_gpu=("32.32.32.64")
#-------------------------------------------------------------------------------
# HiRep LLR HMC CPU:
#-------------------------------------------------------------------------------
#Weak scaling, 1 rank per replica, number of replicas = total number of CPU cores (varies with platform),
#nodes=1, 2, 3, 4
#Strong scaling, number of CPU cores per node = number of replicas;
#total number of CPU cores = number of replicas * number of domains per replica, nodes=1, 2, 3, 4, 6, 8
declare -a HiRep_LLR_HMC_weak_n_nodes=(1 2 3 4)
declare -a HiRep_LLR_HMC_strong_n_nodes=(1 2 3 4 6 8)

#TODO. continue from here ....





# ##############################################################################
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Other template examples based on strings
#-------------------------------------------------------------------------------
declare -a path_to_data_dir=(
              "$sourcecode_dir"
              "$sombrero_dir"
              "$bkeeper_dir"
              "$Bench_Grid_HiRep_dir"
              "$benchmark_input_dir"
              "$batch_Scripts_dir"
              "$LatticeRuns_dir"
              "$Hirep_LLR_SP_dir"
              "$Hirep_LLR_SP_HMC_dir"
              "$HiRep_LLR_master_dir"
              "$HiRep_LLR_master_HMC_dir"
              "$HiRep_Cuda_dir"
              "$grid_dir"
              "$basedir"
              "$prefix"
              )
# getting the length of the strings
max_string_array=()
for i in $(seq 0 `expr ${#path_to_data_dir[@]} - 1`)
do max_string_array=(${max_string_array[@]} ${#path_to_data_dir[$i]}); done
#Initialising the max length to a either first entry of array or 80 characters
if   [ ${#path_to_data_dir[@]} -ne 0 ]; then max_string_length=${max_string_array[0]}
elif [ ${#path_to_data_dir[@]} -eq 0 ]; then max_string_length=80; fi
#getting the maximum length method #1
for n_nodes in "${max_string_array[@]}"
do ((n_nodes > max_string_length)) && max_string_length=$n_nodes; done
$cyan;printf "<-- Array length   --->: ";$green;printf "%i\n" ${#path_to_data_dir[@]};$white
$cyan;printf "<-- Max length dir --->: ";$yellow;printf "%i\n" ${max_string_length};$white
#launching the metadata extractor and plotters
G=1
for i in $(seq 0 `expr ${#path_to_data_dir[@]} - 1`)
do
    logfile=$(printf "out_launch_TotalDosePlotter_path_%03d.log" $i)
    sourcedir_in=${path_to_data_dir[$i]}
    index=$($green;printf "%03d" $G;$cyan)
    $cyan; printf "<-- Source dir     --->: [$index] --->: ";
    $yellow;printf "%-${max_string_length}s" $sourcedir_in;
    $green; printf " ---> ";$cyan;printf "$logfile\n"; $white;
    #sh TotalDoseAnalyser.sh $sourcedir_in $targetdir_in $dateSpan_in > $logfile &
    if [ $G -eq ${#path_to_data_dir[@]} ];then G=0; $red;printf "Waiting for procs ...\n";$white;wait;fi
    G=$(expr $G + 1)
done
$cyan;printf "<-- Process done   --->: ";$green;printf "%s\n" "Continuing...";$white
#-------------------------------------------------------------------------------
# ##############################################################################
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Checking if the target directory exists if not ceetee it
#-------------------------------------------------------------------------------
if [ -d ${LatticeRuns_dir} ]
then
  $white; printf "Directory              : "; $bold;
  $blue; printf '%s'"${LatticeRuns_dir}"; $green; printf " exist, nothing to do.\n"; $white; $reset_colors;
else
  $white; printf "Directory              : "; $bold;
  $blue; printf '%s'"${LatticeRuns_dir}"; $red;printf " does not exist, We will create it ...\n";
   $white; $reset_colors;
  mkdir -p ${LatticeRuns_dir}
  printf "                       : "; $bold;
  $green; printf "done.\n"; $reset_colors;
fi
echo
#-------------------------------------------------------------------------------
# scanning through the directories in question in ${LatticeRuns_dir}
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Directory structure creation
#-------------------------------------------------------------------------------













#-------------------------------------------------------------------------------
# Sombrero weak:
#-------------------------------------------------------------------------------
__batch_action="Sombrero_weak" #$2
# coinstructing the files and directory structure
H=1
  for i in $(seq 0 `expr ${#sombrero_small_strong_n_nodes[@]} - 1`)
  do
    cnt=$(printf "%03d" $H)
    index=$(printf "%03d" $i)
    n_nodes=$(printf "nodes%03d" ${sombrero_small_strong_n_nodes[$i]};)
    # Orchetstrating the file construction
    __batch_file_construct=$(printf "Run_${__batch_action}_${n_nodes}_small")
    __batch_file_out=$(printf "${__batch_file_construct}.sh")
    __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_file_construct}")

    #$cyan;printf "bkeeper_large_n_nodes_cpu[$index] : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors
    $cyan;printf "                       : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors

    # Creating the path in question
    Batch_util_create_path ${__path_to_run}

    # incrementing the counter
    H=$(expr $H + 1)
  done




#-------------------------------------------------------------------------------
# Sombrero Strong:
#-------------------------------------------------------------------------------
__batch_action="Sombrero_strong" #$2
# coinstructing the files and directory structure
H=1
  for i in $(seq 0 `expr ${#sombrero_large_strong_n_nodes[@]} - 1`)
  do
    cnt=$(printf "%03d" $H)
    index=$(printf "%03d" $i)
    n_nodes=$(printf "nodes%03d" ${sombrero_large_strong_n_nodes[$i]};)
    # Orchetstrating the file construction
    __batch_file_construct=$(printf "Run_${__batch_action}_${n_nodes}_large")
    __batch_file_out=$(printf "${__batch_file_construct}.sh")
    __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_file_construct}")

    #$cyan;printf "bkeeper_large_n_nodes_cpu[$index] : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors
    $cyan;printf "                       : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors

    # Creating the path in question
    Batch_util_create_path ${__path_to_run}

    # incrementing the counter
    H=$(expr $H + 1)
  done
















#-------------------------------------------------------------------------------
# BKeeper CPU:
#-------------------------------------------------------------------------------
__batch_action="BKeeper_run_cpu" #$2
# coinstructing the files and directory structure
H=1
L=1
for j in $(seq 0 `expr ${#bkeeper_lattice_size_cpu[@]} - 1`)
do
  lattice=$(printf "lat%s" ${bkeeper_lattice_size_cpu[$j]};)

  for i in $(seq 0 `expr ${#bkeeper_large_n_nodes_cpu[@]} - 1`)
  do
    cnt=$(printf "%03d" $H)
    index=$(printf "%03d" $i)
    n_nodes=$(printf "nodes%03d" ${bkeeper_large_n_nodes_cpu[$i]};)
    # Orchetstrating the file construction
    __batch_file_construct=$(printf "Run_${__batch_action}_${n_nodes}_${lattice}")
    __batch_file_out=$(printf "${__batch_file_construct}.sh")
    __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_file_construct}")

    #$cyan;printf "bkeeper_large_n_nodes_cpu[$index] : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors
    $cyan;printf "                       : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors

    # Creating the path in question
    Batch_util_create_path ${__path_to_run}

    # incrementing the counter
    H=$(expr $H + 1)
  done
  L=$(expr $L + 1)
done
#-------------------------------------------------------------------------------
# BKeeper GPU:
#-------------------------------------------------------------------------------
# constructing the files and directory structure
__batch_action="BKeeper_run_gpu" #$2
H=1
L=1
for j in $(seq 0 `expr ${#bkeeper_lattice_size_gpu[@]} - 1`)
do
  lattice=$(printf "lat%s" ${bkeeper_lattice_size_gpu[$j]};)

  for i in $(seq 0 `expr ${#bkeeper_large_n_nodes_cpu[@]} - 1`)
  do
    cnt=$(printf "%03d" $H)
    index=$(printf "%03d" $i)
    n_nodes=$(printf "nodes%03d" ${bkeeper_large_n_nodes_cpu[$i]};)
    # Orchetstrating the file construction
    __batch_file_construct=$(printf "Run_${__batch_action}_${n_nodes}_${lattice}")
    __batch_file_out=$(printf "${__batch_file_construct}.sh")
    __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_file_construct}")

    #$cyan;printf "bkeeper_large_n_nodes_cpu[$index] : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors
    $cyan;printf "                       : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors

    # Creating the path in question
    Batch_util_create_path ${__path_to_run}

    # incrementing the counter
    H=$(expr $H + 1)
  done
  L=$(expr $L + 1)
done

#-------------------------------------------------------------------------------
# Scanning the directories for thw benches
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#Loop over all projectfolders as they all should start with 20 (eg 2019, 2020, 2021, etc)
#20*/
echo $LatticeRuns_dir
lookfor=${LatticeRuns_dir}$sptr$all
for dir in $lookfor
do
    cd $dir
    #Store projName variable for use in filenames
    projName="${PWD##*/}"
    printf "projName --->: ${projName} --->: "
    printf "Retrieve from directory: ${dir}\n"
    #TODO: continue the loop from here
done
#-------------------------------------------------------------------------------
# Printing the array sizes and thing
#-------------------------------------------------------------------------------
$cyan;printf "<-- Array length   --->: [sombrero_small_strong_n_nodes] --->: ";
$green;printf "%i\n" ${#sombrero_small_strong_n_nodes[@]};$white

$cyan;printf "<-- Array length   --->: [sombrero_large_strong_n_nodes] --->: ";
$green;printf "%i\n" ${#sombrero_large_strong_n_nodes[@]};$white

$cyan;printf "<-- Array length   --->: [grid_large_n_nodes           ] --->: ";
$green;printf "%i\n" ${#grid_large_n_nodes[@]};$white

$cyan;printf "<-- Array length   --->: [grid_lattice_size_gpu        ] --->: ";
$green;printf "%i\n" ${#grid_lattice_size_gpu[@]};$white
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  testing_array.sh Done.                               -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#exit
#-------------------------------------------------------------------------------


