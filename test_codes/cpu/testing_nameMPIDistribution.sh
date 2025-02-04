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
echo "!     [usage]: testing_nameMPIDistribution.sh   {Input list}            !"
echo "!     [example]: testing_nameMPIDistribution.sh /data/local             !"
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
source ../../config_Run_Batchs.sh
#-------------------------------------------------------------------------------
# Mapping of the mpi_distribution for file name conevention:
#-------------------------------------------------------------------------------
H=1
for i in $(seq 0 `expr ${#mpi_distribution[@]} - 1`)
do
  cnt=$(printf "%03d" $H)
  index=$(printf "%03d" $i)
  mpi_distr=$(printf "mpi%s" "${mpi_distribution[$i]}";)
  # Orchestrating the file construction
  #line_date=$(echo "${mpi_distr}" | sed -E 's/([0-9]+)/00\1/g; s/0*([0-9]{3})/\1/g'|sed 's/\./\-/g')
  line_date=$(printf "${mpi_distr}" | sed -E 's/([0-9]+)/0\1/g' | sed 's/\./\-/g')
  __mpi_distr_FileTag=$(printf "${line_date}")

  $cyan;printf "mpi_distribution[$(printf "%03d" "${i}")]  : ${mpi_distribution[$i]} --->: $__mpi_distr_FileTag\n";
  $reset_colors

  # incrementing the counter
  H=$(expr $H + 1)

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

$cyan;printf "<-- Array length   --->: [mpi_distribution             ] --->: ";
$green;printf "%i\n" ${#mpi_distribution[@]};$white
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  testing_nameMPIDistribution.sh Done.                 -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#exit
#-------------------------------------------------------------------------------

