#!/bin/bash
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
}
