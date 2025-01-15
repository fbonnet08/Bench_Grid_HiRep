FLNAME=`basename $1 .cpp`

GFORTRAN=g++

SOURCE_DIR=/home/frederic/Leiden/SourceCode/DataManage_project
#/home/frederic/Leiden/SourceCode/Simple_Restruct.projet
#/home/frederic/Yale/SourceCode/Simple_Restruct.projet
#/home/frederic/Monash/SourceCode/Simple/Restructured/HansVersion/Simple_Restruct.projet

FFTW_LIB=/usr/lib/x86_64-linux-gnu

SOURCEDIR_INC=$SOURCE_DIR/src/include
RELIONIMPORTS_INC=$SOURCE_DIR/src/include/relionImports
OPENGLIMPORTS_INC=$SOURCE_DIR/src/include/OpenGL

CUDADADIR_INC=$SOURCE_DIR/cuda/include/dataManage
OBJDIR=$SOURCE_DIR/obj/GFORTgpu

MAGMADIR=/opt/Devel_tools/magma-1.6.1
MAGMADIR_LIB=$MAGMADIR/lib

#USER_LOCAL_DIR=/usr/local
USER_LOCAL_DIR=/mnt/c/Program\\ Files/NVIDIA\\ GPU\\ Computing\\ Toolkit
CUDADIR=$USER_LOCAL_DIR/CUDA/v12.6/
CUDAINC=$CUDADIR/include


CUDNNDIR=$USER_LOCAL_DIR/cudnn
CUDNNDIR_LIB=$CUDNNDIR/2016-05-12/lib64

NVIDIA_CUDA_10_2_SAMPLES=$CUDADIR/Samples/NVIDIA_CUDA-10.2_Samples
NVIDIA_CUDA_10_2_SAMPLES_INC=$NVIDIA_CUDA_10_2_SAMPLES/common/inc
NVIDIA_CUDA_10_2_SAMPLES_INC_GL=$NVIDIA_CUDA_10_2_SAMPLES/common/inc/GL

CV_INC=$USER_LOCAL_DIR/include/opencv4
CV_LIB=$USER_LOCAL_DIR/lib

#platform stuff
PLATFORM=`uname`
if [ "$PLATFORM" = "Linux" ]
then
 PLAT="-DLINUX"
elif [ "$PLATFORM" = "Darwin" ]
then
 PLAT="-DMACOSX"
else
    echo "You seem to be compiling/running in wonderland"
fi
#-DDRAW_WIREFRAME -DQT    -v -Wl,--trace -v -Wl,--trace
OPTION=" -std=c++11 -cpp -O3 -fopenmp $PLAT -DOPENMP -DBENCH -DCUDA -DMAGMA -DGL_GLEXT_PROTOTYPES"
#
$GFORTRAN $OPTION -I $NVIDIA_CUDA_10_2_SAMPLES_INC \
                    -I $NVIDIA_CUDA_10_2_SAMPLES_INC_GL \
                    -I $OBJDIR -I $SOURCEDIR_INC -I $OPENGLIMPORTS_INC \
                    -I $RELIONIMPORTS_INC -I $CUDADADIR_INC -I $CUDAINC \
                    -I $CV_INC -o $FLNAME \
                    $FLNAME.cpp