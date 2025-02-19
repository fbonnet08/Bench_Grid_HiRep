#!/usr/bin/bash
target_file=/home/frederic/SwanSea/SourceCodes/LatticeRuns/Clusters/Lumi/LatticeRuns/target_BKeeper_run_gpu_small_batch_files.txt
LatticeRuns_dir=/home/frederic/SwanSea/SourceCodes/LatticeRuns
#-------------------------------------------------------------------------------
# Testing code begins
#-------------------------------------------------------------------------------
declare -a simulations_type_array=("small" "large")

for k in $(seq 0 `expr ${#simulations_type_array[@]} - 1`)
do
  printf "simulations_type_array[$k]} ----> ${simulations_type_array[k]} ----> "

  simulation_size=${simulations_type_array[k]}

  target_file_BKeeper_gpu_small="empty"
  target_file_BKeeper_gpu_large="empty"

  case $simulation_size in
    *"small"*)
      target_file_BKeeper_gpu_small="${LatticeRuns_dir}"/"target_BKeeper_run_gpu_small_batch_files"
      ;;
    *"large"*)
      target_file_BKeeper_gpu_large="${LatticeRuns_dir}"/"target_BKeeper_run_gpu_large_batch_files"
      ;;
    esac

  printf "${target_file_BKeeper_gpu_small} <--::--> ${target_file_BKeeper_gpu_large}\n"

done