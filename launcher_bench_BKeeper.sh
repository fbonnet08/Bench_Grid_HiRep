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
# Global variables
sleep_time=2
#Functions
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
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
__batch_action=$2
source ./common_main.sh $1;
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
$green; printf "Moving Scripts/Batch_Scripts dir and submitting job: "; $bold;
$magenta; printf "${batch_Scripts_dir}\n"; $white; $reset_colors;
cd ${batch_Scripts_dir}
ls -al

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Launching BKeeper benchmark dir: "; $bold;

# TODO: create loop here for the different cases.

case "$__batch_action" in
  *"BKeeper_compile"*)
      sbatch $batch_Scripts_dir/Run_BKeeper_compile.sh \
             > $LatticeRuns_dir/out_launcher_run_BKeeper_compile.log & ;;
  *"BKeeper_run_cpu"*)
      sbatch $batch_Scripts_dir/Run_BKeeper_run_cpu.sh \
             > $LatticeRuns_dir/out_launcher_run_BKeeper_run_cpu.log &;;
  *"BKeeper_run_gpu"*)
      sbatch $batch_Scripts_dir/Run_BKeeper_run_gpu.sh \
             > $LatticeRuns_dir/out_launcher_run_BKeeper_run_gpu.log &;;
esac

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
