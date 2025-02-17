#!/usr/bin/bash
target_file=/home/frederic/SwanSea/SourceCodes/LatticeRuns/Clusters/Lumi/LatticeRuns/target_BKeeper_run_gpu_small_batch_files.txt
#-------------------------------------------------------------------------------
# Testing code begins
#-------------------------------------------------------------------------------
if [ -f "$target_file" ]
then
  echo "Target_file ---->: $target_file ---->: exists"
else
  echo "Target_file ---->: $target_file ---->: does not exists"
fi

declare -a target_file_array=()
N=1
while read line
do
    if [ -f "$line" ]
    then
      printf "Target_file ---->: $line ---->: exists\n"
    else
      printf "Target_file ---->: $line ---->: does not exists"
    fi

    target_file_array+=($(echo "$line" | sed -E 's/([0-9]+)/0\1/g' | sed 's/\./\-/g'));

    N=$(expr $N + 1)
done < "$target_file"

printf "\nNow looping through the array ----\n"

H=1
for i in $(seq 0 `expr ${#target_file_array[@]} - 1`)
do
  index_i=$(printf "%04d" "$i")
  index_H=$(printf "%04d" "$H")
  printf " i ------>: $index_i ------>: H ------>: $index_H ------>: ${target_file_array[i]}\n"

  H=$(expr $H + 1)
done

