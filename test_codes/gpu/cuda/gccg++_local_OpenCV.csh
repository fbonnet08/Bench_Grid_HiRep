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

USER_LOCAL_DIR=/usr/local

CUDADIR=$USER_LOCAL_DIR/cuda
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
		                $FLNAME.cpp \
                                $OBJDIR/timming.o \
                                $OBJDIR/timming_c.o \
                                $OBJDIR/get_deviceQuery_gpu.o \
                                $OBJDIR/get_deviceQuery_gpu_c.o \
                                $OBJDIR/progressBar.o \
                                $OBJDIR/StopWatch.o \
                                $OBJDIR/cmdLine.o \
                                $OBJDIR/memory.o \
                                $OBJDIR/error.o \
                                $OBJDIR/t_complex.o \
                                $OBJDIR/complex.o \
                                $OBJDIR/matrix1d.o \
                                $OBJDIR/matrix2d.o \
                                $OBJDIR/multidim_array.o \
                                $OBJDIR/funcs.o \
                                $OBJDIR/macros.o \
                                $OBJDIR/args.o \
                                $OBJDIR/numerical_recipes.o \
                                $OBJDIR/fftw.o \
                                $OBJDIR/tabfuncs.o \
                                $OBJDIR/CPlot2D.o \
                                $OBJDIR/transformations.o \
                                $OBJDIR/euler.o \
                                $OBJDIR/filename.o \
                                $OBJDIR/my_strings.o \
                                $OBJDIR/image.o \
                                $OBJDIR/metadata_container.o \
                                $OBJDIR/metadata_label.o \
                                $OBJDIR/metadata_table.o \
                                $OBJDIR/renderer.o \
                                $OBJDIR/render_particles.o \
                                $OBJDIR/render_vol.o \
                                $OBJDIR/shaders.o \
                                $OBJDIR/deepL.o \
                                $OBJDIR/saxs_gl.o \
                                $OBJDIR/saxs_HelperSimul.o \
                                $OBJDIR/saxs_particles_kernel_impl.o \
                                $OBJDIR/saxs_particleSystem.o \
                                $OBJDIR/saxs_particleSystem_cuda.o \
                                $OBJDIR/VolumeSystem.o \
                                $OBJDIR/LDMaP_HelperSimul.o \
                                $OBJDIR/LDMaP_render_volumes.o \
                                $OBJDIR/marchingCubes_kernel.o \
                                $OBJDIR/volumeRender_kernel.o \
                                $OBJDIR/simpleTexture3D_kernel.o \
                                -L $FFTW_LIB -lfftw3 \
                                -L $FFTW_LIB -lfftw3f \
                                -L $FFTW_LIB -lfftw3_threads \
                                -ltiff \
                                -lgsl \
                                -lblas \
                                -llapack \
                                -lstdc++ \
                                -lrt \
                                -lpthread \
                                -lcuda \
                                -lcublas \
                                -lcudart \
                                -lcufft \
                                -L $CUDNNDIR_LIB -lcudnn \
                                -lcurand \
                                -L $CUDADIR/lib64 \
                                -lmagma \
                                -L $MAGMADIR_LIB \
                                -lm \
                                -lGL \
                                -lGLU \
                                -lX11 \
                                -lglut \
                                -lboost_system \
                                -lboost_thread \
				$CV_LIB/libopencv_core.so \
                                $CV_LIB/libopencv_imgproc.so \
                                $CV_LIB/libopencv_highgui.so \
				$CV_LIB/libopencv_imgcodecs.so \
				$CV_LIB/libopencv_cudaimgproc.so \
				$CV_LIB/libopencv_*.so

#opencv4
#-lopencv_core \
#-lopencv_imgproc \
#-lopencv_highgui \
#-lopencv_ml \
#-lopencv_video \
#-lopencv_features2d \
#-lopencv_calib3d \
#-lopencv_objdetect \
#-lopencv_flann \
#-L $CV_LIB
#-lopencv_contrib \
#-lopencv_legacy \
#-lcudnn \
# -L /usr/lib/x86_64-linux-gnu -lQt5Widgets -lQt5Gui -lQt5Core
# $OBJDIR/xsE_cuMathFunction.o \
# -L $NVIDIA_CUDA_10_2_SAMPLES_LIB -lGLEW \
# $OBJDIR/render_vol.o \
# $OBJDIR/bodysystemcuda.o \
# $OBJDIR/renderer.o \
#					     $OBJDIR/volumeRender_kernel.o \

#-I $NVIDIA_CUDA_10_2_SAMPLES_INC \
#          -I $NVIDIA_CUDA_10_2_SAMPLES_GLINC 
					     
#"/usr/local/cuda-9.0"/bin/nvcc -ccbin g++ -I../../common/inc  -m64    -gencode arch=compute_30,code=sm_30 -gencode arch=compute_35,code=sm_35 -gencode arch=compute_37,code=sm_37 -gencode arch=compute_50,code=sm_50 -gencode arch=compute_52,code=sm_52 -gencode arch=compute_60,code=sm_60 -gencode arch=compute_70,code=sm_70 -gencode arch=compute_70,code=compute_70 -o oceanFFT.o -c oceanFFT.cpp

#"/usr/local/cuda-9.0"/bin/nvcc -ccbin g++ -I../../common/inc  -m64    -gencode arch=compute_30,code=sm_30 -gencode arch=compute_35,code=sm_35 -gencode arch=compute_37,code=sm_37 -gencode arch=compute_50,code=sm_50 -gencode arch=compute_52,code=sm_52 -gencode arch=compute_60,code=sm_60 -gencode arch=compute_70,code=sm_70 -gencode arch=compute_70,code=compute_70 -o oceanFFT_kernel.o -c oceanFFT_kernel.cu

#"/usr/local/cuda-9.0"/bin/nvcc -ccbin g++   -m64      -gencode arch=compute_30,code=sm_30 -gencode arch=compute_35,code=sm_35 -gencode arch=compute_37,code=sm_37 -gencode arch=compute_50,code=sm_50 -gencode arch=compute_52,code=sm_52 -gencode arch=compute_60,code=sm_60 -gencode arch=compute_70,code=sm_70 -gencode arch=compute_70,code=compute_70 -o oceanFFT oceanFFT.o oceanFFT_kernel.o   -lGL -lGLU -lX11 -lglut -lcufft
