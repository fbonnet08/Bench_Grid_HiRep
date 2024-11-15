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

source ../../common_main.sh $__dir;

#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
batch_file_out="samplefile.sh"

ntask=1
nodes=2
ntasks_per_node=3
cpus_per_task=1
partition="cpu"
job_name=$__job_name
time="5:0:0"
qos="standard"

#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
Batch_header (){
_nodes=$1
_ntask=$2
_ntasks_per_node=$3
_cpus_per_task=$4
_partition=$5
_job_name=$6
_time=$7
_qos=$8
echo "#!/bin/bash"
echo "#SBATCH --nodes=$_nodes"
echo "#SBATCH --ntasks=$_ntask"
echo "#SBATCH --ntasks-per-node=$_ntasks_per_node"
echo "#SBATCH --cpus-per-task=$_cpus_per_task"
echo "#SBATCH --partition=$_partition"
echo "#SBATCH --job-name=$_job_name"
echo "#SBATCH --time=$_time"
echo "#SBATCH --qos=$_qos"
echo "#-------------------------------------------------------------------------------"
echo "# Getting the common code setup and variables"
echo "#-------------------------------------------------------------------------------"

echo "# hello this is the rest of the code ...."
}
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

echo "# ---> this works ----<"
echo "TODO: insert the main of each case of the machines"
echo "ls -al ${prefix}"

END
