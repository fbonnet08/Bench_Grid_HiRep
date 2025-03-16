#!/usr/bin/env python3
'''!\file
   -- DataManage addon: (Python3 code) class for handling MZMine files
      \author Frederic Bonnet
      \date 03rd of March 2024

      Swansea University March 2025

Name:
---
Bencher: class Bencher for analyzing raw files, can be called
from the GUI interfaces.

Description of classes:
---
This class generates an object and files used in the MgfTransformer class

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
# numerical imports
import numpy
import IPython

# Path extension
sys.path.append(os.path.join(os.getcwd(), '.'))
sys.path.append(os.path.join(os.getcwd(), '..'))
sys.path.append(os.path.join(os.getcwd(), '..','..'))
sys.path.append(os.path.join(os.getcwd(), '..','..','src','PythonCodes'))
sys.path.append(os.path.join(os.getcwd(), '..','..','src','PythonCodes','utils'))
#Application imports
# Definition of the constructor
class Bencher:
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
                            self.c.getGreen(), "Bencher")
        #--------------------------------------------------------------------
        #gettign the csv file
        self.ext_txt = ".txt"
        self.ext_asc = ".asc"
        self.ext_csv = ".csv"
        self.ext_mgf = ".mgf"
        self.ext_png = ".png"
        self.ext_json = ".json"
        self.undr_scr = "_"
        self.dot = "."
        self.csv_len = 0
        self.csv_col = 0
        # spectrum details
        #Statistics variables
        self.sample_min      = 0.0
        self.sample_max      = 0.0
        self.sample_mean     = 0.0
        self.sample_variance = 0.0
        self.running_mean = []
        # some path initialisation
        self.targetdir = "./"
        # Getting the file structure in place

        # printing the files:
        self.printFileNames()
        #--------------------------------------------------------------------
        # [Constructor-end] end of the constructor
        #--------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Driver]
    #------------------------------------------------------------------------
    # -----------------------------------------------------------------------
    def driver_BenchRes_BKeeper(self, transformer,
                                lattice_Analyser,
                                mach_name, batch_act, sim_sz, data_path):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Getting target file list      :", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------
        # --------------------------------------------------------------------
        rc = transformer.Reinitialising_Paths_and_object_content(data_path, batch_act, sim_sz)
        # --------------------------------------------------------------------
        # --------------------------------------------------------------------
        # Getting content in the target file
        rc, target_file_lst, target_file_dir = transformer.getTarget_file_lst(self.c.getTargetdir())
        # --------------------------------------------------------------------
        # --------------------------------------------------------------------
        # Getting content in the target file
        rc, target_file_cluster_lst = transformer.getTarget_file_cluster_lst(batch_act,
                                                                            sim_sz,
                                                                            target_file_lst[:])
        # --------------------------------------------------------------------
        # --------------------------------------------------------------------
        # [Data-Extraction]
        # --------------------------------------------------------------------
        self.m.printMesgStr(   "Data extraction cluster out   :", self.c.getGreen(), mach_name)
        self.m.printMesgAddStr("Simulation size               :", self.c.getRed(), sim_sz)
        self.m.printMesgAddStr("target_file_cluster_lst       :", self.c.getYellow(), target_file_cluster_lst[:])
        self.m.printMesgAddStr("len( ..file_cluster_lst)      :", self.c.getYellow(), len(target_file_cluster_lst[:]))
        # ----------------------------------------------------------------------------
        # --------------------------------------------------------------------------
        # Reading in the inout file
        rc, target_file_cluster_filtered_lst = transformer.filter_target_file_cluster_lst(self.c.start_key_rep_lst[:],
                                                                                        target_file_cluster_lst[:])
        self.m.printMesgAddStr("len(target_file_cluster_filtered_lst[:]) --->:",
                          self.c.getYellow(), len(target_file_cluster_filtered_lst[:]))
        # ----------------------------------------------------------------------------
        #%%
        # --------------------------------------------------------------------------
        # Reading in the inout file
        msg = batch_act + "_" + sim_sz + "_" + "all_nodes"
        rc, cluster_failed_lst = lattice_Analyser.plot_BenchRes_SuccessFailure_pieChart_matplotlib(target_file_cluster_lst[:],
                                                                                                target_file_cluster_filtered_lst[:],
                                                                                                mach_name, msg)
        # --------------------------------------------------------------------------
        # --------------------------------------------------------------------------
        # Reading in the inout file
        #rc, dataFrame_BKeeper = read_BKeeper_file_out(c, m, batch_action, simulation_size, target_file_cluster_lst[:])
        rc, dataFrame_BKeeper = transformer.read_BKeeper_file_out(batch_act, sim_sz,
                                                                        target_file_cluster_filtered_lst[:])
        # --------------------------------------------------------------------------
        # --------------------------------------------------------------------------
        # Reading in the inout file
        self.m.printMesgStr("DataFrame BKeeper             :", self.c.getGreen(), mach_name)
        IPython.display.display(dataFrame_BKeeper)
        # ----------------------------------------------------------------------------
        # --------------------------------------------------------------------------
        # Reading in the inout file
        self.m.printMesgStr("Plots DataFrame BKeeper       :", self.c.getGreen(), mach_name)

        df_su2_ad = dataFrame_BKeeper[
            dataFrame_BKeeper["Representation"] == "SU(2), adjoint"][
            ["Representation", "CG Run Time (s)","mpi_distribution","nodes", "FlOp/S (GFlOp/s)", "lattice"]
        ]
        df_su2_fun = dataFrame_BKeeper[
            dataFrame_BKeeper["Representation"] == "SU(2), fundamental"][
            ["Representation", "CG Run Time (s)","mpi_distribution","nodes", "FlOp/S (GFlOp/s)", "lattice"]
        ]
        df_su3_fun = dataFrame_BKeeper[
            dataFrame_BKeeper["Representation"] == "SU(3), fundamental"][
            ["Representation", "CG Run Time (s)","mpi_distribution","nodes", "FlOp/S (GFlOp/s)", "lattice"]
        ]
        # --------------------------------------------------------------------------
        #IPython.display.display(df_su2_ad)
        # --------------------------------------------------------------------------

        nodes_lst   = df_su2_ad['nodes'].unique().tolist()
        lattice_lst = df_su2_ad['lattice'].unique().tolist()

        cnt_node = 1
        for node in nodes_lst[:]:
            self.m.printMesgAddStr(" nodes to be considered     ["+str(cnt_node)+"]: ", self.c.getYellow(), node)
            cnt_node += 1
        # [end-for-loop [node]]
        cnt_lattice = 1
        for lattice in lattice_lst[:]:
            self.m.printMesgAddStr(" lattice to be considered   ["+str(cnt_lattice)+"]: ", self.c.getYellow(), lattice)
            cnt_lattice += 1
        # [end-for-loop [node]]

        for lattice in lattice_lst[:]:

            df_su2_ad_lattice = df_su2_ad[
                df_su2_ad['lattice'] == lattice][
                ["Representation", "CG Run Time (s)","mpi_distribution","nodes", "FlOp/S (GFlOp/s)"]
            ]
            df_su2_fun_lattice = df_su2_fun[
                df_su2_fun['lattice'] == lattice][
                ["Representation", "CG Run Time (s)","mpi_distribution","nodes", "FlOp/S (GFlOp/s)"]
            ]
            df_su3_fun_lattice = df_su3_fun[
                df_su3_fun['lattice'] == lattice][
                ["Representation", "CG Run Time (s)","mpi_distribution","nodes", "FlOp/S (GFlOp/s)"]
            ]
            # --------------------------------------------------------------------------
            # --------------------------------------------------------------------------
            # Plotting data
            x_label = "mpi_distribution"
            y_label = "CG Run Time (s)"

            self.c.setXaxis_label(x_label)
            self.c.setYaxis_label(y_label)
            self.m.printMesgAddStr(" Plot x-axis                   : ", self.c.getGreen(), self.c.getXaxis_label())
            self.m.printMesgAddStr(" Plot y-axis                   : ", self.c.getGreen(), self.c.getYaxis_label())
            for node in nodes_lst[:]:
                df_su2_adj_mpi_node001     = df_su2_ad_lattice[df_su2_ad_lattice["nodes"]   == str(node)][[x_label]]
                df_su2_adj_cgtimes_node001 = df_su2_ad_lattice[df_su2_ad_lattice["nodes"]   == str(node)][[y_label]]
                df_su2_fun_cgtimes_node001 = df_su2_fun_lattice[df_su2_fun_lattice["nodes"] == str(node)][[y_label]]
                df_su3_fun_cgtimes_node001 = df_su3_fun_lattice[df_su3_fun_lattice["nodes"] == str(node)][[y_label]]

                #msg = batch_act + "_" + sim_sz + "_" + "node001"
                msg = batch_act + "_" + sim_sz + "_" + "node"+str(node) +  "_" + "lat"+str(lattice)

                rc = lattice_Analyser.plot_BenchRes_groupByBars_matplotlib(
                    df_su2_adj_mpi_node001[x_label],
                    df_su2_adj_cgtimes_node001[y_label],
                    df_su2_fun_cgtimes_node001[y_label],
                    df_su3_fun_cgtimes_node001[y_label],
                    mach_name, msg
                )
            # --------------------------------------------------------------------------
            # [Mpi_dristibution]
            # --------------------------------------------------------------------------
            # Plotting data
            x_label = "mpi_distribution"
            y_label = "FlOp/S (GFlOp/s)"

            self.c.setXaxis_label(x_label)
            self.c.setYaxis_label(y_label)
            self.m.printMesgAddStr(" Plot x-axis                   : ", self.c.getGreen(), self.c.getXaxis_label())
            self.m.printMesgAddStr(" Plot y-axis                   : ", self.c.getGreen(), self.c.getYaxis_label())

            for node in nodes_lst[:]:
                df_su2_adj_mpi_node001   = df_su2_ad_lattice[df_su2_ad_lattice["nodes"]   == str(node)][[x_label]]
                df_su2_adj_flops_node001 = df_su2_ad_lattice[df_su2_ad_lattice["nodes"]   == str(node)][[y_label]]
                df_su2_fun_flops_node001 = df_su2_fun_lattice[df_su2_fun_lattice["nodes"] == str(node)][[y_label]]
                df_su3_fun_flops_node001 = df_su3_fun_lattice[df_su3_fun_lattice["nodes"] == str(node)][[y_label]]

                #msg = batch_act + "_" + sim_sz + "_" + "node001"
                msg = batch_act + "_" + sim_sz + "_" + "node" + str(node) +  "_" + "lat" + str(lattice)

                rc = lattice_Analyser.plot_BenchRes_groupByBars_matplotlib(
                    df_su2_adj_mpi_node001[x_label],
                    df_su2_adj_flops_node001[y_label],
                    df_su2_fun_flops_node001[y_label],
                    df_su3_fun_flops_node001[y_label],
                    mach_name, msg
                )
            #[end-for-loop [node]
        #[end-for-loop [lattice]
        # --------------------------------------------------------------------------
        # [Nodes] All cases
        # --------------------------------------------------------------------------
        # --------------------------------------------------------------------------
        # [Representation]
        # --------------------------------------------------------------------------
        # --------------------------------------------------------------------------
        x_label = "nodes"
        y_label = "CG Run Time (s)"
        self.c.setXaxis_label(x_label)
        self.c.setYaxis_label(y_label)
        # --------------------------------------------------------------------------
        msg = batch_act + "_" + sim_sz + "_" + \
              str(str(self.c.start_key_rep_lst[0]).split("Performing benchmark for ")[1]).replace(" ","_").replace(",","")
        # --------------------------------------------------------------------------
        rc = lattice_Analyser.plot_BenchRes_group_Nodes_Rep_matplotlib(df_su2_ad, mach_name, msg)
        # --------------------------------------------------------------------------
        y_label = "FlOp/S (GFlOp/s)"
        self.c.setYaxis_label(y_label)
        rc = lattice_Analyser.plot_BenchRes_group_Nodes_Rep_matplotlib(df_su2_ad, mach_name, msg)
        # --------------------------------------------------------------------------
        # --------------------------------------------------------------------------
        # Plotting data per nodes
        # --------------------------------------------------------------------------
        x_label = "nodes"
        y_label = "CG Run Time (s)"
        self.c.setXaxis_label(x_label)
        self.c.setYaxis_label(y_label)

        msg = batch_act + "_" + sim_sz
        # --------------------------------------------------------------------------
        rc = lattice_Analyser.plot_BenchRes_group_Nodes_matplotlib("linear_scale",
                                                                  df_su2_ad,
                                                                  df_su2_fun,
                                                                  df_su3_fun,
                                                                  mach_name, msg)
        # --------------------------------------------------------------------------
        y_label = "FlOp/S (GFlOp/s)"
        self.c.setYaxis_label(y_label)
        rc = lattice_Analyser.plot_BenchRes_group_Nodes_matplotlib("linear_scale",
                                                                    df_su2_ad,
                                                                    df_su2_fun,
                                                                    df_su3_fun,
                                                                    mach_name, msg)
        # --------------------------------------------------------------------------
        # --------------------------------------------------------------------------
        # [CG vs Flops]
        # --------------------------------------------------------------------------
        x_label = "FlOp/S (GFlOp/s)"
        y_label = "CG Run Time (s)"
        self.c.setXaxis_label(x_label)
        self.c.setYaxis_label(y_label)

        msg = batch_act + "_" + sim_sz
        rc = lattice_Analyser.plot_BenchRes_group_FlopsCG_matplotlib("linear_scale",
                                                                    df_su2_ad,
                                                                    df_su2_fun,
                                                                    df_su3_fun,
                                                                    batch_act, sim_sz, mach_name, msg)
        #'''
        # --------------------------------------------------------------------------
        # [CG vs Flops] per node
        # --------------------------------------------------------------------------
        x_label = "FlOp/S (GFlOp/s)"
        y_label = "CG Run Time (s)"
        self.c.setXaxis_label(x_label)
        self.c.setYaxis_label(y_label)

        msg = batch_act + "_" + sim_sz
        rc = lattice_Analyser.plot_BenchRes_group_FlopsCG_per_Nodes_matplotlib("linear_scale",
                                                                                df_su2_ad,
                                                                                df_su2_fun,
                                                                                df_su3_fun,
                                                                                batch_act, sim_sz, mach_name, msg)
        #'''
        # -------------------------------------------------------------------
        return rc
        # [end-function]
        # -------------------------------------------------------------------
    def driver_BenchRes_Sombrero(self, transformer,
                                lattice_Analyser,
                                mach_name,
                                target_batch_act,
                                batch_act, sim_sz, data_path):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Getting target file list      :", self.c.getGreen(), __func__)
        # -------------------------------------------------------------------
        rc, dataFrame_Sombrero = self.getDataFrame_from_Sombrero_Runs(transformer,
                                                                    lattice_Analyser,
                                                                    data_path,
                                                                    mach_name,
                                                                    target_batch_act,
                                                                    batch_act,
                                                                    sim_sz,
                                                                    self.c.start_key_sombrero_rep_lst)
        # --------------------------------------------------------------------------
        # Reading in the inout file
        self.m.printMesgStr("DataFrame Sombrero            :", self.c.getGreen(), mach_name)
        IPython.display.display(dataFrame_Sombrero)
        # ----------------------------------------------------------------------------
        # --------------------------------------------------------------------------
        rc = lattice_Analyser.plot_Sombrero_AllCases_strong_ByLatticeSz_scatterPlot_mach(
            dataFrame_Sombrero,
            batch_act,
            sim_sz,
            mach_name,
            self.c.start_key_sombrero_rep_bkeeper_map_lst,
            is_float="with_float"
        )
        rc = lattice_Analyser.plot_Sombrero_AllCases_strong_ByLatticeSz_scatterPlot_mach(
            dataFrame_Sombrero,
            batch_act,
            sim_sz,
            mach_name,
            self.c.start_key_sombrero_rep_bkeeper_map_lst,
            is_float="no_float"
        )

        return rc
        # [end-function]
        # -------------------------------------------------------------------

    def driver_BenchRes_Sombrero_weak(self, transformer,
                                    lattice_Analyser,
                                    mach_name,
                                    target_batch_act,
                                    batch_act, sim_sz, data_path):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Getting target file list      :", self.c.getGreen(), __func__)
        # -------------------------------------------------------------------
        rc, dataFrame_Sombrero = self.getDataFrame_from_Sombrero_Runs(
            transformer,
            lattice_Analyser,
            data_path,
            mach_name,
            target_batch_act,
            batch_act,
            sim_sz,
            self.c.start_key_sombrero_rep_lst
        )
        # --------------------------------------------------------------------------
        # Reading in the inout file
        self.m.printMesgStr("DataFrame Sombrero            :", self.c.getGreen(), mach_name)
        IPython.display.display(dataFrame_Sombrero)
        # ----------------------------------------------------------------------------
        # --------------------------------------------------------------------------
        rc = lattice_Analyser.plot_Sombrero_AllCases_weak_ByLatticeSz_scatterPlot_mach(
            dataFrame_Sombrero,
            batch_act,
            sim_sz,
            mach_name,
            self.c.start_key_sombrero_rep_bkeeper_map_lst,
            is_float="with_float"
        )
        rc = lattice_Analyser.plot_Sombrero_AllCases_weak_ByLatticeSz_scatterPlot_mach(
            dataFrame_Sombrero,
            batch_act,
            sim_sz,
            mach_name,
            self.c.start_key_sombrero_rep_bkeeper_map_lst,
            is_float="no_float"
        )

        return rc
        # [end-function]
        # -------------------------------------------------------------------
    def driver_BenchRes_Sombrero_small_large(self, transformer,
                                                lattice_Analyser,
                                                mach_name,
                                                target_batch_act,
                                                batch_act, sim_sz, data_path):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Getting target file list      :",
                            self.c.getGreen(), __func__)
        # -------------------------------------------------------------------
        # Get the frames
        # -------------------------------------------------------------------
        get_size_lst = sim_sz.split("-")
        self.m.printMesgStr("Simulation size list          :",
                            self.c.getGreen(), get_size_lst[:])
        # -------------------------------------------------------------------
        #small
        size = get_size_lst[0]
        rc, dataFrame_Sombrero_small = self.getDataFrame_from_Sombrero_Runs(
            transformer,
            lattice_Analyser,
            data_path,
            mach_name,
            target_batch_act,
            batch_act,
            size,
            self.c.start_key_sombrero_rep_lst
        )
        #large
        size = get_size_lst[1]
        rc, dataFrame_Sombrero_large = self.getDataFrame_from_Sombrero_Runs(
            transformer,
            lattice_Analyser,
            data_path,
            mach_name,
            target_batch_act,
            batch_act,
            size,
            self.c.start_key_sombrero_rep_lst
        )
        # --------------------------------------------------------------------------
        # Reading in the inout file
        self.m.printMesgStr("DataFrame Sombrero small      :",
                            self.c.getGreen(), mach_name)
        IPython.display.display(dataFrame_Sombrero_small)
        # Reading in the inout file
        self.m.printMesgStr("DataFrame Sombrero large      :",
                            self.c.getGreen(), mach_name)
        IPython.display.display(dataFrame_Sombrero_large)
        # ----------------------------------------------------------------------------
        # --------------------------------------------------------------------------
        # Scatter plots
        rc = lattice_Analyser.plot_Sombrero_AllCases_strength_scatterPlot_mach(
            dataFrame_Sombrero_small,
            dataFrame_Sombrero_large,
            batch_act, mach_name,
            self.c.start_key_sombrero_rep_bkeeper_map_lst,
            is_float="with_float"
        )
        rc = lattice_Analyser.plot_Sombrero_AllCases_strength_scatterPlot_mach(
            dataFrame_Sombrero_small,
            dataFrame_Sombrero_large,
            batch_act, mach_name,
            self.c.start_key_sombrero_rep_bkeeper_map_lst,
            is_float="no_float"
        )
        # Barplots
        rc = lattice_Analyser.plot_Sombrero_AllCases_strength_mach(
            dataFrame_Sombrero_small,
            dataFrame_Sombrero_large,
            batch_act, mach_name,
            self.c.start_key_sombrero_rep_bkeeper_map_lst,
            is_float="with_float"
        )
        rc = lattice_Analyser.plot_Sombrero_AllCases_strength_mach(
            dataFrame_Sombrero_small,
            dataFrame_Sombrero_large,
            batch_act, mach_name,
            self.c.start_key_sombrero_rep_bkeeper_map_lst,
            is_float="no_float"
        )
        # --------------------------------------------------------------------------
        x_label = "nodes"
        y_label = "Gflops_per_seconds"
        self.c.setXaxis_label(x_label)
        self.c.setYaxis_label(y_label)
        # --------------------------------------------------------------------------
        rc = lattice_Analyser.plot_Sombrero_AllCases_strength_Nodes_mach(
            dataFrame_Sombrero_small,
            dataFrame_Sombrero_large,
            batch_act, mach_name,
            self.c.start_key_sombrero_rep_bkeeper_map_lst,
            "no_float"
        )
        rc = lattice_Analyser.plot_Sombrero_AllCases_strength_Nodes_mach(
            dataFrame_Sombrero_small,
            dataFrame_Sombrero_large,
            batch_act, mach_name,
            self.c.start_key_sombrero_rep_bkeeper_map_lst,
            "with_float"
        )
        # --------------------------------------------------------------------------

        return rc
        # [end-function]
        # -------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Plotters]
    #------------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Handlers]
    #------------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Extractor] extract the zerolead from a given list or length
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
        # -------------------------------------------------------------------
        # End of method return statement
        # -------------------------------------------------------------------
        return rc, zerolead
        #--------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Writers]
    #------------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Reader]
    #------------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Getters]
    #------------------------------------------------------------------------
    # -----------------------------------------------------------------------
    def getDataFrame_from_Sombrero_Runs(self, transformer,
                                        lattice_Analyser,
                                        data_path, mach_name,
                                        target_batch_act,
                                        batch_act,
                                        sim_size, start_key_lst):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Getting target file list      :", self.c.getGreen(), __func__)
        # -------------------------------------------------------------------
        # -------------------------------------------------------------------
        #batch_action = "Sombrero_weak_cpu"
        #simulation_size = "small"
        rc = transformer.Reinitialising_Paths_and_object_content(data_path, target_batch_act, sim_size)
        # -------------------------------------------------------------------
        # -------------------------------------------------------------------
        # Getting content in the target file
        # TODO: redefinition necessary to to act on the target file name _cpu
        # TODO: and batch script discrepancy, batch action will need to be passed in,
        # TODO: in the cluster method.
        #batch_action = "Sombrero_weak"
        rc, target_file_lst, target_file_dir = transformer.getTarget_file_lst(self.c.getTargetdir())
        # -------------------------------------------------------------------
        # -------------------------------------------------------------------
        # Getting content in the target file
        rc, target_file_cluster_lst = transformer.getTarget_file_cluster_lst(batch_act,
                                                                             sim_size,
                                                                             target_file_lst[:])
        # -------------------------------------------------------------------
        # -------------------------------------------------------------------
        # [Data-Extraction]
        # -------------------------------------------------------------------
        self.m.printMesgStr(   "Data extraction cluster out          : ", self.c.getGreen(), mach_name)
        self.m.printMesgAddStr("Target Batch action                   : ", self.c.getYellow(), target_batch_act)
        self.m.printMesgAddStr("Batch action                          : ", self.c.getCyan(), batch_act)
        self.m.printMesgAddStr("Simulation size                       : ", self.c.getMagenta(), sim_size)
        self.m.printMesgAddStr("target_file_cluster_lst[:]        --->: ", self.c.getYellow(), target_file_cluster_lst[:])
        self.m.printMesgAddStr("Length target_file_cluster_lst[:] --->: ", self.c.getYellow(), len(target_file_cluster_lst[:]))
        # -------------------------------------------------------------------
        # -------------------------------------------------------------------
        # Reading in the inout file
        rc, target_file_cluster_filtered_lst = transformer.filter_target_file_cluster_lst(start_key_lst[:],
                                                                              target_file_cluster_lst[:])
        self.m.printMesgAddStr("len(target_Sombrero_weak_small_file_cluster_filtered_lst[:]) --->: ",
                               self.c.getYellow(), len(target_file_cluster_filtered_lst[:]))
        # -------------------------------------------------------------------
        # -------------------------------------------------------------------
        # Reading in the inout file
        msg = batch_act + "_" + sim_size + "_" + "all_nodes"
        rc, file_cluster_failed_lst = lattice_Analyser.plot_BenchRes_SuccessFailure_pieChart_matplotlib(target_file_cluster_lst[:],
                                                                                       target_file_cluster_filtered_lst[:],
                                                                                       mach_name,
                                                                                       msg)
        # -------------------------------------------------------------------
        # -------------------------------------------------------------------
        # Reading in the inout file
        # TODO: return to this one once the read_Sombrero_file_out method is done and replace with the filtered list
        # TODO: instead. For now we are going to use the full unfiltered list.
        #batch_action = "Sombrero_weak"
        #simulation_size = "small"
        rc, dataframe = transformer.read_Sombrero_file_out(batch_act, sim_size, target_file_cluster_lst)
        # -------------------------------------------------------------------------
        self.m.printMesgStr(   "DataFrame on machine                    : ", self.c.getGreen(), mach_name)
        self.m.printMesgAddStr(" Target Batch action                     : ", self.c.getYellow(), target_batch_act)
        self.m.printMesgAddStr(" Batch action                            : ", self.c.getCyan(), batch_act)
        self.m.printMesgAddStr(" Simulation size                         : ", self.c.getMagenta(), sim_size)

        return rc, dataframe
        # [end-function]
        # -------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Printers]
    #------------------------------------------------------------------------
    def printFileNames(self):
        rc = self.c.get_RC_SUCCESS()

        return rc
    #------------------------------------------------------------------------
#----------------------------------------------------------------------------
# end of Bencher class
#----------------------------------------------------------------------------
