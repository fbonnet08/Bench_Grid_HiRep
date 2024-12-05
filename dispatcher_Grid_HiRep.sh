#!/usr/bin/bash
set -eu
scrfipt_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!     Code to dispatch the codes to remote clusters.                    !"
echo "!     $scrfipt_file_name                                          !"
echo "!     [Author]: Frederic Bonnet October 2024                            !"
echo "!     [usage]: sh dispatcher_Grid_hiRep.sh                              !"
echo "!     [example]: sh dispatcher_Grid_hiRep.sh                            !"
echo "!                                                                       !"
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
tput sgr0;
#colors
red="tput setaf 1"  ;green="tput setaf 2"  ;yellow="tput setaf 3"
blue="tput setaf 4" ;magenta="tput setaf 5";cyan="tput setaf 6"
white="tput setaf 7";bold=""               ;reset_colors="tput sgr0"
# Global variables
sptr="/"
# read username and echo username in terminal
#echo           "Enter Username         : "; username="frederic"                    # read username;
#echo           "Enter remote hostname  : "; remote_hostname="137.44.5.215"         # read remote_hostname;
echo           "Enter Username         : "; username="dc-bonn2"                    # read username;
echo           "Enter remote hostname  : "; remote_hostname="tursa.dirac.ed.ac.uk" # read remote_hostname;
#echo           "Enter Username         : "; username="eufredericb"                 # read username;
#echo           "Enter remote hostname  : "; remote_hostname="login.vega.izum.si"   # read remote_hostname;

echo
$white; printf "username               : ";$green;  printf "$username\n";$reset_colors;
$white; printf "remote hostname        : ";$yellow; printf "$remote_hostname\n";$reset_colors;

user_remote_host=${username}"@"${remote_hostname}
$white; printf "user@hostname          : ";$blue;   printf "$user_remote_host\n";$reset_colors;
printf "\n"
# Getting the remote home dir from the remote (brutal way of doing this)
user_remote_home_dir=$(ssh -t ${user_remote_host} "cd ~/; pwd -P")
$white; printf "user remote home dir   : ";$magenta; printf "$user_remote_home_dir\n";$reset_colors;

# Setting the external lib_dir
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
src_dir="SwanSea/SourceCodes"
lib_dir="SwanSea/SourceCodes/external_lib";
lat_run_dir="SwanSea/SourceCodes/LatticeRuns";
#external_lib_dir=$(echo $user_remote_home_dir$sptr$lib_dir | tr -d ' ')
chopped=$(echo "${user_remote_home_dir}" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
external_lib_dir=$chopped$sptr$lib_dir
source_dir=$chopped$sptr$src_dir
LatticeRuns_dir=$chopped$sptr$lat_run_dir
$white; printf "source_dir             : ";$yellow; printf "$source_dir\n";$reset_colors;
$white; printf "external_lib_dir       : ";$magenta; printf "$external_lib_dir\n";$reset_colors;
$white; printf "Lattice run directory  : ";$cyan; printf "$LatticeRuns_dir\n";$reset_colors;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"

ssh -t $user_remote_host "
#colors
red=\"tput setaf 1\"  ;green=\"tput setaf 2\"  ;yellow=\"tput setaf 3\"
blue=\"tput setaf 4\" ;magenta=\"tput setaf 5\";cyan=\"tput setaf 6\"
white=\"tput setaf 7\";bold=\"\"               ;reset_colors=\"tput sgr0\"

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
# First let's get the code
cd ${source_dir} ; pwd ; ls -al ${source_dir}

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
src_fldr=./Bench_Grid_HiRep
\$white; printf \"Directory              : \"; \$bold;
\$magenta; printf \'%s\'\"\$src_fldr\"; \$green; printf \" exist, nothing to do.\n\"; \$white; \$reset_colors;

if [ -d \$src_fldr ]
then
 cd ./Bench_Grid_HiRep
 git pull
 cd ..
else
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

cp -v common_main.sh build_*.sh install_*.sh launcher_*.sh ${external_lib_dir}
cp -v clean_allbuilds.sh ${source_dir}

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
# Now moving to the directory external_dir directory
\$white; printf \"Moving to directory    : \"; \$bold;
\$magenta; printf \'%s\'\"${external_lib_dir}\"; \$green; printf \" exist, nothing to do.\n\"; \$white; \$reset_colors;
cd ${external_lib_dir}; pwd ;ls -al ${external_lib_dir}

# loading the modules for compilation (only valid during the life of this script)
\$white; printf \"Module load (script)   : \"; \$bold;
case ${remote_hostname} in
  *\"tursa.dirac.ed.ac.uk\"*);;
  *\"sunbird.swansea.ac.uk\"*) module load CUDA/11.7 compiler/gnu/11/3.0 mpi/openmpi/1.10.6; module list;;
  *\"login.vega.izum.si\"*)
    source /etc/profile.d/modules.sh;
    source /ceph/hpc/software/cvmfs_env.sh ;
    module list;
    module load CUDA/12.3.0 OpenMPI/4.1.5-GCC-12.3.0 UCX/1.15.0-GCCcore-12.3.0 GCC/12.3.0; module list;;
esac
\$green; printf \"done.\n\"; \$reset_colors;

which bash;
bash -s < ./creator_batch.sh         SwanSea/SourceCodes/external_lib BKeeper_compile;
bash -s < ./creator_batch.sh         SwanSea/SourceCodes/external_lib BKeeper_run_cpu;
bash -s < ./creator_batch.sh         SwanSea/SourceCodes/external_lib BKeeper_run_gpu;
bash -s < ./creator_batch.sh         SwanSea/SourceCodes/external_lib Sombrero_weak
bash -s < ./creator_batch.sh         SwanSea/SourceCodes/external_lib Sombrero_strong
bash -s < ./creator_batch.sh         SwanSea/SourceCodes/external_lib HiRep-LLR-master-cpu

#bash -s < ./build_Hirep_LLR_SP.sh     SwanSea/SourceCodes/external_lib;
#bash -s < ./build_HiRep-LLR-master.sh SwanSea/SourceCodes/external_lib;
#bash -s < ./build_dependencies.sh     SwanSea/SourceCodes/external_lib;
#bash -s < ./build_Grid.sh             SwanSea/SourceCodes/external_lib;
bash -s < ./build_SombreroBKeeper.sh  SwanSea/SourceCodes/external_lib;

#bash -s < ./install_Grid.sh          SwanSea/SourceCodes/external_lib;

#bash -s < ./launcher_bench_BKeeper.sh         SwanSea/SourceCodes/external_lib BKeeper_compile;
#bash -s < ./launcher_bench_Grid.sh            SwanSea/SourceCodes/external_lib;
#bash -s < ./launcher_bench_Sombrero_Weak.sh   SwanSea/SourceCodes/external_lib;
#bash -s < ./launcher_bench_Sombrero_Strong.sh SwanSea/SourceCodes/external_lib;
#bash -s < ./launcher_bench_HiRep.sh           SwanSea/SourceCodes/external_lib;

"
#TODO: continue with the commands here or in the ssh statement
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


