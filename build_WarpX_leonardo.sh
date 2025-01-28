#!/usr/bin/bash
ARGV=`basename -a $1`
set -eu
script_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!  Code to load modules and prepare the base dependencies for grid      !"
echo "!  $script_file_name                                                !"
echo "!  [Author]: Frederic Bonnet January 2025                               !"
echo "!  [usage]: sh build_WarpX_leonardo.sh   {Input list}                   !"
echo "!  [example]: sh build_WarpX_leonardo.sh {...}/SourceCodes/external_lib !"
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
_external_lib_dir=$1
source ./common_main.sh $1;
source ./Scripts/Batch_Scripts/Batch_util_methods.sh;
#-------------------------------------------------------------------------------
# Creating the src folder for the dumping the environment source code python
#-------------------------------------------------------------------------------
__path_to_home_src="${HOME}"/src
Batch_util_create_path "${__path_to_home_src}"
#-------------------------------------------------------------------------------
# Getting and building the dependencies
#-------------------------------------------------------------------------------
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$white; printf "Getting and compiling  : "; $bold;
$magenta; printf "WarpX\n"; $white; $reset_colors;

cd ${basedir}
git clone https://github.com/ECP-WarpX/WarpX.git
for i in $(seq 0 $sleep_time)
do
  $green;ProgressBar "${i}" "${sleep_time}"; sleep 1;
done
printf "\n"
#-------------------------------------------------------------------------------
# Making the link between external_lib/WarpX <----> $HOME/src/warpx and
#-------------------------------------------------------------------------------
$white; printf "Creating Sym link      : "; $bold;
$magenta; printf "ln -s ${HOME}/${_external_lib_dir}/grid_bench_202410/WarpX ";
          printf " ${HOME}/src/warpx\n";
$white; $reset_colors;

ln -s "${HOME}"/"${_external_lib_dir}"/grid_bench_202410/WarpX \
      "${HOME}"/src/warpx
#-------------------------------------------------------------------------------
# Setting up the WarpX environment WarpX and then compiling the all of the codes
#-------------------------------------------------------------------------------
# Copying the leonardo profile to external_lib dir
$white; printf "Copying profile        : "; $bold;
$magenta; printf "cp ./WarpX/Tools/machines/leonardo-cineca/leonardo_gpu_warpx.profile.example ";
          printf "${HOME}/${_external_lib_dir}/leonardo_gpu_warpx.profile\n";
$white; $reset_colors;

cp ./WarpX/Tools/machines/leonardo-cineca/leonardo_gpu_warpx.profile.example \
    "${HOME}"/"${_external_lib_dir}"/leonardo_gpu_warpx.profile
#-------------------------------------------------------------------------------
# Executing the leonardo_gpu_warpx.profile
#-------------------------------------------------------------------------------
$white; printf "Sourcing the profile   : "; $bold;
$magenta; printf "leonardo_gpu_warpx.profile\n"; $white; $reset_colors;
source "${HOME}"/"${_external_lib_dir}"/leonardo_gpu_warpx.profile
#-------------------------------------------------------------------------------
# Installing the package and creating the dependencies
#-------------------------------------------------------------------------------
# Finally, since Leonardo does not yet provide software modules for some of
# our dependencies, install them once:
# Here we are using the same script as original minus LibEnsemble optional
# installation.
#bash ./WarpX/Tools/machines/leonardo-cineca/install_gpu_dependencies.sh
bash "${LeonardoInstallerWarpX_dir}"/install_gpu_dependencies.sh
#-------------------------------------------------------------------------------
# Activating the python environment
#-------------------------------------------------------------------------------
source "${HOME}"/sw/venvs/warpx/bin/activate
#-------------------------------------------------------------------------------
# [build_gpu]: Compiling via cmake the code WarpX from ln -s directory ~./src/warpx
#-------------------------------------------------------------------------------
cd "${HOME}"/src/warpx
rm -rf build_gpu

#cmake -S . -B build_gpu -DWarpX_COMPUTE=CUDA -DWarpX_PSATD=ON -DWarpX_QED_TABLE_GEN=ON -DWarpX_DIMS="1;2;RZ;3"
cmake -S . -B build_gpu \
      -DWarpX_COMPUTE=CUDA \
      -DWarpX_PSATD=ON \
      -DWarpX_QED_TABLE_GEN=ON \
      -DWarpX_DIMS="1;2;RZ;3"
# 16
cmake --build build_gpu -j 32
#-------------------------------------------------------------------------------
# [build_gpu_py]: Compiling via cmake the code WarpX from ln -s directory ~./src/warpx
#-------------------------------------------------------------------------------
cd "${HOME}"/src/warpx
rm -rf build_gpu_py

#cmake -S . -B build_gpu_py -DWarpX_COMPUTE=CUDA -DWarpX_PSATD=ON -DWarpX_QED_TABLE_GEN=ON -DWarpX_PYTHON=ON -DWarpX_APP=OFF -DWarpX_DIMS="1;2;RZ;3"
cmake -S . -B build_gpu_py \
      -DWarpX_COMPUTE=CUDA \
      -DWarpX_PSATD=ON \
      -DWarpX_QED_TABLE_GEN=ON \
      -DWarpX_PYTHON=ON \
      -DWarpX_APP=OFF \
      -DWarpX_DIMS="1;2;RZ;3"
# 16
cmake --build build_gpu_py -j 32 --target pip_install
#-------------------------------------------------------------------------------
# [Printing]: Printing information on screen after completion
#-------------------------------------------------------------------------------
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$white;   printf "Now, you can submit Leonardo compute jobs:\n"
$magenta; printf "https://warpx.readthedocs.io/en/24.01/install/hpc/leonardo.html#running-leonardo\n"
$white;   printf " for WarpX Python (PICMI) scripts (example scripts):\n"
$magenta; printf " https://warpx.readthedocs.io/en/24.01/usage/python.html#usage-picmi\n"
$white;   printf "Or, you can use the WarpX executables to submit Leonardo jobs (example inputs):\n"
$magenta; printf "https://warpx.readthedocs.io/en/24.01/usage/examples.html#usage-examples\n"
$white;   printf "For executables, you can reference their location in\n"
$white;   printf "your job script or copy them to a location in ";
$red;     printf "\$CINECA_SCRATCH";
$white;   printf ".\n";
$reset_colors;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
for i in $(seq 0 $sleep_time)
do
  $green;ProgressBar "${i}" "${sleep_time}"; sleep 1;
done
printf "\n"
#-------------------------------------------------------------------------------
# [Finishing]
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  build_WarpX_leonardo.sh Done.                        -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#exit
#-------------------------------------------------------------------------------






