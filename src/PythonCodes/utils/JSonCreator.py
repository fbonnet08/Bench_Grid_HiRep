'''!\file
   -- LDMaP-APP addon: (Python3 code) to handle the sql scripting and
      generation for incoming data from the microscopes into a pool of
      file for a given project
      (code under construction and subject to constant changes).
      \author Frederic Bonnet
      \date 19th of June 2021

      Leiden University June 2021

Name:
---
JSonCreator: module for launching scanning the file from the projects folder and
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
import json
import numpy
import datetime
import time
#from subprocess import PIPE, run
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
class JSonCreator:
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
        self.m.printMesgStr("Instantiating the class       :", self.c.getGreen(), "JSonCreator")
        self.app_root = self.c.getApp_root()                    # app_root
        self.data_path = self.c.getData_path()                  # data_path
        self.projectName = self.c.getProjectName()              # projectName
        self.targetdir = self.c.getTargetdir()                  # targetdir
        self.software = self.c.getSoftware()                    # software
        self.pool_componentdir = self.c.getPool_componentdir()  # "_Pool or not"
        # Some fix variables
        self.ext_asc = ".asc"
        self.ext_csv = ".csv"
        self.ext_mgf = ".mgf"
        self.ext_json = ".json"
        self.undr_scr = "_"
        self.dot = "."

        # Instantiating logfile mechanism
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
        # TODO : need to fix the preamble of the class
        self.m.printMesgAddStr(" app_root                  --->: ", self.c.getYellow(), self.app_root)
        #self.m.printMesgAddStr(" data_path                 --->: ", self.c.getCyan(), str(self.data_path))
        #self.m.printMesgAddStr(" projectName               --->: ", self.c.getMagenta(), str(self.projectName))
        self.m.printMesgAddStr(" targetdir                 --->: ", self.c.getCyan(), str(self.targetdir))
        #self.m.printMesgAddStr(" Software                  --->: ", self.c.getRed(), str(self.software))
        #self.m.printMesgAddStr(" Pool path                 --->: ", self.c.getBlue(), str(self.pool_targetdir))
        self.m.printMesgAddStr(" System                    --->: ", self.c.getCyan(), system)
        self.system = system
        # ----------------------------------------------------------------------
        # Setting up the file environment
        # ----------------------------------------------------------------------
        self.json_ext = ".json"
        self.jsonfilenamelist = "target_jsonfile.txt"
        self.jsondir = "JSonFiles_json"
        self.jsontargetfile = self.pool_targetdir+os.path.sep+"target_jsonfile.txt"

        if system == 'Linux':
            self.json_write_path = os.path.join("data","local","frederic")
        else:
            self.system = "Windows"
            self.json_write_path = os.path.join("g:","frederic")

        self.json_table_file = "current_AllTableCount_rec"+self.json_ext
        # ----------------------------------------------------------------------
        # Reporting time taken to instantiate and strip innitial star file
        # ----------------------------------------------------------------------
        if c.getBench_cpu():
            src.PythonCodes.utils.StopWatch.StopTimer_secs(stopwatch)
            info = self.c.GetFrameInfo()
            self.m.printBenchMap("data_path",self.c.getRed(), self.data_path, info, __func__)
            self.m.printBenchTime_cpu("Read data_path file", self.c.getBlue(), stopwatch, info, __func__)
        # ----------------------------------------------------------------------
        # end of construtor __init__(self, path, file_type)
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
    def create_ith_molecule_JSon_file(self, ith_molecules_dict, mol_num, filename_json, outfile):
        rc = self.c.get_RC_SUCCESS()
        #----------------------------------------------------------------------------
        # Constructing the filename
        #----------------------------------------------------------------------------
        current_time = datetime.datetime.now()
        format_time = current_time.strftime('%Y-%m-%d_%H:%M:%S')
        #----------------------------------------------------------------------------
        # [opening-mol-jsonfile] Filling the JSon file with content
        #----------------------------------------------------------------------------
        outfile.write("[\n")
        #----------------------------------------------------------------------------
        # [header-mol-jsonfile] Filling the JSon file with content
        #----------------------------------------------------------------------------
        #json.dump(ith_molecules_dict, outfile, indent=8)
        start_key = "BEGIN IONS"
        end_key = "END IONS"
        MZ_REL_key = "mz rel: "
        INCHI_key = "INCHI"
        outfile.write("    {\n")
        # Now we can add additional information in the json file
        msg = "        \"" + "mol_num" + "\": \"" + str(mol_num) + "\",\n"
        outfile.write(msg)
        msg = "        \"" + "molecule_json_filename" + "\": \"" + str(filename_json).replace('\\','/') + "\",\n"
        outfile.write(msg)
        msg = "        \"" + "database_name" + "\": \"" + self.c.getDatabase_name() + "\",\n"
        outfile.write(msg)
        filename_timestamp = time.ctime(
            os.path.getctime(
                str(filename_json)
            )
        )
        msg = "        \"" + "json_creation_timestamp"           + "\": \"" + format_time + "\",\n"
        outfile.write(msg)
        msg = "        \"" + "timestamp_mgf_file"           + "\": \"" + filename_timestamp + "\",\n"
        outfile.write(msg)
        # TODO: append entries here as needed and if needed.
        #----------------------------------------------------------------------------
        # [main-mol-jsonfile] Filling the JSon file with content
        #----------------------------------------------------------------------------
        #print("ith_molecules_dict ---->: ", ith_molecules_dict)
        cnt = 0
        for key, value in ith_molecules_dict.items():
            #self.m.printMesgAddStr("[keys]: ith_molecules_dict["+str(cnt)+"]  --->: ",
            #                       self.c.getCyan(), key)
            if key == end_key:
                msg = "        \"" + key + "\": \"" + value + "\"\n"
            elif MZ_REL_key in key:
                msg = "        \"" + key + "\": [" + str(value).replace(' ', ', ') + "],\n"
            elif INCHI_key in key:
                msg = "        \"" + key + "\": \"" + str(value).replace("\"","") + "\",\n"
            else:
                msg = "        \"" + key + "\": \"" + value + "\",\n"
            outfile.write(msg)
            cnt += 1
        # [end-loop]
        outfile.write("    }\n")
        #----------------------------------------------------------------------------
        # [closing-mol-jsonfile] Filling the JSon file with content
        #----------------------------------------------------------------------------
        outfile.write("]\n")
        #----------------------------------------------------------------------------
        # [end] of Filling the JSon file with content
        #----------------------------------------------------------------------------
        return rc

    def create_MZ_Relative_JSon_file(self, scan_number, spectrum, mz_I_Rel, mz_I_Rel_sorted):
        # TODO: need to put setters and getters for the raw file in the c object
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        #  Start of method implementation
        self.m.printMesgStr("Reading spectrum from (file_json): ", self.c.getGreen(), __func__)
        self.m.printMesgAddStr("Json file scan_number      --->: ", self.c.getMagenta(), str(scan_number))
        #----------------------------------------------------------------------------
        # Getting the length of the lists
        #----------------------------------------------------------------------------
        spectrum_len = len(spectrum[:])
        mz_I_len = len(mz_I_Rel[:])
        mz_I_Rel_sorted_len = len(mz_I_Rel_sorted[:])
        #----------------------------------------------------------------------------
        # constructing the leading zeros according to 10^4
        #----------------------------------------------------------------------------
        rc, self.zerolead = self.extract_ZeroLead(numpy.power(10, 4))
        #----------------------------------------------------------------------------
        # Constructing the filename
        #----------------------------------------------------------------------------
        current_time = datetime.datetime.now()
        format_time = current_time.strftime('%Y-%m-%d_%H:%M:%S')
        filename_prefix = "spectra"
        file_format_time = 1 #current_time.strftime('%Y%m%d_%H%M%S')
        msg = self.c.getApp_root()+" "+filename_prefix+" "+self.c.getScan_number()+" "+ self.c.getRet_time()+" " + \
              self.c.getRAW_file() + " " + str(format_time) + " " + \
              str(self.c.getScan_number().zfill(len(str(self.zerolead)))) + " " + self.ext_json
        #print(" msg      -->: ", msg)
        self.m.printMesgAddStr("[file_constructors]    msg --->: ", self.c.getMagenta(), msg)

        filename = self.c.getRawfile_path() + os.path.sep + filename_prefix + self.undr_scr + \
                   str(file_format_time)+"_"+str(self.c.getScan_number().zfill(len(str(self.zerolead)))) +"_" + \
                   '{:03.2f}'.format(float(self.c.getRet_time()))+"_"+ \
                   os.path.basename(os.path.normpath(self.c.getRawfile_full_path_no_ext()))+self.ext_json

        filename_timestamp = time.ctime(
            os.path.getctime(
                str(
                    self.c.getRawfile_path() + os.path.sep + \
                    os.path.basename(os.path.normpath(self.c.getRawfile_full_path_no_ext())) + \
                    self.ext_mgf
                )
            )
        )
        #filename_timestamp = str(filename_timestamp).format('%Y-%m-%d_%H:%M:%S')
        #print("filename_timestamp --->: ", filename_timestamp)
        self.m.printMesgAddStr("[file_json]:   scan number --->: ", self.c.getMagenta(), filename)
        #----------------------------------------------------------------------------
        # Writing to file wi the try catch method
        #----------------------------------------------------------------------------
        try:
            json_file = open(filename, 'w')
            json_file.write("[\n")
            json_file.write("    {\n")

            msg = "        \"" + spectrum[0] + "\": \"" + spectrum[0] + "\",\n"
            json_file.write(msg)
            msg = "        \"" + str(spectrum[1]).split('=')[0] + "\": \"" + self.c.getPepMass() + "\",\n"
            json_file.write(msg)
            msg = "        \"" + str(spectrum[2]).split('=')[0] + "\": \"" + self.c.getCharge() + "\",\n"
            json_file.write(msg)
            msg = "        \"" + str(spectrum[3]).split('=')[0] + "\": \"" + self.c.getMSLevel() + "\",\n"
            json_file.write(msg)
            msg = "        \"" + "Scan#"                        + "\": \"" + self.c.getScan_number() + "\",\n"
            json_file.write(msg)
            msg = "        \"" + "RT"                           + "\": \"" + self.c.getRet_time() + "\",\n"
            json_file.write(msg)
            msg = "        \"" + "mgf_file"                     + "\": \"" + str(os.path.basename(os.path.normpath(self.c.getRawfile_full_path_no_ext()))+self.ext_mgf) + "\",\n"
            json_file.write(msg)
            msg = "        \"" + "json_creation_timestamp"           + "\": \"" + format_time + "\",\n"
            json_file.write(msg)
            msg = "        \"" + "timestamp_mgf_file"           + "\": \"" + filename_timestamp + "\",\n"
            json_file.write(msg)
            msg = "        \"" + "spectra_json_filename"        + "\": \"" + str(filename).replace('\\','/') + "\",\n"
            json_file.write(msg)
            # Writing the list of colum into the
            cnt = 0
            for i in range(mz_I_Rel_sorted_len):
                msg = "        \"" + \
                      'mz rel: '+str(cnt).zfill(4) + "\": [" + str(mz_I_Rel_sorted[i][0]) + ", " + \
                      str(mz_I_Rel_sorted[i][2]) + "],\n"
                cnt += 1
                json_file.write(msg)
            # [end-loop]
            msg = "        \"" + spectrum[spectrum_len-1] + "\": \"" + spectrum[spectrum_len-1] + "\"\n"
            json_file.write(msg)
            # ending the json file
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
    def create_TableCount_JSon_file(self, table_list, table_count_list):
        rc = self.c.get_RC_SUCCESS()

        self.m.printMesg("Creating the table count json file...")
        filename = os.path.join(self.getJSon_Table_write_path(),
                                self.getJSon_Table_filename())
        self.m.printMesgAddStr(" Filename          : ", self.c.getCyan(), filename)
        try:
            json_file = open(filename, 'w')
            json_file.write("[\n")
            json_file.write("    {\n")
            progressBar = src.PythonCodes.utils.progressBar.ProgressBar()
            for i in range(len(table_list)-1):
                json_file.write("        \""+table_list[i]+"\": "+"\""+str(table_count_list[i])+"\",\n")
                progressBar.update(1, len(table_list)-1)
                progressBar.printEv()
            self.m.printLine()
            progressBar.resetprogressBar()
            #-------------------------------------------------------------------
            # [Loop-end]
            #-------------------------------------------------------------------
            # Adding the last line in
            json_file.write("        \"" + table_list[len(table_list)-1] + "\": " + \
                            "\"" + str(table_count_list[len(table_list)-1]) + "\"\n")
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

    def create_IthRowTable_JSon_file(self, queryMsSQL, colName_list, table, json_data, row):
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesg("Creating the ["+table+"] table json file...")
        #----------------------------------------------------------------------------
        # Get the table count from the constructing the leading zeros according to nboot
        #----------------------------------------------------------------------------
        table_length = 0
        for idata in json_data: table_length = idata[table]
        #----------------------------------------------------------------------------
        # constructing the leading zeros according to nboot
        #----------------------------------------------------------------------------
        rc, self.zerolead = self.extract_ZeroLead(int(table_length))  # self.nboot
        #----------------------------------------------------------------------------
        # Retrieveing the ith row from the data base
        #----------------------------------------------------------------------------
        rc, rowth = queryMsSQL.query_GetRowFromTable(queryMsSQL.cursor,
                                                     queryMsSQL.credentialsMsSQL.database,
                                                     table, colName_list[0], row)
        #----------------------------------------------------------------------------
        # Constructing the filename
        #----------------------------------------------------------------------------
        ext_json = ".json"
        filename = os.path.join(self.getJSon_Table_write_path(),
                                self.getJSon_Table_filename()+str(row).zfill(len(str(self.zerolead)))+ext_json)
        self.m.printMesgAddStr(" Filename          : ", self.c.getCyan(), filename)
        #----------------------------------------------------------------------------
        # Writting to file wi the try catch method
        #----------------------------------------------------------------------------
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
    # -----------------------------------------------------------------------------
    # [Extractor] extract the zerolead from a given list or length
    # -----------------------------------------------------------------------------
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
    def getJSon_Table_filename(self):
        return self.json_table_file

    def getJSon_Table_write_path(self):
        return self.json_write_path
    #---------------------------------------------------------------------------
    # [Setters]
    #---------------------------------------------------------------------------
    def setJSon_Table_filename(self, filename):
        self.json_table_file = filename

    def setJSon_Table_write_path(self, path):
        self.json_write_path = path

    #---------------------------------------------------------------------------
    # Helper methods for the class
    #---------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# end of JSonCreator module
#-------------------------------------------------------------------------------
