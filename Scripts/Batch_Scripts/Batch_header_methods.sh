#!/bin/bash
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
Batch_header (){
  _accelerator=$1
  _project_account=$2
  _gpus_per_node=$3
  _accelerator=$4
  _simulation_size=$5
  _machine_name=$6
  _nodes=$7
  _ntask=$8
  _ntasks_per_node=$9
  _cpus_per_task=${10}
  _partition=${11}
  _job_name=${12}
  _time=${13}
  _qos=${14}
#-------------------------------------------------------------------------------
# Some default methods for initialisation.
#-------------------------------------------------------------------------------
echo "#!/bin/bash"
echo "#SBATCH --job-name=$_job_name"
echo "#SBATCH --output=%x.%j.out"
echo "#SBATCH --error=%x.%j.err"
echo "#SBATCH --time=$_time"
echo "#SBATCH --partition=$_partition"
echo "#SBATCH --nodes=$_nodes"
echo "#SBATCH --ntasks-per-node=$_ntasks_per_node    # nodes * ntasks"
if [[ $_accelerator = "cpu" ]];
then
    echo "## CPU only";
elif [[ $_accelerator = "gpu" ]];
then
    echo "## GPU only";
    echo "#SBATCH --gpus-per-node=$_gpus_per_node"
else
  echo "##accelerator type not specified, we will default onto CPU only"
  echo "#SBATCH --cpus-per-task=$_cpus_per_task"
fi

if [[ $_machine_name != "vega" ]];
then echo "#SBATCH --account=$_project_account"; fi

# additional commands required on the following systems
if [[ $_machine_name = "tursa" ]];
then
  echo "#SBATCH --cpus-per-task=$_cpus_per_task"
  echo "#SBATCH --gres=gpu:4"
  echo "#SBATCH --qos=$_qos"
elif [[ $_machine_name = "leonardo" || $_machine_name = "vega" ]];
then
  echo "#SBATCH --cpus-per-task=$_cpus_per_task"
  echo "#SBATCH --gres=gpu:4"
fi
# TODO: continue from here to include the logic of different systems
# TODO: fix the --ntasks-per-node=128 error and --cpus-per-task=1
# TODO: for --ntasks-per-node remove unnecessary loop
#echo "#SBATCH --ntasks=$_ntask"
echo "#-------------------------------------------------------------------------------"
echo "# Getting the common code setup and variables: "
echo "#---> Accelerator type (cpu/gpu)             : $_accelerator"
echo "#---> Simulation size in consideration       : $_simulation_size"
echo "#---> Machine name that we are working on is : $_machine_name"
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

