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
* messageHandler
* StopWatch
* progressBar

'''
# System tools
import subprocess
import sys
import os
import json
import numpy as np
from subprocess import PIPE, run
# appending the utils path
sys.path.append(os.path.join(os.getcwd(), '.'))
sys.path.append(os.path.join(os.getcwd(), '..'))
# application imports
#from DataManage_common import whichPlatform
import src.PythonCodes.DataManage_common
#platform, release  = whichPlatform()
sysver, platform, system, release, node, processor, cpu_count = src.PythonCodes.DataManage_common.whichPlatform()
#from progressBar import *
import src.PythonCodes.utils.StopWatch
import src.PythonCodes.utils.progressBar
# ------------------------------------------------------------------------------
# Class to read star file from Relion
# file_type can be 'mrc' or 'ccp4' or 'imod'.
# ------------------------------------------------------------------------------
# ******************************************************************************
##\brief Python3 method.
# Class to read star file from Relion
# file_type can be 'mrc' or 'ccp4' or 'imod'.
class JSonScanner:
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
        self.m.printMesgStr("Instantiating the class       :", self.c.getGreen(), "JSonScanner")
        self.app_root = self.c.getApp_root()        # app_root
        self.json_scan_dir = self.c.getJSon_Scan_Dir() #Json dir to be scanned
        self.table_cnts_dir = self.c.getJSon_TableCounts_Dir()
        # Instantiating logfile mechanism
        logfile = self.c.getLogfileName()

        #-----------------------------------------------------------------------
        # Starting the timers for the constructor
        #-----------------------------------------------------------------------
        stopwatch = src.PythonCodes.utils.StopWatch.createTimer()
        if c.getBench_cpu():
            # creating the timers and starting the stop watch...
            src.PythonCodes.utils.StopWatch.StartTimer(stopwatch)

        self.m.printMesgAddStr(" app_root                  --->: ", self.c.getYellow(), self.app_root)
        self.m.printMesgAddStr(" Json scanning dir         --->: ", self.c.getGreen(), self.json_scan_dir)
        self.m.printMesgAddStr(" Table counts dir          --->: ", self.c.getMagenta(), self.table_cnts_dir)
        self.system = system
        #-----------------------------------------------------------------------
        # Setting up the file environment
        #-----------------------------------------------------------------------
        self.json_ext = ".json"

        if system == 'Linux':
            self.json_write_path = os.path.join("data","local","frederic")
        else:
            self.system = "Windows"
            self.json_write_path = os.path.join("g:","frederic")

        self.json_table_file = "current_TableCount_jsonfile"+self.json_ext

        self.ScanTableFileList_txt = self.app_root+os.path.sep+"Scanner_Table_fileList.txt"
        
        self.m.printMesgAddStr(" JSon TableCount           --->: ", self.c.getMagenta(), self.json_table_file)
        self.m.printMesgAddStr(" System                    --->: ", self.c.getCyan(), system)
        #-----------------------------------------------------------------------
        # Setting the list for the records scanned
        #-----------------------------------------------------------------------
        self.record_Table_file_lst = []
        self.table_key_lst = []
        self.table_val_lst = []

        self.ls_lst_frame = []
        self.ls_lst_gainR = []
        #-----------------------------------------------------------------------
        # Reporting time taken to instantiate and strip innitial star file
        #-----------------------------------------------------------------------
        if c.getBench_cpu():
            src.PythonCodesutils.StopWatch.StopTimer_secs(stopwatch)
            info = self.c.GetFrameInfo()
            self.m.printBenchTime_cpu("Read data_path file", self.c.getBlue(), stopwatch, info, __func__)
        # ----------------------------------------------------------------------
        # end of construtor __init__(self, path, file_type)
        # ----------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Methods] for the class
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Generators]
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Extractor]
    #---------------------------------------------------------------------------
    def extract_RecordList(self, table):
        __func__ = sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        # First clearing out the list
        self.record_Table_file_lst.clear()
        #-----------------------------------------------------------------------
        # Contruct the ls command
        #-----------------------------------------------------------------------
        self.ScanTableFileList_txt = self.app_root+os.path.sep+\
                                     "Scanner_"+table+"_fileList.txt" 
        #-----------------------------------------------------------------------
        # Moving to the json path location to make sure all good operation
        #-----------------------------------------------------------------------
        self.move_to_dir(self.c, self.m, self.json_scan_dir)
        #-----------------------------------------------------------------------
        # Generating the Scanner files
        #-----------------------------------------------------------------------
        file_to_scan = "*"+table+"*"+self.json_ext 
        ls_cmd = [file_to_scan,">", self.ScanTableFileList_txt]
        CMD = ' '.join(ls_cmd)
        self.m.printMesgAddStr(" Scan ls command   : ",self.c.getYellow(),
                               "ls -1 "+CMD)
        rc_ls = os.system('ls -1 %s'%CMD)
        #-----------------------------------------------------------------------
        # Moving to the app_root path location to make sure all good operation
        #-----------------------------------------------------------------------
        self.move_to_dir(self.c, self.m, self.app_root)
        #-----------------------------------------------------------------------
        # Getting the file list
        #-----------------------------------------------------------------------
        self.m.printMesgAddStr(" Reading Scanner   : ",
                               self.c.getCyan(), self.ScanTableFileList_txt)
        try:
            file_list = open(self.ScanTableFileList_txt, 'r')
            lines = file_list.readlines()
            progressBar = utils.progressBar.ProgressBar()
            nlines = len(lines)
            for ilines in lines:
                self.record_Table_file_lst.append(ilines)
                progressBar.update(1, nlines)
                progressBar.printEv()
            self.m.printLine()
            progressBar.resetprogressBar()
            file_list.close()
        except IOError:
            self.m.printMesgAddStr(" Scanner File List : ",
                                   self.c.getCyan(), self.ScanTableFileList_txt)
            self.m.printMesgAddStr("                   : ",
                                   self.c.getRed(), "Cannot be read check"
                                                    " if file exist")
            #exit(self.c.get_RC_FAIL())
        #-----------------------------------------------------------------------
        # End of method
        #-----------------------------------------------------------------------
        return rc, self.record_Table_file_lst
    #---------------------------------------------------------------------------
    # [Readers]
    #---------------------------------------------------------------------------
    def read_IthRowTable_JSon_file(self, table, json_data):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesg("Creating the ["+table+"] table json file...")
        #-----------------------------------------------------------------------
        # Get the table count from the constructing the leading zeros
        # according to nboot
        #-----------------------------------------------------------------------
        table_length = 0
        for idata in json_data:
            self.table_key_lst.clear()
            self.table_val_lst.clear()
            for key, val in idata.items():
                table_length += 1
                self.m.print_key_val_table(self.c, table, key, val)
                self.table_key_lst.append(key)
                self.table_val_lst.append(val)
        #-----------------------------------------------------------------------
        # constructing the leading zeros according to nboot
        #-----------------------------------------------------------------------
        self.m.printMesgAddStr(" "+table+" length: ",
                               self.c.getCyan(), table_length)

        return rc, self.table_key_lst, self.table_val_lst
    #---------------------------------------------------------------------------
    # [Finders]
    #---------------------------------------------------------------------------
    def find_ProjectFolder(self, data_path, key_lst, val_lst):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Extracting and constructing the project folder from",
                       self.c.getCyan(), "ProjectsNameID" + self.c.getBlue() + \
                            " and " + self.c.getMagenta() + "ProjectNumber")

        ProjectsNameID = val_lst[key_lst[:].index("ProjectsNameID")]
        ProjectNumber = val_lst[key_lst[:].index("ProjectNumber")]
        self.m.printMesgAddStr(" ProjectsNameID            : ", self.c.getCyan(), ProjectsNameID)
        self.m.printMesgAddStr(" ProjectNumber             : ", self.c.getMagenta(), ProjectNumber)

        scanfolder = data_path + " |grep \"" + str(ProjectsNameID) + "_" + str(ProjectNumber) + "\""
        CMD = "ls -1 %s | awk \'{print $0}\'" % scanfolder
        self.m.printMesgAddStr(" Project Folder command    : ", self.c.getYellow(), CMD)
        stdout = subprocess.run(CMD, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                universal_newlines=True, shell=True).stdout

        ls_lst = stdout.splitlines()
        projectfolder = "Unknown"
        if len(ls_lst) == 0:
            self.m.printMesgAddStr(" Project Folder            : ", self.c.getRed(), str(ls_lst[:])+" Not found or Does not exits")
            self.m.printMesgAddStr("                           : ", self.c.getRed(), "Try different data_path or server location.")
            self.m.printMesgAddStr("                           : ", self.c.getRed(), "It may also be on krios2 prior to _Frames folders creation")
            self.m.printMesgAddStr("                           : ", self.c.getRed(), "If the --OperatorsINDX > 4 then data exists. Try: /data/krio2buffer")
        elif len(ls_lst) > 0:
            projectfolder = ls_lst[0]
            self.m.printMesgAddStr(" Project Folder            : ", self.c.getGreen(), projectfolder)
        elif len(ls_lst) < 0:
            self.m.printMesgAddStr(" Unknown error from CMD    : ", self.c.getGreen(), CMD)
        return rc, projectfolder

    #Get the frames foldere from the data_path from keys
    def find_FramesFolder(self, data_path, projectfolder):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Extracting and Constructing the project space for ProjectFolder:", self.c.getCyan(), projectfolder)
        scanfolder = data_path + os.path.sep + projectfolder
        self.m.printMesgAddStr(" Project Folder            : ", self.c.getGreen(), projectfolder)
        CMD = "ls -1 %s | awk \'{print $0}\'" % scanfolder
        self.m.printMesgAddStr(" Project Folder command    : ", self.c.getYellow(), CMD)
        stdout = subprocess.run(CMD, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                universal_newlines=True, shell=True).stdout
        ls_lst = stdout.splitlines()
        self.ls_lst_frame.clear()
        self.ls_lst_gainR.clear()
        for i in range(len(ls_lst)):
            filename, ext = os.path.splitext(ls_lst[i])
            if ext == ".dm4" or ext == ".mrc": self.ls_lst_gainR.append(ls_lst[i])
            if ext == "":
                frames_fld = ls_lst[i] + "_Frames"
                path_to_check = data_path + os.path.sep + frames_fld
                if os.path.exists(path_to_check):
                    self.ls_lst_frame.append(ls_lst[i] + "_Frames")
        # ----------------------------------------------------------------------------
        # [Printers] finding the frames  folder from the project folder
        # ----------------------------------------------------------------------------
        for i in range(len(self.ls_lst_frame)):
            self.m.printMesgAddStr(" Frames folders generated  : ", self.c.getCyan(), self.ls_lst_frame[i])
        for i in range(len(self.ls_lst_gainR)):
            self.m.printMesgAddStr(" Gain Reference created    : ", self.c.getMagenta(), self.ls_lst_gainR[i])

        return rc, self.ls_lst_frame, self.ls_lst_gainR
    #---------------------------------------------------------------------------
    # [Creator]
    #---------------------------------------------------------------------------
    def create_IthRowTable_JSon_file(self, queryMsSQL, colName_list, table,
                                     json_data, row):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesg(" Creating the ["+table+"] table json file...")
        #-----------------------------------------------------------------------
        # Get the table count from the constructing the leading zeros
        # according to nboot
        #-----------------------------------------------------------------------
        table_length = 0
        for idata in json_data: table_length = idata[table]
        #-----------------------------------------------------------------------
        # constructing the leading zeros according to nboot
        #-----------------------------------------------------------------------
        rc, self.zerolead = self.extract_ZeroLead(int(table_length))
        #-----------------------------------------------------------------------
        # Retrieveing the ith row from the data base
        #-----------------------------------------------------------------------
        rc, rowth = queryMsSQL.query_GetRowFromTable(queryMsSQL.cursor,
                                                     queryMsSQL.credentialsMsSQL.database,
                                                     table, colName_list[0], row)
        #-----------------------------------------------------------------------
        # Constructing the filename
        #-----------------------------------------------------------------------
        ext_json = ".json"
        filename = os.path.join(self.getJSon_Table_write_path(),
                                self.getJSon_Table_filename()+           \
                                str(row).zfill(len(str(self.zerolead)))+ \
                                ext_json)
        self.m.printMesgAddStr(" Filename          : ",
                               self.c.getCyan(), filename)
        #-----------------------------------------------------------------------
        # Writting to file wi the try catch method
        #-----------------------------------------------------------------------
        try:
            json_file = open(filename, 'w')
            json_file.write("[\n")
            json_file.write("    {\n")

            # Writting the list of colum into the
            value = ""
            for icol in range(len(colName_list[:]) - 1):
                if str(rowth[icol]) == 'None':
                    value = ""
                else:
                    value = str(rowth[icol])
                msg = "        \"" + colName_list[icol] + "\": \"" + value + "\",\n"

                json_file.write(msg)
            # Taking care of the last entry tin the list
            if str(rowth[len(colName_list[:]) - 1]) == 'None':
                value = ""
            else:
                value = str(rowth[len(colName_list[:]) - 1])
            last_colum = "        \"" + colName_list[len(colName_list[:]) - 1] + "\": \"" + value + "\"\n"
            json_file.write(last_colum)

            json_file.write("    }\n")
            json_file.write("]\n")

            json_file.close()
        except IOError:
            self.m.printMesgAddStr(" Filename          : ",
                                   self.c.getCyan(), filename)
            self.m.printMesgAddStr("                   : ",
                                   self.c.getRed(), "cannot be written check"
                                                    " if path exist")
            exit(self.c.get_RC_FAIL())

        return rc
    #---------------------------------------------------------------------------
    # [Reader]
    #---------------------------------------------------------------------------
    def read_TableCount_JSon_file(self, json_file):
        rc = self.c.get_RC_SUCCESS()
        try:
            jfile = open(json_file, 'r')
            jsondata = json.load(jfile)
            self.m.printMesgAddStr(" Loading JSon file : ",
                                   self.c.getCyan(), json_file)
        except IOError:
            self.m.printMesgAddStr(" Json Filename     : ",
                                   self.c.getCyan(), json_file)
            self.m.printMesgAddStr("                   : ",
                                   self.c.getRed(), "does not exist check"
                                                    " if file exists")
            exit(self.c.get_RC_FAIL())
        return rc, jsondata
    #---------------------------------------------------------------------------
    # [JSon-Interpretors]
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Extractor] extract the zerolead from a given list or length
    #---------------------------------------------------------------------------
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
        zerolead = np.power(10, digits)
        # ----------------------------------------------------------------------
        # End of method return statement
        # ----------------------------------------------------------------------
        return rc, zerolead
    #---------------------------------------------------------------------------
    # [Getters]
    #---------------------------------------------------------------------------
    def getJSon_Table_filename(self): return self.json_table_file
    def getJSon_Table_write_path(self): return self.json_write_path

    def get_Value_FromTable(self, json_data, table, key):
        rc = self.c.get_RC_SUCCESS()
        __func__ = sys._getframe().f_code.co_name
        cnt = 0
        value = ""
        for idata in json_data:
            msg = "[" + str(cnt) + "]" + " <-Table-> " \
                  + self.c.getYellow() + table         \
                  + self.c.getGreen() + " <-Key-> "    \
                  + self.c.getYellow() + key           \
                  + self.c.getGreen()+ " <-Value-> "   \
                  + self.c.getCyan() + str(idata[key])
            value = idata[key]
            self.m.printMesgAddStr(" Last count                --->: ", self.c.getGreen(), msg)

            cnt += 1
        return rc, value

    def get_TableCount_FromTable(self, json_data, table, silent):
        rc = self.c.get_RC_SUCCESS()
        __func__ = sys._getframe().f_code.co_name
        cnt = 0
        count = 0
        for idata in json_data:
            msg = "[" + str(cnt) + "]" + " <-Table-> "  \
                  + self.c.getYellow() + table          \
                  + self.c.getGreen() +" <-Count-> "    \
                  + self.c.getCyan() + str(idata[table])
            count = idata[table]
            if not silent:
                self.m.printMesgAddStr(" Last count                --->: ", self.c.getGreen(), msg)
            cnt += 1
        # [end-loop]
        return rc, count
    #---------------------------------------------------------------------------
    # [Setters]
    #---------------------------------------------------------------------------
    def setJSon_Table_filename(self, filename): self.json_table_file = filename
    def setJSon_Table_write_path(self, path): self.json_write_path = path
    #---------------------------------------------------------------------------
    # Helper methods for the class
    #---------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    # [Movers] for the
    # --------------------------------------------------------------------------
    def move_to_dir(self, c, m, dirto):
        rc = c.get_RC_SUCCESS()
        __func__ = sys._getframe().f_code.co_name
        m.printMesgStr("Changing dir to   : ", c.getRed(), dirto)
        os.chdir(dirto)
        # ----------------------------------------------------------------------
        # End of the method
        # ----------------------------------------------------------------------
        return rc
#-------------------------------------------------------------------------------
# end of JSonScanner module
#-------------------------------------------------------------------------------
