#!/bin/bash
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
Batch_util_create_path (){
_path_to_run=$1
#-------------------------------------------------------------------------------
if [ -d ${_path_to_run} ]
  then
    $white; printf "Directory              : "; $bold;
    $blue; printf '%s'"${_path_to_run}"; $green; printf " exist, nothing to do.\n"; $white; $reset_colors;
  else
    $white; printf "Directory              : "; $bold;
    $blue; printf '%s'"${_path_to_run}"; $red;printf " does not exist, We will create it ...\n";
    $white; $reset_colors;
    mkdir -p ${_path_to_run}
    printf "                       : "; $bold;
    $green; printf "done.\n"; $reset_colors;
fi

}