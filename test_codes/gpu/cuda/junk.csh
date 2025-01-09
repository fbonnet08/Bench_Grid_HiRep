 \
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
