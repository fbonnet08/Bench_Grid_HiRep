'''!\file
   -- LDMaP-APP addon: 
      \date 20th of June 2021

      Leiden University June 2021

Name:
---
credDetails: module for the credemtials of the dataBase in questions all
             dataBase handling credentials and the like are to go here

Description of classes:
---
This class holds the authentication mechanisms to the database via getpass

Requirements (system):
---
* sys
* getpass

Requirements (application):
* none
---
'''
import getpass
# ------------------------------------------------------------------------------
# [WIN-I0E9QBHS21\SQLEXPRESS2019]
# ------------------------------------------------------------------------------
#server = '132.229.105.89\SQLEXPRESS2019'
#server = '132.229.105.71\SQLEXPRESS2019' #TODO: need to DataMange_namespace or DataManage_config imports
server = 'DESKTOP-GPI5ERK\SQLEXPRESS2019'       #TODO: need to DataMange_namespace or DataManage_config imports
database = 'NeCENDatabase-Prod'
username = "quarky" # input("Username: ")            #
password = "password"  # getpass.getpass(prompt='Enter DataBase password:')
# ------------------------------------------------------------------------------
# TODO: [Remote-access] Remote access from non windows machine needs to be fixed
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# [PostGreSQL]
# ------------------------------------------------------------------------------
server_PostGreSQL = '127.0.0.1'           # 'palpostgres.obs-banyuls.fr'
database_PostGreSQL = "MolRefAnt_DB_PostGreSQL"
schema_PostGreSQL = "MolRefAnt_DB"
username_PostGreSQL = "frederic"          # "MolRefAnt_DB_PostGreSQL_admin"
password_PostGreSQL = "postgre23"         # "H1&5j5^D_P5v+}"
port_PostGreSQL = '5432'                  # '4604'
#-------------------------------------------------------------------------------
# TODO: [Remote-access] Remote access from non windows machine needs to be fixed
#-------------------------------------------------------------------------------
#'PWD='+ password
#ODBC Driver 17 for SQL Server
#server = 'tcp:132.229.105.89\SQLEXPRESS2019,1433'
#WIN-I0E9QBHS21\SQLEXPRESS2019
#database = 'QuarkyTestDB'
#username = 'quarky'
