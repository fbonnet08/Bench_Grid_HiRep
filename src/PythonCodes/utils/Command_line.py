#!/usr/bin/env python3
'''!\file
   -- DataManage addon: (Python3 code) class for handling some of the command line
      of the common variables
      \author Frederic Bonnet
      \date 13th of February 2021

      Leiden University October 2021

Name:
---
Command_line: class Command_line for handling some of the command line
inputs

Description of classes:
---
This class generates an object that contains and handles some of the command line
inputs. It avoids multiple refdefinitions
of variables and allow transportability accross applicatuions.

Requirements (system):
---
* sys
* os
'''
#-------------------------------------------------------------------------------
# Command line definitions and methods
# Author: Frederic Bonnet
# Date: 27/10/2021
#-------------------------------------------------------------------------------
#System tools
import os
import sys
#-------------------------------------------------------------------------------
# Start of the test script
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#DataManage common object definition.
#*******************************************************************************
class Command_line:
    #***************************************************************************
    ##\brief Python3 method.
    #Command_line class constructor
    #***************************************************************************
    #\param self     Self object
    def __init__(self, args, c, m):
        __func__= sys._getframe().f_code.co_name
        # first mapping the input to the object self
        self.args = args
        self.c = c
        self.m = m
        
        self.m.printMesgStr("Instantiating the class       :", self.c.getGreen(), "Command_line")
        #INitialising some of the basic file characters
        self.initialize()
    #---------------------------------------------------------------------------
    # class methods
    #---------------------------------------------------------------------------
    #***************************************************************************
    ##\brief Python3 method.
    #initialises the variables
    #\param self     Self object
    def initialize(self):
        '''!
        Initializes all of the common varaibles
        '''
        #general symbols
        self.sl_brck            = "["
        self.sr_brck            = "]"
        self.g_than             = ">"
        self.l_than             = "<"
        self.undscr             = "_"    # underscore
        self.sptr               = "/";   # set the name for the separator.
        self.b_sptr             = "\\";  # set the name for the separator.
        self.all                = "*";   # unix commands for all files eg: file*
        self.eq                 = "=";   # equal sign for file writting
        self.mrc_ext            = ".mrc"
        self.spi_ext            = ".spi"
        self.json_ext            = ".json"
        self.csv_ext            = ".csv"
        self.asc_ext            = ".asc"
        self.local_path         = os.getcwd()
    #---------------------------------------------------------------------------
    # [Creators]: methods
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    #General command for args
    #---------------------------------------------------------------------------

    # --sombrero_action=[Sombrero_weak, Sombrero_strong]
    def createSombreroAction(self):
        __func__ = sys._getframe().f_code.co_name
        #--sombrero_action=[Sombrero_weak, Sombrero_strong]
        if self.args['--sombrero_action'] == "Sombrero_weak":
            SOMBRERO_ACTION = "Sombrero_weak"
        elif self.args['--sombrero_action'] == "Sombrero_strong":
            SOMBRERO_ACTION = "Sombrero_strong"
        else:
            SOMBRERO_ACTION = self.c.getSombreroAction()
        self.c.setSombreroAction(SOMBRERO_ACTION)

    # --simulation_size=[small, large]
    def createSimulationSize(self):
        __func__ = sys._getframe().f_code.co_name
        #--sombrero_action=[Sombrero_weak, Sombrero_strong]
        if self.args['--simulation_size'] == "small":
            SIMULATION_SIZE = "small"
        elif self.args['--simulation_size'] == "large":
            SIMULATION_SIZE = "large"
        else:
            SIMULATION_SIZE = self.c.getSimulationSize()
        self.c.setSimulationSize(SIMULATION_SIZE)



    # --grid=GRID
    def createGrid(self):
        __func__ = sys._getframe().f_code.co_name
        #--grid=GRID
        if self.args['--grid'] == "yes":
            GRID = "yes"
        elif self.args['--grid'] == "no":
            GRID = "no"
        else:
            GRID = self.c.getGrid()
        self.c.setGrid(GRID)

    # --hirep=HIREP
    def createHiRep(self):
        __func__ = sys._getframe().f_code.co_name
        #--hirep=HIREP
        if self.args['--hirep'] == "yes":
            HIREP = "yes"
        elif self.args['--hirep'] == "no":
            HIREP = "no"
        else:
            HIREP = self.c.getHiRep()
        self.c.setHiRep(HIREP)

    # --bkeeper_action=[BKeeper_run_cpu, BKeeper_run_gpu]
    def createBKeeperAction(self):
        __func__ = sys._getframe().f_code.co_name
        #--bkeeper_action=[BKeeper_run_cpu, BKeeper_run_gpu]
        if self.args['--bkeeper_action'] == "BKeeper_run_cpu":
            BKEEPER_ACTION = "BKeeper_run_cpu"
        elif self.args['--bkeeper_action'] == "BKeeper_run_gpu":
            BKEEPER_ACTION = "BKeeper_run_gpu"
        else:
            BKEEPER_ACTION = self.c.getBKeeperAction()
        self.c.setBKeeperAction(BKEEPER_ACTION)

    # --insert_into_web=INSERT_INTO_WEB
    def createInsert_into_web(self):
        __func__ = sys._getframe().f_code.co_name
        #--machine_learning=MACHINE_LEARNING
        if self.args['--insert_into_web'] == "yes":
            INSERT_INTO_WEB = "yes"
        elif self.args['--insert_into_web'] == "no":
            INSERT_INTO_WEB = "no"
        else:
            INSERT_INTO_WEB = self.c.getInsert_into_web
        self.c.setInsert_into_web(INSERT_INTO_WEB)

    # --machine_learning=MACHINE_LEARNING
    def createMachineLearning(self):
        __func__ = sys._getframe().f_code.co_name
        #--machine_learning=MACHINE_LEARNING
        if self.args['--machine_learning'] == "yes":
            MACHINE_LEARNING = "yes"
        elif self.args['--machine_learning'] == "no":
            MACHINE_LEARNING = "no"
        else:
            MACHINE_LEARNING = self.c.getMachineLearning()
        self.c.setMachineLearning(MACHINE_LEARNING)

    # --database_origin=DATABASE_ORIGIN
    def createDatabase_origin_db(self):
        __func__ = sys._getframe().f_code.co_name
        try:
            DATABASE_ORIGIN = self.args['--database_origin']
        except:
            DATABASE_ORIGIN = self.c.getDatabase_origin()
        self.c.setDatabase_origin(DATABASE_ORIGIN)

    # --import_db_set=IMPORT_DB_SET
    def createImport_db_set(self):
        __func__ = sys._getframe().f_code.co_name
        try:
            IMPORT_DB_SET = self.args['--import_db_set']
        except:
            IMPORT_DB_SET = self.c.getImport_db_set()
        self.c.setImport_db_set(IMPORT_DB_SET)

    # --multiprocessing_type=MULTIPROCESSING_TYPE
    def createMultiprocessing_type(self):
        __func__ = sys._getframe().f_code.co_name
        try:
            MULTIPROCESSING_TYPE = self.args['--multiprocessing_type']
        except:
            MULTIPROCESSING_TYPE = self.c.getMultiprocessing_type()
        self.c.setMultiprocessing_type(MULTIPROCESSING_TYPE)

    # --import_external_db=IMPORT_EXTERNAL_DB
    def createImport_External_db(self):
        __func__ = sys._getframe().f_code.co_name
        try:
            IMPORT_EXTERNAL_DB = self.args['--import_external_db']
        except:
            IMPORT_EXTERNAL_DB = self.c.getImport_External_db()
        self.c.setImport_External_db(IMPORT_EXTERNAL_DB)

    # --export_external_db=export_EXTERNAL_DB
    def createExport_External_db(self):
        __func__ = sys._getframe().f_code.co_name
        try:
            EXPORT_EXTERNAL_DB = self.args['--export_external_db']
        except:
            EXPORT_EXTERNAL_DB = self.c.getExport_External_db()
        self.c.setExport_External_db(EXPORT_EXTERNAL_DB)

    # --import_db=IMPORT_DB
    def createImport_db(self):
        __func__ = sys._getframe().f_code.co_name
        try:
            IMPORT_DB = self.args['--import_db']
        except:
            IMPORT_DB = self.c.getImport_db()
        self.c.setImport_db(IMPORT_DB)

    # --export_db=EXPORT_DB
    def createExport_db(self):
        __func__ = sys._getframe().f_code.co_name
        try:
            EXPORT_DB = self.args['--export_db']
        except:
            EXPORT_DB = self.c.getExport_db()
        self.c.setExport_db(EXPORT_DB)

    # --scan_number=SCAN_NUMBER
    def createScan_number(self):
        __func__ = sys._getframe().f_code.co_name
        #self.scan_number = scan_number
        try:
            SCAN_NUMBER = self.args['--scan_number']
        except:
            SCAN_NUMBER = self.c.getScan_number()
        self.c.setScan_number(SCAN_NUMBER)

    # --RT=RET_TIME
    def createRet_time(self):
        __func__ = sys._getframe().f_code.co_name
        #--RT=RET_TIME
        try:
            RET_TIME = self.args['--RT']
        except:
            RET_TIME = self.c.getRet_time()
        self.c.setRet_time(RET_TIME)

    #--rawfile=RAW_FILE
    def createRAW_file(self):
        __func__ = sys._getframe().f_code.co_name
        #--rawfile=RAW_FILE
        try:
            RAW_FILE = self.args['--rawfile']
        except:
            RAW_FILE = self.c.getRAW_file()
        self.c.setRAW_file(RAW_FILE)

    # --quantum_computing=QUANTUM_COMPUTING
    def createQuantumComputing(self):
        __func__ = sys._getframe().f_code.co_name
        #--quantum_computing=QUANTUM_COMPUTING
        if self.args['--quantum_computing'] == "yes":
            QUANTUM_COMPUTING = "yes"
        elif self.args['--quantum_computing'] == "no":
            QUANTUM_COMPUTING = "no"
        else:
            QUANTUM_COMPUTING = self.c.getQuantumComputing()
        self.c.setQuantumComputing(QUANTUM_COMPUTING)

    # --csvfile=CSV_FILE
    def createCSV_file(self):
        __func__ = sys._getframe().f_code.co_name
        #--csvfile=CSV_FILE
        try:
            CSV_FILE = self.args['--csvfile']
        except:
            CSV_FILE = self.c.getCSV_file()
        self.c.setCSV_file(CSV_FILE)
    #--plot_asc=PLOT_ASC
    def createPlot_asc(self):
        __func__ = sys._getframe().f_code.co_name
        #--plot_asc=PLOT_ASC
        try:
            PLOT_ASC = self.args['--plot_asc']
        except:
            PLOT_ASC = "copy.asc"
        self.c.setPlot_asc(PLOT_ASC)

    #--with_while_loop=WITH_WHILE_LOOP
    def createWith_while_loop(self):
        __func__ = sys._getframe().f_code.co_name
        #--with_while_loop=WITH_WHILE_LOOP
        if self.args['--with_while_loop'] == "yes":
            with_while_loop = "yes"
        elif self.args['--with_while_loop'] == "no":
            with_while_loop = "no"
        else:
            with_while_loop = self.c.with_while_loop
        self.m.printMesgStr("with_while_loop ----> ", self.c.getRed(), with_while_loop)
        self.c.setWith_while_loop(with_while_loop)

   #--use_gpu=USE_GPU
    def createArgs_use_gpu(self):
        __func__ = sys._getframe().f_code.co_name
        #--use_gpu=USE_GPU
        if self.args['--use_gpu'] == "yes":
            use_gpu = "yes"
        else:
            use_gpu = "no"
        self.c.setUse_gpu(use_gpu)
    
    def createArgs_gpu_list(self):
        __func__ = sys._getframe().f_code.co_name
        #--gpu_list=GPU_LIST
        if self.args['--gpu_list']:
            GPU_LIST = self.args['--gpu_list']
        else:
            GPU_LIST = "0"
        self.c.setGpu_list(GPU_LIST)

    def createArgs_doBenchMarking(self):
        __func__ = sys._getframe().f_code.co_name
        # --doBenchMarking
        if self.args['--doBenchMarking'] == True:
            doBenchMarking = True
            showGUI = False
            self.c.setShow_gui(showGUI)
            self.c.setdoBenchMarking_marker("--doBenchMarking")
        else:
            doBenchMarking = False
            showGUI = True
            self.c.setShow_gui(showGUI)
            self.c.setdoBenchMarking_marker("")
        self.c.setBench_cpu(doBenchMarking)
    #------------------------------------------
    #Pre-Proc from particle pickling to Refine3D
    #------------------------------------------
    def createArgs_movies_ext(self):
        __func__ = sys._getframe().f_code.co_name
        #--movies_ext=MOVIES_EXT     Movies extension [{mrc|tiff}|dflt=mrc}]
        if self.args['--movies_ext']  == "tiff":
            MOVIES_EXT = "tiff"
        else:
            MOVIES_EXT = "mrc"
            self.m.printCMesg("Movies extension not specified --> mrc", self.c.get_B_Yellow())
            self.m.printMesgAddStr("--movies_ext: ", self.c.getGreen(),MOVIES_EXT)
            self.m.printMesgInt("Return code: ", self.c.get_B_Yellow(), self.c.get_RC_WARNING())
        self.c.setMovies_ext(MOVIES_EXT)

    def createArgs_file_frame_copy_move_handler(self):
        __func__ = sys._getframe().f_code.co_name
        #--file_frame_copy_move_handler=FILE_FRAME_COPY_MOVE_HANDLER [{copy,move,rsync_copy,rsync_move}|copy]
        if self.args['--file_frame_copy_move_handler']:
            FILE_FRAME_COPY_MOVE_HANDLER = self.args['--file_frame_copy_move_handler']
        else:
            FILE_FRAME_COPY_MOVE_HANDLER = "copy"
            self.m.printCMesg("FILE_FRAME_COPY_MOVE_HANDLER not specified --> copy", self.c.get_B_Yellow())
            self.m.printMesgAddStr("--file_frame_copy_move_handler: ", self.c.getGreen(), FILE_FRAME_COPY_MOVE_HANDLER)
            self.m.printMesgInt("Return code: ", self.c.get_B_Yellow(), self.c.get_RC_WARNING())
        self.c.setFile_frame_copy_move_handler(FILE_FRAME_COPY_MOVE_HANDLER)

    def createArgs_super_res(self):
        __func__ = sys._getframe().f_code.co_name
        #--super_res=SUPER_RES       Super resolution mode [{yes|no}|dflt=no}]
        if self.args['--super_res'] == "yes":
            SUPER_RES = "yes"
        else:
            SUPER_RES = "no"
            self.m.printCMesg("Not in Super res mode --> no", self.c.get_B_Yellow())
            self.m.printMesgAddStr("--super_res: ", self.c.getGreen(), SUPER_RES)
            self.m.printMesgInt("Return code: ", self.c.get_B_Yellow(), self.c.get_RC_WARNING())
        self.c.setSuper_Res(SUPER_RES)

    def createArgs_motioncorr_dir(self):
        __func__ = sys._getframe().f_code.co_name
        #--motioncorr_dir=MOTIONCORR_DIR     Path to Motion Corr executable
        if self.args['--motioncorr_dir']:
            MOTIONCORR_DIR = self.args['--motioncorr_dir']
        else:
            MOTIONCORR_DIR = ""
        self.c.setMotionCorr_dir(MOTIONCORR_DIR)

    def createArgs_fm_dose(self):
        __func__ = sys._getframe().f_code.co_name
        #--fm_dose=FM_DOSE            Dose per frames [{float}|1.0]
        try:
            FM_DOSE = float(self.args['--fm_dose'])
        except:
            FM_DOSE = 1.0
        self.c.setFMDose(FM_DOSE)
        
    def createArgs_bfactor(self):
        __func__ = sys._getframe().f_code.co_name
        #--bfactor=BFACTOR                Bfactor
        try:
            BFACTOR = float(self.args['--bfactor'])
        except:
            BFACTOR = 150
        self.c.setBfactor(BFACTOR)

    def createArgs_binning_factor(self):
        __func__ = sys._getframe().f_code.co_name
        #--binning_factor=BINNING_FACTOR  Binning factor
        try:
            BINNING_FACTOR = float(self.args['--binning_factor'])
        except:
            BINNING_FACTOR = 1
        self.c.setBinning_factor(BINNING_FACTOR)

    def createArgs_gain_rotation(self):
        __func__ = sys._getframe().f_code.co_name
        #--gain_rotation=GAIN_ROTATION    cntr-clockwise [{0:0,1:90,2:180,3:270}|0]
        try:
            GAIN_ROTATION = float(self.args['--gain_rotation'])
            if (GAIN_ROTATION == 90 ): GAIN_ROTATION = 1
            if (GAIN_ROTATION == 180): GAIN_ROTATION = 2
            if (GAIN_ROTATION == 270): GAIN_ROTATION = 3
        except:
            GAIN_ROTATION = 0
        self.c.setGain_rotation(GAIN_ROTATION)

    def createArgs_gain_flip(self):
        __func__ = sys._getframe().f_code.co_name
        #--gain_flip=GAIN_FLIP            [{0:no, 1:flip UpDown, 2:flip LR}|0]
        try:
            GAIN_FLIP = float(self.args['--gain_flip'])
        except:
            GAIN_FLIP = 0
        self.c.setGain_flip(GAIN_FLIP)

    def createArgs_ctffind_dir(self):
        __func__ = sys._getframe().f_code.co_name
        #--ctffind_dir=CTFFIND_DIR           Path to CTFFind executable
        if self.args['--ctffind_dir']:
            CTFFIND_DIR = self.args['--ctffind_dir']
        else:
            CTFFIND_DIR = ""
        self.c.setCTFFind_dir(CTFFIND_DIR)

    def createArgs_live_process(self):
        __func__ = sys._getframe().f_code.co_name
        #--live_process=LIVE_PROCESS Live processing [{yes|no}|dflt=no}]
        if self.args['--live_process'] == "yes":
            LIVE_PROCESS = "yes"
        else:
            LIVE_PROCESS = "no"
            self.m.printCMesg("Movies extension not specified --> mrc", self.c.get_B_Yellow())
            self.m.printMesgAddStr("--live_process: ", self.c.getGreen(),LIVE_PROCESS)
            self.m.printMesgInt("Return code: ", self.c.get_B_Yellow(), self.c.get_RC_WARNING())
        self.c.setLive_process(LIVE_PROCESS)
           
    def createArgs_use_MotionCorr(self):
        __func__ = sys._getframe().f_code.co_name
        #--use_MotionCorr=USE_MCORR {yes:1|dflt=no:0}
        if self.args['--use_MotionCorr'] == "1":
            USE_MCORR = 1
        else:
            USE_MCORR = 0
        self.c.setUse_MotionCorr(USE_MCORR)

    def createArgs_use_CTFfind(self):
        __func__ = sys._getframe().f_code.co_name
        #--use_CTFfind=USE_CTFFIND {yes:1|dflt=no:0}
        if self.args['--use_CTFfind'] == "1":
            USE_CTFFIND = 1
        else:
            USE_CTFFIND = 0
        self.c.setUse_CTFfind(USE_CTFFIND)

    def createArgs_use_unblur(self):
        # --use_unblur=USE_UNBLUR {yes:1|dflt=no:0}
        __func__ = sys._getframe().f_code.co_name
        if self.args['--use_unblur'] == "1":
            USE_UNBLUR = 1
        else:
            USE_UNBLUR = 0
        self.c.setUse_unblur(USE_UNBLUR)

    def createArgs_file_pre_handler(self):
        __func__ = sys._getframe().f_code.co_name
        #--file_pre_handler=F_PRE_HDLR
        if self.args['--file_pre_handler'] == "preprocess":
            F_PRE_HDLR = "preprocess"
            self.c.setFile_pre_handler(F_PRE_HDLR)
        else:
            F_PRE_HDLR = "lookupdata"
            self.c.setFile_pre_handler(F_PRE_HDLR)
            self.m.printCMesg("preprocess not set --> lookupdata", self.c.get_B_Yellow())
            self.m.printMesgAddStr("--file_pre_handler: ", self.c.getGreen(),F_PRE_HDLR)
            self.m.printMesgInt("Return code: ", self.c.get_B_Yellow(), self.c.get_RC_WARNING())

    def createArgs_file_organise_dir(self):
        __func__ = sys._getframe().f_code.co_name
        #--file_organise_dir=F_ORGS_DIR
        if self.args['--file_organise_dir'] == "or":
            F_ORGS_DIR = "or"
        elif self.args['--file_organise_dir'] == "re":
            F_ORGS_DIR = "re"
        elif self.args['--file_organise_dir'] == "no":
            F_ORGS_DIR = "no"
        else:
            F_ORGS_DIR = "or"
            self.m.printCMesg("file_organise_dir not set --> or", self.c.get_B_Yellow())
            self.m.printMesgAddStr("--file_organise_dir: ", self.c.getGreen(), F_ORGS_DIR)
            self.m.printMesgInt("Return code: ", self.c.get_B_Yellow(), self.c.get_RC_WARNING())
        self.c.setFile_organise_dir(F_ORGS_DIR)

    def createArgs_file_pst_handler(self):
        __func__ = sys._getframe().f_code.co_name
        #--file_pst_handler=F_PST_HDLR
        if self.args['--file_pst_handler'] == "extract_data":
            F_PST_HDLR = "extract_data"
        else:
            F_PST_HDLR = "no"
            self.m.printCMesg("file_pst_handler not set --> no", self.c.get_B_Yellow())
            self.m.printMesgAddStr("--file_pst_handler: ", self.c.getGreen(),F_PST_HDLR)
            self.m.printMesgInt("Return code: ", self.c.get_B_Yellow(), self.c.get_RC_WARNING())
        self.c.setFile_pst_handler(F_PST_HDLR)

    def createArgs_poolify(self):
        __func__ = sys._getframe().f_code.co_name
        #--poolify=POOLIFY    Poolify the data {yes|no} [dflt=yes]
        if self.args['--poolify'] == "yes":
            POOLIFY = "yes"
        else:
            POOLIFY = "no"
        self.c.setPoolify(POOLIFY)
    #------------------------------------------
    #Input parameters for the numberical computation
    #------------------------------------------
    #--nframes=NFRAMES              [50] TODO: Include number frames unblur
    #--sph_abe=SPH_ABE              [2.7] Sphererical Aberration
    #--amp_con=AMP_CON              [0.10] Ampl constrast (from 0.07 06Nov21)
    #--sze_pwr_spc=SZE_PWR_SPC      [512] Size of prower spectrum 
    #--minres=MINRES                [30.0] Minimum resolution
    #--maxres=MAXRES                [5.0] Maximum resolution
    #--mindef=MINDEF                [5000] Minimum defocus "3100.0"06Nov21
    #--maxdef=MAXDEF                [50000] Maximum defocus "6900.0"06Nov21
    #--defstep=DEFSTEP              [500.0] Defocus search step
    #--astigpenaltyover=ASTIGPENALTYOVER   [1500.0] Expected \(tolerated\) astig
    def createArgs_Nframes(self):
        __func__ = sys._getframe().f_code.co_name
        #--nframes=NFRAMES              [50] TODO: Include number frames unblur
        try:
            NFRAMES = float(self.args['--nframes'])
        except:
            NFRAMES = 50
        self.c.setNframes(NFRAMES)

    def createArgs_Sph_Abe(self):
        __func__ = sys._getframe().f_code.co_name
        #--sph_abe=SPH_ABE              [2.7] Sphererical Aberration
        try:
            SPH_ABE = float(self.args['--sph_abe'])
        except:
            SPH_ABE = 2.7
        self.c.setSph_Abe(SPH_ABE)

    def createArgs_Amp_Con(self):
        __func__ = sys._getframe().f_code.co_name
        #--amp_con=AMP_CON              [0.10] Ampl constrast (from 0.07 06Nov21)
        try:
            AMP_CON = float(self.args['--amp_con'])
        except:
            AMP_CON = 0.10
        self.c.setAmp_Con(AMP_CON)

    def createArgs_Sze_Pwr_Spc(self):
        __func__ = sys._getframe().f_code.co_name
        #--sze_pwr_spc=SZE_PWR_SPC      [512] Size of prower spectrum 
        try:
            SZE_PWR_SPC = float(self.args['--sze_pwr_spc'])
        except:
            SZE_PWR_SPC = 512
        self.c.setSze_Pwr_Spc(SZE_PWR_SPC)

    def createArgs_MinRes(self):
        __func__ = sys._getframe().f_code.co_name
        #--minres=MINRES                [30.0] Minimum resolution
        try:
            MINRES = float(self.args['--minres'])
        except:
            MINRES = 30.0
        self.c.setMinRes(MINRES)

    def createArgs_MaxRes(self):
        __func__ = sys._getframe().f_code.co_name
        #--maxres=MAXRES                [5.0] Maximum resolution
        try:
            MAXRES = float(self.args['--maxres'])
        except:
            MAXRES = 5.0
        self.c.setMaxRes(MAXRES)

    def createArgs_MinDef(self):
        __func__ = sys._getframe().f_code.co_name
        #--mindef=MINDEF                [5000] Minimum defocus "3100.0"06Nov21
        try:
            MINDEF = float(self.args['--mindef'])
        except:
            MINDEF = 5000
        self.c.setMinDef(MINDEF)

    def createArgs_MaxDef(self):
        __func__ = sys._getframe().f_code.co_name
        #--maxdef=MAXDEF                [50000] Maximum defocus "6900.0"06Nov21
        try:
            MAXDEF = float(self.args['--maxdef'])
        except:
            MAXDEF = 50000
        self.c.setMaxDef(MAXDEF)

    def createArgs_DefStep(self):
        __func__ = sys._getframe().f_code.co_name
        #--defstep=DEFSTEP              [500.0] Defocus search step
        try:
            DEFSTEP = float(self.args['--defstep'])
        except:
            DEFSTEP = 500.0
        self.c.setDefStep(DEFSTEP)

    def createArgs_AstigPenaltyOver(self):
        __func__ = sys._getframe().f_code.co_name
        #--astigpenaltyover=ASTIGPENALTYOVER   [1500.0] Expected \(tolerated\) astig
        try:
            ASTIGPENALTYOVER = float(self.args['--astigpenaltyover'])
        except:
            ASTIGPENALTYOVER = 1500.0
        self.c.setAstigPenaltyOver(ASTIGPENALTYOVER)
    #------------------------------------------
    #Pst-Proc from particle pickling to Refine3D
    #------------------------------------------
    # Aplication Paths and the like
    # TODO get the app_root, data_path and etc...  here
    # Common to all
    def createArgs_ctf_star(self):
        __func__ = sys._getframe().f_code.co_name
        #--ctf_star=CTF_STAR {required}
        CTF_STAR = ""
        if self.args['--ctf_star']:
            CTF_STAR = self.args['--ctf_star']
            self.c.setCTFStar_fullPath(CTF_STAR)

            relionPath          = "Relion"
            relionPath_fullpath = self.c.getTargetdir()  + os.path.sep         + \
                                  self.c.getProjectName()+ "_Pool"+os.path.sep + \
                                  relionPath
            self.c.setRelionPath(relionPath)
            self.c.setRelionPath_fullpath(relionPath_fullpath)

            mc2Star          = "app_mc2_corrected_micrographs.star"
            mc2Star_fullPath = self.c.getTargetdir()   + os.path.sep           + \
                               self.c.getProjectName() + "_Pool" + os.path.sep + \
                               relionPath         + os.path.sep + mc2Star
            self.c.setMc2Star(mc2Star)
            self.c.setMc2Star_fullPath(mc2Star_fullPath)
        else:
            self.m.printCMesg("A start file is required.",self.c.get_B_Red())
            self.m.printMesgAddStr(" ctf_star: ", self.c.getGreen(), self.args['--ctf_star'])
            self.m.printMesgInt("Return code: ", self.c.get_B_Red(), self.c.get_RC_FAIL())
            exit(self.c.get_RC_FAIL())

    def createArgs_extract_size(self):
        # --extract_size=EXTRACT_SIZE [{int}|300]
        try:
            EXTRACT_SIZE = int(self.args['--extract_size'])
        except:
            EXTRACT_SIZE = 300
        self.c.setExtractSize(EXTRACT_SIZE)

    def createArgs_particle_diameter(self):
        # --particle_diameter=PARTICLE_DIAMETER [{int}|180]
        try:
            PARTICLE_DIAMETER = int(self.args['--particle_diameter'])
        except:
            PARTICLE_DIAMETER = 180
        self.c.setParticleDiameter(PARTICLE_DIAMETER)
    #------------------------------------------
    #Particle Pick and Extract
    #------------------------------------------
    def createArgs_log_dia_min(self):
        #--log_dia_min=LOG_DIA_MIN [{int}|160]
        try:
            LOG_DIA_MIN = int(self.args['--log_dia_min'])
        except:
            LOG_DIA_MIN = 160
        self.c.setLogDiaMin(LOG_DIA_MIN)

    def createArgs_log_dia_max(self):
        #--log_dia_max=LOG_DIA_MAX [{int}|250]
        try:
            LOG_DIA_MAX = int(self.args['--log_dia_max'])
        except:
            LOG_DIA_MAX = 250
        self.c.setLogDiaMax(LOG_DIA_MAX)

    def createArgs_lowpass(self):
        #--lowpass = LOWPASS [float{10,100}|20]
        try:
            LOWPASS = float(self.args['--lowpass'])
        except:
            LOWPASS = 20
        self.c.setLowpass(LOWPASS)

    def createArgs_LoG_adjust_threshold(self):        
        #--LoG_adjust_threshold = LOG_ADJUST_THRESHOLD [float{-1,1}|0.0]
        try:
            LOG_ADJUST_THRESHOLD = float(self.args['--LoG_adjust_threshold'])
        except:
            LOG_ADJUST_THRESHOLD = 0
        self.c.setLogAdjustThreshold(LOG_ADJUST_THRESHOLD)

    def createArgs_LoG_upper_threshold(self):        
        #--LoG_upper_threshold = LOG_UPPER_THRESHOLD
        try:
            LOG_UPPER_THRESHOLD = float(self.args['--LoG_upper_threshold'])
        except:
            LOG_UPPER_THRESHOLD = 999
        self.c.setLogUpperThreshold(LOG_UPPER_THRESHOLD)

    def createArgs_n_mpi_proc_extract(self):
        #--n_mpi_proc_extract=N_MPI_PROC_EXTRACT
        try:
            N_MPI_PROC_EXTRACT = int(self.args['--n_mpi_proc_extract'])
        except:
            N_MPI_PROC_EXTRACT = 4
        self.c.setNMpiProcExtract(N_MPI_PROC_EXTRACT)
    #------------------------------------------
    # Class2D
    #------------------------------------------
    def createArgs_ctf_intact_first_peak(self):
        #--ctf_intact_first_peak=CTF_INTACT_FIRST_PEAK
        try:
            CTF_INTACT_FIRST_PEAK = self.args['--ctf_intact_first_peak']
        except:
            CTF_INTACT_FIRST_PEAK = "no"

    def createArgs_n_mpi_proc_cl2D(self):
        #--n_mpi_proc_cl2D=N_MPI_PROC_CL2D [{int}|11]
        try:
            N_MPI_PROC_CL2D = int(self.args['--n_mpi_proc_cl2D'])
        except:
            N_MPI_PROC_CL2D = 11
        self.c.setNMpiClass2D(N_MPI_PROC_CL2D)

    def createArgs_n_thrds_cl2D(self):
        #--n_thrds_cl2D=N_THRDS_CL2D [{int}|8]
        try:
            N_THRDS_CL2D = int(self.args['--n_thrds_cl2D'])
        except:
            N_THRDS_CL2D = 8
        self.c.setNThrdsCl2D(N_THRDS_CL2D)

    def createArgs_n_classes2D(self):
        #--n_classes2D=N_CLASSES2D [{int}|15]
        try:
            N_CLASSES2D = int(self.args['--n_classes2D'])
        except:
            N_CLASSES2D = 15
        self.c.setNClasses2D(N_CLASSES2D)

    def createArgs_n_iterClss2D(self):
        #--n_iterClss2D=N_ITERCLSS2D [{int}|25]
        try:
            N_ITERCLSS2D = int(self.args['--n_iterClss2D'])
        except:
            N_ITERCLSS2D = 25
        self.c.setNIterClss2D(N_ITERCLSS2D)

    def createArgs_n_mskDClss2D(self):
        #--n_mskDClss2D=N_MSKDCLSS2D [{int}|300]
        try:
            N_MSKDCLSS2D = int(self.args['--n_mskDClss2D'])
        except:
            N_MSKDCLSS2D = 300
        self.c.setNMskDClss2D(N_MSKDCLSS2D)

    def createArgs_n_poolClss2D(self):
        #--n_poolClss2D=N_POOLCLSS2D [{int}|100]
        try:
            N_POOLCLSS2D = int(self.args['--n_poolClss2D'])
        except:
            N_POOLCLSS2D = 100
        self.c.setNPoolClss2D(N_POOLCLSS2D)

    def createArgs_gpu_list_cl23d(self):
        #--gpu_list=GPU_LIST
        if self.args['--gpu_list_class2d']:
            GPU_LIST = self.args['--gpu_list_class2d']
            self.c.setGpu_list(GPU_LIST)
        else:
            GPU_LIST = "0"
            self.c.setGpu_list(GPU_LIST)

        input_gpu_list_cl23d = self.c.getGpu_list()
        self.c.setGPU_list_Class2D(input_gpu_list_cl23d)
    #------------------------------------------
    # Init3D
    #------------------------------------------
    def createArgs_do_ctf_correction_init3D(self):
        #--do_ctf_correction_init3D=DO_CTF_CORRECTION_INIT3D
        try:
            DO_CTF_CORRECTION_INIT3D = self.args['--do_ctf_correction_init3D']
        except:
            DO_CTF_CORRECTION_INIT3D = "yes"
        self.c.setDo_ctf_correction_init3D(DO_CTF_CORRECTION_INIT3D)

    def createArgs_n_classesInit3D(self):
        #--n_classesInit3D=N_CLASSESINIT3D
        try:
            N_CLASSESINIT3D = int(self.args['--n_classesInit3D'])
        except:
            N_CLASSESINIT3D = 1
        self.c.setNClassInit3D(N_CLASSESINIT3D)

    def createArgs_n_mskDInit3D(self):
        #--n_mskDInit3D=N_MSKDINIT3D
        try:
            N_MSKDINIT3D = int(self.args['--n_mskDInit3D'])
        except:
            N_MSKDINIT3D = 200
        self.c.setNMskDInit3D(N_MSKDINIT3D)

    def createArgs_n_poolInit3D(self):
        #--n_poolInit3D=N_POOLINIT3D
        try:
            N_POOLINIT3D = int(self.args['--n_poolInit3D'])
        except:
            N_POOLINIT3D = 100
        self.c.setNPoolInit3D(N_POOLINIT3D)

    def createArgs_symmetryInit3D(self):
        #--symmetryInit3D=SYMMETRYINIT3D
        try:
            SYMMETRYINIT3D = self.args['--symmetryInit3D']
        except:
            SYMMETRYINIT3D = "C1"
        self.c.setSymmetryInit3D(SYMMETRYINIT3D)

    def createArgs_offset_search_range_init3D(self):
        #--offset_search_range_init3D=OFFSET_SEARCH_RANGE_INIT3D
        try:
            OFFSET_SEARCH_RANGE_INIT3D = float(self.args['--offset_search_range_init3D'])
        except:
            OFFSET_SEARCH_RANGE_INIT3D = 6
        self.c.setOffset_search_range_init3D(OFFSET_SEARCH_RANGE_INIT3D)

    def createArgs_offset_search_step_init3D(self):
        #--offset_search_step_init3D=OFFSET_SEARCH_STEP_INIT3D
        try:
            OFFSET_SEARCH_STEP_INIT3D = float(self.args['--offset_search_step_init3D'])
        except:
            OFFSET_SEARCH_STEP_INIT3D = 2
        self.c.setOffset_search_step_init3D(OFFSET_SEARCH_STEP_INIT3D)

    def createArgs_n_mpi_proc_init3D(self):
        #--n_mpi_proc_init3D=N_MPI_PROC_INIT3D
        try:
            N_MPI_PROC_INIT3D = int(self.args['--n_mpi_proc_init3D'])
        except:
            N_MPI_PROC_INIT3D = 11
        self.c.setNMpiInit3D(N_MPI_PROC_INIT3D)

    def createArgs_n_thrds_init3D(self):
        #--n_thrds_init3D=N_THRDS_INIT3D
        try:
            N_THRDS_INIT3D = int(self.args['--n_thrds_init3D'])
        except:
            N_THRDS_INIT3D = 8
        self.c.setNThrdsInit3D(N_THRDS_INIT3D)

    def createArgs_gpu_list_init3d(self):
        #--gpu_list_init3d=GPU_LIST_INIT3D
        if self.args['--gpu_list_init3d']:
            GPU_LIST_INIT3D = self.args['--gpu_list_init3d']
        else:
            GPU_LIST_INIT3D = "0"
        self.c.setGPU_list_Init3D(GPU_LIST_INIT3D)
    #------------------------------------------
    # Class3D
    #------------------------------------------
    def createArgs_do_ctf_correction_class3D(self):
        #--do_ctf_correction_class3D=DO_CTF_CORRECTION_CLASS3D
        try:
            DO_CTF_CORRECTION_CLASS3D = self.args['--do_ctf_correction_class3D']
        except:
            DO_CTF_CORRECTION_CLASS3D = "yes"
        self.c.setDo_ctf_correction_class3D(DO_CTF_CORRECTION_CLASS3D)

    def createArgs_has_ctf_correction_class3D(self):
        #--has_ctf_correction_class3D=HAS_CTF_CORRECTION_CLASS3D
        try:
            HAS_CTF_CORRECTION_CLASS3D = self.args['--has_ctf_correction_class3D']
        except:
            HAS_CTF_CORRECTION_CLASS3D = "no"
        self.c.setHas_ctf_correction_class3D(HAS_CTF_CORRECTION_CLASS3D)

    def createArgs_n_classClass3D(self):
        #--n_classClass3D=N_CLASSCLASS3D
        try:
            N_CLASSCLASS3D = int(self.args['--n_classClass3D'])
        except:
            N_CLASSCLASS3D = 5
        self.c.setNClassClass3D(N_CLASSCLASS3D)

    def createArgs_n_iterClss3D(self):
        #--n_iterClss3D=N_ITERCLSS3D
        try:
            N_ITERCLSS3D = int(self.args['--n_iterClss3D'])
        except:
            N_ITERCLSS3D = 25
        self.c.setNIterClass3D(N_ITERCLSS3D)

    def createArgs_n_mskDClss3D(self):
        #--n_mskDClss3D=N_MSKDCLSS3D
        try:
            N_MSKDCLSS3D = int(self.args['--n_mskDClss3D'])
        except:
            N_MSKDCLSS3D = 200
        self.c.setNMskDClass3D(N_MSKDCLSS3D)

    def createArgs_n_poolClss3D(self):
        #--n_poolClss3D=N_POOLCLSS3D
        try:
            N_POOLCLSS3D = int(self.args['--n_poolClss3D'])
        except:
            N_POOLCLSS3D = 100
        self.c.setNPoolClass3D(N_POOLCLSS3D)

    def createArgs_symmetryClass3D(self):
        #--symmetryClass3D=SYMMETRYCLASS3D
        try:
            SYMMETRYCLASS3D = self.args['--symmetryClass3D']
        except:
            SYMMETRYCLASS3D = "C1"
        self.c.setSymmetryClass3D(SYMMETRYCLASS3D)

    def createArgs_offset_search_range_class3D(self):
        #--offset_search_range_class3D=OFFSET_SEARCH_RANGE_CLASS3D
        try:
            OFFSET_SEARCH_RANGE_CLASS3D = float(self.args['--offset_search_range_class3D'])
        except:
            OFFSET_SEARCH_RANGE_CLASS3D = 5
        self.c.setOffset_search_range_class3D(OFFSET_SEARCH_RANGE_CLASS3D)

    def createArgs_offset_search_step_class3D(self):
        #--offset_search_step_class3D=OFFSET_SEARCH_STEP_CLASS3D
        try:
            OFFSET_SEARCH_STEP_CLASS3D = float(self.args['--offset_search_step_class3D'])
        except:
            OFFSET_SEARCH_STEP_CLASS3D = 2
        self.c.setOffset_search_step_class3D(OFFSET_SEARCH_STEP_CLASS3D)

    def createArgs_n_mpi_proc_cl3d(self):
        #--n_mpi_proc_cl3d=N_MPI_PROC_CL3D
        try:
            N_MPI_PROC_CL3D = int(self.args['--n_mpi_proc_cl3d'])
        except:
            N_MPI_PROC_CL3D = 5
        self.c.setNMpiClass3D(N_MPI_PROC_CL3D)

    def createArgs_n_thrds_cl3d(self):
        #--n_thrds_cl3d=N_THRDS_CL3D
        try:
            N_THRDS_CL3D = int(self.args['--n_thrds_cl3d'])
        except:
            N_THRDS_CL3D = 4
        self.c.setNThrdsClass3D(N_THRDS_CL3D)

    def createArgs_gpu_list_class3d(self):
        #--gpu_list_class3d=GPU_LIST_CLASS3D
        if self.args['--gpu_list_class3d']:
            GPU_LIST_CLASS3D = self.args['--gpu_list_class3d']
        else:
            GPU_LIST_CLASS3D = "0"
        self.c.setGPU_list_Class3D(GPU_LIST_CLASS3D)
    #------------------------------------------
    # Refine3D
    #------------------------------------------
    def createArgs_do_ctf_correction_refine3D(self):
    #--do_ctf_correction_refine3D=DO_CTF_CORRECTION_REFINE3D
        try:
            DO_CTF_CORRECTION_REFINE3D = self.args['--do_ctf_correction_refine3D']
        except:
            DO_CTF_CORRECTION_REFINE3D = "yes"
        self.c.setDo_ctf_correction_refine3D(DO_CTF_CORRECTION_REFINE3D)

    def createArgs_has_ctf_correction_refine3D(self):
        #--has_ctf_correction_refine3D=HAS_CTF_CORRECTION_REFINE3D
        try:
            HAS_CTF_CORRECTION_REFINE3D = self.args['--has_ctf_correction_refine3D']
        except:
            HAS_CTF_CORRECTION_REFINE3D = "no"
        self.c.setHas_ctf_correction_refine3D(HAS_CTF_CORRECTION_REFINE3D)

    def createArgs_symmetryRefine3D(self):
        #--symmetryRefine3D=SYMMETRYREFINE3D
        try:
            SYMMETRYREFINE3D = self.args['--symmetryRefine3D']
        except:
            SYMMETRYREFINE3D = "C1"
        self.c.setSymmetryRefine3D(SYMMETRYREFINE3D)

    def createArgs_n_classesRefine3D(self):
        #--n_classesRefine3D=N_CLASSESREFINE3D
        try:
            N_CLASSESREFINE3D = int(self.args['--n_classesRefine3D'])
        except:
            N_CLASSESREFINE3D = 1
        self.c.setNClassRefine3D(N_CLASSESREFINE3D)

    def createArgs_n_mskDRefine3D(self):
        #--n_mskDRefine3D=N_MSKDREFINE3D
        try:
            N_MSKDREFINE3D = int(self.args['--n_mskDRefine3D'])
        except:
            N_MSKDREFINE3D = 200
        self.c.setNMskDRefine3D(N_MSKDREFINE3D)

    def createArgs_n_poolRefine3D(self):
        #--n_poolRefine3D=N_POOLREFINE3D
        try:
            N_POOLREFINE3D = int(self.args['--n_poolRefine3D'])
        except:
            N_POOLREFINE3D = 200
        self.c.setNPoolRefine3D(N_POOLREFINE3D)

    def createArgs_offset_search_range_refine3D(self):
        #--offset_search_range_refine3D=OFFSET_SEARCH_RANGE_REFINE3D
        try:
            OFFSET_SEARCH_RANGE_REFINE3D = float(self.args['--offset_search_range_refine3D'])
        except:
            OFFSET_SEARCH_RANGE_REFINE3D = 5
        self.c.setOffset_search_range_refine3D(OFFSET_SEARCH_RANGE_REFINE3D)

    def createArgs_offset_search_step_refine3D(self):
        #--offset_search_step_refine3D=OFFSET_SEARCH_STEP_REFINE3D
        try:
            OFFSET_SEARCH_STEP_REFINE3D = float(self.args['--offset_search_step_refine3D'])
        except:
            OFFSET_SEARCH_STEP_REFINE3D = 5
        self.c.setOffset_search_step_refine3D(OFFSET_SEARCH_STEP_REFINE3D)

    def createArgs_n_mpi_proc_refine3D(self):
        #--n_mpi_proc_refine3D=N_MPI_PROC_REFINE3D
        try:
            N_MPI_PROC_REFINE3D = int(self.args['--n_mpi_proc_refine3D'])
        except:
            N_MPI_PROC_REFINE3D = 5
        self.c.setNMpiRefine3D(N_MPI_PROC_REFINE3D)

    def createArgs_n_thrds_refine3D(self):
        #--n_thrds_refine3D=N_THRDS_REFINE3D
        try:
            N_THRDS_REFINE3D = int(self.args['--n_thrds_refine3D'])
        except:
            N_THRDS_REFINE3D = 4
        self.c.setNThrdsRefine3D(N_THRDS_REFINE3D)

    def createArgs_gpu_list_refine3d(self):
        #--gpu_list_refine3d=GPU_LIST_REFINE3D
        if self.args['--gpu_list_refine3d']:
            GPU_LIST_REFINE3D = self.args['--gpu_list_refine3d']
        else:
            GPU_LIST_REFINE3D = "0"
        self.c.setGPU_list_Refine3D(GPU_LIST_REFINE3D)
    #---------------------------------------------------------------------------
    # [Setters]: methods
    #---------------------------------------------------------------------------
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
    #Marker variable self.ptcl_pick_extract_Marker =  ptcl_pick_extract_Marker
    def setclass2D_Marker(self, class2d_Marker):
        self.class2d_Marker = class2d_Marker
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
    #Marker variable self.init3d_marker = init3d_marker
    #TODO: start here tomorrow or later this evening
    #      Class3D
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
    #TODO: start here tomorrow or later this evening
    #      Refine3D
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
    # [Getters]: methods
    #---------------------------------------------------------------------------
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
    #Marker variable self.ptcl_pick_extract_Marker =  ptcl_pick_extract_Marker
    def getclass2D_Marker(self):
        return self.class2d_Marker
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
    #Marker variable self.init3d_marker = init3d_marker
    #TODO: start here tomorrow or later this evening
    #      Class3D
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
    #Marker variable self.init3d_marker = init3d_marker
    #TODO: start here tomorrow or later this evening
    #      Refine3D
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
#---------------------------------------------------------------------------
# end of Command_line module
#---------------------------------------------------------------------------
