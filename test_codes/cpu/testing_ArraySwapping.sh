#!/usr/bin/bash
#colors
red="tput setaf 1"  ;green="tput setaf 2"  ;yellow="tput setaf 3"
blue="tput setaf 4" ;magenta="tput setaf 5";cyan="tput setaf 6"
white="tput setaf 7";bold=""               ;reset_colors="tput sgr0"
#-------------------------------------------------------------------------------
# Testing code begins
#-------------------------------------------------------------------------------
machine_name="leonardo"

declare -a ntasks_per_node=(1 2 4 8 16 32 64 128 256)
declare -a ntasks_per_node_leonardo_special=(1 2 3 6 12 24 48 96)

for k in $(seq 0 `expr ${#ntasks_per_node[@]} - 1`)
do
  printf "ntasks_per_node[$k]} ----> ${ntasks_per_node[k]} ---->\n"
  #printf "${target_file_BKeeper_gpu_small} <--::--> ${target_file_BKeeper_gpu_large}\n"
done
echo ""
for k in $(seq 0 `expr ${#ntasks_per_node_leonardo_special[@]} - 1`)
do
  printf "ntasks_per_node_leonardo_special[$k]} ----> ${ntasks_per_node_leonardo_special[k]} ---->\n"
done

echo " Now swapping the arrays"

if [[ $machine_name = "leonardo" ]]
then
  echo " -----> Switching to the Leonardo configuration ---->:"
  ntasks_per_node=()
  for k in $(seq 0 `expr ${#ntasks_per_node_leonardo_special[@]} - 1`)
  do
    ntasks_per_node=(${ntasks_per_node[@]} ${ntasks_per_node_leonardo_special[$k]})
  done
fi

echo " Printing out the new array"

for k in $(seq 0 `expr ${#ntasks_per_node[@]} - 1`)
do
  _ntasks_per_socket=$((ntasks_per_node[k] / 2))
  if [[ $_ntasks_per_socket -eq 0 ]]; then _ntasks_per_socket=1; fi
  printf "ntasks_per_node[$k] ----> ${ntasks_per_node[k]}"
  printf " <--::--> #SBATCH --ntasks-per-socket=$_ntasks_per_socket\n"
done
printf "\n"
printf "Printing the array elements of ntasks_per_node ---> ${ntasks_per_node[*]}\n"
#'
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  deploy_to_clusters.sh Done.                          -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#exit
#-------------------------------------------------------------------------------
