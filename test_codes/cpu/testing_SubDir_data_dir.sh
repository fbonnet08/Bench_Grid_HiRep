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

  #echo "echo --->: $parent_dir"
  #echo "echo --->: $substring"
  $yellow; printf "                       ------------------------------------------\n"; $white; $reset_colors;
  $white; printf "Parent directory       : "; $bold; $yellow; printf '%s'"${parent_dir}"; printf "\n"; $white; $reset_colors;
  $white; printf "Substring              : "; $bold; $cyan; printf '%s'"${substring}";  printf "\n"; $white; $reset_colors;

  found=0
  for dir in "$parent_dir"/*/; do
    if [[ -d "$dir" && "$dir" == *"$substring"* ]]; then
      $white; printf "Found matching dir     : "; $bold; $yellow; printf '%s'"${dir}"; printf "\n"; $white; $reset_colors;
      found=1
      break
    fi
  done

  if [ "$found" -eq 1 ]; then
    #---------------------------------------------------------------------------
    # Extracting the parameters from the configuration files
    #---------------------------------------------------------------------------
    $white; printf "Directory substring    : "; $bold;
    $cyan; printf '%s'"${substring}"; $green; printf " exist.\n";
    $white; $reset_colors;
    $yellow; printf "                       ------------------------------------------\n"; $white; $reset_colors;
    #---------------------------------------------------------------------------
    # Extract and convert 6p9 to 6.9
    beta_telos_segment=$(echo "$substring" | grep -oP 'b\K\d+p\d+' | sed 's/p/./')
    # Extract and convert LNt32L24 to 24.24.24.32
    lattice_segment=$(echo "$substring" | grep -oP 'LNt\d+L\d+' | sed -E 's/LNt([0-9]+)L([0-9]+)/\2.\2.\2.\1/')
    # Extract and convert m0p08 to 0.08
    mass_segment=$(echo "$substring" | grep -oP 'm\K\d+p\d+' | sed 's/p/./')
    # Extract and convert Ls8 to Ls=8
    Ls_segment=$(echo "$substring" | grep -oP 'Ls\d+' | sed 's/Ls//')
    #---------------------------------------------------------------------------
    # Output results
    $white; printf "6p9                    : "; $bold; $yellow; printf '%s'"${beta_telos_segment}"; printf "\n"; $white; $reset_colors;
    $white; printf "m0p08                  : "; $bold; $yellow; printf '%s'"${mass_segment}"; printf "\n"; $white; $reset_colors;
    $white; printf "LNt32L24               : "; $bold; $yellow; printf '%s'"${lattice_segment}"; printf "\n"; $white; $reset_colors;
    $white; printf "Ls8                    : "; $bold; $yellow; printf '%s'"${Ls_segment}"; printf "\n"; $white; $reset_colors;
    $yellow; printf "                       ------------------------------------------\n"; $white; $reset_colors;
    #---------------------------------------------------------------------------
  else
    $white; printf "Directory substring    : "; $bold;
    $magenta; printf '%s'"${substring}"; $red; printf " does not exist.\n";
    $white; $reset_colors;
    $yellow; printf "                       ------------------------------------------\n"; $white; $reset_colors;
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

