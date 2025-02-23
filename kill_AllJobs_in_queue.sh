#!/usr/bin/bash
set -eu
script_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!     Code to kill batch submitted slurm jobs                           !"
echo "!     $script_file_name                                          !"
echo "!     [Author]: Frederic Bonnet Febrary 2025                            !"
echo "!     [usage]: kill_AllJobs_in_queue.sh                                 !"
echo "!     [example]: kill_AllJobs_in_queue.sh                               !"
echo "!                                                                       !"
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
tput sgr0;
#colors
red="tput setaf 1"  ;green="tput setaf 2"  ;yellow="tput setaf 3"
blue="tput setaf 4" ;magenta="tput setaf 5";cyan="tput setaf 6"
white="tput setaf 7";bold=""               ;reset_colors="tput sgr0"
# Global variables
sleep_time=2
#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------
ProgressBar (){
    _percent=$(awk -vp=$1 -vq=$2 'BEGIN{printf "%0.2f", p*100/q*100/100}')
    _progress=$(awk -vp=$_percent 'BEGIN{printf "%i", p*4/10}')
    _remainder=$(awk -vp=$_progress 'BEGIN{printf "%i", 40-p}')
    _completed=$(printf "%${_progress}s" )
    _left=$(printf "%${_remainder}s"  )
    printf "\rProgress : [-$_completed#$_left-] ";tput setaf 4; tput bold; printf "[= ";
    tput sgr0; tput setaf 6; printf "$1";
    tput sgr0; tput setaf 4; tput bold;printf " <---> ";
    tput sgr0; tput setaf 6; tput bold;printf "(secs)";
    tput sgr0; tput setaf 2; tput bold; printf " ${_percent}%%"
    tput setaf 4; tput bold; printf " =]"
    tput sgr0
}
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
__sourcecode_dir=${HOME}/SwanSea/SourceCodes
__Bench_Grid_HiRep_dir=${__sourcecode_dir}/Bench_Grid_HiRep
__LatticeRuns_dir=${__sourcecode_dir}/LatticeRuns/Clusters/Lumi/LatticeRuns
__Batch_submission_log="Batch_submission.log"
# Target Batch_submission.log
__target_file="${__LatticeRuns_dir}/${__Batch_submission_log}"
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
$magenta; printf "${__LatticeRuns_dir}\n"; $white; $reset_colors;
cd "${__LatticeRuns_dir}"
ls -al

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Killing all jobs in the queue  :\n"; $white; $reset_colors;
#-------------------------------------------------------------------------------
# Check if the Batch_submission.log exists
#-------------------------------------------------------------------------------
file_exists="no"
if [ -f "${__target_file}" ]
  then
    $white; printf "File                   : "; $bold;
    $yellow; printf '%s'"${__target_file}"; $green; printf " --->: exist.\n";
    $white; $reset_colors;
    file_exists="yes"
    printf "      file_exists ---->: "; $bold;
    $green; printf "$file_exists.\n"; $reset_colors;
  else
    $white; printf "File                   : "; $bold;
    $yellow; printf '%s'"${__target_file}"; $red;printf " --->: does not exist.\n";
    $white; $reset_colors;
    file_exists="no"
    printf "      file_exists ---->: "; $bold;
    $red; printf "$file_exists.\n"; $reset_colors;
fi
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Reading from the Batch_submission.log file
#-------------------------------------------------------------------------------
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Killing all jobs in the queue  :\n"; $white; $reset_colors;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Reading -> Batch_submission.log: "; $bold;
$magenta; printf "${__target_file}\n"; $white; $reset_colors;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#-------------------------------------------------------------------------------
declare -a target_batch_jobid_array=()
N=0
if [ "$file_exists" = 'yes' ]
then
  printf "                       : "; $bold;
  $white; printf "YES ---> Batch_submission.log submitted to the queue....\n"; $reset_colors;
  while read line
  do
    batch_jobid=$(echo "$line"|sed 's/Submitted batch job //')
    target_batch_jobid_array+=("$(echo "$batch_jobid")");
    N=$(expr $N + 1)
  done < "$__target_file"

  $cyan; printf "Read in from Batch_submission_log   : "; $bold;
  $yellow; printf "${N}"; $cyan; printf " batch scripts to be submitted.\n"; $white; $reset_colors;

  echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  $green; printf "Now looping through the target batch file array:\n";
  $white; $reset_colors;
  #-----------------------------------------------------------------------------
  H=1
  for i in $(seq 0 `expr ${#target_batch_jobid_array[@]} - 1`)
  do
    index_i=$(printf "%04d" "$i")
    index_H=$(printf "%04d" "$H")
    $cyan; printf "#------>: i #------>: "; $green;      printf "${index_i} ";
    $cyan; printf "#------>: H #------>: "; $magenta;    printf "${index_H} ";
    $cyan; printf "#------>: Bath job id #--->: "; $red; printf "${target_batch_jobid_array[i]} ";
    $yellow; printf "#------>: Cancelling job #--->: "; $red; printf "${target_batch_jobid_array[i]}";
    $cyan; printf "\n"; $white; $reset_colors;

    #scancel "${target_batch_jobid_array[i]}"

    H=$(expr $H + 1)
  done
  # [end of for-loop]
  #-----------------------------------------------------------------------------
elif [ "$file_exists" = 'no' ]
then
  printf "                       : "; $bold;
  $white; printf "NO  ---> Batch_submission.log NO GO.\n"; $reset_colors;
fi
# [end-if file_exists]
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  kill_AllJobs_in_queue.sh Done.                       -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#exit
#-------------------------------------------------------------------------------
