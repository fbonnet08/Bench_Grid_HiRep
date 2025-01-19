#!/usr/bin/bash
ARGV=`basename -a $1`
set -eu
scrfipt_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!     Code to load modules and prepare the base dependencies for grid   !"
echo "!     $scrfipt_file_name                                                    !"
echo "!     [Author]: Frederic Bonnet October 2024                            !"
echo "!     [usage]: sh common_main.sh   {Input list}                         !"
echo "!     [example]: sh common_main.sh /data/local                          !"
echo "!                                                                       !"
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
tput sgr0;
#colors
red="tput setaf 1"  ;green="tput setaf 2"  ;yellow="tput setaf 3"
blue="tput setaf 4" ;magenta="tput setaf 5";cyan="tput setaf 6"
white="tput setaf 7";bold=""               ;reset_colors="tput sgr0"
# Global variables and fixed Unix operators
sleep_time=2
sptr="/";
all="*";
dot=".";
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
# The Batch content creators methods
source ./Scripts/Batch_Scripts/Batch_util_methods.sh;
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
# Checking the argument list
if [ $# -ne 1 ]; then
  $white; printf "No directory specified : "; $bold;
  $red;printf " we will use the home directory ---> \n"; $green;printf "${HOME}"; $white; $reset_colors;
  local_dir=${HOME}
else
  $white; printf "Directory specified    : "; $bold;
  $blue; printf '%s'"${1}"; $red;printf " will be the working target dir ...\n"; $white; $reset_colors;
  local_dir=${HOME}/$1
fi

# first get the hostnames and deduce the machine_name from it.
hostname=$(echo ${HOSTNAME});
$white; printf "Hostname               : "; $bold;
$blue; printf "$hostname\n"; $white; $reset_colors;
#TODO: add other machines here or in common block code: LUMI and Leonardo module load combination and environment
if [[ $hostname =~ "tursa" ]]; then
  machine_name="tursa"
  # Clearing the modules already loaded and starting fresh
  #source /mnt/lustre/tursafs1/home/y07/shared/tursa-modules/setup-env
  # TODO: may be ok to move this to the common block code
  source /etc/profile.d/modules.sh ;
  module load /mnt/lustre/tursafs1/home/y07/shared/tursa-modules/setup-env ;
  module list ;

  $white; printf "Purging the modules    : "; $bold;
  module purge
  module list

  $green; printf "done.\n"; $reset_colors;
elif [[ $hostname =~ "Precision-3571" ]]; then
  machine_name="Precision-3571"
elif [[ $hostname =~ "vega" ]]; then
  machine_name="vega"

  # Clearing the modules already loaded and starting fresh
  $white; printf "Purging the modules    : "; $bold;
  __Init_Default_Modules=${__Init_Default_Modules:-}
  $green; printf "done.\n"; $reset_colors;

  source /etc/profile.d/modules.sh;
  source /ceph/hpc/software/cvmfs_env.sh;
  module list

elif [[ $hostname =~ "sunbird" ]]; then
  machine_name="sunbird"
  # Clearing the modules already loaded and starting fresh
  $white; printf "Purging the modules    : "; $bold;
  #module purge
  $green; printf "done.\n"; $reset_colors;

elif [[ $hostname =~ "DESKTOP-GPI5ERK" ]]; then
  machine_name="DESKTOP-GPI5ERK"

elif [[ $hostname =~ "desktop-dpr4gpr" ]]; then
  machine_name="desktop-dpr4gpr"

else
  #TODO: need to fix propagation machine_name when system is not defined
  machine_name="Other-Linux-Distribution"
fi

# Setting up the directory structure for the download
build_dir=build

sourcecode_dir=${HOME}/SwanSea/SourceCodes
Batch_util_create_path "${sourcecode_dir}"
sombrero_dir=${sourcecode_dir}/Sombrero/SOMBRERO
bkeeper_dir=${sourcecode_dir}/BKeeper
Bench_Grid_HiRep_dir=${sourcecode_dir}/Bench_Grid_HiRep
benchmark_input_dir=${Bench_Grid_HiRep_dir}/benchmarks
batch_Scripts_dir=${Bench_Grid_HiRep_dir}/Scripts/Batch_Scripts
LatticeRuns_dir=${sourcecode_dir}/LatticeRuns

Hirep_LLR_SP_dir=${sourcecode_dir}/Hirep_LLR_SP/Hirep_LLR_SP/
Hirep_LLR_SP_HMC_dir=${Hirep_LLR_SP_dir}/HMC

HiRep_LLR_master_dir=${sourcecode_dir}/HiRep-LLR-master/HiRep
HiRep_LLR_master_HMC_dir=${HiRep_LLR_master_dir}/LLR_HMC

HiRep_Cuda_dir=${sourcecode_dir}/HiRep-Cuda/HiRep

grid_dir=${sourcecode_dir}/Grid-Main/Grid

basedir=${local_dir}/grid_bench_202410
prefix=${local_dir}/prefix_grid_202410
#-------------------------------------------------------------------------------
#[Directory-Check] check if dir exists if not create it.
if [ -d ${basedir} ] && [ ! -L ${prefix} ]
then
  $white; printf "Directory              : "; $bold;
  $blue; printf '%s'"${basedir}"; $green; printf " exist, nothing to do.\n"; $white; $reset_colors;
else
  $white; printf "Directory              : "; $bold;
  $blue; printf '%s'"${basedir}"; $red;printf " does not exist, We will create it ...\n"; $white; $reset_colors;
  mkdir -p ${basedir}
  printf "                       : "; $bold;
  $green; printf "done.\n"; $reset_colors;
fi
if [ -d ${prefix} ]
then
  $white; printf "Directory              : "; $bold;
  $blue; printf '%s'"${prefix}"; $green; printf " exist, nothing to do.\n"; $white; $reset_colors;
else
  $white; printf "Directory              : "; $bold;
  $blue; printf '%s'"${prefix}"; $red;printf " does not exist, We will create it ...\n"; $white; $reset_colors;
  mkdir -p ${prefix}
  printf "                       : "; $bold;
  $green; printf "done.\n"; $reset_colors;
fi

# loading the modules for compilation (only valid during the life of this script)
# TODO: may be moved the dispatcher but remains machine dependent now, later.
$white; printf "Module load (script)   : "; $bold;
module_list="#no modules on UNKNOWN machine maybe Saturn!; module list;"
case $machine_name in
  *"Precision-3571"*)
    $white; printf "Laptop no module load  : no module load"; $bold
    # grid_dir is already set above but setting to new value here for laptop
    grid_dir=${sourcecode_dir}/JetBrainGateway/Grid-Main/Grid;
    module_list="#---> no modules on Precision-3571;module list;"
    ;;
  *"tursa"*)
    source /etc/profile.d/modules.sh ;
    module load /mnt/lustre/tursafs1/home/y07/shared/tursa-modules/setup-env ;
    module load cuda/12.3 openmpi/4.1.5-cuda12.3 ucx/1.15.0-cuda12.3 gcc/9.3.0; module list;
    module_list="module load cuda/12.3 openmpi/4.1.5-cuda12.3 ucx/1.15.0-cuda12.3 gcc/9.3.0; module list;"
    ;;
  *"sunbird"*)
   #module load CUDA/11.7 compiler/gnu/11/3.0 mpi/openmpi/1.10.6; module list;
   module_list="module load CUDA/11.7 compiler/gnu/11/3.0 mpi/openmpi/1.10.6; module list;"
    ;;
  *"vega"*)
    #source /etc/profile.d/modules.sh;
    #source /ceph/hpc/software/cvmfs_env.sh ;
    #module list;
    #module load CUDA/12.3.0 OpenMPI/4.1.5-GCC-12.3.0 UCX/1.15.0-GCCcore-12.3.0 GCC/12.3.0; module list
    module_list="module load CUDA/12.3.0 OpenMPI/4.1.5-GCC-12.3.0 UCX/1.15.0-GCCcore-12.3.0 GCC/12.3.0; module list;"
    ;;
  *"lumi-c"*);;
  *"lumi-g"*);;
  *"leonardo-booster"*);;
  *"leonardo-dcgp"*);;
  *"DESKTOP-GPI5ERK"*)
    module_list="#---> no modules on ${machine_name}; module list;"
    ;;
  *"desktop-dpr4gpr"*)
    module_list="#---> no modules on ${machine_name}; module list;"
    ;;
esac
$green; printf "done.\n"; $reset_colors;
grid_build_dir=$grid_dir$sptr$build_dir
#-------------------------------------------------------------------------------
$green; $bold;
echo "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
$red  ; printf "Directory structure    : ";
$cyan ; printf "$(basename \"$0\")\n"; $green;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$reset_colors;
$white; printf "hostname               : ";$red;      printf "$hostname\n";             $reset_colors;
$white; printf "machine_name           : ";$red;      printf "$machine_name\n";         $reset_colors;
$white; printf "build_dir              : ";$blue;     printf "$build_dir\n";            $reset_colors;
$white; printf "sourcecode_dir         : ";$green;    printf "$sourcecode_dir\n";       $reset_colors;
$white; printf "prefix Directory       : ";$yellow;   printf "$prefix\n";               $reset_colors;
$white; printf "base Directory         : ";$blue;     printf "$basedir\n";              $reset_colors;
$white; printf "grid directory         : ";$magenta;  printf "$grid_dir\n";             $reset_colors;
$white; printf "grid build directory   : ";$magenta;  printf "$grid_build_dir\n";       $reset_colors;
$white; printf "Hirep_LLR_SP directory : ";$yellow;   printf "$Hirep_LLR_SP_dir\n";     $reset_colors;
$white; printf "Hirep_LLR_SP_HMC dir   : ";$green;    printf "$Hirep_LLR_SP_HMC_dir\n"; $reset_colors;
$white; printf "HiRep_Cuda directory   : ";$green;    printf "$HiRep_Cuda_dir\n";       $reset_colors;
$white; printf "Sombrero directory     : ";$magenta;  printf "$sombrero_dir\n";         $reset_colors;
$white; printf "BKeeper directory      : ";$cyan;     printf "$bkeeper_dir\n";         $reset_colors;
$white; printf "Lattice runs directory : ";$magenta;  printf "$LatticeRuns_dir\n";      $reset_colors;
$cyan;  printf "<-- extrn_lib Fldr --->: ";$cyan;     printf "$0\n";                    $reset_colors;
# ##############################################################################
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Other template examples based on strings
#-------------------------------------------------------------------------------
declare -a path_to_data_dir=(
              "$sourcecode_dir"
              "$sombrero_dir"
              "$bkeeper_dir"
              "$Bench_Grid_HiRep_dir"
              "$benchmark_input_dir"
              "$batch_Scripts_dir"
              "$LatticeRuns_dir"
              "$Hirep_LLR_SP_dir"
              "$Hirep_LLR_SP_HMC_dir"
              "$HiRep_LLR_master_dir"
              "$HiRep_LLR_master_HMC_dir"
              "$HiRep_Cuda_dir"
              "$grid_dir"
              "$basedir"
              "$prefix"
              )
# getting the length of the strings
max_string_array=()
for i in $(seq 0 `expr ${#path_to_data_dir[@]} - 1`)
do max_string_array=(${max_string_array[@]} ${#path_to_data_dir[$i]}); done
#Initialising the max length to a either first entry of array or 80 characters
if   [ ${#path_to_data_dir[@]} -ne 0 ]; then max_string_length=${max_string_array[0]}
elif [ ${#path_to_data_dir[@]} -eq 0 ]; then max_string_length=80; fi
#getting the maximum length method #1
for n_nodes in "${max_string_array[@]}"
do ((n_nodes > max_string_length)) && max_string_length=$n_nodes; done
$cyan;printf "<-- Array length   --->: ";$green;printf "%i\n" ${#path_to_data_dir[@]};$white
$cyan;printf "<-- Max length dir --->: ";$yellow;printf "%i\n" ${max_string_length};$white
#launching the metadata extractor and plotters
G=1
for i in $(seq 0 `expr ${#path_to_data_dir[@]} - 1`)
do
    logfile=$(printf "out_launch_Bench_Grid_HiRep_path_%03d.log" $i)
    sourcedir_in=${path_to_data_dir[$i]}
    index=$($green;printf "%03d" $G;$cyan)
    $cyan; printf "<-- Source dir     --->: [$index] --->: ";
    $yellow;printf "%-${max_string_length}s" $sourcedir_in;
    $green; printf " ---> ";$cyan;printf "$logfile\n"; $white;
    #sh TotalDoseAnalyser.sh $sourcedir_in $targetdir_in $dateSpan_in > $logfile &
    if [ $G -eq ${#path_to_data_dir[@]} ];then G=0; $red;printf "Waiting for procs ...\n";$white;wait;fi
    G=$(expr $G + 1)
done
$cyan;printf "<-- Process done   --->: ";$green;printf "%s\n" "Continuing...";$white
#-------------------------------------------------------------------------------
# ##############################################################################
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  common_main.sh Done.                                 -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$reset_colors
#exit
#-------------------------------------------------------------------------------


