#!/usr/bin/bash
#colors
red="tput setaf 1"  ;green="tput setaf 2"  ;yellow="tput setaf 3"
blue="tput setaf 4" ;magenta="tput setaf 5";cyan="tput setaf 6"
white="tput setaf 7";bold=""               ;reset_colors="tput sgr0"
# Global variables
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
SwanSea_SourceCodes="SwanSea/SourceCodes"
sourcecode_dir=${HOME}/${SwanSea_SourceCodes}
LatticeRuns_dir=${sourcecode_dir}/LatticeRuns

# LLR directory and github structure
Hirep_LLR_SP="Hirep_LLR_SP"
LLR_HiRep_heatbath_input="LLR_HiRep_heatbath_input"
LLR_HiRep_heatbath_input_dir=${sourcecode_dir}/${LLR_HiRep_heatbath_input}

llr_input="${LLR_HiRep_heatbath_input_dir}"

path_llr_exec="\${HOME}/${SwanSea_SourceCodes}/${Hirep_LLR_SP}/LLR_HB}"
path_to_run_dir="${LatticeRuns_dir}/${Hirep_LLR_SP}/LLR_HB"
#-------------------------------------------------------------------------------
# [Vega]
#-------------------------------------------------------------------------------
__machine_name="vega"
__partition="cpu"
__qos="normal"
__account_name="not_required"
__module_list="CUDA/12.1.1 GCC/11.3.0 UCX/1.12.1-GCCcore-11.3.0 OpenMPI/4.1.4-GCC-11.3.0 Python/3.10.4-GCCcore-11.3.0 FFTW/3.3.10-GCC-11.3.0 OpenSSL/3; module list;"
#-------------------------------------------------------------------------------
# [MareNostrum]
#-------------------------------------------------------------------------------
#__machine_name="MareNostrum"
#__partition="gp"
#__qos="gp_ehpc"
#__account_name="ehpc191"
#__module_list="gcc/12.3.0 openmpi/4.1.5-gcc; module list;"
#-------------------------------------------------------------------------------
# [Runner]
#-------------------------------------------------------------------------------
$white; printf "output_run_dir         : ";$cyan; printf "%s\n" "${path_to_run_dir}";
$reset_colors;

  case $__machine_name in
    *"Precision-3571"*)
      ;;
    *"DESKTOP-GPI5ERK"*)
      ;;
    *"desktop-dpr4gpr"*)
      ;;
    *"tursa"*)
      ;;
    *"sunbird"*)
      ;;
    *"vega"*)
      python3 \
        "${llr_input}"/main.py \
        --input_params_csv "${llr_input}/input/${__machine_name}.csv" \
        --machine "${__machine_name}" \
        --partition "${__partition}" \
        --modules "${__module_list}" \
        --run_index 1 \
        --path_llr_exec "${path_llr_exec}" \
        --output_run_dir "${path_to_run_dir}"
      ;;
    *"lumi"*)
      ;;
    *"leonardo"*)
      ;;
    *"mi300"*)
      ;;
    *"mi210"*)
      ;;
    *"MareNostrum"*)
      python3 \
        "${llr_input}"/main.py \
        --input_params_csv "${llr_input}/input/${__machine_name}.csv" \
        --machine "${__machine_name}" \
        --partition "${__partition}" \
        --qos "${__qos}" \
        --account  "${__account_name}" \
        --modules "${__module_list}" \
        --run_index 1 \
        --path_llr_exec "${path_llr_exec}" \
        --output_run_dir "${path_to_run_dir}"
      ;;
  esac

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  run_LLR_HiRep_heatbath_input_mainPy.sh Done.         -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$white; $reset_colors;
#exit
#-------------------------------------------------------------------------------
