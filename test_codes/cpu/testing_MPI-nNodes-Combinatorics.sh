#!/bin/bash
ARGV=`basename -a $1 $2 $3`
script_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!  Code to load modules and prepare the base dependencies for grid      !"
echo "!  $script_file_name                                                    !"
echo "!  [Author]: Frederic Bonnet October 2024                               !"
echo "!  [usage]: sh testing_MPI-nNodes-Combinatorics.sh {nodes}{gpu}{mpi}    !"
echo "!  [example]: sh testing_MPI-nNodes-Combinatorics.sh 8 8 8              !"
echo "!                                                                       !"
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
tput sgr0;
#colors
red="tput setaf 1"  ;green="tput setaf 2"  ;yellow="tput setaf 3"
blue="tput setaf 4" ;magenta="tput setaf 5";cyan="tput setaf 6"
white="tput setaf 7";bold=""               ;reset_colors="tput sgr0"
# Global variables and fixed Unix operators
sleep_time=2
sptr="/";
all="*";
dot=".";
echo "--------------------------------------------------"
# Number of nodes to run on
nodes=$1
echo "number of nodes to run --->: $nodes"
# Number of gpus-per-node
gpus_per_node=$2
echo "gpus_per_node          --->: $gpus_per_node"
# Maximum mpi allowance
mpi_max=$3
echo "mpi_max                --->: $mpi_max"

nodes_x_gpus_per_node=$(echo "$nodes*$gpus_per_node"|bc);
#nodes_x_gpus_per_node=$(expr $nodes * $gpus_per_node)
echo "nodes_x_gpus_per_node  --->: $nodes_x_gpus_per_node"
echo "--------------------------------------------------"

# Generate all unique 4-number combinations
K=1
_mpi_distr=""
for ((i = 1; i <= mpi_max; i++)); do
  for ((j = 1; j <= mpi_max; j++)); do
    for ((k = 1; k <= mpi_max; k++)); do
      for ((l = 1; l <= mpi_max; l++)); do
        # Calculate the product of the four numbers
        product=$((i * j * k * l))
        # Check if the product is equals to number of nodes nodes
        if ((product == nodes_x_gpus_per_node)); then
          _mpi_distr="${i}.${j}.${k}.${l}"
          echo "$_mpi_distr"
          K=$(expr $K + 1)
        fi
      done
    done
  done
done
echo "--------------------------------------------------"
echo "Number of combinations --->: $K"
echo "--------------------------------------------------"
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  testing_MPI-nNodes-Combinatorics.sh Done.             -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$reset_colors
#exit
#-------------------------------------------------------------------------------
