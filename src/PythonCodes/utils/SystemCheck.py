'''!\file
   -- LDMaP-APP addon: (Python3 code) to handle the json files and
      generation for incoming data from the microscopes into a pool of
      file for a given project
      (code under construction and subject to constant changes).
      \author Frederic Bonnet
      \date 19th of July 2021

      Leiden University July 2021

Name:
---
JSonScanner: module for scanning and reading in the Json file from
             the Operator tables and projects folder and
                    create a pool directory for a given project.

Description of classes:
---
This class reads in and scans and handles data coming from the microscopes for given 
project folder into a pool.

It uses class MRC_Data: Read, process, and write MRC volumes.

Requirements (system):
---
* sys
* os

Requirements (application):
---
* DataManage_common

'''
# System tools
import subprocess
import sys
import os
# appending the utils path
sys.path.append(os.path.join(os.getcwd(), '.'))
sys.path.append(os.path.join(os.getcwd(), '..'))
# application imports
#from DataManage_common import whichPlatform
import src.PythonCodes.DataManage_common
#platform, release  = whichPlatform()
sysver, platform, system, release, node, processor, cpu_count = src.PythonCodes.DataManage_common.whichPlatform()
# ------------------------------------------------------------------------------
# Class to read star file from Relion
# file_type can be 'mrc' or 'ccp4' or 'imod'.
# ------------------------------------------------------------------------------
# ******************************************************************************
##\brief Python3 method.
# Class to read star file from Relion
# file_type can be 'mrc' or 'ccp4' or 'imod'.
class SystemCheck:
    #***************************************************************************
    ##\brief Python3 method.
    #The constructor and Initialisation of the class for the PoolCreator.
    #Strip the header and generate a raw asc file to bootstarp on.
    #\param self       The object
    #\param c          Common class
    #\param m          Messenger class
    def __init__(self, c, m):
        # data_path, projectName, targetdir ,gainmrc, software):
        __func__= sys._getframe().f_code.co_name
        # first mapping the input to the object self
        self.c = c
        self.m = m
        self.m.printMesgStr("Instantiating the class       :", self.c.getGreen(), "SystemCheck")
        self.app_root = self.c.getApp_root()        # app_root
        self.json_scan_dir = self.c.getJSon_Scan_Dir() #Json dir to be scanned
        self.table_cnts_dir = self.c.getJSon_TableCounts_Dir()
        # Instantiating logfile mechanism
        logfile = self.c.getLogfileName()
        # Field initializors
        self.MATPLOTLIB_AVAILABLE = None
        self.MATPLOTLIB_PYPLOT_AVAILABLE = None
        self.MATPLOTLIB_COLORS_AVAILABLE = None
        self.TQDM_AVAILABLE = None
        self.PANDAS_AVAILABLE = None
        self.SEABORN_AVAILABLE = None
        self.NUMPY_AVAILABLE = None
        self.IPYTHON_AVAILABLE = None
        self.IPYWIDGETS_AVAILABLE = None
        #-----------------------------------------------------------------------
        # Starting the timers for the constructor
        #-----------------------------------------------------------------------
        #---------------------------------------------------------------------------
        # system details
        #---------------------------------------------------------------------------
        # platform, release  = whichPlatform()
        #if (system == 'Linux'):
        m.printMesgStr("System                        :", c.get_B_Green(), system)
        m.printMesgStr("System time stamp             :", c.get_B_Yellow(), sysver)
        m.printMesgStr("Release                       :", c.get_B_Magenta(), release)
        m.printMesgStr("Kernel                        :", c.get_B_Cyan(), platform)
        m.printMesgStr("Node                          :", c.get_B_Magenta(), node)
        m.printMesgStr("Processor type                :", c.getMagenta(), processor)
        m.printMesgStr("CPU cores count               :", c.get_B_Green(), cpu_count)
        #-----------------------------------------------------------------------
        # Setting up the file environment
        #-----------------------------------------------------------------------
        self.system = system
        self.m.printMesgStr(" System (Obj)                 :", self.c.getCyan(), self.system)
        #-----------------------------------------------------------------------
        # Initialiazing the class
        #-----------------------------------------------------------------------
        self.initialize()
        # ----------------------------------------------------------------------
        # end of constructor __init__(self, path, file_type)
        # ----------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Methods] for the class
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Initializing]
    #---------------------------------------------------------------------------
    def initialize(self):
        __func__ = sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        # ----------------------------------------------------------------------
        try:
            import ipywidgets
            self.IPYWIDGETS_AVAILABLE = True
        except (ImportError, NameError, AttributeError, OSError):
            print(" Python package ipywidgets is not installed on your system, verify or install\n")
            self.IPYWIDGETS_AVAILABLE = False
        try:
            import IPython
            self.IPYTHON_AVAILABLE = True
        except (ImportError, NameError, AttributeError, OSError):
            print(" Python package IPython is not installed on your system, verify or install\n")
            self.IPYTHON_AVAILABLE = False
        try:
            import numpy
            self.NUMPY_AVAILABLE = True
        except (ImportError, NameError, AttributeError, OSError):
            print(" Python package numpy is not installed on your system, verify or install\n")
            self.NUMPY_AVAILABLE = False
        try:
            import matplotlib.pyplot
            self.MATPLOTLIB_PYPLOT_AVAILABLE = True
        except (ImportError, NameError, AttributeError, OSError):
            print(" Python package matplotlib.pyplot is not installed on your system, verify or install\n")
            self.MATPLOTLIB_PYPLOT_AVAILABLE = False
        try:
            import matplotlib.colors
            self.MATPLOTLIB_COLORS_AVAILABLE = True
        except (ImportError, NameError, AttributeError, OSError):
            print(" Python package matplotlib.colors is not installed on your system, verify or install\n")
            self.MATPLOTLIB_COLORS_AVAILABLE = False
        try:
            import matplotlib
            self.MATPLOTLIB_AVAILABLE = True
        except (ImportError, NameError, AttributeError, OSError):
            print(" Python package matplotlib is not installed on your system, verify or install\n")
            self.MATPLOTLIB_AVAILABLE = False
        try:
            import tqdm
            self.TQDM_AVAILABLE = True
        except (ImportError, NameError, AttributeError, OSError):
            print(" Python package tqdm is not installed on your system, verify or install\n")
            self.TQDM_AVAILABLE = False
        try:
            import pandas
            self.PANDAS_AVAILABLE = True
        except (ImportError, NameError, AttributeError, OSError):
            print(" Python package pandas is not installed on your system, verify or install\n")
            self.PANDAS_AVAILABLE = False
        try:
            import seaborn
            self.SEABORN_AVAILABLE = True
        except (ImportError, NameError, AttributeError, OSError):
            print(" Python package seaborn is not installed on your system, verify or install\n")
            self.SEABORN_AVAILABLE = False
        # ----------------------------------------------------------------------------
        #-----------------------------------------------------------------------
        # End of method
        #-----------------------------------------------------------------------
        return rc
    # [end-method] initialize
    #---------------------------------------------------------------------------
    # [Checkers]
    #---------------------------------------------------------------------------
    def check_InstalledPackages(self):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Plotting AllCases ScatterPlot :", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------
        # ----------------------------------------------------------------------------
        # [Import-checks]
        # ----------------------------------------------------------------------------
        self.m.printMesgStr("matplotlib       - installed >:", self.c.get_B_Magenta(), self.MATPLOTLIB_AVAILABLE)
        self.m.printMesgStr("matplotlib.pyplot- installed >:", self.c.get_B_Magenta(), self.MATPLOTLIB_PYPLOT_AVAILABLE)
        self.m.printMesgStr("matplotlib.colors- installed >:", self.c.get_B_Magenta(), self.MATPLOTLIB_COLORS_AVAILABLE)
        self.m.printMesgStr("tqdm             - installed >:", self.c.get_B_Magenta(), self.TQDM_AVAILABLE)
        self.m.printMesgStr("pandas           - installed >:", self.c.get_B_Magenta(), self.PANDAS_AVAILABLE)
        self.m.printMesgStr("seaborn          - installed >:", self.c.get_B_Magenta(), self.SEABORN_AVAILABLE)
        self.m.printMesgStr("numpy            - installed >:", self.c.get_B_Magenta(), self.NUMPY_AVAILABLE)
        self.m.printMesgStr("IPython          - installed >:", self.c.get_B_Magenta(), self.IPYTHON_AVAILABLE)
        self.m.printMesgStr("ipywidgets       - installed >:", self.c.get_B_Magenta(), self.IPYWIDGETS_AVAILABLE)
        # ----------------------------------------------------------------------------
        return rc
    # [end-method] initialize
    #---------------------------------------------------------------------------
    # [Readers]
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Finders]
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Creator]
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Reader]
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Getters]
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Setters]
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # Helper methods for the class
    #---------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    # [Movers] for the
    # --------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# end of SystemCheck module
#-------------------------------------------------------------------------------
