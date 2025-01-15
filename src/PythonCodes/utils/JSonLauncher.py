'''!\file
   -- LDMaP-APP addon: (Python3 code) to handle the sql scripting and
      generation for incoming data from the microscopes into a pool of
      file for a given project
      (code under construction and subject to constant changes).
      \author Frederic Bonnet
      \date 27th of July 2020

      July 2020

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
import json
import sys
import os
import numpy
import subprocess
from subprocess import PIPE, run
# appending the utils path

sys.path.append(os.path.join(os.getcwd(), '.'))
sys.path.append(os.path.join(os.getcwd(), '..'))
# application imports
#from DataManage_common import *
import src.PythonCodes.DataManage_common
import src.PythonCodes.utils.StopWatch
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
class JSonLauncher:
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
        self.m.printMesgStr("Instantiating the class       :", self.c.getGreen(), "JSonLauncher")
        self.app_root = self.c.getApp_root()        # app_root
        self.data_path = self.c.getData_path()      # data_path
        self.projectName = self.c.getProjectName()  # projectName
        self.targetdir = self.c.getTargetdir()      # targetdir
        self.software = self.c.getSoftware()        # software
        self.pool_componentdir = self.c.getPool_componentdir() # "_Pool or not"
        # ----------------------------------------------------------------------
        # Tke list object declaration
        # ----------------------------------------------------------------------
        self.json_file_lst = []
        self.json_mol_file_lst = []
        self.jsonfile_content_key_lst = []
        self.jsonfile_content_value_lst = []
        self.jsonfile_content_dict_lst = []

    # ----------------------------------------------------------------------
        # Instantiating logfile mechanism
        # ----------------------------------------------------------------------
        logfile = self.c.getLogfileName()
        # ----------------------------------------------------------------------
        # Starting the timers for the constructor
        # ----------------------------------------------------------------------
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
        #'''
        self.m.printMesgAddStr("Database directory name    --->: ", self.c.getMagenta(), self.c.getDatabase_path())
        self.m.printMesgAddStr("database_full_path_no_ext  --->: ", self.c.getMagenta(), self.c.getDatabase_full_path_no_ext())
        self.m.printMesgAddStr("Database file              --->: ", self.c.getMagenta(), self.c.getDatabase_file())
        self.m.printMesgAddStr("Database name              --->: ", self.c.getMagenta(), self.c.getDatabase_name())
        self.m.printMesgAddStr("File basename              --->: ", self.c.getMagenta(), self.c.getFile_basename())
        #'''
        # ----------------------------------------------------------------------
        # Setting up the file environment
        # ----------------------------------------------------------------------
        self.json_ext = ".json"
        self.jsonfilenamelist = "target_jsonfile.txt"
        self.jsondir = "JSonFiles_json"
        self.jsontargetfile = os.path.join(self.pool_targetdir, "target_jsonfile.txt")
        # ----------------------------------------------------------------------
        # Genrating the json file target list
        # ----------------------------------------------------------------------
        rc, self.jsontargetfile = self.generate_JsonFileList(self.jsondir,
                                                             self.json_ext)
        # ----------------------------------------------------------------------
        # Reporting time taken to instantiate and strip innitial star file
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
    def generate_JsonFileList(self, jsondir, ext):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgAddStr("Generating json targetfile --->: ", self.c.getGreen(), __func__)
        fileout = self.jsontargetfile
        self.m.printMesgAddStr("[json-file ]:        (out) --->: ", self.c.getCyan(), fileout)
        self.json_mol_file_lst = []
        if self.c.get_system() == "Windows" or self.c.get_system() == "Linux":
            for (root, dirs, file) in os.walk(self.c.getPool_Targetdir()):
                for f in file:
                    if self.c.getDatabase_name() in f and "header" not in f:
                        self.json_mol_file_lst.append(str(f).strip())
            # [end-loop]
            try:
                file = open(fileout, 'w')
                #print(len(self.json_mol_file_lst[:]))
                cnt = 0
                rc, zerolead = self.extract_ZeroLead(len(self.json_mol_file_lst[:]))
                if zerolead <= numpy.power(10, 4):
                    rc, zerolead = self.extract_ZeroLead(numpy.power(10, 4))
                for i in range(len(self.json_mol_file_lst[:])):
                    mol_num = str(i).zfill(len(str(zerolead)))
                    if self.c.getDebug() == 1:
                        self.m.printMesgAddStr("Json file for mol("+mol_num+")  --->: ",
                                               self.c.getMagenta(), self.json_mol_file_lst[i])
                    msg = str(self.json_mol_file_lst[i]).strip()+"\n"
                    file.write(msg)
                    cnt += 1
                # [end-loop]
                #self.m.printMesgStr("[JSonFile("+str(cnt) + ")]: Could not open file:", self.c.get_B_Red(), file)
                file.close()
            except IOError:
                self.m.printMesgAddStr(" Filename          : ", self.c.getCyan(), fileout)
                self.m.printMesgAddStr("                   : ",
                self.c.getRed(), "cannot be written check if path exist")
                exit(self.c.get_RC_FAIL())

        else:
            ls_cmd = [jsondir+os.path.sep+"*_JsonFile"+ext, ">", fileout]
            CMD = ' '.join(ls_cmd)
            self.m.printMesgStr("CMD: ls -1 ", self.c.get_B_Magenta(), CMD)
            os.system('ls -1 %s'%CMD)

        return rc, fileout
    #---------------------------------------------------------------------------
    # [Creator]
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Reader]
    #---------------------------------------------------------------------------
    def getListOfJsonFiles(self, target_file):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Getting the list of Jason files: ", self.c.getGreen(), __func__)
        self.json_file_lst = []
        list_len = 0
        try:
            file = open(target_file, 'r')
            self.json_file_lst = file.readlines()   #read().splitlines()
            for i in range(len(self.json_file_lst)):
                list_len += 1
        except IOError:
            rc = self.c.get_RC_WARNING()
            self.m.printMesgStr("[target_file]: Could not open file:",
                           self.c.get_B_Red(), target_file)
            list_len = 0
            #exit(-1) #self.c.get_RC_FAIL())

        self.m.printCMesgValMesgVal(self.c.getBlue(),"Read from file: ",
                                    self.c.getCyan(),target_file,
                                    " ---> length list_len: ",
                                    self.c.getMagenta(), list_len)
        return rc, list_len, self.json_file_lst[:]
    #---------------------------------------------------------------------------
    # [JSon-Interpreters]
    #---------------------------------------------------------------------------
    def ReadingMoleculeJsonFile(self, filelist):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Reading in the Molecule Json file list: ", self.c.getGreen(), __func__)
        self.jsonfile_content_key_lst = []
        self.jsonfile_content_value_lst = []
        ith_data_key = []
        ith_data_value = []
        cnt = 0
        try:
            self.jsonfile_content_dict_lst = []
            for i in range(len(filelist)):
                filein = os.path.join(self.c.getPool_Targetdir(),
                                      str(filelist[i]).split('\n')[0])
                #print("filein --->: ", filein)
                jfile = open(filein, 'r')
                jsondata = json.load(jfile)
                for idata in jsondata:
                    '''
                    msg = "["+str(i)+"]"                           + " <---> " \
                        + self.c.getYellow() + idata['FEATURE_ID'] + " <---> " \
                        + self.c.getCyan() + str(idata['PEPMASS']) + " <...> " \
                        + self.c.getYellow() + idata['SOURCE_INSTRUMENT']
                    self.m.printMesgAddStr(" Json file [" + self.c.getMagenta() + str(filelist[i]).split('\n')[0] + \
                        self.c.getBlue()+"] entry: ", self.c.getGreen(), msg)
                    '''
                    ith_data_key = []
                    ith_data_value = []
                    for key, value in idata.items():
                        ith_data_key.append(key)
                        ith_data_value.append(value)

                    self.jsonfile_content_key_lst.append(ith_data_key[:])
                    self.jsonfile_content_value_lst.append(ith_data_value[:])
                    self.jsonfile_content_dict_lst.append(idata)

                    '''
                    jsonfile_content.append([idata['EntryID']
                                                , idata['CTF_values']
                                                , idata['Frame']
                                                , idata['DataMRC']
                                                , idata['SumCor2Live_mrc']
                                                , idata['SumCor2Live_txt']
                                                , idata['SumCor2FitCoeffLive_log']
                                                , idata['SumCor2FrameLive_log']
                                                , idata['SumCor2FullLive_log']
                                                , idata['SumCor2PatchLive_log']
                                                , idata['CTF_SumCor2Live_mrc']
                                                , idata['CTF_SumCor2Live_txt']
                                                , idata['CTF_SumCor2DiagAvrLive_png']
                                                , idata['CTF_SumCor2DiagAvrLive_txt']
                                                , idata['CTF_SumCor2DiagCTFLive_png']])
                    '''
                    cnt += 1
                # [end-loop]
                jfile.close()
        except:
            rc = self.c.get_RC_FAIL()
            self.m.printMesgStr("[JSonFile("+str(cnt)+")]: Could not open file:", self.c.get_B_Red(), jfile)
            cnt = 0
            exit(rc)
        #End of the try catch
        return rc, self.jsonfile_content_dict_lst, self.jsonfile_content_key_lst, self.jsonfile_content_value_lst

    def ReadingCTFJsonFile(self, filelist):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()

        jsonfile_content = []
        msg = ""
        cnt = 0
        try:
            for i in range(len(filelist)):
                jfile = open(filelist[i],'r')
                jsondata = json.load(jfile)
                for idata in jsondata:
                    msg = "["+str(i)+"]"                              +" <---> " \
                          +self.c.getYellow() + idata['EntryID']      +" <---> " \
                          +self.c.getCyan() + str(idata['CTF_values'])+" <...> " \
                          +self.c.getYellow() + idata['CTF_SumCor2DiagCTFLive_png']
                    #self.m.printMesgAddStr(" Json file entry: ",
                    #                       self.c.getGreen(), msg)
                    jsonfile_content.append([idata['EntryID']
                                                , idata['CTF_values']
                                                , idata['Frame']
                                                , idata['DataMRC']
                                                , idata['SumCor2Live_mrc']
                                                , idata['SumCor2Live_txt']
                                                , idata['SumCor2FitCoeffLive_log']
                                                , idata['SumCor2FrameLive_log']
                                                , idata['SumCor2FullLive_log']
                                                , idata['SumCor2PatchLive_log']
                                                , idata['CTF_SumCor2Live_mrc']
                                                , idata['CTF_SumCor2Live_txt']
                                                , idata['CTF_SumCor2DiagAvrLive_png']
                                                , idata['CTF_SumCor2DiagAvrLive_txt']
                                                , idata['CTF_SumCor2DiagCTFLive_png']])
                cnt += 1
                jfile.close()
        except:
            rc = self.c.get_RC_WARNING()
            self.m.printMesgStr("[JSonFile("+str(cnt) + \
                                ")]: Could not open file:",
                                self.c.get_B_Red(), "jfile")
            cnt = 0
        #End of the try catch
        return rc, jsonfile_content
    # --------------------------------------------------------------------------
    # [Extractor] extract the zerolead from a given list or length
    # --------------------------------------------------------------------------
    def extract_ZeroLead(self, nrows):
        rc = self.c.get_RC_SUCCESS()
        __func__ = sys._getframe().f_code.co_name
        # ----------------------------------------------------------------------
        # constructing the leading zeros according to nboot
        # ----------------------------------------------------------------------
        zerolead = 0
        # counting the number of digits in self.nboot
        import math
        if nrows > 0:
            digits = int(math.log10(nrows)) + 1
        elif nrows == 0:
            digits = 1
        else:
            digits = int(math.log10(-nrows)) + 2
        zerolead = numpy.power(10, digits)
        # ----------------------------------------------------------------------
        # End of method return statement
        # ----------------------------------------------------------------------
        return rc, zerolead
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
# end of JSonLauncher module
#-------------------------------------------------------------------------------
