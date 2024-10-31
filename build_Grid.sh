#!/usr/bin/bash
ARGV=`basename -a $1`
set -eu
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!     Code to load modules and prepare the base dependencies for grid   !"
echo "!     dependencies_Grid.sh                                              !"
echo "!     [Author]: Frederic Bonnet October 2024                            !"
echo "!     [usage]: sh dependencies_Grid.sh   {Input list}                   !"
echo "!     [example]: sh dependencies_Grid.sh /data/local                    !"
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
  $red;printf " we will use the home directory ---> \n"; $green;printf "${HOME}"; $white; $reset_colors;
  local_dir=${HOME}
else
  $white; printf "Directory specified    : "; $bold;
  $blue; printf '%s'"${1}"; $red;printf " will be the working target dir ...\n"; $white; $reset_colors;
  local_dir=${HOME}/$1
fi

#setting up the environment properly

# first get the hostnames and deduce the machine_name from it.
hostname=$(echo ${HOSTNAME});
$white; printf "Hostname               : "; $bold;
$blue; printf "$hostname\n"; $white; $reset_colors;
#TODO: add the other machines here LUMI and Leonardo
if [[ $hostname =~ "tursa" ]]; then
  #echo "Found 'tursa' in string."
  machine_name="tursa"
  # Clearing the modules already loaded and starting fresh
  #source /mnt/lustre/tursafs1/home/y07/shared/tursa-modules/setup-env

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
Hirep_LLR_SP_dir=${sourcecode_dir}/Hirep_LLR_SP
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
$white; printf "Module load (script)   : "; $bold;
case $machine_name in
  *"Precision-3571"*)
    $white; printf "Laptop no module load  : no module load"; $bold
    # grid_dir is already set above but setting to new value here for laptop
    grid_dir=${sourcecode_dir}/JetBrainGateway/Grid-Main/Grid
    ;;
  *"tursa"*)
    source /etc/profile.d/modules.sh ;
    module load /mnt/lustre/tursafs1/home/y07/shared/tursa-modules/setup-env ;
    module load cuda/12.3 openmpi/4.1.5-cuda12.3 ucx/1.15.0-cuda12.3 gcc/9.3.0; module list;;
  *"sunbird"*) module load CUDA/11.7 compiler/gnu/11/3.0 mpi/openmpi/1.10.6; module list;;
  *"vega"*)
    source /etc/profile.d/modules.sh;
    source /ceph/hpc/software/cvmfs_env.sh ;
    module list;
    module load CUDA/12.3.0 OpenMPI/4.1.5-GCC-12.3.0 UCX/1.15.0-GCCcore-12.3.0 GCC/12.3.0; module list;;
esac
$green; printf "done.\n"; $reset_colors;

#-------------------------------------------------------------------------------
$green; $bold;
echo "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
$red  ; printf "Directory structure    : ";
$cyan ; printf "$(basename \"$0\")\n"; $green;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$reset_colors;
$white; printf "hostname               : ";$red;      printf "$hostname\n";$reset_colors;
$white; printf "machine_name           : ";$red;      printf "$machine_name\n";$reset_colors;
$white; printf "prefix Directory       : ";$yellow;   printf "$prefix\n";  $reset_colors;
$white; printf "base Directory         : ";$blue;     printf "$basedir\n";  $reset_colors;
$white; printf "grid directory         : ";$magenta;  printf "$grid_dir\n";      $reset_colors;
$cyan;  printf "<-- extrn_lib Fldr --->: ";$cyan;     printf "$0\n";   $reset_colors;
#-------------------------------------------------------------------------------
# Building grid after the dependencies
#-------------------------------------------------------------------------------
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Moving Grid dir and compiling: "; $bold;
$magenta; printf "${grid_dir}\n"; $white; $reset_colors;
cd ${grid_dir}
ls -al

$magenta; printf "currennt dir: "`pwd`"\n"; $white; $reset_colors;

$green; printf "Launching bootstrapper       : "; $bold;
$magenta; printf "./bootstrap.sh\n"; $white; $reset_colors;
./bootstrap.sh

if [ -d ${build_dir} ]
then
  $white; printf "Directory              : "; $bold;
  $blue; printf '%s'"${build_dir}"; $green; printf " exist, nothing to do.\n"; $white; $reset_colors;
else
  $white; printf "Directory              : "; $bold;
  $blue; printf '%s'"${build_dir}"; $red;printf " does not exist, We will create it ...\n"; $white; $reset_colors;
  mkdir -p ${build_dir}
  printf "                       : "; $bold;
  $green; printf "done.\n"; $reset_colors;
fi

$green; printf "Moving to build directory    : "; $bold;
$magenta; printf "${build_dir}\n"; $white; $reset_colors;
cd build
$magenta; printf "currennt dir: "`pwd`"\n"; $white; $reset_colors;

# loading the modules for compilation (only valid during the life of this script)
# Here the idea is to use the exact same configuration on all machines, the laptop
# configuration is just for testing purpooses and sanity checks when it all goes pear shape
# on the cluster.
#TODO: fix the repetition in the same cases when needed.
$green; printf "Configuring                  : "; $bold;
case $machine_name in
  *"Precision-3571"*)
    ../configure \
    --enable-comms=mpi-auto \
    --enable-doxygen-doc
    ;;
  *"tursa"*)
    ../configure \
    --prefix=${prefix} \
    --enable-doxygen-doc \
    --enable-comms=mpi \
    --enable-simd=GPU \
    --enable-shm=nvlink \
    --enable-accelerator=cuda \
    --enable-gen-simd-width=64 \
    --disable-gparity \
    --disable-fermion-reps \
    --enable-Sp \
    --enable-Nc=4 \
    --with-lime=${prefix} \
    --with-gmp=${prefix} \
    --with-mpfr=${prefix} \
    --disable-unified \
    CXX=nvcc \
    LDFLAGS="-cudart shared -lcublas " \
    CXXFLAGS="-ccbin mpicxx -gencode arch=compute_80,code=sm_80 -std=c++17 -cudart shared --diag-suppress 177,550,611"
    ;;
  *"sunbird"*)
    ../configure \
    --prefix=${prefix} \
    --enable-doxygen-doc \
    --enable-comms=mpi \
    --enable-simd=GPU \
    --enable-shm=nvlink \
    --enable-accelerator=cuda \
    --enable-gen-simd-width=64 \
    --disable-gparity \
    --disable-fermion-reps \
    --enable-Sp \
    --enable-Nc=4 \
    --with-lime=${prefix} \
    --with-gmp=${prefix} \
    --with-mpfr=${prefix} \
    --disable-unified \
    CXX=nvcc \
    LDFLAGS="-cudart shared -lcublas " \
    CXXFLAGS="-ccbin mpicxx -gencode arch=compute_80,code=sm_80 -std=c++17 -cudart shared --diag-suppress 177,550,611"
    ;;
  *"vega"*)
    ../configure \
    --prefix=${prefix} \
    --enable-doxygen-doc \
    --enable-comms=mpi \
    --enable-simd=GPU \
    --enable-shm=nvlink \
    --enable-accelerator=cuda \
    --enable-gen-simd-width=64 \
    --disable-gparity \
    --disable-zmobius \
    --disable-fermion-reps \
    --enable-Sp \
    --enable-Nc=4 \
    --with-lime=${prefix} \
    --with-gmp=${prefix} \
    --with-mpfr=${prefix} \
    --disable-unified \
    CXX=nvcc \
    LDFLAGS="-cudart shared -lcublas " \
    CXXFLAGS="-ccbin mpicxx -gencode arch=compute_80,code=sm_80 -std=c++17 -cudart shared --diag-suppress 177,550,611"
    ;;
esac

$green; printf "Building Grid                : "; $bold;
$yellow; printf "coffee o'clock time! ... \n"; $white; $reset_colors;
if [[ $machine_name =~ "Precision-3571" ]]; then
  make -k -j16;
else
  make -k -j32;
fi
# Running the make install into the prefix directory
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Running make -k install      : "; $bold;
$magenta; printf "${build_dir}\n"; $white; $reset_colors;
ls -al
make -k install

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
prefix_lib_dir=${prefix}/lib
$green; printf "Checking content of prefix library directory : "; $bold;
$magenta; printf "${prefix_lib_dir}\n"; $white; $reset_colors;
ls -al ${prefix_lib_dir}
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
prefix_inc_dir=${prefix}/include
$green; printf "Checking content of prefix include directory : "; $bold;
$magenta; printf "${prefix_inc_dir}\n"; $white; $reset_colors;
ls -al ${prefix_inc_dir}

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
grid_build_bench_dir=${build_dir}/benchmarks
$green; printf "Moving Grid/build/benchmark dir and compiling: "; $bold;
$magenta; printf "${grid_build_bench_dir}\n"; $white; $reset_colors;
cd ${grid_build_bench_dir}
ls -al

#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  build_Grid.sh Done.                                  -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#exit
#-------------------------------------------------------------------------------
