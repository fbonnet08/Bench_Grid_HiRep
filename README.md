Bench_Grid_HiRep code v-0.0.1
============================
Bench_Grid_HiRep is a code used in system programming to build and 
launch Lattice Gauge theory codes. It aims at extracting system
information or system management and/or test/benchmark different
scenarios on various HPC clusters as well as local ones.

The code is modular and aims at 
* build
* Launch
* collect and data analyse results

from a remote setting across several machines simultaneously.

The code is currently driven in bash and works under both 
* Windows 10 via Cygwin/X or WSL (Debian or Ubuntu) other emulators are also capable. 
* Linux

Environments. 

Some parts of code are/will ./be written in C/C++/Cuda-C and is
still under development. The driving part is done in bash and
is portable on different OS.

A Python interface will then be developed at a later stage. The code
may also be driven using bash/PowerShell commands line with [options].
The prupose of the Python environment is to have a a proper data
analysis tool in the data collection.

Requirements
------------
* Linux: GNU chain tool
* Windows: The built in Visual Studio Tool Chain (clang)
* Make, CMake, and CUDA-toolkit (12.x preferably)
* Windows: Visual Studio 2019 community version
* Python-3.12.8+:
    - psycopg2 (PostGreSQL access)
    - psycopg[binaries]
    - pyodbc (SQL access)
    - tqdm
    - selenium (automated testing on websites)
 
GitHub access and password protected repos.
------------
Some repository require GitHub authentication password. This is done via a Git Token
multifactor authentification mechanism.

In the file ```common_main.sh``` in the root of the application two variables 
have been set to provide the name of the file where the Token can be isolated in
a secure place and the path to that file on the local host:

```aiignore
    GitHub_Token_File="Personal_GitHub_Token.sh"
    GitHub_Token_File_dir="{path to GitHub_Token_File}"
```

In file ```Personal_GitHub_Token.sh``` all is required is the following:
```aiignore
    #!/usr/bin/bash
    # Global variables
    #-------------------------------------------------------------------------------
    # Setting the github token value away from the project. 
    #-------------------------------------------------------------------------------
    __GitHub_Token="insert GitHub token here"
```

The GitHub Token is usually starting with ```ghp_``` and contains ```40``` characters
(as of May 2025).

How to use it
-------------
Right now the code is still under development and only some of the
classes have been developed. The main is just a simple driver code that
will be rearranged otherwise later once, most of the primary classes
have been at least developed

Depending on the purpose the use of bash , Pyhton or C/C++/CUDA-C
is determined

- For building ```>$ sh dispatcher_Grid_hiRep.sh```, in the root project.
- For data analysis ```>$ python Bench_Grid_HiRep.py [--grid=Grid, --hirep=HiRep]```
- For C/C++ driven with GPU acceleration ```>$ cmake```. Via Ninja build.

The Python or the bash may be used for complete automation
at some point this is still under development.

How to download.
-----------------
The code is available in GitHub via a private share.

- https: ```https://github.com/fbonnet08/Bench_Grid_HiRep.git```
- ssh: ```git@github.com:fbonnet08/Bench_Grid_HiRep.git```
- github cli: ```gh repo clone fbonnet08/Bench_Grid_HiRep```

GPU-Component
--------------
The cuda tool kit is used for handling some of the computationally expansive
tasks and may be removed later if not needed at all. At the moment
it stays. Some basic kernels and testcode has been developed and
inserted and may be removed later as I see fits.

The project a both a CMake and Make file based project. The CMake is based
in the windows version v-3.30 with std=c++17
running on cuda-12.2 and in the Linux on CMake version 3.25 with Cuda-12.6.

In the the folder CMakes there are several possible configuration for the CMakeList.txt
file. One needs to copy the appropriate version into CMakeList.txt in the root of the project.
The WSL version is yet to be final. The default CMakeList.txt file does not contain the library links
necessary for the a CUDA successful build.

In Powershell in teh root of the project, this can be compiled using:

``
& 'C:\Users\Frederic\AppData\Local\Programs\CLion Nova\bin\cmake\win\x64\bin\cmake.exe' -DCMAKE_BUILD_TYPE=Debug -G 'Unix Makefiles' -DMAKE_CUDA_COMPILER='C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.2\bin\nvcc.exe' -DPython_EXECUTABLE='C:/Program Files/Python312/python.exe' -DPython3_EXECUTABLE='C:/Program Files/Python312/python.exe' -S C:\cygwin64\home\Frederic\SwanSea\SourceCodes\Bench_Grid_HiRep -B C:\cygwin64\home\Frederic\SwanSea\SourceCodes\Bench_Grid_HiRep\cmake-build-debug-visual-studio
``

For example, the correct paths need to be inserted.

For Windows with CUDA one needs: ``add_definitions(-DWINDOWS -DCUDA)``.

For Linux with no Cuda, one would then need: ``add_definitions(-DLINUX)``.

Certain functionalities
------------------------
The code parses system information such as network infrastructure and
information. The information is then stored in data structures which
can then be passed around in the code for extraction and
exploitation.

The Benches
-------------

<u>SOMBRERO:</u>
- Small, strong scaling, nodes=1, 2, 3, 4, 6, 8, 12
- Large, strong scaling; small/large, weak scaling, nodes=1, 2, 3, 4, 6, 8, 12, 16, 24, 32
- In all cases, fill entire node

<u>BKeeper CPU:</u>
- --grid 24.24.24.32, 1 node, vary ntasks per node, set threads per task to fill node
- --grid 24.24.24.32, 1 node, fix optimal ntasks per node and threads per task, vary --mpi argument. \
    (From this we can identify what pattern of MPI filling optimises performance. \
    This is typically going 1.1.1.2, 1.1.1.4, until we run out of factors, \
    and then going to 1.1.2.N, etc., but this should be verified)
- --grid 24.24.24.32, use a sensible --mpi and ntasks-per-node, nodes=1, 2, 3, 4, 6, 8, 12, 16
- --grid 64.64.64.96, use a sensible --mpi and ntasks-per-node, nodes=1, 2, 3, 4, 6, 8, 12, 16, 24, 32
- --grid 24.24.24.{number of MPI ranks} --mpi 1.1.2.{number of MPI ranks/2}, nodes=1, 2, 3, 4, 6, 8, 12, 16, 24, 32

<u>BKeeper GPU:</u>\
Note when running BKeeper in parallel on GPU that a wrapper script is needed to place processes on the correct device.
This will vary from machine to machine; an example for Tursa is attached
- --grid 24.24.24.32, use a sensible --mpi from above, one task per GPU, nodes=1, 2, 3, 4, 6, 8, 12, 16
- --grid 64.64.64.96, use a sensible --mpi from above, one task per GPU, nodes=1, 2, 3, 4, 6, 8, 12, 16, 24, 32
- --grid 24.24.24.{number of MPI ranks} --mpi 1.1.2.{number of MPI ranks/2}, nodes=1, 2, 3, 4, 6, 8, 12, 16, 24, 32
- --grid 48.48.48.64 --mpi 1.1.1.4, scan GPU clock frequency

<u>Grid GPU:</u> \
tests/sp2n/Test_hmc_Sp_WF_2_Fund_3_2AS.cc, using a thermalised starting configuration
- --grid 32.32.32.64, use a sensible --mpi, one task per GPU, nodes=1, 2, 4, 8, 16, 32

<u>HiRep LLR HMC CPU:</u>
- Weak scaling, 1 rank per replica, number of replicas = total number of CPU cores (varies with platform),\
    nodes=1, 2, 3, 4
- Strong scaling, number of CPU cores per node = number of replicas; \
    total number of CPU cores = number of replicas * number of domains per replica, nodes=1, 2, 3, 4, 6, 8

On EuroHPC machines we absolutely need to get the latter two tests done so that we can prepare a convincing application. On other machines we only need SOMBRERO and BKeeper.

Documentation
---------------
Right now the code is not documented but will be later once it matures
a little
