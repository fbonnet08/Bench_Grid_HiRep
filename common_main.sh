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
# Global variables
sleep_time=2
sptr="/"
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
  module purge
  $green; printf "done.\n"; $reset_colors;
fi

# Setting up the directory structure for the download
build_dir=build
sourcecode_dir=${HOME}/SwanSea/SourceCodes
sombrero_dir=${sourcecode_dir}/Sombrero/SOMBRERO
bekeeper_dir=${sourcecode_dir}/BKeeper
LatticeRuns_dir=${sourcecode_dir}/LatticeRuns
Hirep_LLR_SP_dir=${sourcecode_dir}/Hirep_LLR_SP
Hirep_LLR_SP_HMC_dir=${sourcecode_dir}/Hirep_LLR_SP/HMC
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
case $machine_name in
  *"Precision-3571"*)
    $white; printf "Laptop no module load  : no module load"; $bold
    # grid_dir is already set above but setting to new value here for laptop
    grid_dir=${sourcecode_dir}/JetBrainGateway/Grid-Main/Grid;
    ;;
  *"tursa"*)
    source /etc/profile.d/modules.sh ;
    module load /mnt/lustre/tursafs1/home/y07/shared/tursa-modules/setup-env ;
    module load cuda/12.3 openmpi/4.1.5-cuda12.3 ucx/1.15.0-cuda12.3 gcc/9.3.0; module list;
    ;;
  *"sunbird"*) module load CUDA/11.7 compiler/gnu/11/3.0 mpi/openmpi/1.10.6; module list
    ;;
  *"vega"*)
    #source /etc/profile.d/modules.sh;
    #source /ceph/hpc/software/cvmfs_env.sh ;
    #module list;
    #module load CUDA/12.3.0 OpenMPI/4.1.5-GCC-12.3.0 UCX/1.15.0-GCCcore-12.3.0 GCC/12.3.0; module list
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
$white; printf "BKeeper directory      : ";$cyan;     printf "$bekeeper_dir\n";         $reset_colors;
$white; printf "Lattice runs directory : ";$magenta;  printf "$LatticeRuns_dir\n";      $reset_colors;
$cyan;  printf "<-- extrn_lib Fldr --->: ";$cyan;     printf "$0\n";                    $reset_colors;
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  common_main.sh Done.                                 -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#exit
#-------------------------------------------------------------------------------


