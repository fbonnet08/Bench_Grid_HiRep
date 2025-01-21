#!/usr/bin/bash
ARGV=`basename -a $1`
set -eu
scrfipt_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!     Code to load modules and prepare the base dependencies for grid   !"
echo "!     $scrfipt_file_name                                          !"
echo "!     [Author]: Frederic Bonnet October 2024                            !"
echo "!     [usage]: sh build_SombreroBKeeper.sh   {Input list}               !"
echo "!     [example]: sh build_SombreroBKeeper.sh /data/local                !"
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
# Checking if the libraries have been installed properly
#-------------------------------------------------------------------------------
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

#-------------------------------------------------------------------------------
# First pulling the Sombrero code from GitHub
#-------------------------------------------------------------------------------
# TODO: ------------------------------------------------------------------------
# TODO: finish this bit
# TODO: ------------------------------------------------------------------------
src_fldr="${sourcecode_dir}"/Sombrero

Git_Clone_project "${src_fldr}" "https://github.com/sa2c/SOMBRERO"

pwd ;
# TODO: ------------------------------------------------------------------------
# TODO: ------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Putting and overwriting MkFlags into SOMBRERO ./Make folder
#-------------------------------------------------------------------------------
cp -v "${benchmark_input_dir}"/Sombrero/MkFlags  "${sombrero_dir}"/Make/MkFlags
#-------------------------------------------------------------------------------
# Now compiling Sombrero
#-------------------------------------------------------------------------------
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Moving Sombrero dir and compiling: "; $bold;
$magenta; printf "${sombrero_dir}\n"; $white; $reset_colors;
cd ${sombrero_dir}
ls -al

$green; printf "Building Sombrero            : "; $bold;
$yellow; printf " ... \n"; $white; $reset_colors;
#make -k

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
for i in $(seq 0 $sleep_time)
do
  $green;ProgressBar "${i}" "${sleep_time}"; sleep 1;
done
printf "\n"
#-------------------------------------------------------------------------------
# First pulling the BKeeper code from GitHub
#-------------------------------------------------------------------------------
# TODO: ------------------------------------------------------------------------
# TODO: finish this bit
# TODO: ------------------------------------------------------------------------
src_fldr="${sourcecode_dir}"

Git_Clone_project "${src_fldr}" "https://github.com/RChrHill/BKeeper"

pwd ;
# TODO: ------------------------------------------------------------------------
# TODO: ------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Now compiling BKeeper
#-------------------------------------------------------------------------------
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Moving BKeeper dir and compiling: "; $bold;
$magenta; printf "${bkeeper_dir}\n"; $white; $reset_colors;
cd ${bkeeper_dir}
ls -al
build=build
./bootstrap.sh
# Creating the build directory build_dir variable is located in ./common_main.sh file
Batch_util_create_path "${build}"

$green; printf "Moving to build directory    : "; $bold;
$magenta; printf "${build}\n"; $white; $reset_colors;
cd ${build}
$magenta; printf "currennt dir: "`pwd`"\n"; $white; $reset_colors;

#--enable-su2adj [Explicitly enables compilation for SU(2) adjoint]
#--enable-su2fund [Explicitly enables compilation for SU(2) fundamental]
#--enable-su3fund [Explicitly enables compilation for SU(3) fundamental]
#--enable-su4fund [Explicitly enables compilation for SU(4) fundamental]
#--enable-su3tis  [Explicitly enables compilation for SU(3) two-index symmetric]
#--enable-sp4tis  [Explicitly enables compilation for Sp(4) two-index symmetric]
#--disable-all
#--no-create
#--no-recursion
#--enable-all     [Enables compilation for all benchmarks not explicitly specified]
#--enable-su4tis  [Explicitly enables compilation for SU(4) two-index symmetric]
#--enable-su2tis  [Explicitly enables compilation for SU(2) two-index symmetric]
#--enable-su2tias [Explicitly enables compilation for SU(2) two-index antisymmetric]
#--enable-su3adj  [Explicitly enables compilation for SU(3) adjoint]
#--enable-su3tias [Explicitly enables compilation for SU(3) two-index antisymmetric]
#--enable-su4adj  [Explicitly enables compilation for SU(4) adjoint]
#--enable-su4tias [Explicitly enables compilation for SU(4) two-index antisymmetric]
#--enable-sp4fund [Explicitly enables compilation for Sp(4) fundamental]
#--enable-sp4tias [Explicitly enables compilation for Sp(4) two-index antisymmetric]
#
#../configure --prefix=${prefix} --with-grid=${prefix} --enable-su2adj --enable-su2fund --enable-su3fund --enable-su4fund --enable-su3tis --enable-sp4tis --disable-all CXX="nvcc -std=c++17 -x cu" --no-create --no-recursion
#

if [[ $machine_name =~ "lumi" ]]; then
../configure \
  --prefix=${prefix} \
  --with-grid=${prefix} \
  --enable-su2adj \
  --enable-su2fund \
  --enable-su3fund \
  --enable-su4fund \
  --enable-su3tis \
  --enable-sp4tis \
  --disable-all \
  CXX=hipcc MPICXX=mpicxx \
  CXXFLAGS="-fPIC --offload-arch=gfx90a -I/opt/rocm/include/ -std=c++17 -I/opt/cray/pe/mpich/8.1.23/ofi/gnu/9.1/include" \
  LDFLAGS="-L/opt/cray/pe/mpich/8.1.23/ofi/gnu/9.1/lib -lmpi -L/opt/cray/pe/mpich/8.1.23/gtl/lib -lmpi_gtl_hsa -lamdhip64 -fopenmp"
else
../configure \
  --prefix=${prefix} \
  --with-grid=${prefix} \
  --enable-su2adj \
  --enable-su2fund \
  --enable-su3fund \
  --enable-su4fund \
  --enable-su3tis \
  --enable-sp4tis \
  --disable-all \
  CXX="nvcc -std=c++17 -x cu"
#  --no-create \
#  --no-recursion
#  CXXFLAGS="-std=c++17"
fi

$green; printf "Building BKeeper             : "; $bold;
$yellow; printf "coffee o'clock time! ... \n"; $white; $reset_colors;

# TODO: ----------------------------------------------------------------------------
# TODO: Replace the standard building mecanism with the battch script already created

$green; printf "Building Grid                : "; $bold;
$yellow; printf "coffee o'clock time! ... \n"; $white; $reset_colors;
if [[ $machine_name =~ "Precision-3571"  ||
      $machine_name =~ "DESKTOP-GPI5ERK" ||
      $machine_name =~ "desktop-dpr4gpr" ]]; then
  make -k -j16;
else
  make -k -j32;
fi
# TODO: ----------------------------------------------------------------------------
#echo "Here now we will submit to queue the rest of compilation"
# sbatch script_name > output.log &
#$green; printf "Submitting to queue         : "; $bold;
#$yellow; printf "coffee o'clock time take 2! ... \n"; $white; $reset_colors;
#cd $batch_Scripts_dir
#sbatch ./Compile_BKeeper.sh > out_Compile_BKeeper.log &
# TODO: ----------------------------------------------------------------------------

$green; printf "Installing BKeeper           : "; $bold;
$yellow; printf "coffee o'clock time take 2! ... \n"; $white; $reset_colors;
#make install

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
for i in $(seq 0 $sleep_time)
do
  $green;ProgressBar "${i}" "${sleep_time}"; sleep 1;
done
printf "\n"

#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  build_SombreroBKeeper.sh Done.                       -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#exit
#-------------------------------------------------------------------------------
