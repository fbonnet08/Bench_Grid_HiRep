#!/usr/bin/bash
ARGV=`basename -a $1`
set -eu
script_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!     Code to load modules and prepare the base dependencies for grid   !"
echo "!     $script_file_name                                                    !"
echo "!     [Author]: Frederic Bonnet October 2024                            !"
echo "!     [usage]: sh common_main.sh   {external_lib_dir}                   !"
echo "!     [example]: sh common_main.sh SwanSea/SourceCodes/external_lib     !"
echo "!                                                                       !"
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
tput sgr0;
#colors
red="tput setaf 1"  ;green="tput setaf 2"  ;yellow="tput setaf 3"
blue="tput setaf 4" ;magenta="tput setaf 5";cyan="tput setaf 6"
white="tput setaf 7";bold=""               ;reset_colors="tput sgr0"
# Global variables and fixed Unix operators
sleep_time=2
max_number_submitted_batch_scripts=500
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
  $blue; printf '%s'"${1} ---> "; $red;printf " will be the working target dir ...\n"; $white; $reset_colors;
  local_dir=${HOME}/$1
fi

# first get the hostnames and deduce the machine_name from it.
hostname=$(echo ${HOSTNAME});
$white; printf "Hostname               : "; $bold;
$blue; printf "$hostname\n"; $white; $reset_colors;
#TODO: add other machines here or in common block code: LUMI and Leonardo module load combination and environment
if [[ $hostname =~ "tursa" ]];             then machine_name="tursa"

  # Clearing the modules already loaded and starting fresh
  source /etc/profile.d/modules.sh ;
  module load /mnt/lustre/tursafs1/home/y07/shared/tursa-modules/setup-env ;
  module list ;
  $white; printf "Purging the modules    : "; $bold;
  module purge
  $green; printf "done.\n"; $reset_colors;
  module list

elif [[ $hostname =~ "Precision-3571" ]];  then machine_name="Precision-3571"
elif [[ $hostname =~ "DESKTOP-GPI5ERK" ]]; then machine_name="DESKTOP-GPI5ERK"
elif [[ $hostname =~ "desktop-dpr4gpr" ]]; then machine_name="desktop-dpr4gpr"
elif [[ $hostname =~ "vega" ]];            then machine_name="vega"

  $white; printf "machine name           : "; $bold;
  $yellow; printf "${machine_name}\n"; $reset_colors;

  # Clearing the modules already loaded and starting fresh
  $white; printf "__Init_Default_Modules : "; $bold;
  __Init_Default_Modules=${__Init_Default_Modules:-}
  $green; printf "done. Next sourcing the profiles ...\n"; $reset_colors;

  #source /etc/profile.d/modules.sh;
  #source /ceph/hpc/software/cvmfs_env.sh;
  module list
  $white; printf "                       : "; $bold;
  $green; printf "done.\n"; $reset_colors;

elif [[ $hostname =~ "sunbird" ]];         then machine_name="sunbird"
elif [[ $hostname =~ "uan" ]];             then machine_name="lumi"
elif [[ $hostname =~ "leonardo" ]];        then machine_name="leonardo"
elif [[ $hostname =~ "a065014a" ]];        then machine_name="mi300"
elif [[ $hostname =~ "a89612a" ]];         then machine_name="mi300"
elif [[ $hostname =~ "c3729fc" ]];         then machine_name="mi210"
elif [[ $hostname =~ "glogin" ]];          then machine_name="MareNostrum"
elif [[ $hostname =~ "alogin" ]];          then machine_name="MareNostrum"
else
  #TODO: need to fix propagation machine_name when system is not defined
  machine_name="Other-Linux-Distribution"
fi
#-------------------------------------------------------------------------------
#[Path-structure] Project maintenance data structure
euroHPC_call="EHPC-BEN-2025B03-046"
previous_runs_dir="PreviousRuns"
logged_runs_dir=${HOME}/${euroHPC_call}/${previous_runs_dir}
#-------------------------------------------------------------------------------
#[Path-structure] Data paths
data_name="data"
data_dir="${HOME}/${data_name}"
DWF_ensembles_GRID_dir="${data_dir}/DWF_ensembles_GRID/nf2_fund_sp4"
#-------------------------------------------------------------------------------
#[Path-structure] Setting up the directory structure for the download
SwanSea_SourceCodes="SwanSea/SourceCodes"
sourcecode_dir=${HOME}/${SwanSea_SourceCodes}
Batch_util_create_path "${sourcecode_dir}"
sombrero_dir=${sourcecode_dir}/Sombrero/SOMBRERO
bkeeper_dir=${sourcecode_dir}/BKeeper
Bench_Grid_HiRep_dir=${sourcecode_dir}/Bench_Grid_HiRep
benchmark_input_dir=${Bench_Grid_HiRep_dir}/benchmarks
batch_Scripts_dir=${Bench_Grid_HiRep_dir}/Scripts/Batch_Scripts
LatticeRuns_dir=${sourcecode_dir}/LatticeRuns
LeonardoInstallerWarpX_dir="${batch_Scripts_dir}"/LeonardoInstallerWarpX

# Directory structures
Hirep_LLR_SP="Hirep_LLR_SP"
Hirep_LLR_SP_dir=${sourcecode_dir}/${Hirep_LLR_SP}
Hirep_LLR_SP_HB_dir=${Hirep_LLR_SP_dir}/LLR_HB
Hirep_LLR_SP_HMC_dir=${Hirep_LLR_SP_dir}/HMC
LatticeRuns_Hirep_LLR_SP_dir=${LatticeRuns_dir}/${Hirep_LLR_SP}

# LLR directory and github structure
LLR_HiRep_heatbath_input="LLR_HiRep_heatbath_input"
LLR_HiRep_heatbath_input_dir=${sourcecode_dir}/${LLR_HiRep_heatbath_input}

# The tar balls
ball_llr_codes="${sourcecode_dir}/ball_HiRep-LLR-SP.tar"
ball_llr_input="${sourcecode_dir}/ball_LLR_HiRep_heatbath_input.tar"
ball_llr_LatticeRuns_name="ball_LatticeRuns_Hirep_LLR_SP.tar"
ball_llr_LatticeRuns="${sourcecode_dir}/${ball_llr_LatticeRuns_name}"
# Some random directory in sourcecode_dir directory for sanity checks and test
some_dir=${sourcecode_dir}/some_other_directory

HiRep_LLR_master_dir=${sourcecode_dir}/HiRep-LLR-master/HiRep
HiRep_LLR_master_HMC_dir=${HiRep_LLR_master_dir}/LLR_HMC

HiRep_Cuda_dir=${sourcecode_dir}/HiRep-Cuda/HiRep

#grid_dir=${sourcecode_dir}/Grid-Main/Grid
build_dir="build"
# DWF grid supported
#grid_DWF_Telos="Grid-DWF-Telos"
grid_DWF_Telos="Grid-Telos"
grid_DWF_Telos_dir=${sourcecode_dir}/${grid_DWF_Telos}/"Grid"
# UCL optimized version
grid_UCL_ARC="Grid-UCL-ARC"
#
# GitHub and repos links for the codes
#
GitHub_Token_File="Personal_GitHub_Token.sh"
GitHub_Token_File_dir="/mnt/c/cygwin64/home/frede/GitHub"
grid_UCL_ARC_git_url="https://github.com/UCL-ARC/Grid.git"
grid_DWF_Telos_git_url="https://github.com/fbonnet08/Grid.git"
# Sombrero
sombrero_git_url="https://github.com/sa2c/SOMBRERO"
# BKeeper
bkeeper_git_url="https://github.com/RChrHill/BKeeper"
# Hirep_LLr_SP
Hirep_LLR_SP_git_url="github.com/fzierler/Hirep_LLR_SP.git"
# LLR directory and github structure
LLR_HiRep_heatbath_input_git_url="https://github.com/fzierler/LLR_HiRep_heatbath_input.git"
#-------------------------------------------------------------------------------
# The grid version that we are going to compile this time. May change this later
#-------------------------------------------------------------------------------
grid_version="${grid_UCL_ARC}"
grid_version_git_url="${grid_UCL_ARC_git_url}"

grid_dir=${sourcecode_dir}/${grid_version}/Grid
grid_build_dir=${grid_dir}${sptr}${build_dir}
#-------------------------------------------------------------------------------
# [Run-Structure] Setting up the target file name structure
#-------------------------------------------------------------------------------
# Sombrero[Weak-Strong]-[Small-Large]:
#-------------------------------------------------------------------------------
# [Small]
target_Sombrero_weak_cpu_small_batch_files="target_Sombrero_weak_cpu_small_batch_files.txt"
target_Sombrero_strg_cpu_small_batch_files="target_Sombrero_strg_cpu_small_batch_files.txt"
# [Large]
target_Sombrero_weak_cpu_large_batch_files="target_Sombrero_weak_cpu_large_batch_files.txt"
target_Sombrero_strg_cpu_large_batch_files="target_Sombrero_strg_cpu_large_batch_files.txt"
#-------------------------------------------------------------------------------
# BKeeper[small-large]-[cpu-gpu]:
#-------------------------------------------------------------------------------
# [Small]
target_BKeeper_run_cpu_small_batch_files="target_BKeeper_run_cpu_small_batch_files.txt"
target_BKeeper_run_gpu_small_batch_files="target_BKeeper_run_gpu_small_batch_files.txt"
# [Large]
target_BKeeper_run_cpu_large_batch_files="target_BKeeper_run_cpu_large_batch_files.txt"
target_BKeeper_run_gpu_large_batch_files="target_BKeeper_run_gpu_large_batch_files.txt"
#-------------------------------------------------------------------------------
# Grid_DWF[small-large]-[gpu]:
#-------------------------------------------------------------------------------
# [Small]
target_Grid_DWF_run_gpu_small_batch_files="target_Grid_DWF_run_gpu_small_batch_files.txt"
# [Large]
target_Grid_DWF_run_gpu_large_batch_files="target_Grid_DWF_run_gpu_large_batch_files.txt"
#-------------------------------------------------------------------------------
# Grid_DWF_telos[small-large]-[gpu]:
#-------------------------------------------------------------------------------
# [Small]
target_Grid_DWF_Telos_run_gpu_small_batch_files="target_Grid_DWF_Telos_run_gpu_small_batch_files.txt"
# [Large]
target_Grid_DWF_Telos_run_gpu_large_batch_files="target_Grid_DWF_Telos_run_gpu_large_batch_files.txt"
#-------------------------------------------------------------------------------
# LLR_HiRep_HB[cpu]:
#-------------------------------------------------------------------------------
target_LLR_HiRep_HB_run_cpu_directories="target_LLR_HiRep_HB_run_cpu_directories.txt"
target_LLR_HiRep_HB_run_cpu_batch_files="target_LLR_HiRep_HB_run_cpu_bash_files.txt"
#-------------------------------------------------------------------------------
$green; $bold;
echo "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
$red  ; printf "Target files names     : ";
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$reset_colors;
$white; printf "#----------------------- ";printf "\n"; $reset_colors;
$white; printf "Grid_DWF_run_gpu         ";printf "\n"; $reset_colors;
$white; printf "#----------------------- ";printf "\n"; $reset_colors;
$white; printf "Grid_DWF_run_gpu_small : ";$magenta; printf "%s\n" $target_Grid_DWF_run_gpu_small_batch_files; $reset_colors;
$white; printf "Grid_DWF_run_gpu_large : ";$cyan;    printf "%s\n" $target_Grid_DWF_run_gpu_large_batch_files; $reset_colors;
$white; printf "#----------------------- ";printf "\n"; $reset_colors;
$white; printf "Grid_DWF_Telos_run_gpu   ";printf "\n"; $reset_colors;
$white; printf "#----------------------- ";printf "\n"; $reset_colors;
$white; printf "Grid_DWF_Telos_g_small : ";$magenta; printf "%s\n" $target_Grid_DWF_Telos_run_gpu_small_batch_files; $reset_colors;
$white; printf "Grid_DWF_Telos_g_large : ";$cyan;    printf "%s\n" $target_Grid_DWF_Telos_run_gpu_large_batch_files; $reset_colors;
$white; printf "#----------------------- ";printf "\n"; $reset_colors;
$white; printf "BKeeper[cpu-gpu]         ";printf "\n"; $reset_colors;
$white; printf "#----------------------- ";printf "\n"; $reset_colors;
$white; printf "BKeeper_run_cpu_small  : ";$magenta; printf "%s\n" $target_BKeeper_run_cpu_small_batch_files; $reset_colors;
$white; printf "BKeeper_run_gpu_small  : ";$cyan;    printf "%s\n" $target_BKeeper_run_gpu_small_batch_files; $reset_colors;
$white; printf "BKeeper_run_cpu_large  : ";$yellow;  printf "%s\n" $target_BKeeper_run_cpu_large_batch_files; $reset_colors;
$white; printf "BKeeper_run_gpu_large  : ";$green;   printf "%s\n" $target_BKeeper_run_gpu_large_batch_files; $reset_colors;
$white; printf "#----------------------- ";printf "\n"; $reset_colors;
$white; printf "Sombrero[cpu]            ";printf "\n";$reset_colors;
$white; printf "#----------------------- ";printf "\n"; $reset_colors;
$white; printf "Sombrero_weak_cpu_small: ";$magenta; printf "%s\n" $target_Sombrero_weak_cpu_small_batch_files; $reset_colors;
$white; printf "Sombrero_strg_cpu_small: ";$cyan;    printf "%s\n" $target_Sombrero_strg_cpu_small_batch_files; $reset_colors;
$white; printf "Sombrero_weak_cpu_large: ";$yellow;  printf "%s\n" $target_Sombrero_weak_cpu_large_batch_files; $reset_colors;
$white; printf "Sombrero_strg_gpu_large: ";$green;   printf "%s\n" $target_Sombrero_strg_cpu_large_batch_files; $reset_colors;
$white; printf "#----------------------- ";printf "\n"; $reset_colors;
$white; printf "LLR-HiRep-SP/LLR_HB[cpu] ";printf "\n";$reset_colors;
$white; printf "#----------------------- ";printf "\n"; $reset_colors;
$white; printf "LLR_HiRep_HB_run_cpu   : ";$magenta; printf "%s\n" $target_LLR_HiRep_HB_run_cpu_batch_files; $reset_colors;
$white; printf "#----------------------- ";printf "\n"; $reset_colors;
$cyan;  printf "<-- Shell          --->: ";$cyan;    printf "%s\n" "$0";                    $reset_colors;
$white; printf "#----------------------- ";printf "\n"; $reset_colors;
#-------------------------------------------------------------------------------
#[Build-Structure] Setting up the directory structure for the download
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
    #grid_dir=${sourcecode_dir}/JetBrainGateway/Grid-Main/Grid;
    module_list="#---> no modules on Precision-3571;module list;"
    ;;
  *"DESKTOP-GPI5ERK"*)
    module_list="#---> no modules on ${machine_name}; module list;"
    ;;
  *"desktop-dpr4gpr"*)
    module_list="#---> no modules on ${machine_name}; module list;"
    ;;
  *"tursa"*)
    source /etc/profile.d/modules.sh ;
    module load /mnt/lustre/tursafs1/home/y07/shared/tursa-modules/setup-env ;
    module load cuda/12.3 openmpi/4.1.5-cuda12.3 ucx/1.15.0-cuda12.3 gcc/9.3.0;
    module list;
    module_list="module load cuda/12.3 openmpi/4.1.5-cuda12.3 ucx/1.15.0-cuda12.3 gcc/9.3.0; module list;"
    ;;
  *"sunbird"*)
   module_list="module load CUDA/11.7 compiler/gnu/11/3.0 mpi/openmpi/1.10.6; module list;"
    ;;
  *"vega"*)
    #module_list="module load NVHPC/24.1-CUDA-12.3.0 FFTW HDF5; module list;"
    #module_list="module load CUDA/12.3.0 OpenMPI/4.1.5-GCC-12.3.0 UCX/1.15.0-GCCcore-12.3.0 GCC/12.3.0 FFTW/3.3.10-GCC-12.3.0 Python; module list;"
    module_list="module load CUDA/12.1.1 GCC/11.3.0 UCX/1.12.1-GCCcore-11.3.0 OpenMPI/4.1.4-GCC-11.3.0 Python/3.10.4-GCCcore-11.3.0 FFTW/3.3.10-GCC-11.3.0 OpenSSL/3; module list;"
    ;;
  *"lumi"*)
    module_list="module load cray-mpich cray-fftw cray-hdf5-parallel cray-python; module list;"
    ;;
  *"leonardo"*)
    module_list="module load cuda/12.2 nvhpc/23.11 fftw/3.3.10--openmpi--4.1.6--gcc--12.2.0 hdf5; module list;"
    ;;
  *"mi300"*)
    module_list="module load rocm amdclang hdf5 fftw openmpi; module list;"
    ;;
  *"mi210"*)
    module_list="module load rocm amdclang hdf5 fftw openmpi; module list;"
    ;;
  *"MareNostrum"*)
    module_list="module load cuda/12.1 gcc/11.4.0 ucx/1.16.0 openmpi/4.1.5-ucx1.16-gcc mkl/2021.4.0 hdf5/1.14.1-2-gcc-ompi; module list;"
    ;;
esac
$white; printf "String --> module_list : "; $bold;
$magenta; printf "${module_list}\n"; $reset_colors;
$green; printf "done.\n"; $reset_colors;
#-------------------------------------------------------------------------------
$green; $bold;
echo "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
$red  ; printf "Directory structure    : ";
$cyan ; printf "$(basename \"$0\")\n"; $green;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$reset_colors;
$white; printf "hostname               : ";$red;     printf "%s\n" "$hostname";             $reset_colors;
$white; printf "machine_name           : ";$red;     printf "%s\n" "$machine_name";         $reset_colors;
$white; printf "build_dir              : ";$blue;    printf "%s\n" "$build_dir";            $reset_colors;
$white; printf "sourcecode_dir         : ";$green;   printf "%s\n" "$sourcecode_dir";       $reset_colors;
$white; printf "prefix Directory       : ";$yellow;  printf "%s\n" "$prefix";               $reset_colors;
$white; printf "base Directory         : ";$blue;    printf "%s\n" "$basedir";              $reset_colors;
$white; printf "grid directory         : ";$magenta; printf "%s\n" "$grid_dir";             $reset_colors;
$white; printf "grid build directory   : ";$magenta; printf "%s\n" "$grid_build_dir";       $reset_colors;
$white; printf "Hirep_LLR_SP directory : ";$yellow;  printf "%s\n" "$Hirep_LLR_SP_dir";     $reset_colors;
$white; printf "Hirep_LLR_SP_HMC dir   : ";$green;   printf "%s\n" "$Hirep_LLR_SP_HMC_dir"; $reset_colors;
$white; printf "HiRep_Cuda directory   : ";$green;   printf "%s\n" "$HiRep_Cuda_dir";       $reset_colors;
$white; printf "Sombrero directory     : ";$magenta; printf "%s\n" "$sombrero_dir";         $reset_colors;
$white; printf "BKeeper directory      : ";$cyan;    printf "%s\n" "$bkeeper_dir";          $reset_colors;
$white; printf "Lattice runs directory : ";$magenta; printf "%s\n" "$LatticeRuns_dir";      $reset_colors;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan;  printf "<-- Git repos      --->: ";$cyan;    printf "\n";                           $reset_colors;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$white; printf "grid_DWF_Telos_git     : ";$cyan;    printf "%s\n" "$grid_DWF_Telos_git_url"; $reset_colors;
$white; printf "grid_UCL_ARC_git       : ";$cyan;    printf "%s\n" "$grid_UCL_ARC_git_url"; $reset_colors;
$white; printf "Sombrero_git           : ";$cyan;    printf "%s\n" "$sombrero_git_url";     $reset_colors;
$white; printf "BKeeper_git            : ";$cyan;    printf "%s\n" "$bkeeper_git_url";      $reset_colors;
$white; printf "Hirep_LLR_SP_git       : ";$cyan;    printf "%s\n" "$Hirep_LLR_SP_git_url"; $reset_colors;
$white; printf "LLR_HiRep_HB_input_git : ";$cyan;    printf "%s\n" "$LLR_HiRep_heatbath_input_git_url"; $reset_colors;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan;  printf "<-- Shell          --->: ";$cyan;    printf "%s\n" "$0";                    $reset_colors;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
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
              "$LLR_HiRep_heatbath_input_dir"
              "$HiRep_Cuda_dir"
              "$grid_dir"
              "$grid_build_dir"
              "$grid_DWF_Telos_dir"
              "$basedir"
              "$prefix"
              "$data_dir"
              "$DWF_ensembles_GRID_dir"
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
$cyan;printf "<-- Max length dir --->: ";$yellow;printf "%i\n" "${max_string_length}";$white
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


