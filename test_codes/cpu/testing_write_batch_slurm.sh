#!/usr/bin/bash
ARGV=`basename -a $1 $2`
set -eu
#-------------------------------------------------------------------------------
# Example on how to run the code
#-------------------------------------------------------------------------------
echo "!     [example]: bash -s < ./testing_write_batch_slurm.sh SwanSea/SourceCodes/external_lib sombrero_weak    !"
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
scrfipt_file_name=$(basename "$0")
echo $scrfipt_file_name
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
__dir=$1
__job_name=$2
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
batch_file_out="samplefile.sh"

nodes=2
ntask=1
ntasks_per_node=3
cpus_per_task=1
partition="cpu"
job_name=$__job_name
time="5:0:0"
qos="standard"
#-------------------------------------------------------------------------------
# Getting the common code setup and variables,
# setting up the environment properly.
#-------------------------------------------------------------------------------
source ../../common_main.sh $__dir;
source ../../Scripts/Batch_Scripts/Batch_header_methods.sh
source ../../Scripts/Batch_Scripts/Batch_body_methods.sh
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
echo "Writing the header file..."

cat << END > $batch_file_out
$(Batch_header ${nodes} ${ntask} ${ntasks_per_node} ${cpus_per_task} ${partition} ${job_name} ${time} ${qos})

$(
case $job_name in
  *"BKeeper"*)
  echo "# ---> this is a BKeeper job run"
  ;;
  *"sombrero_weak"*)
  echo "# ---> this is a Sombrero_weak job run"
  ;;
  *"sombrero_strong"*)
  echo "# ---> this is a Sombrero_strong job run"
  ;;
esac
)

# shellcheck disable=SC2154
echo "$module_list"

echo "# ---> this works ----<"
echo "TODO: insert the main of each case of the machines"
echo "ls -al ${prefix}"

$(Batch_body_Run_BKeeper ${machine_name} ${bkeeper_dir} ${batch_file_out})


END
