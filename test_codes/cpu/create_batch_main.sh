#!/bin/bash

# Creates the Makefile for the modules.

echo "makemake: a script that makes the Makefile"
echo

srcdirs=""
targets=""
all=""

# Scan the directories for Makefile_target files.

for dir in */;
do

  if [[ -e ${dir}Makefile_target ]];
  then

    target=$(< ${dir}Makefile_target)
    target_name=${target%%:*}
    target_name=${target_name##*[[:space:]]}

# Also scan the subdirectories.

    for subdir in ${dir}*/;
    do

      if [[ -e ${subdir}Makefile_target ]];
      then

        subtarget=$(< ${subdir}Makefile_target)
        subtarget_name=${subtarget%%:*}
        subtarget_name=${subtarget_name##*[[:space:]]}

# Also scan the sub-subdirectories !

        for subsubdir in ${subdir}*/;
        do

          if [[ -e ${subsubdir}Makefile_target ]];
          then

            subsubtarget=$(< ${subsubdir}Makefile_target)
            subsubtarget_name=${subsubtarget%%:*}
            subsubtarget_name=${subsubtarget_name##*[[:space:]]}

            if [[ -n $subsubtarget_name ]];
            then

              echo "Directory: "$subsubdir
              echo "Target name: "$subsubtarget_name
              echo "Rule: "$subsubtarget
              echo
          
              if [[ $subsubtarget_name != ".CONTROL" ]];
              then
                all=$all" "$subsubtarget_name
                srcdirs=$srcdirs" "${subsubdir%/}
              else
                subsubtarget=${subsubtarget#*:[[:space:]]*}
              fi

              targets=$targets$'\n'$subsubtarget$'\n'

            else

# Concatenate unnamed targets with the one of the parent directory.

              srcdirs=$srcdirs" "${subsubdir%/}
              subtarget=${subtarget%;*}" "${subsubtarget#:}

            fi

          fi

        done

        if [[ -n $subtarget_name ]];
        then

          echo "Directory: "$subdir
          echo "Target name: "$subtarget_name
          echo "Rule: "$subtarget
          echo
          
          if [[ $subtarget_name != ".CONTROL" ]];
          then
            all=$all" "$subtarget_name
            srcdirs=$srcdirs" "${subdir%/}
          else
            subtarget=${subtarget#*:[[:space:]]*}
          fi

          targets=$targets$'\n'$subtarget$'\n'

        else

# Concatenate unnamed targets with the one of the parent directory.

          srcdirs=$srcdirs" "${subdir%/}
          target=${target%;*}" "${subtarget#:}

        fi

      fi

    done

    echo "Directory: "$dir
    echo "Target name: "$target_name
    echo "Rule: "$target
    echo

    if [[ $target_name != ".CONTROL" ]];
    then
      all=$all" "$target_name
      srcdirs=$srcdirs" "${dir%/}
    else
      target=${target#*:[[:space:]]*}
    fi
    targets=$targets$'\n'$target$'\n'

  fi

done 

# Write the Makefile to disk.

echo "Writing the Makefile..."

cat << END > Makefile
include ./src/Makefile_globVar
include Makefile_macros

# Source directories.

SRCDIRS =$srcdirs

# Search directories.

vpath %.c   \$(SRCDIRS)
vpath %.cpp \$(SRCDIRS)
vpath %.cu  \$(SRCDIRS)
vpath %.f   \$(SRCDIRS)
vpath %.for \$(SRCDIRS)
vpath %.t90 \$(SRCDIRS)
vpath %.mpi.f90 \$(SRCDIRS)
vpath %.f90 \$(SRCDIRS)
vpath %.o   \$(OBJDIR)

# Implicit rules.

%.o:%.c
	@printf "%b" "\$(COM_COLOR)\$(COM_STRING)\$(CC_OBJ_COLOR) \$(CCLIB) -o \$(OBJDIR)/\$@ -c \$< \$(NO_COLOR)\n"
	@\$(CCLIB) -o \$(OBJDIR)/\$@ -c \$< ; \\
	RESULT=\$\$?; \\
	\$(call return_value,\$\$RESULT,\$(CMP_OBJ_COLOR))

%.o:%.cpp
	@printf "%b" "\$(COM_COLOR)\$(COM_STRING)\$(CPP_OBJ_COLOR) \$(CPPCLIB) -o \$(OBJDIR)/\$@ -c \$< \$(NO_COLOR)\n"
	@\$(CPPCLIB) -o \$(OBJDIR)/\$@ -c \$< ; \\
	RESULT=\$\$?; \\
	\$(call return_value,\$\$RESULT,\$(CMP_OBJ_COLOR))

%.o:%.cu
	@printf "%b" "\$(COM_COLOR)\$(COM_STRING)\$(CU_OBJ_COLOR) \$(NVCCCLIB) -o \$(OBJDIR)/\$@ -c \$< \$(PTX_OUT_COLOR)\n"
	@\$(NVCCCLIB) -o \$(OBJDIR)/\$@ -c \$<; \\
	RESULT=\$\$?; \\
	\$(call return_value,\$\$RESULT,\$(CMP_OBJ_COLOR))

%.o:%.f
	@printf "%b" "\$(COM_COLOR)\$(COM_STRING)\$(F77_OBJ_COLOR) \$(F77CLIB) -o \$(OBJDIR)/\$@ -c \$< \$(NO_COLOR)\n"
	@\$(F77CLIB) -o \$(OBJDIR)/\$@ -c \$<

%.o:%.for
	\$(F90CLIB77) -o \$(OBJDIR)/\$@ -c \$<; \$(F90POST)

%.o:%.t90
	./template \$<
	\$(F90CLIB) -o \$(OBJDIR)/\$@ \$(basename \$<).f90; \$(F90POST)

%.o:%.mpi.f90
	\$(MPIF90CLIB) -o \$(OBJDIR)/\$@ -c \$<; \$(MPIF90POST)

%.o:%.f90
	@printf "%b" "\$(COM_COLOR)\$(COM_STRING)\$(F90_OBJ_COLOR) \$(F90CLIB) -o \$(OBJDIR)/\$@ -c \$< \$(F90POST) \$(NO_COLOR)\n"
	@\$(F90CLIB) -o \$(OBJDIR)/\$@ -c \$<

# Targets.

.PHONY:$all default all makedir checkclean clean cleanall robodoc check_news protocB finalCmpl wc tar detar;

default:
	@./makemake > /dev/null; \\
	make --no-print-directory all

all: makedir checkclean$all protocB finalCmpl;
$targets
protocB:

makedir:
	@if [ ! -d \$(OBJDIR) ]; \\
	then \\
		echo "Creating directory "\$(OBJDIR)"."; \\
		mkdir \$(OBJDIR); \\
	fi; \\
	if [ ! -d \$(MODDIR) ]; \\
	then \\
		echo "Creating directory "\$(MODDIR)"."; \\
		mkdir \$(MODDIR); \\
	fi

checkclean:
	@if [ -e CLEAN ]; \\
	then \\
		clean=1; \\
		if [ -e \$(OBJDIR)/LASTCLEAN ]; \\
		then \\
			if cmp -s CLEAN \$(OBJDIR)/LASTCLEAN; \\
			then \\
				clean=0; \\
			fi; \\
		fi; \\
		if [ \$\$clean -eq 1 ]; \\
		then \\
			make -s clean; \\
			cp CLEAN \$(OBJDIR)/LASTCLEAN; \\
		fi \\
	fi; \\

clean:
	@echo "Cleaning .o and .mod files in "\$(OBJDIR)"."; \\
	rm -f \$(OBJDIR)/*.o; \\
	rm -f \$(MODDIR)/*.mod; \\
	rm -f \$(MODDIR)/*.h

cleanall:
	@echo "Cleaning .o and .mod files in "\$(OBJDIR)" and "\$(OBJDIR)"/lapack/lapack95."; \\
	rm -f \$(OBJDIR)/*.o; \\
	rm -f \$(OBJDIR)/lapack/lapack95/*.o; \\
	rm -f \$(MODDIR)/*.mod; \\
	rm -f \$(MODDIR)/*.h; \\
        cd ./checks/simple_LibTests/cpu_test_code; \\
        pwd; \\
        make clean; \\
        pwd; \\
        cd ./../gpu_test_code; \\
        pwd; \\
        make clean; \\
        pwd; \\
        cd ./../Clustering/; \\
        pwd; \\
        make clean; \\
        pwd; \\
        cd ./../1WCM/; \\
        pwd; \\
        make clean; \\
        pwd; \\
        cd ../../../bin/bin_tests; \\
        pwd; \\
        rm simple_test_*; \\
        pwd; \\
        cd ../; \\
        pwd; \\
        rm simple_*; \\
        pwd; \\
	cd ../src/deepLearning/proto; \\
	pwd; \\
	make clean; \\
	cd ../../../; \\
	pwd

robodoc:
	@echo "Building RoBoDoc documentation."; \\
	make check_news > doc/robodoc/.lastnews; \\
	robodoc --rc doc/robodoc/robodoc.rc; \\
	cd robodoc; \\
	./makemdoc;
check:
	@echo "Running building in check scenarios for simple models."; \\
        export PYTHONPATH=${PYTHONPATH}; \\
        export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}; \\
        python ./checks/simple_LibTests/report.py --use_gpu=\$(use_gpu) --bench_gpu=\$(bench_gpu) --fix_gpu=\$(fix_gpu) --set_gpu=\$(set_gpu) --help=\$(help)
bench:
	@echo "Running building in check scenarios for simple models."; \\
        export PYTHONPATH=${PYTHONPATH}; \\
        export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}; \\
        python3 ./checks/simple_LibTests/bench.py --use_gpu=\$(use_gpu) --bench_gpu=\$(bench_gpu) --fix_gpu=\$(fix_gpu) --set_gpu=\$(set_gpu) --help=\$(help)
check_help:
	@echo "Running building in check scenarios for simple models."; \\
        export PYTHONPATH=${PYTHONPATH}; \\
        export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}; \\
        python ./checks/simple_LibTests/report.py --help
check_cpu:
	@echo "moving to directory: ./checks/simple_LibTests/cpu_test_code and compiling check codes..."; \\
        cd ./checks/simple_LibTests/cpu_test_code; \\
        pwd; \\
        make; \\
        ./run_Testing_cpu.csh; \\
        cd ../../../
check_gpu:
	@echo "moving to directory: ./checks/simple_LibTests/gpu_test_code and compiling check codes..."; \\
        cd ./checks/simple_LibTests/gpu_test_code; \\
        pwd; \\
        make; \\
        export PYTHONPATH=${PYTHONPATH}; \\
        export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}; \\
        python ./check_gpu.py --use_gpu=\$(use_gpu) --set_gpu=\$(set_gpu); \\
        cd ../../../
clean_check_cpu:
	@echo "moving to directory: ./checks/simple_LibTests/cpu_test_code and compiling check codes..."; \\
        cd ./checks/simple_LibTests/cpu_test_code; \\
        pwd; \\
        make clean; \\
        cd ../Clustering/; \\
        make clean; \\
        pwd; \\
        cd ../1WCM/; \\
        make clean; \\
        pwd
clean_check_gpu:
	@echo "moving to directory: ./checks/simple_LibTests/gpu_test_code and compiling check codes..."; \\
        cd ./checks/simple_LibTests/gpu_test_code; \\
        pwd; \\
        make clean
finalCmpl:
	@news=1; \\
	if [ -e news/.lastnews ]; \\
	then \\
		if cmp -s news/news news/.lastnews; \\
		then \\
			news=0; \\
		fi; \\
	fi; \\
	if [ \$\$news -eq 1 ]; \\
	then \\
		echo ""; \\
		tput bold; \\
		tput setaf 4; \\
		echo "**************************************************************"; \\
		echo "* The DataManage news:                                       *"; \\
		echo "* Date: 23 Aug 2022                                          *"; \\
		echo "* Date: currently partially completed,                       *"; \\
		echo "*       completion anticipated at latest August 2022         *"; \\
		echo "* 1.) Integration of the compilation model for Dev project   *"; \\
		echo "* 2.) Volume reader/Writter integration IO project           *"; \\
		echo "* 3.) VTK Volume rendering from the IO using MRC handling    *"; \\
		echo "**************************************************************"; \\
		tput sgr0; \\
		echo ""; \\
	fi; \\

check_news:
	@news=1; \\
	if [ -e news/.lastnews ]; \\
	then \\
		if cmp -s news/news news/.lastnews; \\
		then \\
			news=0; \\
		fi; \\
	fi; \\
	if [ \$\$news -eq 1 ]; \\
	then \\
		echo ""; \\
		tput bold; \\
		tput setaf 4; \\
		echo "**************************************************************"; \\
		echo "* The DataManage news:                                       *"; \\
		echo "* Date: 23 Aug 2022                                          *"; \\
                echo "* New Volume insertion                                       *"; \\
		echo "* 1.) Read/Write volumes 3D class in C++ inserted            *"; \\
		echo "*     Images and stacks also implemented                     *"; \\
		echo "*                                                            *"; \\
		echo "* Next development:                                          *"; \\
		echo "* Date: Unser development                                    *"; \\
		echo "*       completion anticipated at latest in a week or two    *"; \\
		echo "* 1.) OpenGL implementation for trhe volume rendering        *"; \\
		echo "* 2.) VTK library inssertion for 2D/3D                       *"; \\
		echo "**************************************************************"; \\
		tput sgr0; \\
		echo ""; \\
	fi; \\

wc:
	@echo "Count the number of lines, words and characters in the modules."; \\
	unset list; \\
	DIRS="\$(SRCDIRS)"; \\
	for dir in \$(SRCDIRS); \\
	do \\
		for ext in "*.c" "*.cpp" "*.cu" "*.h" "*.f90" "*.f" "*.for"; \\
		do \\
			list=\$\$list" "\$\$(find \$\$dir"/" -maxdepth 1 -name "\$\$ext"); \\
		done; \\
	done; \\
	wc \$\$list

tar:
	@echo "Creating a tar archive 'modules.tar.gz' with the modules."; \\
	unset list; \\
	for dir in \$(SRCDIRS); \\
	do \\
		for ext in "*.c" "*.cpp" "*.cu" "*.h" "*.f90" ".t90" "*.f" "*.for" "Makefile_*" "*.par*"; \\
		do \\
			list=\$\$list" "\$\$(find \$\$dir"/" -maxdepth 1 -name "\$\$ext"); \\
		done; \\
	done; \\
	tar czvf modules.tar.gz makemake template macros/Makefile_macros* \$\$list

detar:
	@echo "Creating a tar backup 'modules.old.tar.gz' with the modules before unpacking the tar archive 'modules.tar.gz'."; \\
	unset list; \\
	for dir in \$(SRCDIRS); \\
	do \\
		for ext in "*.c" "*.cpp" "*.cu" "*.h" "*.f90" ".t90" "*.f" "*.for" "Makefile_*" "*.par*"; \\
		do \\
			list=\$\$list" "\$\$(find \$\$dir"/" -maxdepth 1 -name "\$\$ext"); \\
		done; \\
	done; \\
	tar czvf modules.old.tar.gz makemake template macros/Makefile_macros* \$\$list; \\
	tar xzvf modules.tar.gz
END
