#!/usr/bin/env python3
'''!\file
   -- DataManage addon: (Python3 code) class for transforming the mgf files
                                      to database files
      \author Frederic Bonnet
      \date 19th of April 2024

      Universite de Perpignan March 2024, OBS.

Name:
---
Command_line: class MgfTransformer for transforming the mgf files to database files

Description of classes:
---
This class generates files

Requirements (system):
---
* sys
* datetime
* os
* csv
* scipy
* pandas
* seaborn
* matplotlib.pyplot
* matplotlib.dates
'''
# System imports
import sys
import datetime
import os
import operator
import numpy
import json

#application imports
import src.PythonCodes.DataManage_common

# Path extension
sys.path.append(os.path.join(os.getcwd(), '.'))
sys.path.append(os.path.join(os.getcwd(), '..'))
#Application imports
import src.PythonCodes.utils.JSonLauncher
import src.PythonCodes.utils.JSonScanner
import src.PythonCodes.utils.JSonCreator
import src.PythonCodes.utils.StopWatch
import src.PythonCodes.utils.progressBar
# Definiiton of the constructor
class MgfTransformer:
    #---------------------------------------------------------------------------
    # [Constructor] for the
    #---------------------------------------------------------------------------
    # Constructor
    def __init__(self, c, m):
        __func__= sys._getframe().f_code.co_name
        self.rc = 0
        self.c = c
        self.m = m
        self.app_root = self.c.getApp_root()
        self.m.printMesgStr("Instantiating the class       : ", self.c.getGreen(), "MgfTransformer")

        #gettign the csv file
        self.ext_asc = ".asc"
        self.ext_csv = ".csv"
        self.ext_mgf = ".mgf"
        self.ext_json = ".json"
        self.csv_len = 0
        self.csv_col = 0
        self.zerolead = 0
        self.rows = []
        #initialising the lists
        self.indnx = []
        self.columns_lst = []
        self.date = []
        self.time = []
        self.upload = []
        self.download = []
        self.newnumber = []
        self.out_data = []
        self.m_on_Z = []
        self.relative = []
        self.intensity = []
        #self.intensity_indexing = []
        #self.sorted_spec = []
        #self.sorted_intensity = []
        self.mz_intensity_relative_lst = []
        self.mz_intensity_relative_sorted_lst = []
        # spectrum details
        self.scan_number = 0
        self.Ret_time = 0.0

        self.pepmass = 355.070007324219
        self.charge = 1
        self.MSLevel = 2

        #Statistics variables
        self.sample_min      = 0.0
        self.sample_max      = 0.0
        self.sample_mean     = 0.0
        self.sample_variance = 0.0
        self.running_mean = []
        # some path iniitialisation
        self.targetdir = "./"
    # Getting the file structure in place
        self.file_asc = self.c.getPlot_asc()
        self.rawfile_full_path = self.c.getRAW_file()

        self.rawfile_path = os.path.dirname(self.rawfile_full_path)
        self.c.setRawfile_path(self.rawfile_path)

        self.rawfile_full_path_no_ext = os.path.splitext(self.rawfile_full_path)[0]
        self.c.setRawfile_full_path_no_ext(self.rawfile_full_path_no_ext)
        self.rawfile = os.path.basename(self.rawfile_full_path)
        self.basename = self.rawfile.split('.')[0]
        ext = ""
        if len(os.path.splitext(self.rawfile_full_path)) > 1: ext = os.path.splitext(self.rawfile_full_path)[1]

        # print("basename: ", basename)
        self.m.printMesgAddStr("rawfile directory name     --->: ", self.c.getMagenta(), self.rawfile_path)
        self.m.printMesgAddStr("rawfile_full_path_no_ext   --->: ", self.c.getMagenta(), self.rawfile_full_path_no_ext)
        self.m.printMesgAddStr("raw file                   --->: ", self.c.getMagenta(), self.rawfile)
        self.m.printMesgAddStr("ext                        --->: ", self.c.getMagenta(), ext)
        self.file_csv = self.basename+self.ext_csv
        self.c.setCSV_file(self.file_csv)
        self.file_asc = self.basename+self.ext_asc
        self.c.setPlot_asc(self.file_asc)
        self.m.printMesgAddStr("the csv file is then       --->: ", self.c.getMagenta(), self.file_csv)
        self.file_mgf = self.basename+self.ext_mgf
        self.c.setMGF_file(self.file_mgf)
        self.m.printMesgAddStr("the mgf file is then       --->: ", self.c.getMagenta(), self.file_mgf)
        # printing the files:
        self.printFileNames()

        #-----------------------------------------------------------------------
        # [Constructor-end] end of the constructor
        #-----------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Driver]
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Plotters]
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Handlers]
    #---------------------------------------------------------------------------
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
    # [Creator]
    #---------------------------------------------------------------------------
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
    #---------------------------------------------------------------------------
    # [Writters]
    #---------------------------------------------------------------------------
    def write_spectrum_to_json(self, spectrum, mz_I_Rel, mz_I_Rel_sorted):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        spectrum_len = len(spectrum[:])
        mz_I_len = len(mz_I_Rel[:])
        mz_I_Rel_sorted_len = len(mz_I_Rel_sorted[:])
        self.m.printMesgStr("Extracting spectrum (file_mgf): ", self.c.getGreen(), __func__)
        self.m.printMesgAddStr("[spectrum]:         length --->: ", self.c.getMagenta(), spectrum_len)
        self.m.printMesgAddStr("[mz_I]:             length --->: ", self.c.getRed(), mz_I_len)
        self.m.printMesgAddStr("[mz_I_Rel_sort]:    length --->: ", self.c.getGreen(), mz_I_Rel_sorted_len)
        self.m.printMesgAddStr("[file_mgf]: retention time --->: ", self.c.getCyan(), self.c.getRet_time())
        self.m.printMesgAddStr("[file_mgf]: scan number    --->: ", self.c.getYellow(), self.c.getScan_number())

        msg = str(mz_I_Rel_sorted[0]) + self.c.getBlue() + " index ---> "+ \
              self.c.getMagenta()+str(mz_I_Rel.index(mz_I_Rel_sorted[0]))
        self.m.printMesgAddStr("[mz_I_Rel_sorted[0]]       --->: ", self.c.getGreen(), msg)

        self.m.printMesgAddStr("[index]                    --->: ",
                               self.c.getMagenta(), "mz_I_Rel.index(mz_I_Rel_sorted[0])+5")
        msg = str(spectrum[mz_I_Rel.index(mz_I_Rel_sorted[0])+5]) + \
              self.c.getBlue() + " index ---> "+\
              self.c.getMagenta()+str(spectrum.index(spectrum[mz_I_Rel.index(mz_I_Rel_sorted[0])+5]))
        self.m.printMesgAddStr("[spectrum[index]           --->: ", self.c.getYellow(), msg)

        jsonCreator = src.PythonCodes.utils.JSonCreator.JSonCreator(self.c, self.m)
        rc = jsonCreator.create_MZ_Relative_JSon_file(self.c.getScan_number(),
                                                      spectrum,
                                                      mz_I_Rel, mz_I_Rel_sorted)

        return rc
    #---------------------------------------------------------------------------
    # [Reader]
    #---------------------------------------------------------------------------
    def read_spectrum_from_json(self, json_file):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        spectrum = []
        spectrum_len = len(spectrum[:])
        self.m.printMesgStr("Reading spectrum from (file_json): ", self.c.getGreen(), __func__)
        # todo: implement the json file reader here.

        return rc, spectrum
    def read_mgf_file(self, mgf_file, scan, retention_time):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        mgf_len = 0
        self.m.printMesgStr("Extracting spectrum (file_mgf): ", self.c.getGreen(), __func__)
        self.m.printMesgAddStr("[file_mgf]: retention time --->: ", self.c.getYellow(), retention_time)
        self.m.printMesgAddStr("[file_mgf]: scan number    --->: ", self.c.getYellow(), scan)
        start_key = "BEGIN IONS"
        end_key = "END IONS"
        trigger_key = "Scan#: "+str(scan)   # "PEPMASS"
        # check if the files names are correct
        msg = "[file_mgf]:     (checking) --->: "+self.c.getMagenta()+mgf_file +\
              self.c.getBlue()+" <--> "+self.c.getMagenta()+self.file_mgf+", "
        if mgf_file == self.file_mgf:
            self.m.printMesgAddStr(msg, self.c.getGreen(), "SUCCESS -->: are the same")
        else:
            rc = self.c.get_RC_WARNING()
            self.m.printMesgAddStr(msg, self.c.getRed(), "WARNING -->: are not the same")

        file_path = self.rawfile_path+os.sep+self.file_mgf
        if os.path.isfile(file_path):
            msg = file_path + self.c.getGreen() + " ---> Exists"
            self.m.printMesgAddStr("[file_mgf]:     (mgf file) --->: ", self.c.getMagenta(), msg)
        else:
            msg = file_path + self.c.getRed() + " ---> Does not exists"
            rc = self.c.get_RC_FAIL()
            self.m.printMesgAddStr("[file_mgf]:     (mgf file) --->: ", self.c.getMagenta(), msg)
            src.PythonCodes.DataManage_common.getFinalExit(self.c, self.m, rc)

        try:
            #print("file_path -=-- > ", file_path)
            file = open(file_path)
            lines = file.readlines()
            mgf_len = len(lines)
            ith_line = 0
            cnt = 0
            for i in range(mgf_len):
                if trigger_key in lines[i].split('\n')[0]:
                    cnt = ith_line
                    break
                ith_line += 1
                #print("lines["+str(i)+"]", lines[i].split('\n')[0])
            #print("\n")
            #print("lines["+str(cnt)+"]", lines[cnt].split('\n')[0])
            self.out_data = []
            self.out_data.append(lines[cnt - 4].split('\n')[0])
            self.out_data.append(lines[cnt - 3].split('\n')[0])
            self.out_data.append(lines[cnt - 2].split('\n')[0])
            self.out_data.append(lines[cnt - 1].split('\n')[0])
            j = 0
            while lines[cnt + j].split('\n')[0] != end_key:
                self.out_data.append(lines[cnt + j].split('\n')[0])
                j += 1
            self.out_data.append(end_key)
            self.m.printMesgAddStr("     out_data[4]           --->: ", self.c.getRed(), self.out_data[4])

            begin_ions = self.out_data[0]
            pepmass = self.out_data[1].split("PEPMASS=")[1]
            charge  = self.out_data[2].split("CHARGE=" )[1]
            mslevel = self.out_data[3].split("MSLEVEL=")[1]
            retention_time = (self.out_data[4].split(", RT: ")[1]).split(' min')[0]
            scan_number = ((self.out_data[4].split("RT: ")[0]).split('Scan#: ')[1]).split(',')[0]
            end_ions = self.out_data[len(self.out_data)-1]
            self.c.setBegin_Ions(begin_ions)
            self.c.setEnd_Ions(end_ions)
            self.c.setPepMass(pepmass)
            self.c.setCharge(charge)
            self.c.setMSLevel(mslevel)
            self.m.printMesgAddStr("Begin_ions          (check)--->: ", self.c.getYellow(), self.c.getBegin_Ions())
            self.m.printMesgAddStr("PepMass                    --->: ", self.c.getMagenta(), self.c.getPepMass())
            self.m.printMesgAddStr("Charge                     --->: ", self.c.getRed(), self.c.getCharge())
            self.m.printMesgAddStr("MSLevel                    --->: ", self.c.getCyan(), self.c.getMSLevel())

            if scan_number == scan:
                msg = self.c.getYellow()+str(scan_number)+" = "+str(scan) + \
                      self.c.getBlue() + " ---> " + self.c.getGreen()+"All good"
                self.m.printMesgAddStr("Scan number are the same   --->: ", self.c.getGreen(), msg)
            else:
                msg = self.c.getRed()+str(scan_number)+" != "+str(scan) + \
                      self.c.getRed()+" that is not good"
                rc = self.c.get_RC_WARNING()
                self.m.printMesgAddStr("Scan number are not the same-->: ", self.c.getGreen(), msg)

            self.c.setScan_number(scan_number)
            #Inserting the extracted retention time into the object
            self.c.setRet_time(retention_time)
            self.m.printMesgAddStr("Retention time extracted   --->: ", self.c.getCyan(), self.c.getRet_time() + \
                                   self.c.getMagenta() + " minutes")

            self.m.printMesgAddStr("End_ions            (check)--->: ", self.c.getYellow(), self.c.getEnd_Ions())

            #print("out_data ---> ", out_data)
            cnt_init = cnt - 4
            cnt_fin = cnt + j + 1

            msg = self.c.getBlue() + "Recorded block from file  ---->: " + \
                self.c.getYellow()  + file_path + \
                self.c.getBlue() + " ---> from line ["+str(cnt-4)+":"+str(cnt + j+1)+"] ---> "
            self.m.printMesgAddStr(msg, self.c.getMagenta(), str(cnt_fin - cnt_init) +" lines" )

        except IOError:
            rc = self.c.get_RC_WARNING()
            print("[mgf_len]: Could not open file:", file_path, mgf_len)
            csv_len = 0
            print("Return code: ", self.c.get_RC_FAIL())
            exit(self.c.get_RC_FAIL())

        #print("Read from file: ",csvfile, " ---> length csv_len: ", csv_len)
        msg = self.c.getBlue() + "Read from file            ---->: " + \
              self.c.getYellow()  + file_path + \
              self.c.getBlue() + " ---> length mgf_len: "
        self.m.printMesgAddStr(msg, self.c.getMagenta(), str(mgf_len))

        return rc, mgf_len, self.out_data

    # Method to extract the sequence from the data
    def extract_sequence_from_spec(self, spectrum):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        self.m.printMesgStr("Extracting sequence (spectrum): ", self.c.getGreen(), __func__)

        # check if the spectrum is the same as the object spectrum
        if spectrum[:] == self.out_data[:]:
            self.m.printMesgAddStr("Spectrum are the same      --->: ",
                                   self.c.getGreen(), "we will use the object spectrum for now")
        else:
            self.m.printMesgAddStr("Spectrum are not the same  --->: ",
                                   self.c.getRed(), "Continuing with the passed spectrum ...")

        # populating the lists for the spectrum
        self.m.printMesgAddStr("Total length of the list   --->: ", self.c.getYellow(), len(spectrum[:]))
        for i in range(5,len(spectrum[:])-1):
            #msg = str(spectrum[i].split(' ')[0]) +" <---> "+ str(spectrum[i].split(' ')[1])
            #self.m.printMesgAddStr("spectrum["+str(i)+"]:--->: ", self.c.getYellow(), msg)
            self.m_on_Z.append(float(spectrum[i].split(' ')[0]))
            self.intensity.append(float(spectrum[i].split(' ')[1]))
        # Getting the maximum intensity
        self.sample_max = max(self.intensity[:])
        self.sample_min = min(self.intensity[:])
        self.sample_mean = numpy.mean(self.intensity[:])
        self.m.printMesgAddStr("Intensity             (min)--->: ", self.c.getMagenta(), self.sample_min)
        self.m.printMesgAddStr("Intensity            (mean)--->: ", self.c.getCyan(), self.sample_mean)
        self.m.printMesgAddStr("Intensity             (max)--->: ", self.c.getRed(), self.sample_max)
        # Now that wwe have the max let's get the output list
        for j in range(len(self.intensity[:])):
            relative = float((float(self.intensity[j] / float(self.sample_max)))*100.0)
            self.relative.append(relative)
            self.mz_intensity_relative_lst.append([self.m_on_Z[j], self.intensity[j], relative])
        # sorting the list
        self.mz_intensity_relative_sorted_lst = sorted(self.mz_intensity_relative_lst[:], key=operator.itemgetter(2), reverse=True)
        # printing the list
        for i in range(len(self.mz_intensity_relative_sorted_lst)):
            mxg = "mz_intensity_relative_sorted_lst["+'{0:>4d}'.format(i)+"]:--->: "
            msg = "{0:>14.8f}".format(self.mz_intensity_relative_sorted_lst[i][0]) + self.c.getBlue() + " <---> " + \
                  self.c.getRed() + "{0:>18.8f}".format(self.mz_intensity_relative_sorted_lst[i][1]) + self.c.getBlue() + " <---> " + \
                  self.c.getGreen() + "{0:>12.8f}".format(self.mz_intensity_relative_sorted_lst[i][2]) + self.c.get_C_Reset()
            self.m.printMesgAddStr(mxg, self.c.getYellow(), msg)

        return rc, self.mz_intensity_relative_lst, self.mz_intensity_relative_sorted_lst
    #---------------------------------------------------------------------------
    # [Getters]
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Printers]
    #---------------------------------------------------------------------------
    def printFileNames(self):
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgAddStr("[file_raw]:     (raw file) --->: ", self.c.getYellow(), self.c.getRAW_file())
        self.m.printMesgAddStr("[file_asc]:     (asc file) --->: ", self.c.getRed(), self.c.getPlot_asc())
        self.m.printMesgAddStr("[file_csv]:     (csv file) --->: ", self.c.getCyan(), self.c.getCSV_file())
        self.m.printMesgAddStr("[file_mgf]:     (mgf file) --->: ", self.c.getBlue(), self.c.getMGF_file())
        return rc
#---------------------------------------------------------------------------
# end of MgfTransformer
#---------------------------------------------------------------------------
