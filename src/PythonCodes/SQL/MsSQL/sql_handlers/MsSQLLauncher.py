'''!\file
   -- LDMaP-APP addon: (Python3 code) to handle the sql scripting and
      generation for incoming data from the microscopes into a pool of
      file for a given project
      (code under construction and subject to constant changes).
      \author Frederic Bonnet
      \date 27th of July 2020

      Leiden University July 2020
     Updated at Obs May 2024

Name:
---
MsSQLLauncher: module for launching SQL querries and pushing onto a databases
                            from the projects folder.

Description of classes:
---
This class generates and handles data coming from the microscopes for given 
project folder into a pool. The class also handles data coming from spectrometry

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
import time

import numpy
from subprocess import PIPE, run
# appending the utils path
sys.path.append(os.path.join(os.getcwd(), '.'))
sys.path.append(os.path.join(os.getcwd(), '..', '..', '..'))
sys.path.append(os.path.join(os.getcwd(), '..', '..', '..', 'utils'))
# application imports
#from DataManage_common import *
import src.PythonCodes.DataManage_common # DataManage_common import *
#import utils.messageHandler
#from messageHandler import *
#from StopWatch import *
import src.PythonCodes.utils.StopWatch #  utils.StopWatch
#from progressBar import *
import src.PythonCodes.utils.progressBar
import src.PythonCodes.utils.JSonLauncher
# ------------------------------------------------------------------------------
# Class to read star file from Relion
# file_type can be 'mrc' or 'ccp4' or 'imod'.
# ------------------------------------------------------------------------------
# ******************************************************************************
##\brief Python3 method.
# Class to read star file from Relion
# file_type can be 'mrc' or 'ccp4' or 'imod'.
class MsSQLLauncher:
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
        # File extension stuff
        self.ext_json = ".json"
        self.ext_sql = ".sql"
        # Object header files
        self.m.printMesgStr("Instantiating the class       :", self.c.getGreen(), "MsSQLLauncher")
        self.app_root = self.c.getApp_root()                                  # app_root
        self.data_path = self.c.getData_path()                               # data_path
        self.projectName = self.c.getProjectName()                      # projectName
        self.targetdir = self.c.getTargetdir()                                 # targetdir
        self.software = self.c.getSoftware()                                  # software
        self.pool_componentdir = self.c.getPool_componentdir()  # "_Pool or not"
        # Instantiating logfile mechanism
        logfile = self.c.getLogfileName()
        self.pool_targetdir = os.path.join(self.targetdir,
                                           self.projectName,
                                           self.pool_componentdir)
        self.c.setPool_Targetdir(self.pool_targetdir)

        self.sql_fullPath_dir = self.c.getSql_fullPath_dir()
        # ----------------------------------------------------------------------
        # preparing the path structure
        # ----------------------------------------------------------------------
        rc = self.create_path_structure()
        # ----------------------------------------------------------------------
        # Starting the timers for the constructor
        # ----------------------------------------------------------------------
        if c.getBench_cpu():
            # creating the timers and starting the stop watch...
            stopwatch = src.PythonCodes.utils.StopWatch.createTimer()
            src.PythonCodes.utils.StopWatch.StartTimer(stopwatch)

        if self.c.getDebug() == 1:
            self.m.printMesgAddStr("App_root                   --->: ", self.c.getMagenta(), self.c.getApp_root())
            self.m.printMesgAddStr("Data_path                  --->: ", self.c.getMagenta(), self.c.getData_path())
            self.m.printMesgAddStr("ProjectName                --->: ", self.c.getMagenta(), self.c.getProjectName())
            self.m.printMesgAddStr("Targetdir                  --->: ", self.c.getMagenta(), self.c.getTargetdir())
            self.m.printMesgAddStr("Software                   --->: ", self.c.getMagenta(), self.c.getSoftware())
            self.m.printMesgAddStr("Pool_componentdir          --->: ", self.c.getMagenta(), self.c.getPool_componentdir())
            self.m.printMesgAddStr("Pool_Targetdir             --->: ", self.c.getMagenta(), self.c.getPool_Targetdir())
            self.m.printMesgAddStr("Database directory name    --->: ", self.c.getMagenta(), self.c.getDatabase_path())
            self.m.printMesgAddStr("database_full_path_no_ext  --->: ", self.c.getMagenta(), self.c.getDatabase_full_path_no_ext())
            self.m.printMesgAddStr("Database file              --->: ", self.c.getMagenta(), self.c.getDatabase_file())
            self.m.printMesgAddStr("Database name              --->: ", self.c.getMagenta(), self.c.getDatabase_name())
            self.m.printMesgAddStr("Database schema            --->: ", self.c.getMagenta(), self.c.getDatabase_schema())
            self.m.printMesgAddStr("Database port              --->: ", self.c.getMagenta(), self.c.getDatabase_port())
            self.m.printMesgAddStr("File basename              --->: ", self.c.getMagenta(), self.c.getFile_basename())
            self.m.printMesgAddStr("SQL_dir                    --->: ", self.c.getMagenta(), self.c.getSql_dir())
            self.m.printMesgAddStr("SQL full path dir          --->: ", self.c.getMagenta(), self.c.getSql_fullPath_dir())
        # ----------------------------------------------------------------------
        # Setting up the file environment
        # ----------------------------------------------------------------------
        #self.ProjectsNameID = self.projectName.split('_')[0]
        #self.ProjectNumber = self.projectName.split('_')[1]
        # ----------------------------------------------------------------------
        # Setting up the file environment
        # ----------------------------------------------------------------------
        self.json_ext = ".json"
        self.jsonfilenamelist = "target_jsonfile.txt"
        self.jsondir = "JSonFiles_json"
        self.jsontargetfile = self.pool_targetdir+os.path.sep + \
                              "target_jsonfile.txt"
        self.c.setJsontargetdir(self.jsontargetfile)

        # ----------------------------------------------------------------------
        # Genrating the json file target list
        # ----------------------------------------------------------------------
        self.jsonLauncher = src.PythonCodes.utils.JSonLauncher.JSonLauncher(c,m)
        # ----------------------------------------------------------------------
        # Genrating the json file target list
        # ----------------------------------------------------------------------
        rc, self.jsontargetfile = self.jsonLauncher.generate_JsonFileList(self.jsondir, self.json_ext)
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
    #---------------------------------------------------------------------------
    # [Creator]
    #---------------------------------------------------------------------------
    def create_path_structure(self):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()

        # The SQL directory
        self.m.printMesgStr("Check/Create      : ", self.c.getMagenta(), str(self.c.getSql_fullPath_dir()).strip())
        if os.path.exists(str(self.c.getSql_fullPath_dir()).strip()):
            sys.path.append(str(self.c.getSql_fullPath_dir()))
            self.m.printMesgAddStr("  "+self.c.getSql_fullPath_dir()+" : ", self.c.getGreen(), "Exits nothing to do")
        else:
            self.m.printMesgAddStr("  "+str(self.c.getSql_fullPath_dir())+" : ", self.c.getRed(), "Does not Exits we will create it...")
            os.mkdir(str(self.c.getSql_fullPath_dir()).strip())
            self.m.printMesgAddStr("                   : ", self.c.getGreen(), "Done.")
            sys.path.append(self.c.getSql_fullPath_dir())

        return rc
    # --------------------------------------------------------------------------
    # [SQL-Updateor-Insertors]
    # --------------------------------------------------------------------------
    def ProjectsNameSQLUpdaterInsertors(self, projects_info_lst, sql_dir):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()

        sql_fullPath_dir = self.pool_targetdir+os.path.sep+sql_dir
        self.m.printMesg("Project Details in question...")
        self.m.printMesgAddStr(" ProjectName      : ",
                               self.c.getCyan(), str(self.projectName))
        self.m.printMesgAddStr(" ProjectsNameID   : ",
                               self.c.getYellow(), str(self.ProjectsNameID))
        self.m.printMesgAddStr(" ProjectNumber    : ",
                               self.c.getGreen(), str(self.ProjectNumber))
        self.m.printMesgAddStr(" SQL full path dir: ",
                               self.c.getGreen(), sql_fullPath_dir)
        #-----------------------------------------------------------------------
        # Generating the zerolead for the sql file constriction
        #-----------------------------------------------------------------------
        rc, zerolead = self.generate_Zerolead(len(projects_info_lst))
        # -----------------------------------------------------------------------
        # constructing the leading zeros according to nboot
        # -----------------------------------------------------------------------
        database = "NeCENDatabase-Prod"
        table = "ProjectsNameTable"
        sqlProjectsNameFileList = []
        ext_json = ".json"
        ext_sql = ".sql"
        progressBar = src.PythonCodes.utils.progressBar.ProgressBar() #ProgressBar()
        for iproj in range(len(projects_info_lst)):
            #print(user_info_lst[iuser])
            file_name = sql_fullPath_dir + os.path.sep + "ProjectsNameUpdatorInsertor" + \
                                  str(iproj).zfill(len(str(zerolead))) + ext_sql

            sqlProjectsNameFileList.append(file_name)
            file_sql = open(file_name, 'w')

            rc = self.projectsNameSSQLWritter(file_sql, iproj, projects_info_lst[iproj], database, table)

            progressBar.update(1, len(projects_info_lst))
            progressBar.printEv()
            file_sql.close()

        self.m.printLine()
        progressBar.resetprogressBar()
        # ----------------------------------------------------------------------
        # End of the method
        # ----------------------------------------------------------------------
        return rc, sqlProjectsNameFileList

    def usersSQLUpdaterInsertors(self, users_info_lst, sql_dir):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()

        sql_fullPath_dir = self.pool_targetdir+os.path.sep+sql_dir
        self.m.printMesg("Project Details in question...")
        self.m.printMesgAddStr(" ProjectName      : ",
                               self.c.getCyan(), str(self.projectName))
        self.m.printMesgAddStr(" ProjectsNameID   : ",
                               self.c.getYellow(), str(self.ProjectsNameID))
        self.m.printMesgAddStr(" ProjectNumber    : ",
                               self.c.getGreen(), str(self.ProjectNumber))
        self.m.printMesgAddStr(" SQL full path dir: ",
                               self.c.getGreen(), sql_fullPath_dir)
        #-----------------------------------------------------------------------
        # Generating the zerolead for the sql file constriction
        #-----------------------------------------------------------------------
        rc, zerolead = self.generate_Zerolead(len(users_info_lst))
        # -----------------------------------------------------------------------
        # constructing the leading zeros according to nboot
        # -----------------------------------------------------------------------
        database = "NeCENDatabase-Prod"
        table = "UsersTable"
        sqlUsersFileList = []
        ext_json = ".json"
        ext_sql = ".sql"
        progressBar = src.PythonCodes.utils.progressBar.ProgressBar()#ProgressBar()
        for iuser in range(len(users_info_lst)):
            #print(user_info_lst[iuser])
            file_name = sql_fullPath_dir + os.path.sep + "UserUpdatorInsertor" + \
                                  str(iuser).zfill(len(str(zerolead))) + ext_sql

            sqlUsersFileList.append(file_name)
            file_sql = open(file_name, 'w')
            rc = self.usersSSQLWritter(file_sql, iuser, users_info_lst[iuser], database, table)

            progressBar.update(1, len(users_info_lst))
            progressBar.printEv()
            file_sql.close()

        self.m.printLine()
        progressBar.resetprogressBar()
        # ----------------------------------------------------------------------
        # End of the method
        # ----------------------------------------------------------------------
        return rc, sqlUsersFileList

    # TODO: need to remove jsonfile_content_key, jsonfile_content_value from the argument list
    #       later if not needed.
    def PostgreSQL_UpdaterInsertors(self, tb,
                                    jsonSanner, json_data_table_count,
                                    queryMsSQL, cursor,
                                    Json_Mol_FileList, jsonfile_content_dict_lst,
                                    jsonfile_content_key, jsonfile_content_value):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("PostgreSQL database insertion, imcoming table :----> "+self.c.getYellow()+str(tb)+" --->: ",
                            self.c.getGreen(), __func__)
        if self.c.getDebug() == 1:
            self.m.printMesg("Project Details in question...")
            self.m.printMesgAddStr(" ProjectName               --->: ", self.c.getCyan(), self.projectName)
            self.m.printMesgAddStr(" Database name             --->: ", self.c.getYellow(), self.c.getDatabase_name())
            self.m.printMesgAddStr(" Database schema           --->: ", self.c.getCyan(), self.c.getDatabase_schema())
            self.m.printMesgAddStr(" SQL dir                   --->: ", self.c.getGreen(), self.c.getSql_dir())
            self.m.printMesgAddStr(" SQL full path dir         --->: ", self.c.getMagenta(), self.c.getSql_fullPath_dir())
            self.m.printMesgAddStr(" Pool targetdir            --->: ", self.c.getGreen(), self.c.getPool_Targetdir())
        #-----------------------------------------------------------------------
        # Generating the zerolead for the sql file constriction
        #-----------------------------------------------------------------------
        rc, zerolead = self.generate_Zerolead(len(Json_Mol_FileList[:]))
        if zerolead <= numpy.power(10, 4):
            rc, zerolead = self.generate_Zerolead(numpy.power(10, 4))
        # -----------------------------------------------------------------------
        # constructing the leading zeros according to file list or 10^4
        # -----------------------------------------------------------------------
        database = self.c.getDatabase_name()
        table = tb
        sqlCTFFileList = []
        #ext_json = ".json"
        #ext_sql = ".sql"
        cnt_analytics = 0
        cnt_date = 0
        cnt_experiment = 0
        progressBar = src.PythonCodes.utils.progressBar.ProgressBar()
        for ifile in range(len(Json_Mol_FileList[:])):
            head, tail = os.path.split(Json_Mol_FileList[ifile])
            msg = os.path.join(self.c.getSql_fullPath_dir(), tail.split(self.ext_json)[0] + self.ext_sql)
            sqlCTFFileList.append(msg)

            file_sql = open(sqlCTFFileList[ifile], 'w')

            # TODO: 1. insert Tool for tool_id
            rc, tb_count = jsonSanner.get_TableCount_FromTable(json_data=json_data_table_count, table='tool', silent=True)
            table_length = int(tb_count)
            rc = self.MolRefAnt_DB_POstGresSQLWritter_Tool(file_sql,
                                                           queryMsSQL, cursor,
                                                           jsonfile_content_dict_lst[ifile],
                                                           database, 'tool', table_length)
            #print("tb_count --->: ", tb_count)
            #print("tb_count --->: ", tb_count)
            # TODO: 2. insert database_details for database_id

            rc, tb_count = jsonSanner.get_TableCount_FromTable(json_data=json_data_table_count, table='database_details', silent=True)
            table_length = int(tb_count)
            import_database_name = str(os.path.basename(sqlCTFFileList[ifile])).split('_molecule')[0].strip()
            rc = self.MolRefAnt_DB_POstGresSQLWritter_Database_details(file_sql,
                                                                       queryMsSQL, cursor,
                                                                       jsonfile_content_dict_lst[ifile],
                                                                       import_database_name,
                                                                       'database_details', table_length)
            # TODO: 3. insert analytics_data for annalytics_data_id
            rc, tb_count = jsonSanner.get_TableCount_FromTable(json_data=json_data_table_count, table='analytics_data', silent=True)
            #table_length = int(tb_count)
            table_length = cnt_analytics + int(tb_count)
            rc = self.MolRefAnt_DB_POstGresSQLWritter_Analytics_data(file_sql,
                                                                     jsonSanner, json_data_table_count,
                                                                     queryMsSQL, cursor,
                                                                     jsonfile_content_dict_lst[ifile],
                                                                     import_database_name,
                                                                     'analytics_data', table_length)
            cnt_analytics += 1

            #progressBar.update(1, len(Json_Mol_FileList[:]))
            #progressBar.printEv()

            file_sql.close()
        # [end-loop] ifile in range(len(Json_Mol_FileList[:]))

        self.m.printLine()
        progressBar.resetprogressBar()

        return rc, sqlCTFFileList

    def ctfSQLUpdaterInsertors(self, JsonCTFFileList, jsonfile_content, sql_dir, table_length):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()

        sql_fullPath_dir = self.pool_targetdir+os.path.sep+sql_dir
        self.m.printMesg("Project Details in question...")
        self.m.printMesgAddStr(" ProjectName      : ", self.c.getCyan(), str(self.projectName))
        self.m.printMesgAddStr(" ProjectsNameID   : ", self.c.getYellow(), str(self.ProjectsNameID))
        self.m.printMesgAddStr(" ProjectNumber    : ", self.c.getGreen(), str(self.ProjectNumber))
        self.m.printMesgAddStr(" SQL full path dir: ", self.c.getGreen(), sql_fullPath_dir)
        #-----------------------------------------------------------------------
        # Generating the zerolead for the sql file constriction
        #-----------------------------------------------------------------------
        rc, zerolead = self.generate_Zerolead(len(JsonCTFFileList))
        # -----------------------------------------------------------------------
        # constructing the leading zeros according to nboot
        # -----------------------------------------------------------------------
        database = "NeCENDatabase-Prod"
        table = "CTFDetailsKrios1Table"
        sqlCTFFileList = []
        ext_json = ".json"
        ext_sql = ".sql"
        progressBar = src.PythonCodes.utils.progressBar.ProgressBar()
        for ifile in range(len(JsonCTFFileList)):
            head, tail = os.path.split(JsonCTFFileList[ifile])
            sqlCTFFileList.append(sql_dir + os.path.sep + tail.split(ext_json)[0] + \
                                  str(ifile).zfill(len(str(zerolead))) + ext_sql)

            file_name = self.pool_targetdir + os.path.sep + sqlCTFFileList[ifile]
            file_sql = open(file_name, 'w')

            rc = self.ctfSSQLWritter(file_sql, jsonfile_content[ifile],
                                     database, table, table_length)

            progressBar.update(1, len(JsonCTFFileList))
            progressBar.printEv()

            file_sql.close()

        self.m.printLine()
        progressBar.resetprogressBar()

        return rc, sqlCTFFileList
    #---------------------------------------------------------------------------
    # [SQL-Writters]
    #---------------------------------------------------------------------------
    def projectsNameSSQLWritter(self, file_hdl, iproj, project_info, database, table):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        #-----------------------------------------------------------------------
        # First create an empty row
        #-----------------------------------------------------------------------
        sqlUsersFileList_entries = []
        start_UProjectsNameINDX = 8
        file_hdl.write("USE ["+database+"]\n")
        file_hdl.write("GO\n")
        file_hdl.write("\n")
        file_hdl.write("INSERT INTO [dbo].["+table+"]\n")
        file_hdl.write("(ProjectsNameINDX, UsersID, ProjectsNameID, ProjectNumber, ScopeNameID, Operator,\n")
        file_hdl.write("ComplementInfo, DateMinStamp, DateMaxStamp, DataSize, AnaSize, Software, ProjType\n")
        file_hdl.write(")\n")
        file_hdl.write("VALUES\n")
        file_hdl.write("('"+str(start_UProjectsNameINDX+iproj)+"', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)\n")
        file_hdl.write(";\n")
        #-----------------------------------------------------------------------
        # Updating the row thta has just been created
        #-----------------------------------------------------------------------

        return rc

    def usersSSQLWritter(self, file_hdl, iuser, users_info, database, table):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        # ----------------------------------------------------------------------
        # First create an empty row
        # ----------------------------------------------------------------------
        sqlUsersFileList_entries = []
        start_UsersID = 132
        file_hdl.write("USE ["+database+"]\n")
        file_hdl.write("GO\n")
        file_hdl.write("\n")
        file_hdl.write("INSERT INTO [dbo].["+table+"]\n")
        file_hdl.write("([UsersID], [Firstname], [LastName], [EmailAddress], [StartUserActivityDate], [StopUserActivityDate],\n")
        file_hdl.write(" [UserGroup], [Affiliation], [AffiliationSubsidy], [ActivityStatus], [ScreeningID], [DataPreProcID], [DataPostProcID]\n")
        file_hdl.write(")\n")

        file_hdl.write("VALUES\n")
        file_hdl.write("('"+str(start_UsersID+iuser)+"', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)\n")
        file_hdl.write(";\n")
        # ----------------------------------------------------------------------
        # Updating the row thta has just been created
        # ----------------------------------------------------------------------
        #login,lname,fname,email,phone,bcode,affiliation,unitlogin,mustchpwd,mustchbcode,active
        sqlUsersFileList_entries = users_info.split(',')
        #print("sqlUsersFileList_entries: ", sqlUsersFileList_entries)
        file_hdl.write("\n")
        file_hdl.write("\n")
        file_hdl.write("USE ["+database+"]\n")
        file_hdl.write("GO\n")
        file_hdl.write("\n")
        file_hdl.write("UPDATE [dbo].["+table+"]\n")
        file_hdl.write("SET\n")
        file_hdl.write("[UsersID] = '" + str(start_UsersID+iuser)+"',\n")
        file_hdl.write("[Firstname] = N'" +sqlUsersFileList_entries[2]+"',\n")
        file_hdl.write("[LastName] = N'" +sqlUsersFileList_entries[1]+"',\n")
        file_hdl.write("[EmailAddress] = N'" +sqlUsersFileList_entries[3]+"',\n")
        file_hdl.write("[StartUserActivityDate] = "+'NULL'+",\n")   #N'"+''+"',\n")
        file_hdl.write("[StopUserActivityDate] = "+'NULL'+",\n")    #N'"+''+"',\n")

        group_afiliat = sqlUsersFileList_entries[7].split('-')
        if len(group_afiliat[:]) == 0:
            file_hdl.write("[UserGroup] = N'',\n")
            file_hdl.write("[Affiliation] = N'',\n")
        if len(group_afiliat[:]) == 1:
            file_hdl.write("[UserGroup] = N'"+ str(group_afiliat[0]).strip()+"',\n")
            if str(group_afiliat[0]).strip() == "NeCEN":
                file_hdl.write("[Affiliation] = N'"+str(group_afiliat[0]).strip()+"',\n")
            else:
                file_hdl.write("[Affiliation] = N'',\n")
        elif len(group_afiliat[:]) == 2:
            file_hdl.write("[UserGroup] = N'" + sqlUsersFileList_entries[7].strip() + "',\n")
            if str(group_afiliat[1]).strip() == "LU":
                file_hdl.write("[Affiliation] = N'" + "Leiden University" + "',\n")
            elif str(group_afiliat[1]).strip() == "UU":
                file_hdl.write("[Affiliation] = N'" + "Utrecht University" + "',\n")
            elif str(group_afiliat[1]).strip() == "MU":
                file_hdl.write("[Affiliation] = N'" + "Maastricht University" + "',\n")
            elif str(group_afiliat[1]).strip() == "RUG":
                file_hdl.write("[Affiliation] = N'" + "University of Groningen" + "',\n")
            elif str(group_afiliat[1]).strip() == "NKI":
                file_hdl.write("[Affiliation] = N'" + "Netherlands Cancer Institute" + "',\n")
            elif str(group_afiliat[1]).strip() == "LUMC":
                file_hdl.write("[Affiliation] = N'" + "Leiden University Medical Center" + "',\n")
            elif str(group_afiliat[1]).strip() == "TUD":
                file_hdl.write("[Affiliation] = N'" + "Delft University of Technology" + "',\n")
            else:
                file_hdl.write("[Affiliation] = N'" + str(group_afiliat[1]).strip() + "',\n")

        file_hdl.write("[AffiliationSubsidy] = N'"+sqlUsersFileList_entries[6]+"',\n")
        if sqlUsersFileList_entries[len(sqlUsersFileList_entries)-1] == 'false':
            file_hdl.write("[ActivityStatus] = N'" +'Non Active' +"',\n")
        if sqlUsersFileList_entries[len(sqlUsersFileList_entries)-1] == 'true':
            file_hdl.write("[ActivityStatus] = N'" +'Active' +"',\n")
        file_hdl.write("[ScreeningID] = N'"+str(start_UsersID+iuser)+'001'+"',\n")
        file_hdl.write("[DataPreProcID] = N'"+str(start_UsersID+iuser)+'001'+"',\n")
        file_hdl.write("[DataPostProcID] = N'"+str(start_UsersID+iuser)+'001'+"'\n")
        file_hdl.write("WHERE\n")
        file_hdl.write("UsersID = "+str(start_UsersID+iuser)+"\n")  #3
        file_hdl.write("GO\n")

        return rc

    def usersSQLBatPusher(self, sqlUsersFileList, sql_dir):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        # ----------------------------------------------------------------------
        # First create an empty row, method not used yet, might later
        # ----------------------------------------------------------------------
        return rc

    def MolRefAnt_DB_POstGresSQLWritter_Tool(self, file_hdl, queryMsSQL, cursor,
                                             i_jsonfile_content_dict,
                                             database, table, table_length):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()

        rc, tool_id = queryMsSQL.query_GetTool_Id(cursor=cursor,
                                                  tool=i_jsonfile_content_dict['SOURCE_INSTRUMENT'])

        rc, tb_count = queryMsSQL.query_PostGreSQL_GetTableCount(cursor=cursor,
                                                                 database=self.c.getDatabase_name(),
                                                                 schema=self.c.getDatabase_schema(),
                                                                 table='tool', silent=True)
        if (tool_id == 0):
            insertion_point = tb_count + 1 # int(i_jsonfile_content_dict['mol_num'])
            #-------------------------------------------------------------------
            # [file-Creator-Tool]
            #-------------------------------------------------------------------
            file_hdl.write("insert into\n")
            file_hdl.write("    \""+database+"\".\""+self.c.getDatabase_schema()+"\"."+table+"(\n")
            file_hdl.write("    tool_id,\n")                         # TODO: ---> Done
            file_hdl.write("    instrument_source)\n")               # TODO: ---> Done
            file_hdl.write("VALUES (\n")
            msg = str(insertion_point)+", "+"'"+str(i_jsonfile_content_dict['SOURCE_INSTRUMENT'])+"'\n"
            file_hdl.write(msg)
            file_hdl.write(");\n")
            file_hdl.write("\n")
            #-------------------------------------------------------------------
            # [MSG-Creator-Tool]
            #-------------------------------------------------------------------
            instrument_source = i_jsonfile_content_dict['SOURCE_INSTRUMENT']
            msg = ("insert into \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\"."+table+"(" +
                   "tool_id, instrument_source)" +
                   " VALUES " +
                   "("+str(insertion_point)+", "+"'"+str(instrument_source)+"'"+");")

            rc = self.MolRefAnt_DB_POstGresSQLPusher(queryMsSQL=queryMsSQL, cursor=cursor, push_request=msg)
            #-------------------------------------------------------------------
            # [MSG-Creator-Ionising]
            #-------------------------------------------------------------------
            rc, tb_count = queryMsSQL.query_PostGreSQL_GetTableCount(cursor=cursor,
                                                                     database=self.c.getDatabase_name(),
                                                                     schema=self.c.getDatabase_schema(),
                                                                     table='ionisation_mode', silent=True)
            msg_print = self.c.getYellow()+str(instrument_source)+self.c.getBlue()+", n ionisation_mode: "+self.c.getCyan()+str(tb_count)
            self.m.printMesgAddStr(" instrument source ("+self.c.getGreen()+str(insertion_point)+self.c.getBlue()+")     --->: ", self.c.getGreen(), msg_print)

            rc, procedure = queryMsSQL.procedure_Fill_IonisingTable(cursor=cursor, tool_id=insertion_point)
            rc = self.MolRefAnt_DB_POstGresSQLPusher(queryMsSQL=queryMsSQL, cursor=cursor, push_request=procedure)
        # [end-if]

        return rc

    def MolRefAnt_DB_POstGresSQLWritter_Database_details(self, file_hdl, queryMsSQL, cursor,
                                                         i_jsonfile_content_dict,
                                                         database, table, table_length):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()

        rc, database_id = queryMsSQL.query_GetDatabase_Id(cursor=cursor,
                                                          database=i_jsonfile_content_dict['database_name'])
        if database_id == 0:
            insertion_point = table_length + 1
            #-------------------------------------------------------------------
            # [file-Creator]
            #-------------------------------------------------------------------
            '''
            create table if not exists
                 "MolRefAnt_DB_PostGreSQL"."MolRefAnt_DB".Database_Details(
                 database_id INT,
                 database_name VARCHAR(50),
                 database_affiliation VARCHAR(50),
                 database_path VARCHAR(100),
                 library_quality_legend VARCHAR(250),
                 PRIMARY KEY(database_id)
            );
            '''
            file_hdl.write("insert into\n")
            file_hdl.write("    \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\"."+table+"(\n")
            file_hdl.write("    database_id,\n")                 # TODO: ---> Done
            file_hdl.write("    database_name,\n")               # TODO: ---> Done
            file_hdl.write("    database_affiliation,\n")        # TODO: ---> Done
            file_hdl.write("    database_path,\n")               # TODO: ---> Done
            file_hdl.write("    library_quality_legend)\n")      # TODO: ---> Done
            file_hdl.write("VALUES (\n")
            file_hdl.write(str(insertion_point)+",\n")
            file_hdl.write("'"+str(database)+"',\n")
            file_hdl.write("'"+str(i_jsonfile_content_dict['SOURCE_INSTRUMENT'])+"',\n")
            file_hdl.write("'"+str(self.c.getDatabase_path()).strip().split(os.path.sep)[0]+"',\n")

            library_quality_legend = "null"
            LIBRARY_QUALITY_key = "LIBRARY_QUALITY"
            if LIBRARY_QUALITY_key in i_jsonfile_content_dict.keys():
                library_quality_legend = i_jsonfile_content_dict[LIBRARY_QUALITY_key]

            file_hdl.write(str(library_quality_legend)+"\n")
            file_hdl.write(");\n")
            # inserting a line for clarity
            file_hdl.write("\n")
            #-------------------------------------------------------------------
            # [MSG-Creator]
            #-------------------------------------------------------------------
            msg = ("insert into \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\"."+table+"(" +
                   "database_id, database_name, database_affiliation, database_path, library_quality_legend)" +
                   " VALUES " +
                   "("+str(insertion_point)+","+"'"+str(database)+"', "+"'"+str(i_jsonfile_content_dict['SOURCE_INSTRUMENT'])+"', " +
                   "'"+str(self.c.getDatabase_path()).strip().split(os.path.sep)[0]+"', "+str(library_quality_legend)+");")

            rc = self.MolRefAnt_DB_POstGresSQLPusher(queryMsSQL=queryMsSQL, cursor=cursor, push_request=msg)

        return rc

    def MolRefAnt_DB_POstGresSQLWritter_Analytics_data(self, file_hdl, jsonSanner, json_data_table_count,
                                                       queryMsSQL, cursor,
                                                       i_jsonfile_content_dict,
                                                       database, table, table_length):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        insertion_point = 0
        rc, tb_count = jsonSanner.get_TableCount_FromTable(json_data=json_data_table_count, table=table, silent=True)
        rc, analytics_data_id = queryMsSQL.query_GetAnalytics_data_Id(cursor=cursor,
                                                                      molecule_json_filename=i_jsonfile_content_dict['molecule_json_filename'])
        if self.c.getDebug() == 1:
            print("analytics_data_id +--->: ", analytics_data_id)
            print("i_jsonfile_content_dict['molecule_json_filename'] +---> ", i_jsonfile_content_dict['molecule_json_filename'])
            print("int(tb_count) after get_TableCount_FromTable analytics_data  +---> ", int(tb_count))
            print("table_length before get_TableCount_FromTable analytics_data +---> ", table_length)

        if analytics_data_id == 0:
            insertion_point = table_length + 1
            #print("insertion_point +--->: ", insertion_point)
            file_hdl.write("insert into\n")
            file_hdl.write("    \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\"."+table+"(\n")
            file_hdl.write("    analytics_data_id,\n")                 # TODO: ---> Done
            file_hdl.write("    sample_name,\n")                       # TODO: ---> Done
            file_hdl.write("    sample_details,\n")                    # TODO: ---> Done
            file_hdl.write("    sample_solvent,\n")                    # TODO: ---> Done
            file_hdl.write("    number_scans,\n")                      # TODO: ---> Done
            file_hdl.write("    filename)\n")                          # TODO: ---> Done
            file_hdl.write("VALUES (\n")
            file_hdl.write(str(insertion_point)+",\n")

            sample_name = "sample 1"
            FILENAME_key = "FILENAME"
            if FILENAME_key in i_jsonfile_content_dict.keys():
                sample_name = str(i_jsonfile_content_dict[FILENAME_key]).strip()

            file_hdl.write("\'"+sample_name+"\',\n")

            file_hdl.write("\'details 1\',\n")
            file_hdl.write("\'solvent 1\',\n")

            # Get the scan_id from the dictionary
            SCAN_ID_key = "SCAN_ID"
            number_scans = "999999"
            if SCAN_ID_key in i_jsonfile_content_dict.keys():
                number_scans = str(i_jsonfile_content_dict[SCAN_ID_key]).strip()

            file_hdl.write("\'"+str(number_scans)+"\',\n")
            file_hdl.write("'"+str(['molecule_json_filename']).strip()+"'\n")
            file_hdl.write(");\n")
            # inserting a line for clarity
            file_hdl.write("\n")
            #-------------------------------------------------------------------
            # [MSG-Creator]
            #-------------------------------------------------------------------
            msg = ("insert into \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\"."+table+"(" +
                   "analytics_data_id, sample_name, sample_details, sample_solvent, number_scans, filename)" +
                   " VALUES " +
                   "("+str(insertion_point)+","+"'"+str(sample_name)+"', "+"'"+"details 1"+"', "+"'"+"solvent 1"+"', " +
                   "'"+str(number_scans)+"', "+"'"+str(i_jsonfile_content_dict['molecule_json_filename']).strip()+"'"+");")

            rc = self.MolRefAnt_DB_POstGresSQLPusher(queryMsSQL=queryMsSQL, cursor=cursor, push_request=msg)
            #-------------------------------------------------------------------
            # [Experiment]
            #-------------------------------------------------------------------
            rc = self.MolRefAnt_DB_POstGresSQLWritter_Experiment(file_hdl, insertion_point,
                                                                 queryMsSQL, cursor,
                                                                 i_jsonfile_content_dict,
                                                                 'experiment', table_length)
            #-------------------------------------------------------------------
            # [DateTable]
            #-------------------------------------------------------------------
            rc = self.MolRefAnt_DB_POstGresSQLWritter_Datetable(file_hdl, insertion_point,
                                                                queryMsSQL, cursor,
                                                                i_jsonfile_content_dict,
                                                                'datetable', table_length)
            #-------------------------------------------------------------------
            # [Data]
            #-------------------------------------------------------------------
            rc = self.MolRefAnt_DB_POstGresSQLWritter_Data(file_hdl, insertion_point,
                                                           queryMsSQL, cursor,
                                                           i_jsonfile_content_dict,
                                                           'data', table_length)
            #-------------------------------------------------------------------
            # [Spectral_Data]
            #-------------------------------------------------------------------
            rc = self.MolRefAnt_DB_POstGresSQLWritter_Spectral_data(file_hdl, jsonSanner, json_data_table_count,
                                                                    insertion_point,
                                                                    queryMsSQL, cursor,
                                                                    i_jsonfile_content_dict,
                                                                    'spectral_data', table_length)
        return rc
    #-------------------------------------------------------------------
    # [Spectral_Data]
    #-------------------------------------------------------------------
    def MolRefAnt_DB_POstGresSQLWritter_Spectral_data(self, file_hdl, jsonSanner, json_data_table_count,
                                                      insertion_point,
                                                      queryMsSQL, cursor,
                                                      i_jsonfile_content_dict,
                                                      table, table_length):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        if self.c.getDebug() == 1:
            print("i_jsonfile_content_dict --> ", i_jsonfile_content_dict['PEPMASS'])
            print("schema --> ", self.c.getDatabase_schema())
            print("table --> ", table)
            print("table_length --> ", table_length)
            print("insertion_point --> ", insertion_point)
        #-------------------------------------------------------------------
        # [Num-Peaks-list]
        #-------------------------------------------------------------------
        peaks_list_lst =[]
        num_peaks = 0
        peaks_list = ""
        for key, value in i_jsonfile_content_dict.items():
            if key.startswith('mz rel:'):
                num_peaks += 1
                mz_value = value[0]
                relative = value[1]
                peaks_list += str(mz_value)+" "+str(relative)+"\\n"
                msg = str(mz_value)+", "+str(relative)
                peaks_list_lst.append(msg)
        # [end-loop]
        num_peaks = len(peaks_list_lst[:])
        #-------------------------------------------------------------------
        # [SQL-file]
        #-------------------------------------------------------------------
        file_hdl.write("insert into\n")
        file_hdl.write("    \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\"."+table+"(\n")
        file_hdl.write("    spectral_data_id,\n")                         # TODO: ---> Done
        file_hdl.write("    feature_id,\n")                               # TODO: ---> Done
        file_hdl.write("    pepmass,\n")                                  # TODO: ---> Done
        file_hdl.write("    mslevel,\n")                                  # TODO: ---> Done
        file_hdl.write("    scan_number,\n")                              # TODO: ---> Done
        file_hdl.write("    retention_time,\n")                           # TODO: ---> Done
        file_hdl.write("    mol_json_file,\n")                            # TODO: ---> Done
        file_hdl.write("    num_peaks, peaks_list,\n")                    # TODO: ---> Done
        file_hdl.write("    ionmodechem_id,\n")                           # TODO: ---> Done
        file_hdl.write("    charge_id,\n")                                # TODO: ---> Done
        file_hdl.write("    tool_id,\n")                                  # TODO: ---> Done
        file_hdl.write("    database_id, data_id)\n")                     # TODO: ---> Done
        file_hdl.write("VALUES (\n")
        file_hdl.write(str(insertion_point)+",\n")
        feature_id = i_jsonfile_content_dict['FEATURE_ID']
        file_hdl.write("'"+str(feature_id)+"',\n")
        pepmass = i_jsonfile_content_dict['PEPMASS']
        file_hdl.write(str(pepmass)+",\n")
        mslevel = i_jsonfile_content_dict['MSLEVEL']
        file_hdl.write("'"+str(mslevel)+"',\n")
        file_hdl.write(str(num_peaks)+",\n")
        file_hdl.write("'"+peaks_list+"',\n")
        mol_json_file = i_jsonfile_content_dict['molecule_json_filename']
        file_hdl.write("'"+str(mol_json_file).strip()+"',\n")
        # scan_id and retention time entries
        SCAN_ID_key = "SCAN_ID"
        scan_number = "999999"
        if SCAN_ID_key in i_jsonfile_content_dict.keys():
            scan_number = str(i_jsonfile_content_dict[SCAN_ID_key]).strip()
        file_hdl.write("'"+str(scan_number)+"',\n")
        # TODO: fix the the retention time here
        RT_key = "RT"
        if RT_key in i_jsonfile_content_dict.keys():
            retention_time = "'"+str(i_jsonfile_content_dict[RT_key]).strip()+"',\n"
            file_hdl.write(str(retention_time))
        else:
            retention_time = "null"+",\n"
            file_hdl.write(str(retention_time))

        # TODO: fix the ionmodechem_id here
        rc, ionmodechem_id = queryMsSQL.query_GetIonModeChem_Id(cursor=cursor,
                                                                ionmodechem=str(i_jsonfile_content_dict['IONMODE']))
        # ionmodechem does not exist we will insert it
        if ionmodechem_id == 0:
            # get the number of entries in the
            rc, tb_count = queryMsSQL.query_PostGreSQL_GetTableCount(cursor=cursor,
                                                                     database=self.c.getDatabase_name(),
                                                                     schema=self.c.getDatabase_schema(),
                                                                     table='ionmodechem', silent=True)
            insertion_into_ionmodechem = tb_count + 1
            #-------------------------------------------------------------------
            # [MSG-Creator]
            #-------------------------------------------------------------------
            '''
            create table if not exists
            "MolRefAnt_DB_PostGreSQL"."MolRefAnt_DB".ionmodechem(
                ionmodechem_id INT,
                chemical_composition VARCHAR(80),
            PRIMARY KEY(ionmodechem_id)
            );
            '''
            #-------------------------------------------------------------------
            # [MSG-Creator]
            #-------------------------------------------------------------------
            msg = ("insert into \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\"."+'ionmodechem'+"(" +
               "ionmodechem_id, chemical_composition)" +
               " VALUES " +
               "("+
               str(insertion_into_ionmodechem)+", "+"'"+str(i_jsonfile_content_dict['IONMODE']).strip()+"'"+
               ");"
               )
            rc = self.MolRefAnt_DB_POstGresSQLPusher(queryMsSQL=queryMsSQL, cursor=cursor, push_request=msg)
        # [end-if] statement if ionmodechem
        rc, ionmodechem_id = queryMsSQL.query_GetIonModeChem_Id(cursor=cursor,
                                                                ionmodechem=str(i_jsonfile_content_dict['IONMODE']))

        file_hdl.write(str(ionmodechem_id)+",\n")
        # Getting the charge ID here from a query
        rc, charge_id = queryMsSQL.query_GetCharge_Id(cursor=cursor,
                                                      charge=i_jsonfile_content_dict['CHARGE'])
        #print("charge_id ---->: ", charge_id)
        file_hdl.write(str(charge_id)+",\n")
        # TODO: get the tool_id from a query

        rc, tool_id = queryMsSQL.query_GetTool_Id(cursor=cursor,
                                                  tool=i_jsonfile_content_dict['SOURCE_INSTRUMENT'])
        file_hdl.write(str(tool_id)+",\n")
        # TODO: get the database_id from query
        rc, database_id = queryMsSQL.query_GetDatabase_Id(cursor=cursor,
                                                          database=i_jsonfile_content_dict['database_name'])
        file_hdl.write(str(database_id)+",\n")
        # TODO: get the data_id from query
        json_file = os.path.basename(str(i_jsonfile_content_dict['molecule_json_filename']).strip())
        rc, data_id = queryMsSQL.query_GetData_from_JsonFile_Id(cursor=cursor, json_filename=json_file)
        file_hdl.write(str(data_id)+"\n")
        file_hdl.write(");\n")
        #-------------------------------------------------------------------
        # [MSG-Creator]
        #-------------------------------------------------------------------
        msg = ("insert into \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\"."+table+"(" +
               "spectral_data_id, feature_id, pepmass, mslevel, scan_number, retention_time,"
               " mol_json_file, num_peaks, peaks_list, ionmodechem_id, charge_id, tool_id, database_id, data_id)" +
               " VALUES " +
               "("+
               str(insertion_point)+", "+"'"+str(feature_id).strip()+"', "+str(pepmass)+", "+"'"+str(mslevel)+"'"+
               ", "+"'"+str(scan_number).strip()+"', "+"null"+", '"+str(mol_json_file).strip()+"'"+", " +
               str(num_peaks)+", "+"'"+peaks_list+"'"+", " +str(ionmodechem_id)+", " +str(charge_id)+
               ", "+str(tool_id)+", "+str(database_id)+""+", "+str(data_id)+
               ");"
        )
        rc = self.MolRefAnt_DB_POstGresSQLPusher(queryMsSQL=queryMsSQL, cursor=cursor, push_request=msg)
        #-------------------------------------------------------------------
        # [Measure]
        #-------------------------------------------------------------------
        rc, table_length = queryMsSQL.query_GetMeasure_ncount(cursor)
        rc = self.MolRefAnt_DB_POstGresSQLWritter_Measure(file_hdl, insertion_point,
                                                          queryMsSQL, cursor,
                                                          i_jsonfile_content_dict,
                                                          'measure', table_length)
        #-------------------------------------------------------------------
        # [Compound]
        #-------------------------------------------------------------------
        rc, tb_count = queryMsSQL.query_PostGreSQL_GetTableCount(cursor=cursor,
                                                                 database=self.c.getDatabase_name(),
                                                                 schema=self.c.getDatabase_schema(),
                                                                 table='ionisation_mode', silent=True)

        rc = self.MolRefAnt_DB_POstGresSQLWritter_Compound(file_hdl, insertion_point,
                                                           queryMsSQL, cursor,
                                                           i_jsonfile_content_dict,
                                                          'Compound', tb_count)
        #-------------------------------------------------------------------
        # [Done] done for this molecule
        #-------------------------------------------------------------------
        # Printing a breakline to distinguish from the different molecule insertion
        self.m.printLine()

        return rc
    #-------------------------------------------------------------------
    # [Compound]
    #-------------------------------------------------------------------
    def MolRefAnt_DB_POstGresSQLWritter_Compound(self, file_hdl, insertion_point,
                                                 queryMsSQL, cursor,
                                                 i_jsonfile_content_dict,
                                                 table, table_length):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        #-------------------------------------------------------------------
        # [SQL-file]
        #-------------------------------------------------------------------
        '''
        create table if not exists
        "MolRefAnt_DB_PostGreSQL"."MolRefAnt_DB".Compound(
        compound_id INT,
        compound_name TEXT,
        smiles VARCHAR(250),
        pubchem VARCHAR(250),
        molecular_formula VARCHAR(250),
        taxonomy TEXT,
        library_quality VARCHAR(250),
        spectral_data_id INT NOT NULL,
        PRIMARY KEY(compound_id),
        FOREIGN KEY(spectral_data_id) REFERENCES "MolRefAnt_DB_PostGreSQL"."MolRefAnt_DB".Spectral_data(spectral_data_id)
        );
        '''
        file_hdl.write("insert into\n")
        file_hdl.write("    \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\"."+table+"(\n")
        file_hdl.write("    compound_id,\n")                          # TODO: ---> Done
        file_hdl.write("    compound_name,\n")                        # TODO: ---> Done
        file_hdl.write("    smiles,\n")                               # TODO: ---> Done
        file_hdl.write("    pubchem,\n")                              # TODO: ---> Done
        file_hdl.write("    molecular_formula,\n")                    # TODO: ---> Done
        file_hdl.write("    taxonomy,\n")                             # TODO: ---> Done
        file_hdl.write("    library_quality,\n")                      # TODO: ---> Done
        file_hdl.write("    spectral_data_id)\n")                     # TODO: ---> Done
        file_hdl.write("VALUES (\n")
        file_hdl.write(str(insertion_point)+",\n")
        if str(i_jsonfile_content_dict['NAME']) != "":
            name = str(i_jsonfile_content_dict['NAME']).strip().replace(';','.')
            name = name.replace("'",'')
        else:
            name = ""
        file_hdl.write("'"+str(name)+"',\n")
        smiles = i_jsonfile_content_dict['SMILES']
        file_hdl.write("'"+str(smiles)+"',\n")

        if 'PUBCHEM' in i_jsonfile_content_dict.keys():
            pubchem = str(i_jsonfile_content_dict['PUBCHEM']).strip()
        if 'PUBMED'  in i_jsonfile_content_dict.keys():
            pubchem = str(i_jsonfile_content_dict['PUBMED']).strip()
        file_hdl.write("'"+str(pubchem)+"',\n")

        if 'FORMULA' in i_jsonfile_content_dict.keys():
            molecular_formula = str(i_jsonfile_content_dict['FORMULA']).strip()
            file_hdl.write("'"+str(molecular_formula)+",\n")
        else:
            molecular_formula = 'null'
            file_hdl.write("null,\n")

        if 'TAXONOMY' in i_jsonfile_content_dict.keys():
            taxonomy =  i_jsonfile_content_dict['TAXONOMY']
            file_hdl.write("'"+taxonomy+"',\n")
        else:
            taxonomy = 'null'
            file_hdl.write("null,\n")

        LIBRARY_QUALITY_key = "LIBRARY_QUALITY"
        if LIBRARY_QUALITY_key in i_jsonfile_content_dict.keys():
            library_quality = str(i_jsonfile_content_dict[LIBRARY_QUALITY_key]).strip()
        else:

            if str(i_jsonfile_content_dict['NAME']).strip() != "":
                library_quality = str(i_jsonfile_content_dict['NAME']).strip().split('level')[1].replace(')','')
                library_quality = "#LEVEL "+str(library_quality)
            elif 'level' not in str(i_jsonfile_content_dict['NAME']).strip():
                library_quality = "#LEVEL ***"
            else:
                library_quality = "#LEVEL ***"

        file_hdl.write("'"+str(library_quality).strip()+"',\n")
        json_file = str(i_jsonfile_content_dict['molecule_json_filename'])
        rc, spectral_data_id = queryMsSQL.query_GetSpectral_data_from_JsonFile_Id(cursor=cursor, json_filename=json_file)
        file_hdl.write(str(spectral_data_id)+"\n")
        file_hdl.write(");\n")
        #-------------------------------------------------------------------
        # [MSG-Creator]
        #-------------------------------------------------------------------
        msg = ("insert into \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\"."+table+"(" +
               "compound_id, compound_name, smiles, pubchem, molecular_formula, taxonomy, library_quality, spectral_data_id)" +
               " VALUES " +
               "("+str(insertion_point)+", "+"'"+str(name)+"'"+", "+"'"+str(smiles)+"'"+", "+"'"+str(pubchem)+"'"+", "+
               "'"+str(molecular_formula)+"'"+", "+"'"+str(taxonomy)+"'"+", "+"'"+str(library_quality)+"'"+
               ", "+str(spectral_data_id)+
               ");")

        rc = self.MolRefAnt_DB_POstGresSQLPusher(queryMsSQL=queryMsSQL, cursor=cursor, push_request=msg)

        return rc
    #-------------------------------------------------------------------
    # [Measure]
    #-------------------------------------------------------------------
    def MolRefAnt_DB_POstGresSQLWritter_Measure(self, file_hdl, insertion_point,
                                                queryMsSQL, cursor,
                                                i_jsonfile_content_dict,
                                                table, table_length):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        # Get the spectral_data_id
        mol_file = str(i_jsonfile_content_dict['molecule_json_filename']).strip()
        rc, spectral_data_id = queryMsSQL.query_GetSpectral_data_Id(cursor=cursor, molecule_json_filename=mol_file)
        cnt_mz_value = 1

        for key, value in i_jsonfile_content_dict.items():
            if key.startswith('mz rel:'):
                mz_value = value[0]
                relative = value[1]
                '''
                create table if not exists
                "MolRefAnt_DB_PostGreSQL"."MolRefAnt_DB".Measure(
                    measure_id INT,
                    mz_value DECIMAL(15,2),
                    relative DECIMAL(15,2),
                    spectral_data_id INT NOT NULL,
                    PRIMARY KEY(measure_id),
                    FOREIGN KEY(spectral_data_id) REFERENCES "MolRefAnt_DB_PostGreSQL"."MolRefAnt_DB".Spectral_data(spectral_data_id)
                );
                '''
                mol_num = str(i_jsonfile_content_dict['mol_num']).strip()
                msg_print = self.c.getBlue()+"m/z: "+self.c.getYellow()+str(mz_value)+self.c.getBlue()+", Relative: "+self.c.getCyan()+str(relative)
                self.m.printMesgAddStr(" spectra values Molecule("+self.c.getGreen()+str(mol_num)+self.c.getBlue()+")           --->: ", self.c.getGreen(), msg_print)
                #-------------------------------------------------------------------
                # [MSG-Creator]
                #-------------------------------------------------------------------
                measure_id = cnt_mz_value + int(table_length)
                msg = ("insert into \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\"."+table+"(" +
                       "measure_id, mz_value, relative, spectral_data_id)" +
                       " VALUES " +
                       "("+str(measure_id)+", "+str(mz_value).strip()+", "+str(relative)+", "+str(spectral_data_id)+
                       ");")

                rc = self.MolRefAnt_DB_POstGresSQLPusher(queryMsSQL=queryMsSQL, cursor=cursor, push_request=msg)
                #-------------------------------------------------------------------
                # [Incrementing] the counter
                #-------------------------------------------------------------------
                cnt_mz_value += 1
            # [end-If} if key.startswith('mz rel:'):
        # [end-loop] for key, value in i_jsonfile_content_dict.items():
        return rc

    def MolRefAnt_DB_POstGresSQLWritter_Data(self, file_hdl, insertion_point,
                                             queryMsSQL, cursor,
                                             i_jsonfile_content_dict,
                                             table, table_length):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        if self.c.getDebug() == 1:
            print("table_length before get_TableCount_FromTable datetable +---> ", table_length)

        json_file = os.path.basename(str(i_jsonfile_content_dict['molecule_json_filename']))
        rc, experiment_id = queryMsSQL.query_GetExperiment_from_Expermenting_Id(cursor=cursor,
                                                                                analytics_data_id=insertion_point)
        rc, data_id = queryMsSQL.query_GetData_from_JsonFile_Id(cursor=cursor,
                                                                json_filename=json_file)
        if self.c.getDebug() == 1:
            print(" json_file +--->: ", json_file)
            print(" experiement_id +--->: ", experiment_id)
            print(" data_id +--->: ", data_id)
            print(" path_to_data +--->: ", self.c.getPool_Targetdir())

        if data_id == 0:

            '''create table if not exists
               "MolRefAnt_DB_PostGreSQL"."MolRefAnt_DB".Data(
               data_id INT,
               path_to_data VARCHAR(150),
               raw_file VARCHAR(60),
               csv_file VARCHAR(60),
               xls_file VARCHAR(60),
               asc_file VARCHAR(60),
               mgf_file VARCHAR(50),
               m2s_file VARCHAR(50),
               json_file VARCHAR(50),
               experiment_id INT NOT NULL,
               PRIMARY KEY(data_id),
               FOREIGN KEY(experiment_id) REFERENCES "MolRefAnt_DB_PostGreSQL"."MolRefAnt_DB".Experiment(experiment_id)
               );
            '''
            #-------------------------------------------------------------------
            # [file-Creator]
            #-------------------------------------------------------------------
            file_hdl.write("insert into\n")
            file_hdl.write("    \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\"."+table+"(\n")
            file_hdl.write("    data_id,\n")                 # TODO: ---> Done
            file_hdl.write("    path_to_data,\n")            # TODO: ---> Done
            file_hdl.write("    raw_file,\n")                # TODO: ---> Done
            file_hdl.write("    csv_file,\n")                # TODO: ---> Done
            file_hdl.write("    xls_file,\n")                # TODO: ---> Done
            file_hdl.write("    asc_file,\n")                # TODO: ---> Done
            file_hdl.write("    mgf_file,\n")                # TODO: ---> Done
            file_hdl.write("    m2s_file,\n")                # TODO: ---> Done
            file_hdl.write("    json_file,\n")               # TODO: ---> Done
            file_hdl.write("    experiment_id)\n")      # TODO: ---> Done
            file_hdl.write("VALUES (\n")
            file_hdl.write(str(insertion_point)+",\n")
            file_hdl.write("'"+str(self.c.getPool_Targetdir()).strip()+"',\n")
            file_hdl.write("null,\n")
            file_hdl.write("null,\n")
            file_hdl.write("null,\n")
            file_hdl.write("null,\n")
            file_hdl.write("null,\n")
            file_hdl.write("null,\n")
            file_hdl.write("'"+str(json_file)+"',\n")
            file_hdl.write(str(experiment_id)+"\n")
            file_hdl.write(");\n")
            # inserting a line for clarity
            file_hdl.write("\n")
            #-------------------------------------------------------------------
            # [MSG-Creator]
            #-------------------------------------------------------------------
            msg = ("insert into \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\"."+table+"(" +
                   "data_id, path_to_data, raw_file, csv_file, xls_file, asc_file, mgf_file, m2s_file, json_file, experiment_id)" +
                   " VALUES " +
                   "("+str(insertion_point)+","+"'"+str(self.c.getPool_Targetdir()).strip()+"', "+"null"+", " +
                   ""+"null"+", "+"null"+", " +"null"+", " +"null"+", "+"null"+", '"+str(json_file)+"'"+", "+str(experiment_id)+
                   ");")

            rc = self.MolRefAnt_DB_POstGresSQLPusher(queryMsSQL=queryMsSQL, cursor=cursor, push_request=msg)

        return rc

    def MolRefAnt_DB_POstGresSQLWritter_Datetable(self, file_hdl, insertion_point,
                                                  queryMsSQL, cursor,
                                                  i_jsonfile_content_dict,
                                                  table, table_length):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        if self.c.getDebug() == 1:
            print("table_length before get_TableCount_FromTable datetable +---> ", table_length)

        msg = str(i_jsonfile_content_dict['molecule_json_filename'])
        #print(msg)
        filename_timestamp = time.ctime(os.path.getctime(msg))

        rc, date_id = queryMsSQL.query_GetDate_Id(cursor=cursor, timestamp=filename_timestamp)
        if self.c.getDebug() == 1:
            print("table_length Datetable date_id +---> ", date_id)
        if date_id == 0:
            # TODO: need to fix the analytics_data_id on the second program call
            rc, analytics_data_file_id = queryMsSQL.query_GetAnalytics_data_Id(cursor=cursor,
                                                                               molecule_json_filename=i_jsonfile_content_dict['molecule_json_filename'])

            if self.c.getDebug() == 1:
                print("table_length Datetable analytics_data_id +---> ", analytics_data_file_id)
            if analytics_data_file_id != 0:
                #insertion_point = table_length + 1
                if self.c.getDebug() == 1:
                    print("table_length Datetable insertion_point +---> ", insertion_point)
                file_hdl.write("insert into\n")
                file_hdl.write("    \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\"."+table+"(\n")
                file_hdl.write("    date_id,\n")                        # TODO: ---> Done
                file_hdl.write("    date_column,\n")                    # TODO: ---> Done
                file_hdl.write("    time_column,\n")                    # TODO: ---> Done
                file_hdl.write("    timestamp_with_tz_column,\n")       # TODO: ---> Done
                file_hdl.write("    analytics_data_id)\n")              # TODO: ---> Done
                file_hdl.write("VALUES (\n")
                file_hdl.write(str(insertion_point)+",\n")
                date_column = str(i_jsonfile_content_dict['json_creation_timestamp']).split('_')[0]
                file_hdl.write("'"+date_column+"',\n")
                time_column = str(i_jsonfile_content_dict['json_creation_timestamp']).split('_')[1]
                file_hdl.write("'"+time_column+"',\n")
                time_stamp = str(i_jsonfile_content_dict['json_creation_timestamp'])
                file_hdl.write("'"+time_stamp+"',\n")
                if analytics_data_file_id == 0:
                    file_hdl.write(str(1)+"\n")
                else:
                    file_hdl.write(str(analytics_data_file_id)+"\n")
                file_hdl.write(");\n")
                # inserting a line for clarity
                file_hdl.write("\n")
                #-------------------------------------------------------------------
                # [MSG-Creator]
                #-------------------------------------------------------------------
                msg = ("insert into \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\"."+table+"(" +
                       "date_id, date_column, time_column, timestamp_with_tz_column, analytics_data_id)" +
                       " VALUES " +
                       "("+str(insertion_point)+","+"'"+date_column+"', "+"'"+time_column+"', "+
                       "'"+time_stamp+"', " +
                       "'"+str(analytics_data_file_id)+"'"+");")
                # Pushing to database
                rc = self.MolRefAnt_DB_POstGresSQLPusher(queryMsSQL=queryMsSQL, cursor=cursor, push_request=msg)
            # [end-if] if analytics_data_id == 0:
        # [end-if] if date_id == 0:

        return rc

    def MolRefAnt_DB_POstGresSQLWritter_Experiment(self, file_hdl, insertion_point,
                                                   queryMsSQL, cursor,
                                                   i_jsonfile_content_dict,
                                                   table, table_length):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        if self.c.getDebug():
            print("table_length Experiment +---> ", table_length)
        #-------------------------------------------------------------------
        # [Experiment]
        #-------------------------------------------------------------------
        '''
        create table if not exists Experiment(
             experiment_id INT,
             scan_id INT,
             ionisation_mode_id INT NOT NULL,
             PRIMARY KEY(experiment_id),
             FOREIGN KEY(ionisation_mode_id) REFERENCES Ionisation_mode(ionisation_mode_id)
        );
        '''
        rc, analytics_data_file_id = queryMsSQL.query_GetAnalytics_data_Id(cursor=cursor, molecule_json_filename=i_jsonfile_content_dict['molecule_json_filename'])
        rc, number_scans = queryMsSQL.query_GetAnalytics_data_number_scans(cursor=cursor, molecule_json_filename=i_jsonfile_content_dict['molecule_json_filename'])
        def get_positivity():
            ionisation_mode = "some ion mode"
            #tail = str(i_jsonfile_content_dict['IONMODE']).split(']')[1]
            if str(i_jsonfile_content_dict['IONMODE']) == "":
                tail = str(i_jsonfile_content_dict['IONMODE'])
            else:
                tail = str(i_jsonfile_content_dict['IONMODE'])[len(i_jsonfile_content_dict['IONMODE'])-1]

            if self.c.getDebug() == 1:
                print("tail +---->: ", tail)

            match tail:
                case "-": ionisation_mode = "Negative"
                case "": ionisation_mode = "Neutral"
                case "+": ionisation_mode = "Positive"
                case "]": ionisation_mode = "Unknown"
                case _: ionisation_mode = "N/A"
            return ionisation_mode
        # [end-def]

        # Get the ionisation_mode_id from str(i_jsonfile_content_dict['IONMODE'])
        if str(i_jsonfile_content_dict['IONMODE']).capitalize() == "Negative":
            rc, ionisation_mode_id = queryMsSQL.query_GetIonisation_mode_Id(cursor=cursor, ionisation_mode=str(i_jsonfile_content_dict['IONMODE']).capitalize())
        elif str(i_jsonfile_content_dict['IONMODE']).capitalize() == "Positive":
            rc, ionisation_mode_id = queryMsSQL.query_GetIonisation_mode_Id(cursor=cursor, ionisation_mode=str(i_jsonfile_content_dict['IONMODE']).capitalize())
        elif str(i_jsonfile_content_dict['IONMODE']).upper() == "N/A":
            rc, ionisation_mode_id = queryMsSQL.query_GetIonisation_mode_Id(cursor=cursor, ionisation_mode=str(i_jsonfile_content_dict['IONMODE']).upper())
        elif str(i_jsonfile_content_dict['IONMODE']).capitalize() == "Unknown":
            rc, ionisation_mode_id = queryMsSQL.query_GetIonisation_mode_Id(cursor=cursor, ionisation_mode=str(i_jsonfile_content_dict['IONMODE']).capitalize())
        else:
            rc, ionisation_mode_id = queryMsSQL.query_GetIonisation_mode_Id(cursor=cursor, ionisation_mode=get_positivity())
        # [end-if] statement
        rc, experiment_id = queryMsSQL.query_GetExperiment_Id(cursor=cursor, ionisation_mode_id=ionisation_mode_id)

        if self.c.getDebug() == 1:
            # TODO: replace with the proper message printers in self.m
            print(" return value +--->: analytics_data_id", analytics_data_file_id)
            print(" return value +--->: number_scans", number_scans)
            print("i_jsonfile_content_dict['IONMODE'] +--->: ", i_jsonfile_content_dict['IONMODE'])
            print(" ionisation_mode +---->: ", get_positivity())
            print(" ionisation_mode_id +---->: ", ionisation_mode_id)
            print()

        if analytics_data_file_id != 0:
            #insertion_point = table_length + 1
            file_hdl.write("insert into\n")
            file_hdl.write("    \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\"."+table+"(\n")
            file_hdl.write("    experiment_id,\n")                 # TODO: ---> Done
            file_hdl.write("    scan_id,\n")                       # TODO: ---> Done
            file_hdl.write("    ionisation_mode_id)\n")            # TODO: ---> Done
            file_hdl.write("VALUES (\n")
            file_hdl.write(str(insertion_point)+",\n")
            file_hdl.write("\'"+str(number_scans)+"\',\n")
            file_hdl.write("'"+str(ionisation_mode_id)+"'\n")
            file_hdl.write(");\n")
            # inserting a line for clarity
            file_hdl.write("\n")
            #-------------------------------------------------------------------
            # [MSG-Creator]
            #-------------------------------------------------------------------
            msg = ("insert into \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\"."+table+"(" +
                   "experiment_id, scan_id, ionisation_mode_id)" +
                   " VALUES " +
                   "("+str(insertion_point)+", "+str(number_scans)+", "+str(ionisation_mode_id)+");")

            rc = self.MolRefAnt_DB_POstGresSQLPusher(queryMsSQL=queryMsSQL, cursor=cursor, push_request=msg)
            #-------------------------------------------------------------------
            # [Experimenting]
            #-------------------------------------------------------------------
            '''
            create table if not exists Experimenting(
            experiment_id INT,
            analytics_data_id INT,
            PRIMARY KEY(experiment_id, analytics_data_id),
            FOREIGN KEY(experiment_id) REFERENCES Experiment(experiment_id),
            FOREIGN KEY(analytics_data_id) REFERENCES Analytics_data(analytics_data_id)
            );
            '''
            #insertion_point = table_length + 1
            file_hdl.write("insert into\n")
            file_hdl.write("    \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\"."+"Experimenting"+"(\n")
            file_hdl.write("    experiment_id,\n")                 # TODO: ---> Done
            file_hdl.write("    analytics_data_id)\n")                          # TODO: ---> Done
            file_hdl.write("VALUES (\n")
            file_hdl.write(str(insertion_point)+",\n")
            file_hdl.write("'"+str(analytics_data_file_id)+"'\n")
            file_hdl.write(");\n")
            # inserting a line for clarity
            file_hdl.write("\n")
            #-------------------------------------------------------------------
            # [MSG-Creator]
            #-------------------------------------------------------------------
            msg = ("insert into \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\"."+"Experimenting"+"(" +
                   "experiment_id, analytics_data_id)" +
                   " VALUES " +
                   "("+str(insertion_point)+", "+str(analytics_data_file_id)+");")

            rc = self.MolRefAnt_DB_POstGresSQLPusher(queryMsSQL=queryMsSQL, cursor=cursor, push_request=msg)
            #-------------------------------------------------------------------
            # [Analysing]
            #-------------------------------------------------------------------
            rc, tool_id = queryMsSQL.query_GetTool_Id(cursor=cursor, tool=i_jsonfile_content_dict['SOURCE_INSTRUMENT'])
            msg = ("insert into \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\"."+"Analysing"+"(" +
                   "tool_id, analytics_data_id)" +
                   " VALUES " +
                   "("+str(tool_id)+", "+str(insertion_point)+");")

            rc = self.MolRefAnt_DB_POstGresSQLPusher(queryMsSQL=queryMsSQL, cursor=cursor, push_request=msg)

        return rc

    def MolRefAnt_DB_POstGresSQLWritter_Platform_user(self, file_hdl,
                                                      queryMsSQL, cursor,
                                                      i_jsonfile_content_dict,
                                                      database, table, table_length):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()

        rc, pi_name_id = queryMsSQL.query_GetPlatform_user_Id(cursor=cursor,name=i_jsonfile_content_dict['PI'])
        if pi_name_id == 0:
            insertion_point = table_length + 1
            # TODO: finish the logic of the insertor
            #print("str(i_jsonfile_content_dict['PI']) ---> ", str(i_jsonfile_content_dict['PI']))
            file_hdl.write("insert into\n")
            file_hdl.write("    \""+database+"\".\""+self.c.getDatabase_schema()+"\"."+table+"(\n")
            file_hdl.write("    platform_user_id,\n")        # TODO: ---> Done
            file_hdl.write("    firstname,\n")               # TODO:
            file_hdl.write("    lastname,\n")                # TODO:
            file_hdl.write("    name,\n")                    # TODO:
            file_hdl.write("    affiliation,\n")             # TODO:
            file_hdl.write("    phone,\n")                   # TODO:
            file_hdl.write("    email)\n")                   # TODO:
            file_hdl.write("VALUES (\n")
            file_hdl.write(str(insertion_point)+",\n")
            if i_jsonfile_content_dict['PI'] != "***":
                file_hdl.write("'"+str(i_jsonfile_content_dict['PI']).split(' ')[0]+"',\n")
                file_hdl.write("'"+str(i_jsonfile_content_dict['PI']).split(' ')[1]+"',\n")
            elif i_jsonfile_content_dict['PI'] == "***":
                file_hdl.write("'"+str(i_jsonfile_content_dict['PI'])+"',\n")
                file_hdl.write("'"+str(i_jsonfile_content_dict['PI'])+"',\n")
            file_hdl.write("'"+str(i_jsonfile_content_dict['PI'])+"',\n")
            file_hdl.write("'"+str(i_jsonfile_content_dict['SOURCE_INSTRUMENT'])+"',\n")
            file_hdl.write("null,\n")
            file_hdl.write("null\n")
            file_hdl.write(");\n")

        # Now for the data colector entry
        rc, datacollector_id = queryMsSQL.query_GetPlatform_user_Id(cursor=cursor, name=i_jsonfile_content_dict['DATACOLLECTOR'])
        if datacollector_id == 0:
            insertion_point = table_length + 1
            # TODO: finish the logic of the insertor
            #print("str(i_jsonfile_content_dict['DATACOLLECTOR']) ---> ", str(i_jsonfile_content_dict['DATACOLLECTOR']))
            file_hdl.write("insert into\n")
            file_hdl.write("    \""+database+"\".\""+self.c.getDatabase_schema()+"\"."+table+"(\n")
            file_hdl.write("    platform_user_id,\n")        # TODO: ---> Done
            file_hdl.write("    firstname,\n")               # TODO:
            file_hdl.write("    lastname,\n")                # TODO:
            file_hdl.write("    name,\n")                    # TODO:
            file_hdl.write("    affiliation,\n")             # TODO:
            file_hdl.write("    phone,\n")                   # TODO:
            file_hdl.write("    email)\n")                   # TODO:
            file_hdl.write("VALUES (\n")
            file_hdl.write(str(insertion_point)+",\n")
            if i_jsonfile_content_dict['DATACOLLECTOR'] != "***":
                file_hdl.write("'"+str(i_jsonfile_content_dict['DATACOLLECTOR']).split(' ')[0]+"',\n")
                file_hdl.write("'"+str(i_jsonfile_content_dict['DATACOLLECTOR']).split(' ')[1]+"',\n")
            elif i_jsonfile_content_dict['DATACOLLECTOR'] == "***":
                file_hdl.write("'"+str(i_jsonfile_content_dict['DATACOLLECTOR'])+"',\n")
                file_hdl.write("'"+str(i_jsonfile_content_dict['DATACOLLECTOR'])+"',\n")
            file_hdl.write("'"+str(i_jsonfile_content_dict['DATACOLLECTOR'])+"',\n")
            file_hdl.write("'"+str(i_jsonfile_content_dict['SOURCE_INSTRUMENT'])+"',\n")
            file_hdl.write("null,\n")
            file_hdl.write("null\n")
            file_hdl.write(");\n")
            # inserting a line for clarity
            file_hdl.write("\n")

        return rc


    def ctfSSQLWritter(self, file_hdl, i_jsonfile_content, database, table, table_length):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        # ----------------------------------------------------------------------
        # First create an empty row
        # ----------------------------------------------------------------------
        #table_legnth = 59
        start_CTFDetailsINDX = table_length - 1 # this make sure of c++ format
        insertion_point = start_CTFDetailsINDX + int(i_jsonfile_content[0])
        file_hdl.write("USE ["+database+"]\n")
        file_hdl.write("GO\n")
        file_hdl.write("\n")
        file_hdl.write("INSERT INTO [dbo].["+table+"]\n")
        file_hdl.write("(CTFDetailsINDX, CTFDetailsID, ProjectsNameID, ProjectNumber, MicrographNumber, Defocus1, Defocus2, Astigmatism, PhaseShift,\n")
        file_hdl.write("CrossCorrelation, Spacing, Frame, DataMRC, DataJPG, DataXML, CTF_SumCor2Live_mrc, CTF_SumCor2Live_txt, CTF_SumCor2DiagAvrLive_png,\n")
        file_hdl.write("CTF_SumCor2DiagAvrLive_txt, CTF_SumCor2DiagCTFLive_png\n")
        file_hdl.write(")\n")
        file_hdl.write("VALUES\n")
        file_hdl.write("("+str(insertion_point)+", NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)\n")
        file_hdl.write(";\n")
        # ----------------------------------------------------------------------
        # Updating the row tha has just been created
        # ----------------------------------------------------------------------
        file_hdl.write("\n")
        file_hdl.write("\n")
        file_hdl.write("USE ["+database+"]\n")
        file_hdl.write("GO\n")
        file_hdl.write("\n")
        file_hdl.write("UPDATE [dbo].["+table+"]\n")
        file_hdl.write("SET\n")
        file_hdl.write("[CTFDetailsINDX] = "+str(insertion_point)+",\n")#3,
        file_hdl.write("[CTFDetailsID] = "+str(i_jsonfile_content[0])+",\n")#3,
        file_hdl.write("[ProjectsNameID] = N'"+self.ProjectsNameID+"',\n")#20210401
        file_hdl.write("[ProjectNumber] = N'"+self.ProjectNumber+"',\n")#2101-278
        # ----------------------------------------------------------------------
        # CTF VAlues
        # ----------------------------------------------------------------------
        # Output from CTFFind version 4.1.8, run on 2021-05-28 22:21:19
        # Input file: ././MotionCorr2_mrc/FoilHole_352185_Data_351988_351990_20210401_161307_fractions_SumCor2.mrc ; Number of micrographs: 1
        # Pixel size: 1.097 Angstroms ; acceleration voltage: 300.0 keV ; spherical aberration: 2.70 mm ; amplitude contrast: 0.07
        # Box size: 512 pixels ; min. res.: 18.0 Angstroms ; max. res.: 4.0 Angstroms ; min. def.: 3100.0 um; max. def. 6900.0 um
        # Columns:
        # #1 - micrograph number;
        # #2 - defocus 1 [Angstroms];
        # #3 - defocus 2;
        # #4 - azimuth of astigmatism;
        # #5 - additional phase shift [radians];
        # #6 - cross correlation;
        # #7 - spacing (in Angstroms) up to which CTF rings were fit successfully
        #1.000000 5779.293457 5638.637207 27.500006 0.000000 -0.115308 6.642923
        ctf_values_lst = i_jsonfile_content[1].split(',')
        file_hdl.write("[MicrographNumber] = "+str(ctf_values_lst[0])+",\n")
        file_hdl.write("[Defocus1] = "+str(ctf_values_lst[1])+",\n")
        file_hdl.write("[Defocus2] = "   +str(ctf_values_lst[2])+",\n")
        file_hdl.write("[Astigmatism] = "    +str(ctf_values_lst[3])+",\n")
        file_hdl.write("[PhaseShift] = " + str(ctf_values_lst[4].strip()) + ",\n")
        file_hdl.write("[CrossCorrelation] = " + str(ctf_values_lst[5].strip()) + ",\n")
        if (str(ctf_values_lst[6].strip()) == "inf"):
            file_hdl.write("[Spacing] = " + "NULL" + ",\n")
        else:
            file_hdl.write("[Spacing] = " + str(ctf_values_lst[6]) + ",\n")
        # ----------------------------------------------------------------------
        # Files Entries
        # ----------------------------------------------------------------------
        file_hdl.write("[Frame] = N'"                     +str(i_jsonfile_content[2 ])+"',\n")#FoilHole_o_Data_ppp_fractions.mrc',
        file_hdl.write("[DataMRC] = N'"                   +str(i_jsonfile_content[3 ])+"',\n")#FoilHole_o_Data_jjj.mrc',
        file_hdl.write("[DataJPG] = N'"                   +str("")                    +"',\n")#FoilHole_o_Data_jjj.jpg',
        file_hdl.write("[DataXML] = N'"                   +str("")                    +"',\n")#FoilHole_o_Data_jjj.xml',
        file_hdl.write("[CTF_SumCor2Live_mrc] = N'"       +str(i_jsonfile_content[10])+"',\n")#CTFFind_mrc/FoilHole_o_Data_ppp_fractions_SumCor2_diag.mrc',
        file_hdl.write("[CTF_SumCor2Live_txt] = N'"       +str(i_jsonfile_content[11])+"',\n")#CTFFind_txt/FoilHole_o_Data_ppp_fractions_SumCor2_diag.txt',
        file_hdl.write("[CTF_SumCor2DiagAvrLive_png] = N'"+str(i_jsonfile_content[12])+"',\n")#CTFFind_png/FoilHole_o_Data_ppp_fractions_SumCor2_diag_avrot.png',
        file_hdl.write("[CTF_SumCor2DiagAvrLive_txt] = N'"+str(i_jsonfile_content[13])+"',\n")#CTFFind_avr/FoilHole_o_Data_ppp_fractions_SumCor2_diag_avrot.txt',
        file_hdl.write("[CTF_SumCor2DiagCTFLive_png] = N'"+str(i_jsonfile_content[14])+"' \n")#CTFFind_fit/FoilHole_o_Data_ppp_fractions_SumCor2_diag_CTF_fit_Graph.png'
        file_hdl.write("WHERE\n")
        file_hdl.write("CTFDetailsINDX = "+str(insertion_point)+"\n")  #3
        file_hdl.write("GO\n")
        # ----------------------------------------------------------------------
        # Debugging and checking code
        # ----------------------------------------------------------------------
        # file_hdl.write("\n")
        # file_hdl.write(str(i_jsonfile_content)+"\n")
        return rc
    #---------------------------------------------------------------------------
    # [SQL-Pushers]
    #---------------------------------------------------------------------------
    def MolRefAnt_DB_POstGresSQLPusher(self, queryMsSQL, cursor, push_request):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        # inserting time stamp to keep track of the querries
        rc,time_stamp = self.m.get_local_current_Time(self.c)
        # Printing to screen the querry before executing it.
        self.m.printMesg("Query"+self.c.getMagenta()+str(time_stamp)+self.c.getBlue()+ \
                         " ---> "+self.c.getCyan()+__func__+ \
                         self.c.getBlue()+" --->: "+self.c.getYellow()+push_request )
        cursor.execute(push_request)
        queryMsSQL.cnxn.commit()
        return rc
    #---------------------------------------------------------------------------
    # [Bat-Writters]
    #---------------------------------------------------------------------------
    def SQLBatPusher(self, server, sqlFileList, sql_dir, bat_file):
        __func__ = sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()

        sql_fullPath_dir = self.pool_targetdir + os.path.sep + sql_dir
        self.m.printMesg("Project Details in question...")
        self.m.printMesgAddStr(" ProjectName      : ",
                               self.c.getCyan(), str(self.projectName))
        self.m.printMesgAddStr(" ProjectsNameID   : ",
                               self.c.getYellow(), str(self.ProjectsNameID))
        self.m.printMesgAddStr(" ProjectNumber    : ",
                               self.c.getGreen(), str(self.ProjectNumber))
        self.m.printMesgAddStr(" SQL full path dir: ",
                               self.c.getMagenta(), sql_fullPath_dir)
        self.m.printMesgAddStr(" Server name      : ",
                               self.c.getYellow(), server)
        #-----------------------------------------------------------------------
        # Generating the zerolead for the sql file constriction
        #-----------------------------------------------------------------------
        rc, zerolead = self.generate_Zerolead(len(sqlFileList))
        #-----------------------------------------------------------------------
        # constructing the leading zeros according to nboot
        #-----------------------------------------------------------------------
        database = "NeCENDatabase-Prod"
        file_name = self.pool_targetdir + os.path.sep + sql_dir+os.path.sep+bat_file
        #os.chmod(file_name,777)
        file_bat = open(file_name, 'w')
        rc = self.ctfSQLBatWritter_header(file_bat, database, server)
        progressBar = src.PythonCodes.utils.progressBar.ProgressBar()#ProgressBar()
        for ifile in range(len(sqlFileList)):
            head, tail = os.path.split(sqlFileList[ifile])

            rc = self.ctfSQLBatWritter(file_bat, tail)

            progressBar.update(1, len(sqlFileList))
            progressBar.printEv()

        self.m.printLine()
        progressBar.resetprogressBar()
        file_bat.close()

        os.system('chmod a+x %s'%file_name)
        return rc

    def ctfSQLBatWritter(self, file_bat, i_sqlCTFFileList):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()

        file_bat.write("sqlcmd -S %SERVER% -i "+i_sqlCTFFileList+"\n")

        return rc

    def ctfSQLBatWritter_header(self, file_bat, database, server):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()

        file_bat.write("@echo off\n")
        file_bat.write("\n")
        file_bat.write("echo Launching the SQL pushing script...\n")
        file_bat.write("echo Moving the executable directory\n")
        file_bat.write("\n")
        file_bat.write("REM set DIR=\"C:\cygwin64\home\Frederic\Leiden\SourceCode\DataManage_project\SQL\MsSQL\DatabaseCode\Production-Scripts\"\n")
        file_bat.write("REM echo The current directory is %CD%\n")
        file_bat.write("\n")
        file_bat.write("set OUTPUT_FILE=\"sql_InsertUpdate_out.log\"\n")
        file_bat.write("set SERVER=\""+server+"\"\n")
        file_bat.write("set DB=\""+database+"\"\n")
        file_bat.write("set USER=\"quarky\"\n")
        file_bat.write("set PASSWORD=\"*********\"\n")
        file_bat.write("\n")

        return rc
    #---------------------------------------------------------------------------
    # [Generators]
    #---------------------------------------------------------------------------
    def generate_Zerolead(self, lst_len):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        #-----------------------------------------------------------------------
        # constructing the leading zeros according to nboot
        #-----------------------------------------------------------------------
        #counting the number of digits in lst_len
        import math
        if lst_len > 0:
            digits = int(math.log10(lst_len))+1
        elif lst_len == 0:
            digits = 1
        else:
            digits = int(math.log10(-lst_len))+2

        zerolead = numpy.power(10,digits)
        
        return rc, zerolead
    #---------------------------------------------------------------------------
    # [Reader]
    #---------------------------------------------------------------------------
    def getListOfJsonFiles_MsSQLLauncher(self, target_file):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        FileList = []

        rc, list_len, FileList = self.jsonLauncher.getListOfJsonFiles(target_file)
        
        return rc, list_len, FileList
    #---------------------------------------------------------------------------
    # [JSon-Interpreters]
    #---------------------------------------------------------------------------
    def ReadinJson_Molecules_File_MsSQLLauncher(self, filelist):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()

        jsonfile_content_key_lst = []
        jsonfile_content_value_lst = []
        jsonfile_content_dict_lst = []
        #print(len(filelist))
        rc, jsonfile_content_dict_lst, jsonfile_content_key_lst, jsonfile_content_value_lst = self.jsonLauncher.ReadingMoleculeJsonFile(filelist)

        #End of the try catch
        return rc, jsonfile_content_dict_lst[:], jsonfile_content_key_lst[:], jsonfile_content_value_lst[:]

    def ReadinJsonFile_MsSQLLauncher(self, filelist):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()

        jsonfile_content = []
        rc, jsonfile_content = self.jsonLauncher.ReadingCTFJsonFile(filelist)

        #End of the try catch
        return rc, jsonfile_content
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
# end of PoolCreator_Fileio module
#-------------------------------------------------------------------------------
