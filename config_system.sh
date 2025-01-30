#!/bin/bash
ARGV=`basename -a $1 $2`
#-------------------------------------------------------------------------------
# Mapping the inpout to variables for purpose
#-------------------------------------------------------------------------------
__project_account=$1
__machine_name=$2

#if [[ -v "$_username" ]];        then echo "Enter Username         : $_username"; fi
if [[ -v "$__project_account" ]]; then echo "Project Account  (sys) : $__project_account"; fi
if [[ -v "$__machine_name" ]];    then echo "Machine name (cfg_sys) : $__machine_name"; fi
#if [[ -v "$_remote_hostname" ]]; then echo "Remote hostname        : $_remote_hostname"; fi

#-------------------------------------------------------------------------------
# Getting the common code setup and variables,
# setting up the environment properly.
#-------------------------------------------------------------------------------
get_system_config_local_nvidia (){
  # CPU stuff
  _core_count=$(grep -c ^processor /proc/cpuinfo)
  _mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  # GPU stuff
  _gpu_count=0
  if command -v lspci 2>&1 >/dev/null
  then
    echo "lspci could be found"
    _gpu_count=$(lspci |grep NVIDIA|grep "\["|wc -l)
    $white; printf "lspci                  : "; $bold;
    $cyan; printf "system cmd --> _gpu_count : "; $bold;
    $yellow; printf "${_gpu_count}\n"; $reset_colors;
  elif command -v nvidia-smi 2>&1 >/dev/null
  then
    echo "nvidia-smi could be found"
    _gpu_count=$(nvidia-smi |grep NVIDIA|wc -l)
    _gpu_count=$(expr $_gpu_count - 1)
    $white; printf "nvidia-smi             : "; $bold;
    $cyan; printf "system cmd --> _gpu_count : "; $bold;
    $yellow; printf "${_gpu_count}\n"; $reset_colors;
  else
    echo "nvidia-smi or lspci command not found"
  fi
}

get_system_config_clusters_nvidia_Vega-GPU (){
  # TODO: MUST CORRECT ACCOUNT_NAME --account= DETAILS FOR EACH MACHINE HERE NOW ONLY LEONARDO
  # Default node setup
  _max_gpu_count=4  # Max number of GPUs on a Leonardo node
  # CPU stuff
  #_core_count=$(grep -c ^processor /proc/cpuinfo)
  _core_count=$(srun --partition=gpu --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep -c ^processor /proc/cpuinfo)
  $white; printf "From /proc/cpuinfo     : "; $bold;
  $cyan; printf "Node srun cmd --> _core_count : "; $bold;
  $yellow; printf "${_core_count}\n"; $reset_colors;
  #_mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  _mem_total=$(srun --partition=gpu --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep MemTotal /proc/meminfo | awk '{print $2}')
  $white; printf "From /proc/meminfo     : "; $bold;
  $cyan; printf "Node srun cmd --> _mem_total : "; $bold;
  $yellow; printf "${_mem_total}\n"; $reset_colors;
  # GPU stuff
  _gpu_count=0
  if command -v lspci 2>&1 >/dev/null
  then
    echo "lspci could be found"
    #_gpu_count=$(lspci |grep NVIDIA|grep "\["|wc -l)
    _gpu_count=$(srun --partition=gpu --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" lspci | grep NVIDIA|grep "\["|wc -l)

    $white; printf "lspci                  : "; $bold;
    $cyan; printf "Node srun cmd --> _gpu_count : "; $bold;
    $yellow; printf "${_gpu_count}\n"; $reset_colors;

  elif command -v nvidia-smi 2>&1 >/dev/null
  then
    echo "lspci could not be found let's try nvidia-smi"
    #_gpu_count=$(nvidia-smi |grep NVIDIA|wc -l)
    # TODO: MUST CORRECT ACCOUNT_NAME DETAILS FOR EACH MACHINE HERE NOW ONLY LEONARDO
    _gpu_count=$(srun --partition=gpu --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" nvidia-smi |grep NVIDIA|wc -l)
    _gpu_count=$(expr $_gpu_count - 1)

    $white; printf "nvidia-smi             : "; $bold;
    $cyan; printf "Node srun cmd --> _gpu_count : "; $bold;
    $yellow; printf "${_gpu_count}\n"; $reset_colors;

  else
    echo "nvidia-smi or lspci command not found"
  fi
}

get_system_config_clusters_nvidia_Leonardo-Booster (){
  # TODO: MUST CORRECT ACCOUNT_NAME --account= DETAILS FOR EACH MACHINE HERE NOW ONLY LEONARDO
  # Default node setup
  _max_gpu_count=4  # Max number of GPUs on a Leonardo node
  # CPU stuff
  #_core_count=$(grep -c ^processor /proc/cpuinfo)
  _core_count=$(srun --account="$__project_account" --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep -c ^processor /proc/cpuinfo)
  $white; printf "From /proc/cpuinfo     : "; $bold;
  $cyan; printf "Node srun cmd --> _core_count : "; $bold;
  $yellow; printf "${_core_count}\n"; $reset_colors;
  #_mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  _mem_total=$(srun --account="$__project_account" --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep MemTotal /proc/meminfo | awk '{print $2}')
  $white; printf "From /proc/meminfo     : "; $bold;
  $cyan; printf "Node srun cmd --> _mem_total : "; $bold;
  $yellow; printf "${_mem_total}\n"; $reset_colors;
  # GPU stuff
  _gpu_count=0
  if command -v lspci 2>&1 >/dev/null
  then
    echo "lspci could be found"
    #_gpu_count=$(lspci |grep NVIDIA|grep "\["|wc -l)
    _gpu_count=$(srun --account="$__project_account" --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" lspci | grep NVIDIA|grep "\["|wc -l)

    $white; printf "lspci                  : "; $bold;
    $cyan; printf "Node srun cmd --> _gpu_count : "; $bold;
    $yellow; printf "${_gpu_count}\n"; $reset_colors;

  elif command -v nvidia-smi 2>&1 >/dev/null
  then
    echo "lspci could not be found let's try nvidia-smi"
    #_gpu_count=$(nvidia-smi |grep NVIDIA|wc -l)
    # TODO: MUST CORRECT ACCOUNT_NAME DETAILS FOR EACH MACHINE HERE NOW ONLY LEONARDO
    _gpu_count=$(srun --account="$__project_account" --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" nvidia-smi |grep NVIDIA|wc -l)
    _gpu_count=$(expr $_gpu_count - 1)

    $white; printf "nvidia-smi             : "; $bold;
    $cyan; printf "Node srun cmd --> _gpu_count : "; $bold;
    $yellow; printf "${_gpu_count}\n"; $reset_colors;

  else
    echo "nvidia-smi or lspci command not found"
  fi
}

get_system_config_clusters_AMD_LUMI-G (){
    # TODO: MUST CORRECT ACCOUNT_NAME --account= DETAILS FOR EACH MACHINE HERE NOW ONLY LUMI
  _max_gpu_count=8  # Max number of GPUs on a Lumi node
  # CPU stuff
  #_core_count=$(grep -c ^processor /proc/cpuinfo)
  _core_count=$(srun --account="$__project_account" --partition=dev-g --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep -c ^processor /proc/cpuinfo)
  $white; printf "From /proc/cpuinfo     : "; $bold;
  $cyan; printf "Node srun cmd --> _core_count : "; $bold;
  $yellow; printf "${_core_count}\n"; $reset_colors;
  #_mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  _mem_total=$(srun --account="$__project_account" --partition=dev-g --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep MemTotal /proc/meminfo | awk '{print $2}')
  $white; printf "From /proc/meminfo     : "; $bold;
  $cyan; printf "Node srun cmd --> _mem_total : "; $bold;
  $yellow; printf "${_mem_total}\n"; $reset_colors;
  # GPU stuff we already know that there is 8 max gpu on Lumi but we can check this way:
  _gpu_count=$(srun --account="$__project_account" --partition=dev-g --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" rocm-smi --showtopo |grep "GPU\["|wc -l | awk '{print $1}');
  _gpu_count=$(echo "$_gpu_count/2"|bc);
  $white; printf "rocm-smi               : "; $bold;
  $cyan; printf "srun cmd --> _gpu_count : "; $bold;
  $yellow; printf "${_gpu_count}\n"; $reset_colors;
  #_gpu_count=$(echo "${_max_gpu_count}/2"|bc);
  #echo "$_gpu_count"
}
#-------------------------------------------------------------------------------
# Instantiating the configuration method for system
#-------------------------------------------------------------------------------
case $machine_name in
  *"Precision-3571"*)  get_system_config_local_nvidia; ;;
  *"DESKTOP-GPI5ERK"*) get_system_config_local_nvidia; ;;
  *"desktop-dpr4gpr"*) get_system_config_local_nvidia; ;;
  *"tursa"*)           get_system_config_clusters_nvidia; ;;
  *"sunbird"*)         get_system_config_clusters_nvidia; ;;
  *"vega"*)            get_system_config_clusters_nvidia_Vega-GPU; ;;
  *"lumi"*)            get_system_config_clusters_AMD_LUMI-G; ;;
  *"leonardo"*)        get_system_config_clusters_nvidia_Leonardo-Booster; ;;
esac
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  config_system.sh Done.                               -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$reset_colors
#exit
#-------------------------------------------------------------------------------

