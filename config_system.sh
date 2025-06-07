#!/bin/bash
ARGV=`basename -a $1 $2`
#-------------------------------------------------------------------------------
# Mapping the inpout to variables for purpose
#-------------------------------------------------------------------------------
__project_account=$1
__machine_name=$2

case $__machine_name in
  *"Precision-3571"*)
    target_partition_gpu="Precision-3571-local"; target_partition_cpu="Precision-3571-local";
    gpus_per_node=1;                             qos="normal";
    max_cores_per_node_gpu=16;                   max_cores_per_node_cpu=16;
    ;;
  *"DESKTOP-GPI5ERK"*)
    target_partition_gpu="DESKTOP-GPI5ERK";      target_partition_cpu="DESKTOP-GPI5ERK";
    gpus_per_node=1;                             qos="normal";
    max_cores_per_node_gpu=8;                    max_cores_per_node_cpu=8;
    ;;
  *"desktop-dpr4gpr"*)
    target_partition_gpu="desktop-dpr4gpr";      target_partition_cpu="desktop-dpr4gpr";
    gpus_per_node=1;                             qos="normal";
    max_cores_per_node_gpu=22;                   max_cores_per_node_cpu=22;
    ;;
  *"tursa"*)
    target_partition_gpu="gpu";                  target_partition_cpu="cpu";
    gpus_per_node=4;                             qos="standard";
    max_cores_per_node_gpu=128;                  max_cores_per_node_cpu=256;
    ;;
  *"sunbird"*)
    target_partition_gpu="accel_ai";             target_partition_cpu="cpu";
    gpus_per_node=4;                             qos="normal";
    max_cores_per_node_gpu=128;                  max_cores_per_node_cpu=256;
    ;;
  *"vega"*)
    target_partition_gpu="gpu";                  target_partition_cpu="cpu";
    gpus_per_node=4;                             qos="normal";
    max_cores_per_node_gpu=128;                  max_cores_per_node_cpu=256;
    cluster_data_disk="/ceph/hpc/data/b2025b03-046-users"
    ;;
  *"lumi"*)
    target_partition_gpu="standard-g";           target_partition_cpu="standard";
    gpus_per_node=8;                             qos="normal";
    max_cores_per_node_gpu=128;                  max_cores_per_node_cpu=256;
    cluster_data_disk="/scratch/${__project_account}";
    ;;
  *"leonardo"*)
    target_partition_gpu="boost_usr_prod";       target_partition_cpu="dcgp_usr_prod";
    gpus_per_node=4;                             qos="normal";
    max_cores_per_node_gpu=128;                  max_cores_per_node_cpu=112;
    cluster_data_disk="/leonardo_work/${__project_account}"; # ${WORK}=/leonardo_work/EUHPC_B22_046
    ;;
  *"mi300"*)
    target_partition_gpu="LocalQ";               target_partition_cpu="LocalQ";
    gpus_per_node=4;                             qos="normal";
    max_cores_per_node_gpu=192;                  max_cores_per_node_cpu=192;
    ;;
  *"mi210"*)
    target_partition_gpu="LocalQ";               target_partition_cpu="LocalQ";
    gpus_per_node=4;                             qos="normal";
    max_cores_per_node_gpu=192;                  max_cores_per_node_cpu=192;
    ;;
  *"MareNostrum"*)
    target_partition_gpu="acc";                  target_partition_cpu="gp";
    qos_gpu="acc_ehpc";                          qos_cpu="gp_ehpc";
    qos="acc_ehpc";
    gpus_per_node=4;
    max_cores_per_node_gpu=80;                   max_cores_per_node_cpu=112;
    cluster_data_disk="/gpfs/projects/${__project_account}";
    ;;
esac

#if [[ -v "$_username" ]];        then echo "Enter Username         : $_username"; fi
#if [[ -v "$_remote_hostname" ]]; then echo "Remote hostname        : $_remote_hostname"; fi
if [[ -v "$__project_account" ]];    then echo "Project Account  (sys) : $__project_account"; fi
if [[ -v "$__machine_name" ]];       then echo "Machine name (cfg_sys) : $__machine_name"; fi
if [[ -v "$target_partition_gpu" ]]; then echo "Target partition (GPU) : $target_partition_gpu"; fi
if [[ -v "$target_partition_cpu" ]]; then echo "Target partition (CPU) : $target_partition_cpu"; fi
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

get_system_config_clusters_nvidia_Sunbird (){
  # Default node setup
  _max_gpu_count=4  # Max number of GPUs
  # CPU stuff
  _core_count=$(grep -c ^processor /proc/cpuinfo)
  _core_count=$(echo "$_core_count/4"|bc);
  #_core_count=$(srun --account="$__project_account" --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep -c ^processor /proc/cpuinfo)
  $white; printf "From /proc/cpuinfo     : "; $bold;
  $cyan; printf "Node srun cmd --> _core_count : "; $bold;
  $yellow; printf "${_core_count}\n"; $reset_colors;
  _mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  _mem_total=$(echo "$_mem_total*1"|bc);
  #_mem_total=$(srun --account="$__project_account" --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep MemTotal /proc/meminfo | awk '{print $2}')
  $white; printf "From /proc/meminfo     : "; $bold;
  $cyan; printf "Node srun cmd --> _mem_total : "; $bold;
  $yellow; printf "${_mem_total}\n"; $reset_colors;
  # GPU stuff
  _gpu_count=${_max_gpu_count}
  if command -v lspci 2>&1 >/dev/null
  then
    echo "lspci could be found"
    _gpu_count=$(lspci |grep NVIDIA|grep "\["|wc -l)
    #_gpu_count=$(srun --account="$__project_account" --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" lspci | grep NVIDIA|grep "\["|wc -l)
    if [[ $_gpu_count -eq 0 ]]; then _gpu_count=${_max_gpu_count}; fi;
    $white; printf "lspci                  : "; $bold;
    $cyan; printf "Node srun cmd --> _gpu_count : "; $bold;
    $yellow; printf "${_gpu_count}\n"; $reset_colors;
  elif command -v nvidia-smi 2>&1 >/dev/null
  then
    echo "lspci could not be found let's try nvidia-smi"
    #_gpu_count=$(nvidia-smi |grep NVIDIA|wc -l)
    #_gpu_count=$(srun --account="$__project_account" --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" nvidia-smi |grep NVIDIA|wc -l)
    #_gpu_count=$(expr $_gpu_count - 1)
    $white; printf "nvidia-smi             : "; $bold;
    $cyan; printf "Node srun cmd --> _gpu_count : "; $bold;
    _gpu_count=0
    $yellow; printf "${_gpu_count}\n"; $reset_colors;
  else
    echo "nvidia-smi or lspci command not found"
  fi
}

get_system_config_clusters_nvidia_Tursa (){
  # Default node setup
  _max_gpu_count=4  # Max number of GPUs
  # CPU stuff
  _core_count=$(grep -c ^processor /proc/cpuinfo)
  _core_count=$(echo "$_core_count/4"|bc);
  #_core_count=$(srun --account="$__project_account" --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep -c ^processor /proc/cpuinfo)
  $white; printf "From /proc/cpuinfo     : "; $bold;
  $cyan; printf "Node srun cmd --> _core_count : "; $bold;
  $yellow; printf "${_core_count}\n"; $reset_colors;
  _mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  _mem_total=$(echo "$_mem_total*1"|bc);
  #_mem_total=$(srun --account="$__project_account" --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep MemTotal /proc/meminfo | awk '{print $2}')
  $white; printf "From /proc/meminfo     : "; $bold;
  $cyan; printf "Node srun cmd --> _mem_total : "; $bold;
  $yellow; printf "${_mem_total}\n"; $reset_colors;
  # GPU stuff
  _gpu_count=${_max_gpu_count}
  if command -v lspci 2>&1 >/dev/null
  then
    echo "lspci could be found"
    _gpu_count=$(lspci |grep NVIDIA|grep "\["|wc -l)
    #_gpu_count=$(srun --account="$__project_account" --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" lspci | grep NVIDIA|grep "\["|wc -l)
    if [[ $_gpu_count -eq 0 ]]; then _gpu_count=${_max_gpu_count}; fi;
    $white; printf "lspci                  : "; $bold;
    $cyan; printf "Node srun cmd --> _gpu_count : "; $bold;
    $yellow; printf "${_gpu_count}\n"; $reset_colors;
  elif command -v nvidia-smi 2>&1 >/dev/null
  then
    echo "lspci could not be found let's try nvidia-smi"
    #_gpu_count=$(nvidia-smi |grep NVIDIA|wc -l)
    #_gpu_count=$(srun --account="$__project_account" --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" nvidia-smi |grep NVIDIA|wc -l)
    #_gpu_count=$(expr $_gpu_count - 1)
    $white; printf "nvidia-smi             : "; $bold;
    $cyan; printf "Node srun cmd --> _gpu_count : "; $bold;
    _gpu_count=0
    $yellow; printf "${_gpu_count}\n"; $reset_colors;
  else
    echo "nvidia-smi or lspci command not found"
  fi
}

get_system_config_clusters_nvidia_Vega-GPU (){
  # Default node setup
  _max_gpu_count=4  # Max number of GPUs
  # CPU stuff
  _core_count=$(grep -c ^processor /proc/cpuinfo)
  _core_count=$(echo "$_core_count*2"|bc);
  #_core_count=$(srun --partition=gpu --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep -c ^processor /proc/cpuinfo)
  #_core_count=$(echo "$_core_count" | sed 's/^ *//; s/ *$//')
  $white; printf "From /proc/cpuinfo     : "; $bold;
  $cyan; printf "Node srun cmd --> _core_count : "; $bold;
  $yellow; printf "${_core_count}\n"; $reset_colors;
  _mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  _mem_total=$(echo "$_mem_total*2"|bc);
  #_mem_total=$(srun --partition=gpu --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep MemTotal /proc/meminfo | awk '{print $2}')
  $white; printf "From /proc/meminfo     : "; $bold;
  $cyan; printf "Node srun cmd --> _mem_total : "; $bold;
  $yellow; printf "${_mem_total}\n"; $reset_colors;
  # GPU stuff
  _gpu_count=${_max_gpu_count}
  if command -v lspci 2>&1 >/dev/null
  then
    echo "lspci could be found"
    _gpu_count=$(lspci |grep NVIDIA|grep "\["|wc -l)
    #_gpu_count=$(srun --partition=gpu --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" lspci | grep NVIDIA|grep "\["|wc -l)
    if [[ $_gpu_count -eq 0 ]]; then _gpu_count=${_max_gpu_count}; fi;
    $white; printf "lspci                  : "; $bold;
    $cyan; printf "Node srun cmd --> _gpu_count : "; $bold;
    $yellow; printf "${_gpu_count}\n"; $reset_colors;
  elif command -v nvidia-smi 2>&1 >/dev/null
  then
    echo "lspci could not be found let's try nvidia-smi"
    #_gpu_count=$(nvidia-smi |grep NVIDIA|wc -l)
    #_gpu_count=$(srun --partition=gpu --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" nvidia-smi |grep NVIDIA|wc -l)
    #_gpu_count=$(expr $_gpu_count - 1)
    _gpu_count=0
    $white; printf "nvidia-smi             : "; $bold;
    $cyan; printf "Node srun cmd --> _gpu_count : "; $bold;
    $yellow; printf "${_gpu_count}\n"; $reset_colors;
  else
    echo "nvidia-smi or lspci command not found"
  fi
}

get_system_config_clusters_nvidia_MareNostrum (){
  # Default node setup
  _max_gpu_count=4  # Max number of GPUs
  # CPU stuff
  _core_count=$(grep -c ^processor /proc/cpuinfo)
  _core_count=$(echo "$_core_count/4"|bc);
  #_core_count=$(srun --account="$__project_account" --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep -c ^processor /proc/cpuinfo)
  $white; printf "From /proc/cpuinfo     : "; $bold;
  $cyan; printf "Node srun cmd --> _core_count : "; $bold;
  $yellow; printf "${_core_count}\n"; $reset_colors;
  _mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  _mem_total=$(echo "$_mem_total*1"|bc);
  #_mem_total=$(srun --account="$__project_account" --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep MemTotal /proc/meminfo | awk '{print $2}')
  $white; printf "From /proc/meminfo     : "; $bold;
  $cyan; printf "Node srun cmd --> _mem_total : "; $bold;
  $yellow; printf "${_mem_total}\n"; $reset_colors;
  # GPU stuff
  _gpu_count=${_max_gpu_count}
  if command -v lspci 2>&1 >/dev/null
  then
    echo "lspci could be found"
    _gpu_count=$(lspci |grep NVIDIA|grep "\["|wc -l)
    #_gpu_count=$(srun --account="$__project_account" --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" lspci | grep NVIDIA|grep "\["|wc -l)
    if [[ $_gpu_count -eq 0 ]]; then _gpu_count=${_max_gpu_count}; fi;
    $white; printf "lspci                  : "; $bold;
    $cyan; printf "Node srun cmd --> _gpu_count : "; $bold;
    $yellow; printf "${_gpu_count}\n"; $reset_colors;
  elif command -v nvidia-smi 2>&1 >/dev/null
  then
    echo "lspci could not be found let's try nvidia-smi"
    #_gpu_count=$(nvidia-smi |grep NVIDIA|wc -l)
    #_gpu_count=$(srun --account="$__project_account" --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" nvidia-smi |grep NVIDIA|wc -l)
    #_gpu_count=$(expr $_gpu_count - 1)
    $white; printf "nvidia-smi             : "; $bold;
    $cyan; printf "Node srun cmd --> _gpu_count : "; $bold;
    _gpu_count=0
    $yellow; printf "${_gpu_count}\n"; $reset_colors;
  else
    echo "nvidia-smi or lspci command not found"
  fi
}


get_system_config_clusters_nvidia_Leonardo-Booster (){
  # Default node setup
  _max_gpu_count=4  # Max number of GPUs on a Leonardo node
  # CPU stuff
  _core_count=$(grep -c ^processor /proc/cpuinfo)
  _core_count=$(echo "$_core_count/4"|bc);
  #_core_count=$(srun --account="$__project_account" --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep -c ^processor /proc/cpuinfo)
  $white; printf "From /proc/cpuinfo     : "; $bold;
  $cyan; printf "Node srun cmd --> _core_count : "; $bold;
  $yellow; printf "${_core_count}\n"; $reset_colors;
  _mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  _mem_total=$(echo "$_mem_total*1"|bc);
  #_mem_total=$(srun --account="$__project_account" --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep MemTotal /proc/meminfo | awk '{print $2}')
  $white; printf "From /proc/meminfo     : "; $bold;
  $cyan; printf "Node srun cmd --> _mem_total : "; $bold;
  $yellow; printf "${_mem_total}\n"; $reset_colors;
  # GPU stuff
  _gpu_count=${_max_gpu_count}
  if command -v lspci 2>&1 >/dev/null
  then
    echo "lspci could be found"
    _gpu_count=$(lspci |grep NVIDIA|grep "\["|wc -l)
    #_gpu_count=$(srun --account="$__project_account" --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" lspci | grep NVIDIA|grep "\["|wc -l)
    if [[ $_gpu_count -eq 0 ]]; then _gpu_count=${_max_gpu_count}; fi;
    $white; printf "lspci                  : "; $bold;
    $cyan; printf "Node srun cmd --> _gpu_count : "; $bold;
    $yellow; printf "${_gpu_count}\n"; $reset_colors;
  elif command -v nvidia-smi 2>&1 >/dev/null
  then
    echo "lspci could not be found let's try nvidia-smi"
    #_gpu_count=$(nvidia-smi |grep NVIDIA|wc -l)
    #_gpu_count=$(srun --account="$__project_account" --partition=boost_usr_prod --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" nvidia-smi |grep NVIDIA|wc -l)
    #_gpu_count=$(expr $_gpu_count - 1)
    $white; printf "nvidia-smi             : "; $bold;
    $cyan; printf "Node srun cmd --> _gpu_count : "; $bold;
    _gpu_count=0
    $yellow; printf "${_gpu_count}\n"; $reset_colors;
  else
    echo "nvidia-smi or lspci command not found"
  fi
}

get_system_config_clusters_AMD_LUMI-G (){
  _max_gpu_count=8  # Max number of GPUs on a Lumi node
  # CPU stuff
  _core_count=$(grep -c ^processor /proc/cpuinfo)
  _core_count=$(echo "$_core_count/2"|bc);
  #_core_count=$(srun --account="$__project_account" --partition="dev-g" --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep -c ^processor /proc/cpuinfo)
  $white; printf "From /proc/cpuinfo     : "; $bold;
  $cyan; printf "Node srun cmd --> _core_count : "; $bold;
  $yellow; printf "${_core_count}\n"; $reset_colors;
  _mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  _mem_total=$(echo "$_mem_total*2"|bc);
  #_mem_total=$(srun --account="$__project_account" --partition="dev-g" --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep MemTotal /proc/meminfo | awk '{print $2}')
  $white; printf "From /proc/meminfo     : "; $bold;
  $cyan; printf "Node srun cmd --> _mem_total : "; $bold;
  $yellow; printf "${_mem_total}\n"; $reset_colors;
  # GPU stuff we already know that there is 8 max gpu on Lumi but we can check this way:
  _gpu_count=${_max_gpu_count}
  #_gpu_count=$(srun --account="$__project_account" --partition="dev-g" --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" rocm-smi --showtopo |grep "GPU\["|wc -l | awk '{print $1}');
  #_gpu_count=$(echo "$_gpu_count/2"|bc);
  $white; printf "rocm-smi               : "; $bold;
  $cyan; printf "srun cmd --> _gpu_count : "; $bold;
  $yellow; printf "${_gpu_count}\n"; $reset_colors;
  #_gpu_count=$(echo "${_max_gpu_count}/2"|bc);
  #echo "$_gpu_count"
}

get_system_config_clusters_AMD_Mi300 (){
  _max_gpu_count=4  # Max number of GPUs on a Lumi node
  # CPU stuff
  _core_count=$(grep -c ^processor /proc/cpuinfo)
  _core_count=$(echo "$_core_count/2"|bc);
  #_core_count=$(srun --account="$__project_account" --partition="dev-g" --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep -c ^processor /proc/cpuinfo)
  $white; printf "From /proc/cpuinfo     : "; $bold;
  $cyan; printf "Node srun cmd --> _core_count : "; $bold;
  $yellow; printf "${_core_count}\n"; $reset_colors;
  _mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  _mem_total=$(echo "$_mem_total*2"|bc);
  #_mem_total=$(srun --account="$__project_account" --partition="dev-g" --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep MemTotal /proc/meminfo | awk '{print $2}')
  $white; printf "From /proc/meminfo     : "; $bold;
  $cyan; printf "Node srun cmd --> _mem_total : "; $bold;
  $yellow; printf "${_mem_total}\n"; $reset_colors;
  # GPU stuff we already know that there is 8 max gpu on Lumi but we can check this way:
  _gpu_count=${_max_gpu_count}
  #_gpu_count=$(srun --account="$__project_account" --partition="dev-g" --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" rocm-smi --showtopo |grep "GPU\["|wc -l | awk '{print $1}');
  #_gpu_count=$(echo "$_gpu_count/2"|bc);
  $white; printf "rocm-smi               : "; $bold;
  $cyan; printf "srun cmd --> _gpu_count : "; $bold;
  $yellow; printf "${_gpu_count}\n"; $reset_colors;
  #_gpu_count=$(echo "${_max_gpu_count}/2"|bc);
  #echo "$_gpu_count"
}
get_system_config_clusters_AMD_Mi210 (){
  _max_gpu_count=4  # Max number of GPUs on a Lumi node
  # CPU stuff
  _core_count=$(grep -c ^processor /proc/cpuinfo)
  _core_count=$(echo "$_core_count/2"|bc);
  #_core_count=$(srun --account="$__project_account" --partition="dev-g" --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep -c ^processor /proc/cpuinfo)
  $white; printf "From /proc/cpuinfo     : "; $bold;
  $cyan; printf "Node srun cmd --> _core_count : "; $bold;
  $yellow; printf "${_core_count}\n"; $reset_colors;
  _mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  _mem_total=$(echo "$_mem_total*2"|bc);
  #_mem_total=$(srun --account="$__project_account" --partition="dev-g" --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep MemTotal /proc/meminfo | awk '{print $2}')
  $white; printf "From /proc/meminfo     : "; $bold;
  $cyan; printf "Node srun cmd --> _mem_total : "; $bold;
  $yellow; printf "${_mem_total}\n"; $reset_colors;
  # GPU stuff we already know that there is 8 max gpu on Lumi but we can check this way:
  _gpu_count=${_max_gpu_count}
  #_gpu_count=$(srun --account="$__project_account" --partition="dev-g" --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" rocm-smi --showtopo |grep "GPU\["|wc -l | awk '{print $1}');
  #_gpu_count=$(echo "$_gpu_count/2"|bc);
  $white; printf "rocm-smi               : "; $bold;
  $cyan; printf "srun cmd --> _gpu_count : "; $bold;
  $yellow; printf "${_gpu_count}\n"; $reset_colors;
  #_gpu_count=$(echo "${_max_gpu_count}/2"|bc);
  #echo "$_gpu_count"
}
#-------------------------------------------------------------------------------
# Instantiating the configuration method for system
# Right now there is code repetition for the different systems, may be fixed later
# if needed.
#-------------------------------------------------------------------------------
case $machine_name in
  *"Precision-3571"*)  get_system_config_local_nvidia; ;;
  *"DESKTOP-GPI5ERK"*) get_system_config_local_nvidia; ;;
  *"desktop-dpr4gpr"*) get_system_config_local_nvidia; ;;
  *"sunbird"*)         get_system_config_clusters_nvidia_Sunbird; ;;
  *"tursa"*)           get_system_config_clusters_nvidia_Tursa; ;;
  *"vega"*)            get_system_config_clusters_nvidia_Vega-GPU; ;;
  *"lumi"*)            get_system_config_clusters_AMD_LUMI-G; ;;
  *"leonardo"*)        get_system_config_clusters_nvidia_Leonardo-Booster; ;;
  *"mi300"*)           get_system_config_clusters_AMD_Mi300; ;;
  *"mi210"*)           get_system_config_clusters_AMD_Mi210; ;;
  *"MareNostrum"*)     get_system_config_clusters_nvidia_MareNostrum; ;;
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

