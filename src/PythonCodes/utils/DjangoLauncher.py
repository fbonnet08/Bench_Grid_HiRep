'''!\file
   -- LDMaP-APP addon: (Python3 code) to handle the sql scripting and
      generation for incoming data from the microscopes into a pool of
      file for a given project
      (code under construction and subject to constant changes).
      \author Frederic Bonnet
      \date 27th of July 2020

      Leiden University July 2020

Name:
---
JSonLauncher: module for launching scanning the file from the projects folder and
                    create a pool directory for a given project.

Description of classes:
---
This class generates and handles data coming from the microscopes for given 
project folder into a pool.

It uses class MRC_Data: Read, process, and write MRC volumes.

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
sys.path.append(os.path.join(os.getcwd(), '..'))
# application imports
#from DataManage_common import *
import src.PythonCodes.DataManage_common
import src.PythonCodes.utils.StopWatch
import src.PythonCodes.utils.JSonLauncher
#from messageHandler import *
#from StopWatch import *
#from progressBar import *
# ------------------------------------------------------------------------------
# Class to read star file from Relion
# file_type can be 'mrc' or 'ccp4' or 'imod'.
# ------------------------------------------------------------------------------
# ******************************************************************************
##\brief Python3 method.
# Class to read star file from Relion
# file_type can be 'mrc' or 'ccp4' or 'imod'.
class DjangoLauncher:
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
        self.m.printMesgStr("Instantiating the class       :", self.c.getGreen(), "DjangoLauncher")
        self.app_root = self.c.getApp_root()        # app_root
        self.data_path = self.c.getData_path()      # data_path
        self.projectName = self.c.getProjectName()  # projectName
        self.targetdir = self.c.getTargetdir()      # targetdir
        self.software = self.c.getSoftware()        # software
        self.pool_componentdir = self.c.getPool_componentdir() # "_Pool or not"        # Instantiating logfile mechanism
        # The filename for the outpout
        self.launcher_djando_model_inspectdb_out_filename = "launcher_alldjango_models.ps1"
        self.alldjango_models = 'alldjango_models.py'

        self.path_to_django_manage = os.path.join('C:\\', 'Users', 'Frederic', 'AppData', 'Local',
                                                  'Programs', 'PyCharm Professional', 'plugins',
                                                  'python', 'helpers','pycharm', 'django_manage.py')
        self.path_to_MolRefAnt_DB_Django_project = os.path.join('C:/', 'Users', 'Frederic', 'OneDrive',
                                                                'UVPD-Perpignan', 'SourceCodes',
                                                                'PycharmProjects', 'MolRefAnt_DB_Django')

        logfile = self.c.getLogfileName()
        self.pool_targetdir = os.path.join(self.targetdir,
                                           self.projectName,
                                           self.pool_componentdir)
        self.c.setPool_Targetdir(self.pool_targetdir)
        # ----------------------------------------------------------------------
        # Starting the timers for the constructor
        # ----------------------------------------------------------------------
        stopwatch = src.PythonCodes.utils.StopWatch.createTimer()
        if c.getBench_cpu():
            # creating the timers and starting the stop watch...
            src.PythonCodes.utils.StopWatch.StartTimer(stopwatch)
        '''
        self.m.printMesgAddStr("Database directory name    --->: ", self.c.getMagenta(), self.c.getDatabase_path())
        self.m.printMesgAddStr("database_full_path_no_ext  --->: ", self.c.getMagenta(), self.c.getDatabase_full_path_no_ext())
        self.m.printMesgAddStr("Database file              --->: ", self.c.getMagenta(), self.c.getDatabase_file())
        self.m.printMesgAddStr("Database name              --->: ", self.c.getMagenta(), self.c.getDatabase_name())
        self.m.printMesgAddStr("Database schema            --->: ", self.c.getMagenta(), self.c.getDatabase_schema())
        self.m.printMesgAddStr("Database port              --->: ", self.c.getMagenta(), self.c.getDatabase_port())
        self.m.printMesgAddStr("File basename              --->: ", self.c.getMagenta(), self.c.getFile_basename())
        '''
        # ----------------------------------------------------------------------
        # Setting up the file environment
        # ----------------------------------------------------------------------
        self.json_ext = ".json"
        self.jsonfilenamelist = "target_jsonfile.txt"
        self.jsondir = "JSonFiles_json"
        self.jsontargetfile = self.pool_targetdir+os.path.sep+"target_jsonfile.txt"
        # ----------------------------------------------------------------------
        # Generating the json file target list
        # ----------------------------------------------------------------------
        #rc, self.jsontargetfile = self.generate_JsonFileList(self.jsondir, self.json_ext)
        jsonLauncher = src.PythonCodes.utils.JSonLauncher.JSonLauncher(c, m)
        # ----------------------------------------------------------------------
        # Reporting time taken to instantiate and strip initial star file
        # ----------------------------------------------------------------------
        if c.getBench_cpu():
            src.PythonCodes.utils.StopWatch.StopTimer_secs(stopwatch)
            info = self.c.GetFrameInfo()
            self.m.printBenchMap("data_path",self.c.getRed(),
                                 self.data_path, info, __func__)
            self.m.printBenchTime_cpu("Read data_path file",
                                      self.c.getBlue(), stopwatch, info, __func__)
        # ----------------------------------------------------------------------
        # end of constructor __init__(self, path, file_type)
        # ----------------------------------------------------------------------
    # --------------------------------------------------------------------------
    # [Methods] for the class
    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    # [Generators]
    # --------------------------------------------------------------------------
    def generate_djangoModel(self, table_list):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        self.m.printMesgStr("Django model generator        :", self.c.getGreen(), __func__)
        #print("self.c.getTagetdir(): ", self.c.getTargetdir())
        #print("TBLECNTS_DIR", self.c.getJSon_TableCounts_Dir())
        fln = open(self.launcher_djando_model_inspectdb_out_filename, 'w')
        for i in range(len(table_list[:])):
            #print(" table_list["+str(i)+"]: --->: ", table_list[i])
            msg2 = 'python \'' + self.path_to_django_manage + '\' inspectdb ' + table_list[i] + ' ' + \
                   self.path_to_MolRefAnt_DB_Django_project + ' >> ' + \
                   self.c.getJSon_TableCounts_Dir() + os.path.sep + self.alldjango_models + ';'
            self.m.printMesgAddStr(" Writing command to file   --->: ", self.c.getYellow(), msg2)
            fln.write(msg2+'\n')
            #os.system('echo %s >> getclass.ps1 '%msg2)
        # [end-loop]
        fln.close()
        self.m.printMesgAddStr(" Launch the file to create --->: ", self.c.getCyan(),
                               self.launcher_djando_model_inspectdb_out_filename)

        return rc
    #---------------------------------------------------------------------------
    # [Creator]
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Reader]
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Django]
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
# end of DjangoLauncher module
#-------------------------------------------------------------------------------
