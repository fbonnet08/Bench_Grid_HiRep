#!/bin/bash
#-------------------------------------------------------------------------------
# Getting the common code setup and variables,
# setting up the environment properly.
#-------------------------------------------------------------------------------
config_Batch_with_input_from_system_config (){
# function block with external input variables
_nodes=$1
_ntask=$2
_ntasks_per_node=$3
_cpus_per_task=$4
_partition=$5
_job_name=$6
_time=$7
_qos=$8
}
#-------------------------------------------------------------------------------
# Some default methods for initialisation.
#-------------------------------------------------------------------------------
config_Batch_Grid_DWF_Telos_run_gpu (){
_nodes=2
_ntask=128
_ntasks_per_node=128
_cpus_per_task=1
_partition="gpu"
_job_name="run_Grid_DWF_gpu"
_time="15:0:0"
_qos="standard"
}
config_Batch_Grid_DWF_run_gpu (){
_nodes=2
_ntask=128
_ntasks_per_node=128
_cpus_per_task=1
_partition="gpu"
_job_name="run_Grid_DWF_gpu"
_time="15:0:0"
_qos="standard"
}
config_Batch_default (){
_nodes=2
_ntask=128
_ntasks_per_node=128
_cpus_per_task=1
_partition="cpu"
_job_name="run_Sonbrero_strong"
_time="15:0:0"
_qos="standard"
}
config_Batch_Sombrero_weak_cpu (){
_nodes=1
_ntask=128
_ntasks_per_node=128
_cpus_per_task=1
_partition="cpu"
_job_name="run_Sombrero_weak"
_time="0:0:20"
_qos="standard"
}
config_Batch_Sombrero_strong_cpu (){
_nodes=2
_ntask=128
_ntasks_per_node=256
_cpus_per_task=1
_partition="cpu"
_job_name="run_Sombrero_strong"
_time="0:0:20"
_qos="standard"
}
config_Batch_BKeeper_compile_cpu (){
_nodes=2
_ntask=128
_ntasks_per_node=128
_cpus_per_task=1
_partition="cpu"
_job_name="compile_BKeeper"
_time="15:0:0"
_qos="standard"
}
config_Batch_BKeeper_run_cpu (){
_nodes=2
_ntask=128
_ntasks_per_node=128
_cpus_per_task=1
_partition="cpu"
_job_name="run_BKeeper_cpu"
_time="15:0:0"
_qos="standard"
}
config_Batch_BKeeper_run_gpu (){
_nodes=2
_ntask=128
_ntasks_per_node=128
_cpus_per_task=1
_partition="gpu"
_job_name="run_BKeeper_gpu"
_time="15:0:0"
_qos="standard"
}
config_Batch_HiRep-LLR-master_cpu (){
_nodes=2
_ntask=128
_ntasks_per_node=256
_cpus_per_task=1
_partition="cpu"
_job_name="run_HiRep-LLR-master_cpu"
_time="0:0:20"
_qos="standard"
}
config_Batch_HiRep-LLR-master_gpu (){
_nodes=2
_ntask=128
_ntasks_per_node=4
_cpus_per_task=8
_gres="gpu:4"
_partition="gpu"
_job_name="run_HiRep-LLR-master_gpu"
_time="48:00:00"
_qos="standard"
}
#-------------------------------------------------------------------------------
#End of the script
echo
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$cyan; echo `date`; $blue;
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "-                  config_batch_action.sh Done.                         -"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$reset_colors
#exit
#-------------------------------------------------------------------------------

