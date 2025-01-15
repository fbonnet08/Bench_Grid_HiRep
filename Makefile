include ./src/Makefile_globVar
include Makefile_macros

# Source directories.

SRCDIRS = src

# Search directories.

vpath %.c   $(SRCDIRS)
vpath %.cpp $(SRCDIRS)
vpath %.cu  $(SRCDIRS)
vpath %.f   $(SRCDIRS)
vpath %.for $(SRCDIRS)
vpath %.t90 $(SRCDIRS)
vpath %.mpi.f90 $(SRCDIRS)
vpath %.f90 $(SRCDIRS)
vpath %.o   $(OBJDIR)

# Implicit rules.

%.o:%.c
	@printf "%b" "$(COM_COLOR)$(COM_STRING)$(CC_OBJ_COLOR) $(CCLIB) -o $(OBJDIR)/$@ -c $< $(NO_COLOR)\n"
	@$(CCLIB) -o $(OBJDIR)/$@ -c $< ; \
	RESULT=$$?; \
	$(call return_value,$$RESULT,$(CMP_OBJ_COLOR))

%.o:%.cpp
	@printf "%b" "$(COM_COLOR)$(COM_STRING)$(CPP_OBJ_COLOR) $(CPPCLIB) -o $(OBJDIR)/$@ -c $< $(NO_COLOR)\n"
	@$(CPPCLIB) -o $(OBJDIR)/$@ -c $< ; \
	RESULT=$$?; \
	$(call return_value,$$RESULT,$(CMP_OBJ_COLOR))

%.o:%.cu
	@printf "%b" "$(COM_COLOR)$(COM_STRING)$(CU_OBJ_COLOR) $(NVCCCLIB) -o $(OBJDIR)/$@ -c $< $(PTX_OUT_COLOR)\n"
	@$(NVCCCLIB) -o $(OBJDIR)/$@ -c $<; \
	RESULT=$$?; \
	$(call return_value,$$RESULT,$(CMP_OBJ_COLOR))

%.o:%.f
	@printf "%b" "$(COM_COLOR)$(COM_STRING)$(F77_OBJ_COLOR) $(F77CLIB) -o $(OBJDIR)/$@ -c $< $(NO_COLOR)\n"
	@$(F77CLIB) -o $(OBJDIR)/$@ -c $<

%.o:%.for
	$(F90CLIB77) -o $(OBJDIR)/$@ -c $<; $(F90POST)

%.o:%.t90
	./template $<
	$(F90CLIB) -o $(OBJDIR)/$@ $(basename $<).f90; $(F90POST)

%.o:%.mpi.f90
	$(MPIF90CLIB) -o $(OBJDIR)/$@ -c $<; $(MPIF90POST)

%.o:%.f90
	@printf "%b" "$(COM_COLOR)$(COM_STRING)$(F90_OBJ_COLOR) $(F90CLIB) -o $(OBJDIR)/$@ -c $< $(F90POST) $(NO_COLOR)\n"
	@$(F90CLIB) -o $(OBJDIR)/$@ -c $<

# Targets.

.PHONY: src_dataManage_code default all makedir checkclean clean cleanall robodoc check_news protocB finalCmpl wc tar detar;

default:
	@./makemake > /dev/null; \
	make --no-print-directory all

all: makedir checkclean src_dataManage_code protocB finalCmpl;

src_dataManage_code: ;

protocB:

makedir:
	@if [ ! -d $(OBJDIR) ]; \
	then \
		echo "Creating directory "$(OBJDIR)"."; \
		mkdir $(OBJDIR); \
	fi; \
	if [ ! -d $(MODDIR) ]; \
	then \
		echo "Creating directory "$(MODDIR)"."; \
		mkdir $(MODDIR); \
	fi

checkclean:
	@if [ -e CLEAN ]; \
	then \
		clean=1; \
		if [ -e $(OBJDIR)/LASTCLEAN ]; \
		then \
			if cmp -s CLEAN $(OBJDIR)/LASTCLEAN; \
			then \
				clean=0; \
			fi; \
		fi; \
		if [ $$clean -eq 1 ]; \
		then \
			make -s clean; \
			cp CLEAN $(OBJDIR)/LASTCLEAN; \
		fi \
	fi; \

clean:
	@echo "Cleaning .o and .mod files in "$(OBJDIR)"."; \
	rm -f $(OBJDIR)/*.o; \
	rm -f $(MODDIR)/*.mod; \
	rm -f $(MODDIR)/*.h

cleanall:
	@echo "Cleaning .o and .mod files in "$(OBJDIR)" and "$(OBJDIR)"/lapack/lapack95."; \
	rm -f $(OBJDIR)/*.o; \
	rm -f $(OBJDIR)/lapack/lapack95/*.o; \
	rm -f $(MODDIR)/*.mod; \
	rm -f $(MODDIR)/*.h; \
        cd ./checks/simple_LibTests/cpu_test_code; \
        pwd; \
        make clean; \
        pwd; \
        cd ./../gpu_test_code; \
        pwd; \
        make clean; \
        pwd; \
        cd ./../Clustering/; \
        pwd; \
        make clean; \
        pwd; \
        cd ./../1WCM/; \
        pwd; \
        make clean; \
        pwd; \
        cd ../../../bin/bin_tests; \
        pwd; \
        rm simple_test_*; \
        pwd; \
        cd ../; \
        pwd; \
        rm simple_*; \
        pwd; \
	cd ../src/deepLearning/proto; \
	pwd; \
	make clean; \
	cd ../../../; \
	pwd

doxygen:
robodoc:
	@echo "Building RoBoDoc documentation."; \
	make check_news > doc/robodoc/.lastnews; \
	robodoc --rc doc/robodoc/robodoc.rc; \
	cd robodoc; \
	./makemdoc;
check:
	@echo "Running building in check scenarios for simple models."; \
        export PYTHONPATH=/home/frederic/Leiden/SourceCode:; \
        export LD_LIBRARY_PATH=:/mnt/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v12.6/lib64:/usr/local/cudnn/2016-05-12/lib64:/opt/Devel_tools/magma-1.6.1/lib:/opt/Devel_tools/Relion4/BetaVersion/relion/build/lib:/usr/local/lib; \
        python ./checks/simple_LibTests/report.py --use_gpu=$(use_gpu) --bench_gpu=$(bench_gpu) --fix_gpu=$(fix_gpu) --set_gpu=$(set_gpu) --help=$(help)
bench:
	@echo "Running building in check scenarios for simple models."; \
        export PYTHONPATH=/home/frederic/Leiden/SourceCode:; \
        export LD_LIBRARY_PATH=:/mnt/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v12.6/lib64:/usr/local/cudnn/2016-05-12/lib64:/opt/Devel_tools/magma-1.6.1/lib:/opt/Devel_tools/Relion4/BetaVersion/relion/build/lib:/usr/local/lib; \
        python3 ./checks/simple_LibTests/bench.py --use_gpu=$(use_gpu) --bench_gpu=$(bench_gpu) --fix_gpu=$(fix_gpu) --set_gpu=$(set_gpu) --help=$(help)
check_help:
	@echo "Running building in check scenarios for simple models."; \
        export PYTHONPATH=/home/frederic/Leiden/SourceCode:; \
        export LD_LIBRARY_PATH=:/mnt/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v12.6/lib64:/usr/local/cudnn/2016-05-12/lib64:/opt/Devel_tools/magma-1.6.1/lib:/opt/Devel_tools/Relion4/BetaVersion/relion/build/lib:/usr/local/lib; \
        python ./checks/simple_LibTests/report.py --help
check_cpu:
	@echo "moving to directory: ./checks/simple_LibTests/cpu_test_code and compiling check codes..."; \
        cd ./checks/simple_LibTests/cpu_test_code; \
        pwd; \
        make; \
        ./run_Testing_cpu.csh; \
        cd ../../../
check_gpu:
	@echo "moving to directory: ./checks/simple_LibTests/gpu_test_code and compiling check codes..."; \
        cd ./checks/simple_LibTests/gpu_test_code; \
        pwd; \
        make; \
        export PYTHONPATH=/home/frederic/Leiden/SourceCode:; \
        export LD_LIBRARY_PATH=:/mnt/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v12.6/lib64:/usr/local/cudnn/2016-05-12/lib64:/opt/Devel_tools/magma-1.6.1/lib:/opt/Devel_tools/Relion4/BetaVersion/relion/build/lib:/usr/local/lib; \
        python ./check_gpu.py --use_gpu=$(use_gpu) --set_gpu=$(set_gpu); \
        cd ../../../
clean_check_cpu:
	@echo "moving to directory: ./checks/simple_LibTests/cpu_test_code and compiling check codes..."; \
        cd ./checks/simple_LibTests/cpu_test_code; \
        pwd; \
        make clean; \
        cd ../Clustering/; \
        make clean; \
        pwd; \
        cd ../1WCM/; \
        make clean; \
        pwd
clean_check_gpu:
	@echo "moving to directory: ./checks/simple_LibTests/gpu_test_code and compiling check codes..."; \
        cd ./checks/simple_LibTests/gpu_test_code; \
        pwd; \
        make clean
finalCmpl:
	@news=1; \
	if [ -e news/.lastnews ]; \
	then \
		if cmp -s news/news news/.lastnews; \
		then \
			news=0; \
		fi; \
	fi; \
	if [ $$news -eq 1 ]; \
	then \
		echo ""; \
		tput bold; \
		tput setaf 4; \
		echo "**************************************************************"; \
		echo "* The Bench_Grid_HiRep news:                                 *"; \
		echo "* Date: 25 Nove 2024                                         *"; \
		echo "* Date: currently partially completed,                       *"; \
		echo "*       completion anticipated ...                           *"; \
		echo "* 1.) Integration of the compilation model for Dev project   *"; \
		echo "**************************************************************"; \
		tput sgr0; \
		echo ""; \
	fi; \

check_news:
	@news=1; \
	if [ -e news/.lastnews ]; \
	then \
		if cmp -s news/news news/.lastnews; \
		then \
			news=0; \
		fi; \
	fi; \
	if [ $$news -eq 1 ]; \
	then \
		echo ""; \
		tput bold; \
		tput setaf 4; \
		echo "**************************************************************"; \
		echo "* The Bench_Grid_HiRep news:                                 *"; \
		echo "* Date: 25 Nov 2024                                          *"; \
                echo "* New Volume insertion                                       *"; \
		echo "* 1.) Read/Write lattice volumes                             *"; \
		echo "*     Images and stacks also implemented                     *"; \
		echo "*                                                            *"; \
		echo "* Next development:                                          *"; \
		echo "* Date: User development                                     *"; \
		echo "*       completion anticipated at latest in a week or two    *"; \
		echo "* 1.) OpenGL implementation ...                              *"; \
		echo "**************************************************************"; \
		tput sgr0; \
		echo ""; \
	fi; \

wc:
	@echo "Count the number of lines, words and characters in the modules."; \
	unset list; \
	DIRS="$(SRCDIRS)"; \
	for dir in $(SRCDIRS); \
	do \
		for ext in "*.c" "*.cpp" "*.cu" "*.h" "*.hpp" "*.f90" "*.f" "*.for"; \
		do \
			list=$$list" "$$(find $$dir"/" -maxdepth 1 -name "$$ext"); \
		done; \
	done; \
	wc $$list

tar:
	@echo "Creating a tar archive 'modules.tar.gz' with the modules."; \
	unset list; \
	for dir in $(SRCDIRS); \
	do \
		for ext in "*.c" "*.cpp" "*.cu" "*.h" "*.hpp" "*.f90" ".t90" "*.f" "*.for" "Makefile_*" "*.par*"; \
		do \
			list=$$list" "$$(find $$dir"/" -maxdepth 1 -name "$$ext"); \
		done; \
	done; \
	tar czvf modules.tar.gz makemake template macros/Makefile_macros* $$list

detar:
	@echo "Creating a tar backup 'modules.old.tar.gz' with the modules before unpacking the tar archive 'modules.tar.gz'."; \
	unset list; \
	for dir in $(SRCDIRS); \
	do \
		for ext in "*.c" "*.cpp" "*.cu" "*.h" "*.f90" ".t90" "*.f" "*.for" "Makefile_*" "*.par*"; \
		do \
			list=$$list" "$$(find $$dir"/" -maxdepth 1 -name "$$ext"); \
		done; \
	done; \
	tar czvf modules.old.tar.gz makemake template macros/Makefile_macros* $$list; \
	tar xzvf modules.tar.gz
