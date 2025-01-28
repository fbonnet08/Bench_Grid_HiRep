#!/bin/bash
#-------------------------------------------------------------------------------
# Method to creat an arbitrary directory
#-------------------------------------------------------------------------------
Batch_util_create_path (){
_path_to_run=$1
#-------------------------------------------------------------------------------
if [ -d "${_path_to_run}" ]
  then
    $white; printf "Directory              : "; $bold;
    $blue; printf '%s'"${_path_to_run}"; $green; printf " exist, nothing to do.\n"; $white; $reset_colors;
  else
    $white; printf "Directory              : "; $bold;
    $blue; printf '%s'"${_path_to_run}"; $red;printf " does not exist, We will create it ...\n";
    $white; $reset_colors;
    mkdir -p "${_path_to_run}"
    printf "                       : "; $bold;
    $green; printf "done.\n"; $reset_colors;
fi
}
#-------------------------------------------------------------------------------
# Cloning method from a given repository
#-------------------------------------------------------------------------------
Git_Clone_project (){
_src_fldr=$1
_repo=$2
#-------------------------------------------------------------------------------
if [ -d "$_src_fldr" ]
then
  $white; printf "Project                : "; $bold;
  $magenta; printf '%s'"$_src_fldr"; $green; printf " exist, we will update it with a pull.\n";
  $white; $reset_colors;

  cd "$grid_dir"
  git pull
  cd ..
else
  $white; printf "Project                : "; $bold;
  $magenta; printf '%s'"$_src_fldr"; $red; printf " does not exist, we will clone from GitHub.\n";
  $white; $reset_colors;
  # Creating src_fldr method located in ./Scripts/Batch_Scripts/Batch_util_methods.sh
  Batch_util_create_path "${_src_fldr}"
  cd "$_src_fldr"
  git clone "$_repo"
fi
}
#-------------------------------------------------------------------------------
# Cloning BKeeper into ~/Swansea/SourceCodes directory...
#-------------------------------------------------------------------------------
Git_Clone_project_BKeeper (){
_src_fldr=$1
_repo=$2
#-------------------------------------------------------------------------------
  cd "$_src_fldr"
  $white; printf "Cloning                : "; $bold;
  $magenta; printf '%s'"$_repo"; $red; printf " from GitHub into ---> "; $yellow; printf "${_src_fldr}\n";
  $white; $reset_colors;
  # Creating src_fldr method located in ./Scripts/Batch_Scripts/Batch_util_methods.sh
  git clone "$_repo"
}
#-------------------------------------------------------------------------------
# Insert next method here ...
#-------------------------------------------------------------------------------
