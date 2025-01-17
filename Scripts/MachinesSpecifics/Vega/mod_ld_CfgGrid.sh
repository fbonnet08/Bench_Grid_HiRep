#!/usr/bin/bash
ARGV=`basename -a $1`
set -eu
scrfipt_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!     Code to load modules and prepare configure and build              !"
echo "!     $scrfipt_file_name                                                 !"
echo "!     [Author]: Frederic Bonnet January 2025                            !"
echo "!     [usage]: sh mod_ld_CfgGrid.sh   {option}                          !"
echo "!     [example]: sh mod_ld_CfgGrid.sh distclean                         !"
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
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
# Checking the argument list
if [ $# -ne 1 ]; then
  __action="no action"
  $white; printf "No action specified    : "; $bold;
  $cyan;printf '%s'"${__action}"; $red;printf " ---> we will use the home directory ---> "; $green;printf "${HOME}\n"; $white; $reset_colors;
else
  __action=$1
  $white; printf "Action specified       : "; $bold;
  $cyan;printf '%s'"${__action}"; $red;printf " ---> we will use the home directory ---> "; $green;printf "${HOME}\n"; $white; $reset_colors;
fi
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
prefix=${HOME}/SwanSea/SourceCodes/external_lib/prefix_grid_202410
user_remote_home_dir=$(cd ~/; pwd -P)
SCRIPT_DIR="${user_remote_home_dir}"/SwanSea/SourceCodes/Bench_Grid_HiRep/Scripts/MachinesSpecifics/Vega
echo "$SCRIPT_DIR"
#-------------------------------------------------------------------------------
# Loading the modules
#-------------------------------------------------------------------------------
module purge;
module load CUDA/12.3.0 OpenMPI/4.1.5-GCC-12.3.0 UCX/1.15.0-GCCcore-12.3.0 GCC/12.3.0;
module list;
#-------------------------------------------------------------------------------
# Moving to directory for the build
#-------------------------------------------------------------------------------
Grid_UCL_ARC_dir="${HOME}"/SwanSea/SourceCodes/Grid-UCL-ARC/Grid/

cd "${Grid_UCL_ARC_dir}"/build

ls -al
#-------------------------------------------------------------------------------
# Core count on the node
#-------------------------------------------------------------------------------
_core_count=$(grep -c ^processor /proc/cpuinfo)
#_use_core_count=$(( "${_core_count}" / 2 ))
_use_core_count=$(( "${_core_count}"))

echo "${_core_count}"
echo "${_use_core_count}"
#-------------------------------------------------------------------------------
# Export path and library paths
#-------------------------------------------------------------------------------
#Extending the library path
export PREFIX_HOME=$prefix
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PREFIX_HOME/lib
#-------------------------------------------------------------------------------
# Action on the code
#-------------------------------------------------------------------------------
#exit
case $__action in
  *"cleanup"*)   rm -rf benchmarks examples Grid grid.configure.summary HMC tests;;
  *"distclean"*) make distclean;;
  *"configure"*)
    #  --enable-Sp \
    #  --enable-Nc=4 \
    ../configure \
      --prefix="${prefix}" \
      --enable-comms=mpi \
      --enable-simd=GPU \
      --enable-shm=nvlink \
      --enable-accelerator=cuda \
      --enable-gen-simd-width=64 \
      --disable-gparity \
      --disable-zmobius \
      --disable-fermion-reps \
      --with-lime="${prefix}" \
      --with-gmp="${prefix}" \
      --with-mpfr="${prefix}" \
      --disable-unified \
      CXX=nvcc \
      LDFLAGS="-cudart shared -lcublas " \
      CXXFLAGS="-ccbin mpicxx -gencode arch=compute_80,code=sm_80 -std=c++17 -cudart shared --diag-suppress 177,550,611"
    ;;
  *"build"*)     make -k -j "${_use_core_count}";;
  *"install"*)   make install;;
esac
#-------------------------------------------------------------------------------
# Moving back home
#-------------------------------------------------------------------------------
cd "$SCRIPT_DIR"
ls -al
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  mod_ld_CfgGrid.sh Done.                              -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#exit
#-------------------------------------------------------------------------------
