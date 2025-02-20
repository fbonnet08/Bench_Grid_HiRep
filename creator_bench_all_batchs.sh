#!/usr/bin/bash
ARGV=`basename -a $1 $2`
set -eu
script_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!     Code to create the batch script                                   !"
echo "!     $script_file_name                                                 !"
echo "!     [Author]: Frederic Bonnet November 2024                           !"
echo "!     [usage]: creator_bench_all_batchs.sh   {Input list}               !"
echo "!     [ex]: creator_bench_all_batchs.sh SwanSea/SourceCodes/external_lib!"
echo "!                                                                       !"
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
tput sgr0;
#colors
red="tput setaf 1"  ;green="tput setaf 2"  ;yellow="tput setaf 3"
blue="tput setaf 4" ;magenta="tput setaf 5";cyan="tput setaf 6"
white="tput setaf 7";bold=""               ;reset_colors="tput sgr0"
#-------------------------------------------------------------------------------
# Creating the case batch file
#-------------------------------------------------------------------------------
__project_account=$1   #SwanSea/SourceCodes/external_lib
__external_lib_dir=$2   #SwanSea/SourceCodes/external_lib
bash -s < ./creator_bench_controller_batch.sh  "$__project_account" "$__external_lib_dir" Sombrero_weak
bash -s < ./creator_bench_controller_batch.sh  "$__project_account" "$__external_lib_dir" Sombrero_strong
#bash -s < ./creator_bench_controller_batch.sh  "$__external_lib_dir" BKeeper_run_cpu;

#bash -s < ./creator_bench_controller_batch.sh "$__project_account" "$__external_lib_dir" BKeeper_run_gpu;

#bash -s < ./creator_bench_controller_batch.sh  "$__external_lib_dir" HiRep-LLR-master-cpu
#bash -s < ./creator_bench_controller_batch.sh  "$__external_lib_dir" BKeeper_compile;
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  creator_bench_all_batchs.sh Done.                    -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$reset_colors
#exit
#-------------------------------------------------------------------------------
