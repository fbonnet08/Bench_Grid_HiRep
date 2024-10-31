Bench_Grid_HiRep code v-0.0.1
============================
SysProg-Cuda is a code used in system programming to extract system
information or system management and/or test of different security
issues on the network and the like and devices.

The code is currently driven in bash and works under both 
* windows
* Linux

Environments. 

Some parts of code is/will is/be written in C/C++/Cuda-C and is still under development.

A Python interface will then be developed at a later stage. The code
may also be driven using bash/PowerShell commands line with [options].

Requirements
------------
* Linux: GNU chain tool
* Windows: The built in Visual Studio Tool Chain (clang)
* Make, CMake, and CUDA-toolkit (12.x preferably)
* Windows: Visual Studio 2019 community version
* Python:
    - psycopg2
    - psycopg[binaries]
    - pyodbc
    - selenium

How to use it
-------------
Right now the code is still under development and only some of the
classes have been developed. The main is just a simple driver code that
will be rearranged otherwise later once, most of the primary classes
have been at least developed

How to download.
-----------------
The code is available in GitHub via a private share.

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

