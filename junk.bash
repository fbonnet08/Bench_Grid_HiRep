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


