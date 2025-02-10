'''!\file
   -- LDMaP-APP addon: (Python3 code) to query the database
      \author Frederic Bonnet
      \date 20th of June 2021

      Leiden University June 2021

Name:
---
QueryMsSQL: module for quering a data base

Description of classes:
---
This class queries the data base.

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
import tqdm

import pyodbc
import psycopg2
# appending the utils path
sys.path.append(os.path.join(os.getcwd(), '.'))
sys.path.append(os.path.join(os.getcwd(), '..','..','..'))
sys.path.append(os.path.join(os.getcwd(), '..','..','..','utils'))
# application imports
import src.PythonCodes.DataManage_common
import src.PythonCodes.utils.StopWatch
import src.PythonCodes.SQL.MsSQL.sql_handlers.CredentialsMsSQL
# ------------------------------------------------------------------------------
# Class to read star file from Relion
# file_type can be 'mrc' or 'ccp4' or 'imod'.
# ------------------------------------------------------------------------------
# ******************************************************************************
##\brief Python3 method.
# Class to read star file from Relion
# file_type can be 'mrc' or 'ccp4' or 'imod'.
class QueryMsSQL:
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
        self.m.printMesgStr("Instantiating the class       :", self.c.getGreen(), "QueryMsSQL")
        self.app_root = self.c.getApp_root()        # app_root
        self.data_path = self.c.getData_path()      # data_path
        self.projectName = self.c.getProjectName()  # projectName
        self.targetdir = self.c.getTargetdir()      # targetdir
        self.software = self.c.getSoftware()        # software
        self.pool_componentdir = self.c.getPool_componentdir() # "_Pool or not"
        # Instantiating logfile mechanism
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

        self.m.printMesgAddStr(" app_root                  --->: ", self.c.getYellow(), self.c.getApp_root())
        self.m.printMesgAddStr(" data_path                 --->: ", self.c.getGreen(), str(self.data_path))
        self.m.printMesgAddStr(" projectName               --->: ", self.c.getGreen(), str(self.projectName))
        self.m.printMesgAddStr(" targetdir                 --->: ", self.c.getMagenta(), str(self.targetdir))
        self.m.printMesgAddStr(" Software                  --->: ", self.c.getRed(), str(self.software))
        self.m.printMesgAddStr(" Pool path                 --->: ", self.c.getBlue(), str(self.pool_targetdir))
        self.m.printMesgAddStr(" Pool targetdir            --->: ", self.c.getGreen(), self.c.getPool_Targetdir())
        #-----------------------------------------------------------------------
        # Setting up the file environment
        #-----------------------------------------------------------------------
        self.table_list = []
        self.full_table_list = []
        self.columNames_table_list = []
        self.rowth_lst = []
        #-----------------------------------------------------------------------
        # Instantiating the Credentials class CredentialsMsSQL to get methods
        #-----------------------------------------------------------------------
        self.credentialsMsSQL = src.PythonCodes.SQL.MsSQL.sql_handlers.CredentialsMsSQL.CredentialsMsSQL(c, m)
        self.server = self.credentialsMsSQL.server
        self.database = self.credentialsMsSQL.database
        self.username = self.credentialsMsSQL.username
        self.password = self.credentialsMsSQL.password
        # PostGerSQL
        self.server_PostGreSQL   = self.credentialsMsSQL.server_PostGreSQL
        self.database_PostGreSQL = self.credentialsMsSQL.database_PostGreSQL
        self.schema_PostGreSQL   = self.credentialsMsSQL.schema_PostGreSQL
        self.username_PostGreSQL = self.credentialsMsSQL.username_PostGreSQL
        self.password_PostGreSQL = self.credentialsMsSQL.password_PostGreSQL
        self.port_PostGreSQL     = self.credentialsMsSQL.port_PostGreSQL
        self.c.setDatabase_server(self.server_PostGreSQL)
        self.c.setDatabase_name(self.database_PostGreSQL)
        self.c.setDatabase_schema(self.schema_PostGreSQL)
        self.c.setDatabase_port(self.port_PostGreSQL)
        #-----------------------------------------------------------------------
        # Reporting time taken to instantiate and strip initial star file
        #-----------------------------------------------------------------------
        if c.getBench_cpu():
            src.PythonCodes.utils.StopWatch.StopTimer_secs(stopwatch)
            info = self.c.GetFrameInfo()
            self.m.printBenchMap("data_path",self.c.getRed(), self.data_path, info, __func__)
            self.m.printBenchTime_cpu("Read data_path file", self.c.getBlue(), stopwatch, info, __func__)
        #-----------------------------------------------------------------------
        # end of construtor __init__(self, path, file_type)
        #-----------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Methods] for the class
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Connector]
    #---------------------------------------------------------------------------
    def open_connection_database(self):
        rc = self.c.get_RC_SUCCESS()
        self.cnxn = pyodbc.connect('DRIVER={SQL Server};'
                                   'SERVER='+self.server+';'
                                   'DATABASE='+self.database+';'
                                   'UID='+self.username+';'
                                   'PWD='+ self.password+';'
                                   'Trusted_Connection=yes;')
        return rc, self.cnxn


    def open_connection_database_PostGreSQL(self):
        rc = self.c.get_RC_SUCCESS()
        self.cnxn = psycopg2.connect(
            database=self.database_PostGreSQL,  # "MolRefAnt_DB_PostGreSQL",
            user=self.username_PostGreSQL,
            password=self.password_PostGreSQL,
            host=self.server_PostGreSQL,
            port=self.port_PostGreSQL
        )

        return rc, self.cnxn
    #---------------------------------------------------------------------------
    # [Procedure-SQL]
    #---------------------------------------------------------------------------
    def procedure_Fill_IonisingTable(self, cursor, tool_id):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name

        msg = "do\n" + \
        "$$\n" + \
        "    declare\n" + \
        "        v_rec RECORD;\n" + \
        "        v_tool_id integer := "+str(tool_id)+";" + \
        "    begin\n" + \
        "        for v_rec in select * from \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".ionisation_mode\n" +\
        "            loop\n" + \
        "                /* raise notice '% %', v_tool_id, v_rec.ionisation_mode_id; */\n" + \
        "                insert into \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".ionising(tool_id, ionisation_mode_id)\n" + \
        "                VALUES (v_tool_id, v_rec.ionisation_mode_id);\n" + \
        "            end loop;\n" + \
        "    end\n" + \
        "$$;\n"

        return rc, msg
    #---------------------------------------------------------------------------
    # [Query-SQL]
    #---------------------------------------------------------------------------
    def query_GetDeepL_data(self, cursor, database):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        # Inserting timestamp into the insert message command
        rc,time_stamp = self.m.get_local_current_Time(self.c)
        '''
        select distinct
            S.spectral_data_id, S.pepmass, S.num_peaks, S.peaks_list, S.data_id,
            C.smiles,
            D.database_name,
            DD.path_to_data, DD.json_file,
            A.filename
        from "MolRefAnt_DB_PostGreSQL"."MolRefAnt_DB".spectral_data S
            join "MolRefAnt_DB_PostGreSQL"."MolRefAnt_DB".compound C on S.spectral_data_id = C.spectral_data_id
            join "MolRefAnt_DB_PostGreSQL"."MolRefAnt_DB".database_details D on S.database_id = D.database_id
            join "MolRefAnt_DB_PostGreSQL"."MolRefAnt_DB".datetable T on T.date_id = S.data_id
            join "MolRefAnt_DB_PostGreSQL"."MolRefAnt_DB".data DD on DD.data_id = S.data_id
            join "MolRefAnt_DB_PostGreSQL"."MolRefAnt_DB".analytics_data A on T.analytics_data_id = A.analytics_data_id
        where D.database_name='Bacterial_metabolites_database' and S.pepmass!=999.9999;
        '''
        msg = "select distinct \n"+ \
                "     S.spectral_data_id, S.pepmass, S.num_peaks, S.peaks_list, S.data_id, \n" + \
                "      C.smiles,  C.compound_name,\n" +\
                "      D.database_name, \n" + \
                "      DD.path_to_data, DD.json_file, \n" + \
                "      A.filename \n" + \
                "from \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".spectral_data S \n" + \
                "    join \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".compound C on S.spectral_data_id = C.spectral_data_id \n" + \
                "    join \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".database_details D on S.database_id = D.database_id \n" + \
                "    join \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".datetable T on T.date_id = S.data_id \n" + \
                "    join \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".data DD on DD.data_id = S.data_id \n" + \
                "    join \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".analytics_data A on T.analytics_data_id = A.analytics_data_id \n" + \
                "    where D.database_name=\'"+str(database)+"\' and S.pepmass!=999.9999;"

        self.m.printMesg("Query"+self.c.getMagenta()+str(time_stamp)+self.c.getBlue()+ \
                         " ---> "+self.c.getCyan()+__func__+ \
                         self.c.getBlue()+" --->: \n"+self.c.getYellow()+msg )

        # TODO: insert the code for the cursor
        cursor.execute(msg)
        row_lst = []
        for row in cursor: row_lst.append(row)
        # [end-loop]

        # Builing the key list based on the query above
        key_lst = ['spectral_data_id', 'pepmass', 'num_peaks', 'peaks_list', 'data_id',
                   'smiles', 'compound_name',
                   'database_name',
                   'path_to_data', 'json_file',
                   'filename']

        # Building the list of dictionary based on the querry.
        deepL_data_lst = []
        cnt = 0
        for i in range(len(row_lst)):
            ith_deepL_data_dic = {}
            #print(" row --->: ", row_lst[i])
            for j in range(len(row_lst[i][:])):
                ith_deepL_data_dic[key_lst[j]] = row_lst[i][j]
                #print(" row["+str(i)+"] --->: ", row[i])
            # [end-lloop] end loop over row for dictionary
            deepL_data_lst.append(ith_deepL_data_dic)
        # end loop over the rows of cursor
        cnt += 1

        return rc, deepL_data_lst

    def query_GetMeasure_ncount(self, cursor):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        msg = "select count(*) from \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".measure;"
        #print(msg)
        cursor.execute(msg)
        measure_ncount = 0
        cnt = 0
        for row in cursor:
            measure_ncount = row[0]
        cnt += 1

        return rc, measure_ncount

    def query_GetMeasure_ncount(self, cursor):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        msg = "select count(*) from \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".measure;"
        #print(msg)
        cursor.execute(msg)
        measure_ncount = 0
        cnt = 0
        for row in cursor:
            measure_ncount = row[0]
        cnt += 1

        return rc, measure_ncount

    def query_GetSpectral_data_Id(self, cursor, molecule_json_filename):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        msg = "select spectral_data_id from \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".spectral_data where mol_json_file='"+str(molecule_json_filename)+"';"
        #print(msg)
        cursor.execute(msg)
        spectral_data_id = 0
        cnt = 0
        for row in cursor:
            spectral_data_id = row[0]
        cnt += 1

        return rc, spectral_data_id
    def query_GetData_from_JsonFile_Id(self, cursor, json_filename):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        msg = "select data_id from \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".Data where json_file='"+str(json_filename)+"';"
        #print(msg)
        cursor.execute(msg)
        data_id = 0
        cnt = 0
        for row in cursor:
            data_id = row[0]
        cnt += 1

        return rc, data_id
    def query_GetSpectral_data_from_JsonFile_Id(self, cursor, json_filename):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        msg = "select spectral_data_id from \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".spectral_data where mol_json_file='"+str(json_filename)+"';"
        #print(msg)
        cursor.execute(msg)
        spectral_data_id = 0
        cnt = 0
        for row in cursor:
            spectral_data_id = row[0]
        cnt += 1

        return rc, spectral_data_id

    def query_GetExperiment_from_Expermenting_Id(self, cursor, analytics_data_id):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        msg = "select experiment_id from \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".experimenting where analytics_data_id="+str(analytics_data_id)+";"
        #print (msg)
        cursor.execute(msg)
        experiment_id = 0
        cnt = 0
        for row in cursor:
            experiment_id = row[0]
        cnt += 1

        return rc, experiment_id
    def query_GetExperiment_Id(self, cursor, ionisation_mode_id):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        msg = "select experiment_id from \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".experiment where ionisation_mode_id="+str(ionisation_mode_id)+";"
        #print (msg)
        cursor.execute(msg)
        experiment_id = 0
        cnt = 0
        for row in cursor:
            experiment_id = row[0]
        cnt += 1

        return rc, experiment_id

    def query_GetIonisation_mode_Id(self, cursor, ionisation_mode):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        msg = "select ionisation_mode_id from \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".ionisation_mode where ionisation_mode=\'"+ionisation_mode+"\';"
        #print('msg ++--->: ', msg)
        cursor.execute(msg)
        ionisation_mode_id = 0
        cnt = 0
        for row in cursor:
            ionisation_mode_id = row[0]
        cnt += 1

        return rc, ionisation_mode_id

    def query_GetDate_Id(self, cursor, timestamp):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        msg = "select date_id from \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".DateTable where timestamp_with_tz_column=\'"+timestamp+"\';"
        cursor.execute(msg)
        date_id = 0
        cnt = 0
        for row in cursor:
            date_id = row[0]
            cnt += 1

        return rc, date_id

    def query_GetDate_analytics_data_Id(self, cursor, analytics_data):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        msg = "select analytics_data_id from \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".DateTable where analytics_data_id=\'"+analytics_data+"\';"
        cursor.execute(msg)
        analytics_data_id = 0
        cnt = 0
        for row in cursor:
            analytics_data_id = row[0]
            cnt += 1

        return rc, analytics_data_id

    def query_GetAnalytics_data_Id(self, cursor, molecule_json_filename):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        msg = "select analytics_data_id from \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".Analytics_data where filename=\'"+molecule_json_filename+"\';"
        cursor.execute(msg)
        analytics_data_id = 0
        cnt = 0
        for row in cursor:
            #print("row["+str(cnt)+"] ++--->: ", row[cnt])
            analytics_data_id = row[cnt]
            #print("analytics_data_id ++--->: ", analytics_data_id)
            cnt += 1
        # [end-loop]
        return rc, analytics_data_id

    def query_GetAnalytics_data_number_scans(self, cursor, molecule_json_filename):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        msg = "select number_scans from \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".Analytics_data where filename=\'"+molecule_json_filename+"\';"
        cursor.execute(msg)
        number_scans = 0
        cnt = 0
        for row in cursor:
            number_scans = row[cnt]
            cnt += 1
        # [end-loop]
        return rc, number_scans

    def query_GetDatabase_Id(self, cursor, database):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        #self.m.printMesg("Query ---> "+self.c.getCyan()+__func__+self.c.getBlue()+" ...")
        msg = "select database_id from \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".database_details where database_name=\'"+database+"\';"
        cursor.execute(msg)
        database_id = 0
        cnt = 0
        for row in cursor:
            database_id = row[0]
            cnt += 1

        return rc, database_id

    def query_GetData_Id(self, cursor, molecule_json_filename):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        #self.m.printMesg("Query ---> "+self.c.getCyan()+__func__+self.c.getBlue()+" ...")
        msg = "select data_id from \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".data where json_file=\'"+molecule_json_filename+"\';"
        cursor.execute(msg)
        data_id = 0
        cnt = 0
        for row in cursor:
            data_id = row[0]
            cnt += 1

        return rc, data_id

    def query_GetPlatform_user_Id(self, cursor, name):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        #self.m.printMesg("Query ---> "+self.c.getCyan()+__func__+self.c.getBlue()+" ...")
        msg = "select platform_user_id from \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".platform_user where name=\'"+name+"\';"
        cursor.execute(msg)
        pi_name_id = 0
        cnt = 0
        for row in cursor:
            pi_name_id = row[0]
            cnt += 1

        return rc, pi_name_id

    def query_GetTool_Id(self, cursor, tool):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        #self.m.printMesg("Query ---> "+self.c.getCyan()+__func__+self.c.getBlue()+" ...")
        msg = "select tool_id from \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".tool where instrument_source=\'"+tool+"\';"
        cursor.execute(msg)
        tool_id = 0
        cnt = 0
        for row in cursor:
            tool_id = row[0]
            cnt += 1

        return rc, tool_id

    def query_GetIonModeChem_Id(self, cursor, ionmodechem):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        #self.m.printMesg("Query ---> "+self.c.getCyan()+__func__+self.c.getBlue()+" ...")
        msg = "select ionmodechem_id from \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".ionmodechem where chemical_composition=\'"+ionmodechem+"\';"
        cursor.execute(msg)
        ionmodechem_id = 0
        cnt = 0
        for row in cursor:
            ionmodechem_id = row[0]
            cnt += 1

        return rc, ionmodechem_id

    def query_GetCharge_Id(self, cursor, charge):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        #self.m.printMesg("Query ---> "+self.c.getCyan()+__func__+self.c.getBlue()+" ...")
        msg = "select charge_id from \""+self.c.getDatabase_name()+"\".\""+self.c.getDatabase_schema()+"\".charge where charge=\'"+charge+"\';"
        cursor.execute(msg)
        charge_id = 0
        cnt = 0
        for row in cursor:
            charge_id = row[0]
            cnt += 1

        return rc, charge_id

    def query_GetFullTable_list(self, cursor):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        self.m.printMesg("Query ---> "+self.c.getCyan()+__func__+self.c.getBlue()+" ...")
        cursor.execute('USE [NeCENDatabase-Prod]')
        cursor.execute('SELECT * FROM INFORMATION_SCHEMA.TABLES')
        cnt = 0
        for row in cursor:
            if cnt > 1: self.full_table_list.append(row)
            cnt += 1
        return rc, self.full_table_list

    def query_PostGreSQL_GetFullTable_list(self, cursor):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        self.m.printMesg("Query ---> "+self.c.getCyan()+__func__+self.c.getBlue()+" ...")
        #select * from pg_catalog.pg_tables where schemaname != 'pg_catalog' and schemaname != 'information_schema';
        cursor.execute('select * from pg_catalog.pg_tables where schemaname != \'pg_catalog\' and schemaname != \'information_schema\' and schemaname != \'public\'  ;')
        cnt = 0
        for row in cursor:
            if cnt > 1: self.full_table_list.append(row)
            cnt += 1
        if self.c.getDebug() == 1:
            print("full_table_list[:]", self.full_table_list[:])
        return rc, self.full_table_list

    def query_GetTableCount(self, cursor, database, table):
        rc = self.c.get_RC_SUCCESS()
        cursor.execute('SELECT count(*) FROM ['+database+'].[dbo].['+table+']')
        #table_count = 0
        for row in cursor:
            self.m.printMesgAddStr("["+database+"].[dbo].[{0:<22}".format(table) + "] ---> count: ",
                                   self.c.getCyan(), row)
        table_count = row[0]
        return rc, table_count

    def query_PostGreSQL_GetTableCount(self, cursor, database, schema, table, silent):
        rc = self.c.get_RC_SUCCESS()
        msg = 'SELECT count(*) FROM \"'+database+'\"'+'.\"'+schema+'\".'+table
        cursor.execute(msg) #'SELECT count(*) FROM \"'+database+'\".\"'+schema+'.'+table)
        #table_count = 0
        for row in cursor:
            msg = "\""+database+"\".\""+schema+"\"."+"{0:<22}".format(table) +" ---> count: "
            if not silent:
                self.m.printMesgAddStr(msg, self.c.getCyan(), row)
        table_count = row[0]

        return rc, table_count

    def query_AllFromTable(self, cursor, database, table):
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesg("Query ---> AllFromTable...")
        cursor.execute('SELECT * FROM ['+database+'].[dbo].['+table+']')
        for row in cursor:
            self.m.printMesgAddStr("["+database+"].[dbo].[{}".format(table) + "] ---> row: ", self.c.getCyan(), row)
        return rc

    def query_SelectFromTable_ColList(self, cursor, database, list, table):
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesg("Query ---> SelectFromTable_ColList...")
        cursor.execute('SELECT '+list+' FROM ['+database+'].[dbo].['+table+']')
        for row in cursor:
            self.m.printMesgAddStr("["+database+"].[dbo].[{}".format(table) + "] ---> row: ",
                                   self.c.getCyan(), row)
        return rc

    def query_SelectFromTable_Where_Value(self, cursor, database, table, column, value ):
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesg("Query ---> SelectFromTable_Where_Value...")
        cursor.execute('SELECT * FROM ['+database+'].[dbo].['+table+'] where ['+column+']=\''+str(value)+'\'')
        for row in cursor:
            self.m.printMesgAddStr("["+database+"].[dbo].[{}".format(table) + "] ---> row: ",
                                   self.c.getCyan(), row)
        return rc

    def query_SelectFromTable_ColList_Where_Value(self, cursor, database, list, table, column, value):
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesg("Query ---> SelectFromTable_ColList_Where_Value...")
        cursor.execute('SELECT '+list+' FROM ['+database+'].[dbo].['+table+'] where ['+column+']=\''+str(value)+'\'')
        self.rowth_lst.clear()
        for row in cursor:
            self.m.printMesgAddStr("["+database+"].[dbo].[{}".format(table) + "] ---> row: ", self.c.getCyan(), row)
            self.rowth_lst.append(row)
        return rc, self.rowth_lst

    def query_GetColumNameFromTable(self, cursor, database, table):
        rc = self.c.get_RC_SUCCESS()
        self.columNames_table_list.clear()
        self.m.printMesg("Query ---> GetColumNameFromTable...")
        cursor.execute('SELECT * FROM INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = \''+table+'\'')
        for row in cursor:
            self.m.printMesgAddStr("["+database+"].[dbo].[{}".format(table)+"] ---> column: ", self.c.getCyan(), row[3])
            self.columNames_table_list.append(row[3])
        return rc, self.columNames_table_list

    def query_GetRowFromTable(self, cursor, database, table, column, row_indx):
        rc = self.c.get_RC_SUCCESS()
        #cursor.execute('SELECT * FROM INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = \''+table+'\'')
        cursor.execute('SELECT * FROM ['+database+'].[dbo].['+table+'] where ['+column+']=\''+str(row_indx)+'\'')
        rowth = ""
        for row in cursor: rowth = row
        return rc, rowth
    #---------------------------------------------------------------------------
    # [Creator]
    #---------------------------------------------------------------------------
    def create_cursor(self, cnxn):
        rc = self.c.get_RC_SUCCESS()
        self.cursor = cnxn.cursor()

        return rc, self.cursor
    #---------------------------------------------------------------------------
    # [Generators]
    #---------------------------------------------------------------------------
    def generateTable_list(self, full_table_list):
        rc = self.c.get_RC_SUCCESS()
        for i in range(len(full_table_list[:])):
            self.table_list.append(full_table_list[i][2])
        return rc, self.table_list

    def generateTable_PostGreSQL_list(self, full_table_list):
        rc = self.c.get_RC_SUCCESS()
        for i in range(len(full_table_list[:])):
            self.table_list.append(full_table_list[i][1])
        return rc, self.table_list
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
#-------------------------------------------------------------------------------
# end of QueryMsSQL module
#-------------------------------------------------------------------------------
