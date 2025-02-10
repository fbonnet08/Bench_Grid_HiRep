####### The OpenCL paths #####

OPT_DEV_TOOLS_NVIDIA = /opt/Devel_tools/NVIDIA_GPU_Computing_SDK

                      -I $(OPT_DEV_TOOLS_NVIDIA)/OpenCL/common/inc/               \
                      -I $(OPT_DEV_TOOLS_NVIDIA)/shared/inc/                      \

                           -I $(OPT_DEV_TOOLS_NVIDIA)/OpenCL/common/inc/               \
                           -I $(OPT_DEV_TOOLS_NVIDIA)/shared/inc/                      \

                                                        \
                                -I $(DataManage_source)/src/include/relionImports          \
                                -I $(DataManage_source)/src/include/OpenGL                 \
                                -I $(DataManage_source)/cuda/include/dataManage

#-I $(DataManage_source)/src/deepLearning/FreeImage/include \
#                                -I $(DataManage_source)/src/simple_gpu/cuda/cub            \
#                                -I $(DataManage_source)/include/cuda                       \
#                                -I $(DataManage_source)/include                            \
#                                -I $(DataManage_source)/include/simple


                                                    \
                           -I $(DataManage_source)/src/include/relionImports           \
                           -I $(DataManage_source)/src/include/OpenGL                  \
                           -I $(DataManage_source)/cuda/include/dataManage
                           #$(QT_INC)


#                      -I $(DataManage_source)/src/include/relionImports           \
#                      -I $(DataManage_source)/src/include/relionImports           \
#                      -I $(DataManage_source)                                     \
#                      -I $(DataManage_source)                                     \



QT_INC= -I. -isystem $(LINUX_INC)/qt5                 \
            -isystem $(LINUX_INC)/qt5/QtPrintSupport  \
            -isystem $(LINUX_INC)/qt5/QtWidgets       \
            -isystem $(LINUX_INC)/qt5/QtGui           \
            -isystem $(LINUX_INC)/qt5/QtCore          \
            -I $(LINUX_LIB)/qt5/mkspecs/linux-g++-64

OPTION_QT= -D_REENTRANT -fPIC -DQT_PRINTSUPPORT_LIB -DQT_WIDGETS_LIB \
           -DQT_GUI_LIB -DQT_CORE_LIB


 \
         $(OPTION_QT)

        include/insert_include_files_here.hpp




