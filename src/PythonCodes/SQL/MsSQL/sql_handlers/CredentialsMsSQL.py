'''!\file
   -- LDMaP-APP addon: (Python3 code) to handle credentials
      \author Frederic Bonnet
      \date 20th of June 2021

      Leiden University June 2021

Name:
---
CredentialsMsSQL: module for the credentials


Description of classes:
---
This class creates the credentials

Requirements (system):
---
* sys
* os

Requirements (application):
---
* DataManage_common
* messageHandler
* StopWatch
* progressBar
'''
# System tools
import sys
import os
from subprocess import PIPE, run
# appending the utils path
sys.path.append(os.path.join(os.getcwd(), '.'))
sys.path.append(os.path.join(os.getcwd(), '..','..','..'))
sys.path.append(os.path.join(os.getcwd(), '..','..','..','utils'))
# application imports
import src.PythonCodes.DataManage_common
import src.PythonCodes.utils.StopWatch
import src.PythonCodes.SQL.MsSQL.sql_handlers.credDetails
# ------------------------------------------------------------------------------
# Class to read star file from Relion
# file_type can be 'mrc' or 'ccp4' or 'imod'.
# ------------------------------------------------------------------------------
# ******************************************************************************
##\brief Python3 method.
# Class to read star file from Relion
# file_type can be 'mrc' or 'ccp4' or 'imod'.
class CredentialsMsSQL:
    #***************************************************************************
    ##\brief Python3 method.
    #The constructor and Initialisation of the class for the PoolCreator.
    #Strip the header and generate a raw asc file to bootstarp on.
    #\param self       The object
    #\param c          Common class
    #\param m          Messenger class
    def __init__(self, c, m):
        # data_path, projectName, targetdir ,gainmrc, software):
        import os.path
        __func__= sys._getframe().f_code.co_name
        # first mapping the input to the object self
        self.c = c
        self.m = m
        self.m.printMesgStr("Instantiating the class       :", self.c.getGreen(), "CredentialsMsSQL")
        self.app_root = self.c.getApp_root()        # app_root
        self.data_path = self.c.getData_path()      # data_path
        self.projectName = self.c.getProjectName()  # projectName
        self.targetdir = self.c.getTargetdir()      # targetdir
        self.software = self.c.getSoftware()        # software
        self.pool_componentdir = self.c.getPool_componentdir() # "_Pool or not"        # Instantiating logfile mechanism
        logfile = self.c.getLogfileName()
        self.pool_targetdir = os.path.join(self.targetdir,
                                           self.projectName,
                                           self.pool_componentdir)
        self.c.setPool_Targetdir(self.pool_targetdir)
        # ----------------------------------------------------------------------
        # Starting the timers for the constructor
        # ----------------------------------------------------------------------
        if c.getBench_cpu():
            # creating the timers and starting the stop watch...
            stopwatch = src.PythonCodes.utils.StopWatch.createTimer()
            src.PythonCodes.utils.StopWatch.StartTimer(stopwatch)

        self.m.printMesgAddStr(" app_root                  --->: ", self.c.getYellow(), self.app_root)
        self.m.printMesgAddStr(" data_path                 --->: ", self.c.getGreen(), str(self.data_path))
        self.m.printMesgAddStr(" projectName               --->: ", self.c.getGreen(), str(self.projectName))
        self.m.printMesgAddStr(" targetdir                 --->: ", self.c.getMagenta(), str(self.targetdir))
        self.m.printMesgAddStr(" Software                  --->: ", self.c.getRed(), str(self.software))
        self.m.printMesgAddStr(" Pool path                 --->: ", self.c.getBlue(), str(self.pool_targetdir))
        self.m.printMesgAddStr(" Pool targetdir            --->: ", self.c.getGreen(), self.c.getPool_Targetdir())
        # ----------------------------------------------------------------------
        # Setting up the file environment
        # ----------------------------------------------------------------------
        self.server   = src.PythonCodes.SQL.MsSQL.sql_handlers.credDetails.server
        self.database = src.PythonCodes.SQL.MsSQL.sql_handlers.credDetails.database
        self.username = src.PythonCodes.SQL.MsSQL.sql_handlers.credDetails.username
        self.password = src.PythonCodes.SQL.MsSQL.sql_handlers.credDetails.password
        # POstGreSQL database
        self.server_PostGreSQL   = src.PythonCodes.SQL.MsSQL.sql_handlers.credDetails.server_PostGreSQL
        self.database_PostGreSQL = src.PythonCodes.SQL.MsSQL.sql_handlers.credDetails.database_PostGreSQL
        self.schema_PostGreSQL   = src.PythonCodes.SQL.MsSQL.sql_handlers.credDetails.schema_PostGreSQL
        self.username_PostGreSQL = src.PythonCodes.SQL.MsSQL.sql_handlers.credDetails.username_PostGreSQL
        self.password_PostGreSQL = src.PythonCodes.SQL.MsSQL.sql_handlers.credDetails.password_PostGreSQL
        self.port_PostGreSQL     = src.PythonCodes.SQL.MsSQL.sql_handlers.credDetails.port_PostGreSQL
    # ----------------------------------------------------------------------
        # Reporting time taken to instantiate and strip initial star file
        # ----------------------------------------------------------------------
        if c.getBench_cpu():
            src.PythonCodes.utils.StopWatch.StopTimer_secs(stopwatch)
            info = self.c.GetFrameInfo()
            self.m.printBenchMap("data_path",self.c.getRed(), self.data_path, info, __func__)
            self.m.printBenchTime_cpu("Read data_path file", self.c.getBlue(), stopwatch, info, __func__)
        # ----------------------------------------------------------------------
        # end of constructor __init__(self, path, file_type)
        # ----------------------------------------------------------------------
    # --------------------------------------------------------------------------
    # [Methods] for the class
    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    # [Generators]
    # --------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Creator]
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Reader]
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [JSon-Interpretors]
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
#-------------------------------------------------------------------------------
# end of CredentialsMsSQL module
#-------------------------------------------------------------------------------
