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
* Python:
    - psycopg2 (PostGreSQL access)
    - psycopg[binaries]
    - pyodbc (SQL access)
    - selenium (automated testing on websites)

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
- For C/C++ driven with GPU acceleration ```>$ cmake```.

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

Certain functionalities
------------------------
The code parses system information such as network infrastructure and
information. The information is then stored in data structures which
can then be passed around in the code for extraction and
exploitation.

Documentation
---------------
Right now the code is not documented but will be later once it matures
a little

