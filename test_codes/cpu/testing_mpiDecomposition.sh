#!/bin/bash
ARGV=`basename -a $1 $2 $3`
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
for ((i = 1; i <= mpi_max; i++)); do
  for ((j = 1; j <= mpi_max; j++)); do
    for ((k = 1; k <= mpi_max; k++)); do
      for ((l = 1; l <= mpi_max; l++)); do
        # Calculate the product of the four numbers
        product=$((i * j * k * l))
        # Check if the product is equals to number of nodes nodes
        if ((product == nodes_x_gpus_per_node)); then
          echo "${i}.${j}.${k}.${l}"
        fi
      done
    done
  done
done
echo "--------------------------------------------------"
