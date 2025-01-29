#!/bin/bash
ARGV=`basename -a $1`
#-------------------------------------------------------------------------------
# Mapping the inpout to variables for purpose
#-------------------------------------------------------------------------------
__machine_name=$1
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
  elif command -v nvidia-smi 2>&1 >/dev/null
  then
    echo "nvidia-smi could be found"
    _gpu_count=$(nvidia-smi |grep NVIDIA|wc -l)
    _gpu_count=$(expr $_gpu_count - 1)
  else
    echo "nvidia-smi or lspci command not found"
  fi
}
get_system_config_clusters_nvidia (){
  # CPU stuff
  _core_count=$(grep -c ^processor /proc/cpuinfo)
  _mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  # GPU stuff
  _gpu_count=0
  _max_gpu_count=4  # Max number of GPUs on a Leonardo node
  if command -v lspci 2>&1 >/dev/null
  then
    echo "lspci could be found"
    #_gpu_count=$(lspci |grep NVIDIA|grep "\["|wc -l)
    # TODO: MUST CORRECT ACCOUNT_NAME --account= DETAILS FOR EACH MACHINE HERE NOW ONLY LEONARDO
    _gpu_count=$(srun --account=EUHPC_B17_015 --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" lspci | grep NVIDIA|grep "\["|wc -l)

    $white; printf "lspci                  : "; $bold;
    $white; printf "srun cmd --> _gpu_count : "; $bold;
    $magenta; printf "${_gpu_count}\n"; $reset_colors;


  elif command -v nvidia-smi 2>&1 >/dev/null
  then
    echo "lspci could not be found let's try nvidia-smi"
    #_gpu_count=$(nvidia-smi |grep NVIDIA|wc -l)
    # TODO: MUST CORRECT ACCOUNT_NAME DETAILS FOR EACH MACHINE HERE NOW ONLY LEONARDO
    _gpu_count=$(srun --account=EUHPC_B17_015 --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" nvidia-smi |grep NVIDIA|wc -l)
    _gpu_count=$(expr $_gpu_count - 1)

    $white; printf "nvidia-smi             : "; $bold;
    $white; printf "srun cmd --> _gpu_count : "; $bold;
    $magenta; printf "${_gpu_count}\n"; $reset_colors;


  else
    echo "nvidia-smi or lspci command not found"
  fi
}
get_system_config_clusters_amd (){
  # CPU stuff
  _core_count=$(grep -c ^processor /proc/cpuinfo)
  _mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  # GPU stuff we already know that there is 8 max gpu on Lumi but we can check this way:
  _max_gpu_count=8  # Max number of GPUs on a Lumi node
    # TODO: MUST CORRECT ACCOUNT_NAME --account= DETAILS FOR EACH MACHINE HERE NOW ONLY LUMI
  _gpu_count=$(srun --account=project_465001614 --partition=dev-g --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" rocm-smi --showtopo |grep "GPU\["|wc -l | awk '{print $1}');
  _gpu_count=$(echo "$_gpu_count/2"|bc);
  $white; printf "rocm-smi               : "; $bold;
  $white; printf "srun cmd --> _gpu_count : "; $bold;
  $magenta; printf "${_gpu_count}\n"; $reset_colors;
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
  *"vega"*)            get_system_config_clusters_nvidia; ;;
  *"lumi"*)            get_system_config_clusters_amd; ;;
  *"leonardo"*)        get_system_config_clusters_nvidia; ;;
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

