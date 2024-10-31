#!/usr/bin/env python3
"""!\file
   -- DataManage addon: (Python3 code) class for transforming the mgf files
                                      to database files
      \author Frederic Bonnet
      \date 19th of April 2024

      Universite de Perpignan March 2024, OBS.

Name:
---
Command_line: class DataBaseHandler for handling files to database files

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
"""
# System imports
import sys
import datetime
import os
import operator
import numpy
import json
import tqdm
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
class DataBaseHandler:
    #---------------------------------------------------------------------------
    # [Constructor] for the
    #---------------------------------------------------------------------------
    # Constructor
    def __init__(self, c, m, db_action="import_db"):
        __func__= sys._getframe().f_code.co_name
        self.rc = 0
        self.c = c
        self.m = m
        self.app_root = self.c.getApp_root()
        self.m.printMesgStr("Instantiating the class       :", self.c.getGreen(), "DataBaseHandler")

        #gettign the csv file
        self.ext_asc = ".asc"
        self.ext_csv = ".csv"
        self.ext_mgf = ".mgf"
        self.ext_json = ".json"
        self.undr_scr = "_"
        self.dot = "."
        self.csv_len = 0
        self.csv_col = 0
        self.zerolead = 0
        self.rows = []
        # data base directory structure
        self.database_json_targetdir = "Json_DataBase"
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
        self.mz_intensity_relative_lst = []
        self.mz_intensity_relative_sorted_lst = []

        self.molecules_lst = []
        self.ith_molecules_lst = []
        self.molecules_dict = {}
        self.ith_molecules_dict = {}

        self.database_hreader_lst = []
        self.database_hreader_dict = {}

        self.molecule_number_lst = []

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

        self.import_db = self.c.getImport_db()
        self.export_db = self.c.getExport_db()

        self.file_asc = self.c.getPlot_asc()

        if db_action == "import_db": self.database_full_path = self.c.getImport_db()
        if db_action == "export_db": self.database_full_path = self.c.getExport_db()
        if db_action == "import_external_db": self.database_full_path = self.c.getImport_External_db()
        if db_action == "export_external_db": self.database_full_path = self.c.getExport_External_db()

        if db_action == "train_dataset_from_db": self.database_full_path = self.c.getData_path()

        # Constructing the file organisation
        self.database_path = os.path.dirname(self.database_full_path)
        self.c.setDatabase_path(self.database_path)

        self.database_full_path_no_ext = os.path.splitext(self.database_full_path)[0]
        self.c.setDatabase_full_path_no_ext(self.database_full_path_no_ext)
        self.database_file = os.path.basename(self.database_full_path)
        self.c.setDatabase_file(self.database_file)
        self.basename = self.database_file.split('.')[0]
        self.c.setFile_basename(self.basename)
        self.c.setDatabase_name(str(self.basename).replace(' ', '_'))
        ext = ""
        if len(os.path.splitext(self.database_full_path)) > 1: ext = os.path.splitext(self.database_full_path)[1]

        # print("basename: ", basename)
        if self.c.getDebug() == 1:
            self.m.printMesgAddStr("Database directory name    --->: ", self.c.getMagenta(), self.database_path)
            self.m.printMesgAddStr("database_full_path_no_ext  --->: ", self.c.getMagenta(), self.database_full_path_no_ext)
            self.m.printMesgAddStr("Database file              --->: ", self.c.getMagenta(), self.database_file)
            self.m.printMesgAddStr("Database name              --->: ", self.c.getMagenta(), self.c.getDatabase_name())
            self.m.printMesgAddStr("File basename              --->: ", self.c.getMagenta(), self.basename)
            self.m.printMesgAddStr("ext                        --->: ", self.c.getMagenta(), ext)
        # [end-if] self.c.getDebug() == 1:

        self.file_csv = self.basename+self.ext_csv
        self.c.setCSV_file(self.file_csv)
        self.file_asc = self.basename+self.ext_asc
        self.c.setPlot_asc(self.file_asc)

        if self.c.getDebug() == 1:
            self.m.printMesgAddStr("the csv file is then       --->: ", self.c.getMagenta(), self.file_csv)
            # printing the files:
            self.printFileNames()
        # [end-if] debug satement
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
    def create_molecule_dictionary(self):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        self.m.printMesgStr("Extracting database content (database_file): ", self.c.getGreen(), __func__)
        # --------------------------------------------------------------
        # [start] insert the loop of the molecule i loop
        # start of loop over the molecule dictionary
        # print("self.molecules_lst[:] ---> ", self.molecules_lst[:])
        # print("len(self.molecules_lst[:]) ---> ", len(self.molecules_lst[:]))
        rc, zerolead = self.extract_ZeroLead(len(self.molecules_lst[:]))
        if zerolead <= numpy.power(10, 4):
            rc, zerolead = self.extract_ZeroLead(numpy.power(10, 4))
        # TODO: insert tqdm for the loop structure
        for i in tqdm.tqdm(range(len(self.molecules_lst[:])), ncols=100, desc='create_molecule_dictionary:'):
            ith_dict_key = 'molecule '+str(i)
            self.ith_molecules_dict = {}
            self.ith_molecules_dict[self.molecules_lst[i][0]] = self.molecules_lst[i][0]
            if self.c.getDebug() == 1:
                self.m.printMesgAddStr("[molecules_lst]: mol("+str(0).zfill(len(str(zerolead))) + \
                                       "), length("+str(len(self.molecules_lst[0][:]))+") --->: ",
                                       self.c.getYellow(), self.molecules_lst[0][0])
            cnt = 0

            #print("self.molecules_lst[i][:] --->: ", self.molecules_lst[i][:])

            for j in range(1, len(self.molecules_lst[i][:]) - 1):
                if self.c.getDebug() == 1:
                    self.m.printMesgAddStr("[molecules_lst]: mol("+str(j).zfill(len(str(zerolead)))+\
                                           "), length("+str(len(self.molecules_lst[0][:]))+") --->: ",
                                           self.c.getYellow(), self.molecules_lst[0][j])
                if 'SMILES=' in self.molecules_lst[i][j]:
                    key = str(self.molecules_lst[i][j]).split('=')[0]
                    value = str(self.molecules_lst[i][j]).split('SMILES=')[1]
                    self.ith_molecules_dict[key] = value.replace('\\','\\\\')
                elif 'INCHI=' in self.molecules_lst[i][j]:
                    key = str(self.molecules_lst[i][j]).split('=')[0]
                    value = str(self.molecules_lst[i][j]).split('INCHI=')[1]
                    self.ith_molecules_dict[key] = value
                elif '=' in self.molecules_lst[i][j]:
                    key = str(self.molecules_lst[i][j]).split('=')[0]
                    value = str(self.molecules_lst[i][j]).split('=')[1]
                    self.ith_molecules_dict[key] = value
                elif ' ' in self.molecules_lst[i][j]:
                    key = 'mz rel: '+str(cnt).zfill(5)
                    value = str(self.molecules_lst[i][j]).strip() #.replace(' ', ', ')+"]").replace('\"','')
                    self.ith_molecules_dict[key] = value
                    cnt += 1
                # if self.molecules_lst[0][j].isnumeric() == False: self.ith_molecules_dict[self.molecules_lst[0][j]] = self.molecules_lst[0][j]
            # [end-loop]
            #self.m.printMesgAddStr("[molecules_lst]: mol("+str(len(self.molecules_lst[0][:]) - 1).zfill(len(str(zerolead)))+"), length("+str(len(self.molecules_lst[0][:]))+") --->: ",
            #                       self.c.getYellow(), self.molecules_lst[0][len(self.molecules_lst[0][:]) - 1])
            self.ith_molecules_dict[self.molecules_lst[i][len(self.molecules_lst[i][:]) - 1]] = str(self.molecules_lst[i][len(self.molecules_lst[i][:]) - 1]).strip()
            # print('printing the ith molecule from the loop ... ')
            #self.m.printMesgAddStr("ith_molecules_dict["+str(i)+"]      --->: ", self.c.getGreen(), self.ith_molecules_dict)
            # creating the molecule dictionary
            self.molecules_dict[ith_dict_key] = self.ith_molecules_dict
        # [end-loop] for the molecule loop
        # [end] insert the loop of the molecule i loop
        # --------------------------------------------------------------
        #print("self.molecules_dict ---->: ", self.molecules_dict)
        #exit(0)
        mol_num = str(0).zfill(len(str(zerolead)))
        #print('testing I can access the correct molecule in the dictionary ... ')
        #self.m.printMesgAddStr("molecule"+mol_num+"           dict --->: ", self.c.getYellow(), self.molecules_dict['molecule 0'])
        self.m.printMesgAddStr("mol("+mol_num+")   PEPMASS dict --->: ", self.c.getYellow(), self.molecules_dict['molecule 0']['PEPMASS'])
        self.m.printMesgAddStr("[dictionary]:     (length) --->: ", self.c.getYellow(), len(self.molecules_dict))
        cnt = 0
        for key, value in self.molecules_dict.items():
            self.molecule_number_lst.append(key)
            #self.m.printMesgAddStr("[keys]: molecules_dict["+str(cnt)+"]  --->: ", self.c.getCyan(), key)
            cnt += 1
        # [end-loop] key, value molecule dictionary
        return rc, self.molecule_number_lst[:]

    def create_molecule_jsonfiles_from_molecules_dict(self):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        database_file_len = 0
        self.m.printMesgStr("Creating molecule jsonfiles from molecules_dict (database_file): ", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------
        # File handling and zerolead determination
        # ----------------------------------------------------------------------
        # Get the zerolead for file conmstriction
        rc, zerolead = self.extract_ZeroLead(len(self.molecules_lst[:]))
        if zerolead <= numpy.power(10, 4):
            rc, zerolead = self.extract_ZeroLead(numpy.power(10, 4))
        #print(" Database_path            ---> ", self.c.getDatabase_path())
        #print(" the name of the database ---> ", self.c.getDatabase_file())
        #print(" database file basename   ---> ", self.c.getFile_basename())
        mol_num = str(len(self.molecules_lst[:])).zfill(len(str(zerolead)))
        self.m.printMesgAddStr("[indexing]:(mol_num)       --->: ", self.c.getBlue(), mol_num)
        #print(" Number of molecules      ---> ", mol_num)
        #print(" database_json_targetdir  ---> ", self.database_json_targetdir)
        self.dir_json = os.path.join(self.c.getDatabase_path(), self.database_json_targetdir)
        self.c.setTargetdir(self.dir_json)
        self.m.printMesgAddStr("Target directory           --->: ", self.c.getCyan(), self.dir_json)

        if os.path.exists(self.dir_json):
            msg = self.c.get_B_Green()+" Already exists, nothing to do, continuing... "
            self.m.printMesgAddStr("Directory                  --->: ", self.c.getCyan(), self.dir_json + msg)
        else:
            self.m.printMesgAddStr("Creating                   --->: ", self.c.getCyan(), self.dir_json)
            os.mkdir(self.dir_json)
        # ----------------------------------------------------------------------
        # Header list to hedera dictionary then to Jason file
        # ----------------------------------------------------------------------
        # TODO: [start] may need to move this method to create_molecule or header dictionary or rather
        for i in range(len(self.database_hreader_lst[:])):
            #print("str(self.database_hreader_lst[i]) --->: ", str(self.database_hreader_lst[i]))
            if self.c.get_system() == 'Windows':
                msg = str(self.database_hreader_lst[i]).split('â€')
            elif self.c.get_system() == 'Linux':
                msg = str(self.database_hreader_lst[i]).split('–')
            #print("self.database_hreader_lst["+str(i)+"]: --->: ", msg)
            key = msg[0]
            value = msg[1]
            self.database_hreader_dict[key] = value
        # [end-loop]

        filename_json = self.c.getTargetdir() + os.sep + \
                        str(self.c.getFile_basename()).replace(' ', self.undr_scr) + \
                        self.undr_scr +"header" + \
                        self.undr_scr+"n_molecule" + mol_num + self.ext_json

        self.m.printMesgAddStr("Json file for header dict  --->: ", self.c.getMagenta(), filename_json)

        try:
            with open(filename_json, "w") as outfile:
                outfile.write("[\n")
                json.dump(self.database_hreader_dict, outfile, indent=8)
                outfile.write("]\n")
                outfile.close()
        except IOError:
            rc = self.c.get_RC_FAIL()
            print("[mgf_len]: Could not open file:", filename_json, database_file_len)
            print("Return code: ", rc)
            exit(rc)

        # TODO: [end] may need to move this method to create_molecule or header dictionary or rather
        #
        # ----------------------------------------------------------------------
        # Body of the database file
        # ----------------------------------------------------------------------
        #print('printing the molecule dictionary ... ')
        #self.m.printMesgAddStr("self.molecules_dict         --->: ", self.c.getMagenta(), self.molecules_dict)
        if self.c.getDebug() == 1:
            self.m.printMesgAddStr("[molecule_num_lst]:(keys)  --->: ", self.c.getCyan(), self.molecule_number_lst[:])

        # Instantiating the json creator class
        jsonCreator = src.PythonCodes.utils.JSonCreator.JSonCreator(self.c, self.m)
        self.m.printMesgAddStr("Creating_ith_molecule_json --->: ", self.c.getMagenta(), "over self.molecule_number_lst[:]")
        for i in tqdm.tqdm(range(len(self.molecule_number_lst[:])), ncols=100, desc='molecl_jsonfiles_from_dict:'):
            mol_num = str(i).zfill(len(str(zerolead)))
            # correcting for the case when the PEPMASS=*** ---> the last entry in the file
            # then we set it to 000.0000
            #print(" ----->: FEATURE_ID: "+ str(self.molecules_dict[self.molecule_number_lst[i]]['FEATURE_ID']))
            #print(str("PEPMASS: "+self.molecules_dict[self.molecule_number_lst[i]]['PEPMASS'])+" ----->: FEATURE_ID: "+ \
            #      str(self.molecules_dict[self.molecule_number_lst[i]]['FEATURE_ID']))
            if str(self.molecules_dict[self.molecule_number_lst[i]]['PEPMASS']) == "***":
                self.molecules_dict[self.molecule_number_lst[i]]['PEPMASS'] = "999.9999"
            if str(self.molecules_dict[self.molecule_number_lst[i]]['PEPMASS']) == "":
                self.molecules_dict[self.molecule_number_lst[i]]['PEPMASS'] = "999.9999"

            # self.undr_scr +"PEPMASS-" + str(self.molecules_dict[self.molecule_number_lst[i]]['PEPMASS']) + \
            filename_json = self.c.getTargetdir() + os.path.sep + \
                            str(self.c.getFile_basename()).replace(' ', self.undr_scr) + \
                            self.undr_scr+"molecule" + mol_num + \
                            self.undr_scr +"PEPMASS-" + str('{:05.4f}'.format(float(self.molecules_dict[self.molecule_number_lst[i]]['PEPMASS']))) + \
                            self.ext_json

            if self.c.getDebug() == 1:
                self.m.printMesgAddStr("Json file for mol("+mol_num+")  --->: ", self.c.getMagenta(), filename_json)

            try:
                # , encoding='utf-8'
                with open(filename_json, "w") as outfile:
                    rc = jsonCreator.create_ith_molecule_JSon_file(self.molecules_dict[self.molecule_number_lst[i]],
                                                                   mol_num, filename_json,
                                                                   outfile=outfile)
                outfile.close()
            except IOError:
                self.m.printMesgAddStr("Json file for mol("+mol_num+")  --->: ", self.c.getMagenta(), filename_json)
                rc = self.c.get_RC_WARNING()
                print("[mgf_len]: Could not open file:", filename_json, database_file_len)
                print("Return code: ", self.c.get_RC_FAIL())
        # [end-loop]        #exit(self.c.get_RC_FAIL())
        '''
        progressBar = src.PythonCodes.utils.progressBar.ProgressBar()
        for i in range(len(self.molecule_number_lst[:])):
            progressBar.update(1, len(self.molecule_number_lst[:]))
            progressBar.printEv()
        # [end-loop]
        '''
        self.m.printLine()
        self.m.printMesgAddStr("Database name              --->: ", self.c.getYellow(), self.c.getDatabase_name())

        if rc == self.c.get_RC_SUCCESS():
            self.m.printMesgAddStr("Has been imported to Json  --->: ", self.c.getGreen(), "Successfully")
        else:
            self.m.printMesgAddStr("Has been imported to Json  --->: ", self.c.getRed(), "There are some issues")
        # [if-staement]
        return rc
    #---------------------------------------------------------------------------
    # [Writters]
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Reader]
    #---------------------------------------------------------------------------
    def read_header_database_file(self, file_path, lines, database_file_len):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        # ----------------------------------------------------------------------
        # Preamble of the readers
        # ----------------------------------------------------------------------
        start_key = "LEVEL"
        end_key = "BEGIN IONS"
        try:
            n_header_lines = 0
            for i in range(database_file_len):
                if start_key in lines[i].split('\n')[0]:
                    n_header_lines += 1
                    self.database_hreader_lst.append(lines[i].split('\n')[0].strip())
                if end_key in  lines[i].split('\n')[0]: break
                #print("lines["+str(i)+"]", lines[i].split('\n')[0])
            # [end-loop]
            #print("self.database_hreader_lst[:] ---> ", self.database_hreader_lst[:])
            self.m.printMesgAddStr("[file_DB ]:(n_header_lines)--->: ", self.c.getYellow(), n_header_lines)
        except IOError:
            rc = self.c.get_RC_WARNING()
            print("[file_DB]: header is empty    :", file_path, database_file_len)
            print("Return code: ", self.c.get_RC_WARNING())

        return rc

    def read_external_Json_MoNA_database_files(self, database_file):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        database_file_len = 0
        self.m.printMesgStr("Extracting JSon database    (database_file): ", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------
        # Preamble of the readers
        # ----------------------------------------------------------------------
        file_path, rc = self.get_and_check_filename_path(database_file)
        # ----------------------------------------------------------------------
        # Starting the timers for the constructor
        # ----------------------------------------------------------------------
        # Trigger keys
        # Used keys either for the mapping or filtering
        BEGIN_IONS_key = "BEGIN IONS"
        END_IONS_key = "END IONS"
        PEAKS_LIST_key = "PEAKS_LIST"
        PRECURSORMZ_key = "PRECURSORMZ"
        PEPMASS_key = "PEPMASS"
        SOURCE_INSTRUMENT_key = "SOURCE_INSTRUMENT"
        PRECURSORTYPE_key = "PRECURSORTYPE"
        IONMODE_key = "IONMODE"
        FORMULA_key = "FORMULA"
        FEATURE_ID_key = "FEATURE_ID"
        MSLEVEL_key = "MSLEVEL"
        CHARGE_KEY = "CHARGE"
        SMILES_key = "SMILES"
        PUBCHEM_key = "PUBCHEM"

        PI_key ="PI"
        DATACOLLECTOR_key = "DATACOLLECTOR"

        INSTRUMENTTYPE_key = "INSTRUMENTTYPE"
        INSTRUMENT_key = "INSTRUMENT"
        # TODO:
        #       PRECURSORMZ ----> PEPMASS                             :---->
        #       INSTRUMENTTYPE + INSTRUMENT ----> SOURCE_INSTRUMENT   :---->
        #       PRECURSORTYPE ----> IONMODE                           :---->
        #       NAME + , + SYNNO ---->  NAME                          :---->
        #       https://pubchem.ncbi.nlm.nih.gov/compound/5280862 + (pubchem)  :---->
        try:
            #print("file_path -=-- > ", file_path)
            file = open(file_path, encoding='utf-8')
            #lines = file.readlines()
            #database_file_len = len(lines)
            jsondata = json.load(file)
            json_length = len(jsondata)
            # ----------------------------------------------------------------------
            # Extracting the molecules
            # ----------------------------------------------------------------------
            n_molecules = json_length
            self.m.printLine()
            self.m.printMesgAddStr("[file_DB ]:  (n molecules) --->: ", self.c.getYellow(), n_molecules)
            self.m.printMesgAddStr("[jsondata]:  (n molecules) --->: ", self.c.getYellow(), json_length)
            appending = False
            cnt = 0
            ith_molecule = 0
            insert_msg = ""
            self.m.printMesgAddStr("[creating] molecules_lst   --->: ", self.c.getCyan(), file_path)
            progressBar = src.PythonCodes.utils.progressBar.ProgressBar()
            for idata in jsondata:
                ith_molecule += 1
                cnt += 1
                #print("idata ["+str(cnt)+"]: ")
                self.ith_molecules_lst.clear()

                self.ith_molecules_lst.append(BEGIN_IONS_key)
                ith_data_key = []
                ith_data_value = []
                #for key, value in tqdm.tqdm(idata.items(), ncols=90, desc='Loading molecule:'):

                #TODO: insert the code for the MoNA database stuff
                feature_id = FEATURE_ID_key+"="+str(idata['id'])
                self.ith_molecules_lst.append(feature_id)
                #print("idata['id'] --->: "+str(idata['id'])+" ----> value ----> "+str(feature_id))
                charge = CHARGE_KEY+"="+str(0)
                self.ith_molecules_lst.append(charge)
                #print("charge        --->: "+str(CHARGE_KEY)+" ----> value ----> "+str(0))

                metaData = idata['metaData']
                compound = idata['compound']
                if 'library' in idata.items(): library = idata['library']
                submitter = idata['submitter']

                #print(" idata['metaData'] --->: ", idata['metaData'])
                #print("len(metadata[:]) --->: ", len(metaData[:]))
                #print("type(metadata[:]) --->: ", type(metaData[:]))
                #print(" idata['submitter'] --->: ", idata['submitter'])
                #print("submitter --->: ", submitter)
                #print("\n")

                for i in range(len(metaData[:])):
                    #total exact mass

                    if metaData[i]['name'] == 'exact mass':
                        pepmass = str(metaData[i]['value'])
                        print("metaData["+str(i)+"]['name'] --->: "+str(metaData[i]['name'])+" ----> value ----> "+str(pepmass))
                        insert_msg = PEPMASS_key+"="+pepmass
                        self.ith_molecules_lst.append(insert_msg)

                    if metaData[i]['name'] == 'ms level':
                        if 'MS' in str(metaData[i]['value']):
                            ms_level = str(metaData[i]['value']).split('MS')[1]
                        else:
                            ms_level = str(metaData[i]['value'])
                        #print("metaData["+str(i)+"]['name'] --->: "+str(metaData[i]['name'])+" ----> value ----> "+str(ms_level))
                        insert_msg = MSLEVEL_key+"="+ms_level
                        self.ith_molecules_lst.append(insert_msg)
                    if metaData[i]['name'] == 'precursor type':
                        ionmode = str(metaData[i]['value'])
                        #print("metaData["+str(i)+"]['name'] --->: "+str(metaData[i]['name'])+" ----> value ----> "+str(ionmode))
                        insert_msg = IONMODE_key+"="+ionmode
                        self.ith_molecules_lst.append(insert_msg)
                    if metaData[i]['name'] == 'instrument':
                        instrument = str(metaData[i]['value'])
                        #print("metaData["+str(i)+"]['name'] --->: "+str(metaData[i]['name'])+" ----> value ----> "+str(instrument))
                    if metaData[i]['name'] == 'instrument type':
                        instrument_type = str(metaData[i]['value'])
                        #print("metaData["+str(i)+"]['name'] --->: "+str(metaData[i]['name'])+" ----> value ----> "+str(instrument_type))
                        insert_msg = SOURCE_INSTRUMENT_key+"="+instrument_type+", "+ instrument
                        self.ith_molecules_lst.append(insert_msg)
                    if metaData[i]['name'] == 'author':
                        pi = str(metaData[i]['value'])
                        #print("metaData["+str(i)+"]['name'] --->: "+str(metaData[i]['name'])+" ----> value ----> "+str(pi))
                        pi_insert_msg = PI_key+"="+pi
                        self.ith_molecules_lst.append(pi_insert_msg)
                # [end-for-loop] for metadata

                firstName = ""
                lastName = ""
                for key, value in submitter.items():
                    if "firstName" in submitter.keys():
                        firstName = submitter['firstName']
                    if 'lastName' in submitter.keys():
                        lastName = submitter['lastName']
                insert_datacolector_meassage = DATACOLLECTOR_key+"="+str(firstName)+" "+str(lastName)
                self.ith_molecules_lst.append(insert_datacolector_meassage)

                for i in range(len(compound[:])):
                    if compound[i]['metaData']:
                        coumpound_metaData = compound[i]['metaData']
                        for j in range(len(coumpound_metaData[:])):

                            if coumpound_metaData[j]['name'] == 'total exact mass':
                                pepmass = str(coumpound_metaData[j]['value'])
                                print("metaData["+str(j)+"]['name'] --->: "+str(coumpound_metaData[j]['name'])+" ----> value ----> "+str(pepmass))
                                insert_msg = PEPMASS_key+"="+pepmass
                                self.ith_molecules_lst.append(insert_msg)

                            if coumpound_metaData[j]['name'] == 'molecular formula' and coumpound_metaData[j]['computed'] == False:
                                formula = str(coumpound_metaData[j]['value'])
                                #print("coumpound_metaData["+str(j)+"]['name'] --->: "+str(coumpound_metaData[j]['name'])+" ----> value ----> "+str(formula))
                                insert_msg = FORMULA_key+"="+formula
                                self.ith_molecules_lst.append(insert_msg)
                            if coumpound_metaData[j]['name'] == 'SMILES' and coumpound_metaData[j]['computed'] == False:
                                smiles = str(coumpound_metaData[j]['value'])
                                insert_smiles = SMILES_key+"="+smiles
                                self.ith_molecules_lst.append(insert_smiles)
                                #print("coumpound_metaData["+str(j)+"]['name'] --->: "+str(coumpound_metaData[j]['name'])+" ----> value ----> "+str(insert_smiles))
                # [end-for-loop] for compound

                if 'library' in idata.items():
                    link = library['link']
                    insert_pubchem_msg = PUBCHEM_key+"="+str(link)
                else:
                    insert_pubchem_msg = PUBCHEM_key+"=***"
                self.ith_molecules_lst.append(insert_pubchem_msg)
                #print("library['link']        --->: "+str(library['link'])+" ----> value ----> "+str(link)+" ----> value ----> "+str(insert_pubchem_msg))

                self.ith_molecules_lst.append(END_IONS_key)

                self.molecules_lst.append(self.ith_molecules_lst[:])
                #if cnt == 10: break

                progressBar.update(1, n_molecules)
                progressBar.printEv()
            # [end-loop] for idata
            self.m.printLine()
            if self.c.getDebug() == 1:
                self.m.printMesgAddStr("[molecules_lst]: last(ith) --->: ", self.c.getYellow(), self.ith_molecules_lst[:])
                self.m.printMesgAddStr("[molecules_lst]:       (0) --->: ", self.c.getYellow(), self.molecules_lst[0])
                self.m.printMesgAddStr("[molecules_lst]:      ("+str(len(self.molecules_lst)-1)+") --->: ",
                                       self.c.getYellow(), self.molecules_lst[len(self.molecules_lst)-1])
                self.m.printMesgAddStr("[molecules_lst]:     (len) --->: ", self.c.getYellow(), len(self.molecules_lst[:]))
            # The full list of molecules
            self.m.printMesgAddStr("[molecules_lst]:     (len) --->: ", self.c.getYellow(), len(self.molecules_lst[:]))
        except IOError:
            rc = self.c.get_RC_WARNING()
            print("[mgf_len]: Could not open file:", file_path, database_file_len)
            csv_len = 0
            print("Return code: ", self.c.get_RC_FAIL())
            exit(self.c.get_RC_FAIL())

        return rc

    def read_external_Json_LCMS_database_files(self, database_file, database_origin):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        database_file_len = 0
        self.m.printMesgStr("Extracting JSon database    (database_file): ", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------
        # Preamble of the readers
        # ----------------------------------------------------------------------
        file_path, rc = self.get_and_check_filename_path(database_file)
        # ----------------------------------------------------------------------
        # Starting the timers for the constructor
        # ----------------------------------------------------------------------
        # Trigger keys
        # Used keys either for the mapping or filtering
        BEGIN_IONS_key = "BEGIN IONS"
        END_IONS_key = "END IONS"
        PEAKS_LIST_key = "PEAKS_LIST"
        PRECURSORMZ_key = "PRECURSORMZ"
        PEPMASS_key = "PEPMASS"
        SOURCE_INSTRUMENT_key = "SOURCE_INSTRUMENT"
        PRECURSORTYPE_key = "PRECURSORTYPE"
        IONMODE_key = "IONMODE"
        INSTRUMENTTYPE_key = "INSTRUMENTTYPE"
        INSTRUMENT_key = "INSTRUMENT"
        FEATURE_ID_key = "FEATURE_ID"
        SPECTRUMID_key = "SPECTRUMID"
        CHARGE_KEY = "CHARGE"
        PUBCHEM_key = "PUBCHEM"
        TAXONOMY_key = "TAXONOMY"
        # TODO:
        #       PRECURSORMZ ----> PEPMASS                             :----> Done
        #       INSTRUMENTTYPE + INSTRUMENT ----> SOURCE_INSTRUMENT   :----> Done
        #       PRECURSORTYPE ----> IONMODE                           :----> Done There is already a IONMODE in record
        #       NAME + , + SYNNO ---->  NAME                          :----> Done
        #       https://pubchem.ncbi.nlm.nih.gov/compound/5280862 + (pubchem)  :----> No pubchem
        try:
            #print("file_path -=-- > ", file_path)
            file = open(file_path)
            #lines = file.readlines()
            #database_file_len = len(lines)
            jsondata = json.load(file)
            json_length = len(jsondata)
            # ----------------------------------------------------------------------
            # Extracting the molecules
            # ----------------------------------------------------------------------
            n_molecules = json_length
            self.m.printLine()
            self.m.printMesgAddStr("[file_DB ]:  (n molecules) --->: ", self.c.getYellow(), n_molecules)
            self.m.printMesgAddStr("[jsondata]:  (n molecules) --->: ", self.c.getYellow(), json_length)
            appending = False
            cnt = 0
            ith_molecule = 0
            insert_msg = ""
            self.m.printMesgAddStr("[xtrct] molecules_lst from --->: ", self.c.getCyan(), file_path)
            progressBar = src.PythonCodes.utils.progressBar.ProgressBar()
            for idata in jsondata:
                ith_molecule += 1
                cnt += 1
                self.ith_molecules_lst.clear()

                insert_replace_name_msg = str(idata['NAME']).replace('\"','')  \
                                          + ", "+str(idata['SYNON']).replace('\"','') \
                                          + "(level ***)"
                #print(" insert_replace_name_msg ---->: ", insert_replace_name_msg)
                idata['NAME'] = str(insert_replace_name_msg)

                self.ith_molecules_lst.append(BEGIN_IONS_key)
                ith_data_key = []
                ith_data_value = []
                #for key, value in tqdm.tqdm(idata.items(), ncols=90, desc='Loading molecule:'):
                for key, value in idata.items():
                    ith_data_key.append(key)
                    ith_data_value.append(value)
                    insert_source_instrument_msg = str(SOURCE_INSTRUMENT_key)+"="+ \
                                                   str(idata[INSTRUMENTTYPE_key])+", "+ \
                                                   str(idata[INSTRUMENT_key])
                    self.ith_molecules_lst.append(insert_source_instrument_msg)
                    if PRECURSORMZ_key in key:
                        insert_msg = str(PEPMASS_key)+"="+str(value)
                        self.ith_molecules_lst.append(insert_msg)
                    if SPECTRUMID_key in key:
                        #insert_msg = insert_msg.replace(SPECTRUMID_key, FEATURE_ID_key)
                        insert_feature_id_msg = str(FEATURE_ID_key)+"="+str(value)
                        self.ith_molecules_lst.append(insert_feature_id_msg)

                    # Getting the charge
                    if CHARGE_KEY in key:
                        insert_charge_msg = str(CHARGE_KEY)+"="+str(idata[CHARGE_KEY])
                    elif CHARGE_KEY not in key:
                        insert_charge_msg = str(CHARGE_KEY)+"="+str(self.getCharge_from_precursortype(idata[PRECURSORTYPE_key]))
                        self.ith_molecules_lst.append(insert_charge_msg)

                    if PUBCHEM_key in key:
                        insert_pubchem_msg = str(PUBCHEM_key)+"="+self.c.getPubchem_url()+"/"+str(idata[PUBCHEM_key])
                        self.ith_molecules_lst.append(insert_pubchem_msg)
                    elif PUBCHEM_key not in key:
                        insert_pubchem_msg = str(PUBCHEM_key)+"="+str("N/A")
                        self.ith_molecules_lst.append(insert_pubchem_msg)

                    if TAXONOMY_key in key:
                        insert_taxonomy_msg = str(TAXONOMY_key)+"="+str(idata[TAXONOMY_key])
                        self.ith_molecules_lst.append(insert_taxonomy_msg)
                    elif TAXONOMY_key not in key:
                        insert_taxonomy_msg = str(TAXONOMY_key)+"="+str("N/A")
                        self.ith_molecules_lst.append(insert_taxonomy_msg)

                    if PEAKS_LIST_key in key:
                        values_lst = str(value).split('\n')
                        #print(values_lst[:])
                        for i in range(len(values_lst[:])):
                            value_msg = str(values_lst[i])
                            self.ith_molecules_lst.append(value_msg)
                    elif IONMODE_key in key:
                        insert_msg = str(IONMODE_key)+"="+str(idata[PRECURSORTYPE_key])
                        self.ith_molecules_lst.append(insert_msg)
                    else:
                        insert_msg = str(key)+"="+str(value)
                        self.ith_molecules_lst.append(insert_msg)
                    # [end-if} statement
                # [end-for-loop]
                self.ith_molecules_lst.append(END_IONS_key)
                #print(insert_msg)
                self.molecules_lst.append(self.ith_molecules_lst[:])

                progressBar.update(1, n_molecules)
                progressBar.printEv()
            # [end-loop]
            self.m.printLine()
            if self.c.getDebug() == 1:
                self.m.printMesgAddStr("[molecules_lst]: last(ith) --->: ", self.c.getYellow(), self.ith_molecules_lst[:])
                self.m.printMesgAddStr("[molecules_lst]:       (0) --->: ", self.c.getYellow(), self.molecules_lst[0])
                self.m.printMesgAddStr("[molecules_lst]:      ("+str(len(self.molecules_lst)-1)+") --->: ",
                                       self.c.getYellow(), self.molecules_lst[len(self.molecules_lst)-1])
                self.m.printMesgAddStr("[molecules_lst]:     (len) --->: ", self.c.getYellow(), len(self.molecules_lst[:]))
            # The full list of molecules
            self.m.printMesgAddStr("[molecules_lst]:     (len) --->: ", self.c.getYellow(), len(self.molecules_lst[:]))
        except IOError:
            rc = self.c.get_RC_WARNING()
            print("[mgf_len]: Could not open file:", file_path, database_file_len)
            csv_len = 0
            print("Return code: ", self.c.get_RC_FAIL())
            exit(self.c.get_RC_FAIL())

        return rc

    # For now the read_external_database_file is almost the same as read_database_file
    # In this method the INCHI trigger key needed to be modified and in fact, every
    # lines have been removed from the " symbol which cuases problems in the strings
    def read_external_FragHub_database_files(self, database_file):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        database_file_len = 0
        self.m.printMesgStr("Extracting database content (database_file): ", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------
        # Preamble of the readers
        # ----------------------------------------------------------------------
        file_path, rc = self.get_and_check_filename_path(database_file)
        # ----------------------------------------------------------------------
        # Starting the timers for the constructor
        # ----------------------------------------------------------------------
        # Trigger keys
        start_key = "BEGIN IONS"
        end_key = "END IONS"
        trigger_key = "Scan#: "   # "PEPMASS"
        # Replacement keys
        INCHI_key = "INCHI"   # ----> goes to TAXONOMY
        FEATURE_ID_key = "FEATURE_ID"
        SPECTRUMID_key = "SPECTRUMID"
        TAXONOMY_key = "TAXONOMY"
        SCANS_key = "SCANS"
        SCAN_ID_key = "SCAN_ID"
        LIBRARYQUALITY_key = "LIBRARYQUALITY"
        LIBRARY_QUALITY_key = "LIBRARY_QUALITY"
        CHARGE_key = "CHARGE"
        SMILES_key = "SMILES"

        # TODO: in the FragHub PRECURSORMZ ----> PEPMASS
        #       INSTRUMENTTYPE + INSTRUMENT ----> SOURCE_INSTRUMENT
        #       PRECURSORTYPE ----> IONMODE
        #       NAME + , + SYNNO ---->  NAME
        #       (DANS le web )   https://pubchem.ncbi.nlm.nih.gov/compound/5280862  (pubchem)
        try:
            #print("file_path -=-- > ", file_path)
            file = open(file_path)
            lines = file.readlines()
            database_file_len = len(lines)
            # ----------------------------------------------------------------------
            # Extracting the header from the file
            # ----------------------------------------------------------------------
            rc = self.read_header_database_file(file_path, lines, database_file_len)
            # ----------------------------------------------------------------------
            # Extracting the molecules
            # ----------------------------------------------------------------------
            progressBar = src.PythonCodes.utils.progressBar.ProgressBar()
            n_molecules = 0
            for i in range(database_file_len):
                if start_key in lines[i].split('\n')[0]:
                    n_molecules += 1
                #print("lines["+str(i)+"]", lines[i].split('\n')[0])
                progressBar.update(1, database_file_len)
                progressBar.printEv()
            # [end-loop]
            self.m.printLine()
            self.m.printMesgAddStr("[file_DB ]:(database file) --->: ", self.c.getMagenta(), database_file_len)
            self.m.printMesgAddStr("[file_DB ]:  (n molecules) --->: ", self.c.getYellow(), n_molecules)
            appending = False
            cnt = 0
            ith_molecule = 0
            insert_msg = ""
            self.m.printMesgAddStr("[xtrct] molecules_lst from --->: ", self.c.getCyan(), file_path)
            progressBar = src.PythonCodes.utils.progressBar.ProgressBar()
            for i in range(database_file_len):
                if start_key in lines[i].split('\n')[0]:
                    ith_molecule += 1
                    appending = True
                if end_key in lines[i].split('\n')[0]:
                    appending = False
                    self.ith_molecules_lst.append(lines[i].split('\n')[0])
                    self.molecules_lst.append(self.ith_molecules_lst[:])
                    #self.m.printMesgAddStr("[molecules_lst]: mol("+str(ith_molecule)+"), line("+str(i)+") --->: ",
                    #                       self.c.getYellow(), self.ith_molecules_lst[:])
                    self.ith_molecules_lst.clear()
                elif appending:
                    # This block of code has been modified to allow external databases imports
                    insert_msg = (lines[i].split('\n')[0]).replace('\t', ' ')
                    # TODO: fix the back slashes here because the SMILEY are incorrect otherwise  :---> done
                    insert_msg = insert_msg.replace("\"", '\\')
                    insert_msg = insert_msg.replace(";", ' ')
                    insert_msg = insert_msg.replace("'", ' ')
                    insert_msg = insert_msg.replace("N\\A", 'N/A')
                    # TODO: fix the back slashes here because the SMILEY are incorrect otherwise  :---> done
                    insert_msg = insert_msg.replace("\\", '\\\\')
                    #print("insert_msg --->: ", insert_msg)
                    # Taking care of the sign in the charge
                    if SMILES_key in lines[i].split('\n')[0]:
                        # TODO: fix the back slashes here because the SMILEY are incorrect otherwise  :---> done
                        insert_msg = insert_msg.replace('\\[', '\\\\[')
                        #insert_msg = insert_msg.replace('\\', '')
                    if CHARGE_key in lines[i].split('\n')[0]:
                        if lines[i].split('\n')[0].startswith("CHARGE=-"):
                            splited_charge = lines[i].split('\n')[0].split('-')
                            insert_msg = splited_charge[0]+splited_charge[1]+'-'
                        else:
                            insert_msg = lines[i].split('\n')[0]+'+'
                        # [end-if] statement
                    if LIBRARYQUALITY_key in lines[i].split('\n')[0]:
                        insert_msg = insert_msg.replace(LIBRARYQUALITY_key, LIBRARY_QUALITY_key)
                    if SCANS_key in lines[i].split('\n')[0]:
                        insert_msg = insert_msg.replace(SCANS_key, SCAN_ID_key)
                    if SPECTRUMID_key in lines[i].split('\n')[0]:
                        insert_msg = insert_msg.replace(SPECTRUMID_key, FEATURE_ID_key)
                    if INCHI_key in lines[i].split('\n')[0]:
                        #print(" before insert_msg --->: ", insert_msg)
                        insert_msg = insert_msg.replace("InChI=", '')
                        insert_msg = insert_msg.replace(INCHI_key, TAXONOMY_key)

                        #print(" after insert_msg --->: ", insert_msg)
                    self.ith_molecules_lst.append(insert_msg)
                # [end-if]
                cnt += 1
                progressBar.update(1, database_file_len)
                progressBar.printEv()
            # [end-loop]
            self.m.printLine()
            #self.m.printMesgAddStr("[molecules_lst]: last(ith) --->: ", self.c.getYellow(), self.ith_molecules_lst[:])
            #self.m.printMesgAddStr("[molecules_lst]:       (0) --->: ", self.c.getYellow(), self.molecules_lst[0])
            #self.m.printMesgAddStr("[molecules_lst]:      ("+str(len(self.molecules_lst)-1)+") --->: ",
            #                       self.c.getYellow(), self.molecules_lst[len(self.molecules_lst)-1])
            self.m.printMesgAddStr("[molecules_lst]:     (len) --->: ", self.c.getYellow(), len(self.molecules_lst[:]))
        except IOError:
            rc = self.c.get_RC_WARNING()
            print("[mgf_len]: Could not open file:", file_path, database_file_len)
            csv_len = 0
            print("Return code: ", self.c.get_RC_FAIL())
            exit(self.c.get_RC_FAIL())

        return rc
    def read_database_file(self, database_file):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        database_file_len = 0
        self.m.printMesgStr("Extracting database content (database_file): ", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------
        # Preamble of the readers
        # ----------------------------------------------------------------------
        file_path, rc = self.get_and_check_filename_path(database_file)
        # ----------------------------------------------------------------------
        # Starting the timers for the constructor
        # ----------------------------------------------------------------------
        start_key = "BEGIN IONS"
        end_key = "END IONS"
        trigger_key = "Scan#: "
        PUBCHEM_key = "PUBCHEM"

        try:
            #print("file_path -=-- > ", file_path)
            file = open(file_path)
            lines = file.readlines()
            database_file_len = len(lines)
            # ----------------------------------------------------------------------
            # Extracting the header from the file
            # ----------------------------------------------------------------------
            rc = self.read_header_database_file(file_path, lines, database_file_len)
            # ----------------------------------------------------------------------
            # Extracting the molecules
            # ----------------------------------------------------------------------
            progressBar = src.PythonCodes.utils.progressBar.ProgressBar()
            n_molecules = 0
            for i in range(database_file_len):
                if start_key in lines[i].split('\n')[0]:
                    n_molecules += 1
                #print("lines["+str(i)+"]", lines[i].split('\n')[0])
                progressBar.update(1, database_file_len)
                progressBar.printEv()
            # [end-loop]
            self.m.printLine()
            self.m.printMesgAddStr("[file_DB ]:(database file) --->: ", self.c.getMagenta(), database_file_len)
            self.m.printMesgAddStr("[file_DB ]:  (n molecules) --->: ", self.c.getYellow(), n_molecules)
            appending = False
            cnt = 0
            ith_molecule = 0
            insert_msg = ""
            progressBar = src.PythonCodes.utils.progressBar.ProgressBar()
            for i in range(database_file_len):
                if start_key in lines[i].split('\n')[0]:
                    ith_molecule += 1
                    appending = True
                if end_key in lines[i].split('\n')[0]:
                    appending = False
                    self.ith_molecules_lst.append(lines[i].split('\n')[0])
                    self.molecules_lst.append(self.ith_molecules_lst[:])
                    #self.m.printMesgAddStr("[molecules_lst]: mol("+str(ith_molecule)+"), line("+str(i)+") --->: ",
                    #                       self.c.getYellow(), self.ith_molecules_lst[:])
                    self.ith_molecules_lst.clear()
                elif appending:
                    insert_msg = (lines[i].split('\n')[0]).replace('\t', ' ')
                    if PUBCHEM_key in lines[i].split('\n')[0]:
                        to_be_replaced = PUBCHEM_key+"="
                        pubchem_key_replace = PUBCHEM_key+"="+self.c.getPubchem_url()+"/"
                        insert_msg = insert_msg.replace(to_be_replaced, pubchem_key_replace)
                    # [end-if] statement
                    # inserting the line into the list
                    self.ith_molecules_lst.append(insert_msg)
                # [end-if]
                cnt += 1
                progressBar.update(1, database_file_len)
                progressBar.printEv()
            # [end-loop]
            self.m.printLine()
            #self.m.printMesgAddStr("[molecules_lst]: last(ith) --->: ", self.c.getYellow(), self.ith_molecules_lst[:])
            self.m.printMesgAddStr("[molecules_lst]:       (0) --->: ", self.c.getYellow(), self.molecules_lst[0])
            #self.m.printMesgAddStr("[molecules_lst]:      ("+str(len(self.molecules_lst)-1)+") --->: ",
            #                       self.c.getYellow(), self.molecules_lst[len(self.molecules_lst)-1])
            self.m.printMesgAddStr("[molecules_lst]:     (len) --->: ", self.c.getYellow(), len(self.molecules_lst[:]))
        except IOError:
            rc = self.c.get_RC_WARNING()
            print("[mgf_len]: Could not open file:", file_path, database_file_len)
            csv_len = 0
            print("Return code: ", self.c.get_RC_FAIL())
            exit(self.c.get_RC_FAIL())

        return rc
    #---------------------------------------------------------------------------
    # [Getters]
    #---------------------------------------------------------------------------
    def getCharge_from_precursortype(self, precursortype):
        charge = "0"
        #tail = str(i_jsonfile_content_dict['IONMODE']).split(']')[1]
        if str(precursortype) == "":
            tail = str(precursortype)
        else:
            tail = str(precursortype)[len(precursortype)-1]

        if self.c.getDebug() == 1:
            print("tail +---->: ", tail)

        match tail:
            case "-": charge = "0-"
            case "": charge = "0"
            case "+": charge = "0+"

        return charge
        # [end-def]

    def get_and_check_filename_path(self, database_file):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        database_file_len = 0
        self.m.printMesgStr("get_and_check_filename_path (database_file): ", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------
        # Preamble of the readers
        # ----------------------------------------------------------------------
        self.m.printMesgAddStr("[file_DB ]:(database file) --->: ", self.c.getYellow(), database_file)
        self.m.printMesgAddStr("[file_DB ]:(Obj DB   file) --->: ", self.c.getYellow(), self.c.getDatabase_file())
        # ----------------------------------------------------------------------
        # Checking the existence and the coherence of the inpout file with object
        # ----------------------------------------------------------------------
        msg = "[file_DB]:      (checking) --->: " + self.c.getMagenta() + database_file + self.c.getBlue() + \
              " <--> " + self.c.getMagenta() + self.database_file + ", "
        if database_file == self.c.getDatabase_file():
            self.m.printMesgAddStr(msg, self.c.getGreen(), "SUCCESS -->: are the same")
        else:
            rc = self.c.get_RC_WARNING()
            self.m.printMesgAddStr(msg, self.c.getRed(), "WARNING -->: are not the same")
        file_path = self.database_path + os.sep + self.c.getDatabase_file()
        if os.path.isfile(file_path):
            msg = file_path + self.c.getGreen() + " ---> Exists"
            self.m.printMesgAddStr("[file_DB ]:(database file) --->: ", self.c.getMagenta(), msg)
        else:
            msg = file_path + self.c.getRed() + " ---> Does not exists"
            rc = self.c.get_RC_FAIL()
            self.m.printMesgAddStr("[file_DB ]:(database file) --->: ", self.c.getMagenta(), msg)
            src.PythonCodes.DataManage_common.getFinalExit(self.c, self.m, rc)
        return file_path, rc
    #---------------------------------------------------------------------------
    # [Printers]
    #---------------------------------------------------------------------------
    def printFileNames(self):
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgAddStr("[file_DB ]:(database file) --->: ", self.c.getYellow(), self.c.getDatabase_file())
        self.m.printMesgAddStr("[basename]:(file basename) --->: ", self.c.getCyan(), self.c.getFile_basename())
        self.m.printMesgAddStr("[file_asc]:     (asc file) --->: ", self.c.getRed(), self.c.getPlot_asc())
        self.m.printMesgAddStr("[file_csv]:     (csv file) --->: ", self.c.getCyan(), self.c.getCSV_file())
        return rc
#---------------------------------------------------------------------------
# end of DataBaseHandler
#---------------------------------------------------------------------------
