



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


