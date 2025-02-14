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
echo "!     [usage]: launcher_bench_BKeeper.sh   {Input list}                 !"
echo "!     [example]: launcher_bench_BKeeper.sh /data/local                  !"
echo "!                                                                       !"
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
__batch_action=$2
# Overall config file
source ./common_main.sh "$__external_lib_dir";
# The Batch content creators methods
source ./Scripts/Batch_Scripts/Batch_util_methods.sh;
#-------------------------------------------------------------------------------
# Now compiling Sombrero
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
cd ${LatticeRuns_dir}
ls -al

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Launching BKeeper benchmark dir:\n"; $white; $reset_colors;

case "$__batch_action" in
  *"BKeeper_compile"*)
      sbatch $batch_Scripts_dir/Run_BKeeper_compile.sh \
              > $LatticeRuns_dir/out_launcher_run_BKeeper_compile.log &
      ;;
  *"BKeeper_run_cpu"*)
      ;;
  *"BKeeper_run_gpu"*)
      #sbatch $batch_Scripts_dir/Run_BKeeper_run_gpu.sh \
      #        > $LatticeRuns_dir/out_launcher_run_BKeeper_run_gpu.log &
      target_file="${LatticeRuns_dir}"/"${target_BKeeper_run_gpu_batch_files}"
      find "${LatticeRuns_dir}/" -type f -name "*Run_BKeeper_run_gpu*node*small.sh" \
              > "$target_file"
      ;;
esac
#-------------------------------------------------------------------------------
# Check if target file exists first
#-------------------------------------------------------------------------------
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Check if target file exists first:\n"; $white; $reset_colors;
file_exists "${target_file}"
#-------------------------------------------------------------------------------
# Launching batch scripts from the Screening directory
#-------------------------------------------------------------------------------
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Launching batch scripts from the Screening directory:\n";
$white; $reset_colors;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; printf "Maximum number of submitted batch scripts: "; $bold;
$magenta; printf "${max_number_submitted_batch_scripts}\n"; $white; $reset_colors;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; printf "Reading in target file: "; $bold;
$yellow; printf "${target_file}\n";  $white; $reset_colors;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo ""

# TODO: create loop here for the different cases.
# TODO: need to fix the file reading of the target_file
H=1
for i in $(seq 0 `expr ${max_number_submitted_batch_scripts} - 1`)
do

  # TODO: fix the logic here on the file screening and use method
  # TODO: file_exists "${__input_filename}"
  #

  echo " i ------>: $i ------> H ------>: $H"

  H=$(expr $H + 1)
done

# TODO: #find $targetdir_in$sptr$run_folder_in -maxdepth 1 -name "$all$stat_ext"  | xargs --replace=@ cat @
# TODO: the find function of the batch*.sh files into the target_runs.txt file
# TODO: find "$PWD" -name "*.sh" > target_runs.txt
# TODO: ls -R1 "$PWD" |grep ".sh"|tr ":" "\n"

#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  launcher_bench_BKeeper.sh Done.                      -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#exit
#-------------------------------------------------------------------------------
