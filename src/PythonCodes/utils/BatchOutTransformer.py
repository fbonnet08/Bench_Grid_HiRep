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
import os
import operator
import numpy
from pathlib import Path
import tqdm
import pandas
# Path extension
sys.path.append(os.path.join(os.getcwd(), '.'))
sys.path.append(os.path.join(os.getcwd(), '..'))
sys.path.append(os.path.join(os.getcwd(), '..','..'))
sys.path.append(os.path.join(os.getcwd(), '..','..','..'))
sys.path.append(os.path.join(os.getcwd(), '..','..','..','src','PythonCodes'))
sys.path.append(os.path.join(os.getcwd(), '..','..','..','src','PythonCodes','utils'))
#Application imports
#import src.PythonCodes.DataManage_common
#import src.PythonCodes.utils.JSonLauncher
#import src.PythonCodes.utils.JSonScanner
#import src.PythonCodes.utils.JSonCreator
#import src.PythonCodes.utils.StopWatch
#import src.PythonCodes.utils.progressBar
# Definiiton of the constructor
class BatchOutTransformer:
    #------------------------------------------------------------------------
    # [Constructor] for the
    #------------------------------------------------------------------------
    # Constructor
    def __init__(self, c, m):
        __func__= sys._getframe().f_code.co_name
        self.rc = 0
        self.c = c
        self.m = m
        self.app_root = self.c.getApp_root()
        self.m.printMesgStr("Instantiating the class       :",
                            self.c.getGreen(), "BatchOutTransformer")
        #--------------------------------------------------------------------
        #gettign the csv file
        self.ext_txt = ".txt"
        self.ext_asc = ".asc"
        self.ext_csv = ".csv"
        self.ext_mgf = ".mgf"
        self.ext_json = ".json"
        self.csv_len = 0
        self.csv_col = 0
        self.zerolead = 0
        self.rows = []
        #initialising the lists
        self.bench_BKeeper_dict = {}
        self.bench_Sombrero_dict = {}
        # list definitions BKeeper
        self.cg_run_time_lst = []
        self.FlOps_GFlOps_lst = []
        self.Comms_MB_lst = []
        self.Memory_GB_lst = []
        self.mpi_distribution_lst = []
        self.nnodes_lst = []
        self.lattice_size_lst = []
        self.representation_lst = []
        self.run_file_name_lst = []
        self.target_file_lst = []
        self.target_file_dir = []
        self.target_file_cluster_lst = []
        self.target_file_cluster_filtered_lst = []
        # list definitions Sombrero
        self.ntpns_lst = []
        self.case_lst = []
        self.Gflops_per_seconds_lst = []
        self.Gflops_in_seconds_lst = []
        self.lattice_sz_lst = []
        self.run_file_name_sombrero_lst = []
        self.proc_grid_lst = []
        #Statistics variables
        self.sample_min      = 0.0
        self.sample_max      = 0.0
        self.sample_mean     = 0.0
        self.sample_variance = 0.0
        # printing the files:
        self.printFileNames()
        #--------------------------------------------------------------------
        # [Constructor-end] end of the constructor
        #--------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Initializers]
    #------------------------------------------------------------------------
    # ----------------------------------------------------------------------------
    def Reinitialising_Paths_and_object_content(self, data_path, b_action, sim_sz):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Getting target file list      :", self.c.getGreen(), __func__)
        # -------------------------------------------------------------------
        self.c.setData_path(data_path)
        self.c.setTarget_File("target.txt")

        target_file_default = self.c.getTarget_File()
        self.m.printMesgStr("Default target file           :", self.c.getMagenta(), target_file_default)

        msg_analysis = self.c.getTarget_File().split(".txt")[0] + self.c.undr_scr + \
                            b_action      + self.c.undr_scr                       + \
                            sim_sz        + self.c.undr_scr                       + \
                            "batch_files" + self.c.txt_ext

        self.c.setTarget_File(str(msg_analysis))
        self.m.printMesgStr("Target file for analysis      :", self.c.getMagenta(), self.c.getTarget_File())

        self.c.setTargetdir( os.path.join(self.c.getData_path(), self.c.getTarget_File()))
        self.m.printMesgStr("Full Path target file         :", self.c.getCyan(), self.c.getTargetdir())

        if Path(self.c.getTargetdir()).is_file():
            self.m.printMesgAddStr("[Check]: target file       --->: ", self.c.getGreen(), "Exists")
        # -------------------------------------------------------------------
        return rc
        # [end-function]
        # -------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Setters]
    #------------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Getters]
    #------------------------------------------------------------------------
    # -----------------------------------------------------------------------
    def getTarget_file_lst(self, target_file):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Getting target file list      :", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------
        self.target_file_lst = []
        self.target_file_dir = []
        try:
            with open(target_file) as file:
                cnt = 0
                for line in file:
                    self.target_file_lst.append(os.path.basename(line).strip())
                    self.target_file_dir.append(os.path.dirname(os.path.realpath(line)).strip())
                    cnt += 1
                # [end-For-Loop]
                self.m.printMesgAddStr("target_file filename           : ", self.c.getCyan(), str(target_file))
                self.m.printMesgAddStr("Number of files in target_file : ", self.c.getYellow(), str(cnt))
            # [end-with]
        except IOError:
            self.m.printMesgAddStr(" Filename          : ", self.c.getCyan(), target_file)
            self.m.printMesgAddStr("                   : ", self.c.getRed(), "cannot be found check if file exist")
            #exit(c.get_RC_FAIL())
        # [end-try-catch]
        return rc, self.target_file_lst, self.target_file_dir
        # [end-function]
        # -------------------------------------------------------------------

    #------------------------------------------------------------------------
    def getTarget_file_cluster_lst(self, batch_act, sim_sz, target_file_lst):
        # TODO: must pass in batch_action in the argument list because in abstracted class
        # TODO: it is a bug otherwise Sombrero_weak and Sombrero_weak_cpu is the problem
        # TODO: or fixe the batch script production in the filename convention the script generation
        # TODO: has it in memory that is why it works here and only here.
        # TODO: If statement in junk.python file in case.
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Getting target file list      :", self.c.getGreen(), __func__)
        # -------------------------------------------------------------------
        self.target_file_cluster_lst = []
        for i in range(len(target_file_lst[:])):
            msg = (os.path.join(self.c.getData_path(), batch_act, sim_sz, str(target_file_lst[i].split(".sh")[0]), target_file_lst[i])).strip()
            if Path(msg).is_file():
                self.m.printMesgAddStr("[Check]: target file       --->: ", self.c.getGreen(), self.c.getMagenta()+ msg + self.c.getGreen() + " ---> Exists")
                # Now get the output file to analise and put it into a list
                cluster_out_file = msg.split(".sh")[0]+".out"
                # Extracting cluster files that has been benched
                if Path(cluster_out_file).is_file():
                    self.m.printMesgAddStr("[Check]: Cluster file      --->: ", self.c.getGreen(), self.c.getYellow()+ cluster_out_file + self.c.getGreen() + " ---> Exists")
                    self.target_file_cluster_lst.append(cluster_out_file)
                # [end-if]
            # [end-if]
        # [end-for-loop]
        return rc, self.target_file_cluster_lst[:]
        # [end-function]
        # -------------------------------------------------------------------

    # -----------------------------------------------------------------------
    def get_target_file_cluster_usable(self, nrep, line):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        # -------------------------------------------------------------------
        start_bkeeper_key = "BKeeper"
        if start_bkeeper_key in line.split('\n')[0]:
            if 'Performing benchmark for ' in line.split('\n')[0]:
                nrep += 1
            # [end-if]
        # [end-if]
        # -------------------------------------------------------------------
        # Sombrero filter
        start_sombrero_key = "[MAIN][0]SOMBRERO built from HiRep commit"
        if start_sombrero_key in line.split('\n')[0]:
            #if 'Gflops/seconds' in line.split('\n')[0]:
            if '[RESULT][0] Case' in line.split('\n')[0]:
                nrep += 1
                # [end-if]
            # [end-if]
        # [end-if]
        # ------------------------------------------------------------------
        return rc, nrep
        # [end-function]
        # ------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Filters]
    #------------------------------------------------------------------------
    # -----------------------------------------------------------------------
    def filter_target_file_cluster_lst(self, key_rep_lst, target_file_cluster_lst):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr(   "Getting target file list      :", self.c.getGreen(), __func__)
        # -------------------------------------------------------------------

        self.target_file_cluster_filtered_lst = []

        for i in tqdm.tqdm(range(len(target_file_cluster_lst[:])), ncols=100, desc='filter target file'):
            #for i in range(len(target_file_cluster_lst[:])):
            try:
                if len(target_file_cluster_lst[:]) != 0:
                    cluster_file = open(target_file_cluster_lst[i])
                    # Getting the mpi_distribution, lattice size and number of nodes
                    #ith_file = os.path.basename(target_file_cluster_lst[i].split('\n')[0]).split('.out')[0].split('Run_')[1].split(batch_action+'_')[1].split('_'+simulation_size)[0]
                    #split_string = ith_file.split('_')

                    lines = cluster_file.readlines()
                    database_file_len = len(lines)

                    #print("target_file_cluster_lst[i] -->: ", target_file_cluster_lst[i])
                    nrep = 0
                    for j in range(database_file_len):
                        rc, nrep = self.get_target_file_cluster_usable(nrep, lines[j])
                    # [end-for-loop [j]]

                    #print("nrep ---->: ", nrep)
                    if nrep == len(key_rep_lst[:]):
                        self.target_file_cluster_filtered_lst.append(target_file_cluster_lst[i])
                    # [end-if]
            except IOError:
                self.m.printMesgAddStr(" Filename          : ", self.c.getCyan(), target_file_cluster_lst[i])
                self.m.printMesgAddStr("                   : ", self.c.getRed(), "cannot be found check if file exist")
                #exit(c.get_RC_FAIL())
            # [end-try-catch]
        # [end-for-loop [i]]
        return rc, self.target_file_cluster_filtered_lst
        # [end-function]
        # -------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Driver]
    #------------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Plotters]
    #------------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Handlers]
    #------------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Extractors]
    #------------------------------------------------------------------------
    def extract_ZeroLead(self, number):
        rc = self.c.get_RC_SUCCESS()
        __func__ = sys._getframe().f_code.co_name
        # -------------------------------------------------------------------
        # constructing the leading zeros according to nboot
        # -------------------------------------------------------------------
        zerolead = 0
        # counting the number of digits in self.nboot
        import math
        if number > 0:
            digits = int(math.log10(number)) + 1
        elif number == 0:
            digits = 1
        else:
            digits = int(math.log10(-number)) + 2
        zerolead = numpy.power(10, digits)
        # ------------------------------------------------------------------
        # End of method return statement
        # ------------------------------------------------------------------
        return rc, zerolead
        # [end-function]
        # ------------------------------------------------------------------
    # ----------------------------------------------------------------------
    # [Sombrero]
    # ----------------------------------------------------------------------
    # ----------------------------------------------------------------------------
    def extract_df_representation_Sombrero(self, line, split_string,
                                            nnodes_lst,
                                            ntpns_lst,
                                            case_lst,
                                            Gflops_per_seconds_lst,
                                            Gflops_in_seconds_lst,
                                            lattice_sz_value,
                                            lattice_sz_lst,
                                            p_grid_value,
                                            p_grid_lst,
                                            ith_target_filename,
                                            run_file_name_sombrero_lst):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        # ----------------------------------------------------------------------
        #start_sombrero_key = "[MAIN][0]SOMBRERO built from HiRep commit"
        start_case1_key = "Case 1"
        #if start_sombrero_key in line.split('\n')[0]:
        # TODO: Lattice volume, parallelization, and GFLOP/s for each test would be the minimum.
        if '[RESULT][0] Case 1' in line.split('\n')[0]:
            if 'Gflops/seconds' in line.split('\n')[0]:
                #print(line.split('\n')[0])
                case_lst.append(start_case1_key)
                value = str(line.split('\n')[0]).split('[RESULT][0] Case 1')[1].split('Gflops/seconds')[0]
                Gflops_per_seconds_lst.append(value)
                nnodes_lst.append(str(split_string[0]).split('nodes')[1])
                ntpns_lst.append(str(split_string[1]).split('ntpns')[1])
                lattice_sz_lst.append(str(lattice_sz_value))
                p_grid_lst.append(str(p_grid_value))
                run_file_name_sombrero_lst.append(ith_target_filename)
            # [end-if]
            if 'Gflops in' in line.split('\n')[0]:
                value = str(line.split('\n')[0]).split('[RESULT][0] Case 1')[1].split('seconds')[0]
                Gflops_in_seconds_lst.append(value)
            # [end-if]
        # [end-if]
        start_case2_key = "Case 2"
        if '[RESULT][0] Case 2' in line.split('\n')[0]:
            if 'Gflops/seconds' in line.split('\n')[0]:
                #print(line.split('\n')[0])
                case_lst.append(start_case2_key)
                value = str(line.split('\n')[0]).split('[RESULT][0] Case 2')[1].split('Gflops/seconds')[0]
                Gflops_per_seconds_lst.append(value)
                nnodes_lst.append(str(split_string[0]).split('nodes')[1])
                ntpns_lst.append(str(split_string[1]).split('ntpns')[1])
                lattice_sz_lst.append(str(lattice_sz_value))
                p_grid_lst.append(str(p_grid_value))
                run_file_name_sombrero_lst.append(ith_target_filename)
            # [end-if]
            if 'Gflops in' in line.split('\n')[0]:
                value = str(line.split('\n')[0]).split('[RESULT][0] Case 2')[1].split('seconds')[0]
                Gflops_in_seconds_lst.append(value)
            # [end-if]
        # [end-if]
        start_case3_key = "Case 3"
        if '[RESULT][0] Case 3' in line.split('\n')[0]:
            if 'Gflops/seconds' in line.split('\n')[0]:
                #print(line.split('\n')[0])
                case_lst.append(start_case3_key)
                value = str(line.split('\n')[0]).split('[RESULT][0] Case 3')[1].split('Gflops/seconds')[0]
                Gflops_per_seconds_lst.append(value)
                nnodes_lst.append(str(split_string[0]).split('nodes')[1])
                ntpns_lst.append(str(split_string[1]).split('ntpns')[1])
                lattice_sz_lst.append(str(lattice_sz_value))
                p_grid_lst.append(str(p_grid_value))
                run_file_name_sombrero_lst.append(ith_target_filename)
            # [end-if]
            if 'Gflops in' in line.split('\n')[0]:
                value = str(line.split('\n')[0]).split('[RESULT][0] Case 3')[1].split('seconds')[0]
                Gflops_in_seconds_lst.append(value)
            # [end-if]
        # [end-if]
        start_case4_key = "Case 4"
        if '[RESULT][0] Case 4' in line.split('\n')[0]:
            if 'Gflops/seconds' in line.split('\n')[0]:
                #print(line.split('\n')[0])
                case_lst.append(start_case4_key)
                value = str(line.split('\n')[0]).split('[RESULT][0] Case 4')[1].split('Gflops/seconds')[0]
                Gflops_per_seconds_lst.append(value)
                nnodes_lst.append(str(split_string[0]).split('nodes')[1])
                ntpns_lst.append(str(split_string[1]).split('ntpns')[1])
                lattice_sz_lst.append(str(lattice_sz_value))
                p_grid_lst.append(str(p_grid_value))
                run_file_name_sombrero_lst.append(ith_target_filename)
            # [end-if]
            if 'Gflops in' in line.split('\n')[0]:
                value = str(line.split('\n')[0]).split('[RESULT][0] Case 4')[1].split('seconds')[0]
                Gflops_in_seconds_lst.append(value)
            # [end-if]
        # [end-if]
        start_case5_key = "Case 5"
        if '[RESULT][0] Case 5' in line.split('\n')[0]:
            if 'Gflops/seconds' in line.split('\n')[0]:
                #print(line.split('\n')[0])
                case_lst.append(start_case5_key)
                value = str(line.split('\n')[0]).split('[RESULT][0] Case 5')[1].split('Gflops/seconds')[0]
                Gflops_per_seconds_lst.append(value)
                nnodes_lst.append(str(split_string[0]).split('nodes')[1])
                ntpns_lst.append(str(split_string[1]).split('ntpns')[1])
                lattice_sz_lst.append(str(lattice_sz_value))
                p_grid_lst.append(str(p_grid_value))
                run_file_name_sombrero_lst.append(ith_target_filename)
            # [end-if]
            if 'Gflops in' in line.split('\n')[0]:
                value = str(line.split('\n')[0]).split('[RESULT][0] Case 5')[1].split('seconds')[0]
                Gflops_in_seconds_lst.append(value)
            # [end-if]
        # [end-if]
        start_case6_key = "Case 6"
        if '[RESULT][0] Case 6' in line.split('\n')[0]:
            if 'Gflops/seconds' in line.split('\n')[0]:
                #print(line.split('\n')[0])
                case_lst.append(start_case6_key)
                value = str(line.split('\n')[0]).split('[RESULT][0] Case 6')[1].split('Gflops/seconds')[0]
                Gflops_per_seconds_lst.append(value)
                nnodes_lst.append(str(split_string[0]).split('nodes')[1])
                ntpns_lst.append(str(split_string[1]).split('ntpns')[1])
                lattice_sz_lst.append(str(lattice_sz_value))
                p_grid_lst.append(str(p_grid_value))
                run_file_name_sombrero_lst.append(ith_target_filename)
            # [end-if]
            if 'Gflops in' in line.split('\n')[0]:
                value = str(line.split('\n')[0]).split('[RESULT][0] Case 6')[1].split('seconds')[0]
                Gflops_in_seconds_lst.append(value)
            # [end-if]
        # [end-if]
        # ----------------------------------------------------------------------
        return rc
        # [end-function]
        # --------------------------------------------------------------------------
    # ----------------------------------------------------------------------
    # [BKeeper]
    # ----------------------------------------------------------------------
    def extract_df_representation_BKeeper(self, line,
                                            split_string,
                                            cg_run_time_lst,
                                            FlOps_GFlOps_lst,
                                            Comms_MB_lst,
                                            Memory_GB_lst,
                                            mpi_distribution_lst,
                                            nnodes_lst,
                                            lattice_size_lst,
                                            representation_lst,
                                            ith_target_filename,
                                            run_file_name_lst):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        # ----------------------------------------------------------------------

        print("line.split('\n')[0] ---> ", line.split('\n')[0])

        start_bkeeper_key = "BKeeper"
        if start_bkeeper_key in line.split('\n')[0]:
            print("start_bkeeper_key ---> ", start_bkeeper_key)
            if 'Performing benchmark for ' in line.split('\n')[0]:
                rep_value = str(line.split('\n')[0]).split('Performing benchmark for ')[1].split(' #')[0]
                #print("rep_value --->: ", rep_value)
                if rep_value != 'Sp(4), fundamental':
                    representation_lst.append(rep_value)
                    run_file_name_lst.append(ith_target_filename)

            if "CG Run Time (s)" in line.split('\n')[0]:
                #key   = "CG Run Time (s)" #str(lines[j]).split(':')[0]
                value = str(str(line).split(':')[4]).split('\n')[0]
                cg_run_time_lst.append(float(value))

                lattice_size_lst.append(str(split_string[0]).split('lat'  )[1])
                nnodes_lst.append(str(split_string[1]).split('nodes')[1])
                mpi_distribution_lst.append(str(split_string[2]).split('mpi'  )[1])
                #if rep_value != "empty_string":

            if "FlOp/S (GFlOp/s)" in line.split('\n')[0]:
                #key   = "FlOp/S (GFlOp/s)" #str(lines[j]).split(':')[0]
                value = str(str(line).split(':')[4]).split('\n')[0]
                FlOps_GFlOps_lst.append(float(value))
            if "Comms  (MB)" in  line.split('\n')[0]:
                #key   = "Comms" #str(lines[j]).split(':')[0]
                value = str(str(line).split(':')[4]).split('\n')[0]
                Comms_MB_lst.append(float(value))
            if "Memory (GB)" in line.split('\n')[0]:
                #key   = "Memory (GB)" #str(lines[j]).split(':')[0]
                value = str(str(line).split(':')[4]).split('\n')[0]
                Memory_GB_lst.append(float(value))
        # [end-if]
        # ------------------------------------------------------------------
        return rc
        # [end-function]
        # ------------------------------------------------------------------
    #-----------------------------------------------------------------------
    # [Reader]
    #-----------------------------------------------------------------------

    # ----------------------------------------------------------------------------
    def read_Sombrero_file_out(self, batch_act, sim_size, target_file_cluster_lst):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Getting target file list      :", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------
        self.bench_Sombrero_dict = {}
        # list definitions
        self.nnodes_lst = []
        self.ntpns_lst = []
        self.case_lst = []
        self.Gflops_per_seconds_lst = []
        self.Gflops_in_seconds_lst = []
        self.lattice_sz_lst = []
        self.run_file_name_sombrero_lst = []
        self.proc_grid_lst = []
        # Making sure that the list are empty before inserting anything
        self.nnodes_lst.clear()
        self.ntpns_lst.clear()
        self.case_lst.clear()
        self.Gflops_per_seconds_lst.clear()
        self.Gflops_in_seconds_lst.clear()
        self.lattice_sz_lst.clear()
        self.run_file_name_sombrero_lst.clear()
        self.proc_grid_lst.clear()
        #
        rc, zerolead = self.extract_ZeroLead(int(2))
        #for i in range(6):
        for i in tqdm.tqdm(range(len(target_file_cluster_lst[:])), ncols=100, desc='bench_BKeeper_dict'):
            try:
                if len(target_file_cluster_lst[:]) != 0:
                    cluster_file = open(target_file_cluster_lst[i])
                    ith_file = os.path.basename(target_file_cluster_lst[i].split('\n')[0]).split('.out')[0].split('Run_')[1].split(batch_act+'_')[1].split('_'+sim_size)[0]
                    split_string = ith_file.split('_')
                    lines = cluster_file.readlines()
                    database_file_len = len(lines)
                    lattice_sz_value = "not reported"
                    proc_grid_value = "not reported"
                    for j in range(database_file_len):
                        start_lattice_key = "[GEOMETRY][10] Global size is"
                        if start_lattice_key in lines[j].split('\n')[0]:
                            lattice_sz_value = str(lines[j].split('\n')[0]).split(start_lattice_key)[1]
                        # [end-if]
                        start_mpi_proc_grid_key = "[GEOMETRY][10] Proc grid is"
                        if start_mpi_proc_grid_key in lines[j].split('\n')[0]:
                            value_lst = str(str(lines[j].split('\n')[0]).split(start_mpi_proc_grid_key)[1]).strip().split('x')
                            mpi_lst = []
                            mpi_lst.clear()
                            for k in range(len(value_lst[:])):
                                mpi_lst.append(value_lst[k].replace(value_lst[k], str( value_lst[k].zfill(len(str(zerolead)) ) ) ) )
                            # [end-for-loop [k]]
                            if len(mpi_lst[:]) == 4:
                                proc_grid_value = mpi_lst[0] +'-' + mpi_lst[1]  +'-' + mpi_lst[2]  +'-' + mpi_lst[3]
                            # [end-if]
                        # [end-if]
                    # [end-for-loop [j]]
                    for j in range(database_file_len):
                        rc = self.extract_df_representation_Sombrero(lines[j], split_string,
                                                                    self.nnodes_lst,
                                                                    self.ntpns_lst,
                                                                    self.case_lst,
                                                                    self.Gflops_per_seconds_lst,
                                                                    self.Gflops_in_seconds_lst,
                                                                    lattice_sz_value,
                                                                    self.lattice_sz_lst,
                                                                    proc_grid_value,
                                                                    self.proc_grid_lst,
                                                                    target_file_cluster_lst[i],
                                                                    self.run_file_name_sombrero_lst)
                    # [end-for-loop [j]]
                # [end-if]
            except IOError:
                self.m.printMesgAddStr(" Filename          : ", self.c.getCyan(), target_file_cluster_lst[i])
                self.m.printMesgAddStr("                   : ", self.c.getRed(), "cannot be found check if file exist")
            # [end-try-catch]
        # [end-for-loop [i]]

        print(len(self.lattice_sz_lst[:]))
        print(len(self.case_lst[:]))
        print(len(self.run_file_name_sombrero_lst[:]))
        print(len(self.Gflops_in_seconds_lst[:]))
        print(len(self.proc_grid_lst[:]))

        self.bench_Sombrero_dict["Case"]               = self.case_lst[:]
        self.bench_Sombrero_dict["nodes"]              = self.nnodes_lst[:]
        self.bench_Sombrero_dict["ntpns"]              = self.ntpns_lst[:]
        self.bench_Sombrero_dict["Gflops_per_seconds"] = self.Gflops_per_seconds_lst[:]
        self.bench_Sombrero_dict["Gflops_in_seconds"]  = self.Gflops_in_seconds_lst[:]
        self.bench_Sombrero_dict["lattice_sz"]         = self.lattice_sz_lst[:]
        self.bench_Sombrero_dict["mpi_distribution"]   = self.proc_grid_lst[:]
        self.bench_Sombrero_dict["Run output file"]    = self.run_file_name_sombrero_lst[:]

        # creating a dictionary from the output data
        dataframe = pandas.DataFrame.from_dict(self.bench_Sombrero_dict)

        # Now sorting out the data from on the mpi_distribution column.
        dataframe.sort_values(by=['Case', 'nodes', 'ntpns', 'mpi_distribution'], inplace=True)

        return rc, dataframe
        # [end-function]
        # --------------------------------------------------------------------------
    # ----------------------------------------------------------------------
    def read_BKeeper_file_out(self, batch_act, sim_size, target_file_cluster_lst):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Getting target file list         :", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------
        self.bench_BKeeper_dict = {}
        # list definitions
        self.cg_run_time_lst = []
        self.FlOps_GFlOps_lst = []
        self.Comms_MB_lst = []
        self.Memory_GB_lst = []
        self.mpi_distribution_lst = []
        self.nnodes_lst = []
        self.lattice_size_lst = []
        self.representation_lst = []
        self.run_file_name_lst = []
        # Making sure that the list are empty before inserting anything
        self.cg_run_time_lst.clear()
        self.FlOps_GFlOps_lst.clear()
        self.Comms_MB_lst.clear()
        self.Memory_GB_lst.clear()
        self.mpi_distribution_lst.clear()
        self.nnodes_lst.clear()
        self.lattice_size_lst.clear()
        self.representation_lst.clear()
        self.run_file_name_lst.clear()
        #
        #for i in range(6):
        for i in tqdm.tqdm(range(len(target_file_cluster_lst[:])), ncols=100, desc='bench_BKeeper_dict'):
            #for i in range(len(target_file_cluster_lst[:])):
            try:
                if len(target_file_cluster_lst[:]) != 0:
                    cluster_file = open(target_file_cluster_lst[i])
                    # Getting the mpi_distribution, lattice size and number of nodes
                    ith_file = os.path.basename(target_file_cluster_lst[i].split('\n')[0]).split('.out')[0].split('Run_')[1].split(batch_act+'_')[1].split('_'+sim_size)[0]
                    split_string = ith_file.split('_')
                    lines = cluster_file.readlines()
                    database_file_len = len(lines)
                    for j in range(database_file_len):
                        rc = self.extract_df_representation_BKeeper(lines[j], split_string,
                                                                    self.cg_run_time_lst, self.FlOps_GFlOps_lst,
                                                                    self.Comms_MB_lst, self.Memory_GB_lst,
                                                                    self.mpi_distribution_lst, self.nnodes_lst,
                                                                    self.lattice_size_lst, self.representation_lst,
                                                                    target_file_cluster_lst[i], self.run_file_name_lst)
                    # [end-for-loop [j]]
                # [end-if]
            except IOError:
                self.m.printMesgAddStr(" Filename          :", self.c.getCyan(), target_file_cluster_lst[i])
                self.m.printMesgAddStr("                   :", self.c.getRed(), "cannot be found check if file exist")
            # [end-try-catch]
        # [end-for-loop [i]]

        self.bench_BKeeper_dict["Representation"]   = self.representation_lst[:]
        self.bench_BKeeper_dict["CG Run Time (s)"]  = self.cg_run_time_lst[:]
        self.bench_BKeeper_dict["FlOp/S (GFlOp/s)"] = self.FlOps_GFlOps_lst[:]
        self.bench_BKeeper_dict["Comms  (MB)"]      = self.Comms_MB_lst[:]
        self.bench_BKeeper_dict["Memory (GB)"]      = self.Memory_GB_lst[:]
        self.bench_BKeeper_dict["lattice"]          = self.lattice_size_lst[:]
        self.bench_BKeeper_dict["nodes"]            = self.nnodes_lst[:]
        self.bench_BKeeper_dict["mpi_distribution"] = self.mpi_distribution_lst[:]
        self.bench_BKeeper_dict["Run output file"]  = self.run_file_name_lst[:]

        # creating a dictionary from the output data
        dataframe = pandas.DataFrame.from_dict(self.bench_BKeeper_dict)

        # Now sorting out the data from on the mpi_distribution column.
        dataframe.sort_values(by='mpi_distribution', inplace=True)

        return rc, dataframe
        # [end-function]
        # --------------------------------------------------------------------------
    #-----------------------------------------------------------------------
    # [Writers]
    #-----------------------------------------------------------------------
    #-------------------------------------------------------------------
    # [Creator]
    #-----------------------------------------------------------------------
    #-----------------------------------------------------------------------
    # [Printers]
    #-----------------------------------------------------------------------
    def printFileNames(self):
        rc = self.c.get_RC_SUCCESS()
        return rc
#---------------------------------------------------------------------------
# end of BatchOutTransformer
#---------------------------------------------------------------------------
