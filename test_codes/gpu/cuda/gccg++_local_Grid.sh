#!/usr/bin/bash
FLNAME=`basename $1 .cpp`

GFORTRAN=g++

SOURCE_DIR=/home/frederic/SwanSea/SourceCodes/Bench_Grid_HiRep
SOURCEDIR_INC=$SOURCE_DIR/include

OBJDIR=$SOURCE_DIR/obj/GFORTgpu

Grid_dir=/home/frederic/SwanSea/SourceCodes/Grid-UCL-ARC/Grid/
Grid_dir_inc=/home/frederic/SwanSea/SourceCodes/Grid-UCL-ARC/Grid/Grid/
Grid_serialisation_dir_inc=/home/frederic/SwanSea/SourceCodes/Grid-UCL-ARC/Grid/Grid/serialisation
Grid_build_dir=/home/frederic/SwanSea/SourceCodes/Grid-UCL-ARC/Grid/build
Grid_build_grid_dir=/home/frederic/SwanSea/SourceCodes/Grid-UCL-ARC/Grid/build/Grid

#Grid_all_headers_inc=$(find /home/frederic/SwanSea/SourceCodes/Grid-UCL-ARC/Grid/ -type f -name "*.h")

openmpi_dir_inc=/usr/lib/x86_64-linux-gnu/fortran/gfortran-mod-15/openmpi

hdf5_openmpi_inc=/usr/include/hdf5/openmpi/
hdf5_serial_inc=/usr/include/hdf5/serial/

external_lib=/home/frederic/SwanSea/SourceCodes/external_lib

prefix=${external_lib}/prefix_grid_202410
prefix_lib=${prefix}/lib
prefix_inc=${prefix}/include

CUDADIR=='/mnt/c/Program\ Files/NVIDIA\ GPU\ Computing\ Toolkit/CUDA/v12.6'
CUDAINC=$CUDADIR/include

#platform stuff
PLATFORM=`uname`
if [ "$PLATFORM" = "Linux" ]; then PLAT="-DLINUX";
elif [ "$PLATFORM" = "Darwin" ]; then PLAT="-DMACOSX";
else echo "You seem to be compiling/running in wonderland";
fi

#-DDRAW_WIREFRAME -DQT    -v -Wl,--trace -v -Wl,--trace
OPTION=" -std=c++17 -cpp -O3 -fopenmp $PLAT"
#
$GFORTRAN $OPTION -I "$OBJDIR"                     \
                  -I "$SOURCEDIR_INC"              \
                  -I "$external_lib_inc"           \
                  -I "$Grid_dir"                   \
                  -I "$Grid_dir_inc"               \
                  -I "$Grid_serialisation_dir_inc" \
                  -I "$Grid_build_dir"             \
                  -I "$Grid_build_grid_dir"        \
                  -I "$hdf5_openmpi_inc"           \
                  -I "$hdf5_serial_inc"            \
                  -I "$openmpi_dir_inc"            \
                  -I "$CUDAINC"                    \
                  -L "$prefix_lib" -lgmp           \
                  -L "$prefix_lib" -llime          \
                  -L "$prefix_lib" -lmpfr          \
                  -L "$prefix_lib" -lGrid          \
                  -o "$FLNAME"                     \
                  "$FLNAME".cpp