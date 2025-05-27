#!/usr/bin/bash
ARGV=`basename -a $1`
set -eu
script_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!     Code to launch BKeeper benchmarker                                !"
echo "!     $script_file_name                                            !"
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
__external_lib_dir=$1
# Overall config file
source ./common_main.sh "$__external_lib_dir";
# The Batch content creators methods
source ./Scripts/Batch_Scripts/Batch_util_methods.sh;
#-------------------------------------------------------------------------------
# The codes to be compressed
#-------------------------------------------------------------------------------
# les codes
#llr_codes="${sourcecode_dir}/Hirep_LLR_SP"
llr_codes="${Hirep_LLR_SP_dir}"
llr_input="${LLR_HiRep_heatbath_input_dir}"
llr_LatticeRuns="${LatticeRuns_Hirep_LLR_SP_dir}"
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
$green; printf "Screening the directory and moving to it: "; $bold;
$magenta; printf "${LatticeRuns_dir}\n"; $white; $reset_colors;
cd "${LatticeRuns_dir}"
ls -al

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Launching tar ball creator      :\n"; $white; $reset_colors;

directory_exists "${llr_codes}"; dir_Hirep_LLR_SP_exists="$directory_exists";
directory_exists "${llr_input}"; dir_LLR_HiRep_heatbath_input_dir="$directory_exists";
directory_exists "${llr_LatticeRuns}"; dir_llr_LatticeRuns_dir=$directory_exists;

$cyan; printf "Directory content      : "; $yellow; printf "%s\n" "${llr_codes}";$white; $reset_colors;
ls "$llr_codes"
$cyan; printf "Directory content      : "; $yellow; printf "%s\n" "${llr_input}";$white; $reset_colors;
ls "$llr_input"
$cyan; printf "Directory content      : "; $yellow; printf "%s\n" "${llr_LatticeRuns}/LLR_HB";$white; $reset_colors;
ls "${llr_LatticeRuns}/LLR_HB"

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; printf "Creating tar ball      : "; $red; printf "%s\n" "${ball_llr_codes}";$white; $reset_colors;
if [ "$dir_Hirep_LLR_SP_exists" == "yes" ];
then
  tar cf "$ball_llr_codes" -C "${sourcecode_dir}" ./${Hirep_LLR_SP};
  pigz --force "$ball_llr_codes";
fi
$cyan; printf "Creating tar ball      : "; $red; printf "%s\n" "${ball_llr_input}";$white; $reset_colors;
if [ "$dir_LLR_HiRep_heatbath_input_dir" == "yes" ];
then
  tar cf "$ball_llr_input" -C "${sourcecode_dir}" ./${LLR_HiRep_heatbath_input};
  pigz --force "$ball_llr_input";
fi
$cyan; printf "Creating tar ball      : "; $red; printf "%s\n" "${ball_llr_LatticeRuns}";$white; $reset_colors;
if [ "$dir_llr_LatticeRuns_dir" == "yes" ];
then
  tar cf "$ball_llr_LatticeRuns" -C "${LatticeRuns_dir}" ./${Hirep_LLR_SP};
  pigz --force "$ball_llr_LatticeRuns";
fi
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; printf "Created tar ball       : "; $yellow; printf "%s\n" "${ball_llr_codes}.gz";$white; $reset_colors;
file_exists "${ball_llr_codes}.gz"
$cyan; printf "Created tar ball       : "; $yellow; printf "%s\n" "${ball_llr_input}.gz";$white; $reset_colors;
file_exists "${ball_llr_input}.gz"
$cyan; printf "Created tar ball       : "; $yellow; printf "%s\n" "${ball_llr_LatticeRuns}.gz";$white; $reset_colors;
file_exists "${ball_llr_LatticeRuns}.gz"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  creator_tarball_HiRep-LLR-SP_Runs.sh Done.           -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$white; $reset_colors;
#exit
#-------------------------------------------------------------------------------
