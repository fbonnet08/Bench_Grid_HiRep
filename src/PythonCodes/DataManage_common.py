#!/usr/bin/env python3
'''!\file
   -- DataManage addon: (Python3 code) class for handling all of the common 
      variables
      \author Frederic Bonnet
      \date 13th of February 2020

      Leiden University February 2020
      Modified Obs/University of Perpignan 2024

Name:
---
DataManage_common: class DataManage_common for handling all of the common
variables

Description of classes:
---
This class generates an object that contains all of the common varaiables that
passes around the applicationm and beyond. It avoids multiple refdefinitions
of variables and allow transportability accross applicatuions.

Requirements (system):
---
* sys
* os
* inspect

'''
#-------------------------------------------------------------------------------
# Common definitions and methods
# Author: Frederic Bonnet
# Date: 13/02/2020
#-------------------------------------------------------------------------------
#System tools
import os
import sys
import inspect
#application imports
#-------------------------------------------------------------------------------
# Versioning of the DataManage application
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#Sets the version number of the application
#version: 1.95
def DataManage_version():
    datamanage_version = "1.0"
    return datamanage_version
def MolRefAnt_version():
    molrefant_version = "0.0.1"
    return molrefant_version
#-------------------------------------------------------------------------------
# DataManage_krnl_gpu.soVersioning of the DataManage application
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#Sets the default value for the lib .so cuda kernel library 
#File: DataManage_krnl-cuda-V9.0.102-sm35_gpu.so
def DataManage_krnl_libSO():
    #Sets the default value for the lib .so cuda kernel library 
    #"DataManage_krnl-cuda-V9.0.102-sm35_gpu.so"
    lib = "DataManage_krnl-cuda-V10.1.105-sm35_gpu.so"
    return lib
#-------------------------------------------------------------------------------
# Start of the test script
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#DataManage common object definition.
#*******************************************************************************
class DataManage_common:
    #***************************************************************************
    ##\brief Python3 method.
    #DataManage_common class constructor
    #***************************************************************************
    #\param self     Self object
    def __init__(self):
        self.undr_scr = "_"
        self.dot = "."
        self.use_gpu = False
        self.gpu_list = "0"
        self.gpu_list_class2d = "0"
        self.gpu_list_init3d = "0"
        self.gpu_list_class3d = "0"
        self.gpu_list_refine3d = "0"
        # Debugger switches
        self.debug           = 0   #True:1 False:0
        self.debug_cpu       = 0   #false
        self.debug_high      = 0   #true
        self.debug_write     = 0   #false
        self.debug_write_C   = 0   #false
        self.set_gpu         = 0
        # File extension
        self.file_extension  = ".json"
        # GUI switch
        self.showGUI = True
        self.bench_cpu = False
        self.app_root = "./"
        self.projectName = "./"
        self.data_path = "./"
        self.gainmrc = "./"
        self.targetdir = "./"
        self.sourcedir = "./"
        self.software = "specify_if_needed" # "EPU-2.10.5\+"
        self.poolify = "no"
        self.superRes = "no"
        self.movies_ext = "mrc"
        self.live_process = "yes"
        self.use_MotionCorr = 0
        self.use_CTFfind = 0
        self.use_unblur = 0
        self.file_frame_copy_move_handler = "copy"
        self.file_pre_handler = "preprocess"
        self.file_organise_dir = "or"
        self.file_pst_handler = "extract_data"
        self.ctffind_dir = "/opt/Devel_tools/CTFfind/ctffind-4.1.18/bin_compat/"
        self.motioncorr_dir = "/opt/Devel_tools/MotionCor2_v1.3.1/"
        self.relionDir = "/opt/Devel_tools/Relion3.1/relion-ver3.1/build/bin"
        self.json_scan_dir = "/scratch/DataProcInterCom"
        self.sql_dir = "SQLFiles_sql"
        self.sql_fullPath_dir = "./SQLFiles_sql"
        self.table_cnts_dir = os.path.join(self.json_scan_dir,'TableCounts')
        #Markers for command lines execution
        self.doBenchMarking_Marker = ""
        self.ptcl_pick_extract_Marker = ""
        self.class2d_Marker = ""
        self.init3d_marker = ""
        self.class3d_marker = ""
        self.refine3d_marker = ""
        self.fullPipeLine_marker = ""
        self.insert_into_web_marker = "--insert_into_web" # Here initialliazed to value because of test
        #Pre-procssing initialiasization of variables
        self.nframes          = 50     #TODO: Include number frames unblur
        self.sph_abe          = 2.7    #sphererical aberration
        self.amp_con          = 0.10   #Ampl constrast (from 0.07 06Nov21)
        self.sze_pwr_spc      = 512    #Size of prower spectrum 
        self.minres           = 30.0   #Minimum resolution
        self.maxres           = 5.0    #Maximum resolution
        self.mindef           = 5000   #Minimum defocus  "3100.0"06Nov21
        self.maxdef           = 50000  #Maximum defocus  "6900.0"06Nov21
        self.defstep          = 500.0  #Defocus search step
        self.is_astig         = "no"   #Is astigmatism present{no}
        self.vl_astig         = "yes"  #Is large astigmatism expected?{yes}
        self.restrt_astig     = "yes"  #Restrain astigmatism? {yes}
        self.astigpenaltyover = 1500.0 #Expected \(tolerated\) astig
        self.expert_op        = "no"   #Set to expert options {no}
        self.phaseshift       = "no"   #Find additional phase shift
        self.data_rot         = -90    #Rot angle for Size of power spec.
        self.target_file      = 'target.txt' #Name of output file list
        self.init_target_file = 'target.txt' #Name of output file list

        self.fm_dose = 1.0
        self.bfactor = 150
        self.binning_factor = 1
        self.gain_rotation = 0
        self.gain_flip = 0
        self.pool_targetdir = "_Pool"
        self.pool_componentdir = "_Pool"
        self.gain_type = "x0.m0"
        #Rest API variable
        self.api_key = "123456789"    #Some Api Key
        sysver, platform, system, release, node, processor, cpu_count = whichPlatform()
        self.sysver = sysver
        self.platform = platform
        self.system = system
        self.release = release
        self.node = node
        self.processor = processor
        self.cpu_count = cpu_count
        # Pick and Extract Post Processing variables
        self.ctf_star = "app_ctf_corrected_micrographs.star"
        self.nboot = 0
        self.log_dia_min = 160
        self.log_dia_max = 250
        self.lowpass = 20
        self.LoG_adjust_threshold = 0
        self.LoG_upper_threshold = 999
        self.n_mpi_proc_extract = self.cpu_count
        self.extract_size = 400
        self.particle_diameter = 180
        # Class2D Post Processing variables
        self.ctf_intact_first_peak = "no"
        self.n_mpi_proc_cl2D = 11
        self.n_thrds_cl2D = 8
        self.n_classes2D = 15
        self.n_iterClss2D = 25
        self.n_mskDClss2D = 200
        self.n_poolClss2D = 100
        # InitialModelling Init3D
        self.n_mpi_proc_init3D = 5
        self.n_thrds_init3D = 4
        self.do_ctf_correction_init3D = "yes"
        self.symmetryInit3D = "C1"
        self.offset_search_range_init3D = 6
        self.offset_search_step_init3D = 2
        self.n_mskDInit3D = 200
        self.n_poolinit3d = 100
        self.nclassInit3D = 1
        # Class3D
        self.do_ctf_correction_class3D = "yes"
        self.has_ctf_correction_class3D = "no"
        self.nclassClass3D = 5
        self.n_iterClass3D = 25
        self.n_mskDClass3D = 200
        self.n_poolClass3D = 100
        self.n_poolInit3D = 100
        self.symmetryClass3D = "C1"
        self.offset_search_range_class3D = 5
        self.offset_search_step_class3D = 2
        self.n_mpi_proc_class3d = 5
        self.n_thrds_class3d = 4
        #refine3D
        self.do_ctf_correction_refine3D = "yes"
        self.has_ctf_correction_refine3D = "no"
        self.nclassRefine3D = 1
        self.n_mskDRefine3D = 200
        self.n_poolRefine3D =100
        self.symmetryRefine3D = "C1"
        self.offset_search_range_refine3D = 5
        self.offset_search_step_refine3D = 2
        self.n_mpi_proc_refine3d = 5
        self.n_thrds_refine3d = 4
        #Activator for the workflow in question
        self.workflow_activator = ""
        #Relion stuff variables
        self.relionPath          = "Relion"
        self.relionPath_fullpath = os.path.sep+"Relion"
        self.CTFStar          = "app_ctf_corrected_micrographs.star"
        self.mc2Star          = "app_ctf_corrected_micrographs.star"
        self.CTFStar_fullPath = os.path.sep + "Relion" + os.path.sep + "app_ctf_corrected_micrographs.star"
        self.mc2Star_fullPath = os.path.sep + "Relion" + os.path.sep + "app_mc2_corrected_micrographs.star"
        self.current_AllTableCount_json_file = "current_AllTableCount_rec.json"
        self.with_while_loop  = "standard"
        self.plot_asc = "copy.asc"
        self.csvfile = "netUse.csv"
        self.rawfile = "mzmineRaw.raw"
        self.mgffile = "mzmineRaw.mgf"
        self.DataProcInterCom = os.path.join('E:','DataProcInterCom')
        self.rawfile_path = "."+os.sep
        self.rawfile_full_path_no_ext = "."+os.sep

        self.pubchem_url = "https://pubchem.ncbi.nlm.nih.gov/compound/"
        self.database_origin = "FragHub"  # [FragHub, LC-MS, MONA]
        self.database_extension = "mgf"
        self.import_db = "full_path/some_db.txt"
        self.export_db = "full_path/some_db.txt"
        self.import_external_db = "full_path/some_db.txt"
        self.export_external_db = "full_path/some_db.txt"
        self.import_db_set = "single"   # [single, multi]
        self.database_path = "./"
        self.database_name = "some_db"
        self.database_schema = "some_schema"
        self.database_full_path_no_ext = "./some_db"
        self.database_file = "some_db.txt"
        self.database_port = 1234
        self.database_server = "server name"
        self.cursor = None
        self.queryMsSQL = None

        self.insert_into_web = "no"

        self.file_basename = "file_basename"
        self.jsontargetdir = "./"
        self.quantum_computing = "no"

        # [Bench_Grid_HiRep]
        self.bkeeper_action = "set action=[BKeeper_run_cpu, BKeeper_run_gpu]"
        self.grid = "no"
        self.HiRep = "no"

        # Machine learning parameters
        self.machine_learning = "no"
        self.batch_size = 64
        self.num_classes = 10
        self.learning_rate = 0.01
        self.num_epochs = 50
        # Bench_Grid_HiRep

        # Mass specytroscopy parameters
        self.scan_number = 1
        self.Ret_time = 1.23
        self.pepmass = 123.456
        self.charge = 0
        self.MSLevel = 1
        self.begin_ions = "BEGIN IONS"
        self.end_ions = "END IONS"

        # Computation and processing [serial, parrallell, multiprocessing]
        self.multiprocessing_type = "serial"   # [serial, parrallle, multithreaded]

        #TODO: If statement will be removed after checking
        if (system == 'Linux'):
            sys.path.append(os.path.join(os.getcwd(), 'utils'))
            #sys.path.append('./utils')
        elif (system == 'Darwin'):
            sys.path.append(os.path.join(os.getcwd(), 'utils'))
            #sys.path.append('./utils')
        elif (system == 'Windows'):
            sys.path.append(os.path.join(os.getcwd(), 'utils'))
            #Windows_warningMessage()
        self.initialize()
    #---------------------------------------------------------------------------
    # class methods
    #---------------------------------------------------------------------------
    #***************************************************************************
    ##\brief Python3 method.
    #Method to get info about the methods equivalent to
    #\param self     Self object
    #(__FILE__,__FUNCTION__,__LINE__) in C/C++/CUDA-C.
    #\return info    Inspected information on getframeinfo method.
    def GetFrameInfo(self):
        inspector = inspect.stack()[1]
        frame = inspector[0]
        info = inspect.getframeinfo(frame)
        return info
    #***************************************************************************
    ##\brief Python3 method.
    #initialises the variables
    #\param self     Self object
    def initialize(self):
        '''!
        Initializes all of the common varaibles
        '''
        #Name of the logfile
        self.logfilename         = "dataManages.log"
        self.logfilename_testing = "testing.log"
        self.logGatan_PC_K3_GUI  = "gatan_PC_K3_GUIs.log"
        self.logMolRefAnt_DB_GUI = "molrefant_DB_GUIs.log"

        self.logQuantumComputing = "quantumComputing.log"

        self.logBKeeperAction    = "bkeeperAction.log"
        self.logGrid             = "grid.log"
        self.logHiRep            = "hirep.log"

        self.logGatan_PC_K3_fileMover = "gatan_PC_K3_fileMover.log"
        self.logGatan_PC_K3_gainRefMover = "gatan_PC_K3_gainRefMover.log"
        self.logDelayed_copy = "delayeds_copy_RSyncer.log"
        self.lib                = DataManage_krnl_libSO()
        #return codes
        self.RC_SUCCESS         =  0
        self.RC_FAIL            = -1
        self.RC_STOP            = -3
        self.RC_WARNING         = -4
        self.RC_CUDA_LIB        = -5
        #general symbols
        self.sl_brck            = "["
        self.sr_brck            = "]"
        self.g_than             = ">"
        self.l_than             = "<"
        self.undscr             = "_"   # underscore
        self.sptr               = "/"   # set the name for the separator.
        self.b_sptr             = "\\"  # set the name for the separator.
        self.all                = "*"   # unix commands for all files eg: file*
        self.eq                 = "="   # equal sign for file writting
        self.mrc_ext            = ".mrc"
        self.spi_ext            = ".spi"
        self.map_ext            = ".map"
        self.mgf_ext            = ".mgf"
        self.txt_ext            = ".txt"
        self.json_ext           = ".json"
        self.csv_ext            = ".csv"
        self.xls_ext            = ".xls"
        self.local_path         = os.getcwd()
        #Scope details default values
        self.collection_speed   = 100
        self.frames_sample_rate = 10
        #colors standard
        #if (self.system == 'Linux' or self.system == 'Darwin' or self.system == 'CYGWIN_NT-10.0-18363'):
        if (self.system != 'Windows'):
            self.red           = "\033[0;91m"
            self.green         = "\033[0;92m"
            self.yellow        = "\033[0;93m"
            self.blue          = "\033[0;94m"
            self.magenta       = "\033[0;95m"
            self.cyan          = "\033[0;96m"
            self.white         = "\033[0;97m"
            #colors bolds
            self.b_red         = "\033[1;91m"
            self.b_green       = "\033[1;92m"
            self.b_yellow      = "\033[1;93m"
            self.b_blue        = "\033[1;94m"
            self.b_magenta     = "\033[1;95m"
            self.b_cyan        = "\033[1;96m"
            self.b_white       = "\033[1;97m"
            #colors underline
            self.u_red         = "\033[4;91m"
            self.u_green       = "\033[4;92m"
            self.u_yellow      = "\033[4;93m"
            self.u_blue        = "\033[4;94m"
            self.u_magenta     = "\033[4;95m"
            self.u_cyan        = "\033[4;96m"
            self.u_white       = "\033[4;97m"
            #colors reset
            self.c_reset       = "\033[0m"
            self.bold          = "\033[01m"
            self.disable       = "\033[02m"
            self.underline     = "\033[04m"
            self.reverse       = "\033[07m"
            self.strikethrough = "\033[09m"
            self.invisible     = "\033[08m"
            #elif (self.system != 'Linux' or self.system != 'Darwin'):
        elif (self.system == 'Windows'):
            self.red           = "\033[0;91m"
            self.green         = "\033[0;92m"
            self.yellow        = "\033[0;93m"
            self.blue          = "\033[0;94m"
            self.magenta       = "\033[0;95m"
            self.cyan          = "\033[0;96m"
            self.white         = "\033[0;97m"
            #colors bolds
            self.b_red         = "\033[1;91m"
            self.b_green       = "\033[1;92m"
            self.b_yellow      = "\033[1;93m"
            self.b_blue        = "\033[1;94m"
            self.b_magenta     = "\033[1;95m"
            self.b_cyan        = "\033[1;96m"
            self.b_white       = "\033[1;97m"
            #colors underline
            self.u_red         = "\033[4;91m"
            self.u_green       = "\033[4;92m"
            self.u_yellow      = "\033[4;93m"
            self.u_blue        = "\033[4;94m"
            self.u_magenta     = "\033[4;95m"
            self.u_cyan        = "\033[4;96m"
            self.u_white       = "\033[4;97m"
            #colors reset
            self.c_reset       = "\033[0m"
            self.bold          = "\033[01m"
            self.disable       = "\033[02m"
            self.underline     = "\033[04m"
            self.reverse       = "\033[07m"
            self.strikethrough = "\033[09m"
            self.invisible     = "\033[08m"
            '''
            self.red           = ""
            self.green         = ""
            self.yellow        = ""
            self.blue          = ""
            self.magenta       = ""
            self.cyan          = ""
            self.white         = ""
            #colors bolds
            self.b_red         = ""
            self.b_green       = ""
            self.b_yellow      = ""
            self.b_blue        = ""
            self.b_magenta     = ""
            self.b_cyan        = ""
            self.b_white       = ""
            #colors underline
            self.u_red         = ""
            self.u_green       = ""
            self.u_yellow      = ""
            self.u_blue        = ""
            self.u_magenta     = ""
            self.u_cyan        = ""
            self.u_white       = ""
            #colors reset
            self.c_reset       = ""
            self.bold          = ""
            self.disable       = ""
            self.underline     = ""
            self.reverse       = ""
            self.strikethrough = ""
            self.invisible     = ""
            '''
    #---------------------------------------------------------------------------
    # [System]: sysver, platform, system, release, node, processor, cpu_count
    #---------------------------------------------------------------------------
    def get_sysver(self): return self.sysver
    def get_platform(self): return self.platform
    def get_system(self):  return self.system
    def get_release(self): return self.release
    def get_node(self): return self.node
    def get_processor(self): return self.processor
    def get_cpu_count(self): return self.cpu_count
    #---------------------------------------------------------------------------
    # [Setters]: methods
    #---------------------------------------------------------------------------
    #logical variables
    def setBench_cpu(self,doBenchMarking):
        self.bench_cpu = doBenchMarking
    #logical variables
    def setShow_gui(self,showGUI):
        self.showGUI = showGUI
    #Set_gpu
    def setSet_gpu(self,set_gpu):
        self.set_gpu = set_gpu
    #lib filename
    def setLibfileName(self,lib):
        self.lib = lib
    #DataManage application main common values
    def setApp_root(self,app_root):
        self.app_root = app_root
    def setProjectName(self, projectName):
        self.projectName = projectName
    def setData_path(self, data_path):
        self.data_path = data_path
    def setGainmrc(self, gainmrc):
        self.gainmrc = gainmrc
    def setTargetdir(self, targetdir):
        self.targetdir = targetdir
    #software = self.software_SP
    def setSoftware(self, software):
        self.software = software
    #Marker variables doBenchMarking = self.doBenchMarking.get()
    def setdoBenchMarking_marker(self, doBenchMarking_Marker):
        self.doBenchMarking_Marker = doBenchMarking_Marker
    #---------------------------------------------------------------------------
    # [MolRefAnt]
    def setInsert_into_web_Marker(self, insert_into_web_marker):
        self.insert_into_web_marker = insert_into_web_marker
    def setInsert_into_web(self, insert_into_web):
        self.insert_into_web = insert_into_web

    #useGpu = self.use_gpu.get() alreday done with setUse_gpu
    def setUse_gpu(self, use_gpu):
        self.use_gpu = use_gpu
    #gpuList = self.gpu_list.get() alreday done with setGpu_list
    def setGpu_list(self, gpu_list):
        self.gpu_list = gpu_list
    #poolify = self.poolify.get()
    def setPoolify(self, poolify):
        self.poolify = poolify
    #superRes = self.super_res.get()
    def setSuper_Res(self, superRes):
        self.superRes = superRes
    #movies_ext = self.movies_ext
    def setMovies_ext(self, movies_ext):
        self.movies_ext = movies_ext
    #live_process = self.live_process
    def setLive_process(self, live_process):
        self.live_process = live_process
    #--use_unblur=0---> checkBox
    def setUse_unblur(self, use_unblur):
        self.use_unblur = use_unblur
    #--use_MotionCorr=0---> checkBox
    def setUse_MotionCorr(self, use_MotionCorr):
        self.use_MotionCorr = use_MotionCorr
    #--use_CTFfind=0---> checkBox
    def setUse_CTFfind(self, use_CTFfind):
        self.use_CTFfind = use_CTFfind
    #--file_frame_copy_move_handler=copy---> radioButton
    def setFile_frame_copy_move_handler(self, file_frame_copy_move_handler):
        self.file_frame_copy_move_handler = file_frame_copy_move_handler
    #--file_pre_handler=preprocess---> checkBox
    def setFile_pre_handler(self, file_pre_handler):
        self.file_pre_handler = file_pre_handler
    #--file_organise_dir=re---> Combo box
    def setFile_organise_dir(self, file_organise_dir):
        self.file_organise_dir = file_organise_dir
    #--file_pst_handler=extract_data---> combo box
    def setFile_pst_handler(self, file_pst_handler):
        self.file_pst_handler = file_pst_handler
    #--motioncorr_dir=MOTIONCORR_DIR
    def setMotionCorr_dir(self, motioncorr_dir):
        self.motioncorr_dir = motioncorr_dir
    #--ctffind_dir=CTFFIND_DIR
    def setCTFFind_dir(self, ctffind_dir):
        self.ctffind_dir = ctffind_dir
    #---------------------------------------------------------------------------
    # [Pre-Proc-CTFFind] Setters for CTFFind Pre- processing
    #--->ctfFind
    #--nframes=NFRAMES              [50] TODO: Include number frames unblur
    def setNframes(self, nframes):
        self.nframes = nframes
    #--sph_abe=SPH_ABE              [2.7] Sphererical Aberration
    def setSph_Abe(self,  sph_abe):
        self.sph_abe = sph_abe
    #--amp_con=AMP_CON              [0.10] Ampl constrast (from 0.07 06Nov21)
    def setAmp_Con(self, amp_con):
        self.amp_con = amp_con
    #--sze_pwr_spc=SZE_PWR_SPC      [512] Size of prower spectrum 
    def setSze_Pwr_Spc(self, sze_pwr_spc):
        self.sze_pwr_spc = sze_pwr_spc
    #--minres=MINRES                [30.0] Minimum resolution
    def setMinRes(self, minres):
        self.minres = minres
    #--maxres=MAXRES                [5.0] Maximum resolution
    def setMaxRes(self, maxres):
        self.maxres = maxres
    #--mindef=MINDEF                [5000] Minimum defocus "3100.0"06Nov21
    def setMinDef(self, mindef):
        self.mindef = mindef
    #--maxdef=MAXDEF                [50000] Maximum defocus "6900.0"06Nov21
    def setMaxDef(self, maxdef):
        self.maxdef = maxdef
    #--defstep=DEFSTEP              [500.0] Defocus search step
    def setDefStep(self, defstep ):
        self.defstep = defstep
    #--is_astig=IS_ASTIG            ["no"] Is astigmatism present{no}
    def setIs_Astig(self, is_astig):
        self.is_astig = is_astig
    #--vl_astig=vl_astig            ["yes"] Is large astigmatism expected?{yes}
    def setVl_Astig(self, vl_astig):
        self.vl_astig = vl_astig
    #--restrt_astig=RESTRT_ASTIG    ["yes"] Restrain astigmatism? {yes}
    def setReStrt_Astig(self, restrt_astig):
        self.restrt_astig = restrt_astig
    #--astigpenaltyover=ASTIGPENALTYOVER   [1500.0] Expected \(tolerated\) astig
    def setAstigPenaltyOver(self, astigpenaltyover):
        self.astigpenaltyover = astigpenaltyover
    #--expert_op=EXPERT_OP          ["no"] Set to expert options {no}
    def setExpert_Op(self, expert_op ):
        self.expert_op = expert_op
    #--phaseshift=PHASESHIFT        ["no"] Find additional phase shift
    def setPhaseShift(self, phaseshift):
        self.phaseshift = phaseshift
    #--data_rot=DATA_ROT            [-90] Rot angle for Size of power spec.
    def setData_Rot (self, data_rot):
        self.data_rot = data_rot
    #--target_file=TARGET_FILE  ['target.txt']Output file list
    def setTarget_File(self, target_file):
        self.target_file = target_file
    #---------------------------------------------------------------------------
    # [Pre-Proc-MotionCorr] Getters for MotionCorr Pre- processing
    #--->MotionCorr
    #--fm_dose=FM_DOSE        string--->textfield
    def setFMDose(self, fm_dose):
        self.fm_dose = fm_dose
    #--bfactor=150 int--->textfield
    def setBfactor(self, bfactor):
        self.bfactor = bfactor
    #--binning_factor=1 int--->textfield
    def setBinning_factor(self, binning_factor):
        self.binning_factor = binning_factor
    #--gain_rotation=0 int--->textfield
    def setGain_rotation(self, gain_rotation):
        self.gain_rotation = gain_rotation
    #--gain_flip=0 int--->textfield
    def setGain_flip(self, gain_flip):
        self.gain_flip = gain_flip
    #--file_pst_handler=extract_data---> combo box
    def setGain_Type(self, gain_type):
        self.gain_type = gain_type
    #--collection_speed=COLLECTION_SPEED
    def setCollection_Speed(self,collection_speed):
        self.collection_speed = collection_speed
    #--frames_sample_rate=FRAMES_SAMPLE_RATE
    def setFrames_Sample_Rate(self,frames_sample_rate):
        self.frames_sample_rate = frames_sample_rate
    #---------------------------------------------------------------------------
    # Setters from extrenal classes
    #--->Target Pool directory
    def setPool_Targetdir(self, pool_targetdir):
        self.pool_targetdir = pool_targetdir
    #---------------------------------------------------------------------------
    # Setters for RestAPi2
    #--->api key
    def setAPI2_Key(self, api_key):
        self.api_key = api_key
    #---------------------------------------------------------------------------
    # Setters for number of bootsrap
    #--->nboot
    def setNBoot(self, nboot):
        self.nboot = nboot
    #---------------------------------------------------------------------------
    # [Relion] Setters for Pick and Extract post processing
    #Marker variable self.ptcl_pick_extract_Marker =  ptcl_pick_extract_Marker
    def setptcl_pick_extract_Marker(self, ptcl_pick_extract_Marker):
        self.ptcl_pick_extract_Marker = ptcl_pick_extract_Marker
    #--->ctf star file
    def setCTFStarFile(self, ctf_star):
        self.ctf_star = ctf_star
    #--->log_dia_min
    def setLogDiaMin(self, log_dia_min):
        self.log_dia_min = log_dia_min
    #--->log_dia_max
    def setLogDiaMax(self, log_dia_max):
        self.log_dia_max = log_dia_max
    #--->lowpass = LOWPASS
    def setLowpass(self, lowpass):
        self.lowpass = lowpass
    #--->LoG_adjust_threshold = LOG_ADJUST_THRESHOLD
    def setLogAdjustThreshold(self, LoG_adjust_threshold):
        self.LoG_adjust_threshold = LoG_adjust_threshold
    #--->LoG_upper_threshold = LOG_UPPER_THRESHOLD
    def setLogUpperThreshold(self, LoG_upper_threshold):
        self.LoG_upper_threshold = LoG_upper_threshold
    #--->n_mpi_proc_extract
    def setNMpiProcExtract(self, n_mpi_proc_extract):
        self.n_mpi_proc_extract = n_mpi_proc_extract
    #--->extract_size
    def setExtractSize(self, extract_size):
        self.extract_size = extract_size
    #--->particle_diameter
    def setParticleDiameter(self, particle_diameter):
        self.particle_diameter = particle_diameter
    #---------------------------------------------------------------------------
    # [Relion] Setters for Pick and Extract post processing
    #--->Workflow activator
    def setWorkflow_Activator(self, activator):
        self.workflow_activator = activator
    #--->relionPath
    def setRelionPath(self, relionPath):
        self.relionPath = relionPath
    def setRelionPath_fullpath(self, relionPath_fullpath):
        self.relionPath_fullpath = relionPath_fullpath
    #--->ctf_star_file
    def setCTFStar(self, ctfStar):
        self.CTFStar = ctfStar
    def setCTFStar_fullPath(self, ctfStar_fullPath):
        self.CTFStar_fullPath = ctfStar_fullPath
    #--->mc2_star_file
    def setMc2Star(self, mc2Star):
        self.mc2Star = mc2Star
    def setMc2Star_fullPath(self, mc2Star_fullPath):
        self.mc2Star_fullPath = mc2Star_fullPath
    #---------------------------------------------------------------------------
    # [Relion] Setters for Class2D post processing
    #Marker variable self.class2d_Marker = class2d_Marker
    def setclass2D_Marker(self, class2d_Marker):
        self.class2d_Marker = class2d_Marker
    #--->ctf_intact_first_peak
    def setCtf_Intact_First_Peak(self, ctf_intact_first_peak):
        self.ctf_intact_first_peak = ctf_intact_first_peak
    #--->n_mpi_proc_cl2D
    def setNMpiClass2D(self, n_mpi_proc_cl2d):
        self.n_mpi_proc_cl2D = n_mpi_proc_cl2d
    #--->n_thrds_cl2D
    def setNThrdsCl2D(self, n_thrds_cl2d):
        self.n_thrds_cl2D = n_thrds_cl2d
    #--->n_classes2D
    def setNClasses2D(self, n_classes2d):
        self.n_classes2D = n_classes2d
    #--->n_iterClss2D
    def setNIterClss2D(self, n_iterclss2d):
        self.n_iterClss2D = n_iterclss2d
    #--->n_mskDClss2D
    def setNMskDClss2D(self, n_mskdclss2d):
        self.n_mskDClss2D = n_mskdclss2d
    #--->n_poolClss2D
    def setNPoolClss2D(self, n_poolclss2d):
        self.n_poolClss2D = n_poolclss2d
    #--->GPU_list_Class2D
    def setGPU_list_Class2D(self, gpu_list):
        self.gpu_list_class2d = gpu_list
    #---------------------------------------------------------------------------
    # [Relion] Setters for Init3D post processing
    #Marker variable self.init3d_marker = init3d_marker
    def setInit3D_Marker(self, init3d_marker):
        self.init3d_marker = init3d_marker
    #--->do_ctf_correction_init3D
    def setDo_ctf_correction_init3D(self, do_ctf_correction_init3D):
        self.do_ctf_correction_init3D = do_ctf_correction_init3D
    #--->n_mskDInit3D
    def setNMskDInit3D(self, n_mskDInit3D):
        self.n_mskDInit3D = n_mskDInit3D
    #--->n_poolInit3D
    def setNPoolInit3D(self, n_poolInit3D):
        self.n_poolInit3D = n_poolInit3D
    #--->symmetryInit3D
    def setSymmetryInit3D(self, symmetryInit3D):
        self.symmetryInit3D = symmetryInit3D
    #--->offset_search_range_init3D
    def setOffset_search_range_init3D(self, offset_search_range_init3D):
        self.offset_search_range_init3D = offset_search_range_init3D
    #--->offset_search_step_init3D
    def setOffset_search_step_init3D(self, offset_search_step_init3D):
        self.offset_search_step_init3D = offset_search_step_init3D
    #--->n_mpi_proc_init3D
    def setNMpiInit3D(self, n_mpi_proc_init3D):
        self.n_mpi_proc_init3D = n_mpi_proc_init3D
    #--->n_thrds_init3D
    def setNThrdsInit3D(self, n_thrds_init3D):
        self.n_thrds_init3D = n_thrds_init3D
    #--->GPU_list_Init3D
    def setGPU_list_Init3D(self, gpu_list):
        self.gpu_list_init3d = gpu_list
    #--->n_init3D
    def setNClassInit3D(self, nclassInit3D):
        self.nclassInit3D = nclassInit3D
    #---------------------------------------------------------------------------
    # [Relion] Setters for Class3D post processing
    #Marker variable self.class3d_marker = class3d_marker
    def setClass3D_Marker(self, class3d_marker):
        self.class3d_marker = class3d_marker
    #--->do_ctf_correction_class3D
    def setDo_ctf_correction_class3D(self, do_ctf_correction_class3D):
        self.do_ctf_correction_class3D = do_ctf_correction_class3D
    #--->has_ctf_correction_class3D
    def setHas_ctf_correction_class3D(self, has_ctf_correction_class3D):
        self.has_ctf_correction_class3D = has_ctf_correction_class3D
    #--->n_classes3D
    def setNClassClass3D(self, nclassClass3D):
        self.nclassClass3D = nclassClass3D
    #--->n_iterClss3D
    def setNIterClass3D(self, n_iterClass3D):
        self.n_iterClass3D = n_iterClass3D
    #--->n_mskDClss3D
    def setNMskDClass3D(self, n_mskDClass3D):
        self.n_mskDClass3D = n_mskDClass3D
    #--->n_poolClass3D
    def setNPoolClass3D(self, n_poolClass3D):
        self.n_poolClass3D = n_poolClass3D
    #--->symmetryClass3D
    def setSymmetryClass3D(self, symmetryClass3D):
        self.symmetryClass3D = symmetryClass3D
    #--->offset_search_range_class3D
    def setOffset_search_range_class3D(self, offset_search_range_class3D):
        self.offset_search_range_class3D = offset_search_range_class3D
    #--->offset_search_step_class3D
    def setOffset_search_step_class3D(self, offset_search_step_class3D):
        self.offset_search_step_class3D = offset_search_step_class3D
    #--->n_mpi_proc_cl3d
    def setNMpiClass3D(self, n_mpi_proc_class3d):
        self.n_mpi_proc_class3d = n_mpi_proc_class3d
    #--->n_thrds_cl3d
    def setNThrdsClass3D(self, n_thrds_class3d):
        self.n_thrds_class3d = n_thrds_class3d
    #--->GPU_list_Class3D
    def setGPU_list_Class3D(self, gpu_list):
        self.gpu_list_class3d = gpu_list
    #---------------------------------------------------------------------------
    # [Relion] Setters for Refine3D post processing
    #Marker variable self.refine3d_marker = refine3d_marker
    def setRefine3D_Marker(self, refine3d_marker):
        self.refine3d_marker = refine3d_marker
    #--->do_ctf_correction_refine3D
    def setDo_ctf_correction_refine3D(self, do_ctf_correction_refine3D):
        self.do_ctf_correction_refine3D = do_ctf_correction_refine3D
    #--->has_ctf_correction_refine3D
    def setHas_ctf_correction_refine3D(self, has_ctf_correction_refine3D):
        self.has_ctf_correction_refine3D = has_ctf_correction_refine3D
    #--->n_classesRefine3D
    def setNClassRefine3D(self, nclassRefine3D):
        self.nclassRefine3D = nclassRefine3D
    #--->n_mskDClss3D
    def setNMskDRefine3D(self, n_mskDRefine3D):
        self.n_mskDRefine3D = n_mskDRefine3D
    #--->n_poolRefine3D
    def setNPoolRefine3D(self, n_poolRefine3D):
        self.n_poolRefine3D = n_poolRefine3D
    #--->symmetryRefine3D
    def setSymmetryRefine3D(self, symmetryRefine3D):
        self.symmetryRefine3D = symmetryRefine3D
    #--->offset_search_range_class3D
    def setOffset_search_range_refine3D(self, offset_search_range_refine3D):
        self.offset_search_range_refine3D = offset_search_range_refine3D
    #--->offset_search_step_class3D
    def setOffset_search_step_refine3D(self, offset_search_step_refine3D):
        self.offset_search_step_refine3D = offset_search_step_refine3D
    #--->n_mpi_proc_cl3d
    def setNMpiRefine3D(self, n_mpi_proc_refine3d):
        self.n_mpi_proc_refine3d = n_mpi_proc_refine3d
    #--->n_thrds_cl3d
    def setNThrdsRefine3D(self, n_thrds_refine3d):
        self.n_thrds_refine3d = n_thrds_refine3d
    #--->GPU_list_Refine3D
    def setGPU_list_Refine3D(self, gpu_list):
        self.gpu_list_refine3d = gpu_list
    #---------------------------------------------------------------------------
    # [Relion] Setters for Refine3D post processing
    #Marker variable self.refine3d_marker = refine3d_marker
    def setFullPipeLine_Marker(self, fullPipeLine):
        self.fullPipeLine_marker = fullPipeLine
    def setDataProcInterCom(self, DataProcInterCom):
        self.DataProcInterCom = DataProcInterCom
    def setPool_componentdir(self, pool_componentdir):
        self.pool_componentdir = pool_componentdir
    def setJsontargetdir(self, jsontargetdir):
        self.jsontargetdir = jsontargetdir
    #---------------------------------------------------------------------------
    # [Scanner] Setters for Scanning methods and classes
    #--->current_AllTableCount_json_file
    def setCurrent_AllTableCount_json_file(self, json_file):
        self.current_AllTableCount_json_file = json_file
    #--->json_scan_dir
    def setJSon_Scan_Dir(self, json_scan_dir):
        self.json_scan_dir = json_scan_dir
    #--->table_cnts_dir
    def setJSon_TableCounts_Dir(self, table_cnts_dir):
        self.table_cnts_dir = table_cnts_dir
    #--->with_while_loop
    def setWith_while_loop(self, with_while_loop):
        self.with_while_loop = with_while_loop
    #--->plot_asc=PLOT_ASC
    def setPlot_asc(self, plot_asc):
        self.plot_asc = plot_asc
    #--->csvfile=CSV_FILE
    def setCSV_file(self, csvfile):
        self.csvfile = csvfile
    #--->quantum_computing=QUANTUM_COMPUTING
    def setQuantumComputing(self, quantum_computing):
        self.quantum_computing = quantum_computing
    #--->rawfile=RAW_FILE
    def setRAW_file(self, rawfile):
        self.rawfile = rawfile
    def setMGF_file(self, mgffile):
        self.mgffile = mgffile
    # --scan_number=SCAN_NUMBER
    def setScan_number(self, scan_number):
        self.scan_number = scan_number
    # --RT=RET_TIME
    def setRet_time(self, ret_time):
        self.Ret_time = ret_time
    def setPepMass(self, pepmass):
        self.pepmass = pepmass
    def setCharge(self, charge):
        self.charge = charge
    def setMSLevel(self, mslevel):
        self.MSLevel = mslevel
    def setBegin_Ions(self, begin_ions):
        self.begin_ions = begin_ions
    def setEnd_Ions(self, end_ions):
        self.end_ions = end_ions
    def setSourcedir(self, sourcedir):
        self.sourcedir = sourcedir
    def setRawfile_path(self, rawfile_path):
        self.rawfile_path = rawfile_path
    def setRawfile_full_path_no_ext(self, rawfile_full_path_no_ext):
        self.rawfile_full_path_no_ext = rawfile_full_path_no_ext
    # --import_db=IMPORT_DB
    def setImport_db(self, import_db):
        self.import_db = import_db
    # --export_db=EXPORT_DB
    def setExport_db(self, export_db):
        self.export_db = export_db
    # --import_external_db=IMPORT_EXTERNAL_DB
    def setImport_External_db(self, import_external_db):
        self.import_external_db = import_external_db
    # --export_external_db=export_EXTERNAL_DB
    def setExport_External_db(self, export_external_db):
        self.export_external_db = export_external_db
    def setDatabase_path(self, database_path):
        self.database_path = database_path
    def setDatabase_name(self, database_name):
        self.database_name = database_name
    def setDatabase_full_path_no_ext(self, database_full_path_no_ext):
        self.database_full_path_no_ext = database_full_path_no_ext
    def setDatabase_file(self, database_file):
        self.database_file = database_file
    def setFile_basename(self, file_basename):
        self.file_basename = file_basename
    def setDatabase_schema(self, database_schema):
        self.database_schema = database_schema
    def setDatabase_port(self, database_port):
        self.database_port = database_port
    def setDatabase_server(self, database_server):
        self.database_server = database_server
    # Debugger setters
    def setDebug(self, debug):
        self.debug = debug
    def setDebug_cpu(self, debug_cpu):
        self.debug_cpu = debug_cpu
    def setDebug_high(self, debug_high):
        self.debug_high = debug_high
    def setDebug_write(self, debug_write):
        self.debug_write = debug_write
    def setDebug_write_C(self, debug_write_C):
        self.debug_write_C = debug_write_C
    def setSql_dir(self, sql_dir):
        self.sql_dir = sql_dir
    def setSql_fullPath_dir(self, sql_fullPath_dir):
        self.sql_fullPath_dir = sql_fullPath_dir
    def setQuery_cursor(self, cursor):
        self.cursor = cursor
    def setQuery_object(self, queryMsSQL):
        self.queryMsSQL = queryMsSQL
    def setDatabase_file(self, database_file):
        self.database_file = database_file
    def setDatabase_file(self, database_file):
        self.database_file = database_file
    # [serial, parrallle, multithreaded]
    def setMultiprocessing_type(self, multiprocessing_type):
        self.multiprocessing_type = multiprocessing_type

    # --import_db_set=IMPORT_DB_SET
    def setImport_db_set(self, import_db_set):
        self.import_db_set = import_db_set

    def setPubchem_url(self, pubchem_url):
        self.pubchem_url = pubchem_url

    #--database_origin=DATABASE_ORIGIN
    def setDatabase_origin(self, database_origin):
        self.database_origin = database_origin

    #self.database_extension
    def setDatabase_extension(self, database_extension):
        self.database_extension = database_extension

    # --machine_learning=MACHINE_LEARNING
    def setMachineLearning(self, machine_learning):
        self.machine_learning = machine_learning

    def setBatch_size(self, batch_size):
        self.batch_size = batch_size
    def setNum_classes(self, num_classes):
        self.num_classes = num_classes
    def setLearning_rate(self, learning_rate):
        self.learning_rate = learning_rate
    def setNum_epochs(self, num_epochs):
        self.num_epochs = num_epochs

    # logfile
    def setLogfileName(self, logfile):
        self.logfilename = logfile
    # logfile for the testing
    def setLogfileName_testing(self, logfilename_testing):
        self.logfilename_testing = logfilename_testing

    #---------------------------------------------------------------------------
    # [Bench_Grid_HiRep]
    def setLogBKeeperAction(self, log_bKeeper_action):
        self.logBKeeperAction = log_bKeeper_action
    def setLogGrid(self, log_grid):
        self.logGrid = log_grid
    def setLogHiRep(self, log_hirep):
        self.logHiRep = log_hirep

    #--bkeeper_action=BKEEPER_ACTION
    def setBKeeperAction(self, bkeeper_action):
        self.bkeeper_action = bkeeper_action
    #--grid=GRID
    def setGrid(self, grid):
        self.grid = grid
    #--hirep=HIREP
    def setHiRep(self, hirep):
        self.HiRep = hirep

    #---------------------------------------------------------------------------
    # [Getters]: methods
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Bench_Grid_HiRep]
    def getLogBKeeperAction(self): return self.logBKeeperAction
    def getLogGrid(self): return self.logGrid
    def getLogHiRep(self):  return self.logHiRep
    #--bkeeper_action=BKEEPER_ACTION
    def getBKeeperAction(self):
        return self.bkeeper_action
    #--grid=GRID
    def getGrid(self):
        return self.grid
    #--hirep=HIREP
    def getHiRep(self):
        return self.HiRep

    #log filename for DataManageApp
    def getLogfileName(self):
        return self.logfilename
    # logfile for the testing
    def getLogfileName_testing(self):
        return self.logfilename_testing

    # --machine_learning=MACHINE_LEARNING
    def getMachineLearning(self):
        return self.machine_learning

    def getBatch_size(self):
        return self.batch_size
    def getNum_classes(self):
        return self.num_classes
    def getLearning_rate(self):
        return self.learning_rate
    def getNum_epochs(self):
        return self.num_epochs

    #self.database_extension
    def getDatabase_extension(self):
        return self.database_extension

    #--database_origin=DATABASE_ORIGIN
    def getDatabase_origin(self):
        return self.database_origin

    def getPubchem_url(self):
        return self.pubchem_url
    # --import_db_set=IMPORT_DB_SET
    def getImport_db_set(self):
        return self.import_db_set

    def getMultiprocessing_type(self):
        return self.multiprocessing_type
    def getImport_db(self):
        return self.import_db
    # --export_db=EXPORT_DB
    def getExport_db(self):
        return self.export_db
    # --import_external_db=IMPORT_EXTERNAL_DB
    def getImport_External_db(self):
        return self.import_external_db
    # --export_external_db=export_EXTERNAL_DB
    def getExport_External_db(self):
        return self.export_external_db
    def getJsontargetdir(self, jsontargetdir):
            return self.jsontargetdir
    def getPool_componentdir(self):
        return self.pool_componentdir
    def getDataProcInterCom(self):
        return self.DataProcInterCom
    def getQuery_object(self):
        return self.queryMsSQL
    def getQuery_cursor(self):
        return self.cursor
    def getSql_fullPath_dir(self):
        return self.sql_fullPath_dir
    def getSql_dir(self):
        return self.sql_dir
    # Debugger setters
    def getDebug(self):
        return self.debug
    def getDebug_cpu(self):
        return self.debug_cpu
    def getDebug_high(self):
        return self.debug_high
    def getDebug_write(self):
        return self.debug_write
    def getDebug_write_C(self):
        return self.debug_write_C
    def getDatabase_server(self):
        return self.database_server
    def getDatabase_port(self):
        return self.database_port
    def getDatabase_schema(self):
        return self.database_schema
    def getFile_basename(self):
        return self.file_basename
    # --import_db=IMPORT_DB
    def getDatabase_path(self):
        return self.database_path
    def getDatabase_name(self):
        return self.database_name
    def getDatabase_full_path_no_ext(self):
        return self.database_full_path_no_ext
    def getRawfile_path(self):
        return self.rawfile_path
    def getDatabase_file(self):
        return self.database_file
    def getRawfile_full_path_no_ext(self):
        return self.rawfile_full_path_no_ext
    def getSourcedir(self):
        return self.sourcedir
    def getBegin_Ions(self):
        return self.begin_ions
    def getEnd_Ions(self):
        return self.end_ions
    def getPepMass(self):
        return self.pepmass
    def getCharge(self):
        return self.charge
    def getMSLevel(self):
        return self.MSLevel
    # --scan_number=SCAN_NUMBER
    def getScan_number(self):
        return self.scan_number
    # --RT=RET_TIME
    def getRet_time(self):
        return self.Ret_time
    def getMGF_file(self):
        return self.mgffile
    def getRAW_file(self):
        return self.rawfile
    def getQuantumComputing(self):
        return self.quantum_computing
    def getCSV_file(self):
        return self.csvfile
    def getPlot_asc(self):
        return self.plot_asc
    def getWith_while_loop(self):
        return self.with_while_loop
    #DataManage application main common values
    def getApp_root(self):
        return self.app_root
    def getProjectName(self):
        return self.projectName
    def getData_path(self):
        return self.data_path
    def getGainmrc(self):
        return self.gainmrc
    def getTargetdir(self):
        return self.targetdir
    #software = self.software_SP 
    def getSoftware(self):
        return self.software
    #Marker variables doBenchMarking = self.doBenchMarking.get()
    def getdoBenchMarking_marker(self):
        return self.doBenchMarking_Marker
    #useGpu = self.use_gpu.get() alreday done with setUse_gpu
    def getUse_gpu(self):
        return self.use_gpu
    #gpuList = self.gpu_list.get() alreday done with setGpu_list
    def getGpu_list(self):
        return self.gpu_list
    #poolify = self.poolify.get()
    def getPoolify(self):
        return self.poolify
    #superRes = self.super_res.get()
    def getSuper_Res(self):
        return self.superRes
    #movies_ext = self.movies_ext
    def getMovies_ext(self):
        return self.movies_ext
    #live_process = self.live_process
    def getLive_process(self):
        return self.live_process
    #--use_unblur=0---> checkBox
    def getUse_unblur(self):
        return self.use_unblur
    #--use_MotionCorr=0---> checkBox
    def getUse_MotionCorr(self):
        return self.use_MotionCorr
    #--use_CTFfind=0---> checkBox
    def getUse_CTFfind(self):
        return self.use_CTFfind
    #--file_frame_copy_move_handler=copy---> radioButton
    def getFile_frame_copy_move_handler(self):
        return self.file_frame_copy_move_handler
    #--file_pre_handler=preprocess---> checkBox
    def getFile_pre_handler(self):
        return self.file_pre_handler
    #--file_organise_dir=re---> Combo box
    def getFile_organise_dir(self):
        return self.file_organise_dir
    #--file_pst_handler=extract_data---> combo box
    def getFile_pst_handler(self):
        return self.file_pst_handler
    #--motioncorr_dir=MOTIONCORR_DIR     Path to Motion Corr executable
    def getMotionCorr_dir(self):
        return self.motioncorr_dir
    #--ctffind_dir=CTFFIND_DIR           Path to CTFFind executable
    def getCTFFind_dir(self):
        return self.ctffind_dir
    #---------------------------------------------------------------------------
    # [Pre-Proc-CTFFind] Getters for CTFFind Pre- processing
    #--->ctfFind
    #--nframes=NFRAMES              [50] TODO: Include number frames unblur
    def getNframes(self):
        return self.nframes
    #--sph_abe=SPH_ABE              [2.7] Sphererical Aberration
    def getSph_Abe(self):
        return self.sph_abe
    #--amp_con=AMP_CON              [0.10] Ampl constrast (from 0.07 06Nov21)
    def getAmp_Con(self):
        return self.amp_con
    #--sze_pwr_spc=SZE_PWR_SPC      [512] Size of prower spectrum 
    def getSze_Pwr_Spc(self):
        return self.sze_pwr_spc
    #--minres=MINRES                [30.0] Minimum resolution
    def getMinRes(self):
        return self.minres
    #--maxres=MAXRES                [5.0] Maximum resolution
    def getMaxRes(self):
        return self.maxres
    #--mindef=MINDEF                [5000] Minimum defocus "3100.0"06Nov21
    def getMinDef(self):
        return self.mindef
    #--maxdef=MAXDEF                [50000] Maximum defocus "6900.0"06Nov21
    def getMaxDef(self):
        return self.maxdef
    #--defstep=DEFSTEP              [500.0] Defocus search step
    def getDefStep(self):
        return self.defstep
    #--is_astig=IS_ASTIG            ["no"] Is astigmatism present{no}
    def getIs_Astig(self):
        return self.is_astig
    #--vl_astig=vl_astig            ["yes"] Is large astigmatism expected?{yes}
    def getVl_Astig(self):
        return self.vl_astig
    #--restrt_astig=RESTRT_ASTIG    ["yes"] Restrain astigmatism? {yes}
    def getReStrt_Astig(self):
        return self.restrt_astig
    #--astigpenaltyover=ASTIGPENALTYOVER   [1500.0] Expected \(tolerated\) astig
    def getAstigPenaltyOver(self):
        return self.astigpenaltyover
    #--expert_op=EXPERT_OP          ["no"] Set to expert options {no}
    def getExpert_Op(self):
        return self.expert_op
    #--phaseshift=PHASESHIFT        ["no"] Find additional phase shift
    def getPhaseShift(self):
        return self.phaseshift
    #--data_rot=DATA_ROT            [-90] Rot angle for Size of power spec.
    def getData_Rot  (self):
        return self.data_rot
    #--target_file=TARGET_FILE  ['target.txt']Output file list
    def getTarget_File(self):
        return self.target_file
    #---------------------------------------------------------------------------
    # [Pre-Proc-MotionCorr] Getters for MotionCorr Pre- processing
    #--->MotionCorr
    #--fm_dose=FM_DOSE        string--->textfield
    def getFMDose(self):
        return self.fm_dose
    #--bfactor=150 int--->textfield
    def getBfactor(self):
        return self.bfactor
    #--binning_factor=1 int--->textfield
    def getBinning_factor(self):
        return self.binning_factor
    #--gain_rotation=0 int--->textfield
    def getGain_rotation(self):
        return self.gain_rotation
    #--gain_flip=0 int--->textfield
    def getGain_flip(self):
        return self.gain_flip
    #--gain_type=x0.m0 -->---> combo box
    def getGain_Type(self):
        return self.gain_type
    #--collection_speed=COLLECTION_SPEED
    def getCollection_Speed(self):
        return self.collection_speed
    def getFrames_Sample_Rate(self):
        return self.frames_sample_rate
    #log filename for Gatan_PC_K3_GUI
    def getLogGatan_PC_K3_GUI(self):
        return self.logGatan_PC_K3_GUI
    #log filename
    def getLogMolRefAnt_DB_GUI(self):
        return self.logMolRefAnt_DB_GUI
    #log filename for DataManageApp
    def getLogQuantumComputing(self):
        return self.logQuantumComputing
    #log filename for Gatan_PC_K3_fileMover
    def getLogGatan_PC_K3_fileMover(self):
        return self.logGatan_PC_K3_fileMover
    #log file for the logGatan_PC_K3_gainRefMover
    def getLogGatan_PC_K3_gainRefMover(self):
        return self.logGatan_PC_K3_gainRefMover
    #log filename for delayeds_copy_shutil
    def getLogDelayed_copy(self):
        return self.logDelayed_copy
    #lib filename
    def getLibfileName(self):
        return self.lib
    #logical variables
    def getBench_cpu(self):
        return self.bench_cpu
    def getUse_gpu(self):
        return self.use_gpu
    def getSet_gpu(self):
        return self.set_gpu
    def getGpu_list(self):
        return self.gpu_list
    def getShow_gui(self):
        return self.showGUI
    #The colors getters (standard)
    def getRed(self):
        return self.red
    def getGreen(self):
        return self.green
    def getYellow(self):
        return self.yellow
    def getBlue(self):
        return self.blue
    def getMagenta(self):
        return self.magenta
    def getCyan(self):
        return self.cyan
    def getWhite(self):
        return self.white
    #The colors getters (bolds)
    def get_B_Red(self):
        return self.b_red
    def get_B_Green(self):
        return self.b_green
    def get_B_Yellow(self):
        return self.b_yellow
    def get_B_Blue(self):
        return self.b_blue
    def get_B_Magenta(self):
        return self.b_magenta
    def get_B_Cyan(self):
        return self.b_cyan
    def get_B_White(self):
        return self.b_white
    #The colors getters (underlined)
    def get_U_Red(self):
        return self.u_red
    def get_U_Green(self):
        return self.u_green
    def get_U_Yellow(self):
        return self.u_yellow
    def get_U_Blue(self):
        return self.u_blue
    def get_U_Magenta(self):
        return self.u_magenta
    def get_U_Cyan(self):
        return self.u_cyan
    def get_U_White(self):
        return self.u_white
    #reseting the colors
    def get_C_Reset(self):
        return self.c_reset
    #return codes methods
    def get_RC_SUCCESS(self):
        return self.RC_SUCCESS
    def get_RC_FAIL(self):
        return self.RC_FAIL
    def get_RC_WARNING(self):
        return self.RC_WARNING
    def get_RC_STOP(self):
        return self.RC_STOP
    def get_RC_CUDA_LIB(self):
        return self.RC_CUDA_LIB
    #---------------------------------------------------------------------------
    # Getters from extrenal classes
    #--->Target Pool directory
    def getPool_Targetdir(self):
        return self.pool_targetdir
    #---------------------------------------------------------------------------
    # Getters for RestAPi2
    # --->api key
    def getAPI2_Key(self):
        return self.api_key
    #---------------------------------------------------------------------------
    # Getters for number of bootstrap
    # --->nboot
    def getNBoot(self):
        return self.nboot
    #---------------------------------------------------------------------------
    # [Relion] Getters for Pick and Extract post processing
    #Marker variable self.ptcl_pick_extract_Marker =  ptcl_pick_extract_Marker
    def getptcl_pick_extract_Marker(self):
        return self.ptcl_pick_extract_Marker
    #--->Workflow activator
    def getWorkflow_Activator(self):
        return self.workflow_activator    
    # --->ctf star file
    def getCTFStarFile(self):
        return self.ctf_star
    #--->log_dia_min
    def getLogDiaMin(self):
        return self.log_dia_min
    #--->log_dia_max
    def getLogDiaMax(self):
        return self.log_dia_max
    #--->lowpass = LOWPASS
    def getLowpass(self):
        return self.lowpass
    #--->LoG_adjust_threshold = LOG_ADJUST_THRESHOLD
    def getLogAdjustThreshold(self):
        return self.LoG_adjust_threshold
    #--->LoG_upper_threshold = LOG_UPPER_THRESHOLD
    def getLogUpperThreshold(self):
        return self.LoG_upper_threshold
    #--->n_mpi_proc_extract
    def getNMpiProcExtract(self):
        return self.n_mpi_proc_extract
    #--->extract_size
    def getExtractSize(self):
        return self.extract_size
    #--->particle_diameter
    def getParticleDiameter(self):
        return self.particle_diameter
    #---------------------------------------------------------------------------
    # [Relion] Getters for Pick and Extract post processing
    #--->relionPath
    def getRelionPath(self):
        return self.relionPath
    def getRelionPath_fullpath(self):
        return self.relionPath_fullpath
    #--->ctf_star_file
    def getCTFStar(self):
        return self.CTFStar
    def getCTFStar_fullPath(self):
        return self.CTFStar_fullPath
    #--->mc2_star_file
    def getMc2Star(self):
        return self.mc2Star
    def getMc2Star_fullPath(self):
        return self.mc2Star_fullPath
    #---------------------------------------------------------------------------
    # [Relion] Getters for Class2D post processing
    #Marker variable self.class2d_Marker = class2d_Marker
    def getclass2D_Marker(self):
        return self.class2d_Marker
    #--->ctf_intact_first_peak
    def getCtf_Intact_First_Peak(self):
        return self.ctf_intact_first_peak
    #--->n_mpi_proc_cl2D
    def getNMpiClass2D(self):
        return self.n_mpi_proc_cl2D
    #--->n_thrds_cl2D
    def getNThrdsCl2D(self):
        return self.n_thrds_cl2D
    #--->n_classes2D
    def getNClasses2D(self):
        return self.n_classes2D
    #--->n_iterClss2D
    def getNIterClss2D(self):
        return self.n_iterClss2D
    #--->n_mskDClss2D
    def getNMskDClss2D(self):
        return self.n_mskDClss2D
    #--->n_poolClss2D
    def getNPoolClss2D(self):
        return self.n_poolClss2D
    # --->GPU_list_Class2D
    def getGPU_list_Class2D(self):
        return self.gpu_list_class2d
    #---------------------------------------------------------------------------
    # [Relion] Setters for Init3D post processing
    #Marker variable self.init3d_marker = init3d_marker
    def getInit3D_Marker(self):
        return self.init3d_marker
    #--->do_ctf_correction_init3D
    def getDo_ctf_correction_init3D(self):
        return self.do_ctf_correction_init3D
    #--->n_mskDInit3D
    def getNMskDInit3D(self):
        return self.n_mskDInit3D
    #--->n_poolInit3D
    def getNPoolInit3D(self):
        return self.n_poolInit3D
    #--->symmetryInit3D
    def getSymmetryInit3D(self):
        return self.symmetryInit3D
    #--->offset_search_range_init3D
    def getOffset_search_range_init3D(self):
        return self.offset_search_range_init3D
    #--->offset_search_step_init3D
    def getOffset_search_step_init3D(self):
        return self.offset_search_step_init3D
    #--->n_mpi_proc_init3D
    def getNMpiInit3D(self):
        return self.n_mpi_proc_init3D
    #--->n_thrds_init3D
    def getNThrdsInit3D(self):
        return self.n_thrds_init3D
    #--->GPU_list_Init3D
    def getGPU_list_Init3D(self):
        return self.gpu_list_init3d
    #--->n_init3D
    def getNClassInit3D(self):
        return self.nclassInit3D
    #---------------------------------------------------------------------------
    # [Relion] Getters for Class3D post processing
    #Marker variable self.class3d_marker = class3d_marker
    def getClass3D_Marker(self):
        return self.class3d_marker
    #--->do_ctf_correction_class3D
    def getDo_ctf_correction_class3D(self):
        return self.do_ctf_correction_class3D
    #--->has_ctf_correction_class3D
    def getHas_ctf_correction_class3D(self):
        return self.has_ctf_correction_class3D
    #--->n_classes3D
    def getNClassClass3D(self):
        return self.nclassClass3D
    #--->n_iterClss3D
    def getNIterClass3D(self):
        return self.n_iterClass3D
    #--->n_mskDClss3D
    def getNMskDClass3D(self):
        return self.n_mskDClass3D
    #--->n_poolClass3D
    def getNPoolClass3D(self):
        return self.n_poolClass3D
    #--->symmetryClass3D
    def getSymmetryClass3D(self):
        return self.symmetryClass3D
    #--->offset_search_range_class3D
    def getOffset_search_range_class3D(self):
        return self.offset_search_range_class3D
    #--->offset_search_step_class3D
    def getOffset_search_step_class3D(self):
        return self.offset_search_step_class3D
    #--->n_mpi_proc_cl3d
    def getNMpiClass3D(self):
        return self.n_mpi_proc_class3d
    #--->n_thrds_cl3d
    def getNThrdsClass3D(self):
        return self.n_thrds_class3d
    #--->GPU_list_Class3D
    def getGPU_list_Class3D(self):
        return self.gpu_list_class3d
    #---------------------------------------------------------------------------
    # [Relion] Getters for Refine3D post processing
    #Marker variable self.refine3d_marker = refine3d_marker
    def getRefine3D_Marker(self):
        return self.refine3d_marker
    #--->do_ctf_correction_refine3D
    def getDo_ctf_correction_refine3D(self):
        return self.do_ctf_correction_refine3D
    #--->has_ctf_correction_refine3D
    def getHas_ctf_correction_refine3D(self):
        return self.has_ctf_correction_refine3D
    #--->n_classesRefine3D
    def getNClassRefine3D(self):
        return self.nclassRefine3D
    #--->n_mskDClss3D
    def getNMskDRefine3D(self):
        return self.n_mskDRefine3D
    #--->n_poolRefine3D
    def getNPoolRefine3D(self):
        return self.n_poolRefine3D
    #--->symmetryRefine3D
    def getSymmetryRefine3D(self):
        return self.symmetryRefine3D
    #--->offset_search_range_class3D
    def getOffset_search_range_refine3D(self):
        return self.offset_search_range_refine3D
    #--->offset_search_step_class3D
    def getOffset_search_step_refine3D(self):
        return self.offset_search_step_refine3D
    #--->n_mpi_proc_cl3d
    def getNMpiRefine3D(self):
        return self.n_mpi_proc_refine3d
    #--->n_thrds_cl3d
    def getNThrdsRefine3D(self):
        return self.n_thrds_refine3d
    #--->GPU_list_Refine3D
    def getGPU_list_Refine3D(self):
        return self.gpu_list_refine3d
    #---------------------------------------------------------------------------
    # [Relion] Getters for Refine3D post processing
    #Marker variable self.refine3d_marker = refine3d_marker
    def getFullPipeLine_Marker(self):
        return self.fullPipeLine_marker

    #---------------------------------------------------------------------------
    # [MolRefAnt]
    def getInsert_into_web_Marker(self):
        return self.insert_into_web_marker
    def getInsert_into_web(self):
        return self.insert_into_web


    #---------------------------------------------------------------------------
    # [Scanner] Setters for Scanning methods and classes
    #--->current_AllTableCount_json_file
    def getCurrent_AllTableCount_json_file(self):
        return self.current_AllTableCount_json_file
    #--->json_scan_dir
    def getJSon_Scan_Dir(self):
        return self.json_scan_dir
    #--->table_cnts_dir
    def getJSon_TableCounts_Dir(self):
        return self.table_cnts_dir
#-------------------------------------------------------------------------------
# Warning message for Windows
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#Prints Window warning message
def Windows_warningMessage():
    print("DataManage: "+DataManage_version()+" is not fully supported under Windows")
    #print("You may see ocasional issues, if so please forward the")
    #print("error message to devloppers")
#-------------------------------------------------------------------------------
# Operating system tools platform.uname()
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#Extract the platform information. Operating system tools platform.uname()
#Operating system tools platform.uname()
#\return - platform.version() - platform.platform() - platform.system() - platform.release() - platform.node() - platform.processor() - cpu_count
def whichPlatform():
    import platform
    import multiprocessing
    cpu_count = multiprocessing.cpu_count()
    return platform.version(), platform.platform(), platform.system(), platform.release(), platform.node(), platform.processor(), cpu_count
#---------------------------------------------------------------------------
# General handlers, creaters, starters and reporters methods go here
#---------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#Determines if the program exists and check if the path and directory are valid
#\param program     Program in question
#\return None
def which(program):
    def is_bin(fpath):
        return os.path.isfile(fpath) and os.access(fpath, os.X_OK)

    fpath, fname = os.path.split(program)
    if fpath:
        if is_bin(program):
            return program
    else:
        for path in os.environ["PATH"].split(os.pathsep):
            path = path.strip('"')
            bin_file = os.path.join(path, program)
            if is_bin(bin_file):
                return bin_file
    return None

#*******************************************************************************
##\brief Python3 method.
#Prints the final exit message based on the return code rc.
#\param c          DataManage_common class object from DataManage_common.py
#\param m          messageHandler class from messageHandler.py
#\param rc         Return code
def getFinalExit(c,m,rc):
    m.printLine()
    if rc == c.get_RC_SUCCESS():
        m.printCMesg("DataManage has exited with no problems.",c.get_B_Green())
        m.printMesgInt("Return code: ",c.get_B_Green(),c.get_RC_SUCCESS())
        #exit(c.get_RC_SUCCESS())
    if rc == c.get_RC_FAIL():
        m.printCMesg("DataManage has exited with a problem.",c.get_B_Red())
        m.printMesgInt("Return code: ",c.get_B_Red(),c.get_RC_FAIL())
        #exit(c.get_RC_FAIL())

#---------------------------------------------------------------------------
# end of DataManage_common module
#---------------------------------------------------------------------------
