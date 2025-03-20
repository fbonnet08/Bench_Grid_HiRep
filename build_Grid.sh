#!/usr/bin/bash
ARGV=`basename -a $1`
set -eu
scrfipt_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!     Code to load modules and prepare the base dependencies for grid   !"
echo "!     $scrfipt_file_name                                                     !"
echo "!     [Author]: Frederic Bonnet October 2024                            !"
echo "!     [usage]: sh build_Grid.sh   {Input list}                          !"
echo "!     [example]: sh build_Grid.sh /data/local                           !"
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
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------

source ./common_main.sh $1;
source ./Scripts/Batch_Scripts/Batch_util_methods.sh;

#-------------------------------------------------------------------------------
# First pulling the code from GitHub
#-------------------------------------------------------------------------------
# TODO: ------------------------------------------------------------------------
# TODO: finish this bit
# TODO: ------------------------------------------------------------------------
src_fldr="${sourcecode_dir}"/Grid-UCL-ARC

Git_Clone_project "${src_fldr}" "https://github.com/UCL-ARC/Grid.git"

pwd ;
# TODO: ------------------------------------------------------------------------
# TODO: ------------------------------------------------------------------------
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

# Creating the build directory build_dir variable is located in ./common_main.sh file
Batch_util_create_path "${build_dir}"

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
    --enable-doxygen-doc \
    --with-lime=${prefix} \
    --with-gmp=${prefix} \
    --with-mpfr=${prefix} \
    --with-openssl=/usr/lib/x86_64-linux-gnu/ \
    --includedir=/usr/include/x86_64-linux-gnu/mpi \
    --disable-unified
    ;;
  *"desktop-dpr4gpr"*)
    #../configure --prefix=/home/frederic/SwanSea/SourceCodes/external_lib/prefix_grid_202410/ --enable-doxygen-doc --enable-comms=mpi-auto --enable-Sp  --enable-Nc=4 --with-lime=/home/frederic/SwanSea/SourceCodes/external_lib/prefix_grid_202410/ --with-gmp=/home/frederic/SwanSea/SourceCodes/external_lib/prefix_grid_202410/ --with-mpfr=/home/frederic/SwanSea/SourceCodes/external_lib/prefix_grid_202410/ --with-openssl=/usr/lib/x86_64-linux-gnu/ --includedir=/usr/include/x86_64-linux-gnu/mpi  --disable-unified
    #../configure --prefix=/home/frederic/SwanSea/SourceCodes/external_lib/prefix_grid_202410/ --enable-doxygen-doc --enable-comms=mpi-auto --with-lime=/home/frederic/SwanSea/SourceCodes/external_lib/prefix_grid_202410/ --with-gmp=/home/frederic/SwanSea/SourceCodes/external_lib/prefix_grid_202410/ --with-mpfr=/home/frederic/SwanSea/SourceCodes/external_lib/prefix_grid_202410/ --with-openssl=/usr/lib/x86_64-linux-gnu/ --with-hdf5=/usr/lib/x86_64-linux-gnu/hdf5/openmpi --includedir=/usr/include/x86_64-linux-gnu/ --includedir=/usr/lib/x86_64-linux-gnu/lapack
    #../configure --prefix=/home/frederic/SwanSea/SourceCodes/external_lib/prefix_grid_202410/ --enable-doxygen-doc --enable-comms=mpi-auto --enable-Sp --with-lime=/home/frederic/SwanSea/SourceCodes/external_lib/prefix_grid_202410/ --with-gmp=/home/frederic/SwanSea/SourceCodes/external_lib/prefix_grid_202410/ --with-mpfr=/home/frederic/SwanSea/SourceCodes/external_lib/prefix_grid_202410/ --with-openssl=/usr/lib/x86_64-linux-gnu/ --with-hdf5=/usr/lib/x86_64-linux-gnu/hdf5/openmpi --includedir=/usr/include/x86_64-linux-gnu/ --includedir=/usr/lib/x86_64-linux-gnu/lapack
    ../configure \
    --prefix=${prefix} \
    --enable-doxygen-doc \
    --enable-comms=mpi-auto \
    --with-lime=${prefix} \
    --with-gmp=${prefix} \
    --with-mpfr=${prefix} \
    --with-openssl=/usr/lib/x86_64-linux-gnu/ \
    --includedir=/usr/include/x86_64-linux-gnu/mpi \
    --disable-unified
    ;;
  *"DESKTOP-GPI5ERK"*)
    ../configure \
    --prefix=${prefix} \
    --enable-doxygen-doc \
    --enable-comms=mpi-auto \
    --with-lime=${prefix} \
    --with-gmp=${prefix} \
    --with-mpfr=${prefix} \
    --with-openssl=/usr/lib/x86_64-linux-gnu/ \
    --includedir=/usr/include/x86_64-linux-gnu/mpi \
    --disable-unified
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
  *"lumi"*)
    #--with-fftw=$FFTW_DIR/.. \
    ../configure \
    --prefix=${prefix} \
    --enable-comms=mpi-auto \
    --enable-unified=no \
    --enable-shm=nvlink \
    --enable-accelerator=hip \
    --enable-gen-simd-width=64 \
    --enable-simd=GPU \
    --enable-accelerator-cshift \
    --with-lime=${prefix} \
    --with-gmp=${prefix} \
    --with-mpfr=${prefix} \
    --disable-fermion-reps \
    --disable-gparity \
    CXX=hipcc MPICXX=mpicxx \
    CXXFLAGS="-fPIC --offload-arch=gfx90a -I/opt/rocm/include/ -std=c++17 -I/opt/cray/pe/mpich/8.1.23/ofi/gnu/9.1/include" \
    LDFLAGS="-L/opt/cray/pe/mpich/8.1.23/ofi/gnu/9.1/lib -lmpi -L/opt/cray/pe/mpich/8.1.23/gtl/lib -lmpi_gtl_hsa -lamdhip64 -fopenmp"
    ;;
  *"leonardo"*)
    ../configure \
    --prefix=${prefix} \
    --enable-comms=mpi-auto \
    --enable-unified=no \
    --enable-shm=nvlink \
    --enable-accelerator=cuda \
    --enable-gen-simd-width=64 \
    --enable-simd=GPU \
    --enable-accelerator-cshift \
    --with-lime=${prefix} \
    --with-gmp=${prefix} \
    --with-mpfr=${prefix} \
    --disable-fermion-reps \
    --disable-gparity \
    CXX=nvcc \
    LDFLAGS="-cudart shared -lcublas" \
    CXXFLAGS="-ccbin mpicxx -gencode arch=compute_80,code=sm_80 -std=c++17 -cudart shared --diag-suppress 177,550,611"
    ;;
  *"mi300"*)
    #--with-fftw=$FFTW_DIR/.. \
    ../configure \
    --prefix=${prefix} \
    --enable-comms=mpi-auto \
    --enable-unified=no \
    --enable-shm=nvlink \
    --enable-accelerator=hip \
    --enable-gen-simd-width=64 \
    --enable-simd=GPU \
    --enable-accelerator-cshift \
    --with-lime=${prefix} \
    --with-gmp=${prefix} \
    --with-mpfr=${prefix} \
    --disable-fermion-reps \
    --disable-gparity \
    CXX=hipcc MPICXX=mpicxx \
    CXXFLAGS="-fPIC --offload-arch=gfx90a -I/opt/rocm/include/ -std=c++17 -I/opt/rocmplus-6.3.3/openmpi-5.0.7-ucc-1.3.0-ucx-1.18.0/include" \
    LDFLAGS="-L/opt/rocmplus-6.3.3/openmpi-5.0.7-ucc-1.3.0-ucx-1.18.0/lib -lmpi -fopenmp"
    ;;
esac

$green; printf "Building Grid                : "; $bold;
$yellow; printf "coffee o'clock time! ... \n"; $white; $reset_colors;
if [[ $machine_name =~ "Precision-3571"  ||
      $machine_name =~ "DESKTOP-GPI5ERK" ||
      $machine_name =~ "desktop-dpr4gpr" ]]; then
  make -k -j16;
else
  make -k -j32;
fi

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
