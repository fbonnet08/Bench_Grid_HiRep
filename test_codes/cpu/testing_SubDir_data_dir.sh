#!/usr/bin/bash
set -eu
scrfipt_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!     Code to test subdir in a diretory                                 !"
echo "!     $scrfipt_file_name                                            !"
echo "!     [Author]: Frederic Bonnet May 2025                                !"
echo "!     [usage]: testing_SubDir_In_Dir.sh   {Input list}                  !"
echo "!     [example]: testing_SubDir_In_Dir.sh external_path                 !"
echo "!                                                                       !"
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
tput sgr0;
#colors
red="tput setaf 1"  ;green="tput setaf 2"  ;yellow="tput setaf 3"
blue="tput setaf 4" ;magenta="tput setaf 5";cyan="tput setaf 6"
white="tput setaf 7";bold=""               ;reset_colors="tput sgr0"
#-------------------------------------------------------------------------------
# Setting up the arrays for the benchmarks.
# Sombrero, BKeeper, grid and HiRep LLR-HMC CPU
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Getting the common code setup and variables,
#-------------------------------------------------------------------------------
source ../../Scripts/Batch_Scripts/Batch_util_methods.sh;
#-------------------------------------------------------------------------------
# data directory:
#-------------------------------------------------------------------------------
data_name="data"
data_dir="${HOME}/${data_name}"
DWF_ensembles_GRID_dir="${data_dir}/DWF_ensembles_GRID/nf2_fund_sp4"
#-------------------------------------------------------------------------------
# TestCode:
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# First fill in the DWF_ensembles_GRID_array
#-------------------------------------------------------------------------------
DWF_ensembles_GRID_array=()
for dir in "${DWF_ensembles_GRID_dir}"/*;
do
  DWF_ensembles_GRID_array+=("$(basename "$dir")")
done

# Looping over the array
for idir in $(seq 0 `expr ${#DWF_ensembles_GRID_array[@]} - 1`)
do

  parent_dir="${DWF_ensembles_GRID_dir}"
  substring="${DWF_ensembles_GRID_array[$idir]}"

  echo "echo --->: $parent_dir"
  echo "echo --->: $substring"

  found=0
  for dir in "$parent_dir"/*/; do
    if [[ -d "$dir" && "$dir" == *"$substring"* ]]; then
      echo "Found matching directory: $dir"
      found=1
      break
    fi
  done

  if [ "$found" -eq 1 ]; then
    echo "Directory with substring '$substring' exists."
  else
    echo "No matching directory found."
  fi

done

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

