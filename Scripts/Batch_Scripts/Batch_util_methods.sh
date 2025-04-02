#!/bin/bash
#-------------------------------------------------------------------------------
# Method to launch batch jobs from a given target file
#-------------------------------------------------------------------------------
Batch_submit_target_file_list_to_queue (){
_target_file=$1
_max_number_submitted_batch_scripts=$2 #variable passed but not used maybe later
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Check if target file exists first
#-------------------------------------------------------------------------------
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Check if target file exists first:\n"; $white; $reset_colors;
file_exists "${_target_file}"
#-------------------------------------------------------------------------------
# Launching batch scripts from the Screening directory
#-------------------------------------------------------------------------------
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Launching batch scripts from the Screening directory:\n";
$white; $reset_colors;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; printf "Maximum number of submitted batch scripts: "; $bold;
$magenta; printf "${_max_number_submitted_batch_scripts}\n"; $white; $reset_colors;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; printf "Reading in target file: "; $bold;
$yellow; printf "${_target_file}\n"; $white; $reset_colors;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo ""

declare -a target_batch_file_array=()
N=0
while read line
do
    file_exists "${line}"

    target_batch_file_array+=($(echo "$line"));

    N=$(expr $N + 1)
done < "$_target_file"

$cyan; printf "Read in from target   : "; $bold;
$yellow; printf "${N}"; $cyan; printf " batch scripts to be submitted.\n"; $white; $reset_colors;

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Now looping through the target batch file array:\n";
$white; $reset_colors;

H=1
for i in $(seq 0 `expr ${#target_batch_file_array[@]} - 1`)
do
  index_i=$(printf "%04d" "$i")
  index_H=$(printf "%04d" "$H")
  $cyan; printf "#------>: i #------>: "; $green;   printf "${index_i} ";
  $cyan; printf "#------>: H #------>: "; $magenta; printf "${index_H} ";
  $cyan; printf "#------>: File #--->: "; $red;     printf "${target_batch_file_array[i]}";
  $cyan; printf "\n"; $white; $reset_colors;

  file_exists "${target_batch_file_array[i]}"

  if [ "$file_exists" = 'yes' ]
  then
    printf "                       : "; $bold;
    $white; printf "YES ---> sbatch submitting to the queue....\n"; $reset_colors;
    # Submitting the batch script to the slurm queue.
    sbatch "${target_batch_file_array[i]}" >> "${LatticeRuns_dir}"/"Batch_submission.log" &
  elif [ "$file_exists" = 'no' ]
  then
    printf "                       : "; $bold;
    $white; printf "NO  ---> sbatch NO GO.\n"; $reset_colors;
  fi;

  H=$(expr $H + 1)
done
}
#-------------------------------------------------------------------------------
# Method to create an arbitrary directory
#-------------------------------------------------------------------------------
Batch_util_create_path (){
_path_to_run=$1
#-------------------------------------------------------------------------------
if [ -d "${_path_to_run}" ]
  then
    $white; printf "Directory              : "; $bold;
    $blue; printf '%s'"${_path_to_run}"; $green; printf " exist, nothing to do.\n";
    $white; $reset_colors;
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
# Method to check if file exists
#-------------------------------------------------------------------------------
file_exists (){
_input_filename=$1
#-------------------------------------------------------------------------------
file_exists="no"
if [ -f "${_input_filename}" ]
  then
    $white; printf "File                   : "; $bold;
    $yellow; printf '%s'"${_input_filename}"; $green; printf " --->: exist.\n";
    $white; $reset_colors;
    file_exists="yes"
    printf "      file_exists ---->: "; $bold;
    $green; printf "$file_exists.\n"; $reset_colors;
  else
    $white; printf "File                   : "; $bold;
    $yellow; printf '%s'"${_input_filename}"; $red;printf " --->: does not exist.\n";
    $white; $reset_colors;
    file_exists="no"
    printf "      file_exists ---->: "; $bold;
    $red; printf "$file_exists.\n"; $reset_colors;
fi
}
#-------------------------------------------------------------------------------
# Method to check if file exists
#-------------------------------------------------------------------------------
directory_exists (){
_input_directory=$1
#-------------------------------------------------------------------------------
directory_exists="no"
if [ -d "${_input_directory}" ]
  then
    $white; printf "Directory              : "; $bold;
    $yellow; printf '%s'"${_input_directory}"; $green; printf " --->: exist.\n";
    $white; $reset_colors;
    directory_exists="yes"
    printf " directory_exists ---->: "; $bold;
    $green; printf "$directory_exists.\n"; $reset_colors;
  else
    $white; printf "Directory              : "; $bold;
    $yellow; printf '%s'"${_input_directory}"; $red;printf " --->: does not exist.\n";
    $white; $reset_colors;
    directory_exists="no"
    printf " directory_exists ---->: "; $bold;
    $red; printf "$directory_exists.\n"; $reset_colors;
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
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  Batch_util_methods.sh Done.                          -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$reset_colors
#exit
#-------------------------------------------------------------------------------
