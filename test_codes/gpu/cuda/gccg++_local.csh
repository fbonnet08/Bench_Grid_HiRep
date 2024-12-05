FLNAME=`basename $1 .cpp`

GFORTRAN=g++

SOURCE_DIR=/home/frederic/Leiden/SourceCode/Simple_Restruct.projet
#/home/frederic/Yale/SourceCode/Simple_Restruct.projet
#/home/frederic/Monash/SourceCode/Simple/Restructured/HansVersion/Simple_Restruct.projet

FFTW_LIB=/usr/lib/x86_64-linux-gnu

MODDIR=$SOURCE_DIR/include/simple
OBJDIR=$SOURCE_DIR/obj/GFORTgpu

MAGMADIR=/opt/Devel_tools/magma-1.6.1
MAGMADIR_LIB=$MAGMADIR/lib

CUDADIR=/usr/local/cuda
CUDAINC=$CUDADIR/include

NVIDIA_SDK=/opt/Devel_tools/NVIDIA_GPU_Computing_SDK

SHARE_LIB=$NVIDIA_SDK/shared/lib/linux
SHARE_INC=$NVIDIA_SDK/shared/inc
SHARE_COM_INC=$NVIDIA_SDK/common/inc

NVIDIA_CUDA_8_0_SAMPLES=$CUDADIR/Samples/NVIDIA_CUDA-9.0_Samples

NVIDIA_CUDA_8_0_SAMPLES_GLINC=$NVIDIA_CUDA_8_0_SAMPLES/common/inc/GL
NVIDIA_CUDA_8_0_SAMPLES_INC=$NVIDIA_CUDA_8_0_SAMPLES/common/inc
NVIDIA_CUDA_8_0_SAMPLES_LIB=$NVIDIA_CUDA_8_0_SAMPLES/common/lib/linux/x86_64

FREEIMAGE=$SOURCE_DIR/src/deepLearning/FreeImage
FREEIMAGE_INC=$FREEIMAGE/include
FREEIMAGE_LIB=$FREEIMAGE/lib/linux/x86_64
#protocol buffers
#PROTOCB_INC=/usr/include
#PROTOCB_LIB=/usr/lib/x86_64-linux-gnu/
PROTOCB_INC=/usr/include
PROTOCB_LIB=/opt/Devel_tools/ProtoBuff_v3/cpp/protobuf-3.3.0/src/.libs/

#QT stuff
OPTION_QT="-std=c++11 -D_REENTRANT -fPIC -DQT_PRINTSUPPORT_LIB -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB "
QT_INC="-I. -isystem /usr/include/x86_64-linux-gnu/qt5 -isystem /usr/include/x86_64-linux-gnu/qt5/QtPrintSupport -isystem /usr/include/x86_64-linux-gnu/qt5/QtWidgets -isystem /usr/include/x86_64-linux-gnu/qt5/QtGui -isystem /usr/include/x86_64-linux-gnu/qt5/QtCore -I. -I. -I/usr/lib/x86_64-linux-gnu/qt5/mkspecs/linux-g++-64"

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
#-DDRAW_WIREFRAME -DQT
OPTION="-cpp -O3 -fopenmp $PLAT -DOPENMP -DBENCH -DCUDA -DMAGMA"

$GFORTRAN $OPTION $OPTION_QT \
        -I $OBJDIR -I $MODDIR -I $CUDAINC -I $SHARE_INC \
        -I $SHARE_COM_INC -I $NVIDIA_CUDA_8_0_SAMPLES_GLINC \
        -I $FREEIMAGE_INC -I $QT_INC -I $PROTOCB_INC \
        -I $NVIDIA_CUDA_8_0_SAMPLES_INC -o $FLNAME \
                                            $FLNAME.cpp \
                                            $OBJDIR/timming.o \
                                            $OBJDIR/timming_c.o \
                                            $OBJDIR/get_deviceQuery_gpu.o \
                                            $OBJDIR/get_deviceQuery_gpu_c.o \
                                            $OBJDIR/saxs_HelperSimul.o \
                                            $OBJDIR/saxs_particles_kernel_impl.o \
                                            $OBJDIR/StopWatch.o \
                                            $OBJDIR/saxs_gl.o \
                                            $OBJDIR/cmdLine.o \
                                            $OBJDIR/cudaUtils.o \
                                            $OBJDIR/saxs_Models.o \
                                            $OBJDIR/saxs_GraphAsc.o \
                                            $OBJDIR/saxs_Model_Gaussian.o \
                                            $OBJDIR/saxs_Model_MonoSphere.o \
                                            $OBJDIR/saxs_Model_MonoEllipse.o \
                                            $OBJDIR/saxs_Model_SphereGaussDoubleSizeOT.o \
                                            $OBJDIR/saxs_Model_SpherePolyDispWBkgrd.o \
                                            $OBJDIR/saxs_Model_NoModel.o \
                                            $OBJDIR/saxs_Model_Parallelepiped.o \
                                            $OBJDIR/saxs_Model_Cube.o \
                                            $OBJDIR/saxs_Utils.o \
                                            $OBJDIR/saxs_Integrators.o \
				     $OBJDIR/deepL.o \
				     $OBJDIR/deepL_ClassTemplate.o \
			     $OBJDIR/deepL_FileHandler.o \
				     $OBJDIR/deepL_ImageHandler.o \
				     $OBJDIR/deepL_PixelHandler.o \
				     $OBJDIR/deepL_ImagePacker.o \
                                             $OBJDIR/deepL_ImageIO.o \
                                             $OBJDIR/deepL_IO.o \
                                             $OBJDIR/deepL_ImagesCPU.o \
                                             $OBJDIR/deepL_ImagesNPP.o \
                                             $OBJDIR/deepL_ImagesAllocCPU.o \
                                             $OBJDIR/deepL_ImagesAllocNPP.o \
                                             $OBJDIR/deepL_Networks.o \
                                             $OBJDIR/deepL_krnl_F16.o \
                                             $OBJDIR/deepL_cpu_F16.o \
                                             $OBJDIR/deepL_Layer.o \
                                             $OBJDIR/mrcHeader.o \
                                             $OBJDIR/mrcImage.o \
                                             $OBJDIR/threadLoad.o \
                                             $OBJDIR/progressBar.o \
                                             $OBJDIR/simple_cudnn_fortran.o \
                                             $OBJDIR/deepL_BaseConv_Layer.o \
                                             $OBJDIR/deepL_Factory_Layer.o \
                                             $OBJDIR/deepL_Conv_Layer.o \
                                             $OBJDIR/deepL_CuDNNConv_Layer.o \
                                             $OBJDIR/deepL_Solver.o \
                                             $OBJDIR/deepL_Solver_factory.o \
                                             $OBJDIR/deepL_Solver_Adam.o \
                                             $OBJDIR/deepL_EMData.o \
                                             $OBJDIR/deepL_Node.o \
                                             $OBJDIR/deepL_EMCommon.o \
                                             $OBJDIR/deepL_SyncHstDevMemory.o \
                                             $OBJDIR/xsE.o \
                                             $OBJDIR/xsE_MathFunction.o \
                                             $OBJDIR/simple_ErrorHandler.o \
                                             $OBJDIR/deepL_Input_ParameterLayer.o \
                                             $OBJDIR/deepL_ParameterLayer.o \
                                             $OBJDIR/deepLEM_test.pb.o \
                                             $OBJDIR/deepLEM.pb.o \
                                             -L $FFTW_LIB -lfftw3 \
                                             -L $FFTW_LIB -lfftw3f \
                                             -L $FFTW_LIB -lfftw3_threads \
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
                                             -lcudnn \
                                             -lnppicc \
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
                                             -lopencv_core -lopencv_imgproc \
					     -lopencv_highgui -lopencv_ml \
					     -lopencv_video \
                                             -lopencv_features2d \
					     -lopencv_calib3d \
					     -lopencv_objdetect \
					     -lopencv_contrib \
                                             -lopencv_legacy -lopencv_flann \
					     -L $SHARE_LIB \
                                             -L $FREEIMAGE_LIB -lfreeimage \
                                             -L $PROTOCB_LIB -lprotobuf \
                                             -L $PROTOCB_LIB -lprotobuf-lite

# -L /usr/lib/x86_64-linux-gnu -lQt5Widgets -lQt5Gui -lQt5Core
# $OBJDIR/xsE_cuMathFunction.o \
# -L $NVIDIA_CUDA_8_0_SAMPLES_LIB -lGLEW \
# $OBJDIR/render_vol.o \
# $OBJDIR/renderer.o \
# $OBJDIR/bodysystemcuda.o \
# $OBJDIR/oceanFFT_kernel.o \
# $OBJDIR/render_particles.o \
# $OBJDIR/shaders.o \
# $OBJDIR/saxs_particleSystem_cuda.o\
# $OBJDIR/saxs_particleSystem.o \
