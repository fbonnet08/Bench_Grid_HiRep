#!/bin/bash
#-------------------------------------------------------------------------------
# Declaring the arrays for the benches marks
# Getting the common code setup and variables,
# setting up the environment properly.
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Instantiating the benchmarks arrays
#-------------------------------------------------------------------------------
declare -a ntasks_per_node=(1 2 4 8 16 32 64 128 256)

declare -a ntasks_per_node_leonardo_special=(1 2 3 6 12 24 48 96)

# Leonardo decomposition over 112 = (1,2,4,7,8,14,16,28,56,112)
# division by primes 2,7 over 112 = (4,8,14,16,28,56,112)
# Best decomposition of over  112 = (1 2 3 6 12 24 48 96) with --ntasks-per-socket=(ntasks_per_node / 2)

#declare -a mpi_permutation=(1 1 2 3)
declare -a mpi_distribution=(
"1.1.1.2"
)
#"1.1.1.8" "1.8.2.1" "1.1.8.2" "1.1.2.8"
#"1.4.1.4" "1.1.4.4" "2.1.1.8" "2.2.2.2" "4.4.1.1"
#"4.1.4.1" "4.1.1.4" "8.1.1.8" "8.1.2.8" "8.1.8.8" "8.1.2.1"
#)
#"1.1.2.3"
#-------------------------------------------------------------------------------
# SOMBRERO:
#-------------------------------------------------------------------------------
# In all cases, fill entire node
#Small, strong scaling, n_nodes=1, 2, 3, 4, 6, 8, 12
#Large, strong scaling; small/large, weak scaling, n_nodes=1, 2, 3, 4, 6, 8, 12, 16, 24, 32
declare -a sombrero_small_weak_n_nodes=(1 2 4) # 6 8 12 16 24 32)
declare -a sombrero_large_weak_n_nodes=(1 2 4) # 6 8 12 16 24 32)
declare -a sombrero_small_strong_n_nodes=(1 2 4) # 6 8 12)
declare -a sombrero_large_strong_n_nodes=(1 2 4) # 6 8 12 16 24 32)
# TODO: add the other possibilities if any
#-------------------------------------------------------------------------------
# BKeeper CPU:
#-------------------------------------------------------------------------------
#--grid 24.24.24.32, use a sensible --mpi and ntasks-per-node, n_nodes=1, 2, 3, 4, 6, 8, 12, 16
#--grid 64.64.64.96, use a sensible --mpi and ntasks-per-node, n_nodes=1, 2, 3, 4, 6, 8, 12, 16, 24, 32
#--grid 24.24.24.{number of MPI ranks} --mpi 1.1.2.{number of MPI ranks/2}, n_nodes=1, 2, 3, 4, 6, 8, 12, 16, 24, 32
declare -a bkeeper_lattice_size_cpu=("24.24.24.32") # "32.32.32.64" "64.64.64.96")
declare -a bkeeper_small_n_nodes_cpu=(1 2)
declare -a bkeeper_large_n_nodes_cpu=(4 6) # 8 12 16 24 32)
# TODO: add the other possibilities if any
#-------------------------------------------------------------------------------
# BKeeper GPU:
#-------------------------------------------------------------------------------
#--grid 24.24.24.32, use a sensible --mpi from above, one task per GPU, nodes=1, 2, 3, 4, 6, 8, 12, 16
#--grid 64.64.64.96, use a sensible --mpi from above, one task per GPU, nodes=1, 2, 3, 4, 6, 8, 12, 16, 24, 32
#--grid 24.24.24.{number of MPI ranks} --mpi 1.1.2.{number of MPI ranks/2}, nodes=1, 2, 3, 4, 6, 8, 12, 16, 24, 32
#--grid 48.48.48.64 --mpi 1.1.1.4, scan GPU clock frequency
declare -a bkeeper_lattice_size_gpu=("24.24.24.32" "32.32.32.64" "64.64.64.96")
declare -a bkeeper_small_lattice_size_gpu=("24.24.24.32")
declare -a bkeeper_large_lattice_size_gpu=("24.24.24.32") # "32.32.32.64" "64.64.64.96")
declare -a bkeeper_mpi_gpu=("24.24.24.32") # "32.32.32.64" "64.64.64.96")
declare -a bkeeper_lattice_size_clock_gpu=("48.48.48.64")
declare -a bkeeper_mpi_clock_gpu=("1.1.1.4")
declare -a bkeeper_small_n_nodes_gpu=(1 2)
declare -a bkeeper_large_n_nodes_gpu=(4 8) # 12 6 16 24 32)
# TODO: add the other possibilities if any
#-------------------------------------------------------------------------------
# Grid GPU:
#-------------------------------------------------------------------------------
#tests/sp2n/Test_hmc_Sp_WF_2_Fund_3_2AS.cc, using a thermalised starting configuration
#--grid 32.32.32.64, use a sensible --mpi, one task per GPU, nodes=1, 2, 4, 8, 16, 32
declare -a grid_large_n_nodes=(1 2 4 8 16 32)
declare -a grid_lattice_size_gpu=("32.32.32.64")
# TODO: add the other possibilities if any
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
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  config_Run_Batchs.sh Done.                           -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$reset_colors
#exit
#-------------------------------------------------------------------------------

