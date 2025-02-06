

echo "$(hostname)  --->: $lrank device=$CUDA_VISIBLE_DEVICES binding=$BINDING"


          #__path_to_run=$(printf "${LatticeRuns_dir}/${__batch_file_construct}")
          #fi
          #for l in $(seq 0 `expr ${#bkeeper_mpi_clock_gpu[@]} - 1`)
          #do

          #mpi_distr=$(printf "mpi%s" "${bkeeper_mpi_clock_gpu[$l]}"| sed -E 's/([0-9]+)/0\1/g' | sed 's/\./\-/g')
          # Orchestrating the file construction
          #__batch_file_construct=$(printf "Run_${__batch_action}_${lattice}_${n_nodes}_${__simulation_size}")
          #__batch_file_construct=$(printf "Run_${__batch_action}_${lattice}_${n_nodes}_${ntpn}_${__mpi_distr_FileTag}_${__simulation_size}")


        echo ""
        echo "nodes_x_gpus_per_node --->: $nodes_x_gpus_per_node"
        echo "gpus_per_node         --->: $gpus_per_node"
        echo "ntasks_per_node       --->: $ntasks_per_node"



# TODO: REMOVE NEXT LINES ......
# TODO: REMOVE NEXT LINES ......
# TODO: REMOVE NEXT LINES ......
# TODO: REMOVE NEXT LINES ......
# TODO: REMOVE NEXT LINES ......
cat << EOF >> "$_batch_file_out"
# TODO: REMOVE NEXT LINES ......
# TODO: REMOVE NEXT LINES ......
#-------------------------------------------------------------------------------
# Previous command for mpirun launch.
#-------------------------------------------------------------------------------
: '
mpirun \$bkeeper_build_dir/BKeeper \\
        --grid $_lattice_size_cpu \\
        --mpi $_mpi_distribution \\
        --accelerator-threads 8 \\
        \$benchmark_input_dir/BKeeper/input_BKeeper.xml \\
        > \$path_to_run/bkeeper_run_gpu.log &


21650  spack env activate cuda12-gcc13
21654  spack add gcc@13.3.0
21656  spack add ucx@1.15.0+cma+cuda+dc+dm+gdrcopy+mlx5_dv+rc+rdmacm+ud+verbs+xpmem cuda_arch=80
21657  spack add openmpi@5.0.2+cuda fabrics=ucx schedulers=slurm
21659  spack add cuda@12.6.3
21660  spack add gdrcopy@2.3
21661  spack concretize
21662  spack install

'
EOF




#-------------------------------------------------------------------------------
# Job description
#-------------------------------------------------------------------------------
cat << EOF >> "$_batch_file_out"
#-------------------------------------------------------------------------------
# Output variable.
#-------------------------------------------------------------------------------
LatticeRuns_dir=$_LatticeRuns_dir
path_to_run=$_path_to_run
job_name=$_batch_file_construct
#-------------------------------------------------------------------------------
# Checking if run directory exists, if not create it.
#-------------------------------------------------------------------------------
if [ -d \${path_to_run} ]
then
  printf "Directory              : ";
  printf '%s'"\${path_to_run}"; printf " exist, nothing to do.\n";
else
  printf "Directory              : ";
  printf '%s'"\${path_to_run}";printf " doesn't exist, will create it...\n";
  mkdir -p \${path_to_run}
  printf "                       : "; printf "done.\n";
fi
#-------------------------------------------------------------------------------
# Move to the directory where to run and linking to the BKeeper directory
#-------------------------------------------------------------------------------
cd \${path_to_run}
EOF



    module_list="module load cray-mpich/8.1.29 gcc/12.2.0; module list;"



      Batch_body_Run_BKeeper_gpu                                                        \
      "${machine_name}" "${bkeeper_dir}" "${LatticeRuns_dir}" "${benchmark_input_dir}"  \
      "${__path_to_run}${sptr}${__batch_file_out}"                                      \
      "${bkeeper_lattice_size_cpu[$j]}"                                                 \
      "${bkeeper_mpi_clock_gpu[$l]}"                                                    \
      "${__simulation_size}" "${__batch_file_construct}" "${prefix}" "${__path_to_run}" \
      "${module_list}" "${sourcecode_dir}"



mpirun \$bkeeper_build_dir/BKeeper \\
        --grid $_lattice_size_cpu \\
        --mpi $_mpi_distribution \\
        --accelerator-threads 8 \\
        \$benchmark_input_dir/BKeeper/input_BKeeper.xml \\
        > \$path_to_run/bkeeper_run_gpu.log &

declare -a path_to_data_dir=("$sourcecode_dir" "$sombrero_dir")

#!/bin/bash
ARGV=`basename -a $1 $2`
# Get N as the upper limit from user input or set a default value
mpi_max=$1
echo "mpi_max          --->: $mpi_max"
nodes=$2
echo "nodes            --->: $nodes"

# Generate an array of even numbers (multiples of 2) up to N
numbers=($(seq 2 2 "$mpi_max"))
echo "numbers          --->: $numbers"

# Get the length of the array
len=${#numbers[@]}
echo "len              --->: $len"


# Generate all unique 4-number combinations
for ((i = 1; i <= mpi_max; i++)); do
  for ((j = 1; j <= mpi_max; j++)); do
    for ((k = 1; k <= mpi_max; k++)); do
      for ((l = 1; l <= mpi_max; l++)); do
        # Calculate the product of the four numbers
        #product=$((numbers[i] * numbers[j] * numbers[k] * numbers[l]))
        product=$((i * j * k * l))
        #echo "product          --->: $product"
        # Check if the product is ≤ N
        if ((product == nodes)); then
          #echo "${numbers[i]}.${numbers[j]}.${numbers[k]}.${numbers[l]}"
          echo "${i}.${j}.${k}.${l}"
        fi
      done
    done
  done
done

# shellcheck disable=SC1091,SC2050,SC2170

## This set of slurm settings assumes that the AMD chips are using bios setting NPS4 (4 mpi taks per socket).

#SBATCH --no-requeue
#SBATCH --no-requeue

##SBATCH --mem=494000

## shellcheck disable=SC1091,SC2050,SC2170
### This set of slurm settings assumes that the AMD chips are using bios setting NPS4 (4 mpi taks per socket).
###SBATCH --qos=standard


#source /home/y07/shared/grid/env/production/env-base.sh
#source /home/y07/shared/grid/env/production/env-gpu.sh


#-------------------------------------------------------------------------------
# Path structure
#-------------------------------------------------------------------------------
prefix=${sourcecode_dir}/external_lib/prefix_grid_202410

  if (( _core_count )); then
      echo "_core_count behaves like an integer."
  else
      echo "_core_count is not a valid integer."
  fi


  _core_count=$(srun --partition=gpu --time=00:30:00 --nodes=1 --gres=gpu:"${_max_gpu_count}" grep -c ^processor /proc/cpuinfo)

  sleep 10

  #_core_count=$(( _core_count + 0 ))
  _core_count=$(echo "$_core_count" | sed 's/^ *//; s/ *$//')

  if (( _core_count )); then
    echo "_core_count behaves like an integer."
  else
    echo "_core_count is not a valid integer."
  fi










echo           "Enter Username         : "; username="frederic"                    # read username;
echo           "Enter remote hostname  : "; remote_hostname="137.44.5.215"         # read remote_hostname;
echo           "Enter Username         : "; username="dc-bonn2"                    # read username;
echo           "Enter remote hostname  : "; remote_hostname="tursa.dirac.ed.ac.uk" # read remote_hostname;
echo           "Enter Username         : "; username="eufredericb"                 # read username;
echo           "Enter remote hostname  : "; remote_hostname="login.vega.izum.si"   # read remote_hostname;


module load nvhpc/23.11 fftw/3.3.10--openmpi--4.1.6--nvhpc--23.11 hdf5


module list;
module load nvhpc/23.11 fftw/3.3.10--openmpi--4.1.6--gcc--12.2.0

[Linux][13:58:17] fbonnet0@login05:~() =>$ echo \$HOSTNAME
login05.leonardo.local
[Linux][13:58:22] fbonnet0@login05:~() =>$

# TODO insert the configuration for the
    echo "INSERT THE CONFIGURATION STEP FOR GRID ON A CRAY MACHINE HERE .... "

  # Clearing the modules already loaded and starting fresh
  $white; printf "Purging the modules    : "; $bold;
  #module purge
  $green; printf "done.\n"; $reset_colors;

#source /mnt/lustre/tursafs1/home/y07/shared/tursa-modules/setup-env
  # TODO: may be ok to move this to the common block code




if [ -d ${build} ]
then
  $white; printf "Directory              : "; $bold;
  $blue; printf '%s'"${build}";
  $green; printf " exist, nothing to do.\n"; $white; $reset_colors;
else
  $white; printf "Directory              : "; $bold;
  $blue; printf '%s'"${build}";
  $red;printf " does not exist, We will create it ...\n"; $white; $reset_colors;
  mkdir -p ${build}
  printf "                       : "; $bold;
  $green; printf "done.\n"; $reset_colors;
fi





    ../configure \
    --prefix=${prefix} \
    --enable-comms=mpi-auto \
    --enable-unified=no \
    --enable-shm=nvlink \
    --enable-accelerator=hip \
    --enable-gen-simd-width=64 \
    --enable-simd=GPU \
    --enable-accelerator-cshift \
    --with-lime=$CLIME \
    --with-gmp=$GMP \
    --with-mpfr=$MPFR \
    --with-fftw=$FFTW_DIR/.. \
    --disable-fermion-reps \
    --disable-gparity \
    CXX=hipcc MPICXX=mpicxx \
    CXXFLAGS="-fPIC --offload-arch=gfx90a -I/opt/rocm/include/ -std=c++17 -I/opt/cray/pe/mpich/8.1.23/ofi/gnu/9.1/include" \
    LDFLAGS="-L/opt/cray/pe/mpich/8.1.23/ofi/gnu/9.1/lib -lmpi -L/opt/cray/pe/mpich/8.1.23/gtl/lib -lmpi_gtl_hsa -lamdhip64 -fopenmp"




# TODO: ------------------------------------------------------------------------
# TODO: finish this bit
# TODO: ------------------------------------------------------------------------
src_fldr=./Sombrero

Git_Clone_project "${src_fldr}" "https://github.com/UCL-ARC/Grid.git"


if [ -d $src_fldr ]
then
  $white; printf "Project                : "; $bold;
  $magenta; printf '%s'"$src_fldr"; $green; printf " exist, we will update it with a pull.\n";
  $white; $reset_colors;

  cd "$grid_dir"
  git pull
  cd ..
else
  $white; printf "Project                : "; $bold;
  $magenta; printf '%s'"$src_fldr"; $red; printf " does not exist, we will clone from GitHub.\n";
  $white; $reset_colors;
  # Creating src_fldr method located in ./Scripts/Batch_Scripts/Batch_util_methods.sh
  Batch_util_create_path "${src_fldr}"
  cd "$src_fldr"
  git clone https://github.com/sa2c/SOMBRERO
fi

pwd ;
# TODO: ------------------------------------------------------------------------
# TODO: ------------------------------------------------------------------------




# TODO: ------------------------------------------------------------------------
# TODO: finish this bit
# TODO: ------------------------------------------------------------------------
src_fldr=./Grid-UCL-ARC
if [ -d $src_fldr ]
then
  $white; printf "Project                : "; $bold;
  $magenta; printf '%s'"$src_fldr"; $green; printf " exist, we will update it with a pull.\n"; $white; $reset_colors;

  cd "$grid_dir"
  git pull
  cd ..
else
  $white; printf "Project                : "; $bold;
  $magenta; printf '%s'"$src_fldr"; $red; printf " does not exist, we will clone from GitHub.\n"; $white; $reset_colors;
  # Creating src_fldr method located in ./Scripts/Batch_Scripts/Batch_util_methods.sh
  Batch_util_create_path "${src_fldr}"
  cd "$src_fldr"
  git clone https://github.com/UCL-ARC/Grid.git
fi

pwd ;
# TODO: ------------------------------------------------------------------------
# TODO: ------------------------------------------------------------------------




if [ -d ${build_dir} ]
then
  $white; printf "Directory              : "; $bold;
  $blue; printf '%s'"${build_dir}"; $green; printf " exist, nothing to do.\n"; $white; $reset_colors;
else
  $white; printf "Directory              : "; $bold;
  $blue; printf '%s'"${build_dir}"; $red;printf " does not exist, We will create it ...\n"; $white; $reset_colors;
  mkdir -p ${build_dir}
  printf "                       : "; $bold;
  $green; printf "done.\n"; $reset_colors;
fi


permute() {
    local input=("$@")
    local length=${#input[@]}

    #echo "Length: $length"

    if (( length == 1 )); then
        echo "${input[@]}"
        return
    fi

    local seen=()
    for ((i = 0; i < length; i++)); do
        local num="${input[$i]}"

        # Skip duplicates
        if [[ " ${seen[@]} " =~ " $num " ]]; then
            continue
        fi
        seen+=("$num")

        # Generate sub-permutations
        local rest=("${input[@]:0:i}" "${input[@]:i+1}")
        for sub_perm in $(permute "${rest[@]}"); do
            echo "$num $sub_perm"
        done
    done
}




#-------------------------------------------------------------------------------
# Permutation with two duplicates
#-------------------------------------------------------------------------------
echo

# Array with duplicates
numbers=(1 1 2 3)

# Function to swap two elements in the array
swap() {
    local temp="${numbers[$1]}"
    numbers[$1]="${numbers[$2]}"
    numbers[$2]="$temp"
}

# Recursive function to generate permutations
permute() {
    local start="$1"
    local end="$2"

    if [[ "$start" -eq "$end" ]]; then
        echo "${numbers[@]}"
        return
    fi

    # Use an associative array to track used elements at this level
    declare -A used

    for (( i = start; i <= end; i++ )); do
        if [[ -n "${used[${numbers[i]}]}" ]]; then
            continue  # Skip duplicates
        fi
        used[${numbers[i]}]=1

        swap "$start" "$i"
        permute "$((start + 1))" "$end"
        swap "$start" "$i"  # Backtrack
    done
}

# Sort the array to handle duplicates
IFS=$'\n' numbers=($(sort -n <<<"${numbers[*]}"))
unset IFS

# Call the recursive function
echo "\$2 --->: $((${#numbers[@]} - 1))"
permute 0 $((${#numbers[@]} - 1))



#-------------------------------------------------------------------------------
# Permutation with two duplicates
#-------------------------------------------------------------------------------

echo

# Array with duplicates
numbers=(1 2 3 4)

# Function to swap two elements in the array
swap() {
    local temp="${numbers[$1]}"
    numbers[$1]="${numbers[$2]}"
    numbers[$2]="$temp"
}

# Recursive function to generate permutations
permute() {
    local start="$1"
    local end="$2"

    if [[ "$start" -eq "$end" ]]; then
        echo "${numbers[@]}"
        return
    fi

    # Use an associative array to track used elements at this level
    declare -A used

    for (( i = start; i <= end; i++ )); do
        if [[ -n "${used[${numbers[$i]}]}" ]]; then
            continue  # Skip duplicate elements
        fi
        used[${numbers[$i]}]=1  # Mark this element as used

        swap "$start" "$i"
        permute "$((start + 1))" "$end"
        swap "$start" "$i"  # Backtrack
    done
}

# Sort the array to handle duplicates
IFS=$'\n' numbers=($(sort -n <<<"${numbers[*]}"))
unset IFS

# Call the recursive function
permute 0 $((${#numbers[@]} - 1))


        #"${_core_count}"                           \
        #$(expr $n_nodes * $_core_count)          \
        # $(expr $sombrero_small_strong_n_nodes[$i] * 8)  \



    # nodes * ntasks


echo "qos          ----> $_qos"

# Function defined in ./config_batch_action.sh
case $__batch_action in
  *"BKeeper_compile"*)      config_Batch_BKeeper_compile_cpu  ;;
  *"BKeeper_run_cpu"*)      config_Batch_BKeeper_run_cpu      ;;
  *"BKeeper_run_gpu"*)      config_Batch_BKeeper_run_gpu      ;;
  *"Sombrero_weak"*)        config_Batch_Sombrero_weak_cpu    ;;
  *"Sombrero_strong"*)      config_Batch_Sombrero_strong_cpu  ;;
  *"HiRep-LLR-master-cpu"*) config_Batch_HiRep-LLR-master_cpu ;;
  *"HiRep-LLR-master-gpu"*) config_Batch_HiRep-LLR-master_gpu ;;
  *)
    echo
    $red; printf "The batch action is either incorrect or missing: \n";
    $yellow; printf "[BKeeper_compile, BKeeper_run, Sombrero_weak, Sombrero_strong,";
             printf " HiRep-LLR-master-cpu]\n";
    $cyan; printf "[try: bash -s < ./creator_batch.sh SwanSea/SourceCodes/external_lib BKeeper_compile]\n"; $reset_colors;
    read -p "Would you like to continue (yes/no): " continue;
    if [[ $continue =~ "yes" || $continue =~ "Yes" ]]
    then
      config_Batch_default;
    else
      $red;printf "Exiting, try again with the correct batch action.\n"; $reset_colors;
      echo
      echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
      $cyan; echo `date`; $reset_colors;
      echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
      exit;
    fi
    ;;
esac
#-------------------------------------------------------------------------------
# Now compiling Sombrero
#-------------------------------------------------------------------------------
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
for i in $(seq 0 $sleep_time)
do
  $green;ProgressBar "${i}" "${sleep_time}"; sleep 1;
done
printf "\n"

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Moving Scripts/Batch_Scripts dir and submitting job: "; $bold;
$magenta; printf "${batch_Scripts_dir}\n"; $white; $reset_colors;
cd ${batch_Scripts_dir}
#ls -al

echo "machine name ----> $machine_name"
echo "module list  ----> $module_list"
echo "batch action ----> $__batch_action"
echo "batch file   ----> $__batch_file_out"
echo "qos          ----> $_qos"

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Creating batch file for batch action: ";
$magenta;printf "$__batch_action\n"; $white; $reset_colors;

# TODO: create the automated launching for the jobs using Sombrero Strong case,
# TODO: create loop here for the different cases.

#sbatch Run_BKeeper.sh > out_launcher_bench_BKeeper.log &
$green; printf "Creating the Batch script from the methods: "; $bold;
$cyan; printf "$__batch_file_out\n"; $white; $reset_colors;

cat << EOF > $__batch_file_out
$(Batch_header ${_nodes} ${_ntask} ${_ntasks_per_node} ${_cpus_per_task} ${_partition} ${_job_name} ${_time} ${_qos})
$(
case $__batch_action in
  *"BKeeper"*)              echo "#---> this is a BKeeper job run"              ;;
  *"Sombrero_weak"*)        echo "#---> this is a Sombrero_weak job run"        ;;
  *"Sombrero_strong"*)      echo "#---> this is a Sombrero_strong job run"      ;;
  *"HiRep-LLR-master-cpu"*) echo "#---> this is a HiRep-LLR-master-cpu job run" ;;
  *"HiRep-LLR-master-gpu"*) echo "#---> this is a HiRep-LLR-master-gpu job run" ;;
esac
)

$module_list

EOF

case "$__batch_action" in
  *"BKeeper_compile"*)
      Batch_body_Compile_BKeeper \
      ${machine_name} ${bkeeper_dir} ${LatticeRuns_dir} \
      ${__batch_file_out} ;;
  *"BKeeper_run_cpu"*)
      Batch_body_Run_BKeeper_cpu \
      ${machine_name} ${bkeeper_dir} ${LatticeRuns_dir} ${benchmark_input_dir} \
      ${__batch_file_out};;
  *"BKeeper_run_gpu"*)
      Batch_body_Run_BKeeper_gpu \
      ${machine_name} ${bkeeper_dir} ${LatticeRuns_dir} ${benchmark_input_dir} \
      ${__batch_file_out};;
  *"Sombrero_weak"*)
      Batch_body_Run_Sombrero_weak \
      ${machine_name} ${sombrero_dir} ${LatticeRuns_dir} \
      ${__batch_file_out};;
  *"Sombrero_strong"*)
      Batch_body_Run_Sombrero_strong \
      ${machine_name} ${sombrero_dir} ${LatticeRuns_dir} \
      ${__batch_file_out};;
  *"HiRep-LLR-master-cpu"*)
      Batch_body_Run_HiRep-LLR-master-cpu \
      ${machine_name} ${HiRep_LLR_master_HMC_dir} ${LatticeRuns_dir} \
      ${__batch_file_out};;
  *"HiRep-LLR-master-gpu"*)
      #TODO: insert the method for the gpu batch script creation
      ;;
esac





echo "core_count --->: $_core_count"
echo "mem_total  --->: $_mem_total"
echo "gpu_count  --->: $_gpu_count"



# Global variables
#-------------------------------------------------------------------------------
# Getting the common code setup and variables, #setting up the environment properly.
#-------------------------------------------------------------------------------
# Overall config file
source ./common_main.sh $1;
# System config file to get information from the node
source ./config_system.sh;
# The config for the batch_action needs information from the system_config call
source ./config_batch_action.sh
# The Batch content creators methods
source ./Scripts/Batch_Scripts/Batch_header_methods.sh
source ./Scripts/Batch_Scripts/Batch_body_methods.sh
# Batch file out constructor variable





    if [ -d ${__path_to_run} ]
    then
      $white; printf "Directory              : "; $bold;
      $blue; printf '%s'"${__path_to_run}"; $green; printf " exist, nothing to do.\n"; $white; $reset_colors;
    else
      $white; printf "Directory              : "; $bold;
      $blue; printf '%s'"${__path_to_run}"; $red;printf " does not exist, We will create it ...\n";
      $white; $reset_colors;
      mkdir -p ${__path_to_run}
      printf "                       : "; $bold;
      $green; printf "done.\n"; $reset_colors;
    fi



__batch_action= #$2

# constructing the files and directory structure
H=1
L=1
for j in $(seq 0 `expr ${#bkeeper_lattice_size_cpu[@]} - 1`)
do
  lattice=$(printf "lat%s" ${bkeeper_lattice_size_cpu[$j]};)

  for i in $(seq 0 `expr ${#bkeeper_large_n_nodes[@]} - 1`)
  do
    cnt=$(printf "%03d" $H)
    index=$(printf "%03d" $i)
    n_nodes=$(printf "nodes%03d" ${bkeeper_large_n_nodes[$i]};)
    # Orchetstrating the file construction
    __batch_file_construct=$(printf "Run_${__batch_action}_${n_nodes}_${lattice}")
    __batch_file_out=$(printf "${__batch_file_construct}.sh")
    __path_to_run=$(printf "${LatticeRuns_dir}/${__batch_file_construct}")

    #$cyan;printf "bkeeper_large_n_nodes[$index] : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors
    $cyan;printf "                       : $n_nodes, $__batch_file_out, $__path_to_run\n"; $reset_colors

    if [ -d ${__path_to_run} ]
    then
      $white; printf "Directory              : "; $bold;
      $blue; printf '%s'"${__path_to_run}"; $green; printf " exist, nothing to do.\n"; $white; $reset_colors;
    else
      $white; printf "Directory              : "; $bold;
      $blue; printf '%s'"${__path_to_run}"; $red;printf " does not exist, We will create it ...\n";
      $white; $reset_colors;
      mkdir -p ${__path_to_run}
      printf "                       : "; $bold;
      $green; printf "done.\n"; $reset_colors;
    fi

    # incrementing the counter
    H=$(expr $H + 1)
  done
  L=$(expr $L + 1)
done




config_Batch_Sombrero_weak_cpu (){
_nodes=2
_ntasks_per_node=128
_cpus_per_task=1
_partition="cpu"
_job_name="run_Sombrero_weak_$_nodes"
_time="0:0:20"
_qos="standard"
}
config_Batch_Sombrero_weak_cpu (){
_nodes=4
_ntasks_per_node=128
_cpus_per_task=1
_partition="cpu"
_job_name="run_Sombrero_weak"
_time="0:0:20"
_qos="standard"
}
config_Batch_Sombrero_weak_cpu (){
_nodes=8
_ntasks_per_node=128
_cpus_per_task=1
_partition="cpu"
_job_name="run_Sombrero_weak"
_time="0:0:20"
_qos="standard"
}


Batch_body_Run_Sombrero_strong (){
 _machine_name=$1
 _sombrero_dir=$2
 _batch_file_out=$3
 cat << EOF >> "$_batch_file_out"

EOF
}

echo "No batch action entered: "
/mnt/c/cygwin64/bin/read -p "thi sis is s" cont;



echo "Linux:is:awesome." | (IFS=":" read -p var1 var2 var3; echo -e "$var1 \n$var2 \n$var3")



Batch_body_Compile_BKeeper (){
_machine_name=$1
_bkeeper_dir=$2
__batch_file_out=$3

cat << EOF >> "$__batch_file_out"
echo "# -------------------------------------------------------------------------------"
echo "# Start of the batch body                                                        "
echo "# -------------------------------------------------------------------------------"
#echo "bkeeper_build_dir=\"${_bkeeper_dir}/build\""
echo "# ------------------------------------------------------------------------------"
echo "# Run the make procedure                                                        "
echo "# ------------------------------------------------------------------------------"
echo "machine_name=\"${_machine_name}\""
echo "bkeeper_dir=$_bkeeper_dir"
echo "bkeeper_build_dir=$bkeeper_build_dir"
echo "# ------------------------------------------------------------------------------"
echo "# move to the directory in BKeeper directory                                    "
echo "# ------------------------------------------------------------------------------"

echo "cd $_bkeeper_dir"
EOF
}

echo "# ---> this works ----<"
echo "TODO: insert the main of each case of the machines"
echo "ls -al ${prefix}"




$(
case $__batch_action in
  *"BKeeper_compile"*) $(Batch_body_Compile_BKeeper ${machine_name} ${bkeeper_dir});;
  *"BKeeper_run"*) $(Batch_body_Run_BKeeper ${machine_name} ${bkeeper_dir});;
esac
)





if [[ $machine_name =~ "Precision-3571" ]]; then
  make -k -j16;
else
  make -k -j32;
fi




#echo "SLURM_SUBMIT_DIR: $SLURM_SUBMIT_DIR"
#cd $SLURM_SUBMIT_DIR


#echo "SLURM_SUBMIT_DIR: $SLURM_SUBMIT_DIR"
#cd $SLURM_SUBMIT_DIR



# ======================================================================================================================
# ====================    from build_Grid.sh    ========================================================================
# ======================================================================================================================


# Running the make install into the prefix directory
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Running make -k install      : "; $bold;
$magenta; printf "${build_dir}\n"; $white; $reset_colors;
ls -al
make -k install

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
prefix_lib_dir=${prefix}/lib
$green; printf "Checking content of prefix library directory : "; $bold;
$magenta; printf "${prefix_lib_dir}\n"; $white; $reset_colors;
ls -al ${prefix_lib_dir}
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
prefix_inc_dir=${prefix}/include
$green; printf "Checking content of prefix include directory : "; $bold;
$magenta; printf "${prefix_inc_dir}\n"; $white; $reset_colors;
ls -al ${prefix_inc_dir}

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
grid_build_bench_dir=${build_dir}/benchmarks
$green; printf "Moving Grid/build/benchmark dir and compiling: "; $bold;
$magenta; printf "${grid_build_bench_dir}\n"; $white; $reset_colors;
cd ${grid_build_bench_dir}
ls -al


# ======================================================================================================================




# ======================================================================================================================
# ====================    from build_Grid.sh    ========================================================================
# ======================================================================================================================


# Now compiling Sombrero
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Moving Sombrero dir and compiling: "; $bold;
$magenta; printf "${sombrero_dir}\n"; $white; $reset_colors;
cd ${sombrero_dir}
ls -al

make

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
for i in $(seq 0 $sleep_time)
do
  $green;ProgressBar "${i}" "${sleep_time}"; sleep 1;
done
printf "\n"

# Now compiling BKeeper
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Moving BKeeper dir and compiling: "; $bold;
$magenta; printf "${bekeeper_dir}\n"; $white; $reset_colors;
cd ${bekeeper_dir}
ls -al
build=build
./bootstrap.sh
if [ -d ${build} ]
then
  $white; printf "Directory              : "; $bold;
  $blue; printf '%s'"${build}"; $green; printf " exist, nothing to do.\n"; $white; $reset_colors;
else
  $white; printf "Directory              : "; $bold;
  $blue; printf '%s'"${build}"; $red;printf " does not exist, We will create it ...\n"; $white; $reset_colors;
  mkdir -p ${build}
  printf "                       : "; $bold;
  $green; printf "done.\n"; $reset_colors;
fi

$green; printf "Moving to build directory    : "; $bold;
$magenta; printf "${build}\n"; $white; $reset_colors;
cd ${build}
$magenta; printf "currennt dir: "`pwd`"\n"; $white; $reset_colors;

../configure \
  --prefix=${prefix} \

make
make install

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
for i in $(seq 0 $sleep_time)
do
  $green;ProgressBar "${i}" "${sleep_time}"; sleep 1;
done
printf "\n"

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Launching benchmark in Grid/build/benchmark dir: "; $bold;

./Benchmark_ITT


# ======================================================================================================================




# ======================================================================================================================
# ====================    from build_dependencies.sh    ================================================================
# ======================================================================================================================
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Moving Grid dir and compiling: "; $bold;
$magenta; printf "${grid_dir}\n"; $white; $reset_colors;
cd ${grid_dir}
ls -al

$magenta; printf "currennt dir: "`pwd`"\n"; $white; $reset_colors;

$green; printf "Launching bootstrapper       : "; $bold;
$magenta; printf "./bootstrap.sh\n"; $white; $reset_colors;
./bootstrap.sh

if [ -d ${build_dir} ]
then
  $white; printf "Directory              : "; $bold;
  $blue; printf '%s'"${build_dir}"; $green; printf " exist, nothing to do.\n"; $white; $reset_colors;
else
  $white; printf "Directory              : "; $bold;
  $blue; printf '%s'"${build_dir}"; $red;printf " does not exist, We will create it ...\n"; $white; $reset_colors;
  mkdir -p ${build_dir}
  printf "                       : "; $bold;
  $green; printf "done.\n"; $reset_colors;
fi

$green; printf "Moving to build directory    : "; $bold;
$magenta; printf "${build_dir}\n"; $white; $reset_colors;
cd build
$magenta; printf "currennt dir: "`pwd`"\n"; $white; $reset_colors;

# loading the modules for compilation (only valid during the life of this script)
# Here the idea is to use the exact same configuration on all machines, the laptop
# configuration is just for testing purpooses and sanity checks when it all goes pear shape
# on the cluster.
#TODO: fix the repetition in the same cases when needed.
$green; printf "Configuring                  : "; $bold;
case $machine_name in
  *"Precision-3571"*)
    ../configure \
    --enable-comms=mpi-auto \
    --enable-doxygen-doc
    ;;
  *"tursa"*)
    ../configure \
    --prefix=${prefix} \
    --enable-doxygen-doc \
    --enable-comms=mpi \
    --enable-simd=GPU \
    --enable-shm=nvlink \
    --enable-accelerator=cuda \
    --enable-gen-simd-width=64 \
    --disable-gparity \
    --disable-fermion-reps \
    --enable-Sp \
    --enable-Nc=4 \
    --with-lime=${prefix} \
    --with-gmp=${prefix} \
    --with-mpfr=${prefix} \
    --disable-unified \
    CXX=nvcc \
    LDFLAGS="-cudart shared -lcublas " \
    CXXFLAGS="-ccbin mpicxx -gencode arch=compute_80,code=sm_80 -std=c++17 -cudart shared --diag-suppress 177,550,611"
    ;;
  *"sunbird"*)
    ../configure \
    --prefix=${prefix} \
    --enable-doxygen-doc \
    --enable-comms=mpi \
    --enable-simd=GPU \
    --enable-shm=nvlink \
    --enable-accelerator=cuda \
    --enable-gen-simd-width=64 \
    --disable-gparity \
    --disable-fermion-reps \
    --enable-Sp \
    --enable-Nc=4 \
    --with-lime=${prefix} \
    --with-gmp=${prefix} \
    --with-mpfr=${prefix} \
    --disable-unified \
    CXX=nvcc \
    LDFLAGS="-cudart shared -lcublas " \
    CXXFLAGS="-ccbin mpicxx -gencode arch=compute_80,code=sm_80 -std=c++17 -cudart shared --diag-suppress 177,550,611"
    ;;
  *"vega"*)
    ../configure \
    --prefix=${prefix} \
    --enable-doxygen-doc \
    --enable-comms=mpi \
    --enable-simd=GPU \
    --enable-shm=nvlink \
    --enable-accelerator=cuda \
    --enable-gen-simd-width=64 \
    --disable-gparity \
    --disable-zmobius \
    --disable-fermion-reps \
    --enable-Sp \
    --enable-Nc=4 \
    --with-lime=${prefix} \
    --with-gmp=${prefix} \
    --with-mpfr=${prefix} \
    --disable-unified \
    CXX=nvcc \
    LDFLAGS="-cudart shared -lcublas " \
    CXXFLAGS="-ccbin mpicxx -gencode arch=compute_80,code=sm_80 -std=c++17 -cudart shared --diag-suppress 177,550,611"
    ;;
esac

$green; printf "Building Grid                : "; $bold;
$yellow; printf "coffee o'clock time! ... \n"; $white; $reset_colors;
if [[ $machine_name =~ "Precision-3571" ]]; then make -k -j16; else make -k -j32; fi
#make

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Moving Grid/build/benchmark dir and compiling: "; $bold;
grid_build_bench_dir=${build_dir}/benchmarks
$magenta; printf "${grid_build_bench_dir}\n"; $white; $reset_colors;
cd ${grid_build_bench_dir}
ls -al

make
make -k install

# Now compiling Sombrero
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Moving Sombrero dir and compiling: "; $bold;
$magenta; printf "${sombrero_dir}\n"; $white; $reset_colors;
cd ${sombrero_dir}
ls -al

make

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
for i in $(seq 0 $sleep_time)
do
  $green;ProgressBar "${i}" "${sleep_time}"; sleep 1;
done
printf "\n"

# Now compiling BKeeper
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Moving BKeeper dir and compiling: "; $bold;
$magenta; printf "${bekeeper_dir}\n"; $white; $reset_colors;
cd ${bekeeper_dir}
ls -al
build=build
./bootstrap.sh
if [ -d ${build} ]
then
  $white; printf "Directory              : "; $bold;
  $blue; printf '%s'"${build}"; $green; printf " exist, nothing to do.\n"; $white; $reset_colors;
else
  $white; printf "Directory              : "; $bold;
  $blue; printf '%s'"${build}"; $red;printf " does not exist, We will create it ...\n"; $white; $reset_colors;
  mkdir -p ${build}
  printf "                       : "; $bold;
  $green; printf "done.\n"; $reset_colors;
fi

$green; printf "Moving to build directory    : "; $bold;
$magenta; printf "${build}\n"; $white; $reset_colors;
cd ${build}
$magenta; printf "currennt dir: "`pwd`"\n"; $white; $reset_colors;

../configure \
  --prefix=${prefix} \

make
make install

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
for i in $(seq 0 $sleep_time)
do
  $green;ProgressBar "${i}" "${sleep_time}"; sleep 1;
done
printf "\n"

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
$green; printf "Launching benchmark in Grid/build/benchmark dir: "; $bold;

./Benchmark_ITT


# ======================================================================================================================




























  *"Precision-3571"*)
    #../configure --enable-comms=mpi-auto --enable-doxygen-doc --no-create --no-recursion --enable-simd=GPU --enable-accelerator=cuda --enable-gen-simd-width=64 --disable-gparity --disable-zmobius --disable-fermion-reps --enable-Sp --enable-Nc=4 --with-lime=/home/frederic/Swansea/SourceCodes/external_lib/prefix_grid_202410 --with-gmp=/home/frederic/Swansea/SourceCodes/external_lib/prefix_grid_202410 --with-mpfr=/home/frederic/Swansea/SourceCodes/external_lib/prefix_grid_202410 --disable-unified CXX=nvcc LDFLAGS="-cudart shared -lcublas " CXXFLAGS="-ccbin mpicxx -gencode arch=compute_80,code=sm_80 -std=c++17 -cudart shared --diag-suppress 177,550,611"
    #    --enable-simd=AVX \
    ../configure \
    --enable-comms=mpi-auto \
    --enable-doxygen-doc \
    --enable-simd=GPU \
    --enable-accelerator=cuda \
    --enable-gen-simd-width=64 \
    --disable-gparity \
    --disable-zmobius \
    --disable-fermion-reps \
    --enable-Sp \
    --enable-Nc=4 \
    --with-lime=${prefix} \
    --with-gmp=${prefix} \
    --with-mpfr=${prefix} \
    --disable-unified \
    CXX=nvcc \
    LDFLAGS="-cudart shared -lcublas " \
    CXXFLAGS="-ccbin mpicxx -gencode arch=compute_80,code=sm_80 -std=c++17 -cudart shared --diag-suppress 177,550,611"
    ;;


# password is read in silent mode i.e. it will
# show nothing instead of password.

echo "Your password is read in silent mode."
echo "username:" ${username} " and remote: " ${remote_hostname}

ssh dc-bonn2@tursa.dirac.ed.ac.uk "cd ~/SwanSea/SourceCodes/Sombrero/SOMBRERO; ls -al"


echo "user_remote_host:" ${user_remote_host}


echo "user_remote_home_dir:" ${user_remote_home_dir}


echo "external_lib_dir:" ${external_lib_dir}


ssh $user_remote_host "cd ~/Scripts; ls -al;mkdir -p ${external_lib_dir}; ls ${external_lib_dir}"
mkdir -p ${external_lib_dir};

    #../configure --enable-comms=mpi-auto --enable-doxygen-doc --no-create --no-recursion --enable-simd=GPU --enable-accelerator=cuda --enable-gen-simd-width=64 --disable-gparity --disable-zmobius --disable-fermion-reps --enable-Sp --enable-Nc=4 --with-lime=/home/frederic/Swansea/SourceCodes/external_lib/prefix_grid_202410 --with-gmp=/home/frederic/Swansea/SourceCodes/external_lib/prefix_grid_202410 --with-mpfr=/home/frederic/Swansea/SourceCodes/external_lib/prefix_grid_202410 --disable-unified CXX=nvcc LDFLAGS="-cudart shared -lcublas " CXXFLAGS="-ccbin mpicxx -gencode arch=compute_80,code=sm_80 -std=c++17 -cudart shared --diag-suppress 177,550,611"
    #    --enable-simd=AVX \
#lib_path="/Swansea/SourceCodes/external_lib";
#external_lib_dir="${external_lib_dir}${lib_path}";


ssh -t $user_remote_host "
#colors
red=\"tput setaf 1\"  ;green=\"tput setaf 2\"  ;yellow=\"tput setaf 3\"
blue=\"tput setaf 4\" ;magenta=\"tput setaf 5\";cyan=\"tput setaf 6\"
white=\"tput setaf 7\";bold=\"\"               ;reset_colors=\"\"
if [ -d ${external_lib_dir} ]
then
  \$white; printf \"Directory              : \"; \$bold;
  \$blue; printf \'%s\'\"${external_lib_dir}\"; \$green; printf \" exist, nothing to do.\n\"; \$white; \$reset_colors;
else
  \$white; printf \"Directory              : \"; \$bold;
  \$blue; printf \'%s\'\"${external_lib_dir}\"; \$red;printf \" does not exist, We will create it ...\n\"; \$white; \$reset_colors;
  mkdir -p ${external_lib_dir}
  printf \"                       : \"; \$bold;
  \$green; printf \"done.\n\"; \$reset_colors;
fi
cd ${external_lib_dir};
pwd
ls -al ${external_lib_dir}
"

user_remote_home_dir=$(ssh -t ${user_remote_host} "mkdir -p ./SwanSea/SourceCodes/external_lib; cd \$_; echo \"\$\(cd \"\$\(\$_ \"\$1\"\)\"; pwd -P\)/\$\(basename \"\$1\"\)\"")

user_remote_home_dir=$(ssh -t ${user_remote_host} "mkdir -p ./SwanSea/SourceCodes/external_lib; cd \$_; pwd -P")


#source /ceph/hpc/software/cvmfs_env.sh ; module use /usr/share/Modules/modulefiles

ssh -t dc-bonn2@tursa.dirac.ed.ac.uk "
  source /etc/profile.d/modules.sh ;
  module load /mnt/lustre/tursafs1/home/y07/shared/tursa-modules/setup-env ;
  module avail ; module list ;
  module load cuda/12.3 openmpi/4.1.5-cuda12.3 ucx/1.15.0-cuda12.3 gcc/9.3.0 ; module list
  "


sed '' -e's/[ \t]*$//' "$user_remote_home_dir"

elif [[ $hostname =~ "vega" ]]; then
  machine_name="vega"

  # Clearing the modules already loaded and starting fresh
  source /etc/profile.d/modules.sh;
  source /ceph/hpc/software/cvmfs_env.sh;
  module list

  $white; printf "Purging the modules    : "; $bold;
  module purge
  module list

  $green; printf "done.\n"; $reset_colors;


