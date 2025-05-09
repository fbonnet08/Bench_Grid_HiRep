#!/usr/bin/bash
ARGV=`basename -a $1 $2 $3`
set -eu
script_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!  Code to dispatch the codes to remote clusters.                       !"
echo "!  $script_file_name                                             !"
echo "!  [Author]: Frederic Bonnet October 2024                               !"
echo "!  [usage]:   sh dispatcher_Grid_hiRep.sh {username} {acc} {hostname}   !"
echo "!  [example]: sh dispatcher_Grid_hiRep.sh $1 $2 $3 !"
echo "!                                                                       !"
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
tput sgr0;
#colors
red="tput setaf 1"  ;green="tput setaf 2"  ;yellow="tput setaf 3"
blue="tput setaf 4" ;magenta="tput setaf 5";cyan="tput setaf 6"
white="tput setaf 7";bold=""               ;reset_colors="tput sgr0"
# Global variables
sptr="/"
# Store the username, project_account and remote_hostname
username=$1                 # username;
project_account=$2          # account project;
remote_hostname=$3          # remote_hostname;

echo           "Username               : $username";
echo           "Project Account        : $project_account";
echo           "Remote hostname        : $remote_hostname";

echo
$white; printf "Username               : ";$green;  printf "$username\n";$reset_colors;
$white; printf "Project Account        : ";$magenta;printf "$project_account\n";$reset_colors;
$white; printf "Remote hostname        : ";$yellow; printf "$remote_hostname\n";$reset_colors;

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
add_connect_strg=""
case ${remote_hostname} in
  *"aac6.amd.com"*)
    add_connect_strg="-X -i ~/.ssh/id_rsa -p 7000"
  ;;
  *"aac1.amd.com"*)
    add_connect_strg="-X -i ~/.ssh/id_rsa -p 7005"
  ;;
  *"login.vega.izum.si"*)
    add_connect_strg="-X -i ~/.ssh/id_ed255"
  ;;
  *"login.leonardo.cineca.it"*)
    add_connect_strg="-X -i ~/.ssh/id_rsa"
  ;;
esac
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
user_remote_host=${username}"@"${remote_hostname}
$white; printf "user@hostname          : ";$blue;   printf "$user_remote_host\n";$reset_colors;
printf "\n"
# Getting the remote home dir from the remote (brutal way of doing this)
user_remote_home_dir=$(ssh -t ${add_connect_strg} "${user_remote_host}" "cd ~/; pwd -P")
$white; printf "user remote home dir   : ";$magenta; printf "$user_remote_home_dir\n";$reset_colors;

# Setting the external lib_dir
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
src_dir="SwanSea/SourceCodes"
lib_dir="$src_dir"/"external_lib";
lat_run_dir="$src_dir"/"LatticeRuns";
#external_lib_dir=$(echo $user_remote_home_dir$sptr$lib_dir | tr -d ' ')
chopped=$(echo "${user_remote_home_dir}" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
source_dir=$chopped$sptr$src_dir
external_lib_dir=$chopped$sptr$lib_dir
LatticeRuns_dir=$chopped$sptr$lat_run_dir
$white; printf "source_dir             : ";$yellow; printf "$source_dir\n";$reset_colors;
$white; printf "external_lib_dir       : ";$magenta; printf "$external_lib_dir\n";$reset_colors;
$white; printf "Lattice run directory  : ";$cyan; printf "$LatticeRuns_dir\n";$reset_colors;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"

ssh -t ${add_connect_strg} "$user_remote_host" "
#colors
red=\"tput setaf 1\"  ;green=\"tput setaf 2\"  ;yellow=\"tput setaf 3\"
blue=\"tput setaf 4\" ;magenta=\"tput setaf 5\";cyan=\"tput setaf 6\"
white=\"tput setaf 7\";bold=\"\"               ;reset_colors=\"tput sgr0\"

_username=${username}
_project_account=${project_account}
_remote_hostname=${remote_hostname}

echo           \"Enter Username  (ssh)  : \$_username\";
echo           \"Project Account (ssh)  : \$_project_account\";
echo           \"Remote hostname (ssh)  : \$_remote_hostname\";

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
if [ -d ${source_dir} ]
then
  \$white; printf \"Directory              : \"; \$bold;
  \$blue; printf \'%s\'\"${source_dir}\"; \$green; printf \" exist, nothing to do.\n\"; \$white; \$reset_colors;
else
  \$white; printf \"Directory              : \"; \$bold;
  \$blue; printf \'%s\'\"${source_dir}\"; \$red;printf \" does not exist, We will create it ...\n\";
   \$white; \$reset_colors;
  mkdir -p ${source_dir}
  printf \"                       : \"; \$bold;
  \$green; printf \"done.\n\"; \$reset_colors;
fi
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
# First let's get the code
cd ${source_dir} ; pwd ; ls -al ${source_dir}

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
src_fldr=./Bench_Grid_HiRep
if [ -d \$src_fldr ]
then
  \$white; printf \"Project                : \"; \$bold;
  \$magenta; printf \'%s\'\"\$src_fldr\"; \$green; printf \" exist, we will update it with a pull.\n\"; \$white; \$reset_colors;

  cd ./Bench_Grid_HiRep
  git pull
  cd ..
else
  \$white; printf \"Project                : \"; \$bold;
  \$magenta; printf \'%s\'\"\$src_fldr\"; \$red; printf \" does not exist, we will clone from GitHub.\n\"; \$white; \$reset_colors;
  git clone https://github.com/fbonnet08/Bench_Grid_HiRep.git
fi

cd \$src_fldr;
pwd ;

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
if [ -d ${external_lib_dir} ]
then
  \$white; printf \"Directory              : \"; \$bold;
  \$blue; printf \'%s\'\"${external_lib_dir}\"; \$green; printf \" exist, nothing to do.\n\"; \$white; \$reset_colors;
else
  \$white; printf \"Directory              : \"; \$bold;
  \$blue; printf \'%s\'\"${external_lib_dir}\"; \$red;printf \" does not exist, We will create it ...\n\";
   \$white; \$reset_colors;
  mkdir -p ${external_lib_dir}
  printf \"                       : \"; \$bold;
  \$green; printf \"done.\n\"; \$reset_colors;
fi
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
if [ -d ${LatticeRuns_dir} ]
then
  \$white; printf \"Directory              : \"; \$bold;
  \$blue; printf \'%s\'\"${LatticeRuns_dir}\"; \$green; printf \" exist, nothing to do.\n\"; \$white; \$reset_colors;
else
  \$white; printf \"Directory              : \"; \$bold;
  \$blue; printf \'%s\'\"${LatticeRuns_dir}\"; \$red;printf \" does not exist, We will create it ...\n\";
   \$white; \$reset_colors;
  mkdir -p ${LatticeRuns_dir}
  printf \"                       : \"; \$bold;
  \$green; printf \"done.\n\"; \$reset_colors;
fi

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
# copying files to destination directory
\$white; printf \"Moving files to dst    : \"; \$bold;
\$magenta; printf \'%s\'\"\$src_fldr\"; \$green; printf \" exist, nothing to do.\n\"; \$white; \$reset_colors;

cp -v common_main.sh build_*.sh install_*.sh launcher_*.sh creator_bench_*.sh ${external_lib_dir}
cp -rv clean_all_builds.sh config_*.sh ./Scripts ${external_lib_dir}
cp kill_*.sh ${LatticeRuns_dir}

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
# Now moving to the directory external_dir directory
\$white; printf \"Moving to directory    : \"; \$bold;
\$magenta; printf \'%s\'\"${external_lib_dir}\"; \$green; printf \" exist, nothing to do.\n\"; \$white; \$reset_colors;
cd ${external_lib_dir}; pwd ;ls -al ${external_lib_dir}

# loading the modules for compilation (only valid during the life of this script)
\$white; printf \"Module load (script)   : \"; \$bold;
case ${remote_hostname} in
  *\"tursa.dirac.ed.ac.uk\"*)
    ;;
  *\"sunbird.swansea.ac.uk\"*)
    ;;
  *\"login.vega.izum.si\"*)
    source /etc/profile.d/modules.sh;
    source /ceph/hpc/software/cvmfs_env.sh;
    module list;
    module load UCX/1.8.0-GCCcore-9.3.0;
    module load OpenMPI/4.0.3-GCC-9.3.0;
    module load CUDA/11.0.2-GCC-9.3.0;
    module load GCC/9.3.0;
    module load Python/3.8.2-GCCcore-9.3.0;
    module load FFTW;
    module list;
    ;;
  *\"lumi.csc.fi\"*)
    module load cray-mpich cray-fftw cray-hdf5-parallel cray-python;
    module list;
    ;;
  *\"login.leonardo.cineca.it\"*)
    source  /etc/profile.d/modules.sh
    module list;

    # Getting the WarpX environment before it gets converted as a module
    #bash -s < ./build_WarpX_leonardo.sh        SwanSea/SourceCodes/external_lib;

    module purge;
    source  /etc/profile.d/modules.sh
    module load cuda/12.2 nvhpc/23.11 fftw/3.3.10--openmpi--4.1.6--gcc--12.2.0 hdf5

    \$white; printf \"Module list after WarpX: \n\"; \$white; \$reset_colors;
    module list;
    ;;
  *\"aac6.amd.com\"*)
    source /etc/profile.d/lmod.sh;
    source /etc/profile.d/z00_lmod.sh;
    source /etc/profile.d/z01_lmod.sh;
    module load rocm amdclang hdf5 fftw openmpi;
    module list;
    ;;
  *\"aac1.amd.com\"*)
    source /etc/profile.d/lmod.sh;
    source /etc/profile.d/z00_lmod.sh;
    source /etc/profile.d/z01_lmod.sh;
    module load rocm amdclang hdf5 fftw openmpi;
    module list;
    ;;
  *\"alogin1.bsc.es\"*)
    source /etc/profile.d/01-module.sh
    module load gcc cuda ucx intel impi hdf5 fftw;
    module list;
    ;;
  *\"glogin1.bsc.es\"*)

    ;;
esac
\$green; printf \"done.\n\"; \$reset_colors;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"

which bash;
CURRENT_DIR=\$(echo \`pwd\`)
\$white; printf \"Current path b4 scripts: \"; \$bold;
\$magenta; printf \'%s\'\"\$CURRENT_DIR\n\"; \$white; \$reset_colors;

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"

bash -s < ./creator_bench_all_batchs.sh        \$_project_account SwanSea/SourceCodes/external_lib;

bash -s < ./build_Hirep_LLR_SP.sh              SwanSea/SourceCodes/external_lib;
bash -s < ./build_HiRep-LLR-master.sh          SwanSea/SourceCodes/external_lib;
bash -s < ./build_dependencies.sh              SwanSea/SourceCodes/external_lib;

bash -s < ./build_Grid.sh                      SwanSea/SourceCodes/external_lib;
bash -s < ./install_Grid.sh                    SwanSea/SourceCodes/external_lib;
bash -s < ./build_Grid-DWF-Telos.sh            SwanSea/SourceCodes/external_lib;
bash -s < ./install_Grid-DWF-Telos.sh          SwanSea/SourceCodes/external_lib;

bash -s < ./build_SombreroBKeeper.sh           SwanSea/SourceCodes/external_lib;

#bash -s < ./launcher_bench_BKeeper.sh           SwanSea/SourceCodes/external_lib BKeeper_run_gpu
#bash -s < ./launcher_bench_Grid-DWF-Telos.sh    SwanSea/SourceCodes/external_lib Grid_DWF_run_gpu

#bash -s < ./launcher_bench_Sombrero.sh        SwanSea/SourceCodes/external_lib Sombrero_weak;
#bash -s < ./launcher_bench_Sombrero.sh        SwanSea/SourceCodes/external_lib Sombrero_strong;
#bash -s < ./launcher_bench_Grid.sh            SwanSea/SourceCodes/external_lib; -->: Here it will be: Grid_DWF_run_gpu
#bash -s < ./launcher_bench_HiRep.sh           SwanSea/SourceCodes/external_lib;
"
#TODO: bash -s < ./profile_grid.sh SwanSea/SourceCodes/external_lib;
#scp -r ./dependencies_Grid.sh ./Scripts ${user_remote_host}:${external_lib_dir}
#ssh -t $user_remote_host " cd ${external_lib_dir};
# ls -al; which bash ; bash -s < ./dependencies_Grid.sh SwanSea/SourceCodes/external_lib;"
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  dispatcher_Grid_hiRep.sh Done.                       -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#exit
#-------------------------------------------------------------------------------


