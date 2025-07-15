#!/usr/bin/bash
ARGV=`basename -a $1 $2 $3 $4`
set -eu
scrfipt_file_name=$(basename "$0")
tput bold;
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
echo "!                                                                       !"
echo "!     Code to create bench_LLR_DataStructure                            !"
echo "!     $scrfipt_file_name                                            !"
echo "!     [Author]: Frederic Bonnet November 2024                           !"
echo "!     [usage]: creator_bench_LLR_DataStructure.sh   {Input list}        !"
echo "!     [example]: creator_bench_LLR_DataStructure.sh                     !"
echo "!                                      SwanSea/SourceCodes/external_lib !"
echo "! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !"
tput sgr0;
#colors
red="tput setaf 1"  ;green="tput setaf 2"  ;yellow="tput setaf 3"
blue="tput setaf 4" ;magenta="tput setaf 5";cyan="tput setaf 6"
white="tput setaf 7";bold=""               ;reset_colors="tput sgr0"
# Checking the argument list
if [ $# -ne 1 ]; then
  $white; printf "No directory specified : "; $bold;
  $red;printf " we will use the home directory ---> \n"; $green;printf "${HOME}";
  $white; $reset_colors;
  local_dir=${HOME}
else
  $white; printf "Directory specified    : "; $bold;
  $blue; printf '%s'"${1}"; $red;printf " will be the working target dir ...\n";
  $white; $reset_colors;
  local_dir=${HOME}/$1
fi
# Global variables
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
__project_account=$1
__remote_hostname=$2
__user_remote_home_dir=$3
__external_lib_dir=$4
# Overall config file
source ./common_main.sh "$__external_lib_dir";
#-------------------------------------------------------------------------------
# Overriding the machine name due to remote creation prior to deployment
#-------------------------------------------------------------------------------
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
__machine_name="${machine_name}"
case ${__remote_hostname} in
  *"10.44.5.20"*)               __machine_name="Precision-3571" ;;
  *"tursa.dirac.ed.ac.uk"*)     __machine_name="tursa"          ;;
  *"login.vega.izum.si"*)       __machine_name="vega"           ;;
  *"sunbird.swansea.ac.uk"*)    __machine_name="sunbird"        ;;
  *"lumi.csc.fi"*)              __machine_name="lumi"           ;;
  *"login.leonardo.cineca.it"*) __machine_name="leonardo"       ;;
  *"aac6.amd.com"*)             __machine_name="mi300"          ;;
  *"aac1.amd.com"*)             __machine_name="mi210"          ;;
  *"alogin1.bsc.es"*)           __machine_name="MareNostrum"    ;;
  *"glogin1.bsc.es"*)           __machine_name="MareNostrum"    ;;
esac
# System config file to get information from the node
source ./config_system.sh "$__project_account" "$__machine_name";
#-------------------------------------------------------------------------------
# Overriding the __module_list due to remote creation prior to deployment
#-------------------------------------------------------------------------------
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
__module_list="#no modules on UNKNOWN machine maybe Saturn!; module list;"
case $__machine_name in
  *"Precision-3571"*)
    $white; printf "Laptop no module load  : no module load\n"; $bold
    # grid_dir is already set above but setting to new value here for laptop
    #grid_dir=${sourcecode_dir}/JetBrainGateway/Grid-Main/Grid;
    __qos="${qos}";
    __module_list="#---> no modules on Precision-3571;module list;"
    ;;
  *"DESKTOP-GPI5ERK"*)
    __qos="${qos}";
    __module_list="#---> no modules on ${__machine_name}; module list;"
    ;;
  *"desktop-dpr4gpr"*)
    __qos="${qos}";
    __module_list="#---> no modules on ${__machine_name}; module list;"
    ;;
  *"tursa"*)
    __qos="${qos}";
    __module_list="cuda/12.3 openmpi/4.1.5-cuda12.3 ucx/1.15.0-cuda12.3 gcc/9.3.0; module list;"
    ;;
  *"sunbird"*)
    __qos="${qos}";
   __module_list="CUDA/11.7 compiler/gnu/11/3.0 mpi/openmpi/1.10.6; module list;"
    ;;
  *"vega"*)
    __qos="${qos}";
    __module_list="CUDA/12.1.1 GCC/11.3.0 UCX/1.12.1-GCCcore-11.3.0 OpenMPI/4.1.4-GCC-11.3.0 Python/3.10.4-GCCcore-11.3.0 FFTW/3.3.10-GCC-11.3.0 OpenSSL/3; module list;"
    ;;
  *"lumi"*)
    __qos="${qos}"; # Coming from config_system.sh call
    __module_list="cray-mpich cray-fftw cray-hdf5-parallel cray-python gcc/12.2.0; module list;"
    ;;
  *"leonardo"*)
    __qos="${qos}";
    __module_list="cuda/12.2 nvhpc/23.11 fftw/3.3.10--openmpi--4.1.6--gcc--12.2.0 hdf5; module list;"
    ;;
  *"mi300"*)
    __qos="${qos}";
    __module_list="rocm amdclang hdf5 fftw openmpi; module list;"
    ;;
  *"mi210"*)
    __qos="${qos}";
    __module_list="rocm amdclang hdf5 fftw openmpi; module list;"
    ;;
  *"MareNostrum"*)
    __qos="${qos_cpu}";
    #__qos="gp_ehpc"
    __module_list="gcc/12.3.0 openmpi/4.1.5-gcc; module list;"
    ;;
esac
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
# System config file to get information from the node
source ./config_system.sh "$__project_account" "$__machine_name";
# The Batch content creators methods
source ./Scripts/Batch_Scripts/Batch_util_methods.sh;
#-------------------------------------------------------------------------------
# The codes to be compressed
#-------------------------------------------------------------------------------
llr_codes="${Hirep_LLR_SP_dir}"
llr_input="${LLR_HiRep_heatbath_input_dir}"
_some_dir="${some_dir}"
#-------------------------------------------------------------------------------
# Now compressing the codes
#-------------------------------------------------------------------------------
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
for i in $(seq 0 $sleep_time)
do
  $green;ProgressBar "${i}" "${sleep_time}"; sleep 1;
done
printf "\n"

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Moving to LatticeRuns  : "; $bold;
$magenta; printf "${LatticeRuns_dir}\n"; $white; $reset_colors;
#cd "${LatticeRuns_dir}"
#ls -al

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Checking directories   :\n"; $white; $reset_colors;

directory_exists "${llr_codes}"; dir_Hirep_LLR_SP_exists="$directory_exists";
directory_exists "${llr_input}"; dir_LLR_HiRep_heatbath_input_exists="$directory_exists";
directory_exists "${_some_dir}"; dir_some_other_directory_exists=$directory_exists;

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
if [ "$dir_Hirep_LLR_SP_exists" == "yes" ]
then
  $cyan; printf "Directory content      : "; $yellow; printf "%s\n" "${llr_codes}";$white; $reset_colors;
  pwd
  ls "$llr_codes"
  #cd "$llr_codes"
  pwd
  #git pull
  source ${GitHub_Token_File_dir}/${GitHub_Token_File}
  Git_Clone_project_with_GitHub_Token "${sourcecode_dir}"       \
                                      "${Hirep_LLR_SP_git_url}" \
                                      "${__GitHub_Token}"       \
                                      "$Hirep_LLR_SP";

  pwd
  #cd ..
elif [ "$dir_Hirep_LLR_SP_exists" == "no" ]
then
  $cyan; printf "Cloning the project    : "; $yellow; printf "%s\n" "${Hirep_LLR_SP_git_url}";
  $white; $reset_colors;
  $cyan; printf "Try to retrieve from   : "; $yellow; printf "%s\n" "${llr_codes}";$white; $reset_colors;

  echo "__GitHub_Token      -->: ${__GitHub_Token}"
  echo "GitHub Hirep_LLR_SP -->: ${Hirep_LLR_SP_git_url}"

  #git clone "https://${__GitHub_Token}@${Hirep_LLR_SP_git_url}" "${sourcecode_dir}"
  source ${GitHub_Token_File_dir}/${GitHub_Token_File}
  Git_Clone_project_with_GitHub_Token "${sourcecode_dir}"       \
                                      "${Hirep_LLR_SP_git_url}" \
                                      "${__GitHub_Token}"       \
                                      "$Hirep_LLR_SP";
  pwd
fi

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
if [ "$dir_LLR_HiRep_heatbath_input_exists" == "yes" ]
then
  $cyan; printf "Directory content      : "; $yellow; printf "%s\n" "${llr_input}";$white; $reset_colors;
  ls "$llr_input"
  $cyan; printf "     Updating project->: "; $yellow; printf "%s\n" "${llr_input}";$white; $reset_colors;
  cd "$llr_input"
  git pull
  cd ..
elif [ "$dir_LLR_HiRep_heatbath_input_exists" == "no" ];
then
  $cyan; printf "Cloning the project    : "; $yellow; printf "%s\n" "${LLR_HiRep_heatbath_input_git_url}";
  $white; $reset_colors;
  Git_Clone_project_to_TargetDir "${sourcecode_dir}"                   \
                                 "${LLR_HiRep_heatbath_input_git_url}" \
                                 "${LLR_HiRep_heatbath_input}"
fi

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Checking input file    :\n"; $white; $reset_colors;
file_exists "${llr_input}/input/${machine_name}.csv"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Generating LLR-Rep     :\n"; $white; $reset_colors;
# TODO drive the code from here.
# TODO:
#  python3 main.py
#       --input_params_csv MareNostrum.csv
#       --machine MareNostrum
#       --partition gp
#       --account ehpc191
#       --modules "gcc/12.3.0 openmpi/4.1.5-gcc"
#       --run_index 1
#       --path_llr_exec "\${HOME}/SwanSea/SourceCodes/Hirep_LLR_SP/LLR_HB"
#       --output_run_dir "${HOME}/SwanSea/SourceCodes/Hirep_LLR_SP/LLR_HB"
# TODO: cd output/Run001_LLR_04x020_056
# TODO: bash -s < ./setup_llr_repeat.sh
#-------------------------------------------------------------------------------
$green; $bold;
echo "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
$red  ; printf "Path construction      : ";
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$reset_colors;
$white; printf "#----------------------- ";printf "\n"; $reset_colors;
$white; printf " Variables list          ";printf "\n"; $reset_colors;
$white; printf "#----------------------- ";printf "\n"; $reset_colors;
$white; printf "llr_input              : ";$magenta; printf "%s\n" "${llr_input}";              $reset_colors;
$white; printf "machine name           : ";$red;     printf "%s\n" "${__machine_name}";         $reset_colors;
$white; printf "input_params_csv       : ";$magenta; printf "%s\n" "${llr_input}/input/${__machine_name}.csv";
$white; printf "module list            : ";$green;   printf "%s\n" "${__module_list}";          $reset_colors;
$white; printf "Partition              : ";$cyan;    printf "%s\n" "${target_partition_cpu}";   $reset_colors;
path_llr_exec="\${HOME}/${SwanSea_SourceCodes}/${Hirep_LLR_SP}/LLR_HB"
path_to_run_dir="${LatticeRuns_dir}/${Hirep_LLR_SP}/LLR_HB"
case $__machine_name in
  *"Precision-3571"*)  ;;
  *"DESKTOP-GPI5ERK"*) ;;
  *"desktop-dpr4gpr"*) ;;
  *"tursa"*)           ;;
  *"sunbird"*)         ;;
  *"vega"*)            ;; #path_to_run_dir="${cluster_data_disk}/LatticeRuns/${Hirep_LLR_SP}/LLR_HB" ;;
  *"lumi"*)            ;;
  *"leonardo"*)        ;;
  *"mi300"*)           ;;
  *"mi210"*)           ;;
  *"MareNostrum"*)     ;; #path_to_run_dir="${cluster_data_disk}/LatticeRuns/${Hirep_LLR_SP}/LLR_HB" ;;
esac
run_index=1
$white; printf "qos                    : ";$cyan;    printf "%s\n" "${__qos}";                  $reset_colors;
$white; printf "account                : ";$cyan;    printf "%s\n" "${__project_account}";      $reset_colors;
$white; printf "run_index              : ";$cyan;    printf "%i\n" "$run_index";                $reset_colors;
$white; printf "path_llr_exec          : ";$cyan;    printf "%s\n" "$path_llr_exec";            $reset_colors;
$white; printf "output_run_dir         : ";$cyan;    printf "%s\n" "${path_to_run_dir}";        $reset_colors;
$white; printf "#----------------------- ";printf "\n"; $reset_colors;
$white; printf "LatticeRuns_dir        : ";$yellow;  printf "%s\n" "${LatticeRuns_dir}";        $reset_colors;
$white; printf "user_remote_home_dir   : ";$cyan;    printf "%s\n" "${__user_remote_home_dir}"; $reset_colors;
$white; printf "#----------------------- ";printf "\n"; $reset_colors;
$cyan;  printf "<-- Shell          --->: ";$cyan;    printf "%s\n" "$0";                        $reset_colors;
$white; printf "#----------------------- ";printf "\n"; $reset_colors;
#-------------------------------------------------------------------------------
#: '
if [ "$dir_LLR_HiRep_heatbath_input_exists" == "yes" ]
then
  case $__machine_name in
    *"Precision-3571"*)
      python3 \
        "${llr_input}"/main.py \
        --machine "${__machine_name}" \
        --input_params_csv "${llr_input}/input/${__machine_name}.csv" \
        --modules "${__module_list}" \
        --partition "${target_partition_cpu}" \
        --qos "${__qos}" \
        --account "${__project_account}" \
        --run_index "$run_index" \
        --path_llr_exec "${path_llr_exec}" \
        --output_run_dir "${path_to_run_dir}"
      ;;
    *"DESKTOP-GPI5ERK"*)
      ;;
    *"desktop-dpr4gpr"*)
      ;;
    *"tursa"*)
      python3 \
        "${llr_input}"/main.py \
        --machine "${__machine_name}" \
        --input_params_csv "${llr_input}/input/${__machine_name}.csv" \
        --modules "${__module_list}" \
        --partition "${target_partition_cpu}" \
        --qos "${__qos}" \
        --account "${__project_account}" \
        --run_index "$run_index" \
        --path_llr_exec "${path_llr_exec}" \
        --output_run_dir "${path_to_run_dir}"
      ;;
    *"sunbird"*)
      ;;
    *"vega"*)
      python3 \
        "${llr_input}"/main.py \
        --machine "${__machine_name}" \
        --input_params_csv "${llr_input}/input/${__machine_name}.csv" \
        --modules "${__module_list}" \
        --partition "${target_partition_cpu}" \
        --run_index "$run_index" \
        --path_llr_exec "${path_llr_exec}" \
        --output_run_dir "${path_to_run_dir}"
      ;;
    *"lumi"*)
      python3 \
        "${llr_input}"/main.py \
        --machine "${__machine_name}" \
        --input_params_csv "${llr_input}/input/${__machine_name}.csv" \
        --modules "${__module_list}" \
        --partition "${target_partition_cpu}" \
        --account "${__project_account}" \
        --run_index "$run_index" \
        --path_llr_exec "${path_llr_exec}" \
        --output_run_dir "${path_to_run_dir}"
      ;;
    *"leonardo"*)
      python3 \
        "${llr_input}"/main.py \
        --machine "${__machine_name}" \
        --input_params_csv "${llr_input}/input/${__machine_name}.csv" \
        --modules "${__module_list}" \
        --partition "${target_partition_cpu}" \
        --account "${__project_account}" \
        --run_index "$run_index" \
        --path_llr_exec "${path_llr_exec}" \
        --output_run_dir "${path_to_run_dir}"
      ;;
    *"mi300"*)
      ;;
    *"mi210"*)
      ;;
    *"MareNostrum"*)
      python3 \
        "${llr_input}"/main.py \
        --machine "${__machine_name}" \
        --input_params_csv "${llr_input}/input/${__machine_name}.csv" \
        --modules "${__module_list}" \
        --partition "${target_partition_cpu}" \
        --qos "${__qos}" \
        --account "${__project_account}" \
        --run_index "$run_index" \
        --path_llr_exec "${path_llr_exec}" \
        --output_run_dir "${path_to_run_dir}"
      ;;
  esac
fi
#'
#  --output_run_dir "${HOME}/EuroHPC/MareNostrum/SwanSea/SourceCodes/LatticeRuns/Hirep_LLR_SP/LLR_HB"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  creator_bench_LLR_DataStructure.sh Done.             -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$white; $reset_colors;
#exit
#-------------------------------------------------------------------------------
