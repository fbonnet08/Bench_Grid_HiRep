#!/bin/bash
#-------------------------------------------------------------------------------
# Getting the common code setup and variables,
# setting up the environment properly.
#-------------------------------------------------------------------------------
get_system_config (){
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
#-------------------------------------------------------------------------------
# Instantiating the configuration method for system
#-------------------------------------------------------------------------------
get_system_config;
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

