#!/bin/bash
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
Batch_header (){
  _accelerator=$1
  _simulation_size=$2
  _machine_name=$3
  _nodes=$4
  _ntask=$5
  _ntasks_per_node=$6
  _cpus_per_task=$7
  _partition=$8
  _job_name=$9
  _time=${10}
  _qos=${11}
echo "#!/bin/bash"
echo "#---> Accelerator type (cpu/gpu)            : $_accelerator"
echo "#---> Simulation size in consideration      : $_simulation_size"
echo "#---> Machine name that we are working on is: $_machine_name"
echo "#SBATCH --job-name=$_job_name"
echo "#SBATCH --output=%x.%j_$_job_name.out"
echo "#SBATCH --error=%x.%j_$_job_name.err"
echo "#SBATCH --time=$_time"
echo "#SBATCH --partition=$_partition"
echo "#SBATCH --nodes=$_nodes"
echo "#SBATCH --ntasks-per-node=$_ntasks_per_node    # nodes * ntasks"



#echo "#SBATCH --ntasks=$_ntask"
echo "#SBATCH --cpus-per-task=$_cpus_per_task"
echo "#SBATCH --qos=$_qos"
echo "#-------------------------------------------------------------------------------"
echo "# Getting the common code setup and variables"
echo "#-------------------------------------------------------------------------------"
}

#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  Batch_header_methods.sh Done.                        -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$reset_colors
#exit
#-------------------------------------------------------------------------------

#The underlining sampling algorithm

#LLR class to define

#- routine to call the different replicas
#- Algorithm that update the sysrtg within the energy interval
#- updates within the energy intervals can be PHB, --> shapr boundary
#                                             HMC -- > define a gaussian 2 parameters
#
#                                             ---> aim to compouyt e eepctted energy
#- Conf update
#- LLR HMC controller instantiated from the the LLR class
#- Try to understand the

