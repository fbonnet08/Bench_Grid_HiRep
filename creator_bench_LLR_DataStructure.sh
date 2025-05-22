#!/usr/bin/bash
ARGV=`basename -a $1 $2`
set -eu
scrfipt_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!     Code to launch BKeeper benchmarker                                !"
echo "!     $scrfipt_file_name                                            !"
echo "!     [Author]: Frederic Bonnet November 2024                           !"
echo "!     [usage]: creator_tarball_HiRep-LLR-SP_Runs.sh   {Input list}      !"
echo "!     [example]: creator_tarball_HiRep-LLR-SP_Runs.sh                   !"
echo "!                                      SwanSea/SourceCodes/external_lib !"
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
tput sgr0;
#colors
red="tput setaf 1"  ;green="tput setaf 2"  ;yellow="tput setaf 3"
blue="tput setaf 4" ;magenta="tput setaf 5";cyan="tput setaf 6"
white="tput setaf 7";bold=""               ;reset_colors="tput sgr0"
# Checking the argument list
if [ $# -ne 1 ]; then
  $white; printf "No directory specified : "; $bold;
  $red;printf " we will use the home directory ---> \n"; $green;printf "${HOME}";
  $white; $reset_colors;
  local_dir=${HOME}
else
  $white; printf "Directory specified    : "; $bold;
  $blue; printf '%s'"${1}"; $red;printf " will be the working target dir ...\n";
  $white; $reset_colors;
  local_dir=${HOME}/$1
fi
# Global variables
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
__project_account=$1
__external_lib_dir=$2
# Overall config file
source ./common_main.sh "$__external_lib_dir";
# System config file to get information from the node
source ./config_system.sh "$__project_account" "$machine_name";
# The Batch content creators methods
source ./Scripts/Batch_Scripts/Batch_util_methods.sh;
#-------------------------------------------------------------------------------
# The codes to be compressed
#-------------------------------------------------------------------------------
# les codes
#llr_codes="${sourcecode_dir}/Hirep_LLR_SP"
llr_codes="${Hirep_LLR_SP_dir}"
llr_input="${LLR_HiRep_heatbath_input_dir}"
_some_dir="${some_dir}"
#-------------------------------------------------------------------------------
# Now compressing the codes
#-------------------------------------------------------------------------------

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
for i in $(seq 0 $sleep_time)
do
  $green;ProgressBar "${i}" "${sleep_time}"; sleep 1;
done
printf "\n"

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Moving to LatticeRuns  : "; $bold;
$magenta; printf "${LatticeRuns_dir}\n"; $white; $reset_colors;
cd "${LatticeRuns_dir}"
ls -al

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Checking directories   :\n"; $white; $reset_colors;

directory_exists "${llr_codes}"; dir_Hirep_LLR_SP_exists="$directory_exists";
directory_exists "${llr_input}"; dir_LLR_HiRep_heatbath_input_dir="$directory_exists";
directory_exists "${_some_dir}"; dir_some_other_directory_dir=$directory_exists;

$cyan; printf "Directory content      : "; $yellow; printf "%s\n" "${llr_codes}";$white; $reset_colors;
ls "$llr_codes"
$cyan; printf "Directory content      : "; $yellow; printf "%s\n" "${llr_input}";$white; $reset_colors;
ls "$llr_input"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Checking input file    :\n"; $white; $reset_colors;
file_exists "${llr_input}/input/${machine_name}.csv"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Generating LLR-Rep     :\n"; $white; $reset_colors;

# TODO drive the code from here.
# TODO:
#  python3 main.py
#       --input_params_csv MareNostrum.csv
#       --machine MareNostrum
#       --partition gp
#       --account ehpc191
#       --modules "gcc/12.3.0 openmpi/4.1.5-gcc"
#       --run_index 1
#       --path_llr_exec "\${HOME}/SwanSea/SourceCodes/Hirep_LLR_SP/LLR_HB"
#       --output_run_dir "${HOME}/SwanSea/SourceCodes/Hirep_LLR_SP/LLR_HB"
# TODO: output/Run001_LLR_04x020_056
# TODO: bash -s < ./setup_llr_repeat.sh

python3 \
  "${llr_input}"/main.py \
  --input_params_csv "${llr_input}/input/${machine_name}.csv" \
  --machine "${machine_name}" \
  --partition gp \
  --account ehpc191 \
  --modules "${module_list}" \
  --run_index 1 \
  --path_llr_exec "\${HOME}/SwanSea/SourceCodes/Hirep_LLR_SP/LLR_HB" \
  --output_run_dir "${LatticeRuns_dir}/Hirep_LLR_SP/LLR_HB"

#  --output_run_dir "${HOME}/EuroHPC/MareNostrum/SwanSea/SourceCodes/LatticeRuns/Hirep_LLR_SP/LLR_HB"

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  creator_tarball_HiRep-LLR-SP_Runs.sh Done.           -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#exit
#-------------------------------------------------------------------------------
