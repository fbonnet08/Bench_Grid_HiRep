#!/usr/bin/env python3
'''!\file
   -- DataManage addon: (Python3 code) class for handling MZMine files
      \author Frederic Bonnet
      \date 03rd of March 2024

      Universite de Perpignan March 2024, OBS

Name:
---
Command_line: class MZmineModel_Analyser for analyzing raw files, can be called
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
#import datetime
import os
#import operator

import numpy
import pandas
import seaborn
# plotting imports
import matplotlib.pyplot
import matplotlib.dates
import IPython

# Path extension
sys.path.append(os.path.join(os.getcwd(), '.'))
sys.path.append(os.path.join(os.getcwd(), '..'))
sys.path.append(os.path.join(os.getcwd(), '..','..'))
sys.path.append(os.path.join(os.getcwd(), '..','..','src','PythonCodes'))
sys.path.append(os.path.join(os.getcwd(), '..','..','src','PythonCodes','utils'))
#Application imports
#import src.PythonCodes.DataManage_common

# Definiton of the constructor
class LatticeModel_Analyser:
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
                            self.c.getGreen(), "LatticeModel_Analyser")
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

        # print("basename: ", basename)

        # printing the files:
        self.printFileNames()
        #--------------------------------------------------------------------
        # [Constructor-end] end of the constructor
        #--------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Driver]
    #------------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Plotters]
    # -----------------------------------------------------------------------
    # -----------------------------------------------------------------------
    # -----------------------------------------------------------------------
    def plot_Sombrero_AllCases_strength_Nodes_mach(self,
                                                   dataframe_sombrero_small_mach,
                                                   dataframe_sombrero_large_mach,
                                                   batch_act, mach_name,
                                                   start_key_cases_sombrero_lst,
                                                   is_float):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Getting target file list      :", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------
        # Setting up the axis labels
        x_label = self.c.getXaxis_label()
        y_label = self.c.getYaxis_label()
        # Define the cases
        cases = ["Case 1", "Case 2", "Case 3", "Case 4", "Case 5", "Case 6"]
        # Define relevant columns
        columns = ["Case", "nodes", "ntpns", "Gflops_per_seconds", "Gflops_in_seconds", "lattice_sz", "mpi_distribution"]

        # Filter data efficiently using `.loc[]` and `.copy()`
        df_sombrero_small_mach = {case: dataframe_sombrero_small_mach.loc[dataframe_sombrero_small_mach["Case"] == case, columns].copy() for case in cases}
        df_sombrero_large_mach = {case: dataframe_sombrero_large_mach.loc[dataframe_sombrero_large_mach["Case"] == case, columns].copy() for case in cases}

        # Combine all cases into a single DataFrame and add a 'Machine' column
        df_sombrero_small_mach_all = pandas.concat(df_sombrero_small_mach.values(), ignore_index=True).assign(Simul_size="Small")
        df_sombrero_large_mach_all = pandas.concat(df_sombrero_large_mach.values(), ignore_index=True).assign(Simul_size="Large")

        # converting the
        if is_float == "with_float":
            df_sombrero_small_mach_all[y_label] = df_sombrero_small_mach_all[y_label].astype(float)
            df_sombrero_large_mach_all[y_label] = df_sombrero_large_mach_all[y_label].astype(float)
        #[end-if [is_float]]

        # Merge small and large Simul_size data
        df_combined = pandas.concat([df_sombrero_small_mach_all, df_sombrero_large_mach_all], ignore_index=True)

        # Print to check if data is structured correctly
        print(df_combined.head())
        # Ensure the combined DataFrame is ready
        df_combined["lattice_sz"] = df_combined["lattice_sz"].astype(str)  # Convert lattice size to string for grouping

        # Plot each case separately
        cases = df_combined["Case"].unique()
        if len(start_key_cases_sombrero_lst[:]) != len(cases[:]):
            self.m.printMesgAddStr("List length for cases !=   --->: ", self.c.getRed(), len(cases[:]))
            self.m.printMesgAddStr("List length for cases !=   --->: ", self.c.getRed(), len(start_key_cases_sombrero_lst[:]))
        # [end-if]
        cnt = 0
        # Plot each case separately
        for case in cases:
            case_df = df_combined[df_combined["Case"] == case]

            # Setting the plot
            matplotlib.pyplot.figure(figsize=(12, 6))
            # Line plot to connect points of the same lattice size
            ax = seaborn.lineplot(
                data=case_df,
                x=x_label,
                y=y_label,
                hue="lattice_sz",  # Different lines for different lattice sizes
                style="Simul_size",# Different line styles for Small/Large Simul_size
                markers=True,      # Show markers at data points
                dashes=False,      # Use solid lines
                linewidth=2.5,
                palette="tab10"
            )
            # Scatter plot to overlay actual points
            seaborn.scatterplot(
                data=case_df,
                x=x_label,
                y=y_label,
                hue="mpi_distribution",   # Same hue for consistency
                style="mpi_distribution", # Ensure marker styles match
                size="ntpns",             # Point size based on ntpns
                edgecolor="black",
                alpha=0.8,
                legend=False,             # Avoid duplicate legends
                palette="tab10"
            )
            # Add values on data points (Gflops_per_seconds)
            for i, row in case_df.iterrows():
                # Label the ntpns on the graph
                matplotlib.pyplot.text(row[x_label], row[y_label], f'{row["ntpns"]}',
                                       ha='center', va='bottom', fontsize=7, fontweight='bold', color='black')
                # Label the ntpns on the graph
                matplotlib.pyplot.text(row[x_label], row[y_label], f'{row["mpi_distribution"]}',
                                       ha='right', va='top', fontsize=8, fontweight='bold', color='black')
                # Label the nodes on the graph
                #matplotlib.pyplot.text(row[x_label], row[y_label], f':{row["lattice_sz"]}',
                #                       ha='left', va='top', fontsize=8, fontweight='bold', color='black')
            # [end-for-loop [i, row]]

            # Titles and labels
            matplotlib.pyplot.title("["+batch_act + "], "    + \
                                    f"{case}" + ", [" + str(mach_name) + "], " + \
                                    str(start_key_cases_sombrero_lst[cnt]), fontsize=14, fontweight='bold')
            matplotlib.pyplot.xlabel(x_label, fontsize=12, fontweight='bold', color="darkgreen")
            matplotlib.pyplot.ylabel(y_label, fontsize=12, fontweight='bold', color="darkred")

            # Adjust legend
            matplotlib.pyplot.legend(title="Lattice Size / Simulation size", fontsize=10, loc="upper left", bbox_to_anchor=(1, 1))
            matplotlib.pyplot.xticks(rotation=45, fontsize=10)
            matplotlib.pyplot.yticks(fontsize=10)
            matplotlib.pyplot.grid(True, linestyle="--", color='gray')

            matplotlib.pyplot.tight_layout()  # Ensure proper layout

            # Check whether the specified path exists or not
            plot_dir = "Plots"
            rc = self.check_directory_if_exists(plot_dir)

            message = batch_act  + "_" + case + "_" + str(is_float) + "_" + "nodes" # + "_" + sim_size  #+ "_" + "node002"

            png_out_filename = "plot_ScatterPlot_" + \
                               str(message) + "_" + \
                               str(self.c.getYaxis_label()).replace(" ","_").replace("/","").replace("(","").replace(")","") + \
                               "_" + \
                               str(mach_name) + ".png"
            output_file = os.path.join(plot_dir, png_out_filename)
            # print("png_out_filename --->: ", png_out_filename)
            self.m.printMesgAddStr("Grouped Bar plot saved to  --->: ", self.c.getMagenta(), output_file)
            #base_width = 300
            matplotlib.pyplot.savefig(output_file) #, dpi=base_width)

            # incrementing the counter on the list
            cnt += 1

            #matplotlib.pyplot.show()
        # [end-for-loop [case]]
        IPython.display.display(case_df)

        return rc
        # [end-function]
        # --------------------------------------------------------------------------

    def plot_Sombrero_AllCases_strength_scatterPlot_mach(self,
                                                        dataframe_sombrero_small,
                                                        dataframe_sombrero_large,
                                                        batch_act, mach_name,
                                                        start_key_cases_sombrero_lst,
                                                        is_float):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Plotting AllCases ScatterPlot :", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------
        # Define the cases
        cases = ["Case 1", "Case 2", "Case 3", "Case 4", "Case 5", "Case 6"]

        # Define relevant columns
        columns = ["Case", "nodes", "ntpns", "Gflops_per_seconds", "Gflops_in_seconds", "lattice_sz", "mpi_distribution"]

        # Filter data efficiently using `.loc[]` and `.copy()`
        df_sombrero_small = {case: dataframe_sombrero_small.loc[dataframe_sombrero_small["Case"] == case, columns].copy() for case in cases}
        df_sombrero_large = {case: dataframe_sombrero_large.loc[dataframe_sombrero_large["Case"] == case, columns].copy() for case in cases}

        # Combine all cases into a single DataFrame and add a 'Machine' column
        df_sombrero_small_all = pandas.concat(df_sombrero_small.values(), ignore_index=True).assign(Simul_size="Small")
        df_sombrero_large_all = pandas.concat(df_sombrero_large.values(), ignore_index=True).assign(Simul_size="Large")

        # Merge small and large Simul_size data
        df_combined = pandas.concat([df_sombrero_small_all, df_sombrero_large_all], ignore_index=True)

        # Print to check if data is structured correctly
        print(df_combined.head())
        # Ensure the combined DataFrame is ready
        df_combined["lattice_sz"] = df_combined["lattice_sz"].astype(str)  # Convert lattice size to string for grouping
        if is_float == "with_float":
            df_combined['Gflops_per_seconds'] = df_combined['Gflops_per_seconds'].astype(float)

        # Plot each case separately
        cases = df_combined["Case"].unique()
        if len(start_key_cases_sombrero_lst[:]) != len(cases[:]):
            self.m.printMesgAddStr("List length for cases !=   --->: ", self.c.getRed(), len(cases[:]))
            self.m.printMesgAddStr("List length for cases !=   --->: ", self.c.getRed(), len(start_key_cases_sombrero_lst[:]))
        # [end-if]
        cnt = 0
        # Plot each case separately
        for case in cases:
            matplotlib.pyplot.figure(figsize=(12, 6))
            case_df = df_combined[df_combined["Case"] == case]

            # Line plot to connect points of the same lattice size
            ax = seaborn.lineplot(
                data=case_df,
                x="mpi_distribution",
                y="Gflops_per_seconds",
                hue="lattice_sz",  # Different lines for different lattice sizes
                style="Simul_size",# Different line styles for Small/Large Simul_size
                markers=True,      # Show markers at data points
                dashes=False,      # Use solid lines
                linewidth=2.5,
                palette="tab10"
            )

            # Scatter plot to overlay actual points
            seaborn.scatterplot(
                data=case_df,
                x="mpi_distribution",
                y="Gflops_per_seconds",
                hue="lattice_sz",   # Same hue for consistency
                style="Simul_size", # Ensure marker styles match
                size="ntpns",       # Point size based on ntpns
                edgecolor="black",
                alpha=0.8,
                legend=False,       # Avoid duplicate legends
                palette="tab10"
            )
            # Add values on data points (Gflops_per_seconds)
            for i, row in case_df.iterrows():
                # Label the ntpns on the graph
                matplotlib.pyplot.text(row["mpi_distribution"], row["Gflops_per_seconds"], f'{row["ntpns"]}',
                                    ha='center', va='bottom', fontsize=5, fontweight='bold', color='black')
                # Label the ntpns on the graph
                matplotlib.pyplot.text(row["mpi_distribution"], row["Gflops_per_seconds"], f'{row["Gflops_per_seconds"]}',
                                    ha='right', va='top', fontsize=6, fontweight='bold', color='black')
                # Label the nodes on the graph
                matplotlib.pyplot.text(row["mpi_distribution"], row["Gflops_per_seconds"], f':{row["nodes"]}',
                                    ha='left', va='top', fontsize=6, fontweight='bold', color='black')
            # [end-for-loop [i, row]]

            # Titles and labels
            matplotlib.pyplot.title("["+batch_act + "], "    + \
                                    f"{case}" + ", [" + str(mach_name) + "], " + \
                                    str(start_key_cases_sombrero_lst[cnt]), fontsize=14, fontweight='bold')
            matplotlib.pyplot.xlabel("MPI Distribution", fontsize=12, fontweight='bold', color="darkgreen")
            matplotlib.pyplot.ylabel("Gflops per Seconds", fontsize=12, fontweight='bold', color="darkred")

            # Adjust legend
            matplotlib.pyplot.legend(title="Lattice Size / Simulation size", fontsize=10, loc="upper left", bbox_to_anchor=(1, 1))
            matplotlib.pyplot.xticks(rotation=45, fontsize=10)
            matplotlib.pyplot.yticks(fontsize=10)
            matplotlib.pyplot.grid(True, linestyle="--", alpha=0.5)

            matplotlib.pyplot.tight_layout()  # Ensure proper layout

            # getting the plots to disk
            plot_dir = "Plots"
            self.check_directory_if_exists(plot_dir)

            message = batch_act  + "_" + str(case).replace(" ","-") + "_" + str(is_float)

            png_out_filename = "plot_ScatterPlot_" + \
                                str(message) + "_" + \
                                str(self.c.getYaxis_label()).replace(" ","_").replace("/","").replace("(","").replace(")","") + \
                                "_" + \
                                str(mach_name) + ".png"
            output_file = os.path.join(plot_dir, png_out_filename)
            # print("png_out_filename --->: ", png_out_filename)
            self.m.printMesgAddStr(" Grouped Bar plot saved to --->: ", self.c.getMagenta(), output_file)
            #base_width = 300
            matplotlib.pyplot.savefig(output_file) #, dpi=base_width)

            # incrementing the counter on the list
            cnt += 1

            #matplotlib.pyplot.show()
        # [end-for-loop [case]]

        return rc
        # [end-function]
        # --------------------------------------------------------------------------

    # ----------------------------------------------------------------------------
    def plot_Sombrero_AllCases_strength_mach(self,
                                             dataframe_sombrero_small, dataframe_sombrero_large,
                                             batch_act, mach_name,
                                             start_key_cases_sombrero_lst,
                                             is_float):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Getting target file list      :", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------
        #print("bach_act   --->: ", bach_act)
        #print("mach_name  --->: ", mach_name)

        #IPython.display.display(dataframe_sombrero_small_mach)
        #IPython.display.display(dataframe_sombrero_large_mach)
        # ----------------------------------------------------------------------
        cases = ["Case 1", "Case 2", "Case 3", "Case 4", "Case 5", "Case 6"] # start_key_cases_sombrero_lst
        print(cases[:])#
        columns = ["Case", "nodes", "ntpns", "Gflops_per_seconds", "Gflops_in_seconds", "lattice_sz", "mpi_distribution"]

        df_sombrero_small = {case: dataframe_sombrero_small[dataframe_sombrero_small["Case"] == case][columns] for case in cases}
        df_sombrero_large = {case: dataframe_sombrero_large[dataframe_sombrero_large["Case"] == case][columns] for case in cases}

        # Combine both dataframes and add a 'Simul_size' column
        df_sombrero_small_all = pandas.concat(df_sombrero_small.values()).assign(Simul_size="Small")
        df_sombrero_large_all = pandas.concat(df_sombrero_large.values()).assign(Simul_size="Large")

        IPython.display.display(df_sombrero_small_all)
        IPython.display.display(df_sombrero_large_all)

        # Merge both into one DataFrame
        df_combined = pandas.concat([df_sombrero_small_all, df_sombrero_large_all])

        df_combined["lattice_sz"] = df_combined["lattice_sz"].astype(str)  # Convert lattice size to string for grouping
        if is_float == "with_float":
            df_combined['Gflops_per_seconds'] = df_combined['Gflops_per_seconds'].astype(float)

        # Plot each case separately
        cases = df_combined["Case"].unique()
        if len(start_key_cases_sombrero_lst[:]) != len(cases[:]):
            self.m.printMesgAddStr("List length for cases !=   --->: ", self.c.getRed(), len(cases[:]))
            self.m.printMesgAddStr("List length for cases !=   --->: ", self.c.getRed(), len(start_key_cases_sombrero_lst[:]))
        # [end-if]

        cnt = 0
        for case in cases:
            matplotlib.pyplot.figure(figsize=(15, 10))
            case_df = df_combined[df_combined["Case"] == case]
            ax = seaborn.barplot(
                data=case_df,
                x="mpi_distribution",
                y="Gflops_per_seconds",
                hue="Simul_size",
                palette="viridis"
            )
            # Scatter plot to overlay actual points
            seaborn.scatterplot(
                data=case_df,
                x="mpi_distribution",
                y="Gflops_per_seconds",
                hue="lattice_sz",   # Same hue for consistency
                style="Simul_size", # Ensure marker styles match
                size="ntpns",       # Point size based on ntpns
                edgecolor="black",
                alpha=0.8,
                legend=True,       # Avoid duplicate legends
                palette="tab10"
            )

            # Add values on data points (Gflops_per_seconds)
            for i, row in case_df.iterrows():
                # Label the ntpns on the graph
                matplotlib.pyplot.text(row["mpi_distribution"], row["Gflops_per_seconds"], f'{row["ntpns"]}',
                                       ha='center', va='bottom', fontsize=5, fontweight='bold', color='black')
                # Label the ntpns on the graph
                matplotlib.pyplot.text(row["mpi_distribution"], row["Gflops_per_seconds"], f'{row["Gflops_per_seconds"]}',
                                       ha='right', va='top', fontsize=6, fontweight='bold', color='black')
                # Label the nodes on the graph
                matplotlib.pyplot.text(row["mpi_distribution"], row["Gflops_per_seconds"], f':{row["nodes"]}',
                                       ha='left', va='top', fontsize=6, fontweight='bold', color='black')
            # [end-for-loop [i, row]]

            matplotlib.pyplot.title("["+batch_act + "], "    + \
                                    f"{case}" + ", [" + str(mach_name) + "], " + \
                                    str(start_key_cases_sombrero_lst[cnt]), fontsize=14, fontweight='bold')
            matplotlib.pyplot.xlabel("MPI Distribution", fontsize=12, fontweight='bold', color="darkgreen")
            matplotlib.pyplot.ylabel("Gflops per Seconds", fontsize=12, fontweight='bold', color="darkred")
            matplotlib.pyplot.legend(title="Simulation size")
            matplotlib.pyplot.xticks(rotation=45, fontsize=10)
            matplotlib.pyplot.yticks(fontsize=10)

            matplotlib.pyplot.grid(True, linestyle="--", alpha=0.5)

            matplotlib.pyplot.tight_layout()  # Ensure proper layout

            # getting the plots to disk
            plot_dir = "Plots"
            self.check_directory_if_exists(plot_dir)

            message = batch_act  + "_" + str(case).replace(" ","-") + "_" + str(is_float)

            png_out_filename = "plot_GroupedBars_" + \
                               str(message) + "_" + \
                               str(self.c.getYaxis_label()).replace(" ","_").replace("/","").replace("(","").replace(")","") + \
                               "_" + \
                               str(mach_name) + ".png"
            output_file = os.path.join(plot_dir, png_out_filename)
            # print("png_out_filename --->: ", png_out_filename)
            self.m.printMesgAddStr(" Grouped Bar plot saved to --->: ", self.c.getMagenta(), output_file)
            #base_width = 300
            matplotlib.pyplot.savefig(output_file) #, dpi=base_width)

            #matplotlib.pyplot.show()
            # incrementing the counter on the list
            cnt += 1
            # [end-for-loop [case]]

        return rc
        # [end-function]
        # ------------------------------------------------------------------------
    # ----------------------------------------------------------------------------
    def plot_Sombrero_AllCases_weak_ByLatticeSz_scatterPlot_mach(self, dataframe_sombrero,
                                                                batch_act, sim_sz, mach_name,
                                                                start_key_cases_sombrero_lst,
                                                                is_float):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Getting target file list      :", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------
        # Define the cases
        cases_lst = ["Case 1", "Case 2", "Case 3", "Case 4", "Case 5", "Case 6"]
        print("cases_lst[:] ---->: ", cases_lst[:])
        # Define relevant columns
        columns_lst = ["Case", "nodes", "ntpns", "Gflops_per_seconds", "Gflops_in_seconds", "lattice_sz", "mpi_distribution"]
        # Define the lattices
        print(" Now getting the lattice sizes from df_sombrero_small_mach")
        lattice_lst = dataframe_sombrero['lattice_sz'].unique().tolist()
        cases_lst   = dataframe_sombrero['Case'].unique().tolist()
        nodes_lst   = dataframe_sombrero['nodes'].unique().tolist()
        ntpns_lst   = dataframe_sombrero['ntpns'].unique().tolist()

        print("lattice_lst[:]       --->: ", lattice_lst[:])
        print("cases_lst[:]         --->: ", cases_lst[:])
        print("nodes_lst[:]         --->: ", nodes_lst[:])
        print("ntpns_lst[:]         --->: ", ntpns_lst[:])
        print("\n")

        # Filter data efficiently using `.loc[]` and `.copy()`
        df_sombrero = {case: dataframe_sombrero.loc[dataframe_sombrero["Case"] == case, columns_lst].copy() for case in cases_lst}

        print("small")
        IPython.display.display(df_sombrero)

        #arg_list=repr(tuple(fields)).replace("'", "")[1:-1]
        plot_dir = "Plots"
        self.check_directory_if_exists(plot_dir)

        # setting the main axis labels
        x_label = "mpi_distribution"
        y_label = "Gflops_per_seconds"

        self.c.setXaxis_label(x_label)
        self.c.setYaxis_label(y_label)
        #columns_small_lat_lst[0]  'lattice_sz'

        if len(start_key_cases_sombrero_lst[:]) != len(cases_lst[:]):
            self.m.printMesgAddStr("List length for cases !=   --->: ", self.c.getRed(), len(cases_lst[:]))
            self.m.printMesgAddStr("List length for cases !=   --->: ", self.c.getRed(), len(start_key_cases_sombrero_lst[:]))
        # [end-if]
        cnt_case = 0
        for case in cases_lst[:]:
            #print(lattice)
            print(case)
            df_sombrero_case = df_sombrero[case]

            for node in nodes_lst[:]:
                print (node)
                df_sombrero_case_node = df_sombrero_case[
                    df_sombrero_case['nodes'] == node][["mpi_distribution", "Gflops_per_seconds", "ntpns"]]

                for ntpns in ntpns_lst[:]:
                    df_sombrero_case_node_ntpns = df_sombrero_case_node[
                        df_sombrero_case_node['ntpns'] == ntpns][["mpi_distribution", "Gflops_per_seconds"]]
                # [end-for-loop [ntpns]]
            # [end-for-loop [node]]
            # --------------------------------------------------------------
            # plotting for each and for
            # --------------------------------------------------------------
            if is_float == "with_float":
                df_sombrero_case['Gflops_per_seconds'] = df_sombrero_case['Gflops_per_seconds'].astype(float)

            matplotlib.pyplot.figure(figsize=(15, 10))

            # Create bar plot
            seaborn.lineplot(
                data=df_sombrero_case,
                x="mpi_distribution",
                y="Gflops_per_seconds",
                hue="ntpns",
                marker="o",
                linewidth=2,
                markersize=8
            )

            # Add values on data points (Gflops_per_seconds)
            for i, row in df_sombrero_case.iterrows():
                # Label the nodes on the graph
                matplotlib.pyplot.text(row["mpi_distribution"], row["Gflops_per_seconds"], f'{row["lattice_sz"]}',
                                        ha='right', va='top', fontsize=6, fontweight='bold', color='black')
                # Label the nodes on the graph
                matplotlib.pyplot.text(row["mpi_distribution"], row["Gflops_per_seconds"], f'{row["Gflops_per_seconds"]}',
                                        ha='right', va='bottom', fontsize=7, fontweight='bold', color='black')
                # Label the nodes on the graph
                matplotlib.pyplot.text(row["mpi_distribution"], row["Gflops_per_seconds"], f':{row["nodes"]}',
                                        ha='left', va='bottom', fontsize=7, fontweight='bold', color='black')
            # [end-for-loop [i, row]]

            # Add labels and title
            matplotlib.pyplot.title("["+batch_act+"-"+sim_sz+"], "    + \
                                    case+", [" + str(mach_name)+"], " + \
                                    start_key_cases_sombrero_lst[cnt_case])
            #matplotlib.pyplot.yscale("log")
            matplotlib.pyplot.xlabel("MPI Distribution",   fontsize=12, fontweight='bold', color="darkgreen")
            matplotlib.pyplot.ylabel("Gflops per Seconds", fontsize=12, fontweight='bold', color="darkred")
            matplotlib.pyplot.legend(title="ntpns")
            matplotlib.pyplot.xticks(rotation=45, fontsize=10)
            matplotlib.pyplot.yticks(fontsize=10)
            # --------------------------------------------------------------
            # Setting up the output
            # --------------------------------------------------------------
            message = batch_act + "_" + sim_sz + "_" + str(case).replace(" ","-") + \
                        "_" + "nodes"  + "_" + "lattice" + "_" + str(is_float)

            #print("msg ---->: ", msg)
            self.m.printMesgAddStr("Output message             --->: ", self.c.getMagenta(), message)
            png_out_filename = "plot_LinePlot_weak_" + str(message) + "_" + \
                                str(self.c.getYaxis_label()).replace(" ","_").replace("/","").replace("(","").replace(")","") + \
                                "_" + str(mach_name) + ".png"
            # print("png_out_filename --->: ", png_out_filename)
            output_file = os.path.join(plot_dir, png_out_filename)
            self.m.printMesgAddStr(" Lineplot saved to         --->: ", self.c.getMagenta(), output_file)
            #base_width = 300
            matplotlib.pyplot.savefig(output_file) #, dpi=base_width)
            # --------------------------------------------------------------
            # Getting the plots out to screen and to file.
            # --------------------------------------------------------------
            # Show the plot
            #matplotlib.pyplot.show()
            # --------------------------------------------------------------
            # Incrementing hte case counter for the graph title
            # --------------------------------------------------------------
            cnt_case += 1
        # ------------------------------------------------------------------
        # [end-for-loop [case]]
        # ------------------------------------------------------------------
        # [end-for-loop [lattice]]
        print(" The dataframe ---->:  df_sombrero_case")
        IPython.display.display(df_sombrero_case)

        print(" The dataframe ---->:  df_sombrero_case_node")
        IPython.display.display(df_sombrero_case_node)

        print(" The dataframe ---->:  df_sombrero_case_node_ntpns")
        IPython.display.display(df_sombrero_case_node_ntpns)

        return rc
        # [end-function]
        # --------------------------------------------------------------------------
    # ----------------------------------------------------------------------------
    def plot_Sombrero_AllCases_strong_ByLatticeSz_scatterPlot_mach(self, dataframe_sombrero,
                                                                   batch_act, sim_sz, mach_name,
                                                                   start_key_cases_sombrero_lst,
                                                                   is_float):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Getting target file list      :", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------
        # Define the cases
        cases_lst = ["Case 1", "Case 2", "Case 3", "Case 4", "Case 5", "Case 6"]
        print("cases_lst[:] ---->: ", cases_lst[:])
        # Define relevant columns
        columns_lst = ["Case", "nodes", "ntpns", "Gflops_per_seconds", "Gflops_in_seconds", "lattice_sz", "mpi_distribution"]
        # Define the lattices
        print(" Now getting the lattice sizes from df_sombrero_small_mach")
        lattice_lst = dataframe_sombrero['lattice_sz'].unique().tolist()
        cases_lst   = dataframe_sombrero['Case'].unique().tolist()
        nodes_lst   = dataframe_sombrero['nodes'].unique().tolist()
        ntpns_lst   = dataframe_sombrero['ntpns'].unique().tolist()

        print("lattice_lst[:]       --->: ", lattice_lst[:])
        print("cases_lst[:]         --->: ", cases_lst[:])
        print("nodes_lst[:]         --->: ", nodes_lst[:])
        print("ntpns_lst[:]         --->: ", ntpns_lst[:])
        print("\n")

        # Filter data efficiently using `.loc[]` and `.copy()`
        df_sombrero = {case: dataframe_sombrero.loc[
            dataframe_sombrero["Case"] == case,
            columns_lst].copy() for case in cases_lst}

        print("small")
        IPython.display.display(df_sombrero)
        IPython.display.display(df_sombrero[cases_lst[5]][df_sombrero[cases_lst[5]]['lattice_sz'] == lattice_lst[0]])

        #arg_list=repr(tuple(fields)).replace("'", "")[1:-1]
        plot_dir = "Plots"
        self.check_directory_if_exists(plot_dir)

        # setting the main axis labels
        x_label = "mpi_distribution"
        y_label = "Gflops_per_seconds"

        self.c.setXaxis_label(x_label)
        self.c.setYaxis_label(y_label)
        #columns_small_lat_lst[0]  'lattice_sz'
        for lattice in lattice_lst:
            print(lattice)

            if len(start_key_cases_sombrero_lst[:]) != len(cases_lst[:]):
                self.m.printMesgAddStr("List length for cases !=   --->: ", self.c.getRed(), len(cases_lst[:]))
                self.m.printMesgAddStr("List length for cases !=   --->: ", self.c.getRed(), len(start_key_cases_sombrero_lst[:]))
            # [end-if]
            cnt_case = 0
            for case in cases_lst[:]:
                print(lattice)
                print(case)
                df_sombrero_lattice_case = df_sombrero[case][
                    df_sombrero[case]['lattice_sz'] == lattice][["Case", "nodes", "ntpns", "Gflops_per_seconds", "Gflops_in_seconds", "mpi_distribution"]]

                for node in nodes_lst[:]:
                    print (node)
                    df_sombrero_lattice_case_node = df_sombrero_lattice_case[
                        df_sombrero_lattice_case['nodes'] == node][["mpi_distribution", "Gflops_per_seconds", "ntpns"]]

                    for ntpns in ntpns_lst[:]:
                        df_sombrero_lattice_case_node_ntpns = df_sombrero_lattice_case_node[
                            df_sombrero_lattice_case_node['ntpns'] == ntpns][["mpi_distribution", "Gflops_per_seconds"]]
                    # [end-for-loop [ntpns]]
                # [end-for-loop [node]]
                # --------------------------------------------------------------
                # plotting for each and for
                # --------------------------------------------------------------
                if is_float == "with_float":
                    df_sombrero_lattice_case['Gflops_per_seconds'] = df_sombrero_lattice_case['Gflops_per_seconds'].astype(float)

                matplotlib.pyplot.figure(figsize=(15, 10))

                # Create bar plot
                seaborn.lineplot(
                    data=df_sombrero_lattice_case,
                    x="mpi_distribution",
                    y="Gflops_per_seconds",
                    hue="ntpns",
                    marker="o",
                    linewidth=2,
                    markersize=8
                )

                # Add values on data points (Gflops_per_seconds)
                for i, row in df_sombrero_lattice_case.iterrows():
                    matplotlib.pyplot.text(row["mpi_distribution"], row["Gflops_per_seconds"], f'{row["Gflops_per_seconds"]}',
                                        ha='right', va='bottom', fontsize=8, fontweight='bold', color='black')

                    # Label the nodes on the graph
                    matplotlib.pyplot.text(row["mpi_distribution"], row["Gflops_per_seconds"], f'Nodes: {row["nodes"]}',
                                        ha='left', va='bottom', fontsize=8, fontweight='bold', color='black')
                # [end-for-loop [i, row]]

                # Add labels and title
                matplotlib.pyplot.xlabel("MPI Distribution",   fontsize=12, fontweight='bold', color="darkgreen")
                matplotlib.pyplot.ylabel("Gflops per Seconds", fontsize=12, fontweight='bold', color="darkred")
                matplotlib.pyplot.xticks(rotation=45)  # Rotate labels by 45 degrees
                matplotlib.pyplot.title("["+batch_act+"-"+sim_sz+"], "    + \
                                        case+", [" + str(mach_name)+"], " + \
                                        start_key_cases_sombrero_lst[cnt_case] + ", " + lattice)
                matplotlib.pyplot.legend(title="ntpns")
                # --------------------------------------------------------------
                # Setting up the output
                # --------------------------------------------------------------
                message = batch_act + "_" + sim_sz + "_" + str(case).replace(" ","-") + \
                            "_" + "nodes" + "_"  + \
                            str(str("lat"+str(lattice)).replace(" ","")).replace("x",".") + "_" + str(is_float)

                self.m.printMesgAddStr("Output message             --->: ", self.c.getMagenta(), message)
                png_out_filename = "plot_LinePlot_" + str(message) + "_" + \
                                    str(self.c.getYaxis_label()).replace(" ","_").replace("/","").replace("(","").replace(")","") + \
                                    "_" + str(mach_name) + ".png"
                # print("png_out_filename --->: ", png_out_filename)
                output_file = os.path.join(plot_dir, png_out_filename)
                self.m.printMesgAddStr(" Lineplot saved to         --->: ", self.c.getMagenta(), output_file)
                #base_width = 300
                matplotlib.pyplot.savefig(output_file) #, dpi=base_width)
                # --------------------------------------------------------------
                # Getting the plots out to screen and to file.
                # --------------------------------------------------------------
                # Show the plot
                #matplotlib.pyplot.show()
                # --------------------------------------------------------------
                # Incrementing hte case counter for the graph title
                # --------------------------------------------------------------
                cnt_case += 1
            # ------------------------------------------------------------------
            # [end-for-loop [case]]
            # ------------------------------------------------------------------
        # [end-for-loop [node]]
        print(" The dataframe ---->:  df_sombrero_lattices_case")
        IPython.display.display(df_sombrero_lattice_case)

        print(" The dataframe ---->:  df_sombrero_lattice_case_node")
        IPython.display.display(df_sombrero_lattice_case_node)

        print(" The dataframe ---->:  df_sombrero_lattice_case_node_ntpns")
        IPython.display.display(df_sombrero_lattice_case_node_ntpns)

        return rc
        # [end-function]
        # --------------------------------------------------------------------------
    def plot_BenchRes_SuccessFailure_pieChart_matplotlib(self,
                                                         cluster_lst,
                                                         cluster_filtered_lst,
                                                         mach_name, message):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Getting target file list      :", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------
        total_cluster = len(cluster_lst)
        total_cluster_filtered = len(cluster_filtered_lst)
        self.m.printMesgAddStr("len(cluster_lst[:])          --->: ", self.c.getYellow(), str(total_cluster))
        self.m.printMesgAddStr("len(cluster_filtered_lst[:]) --->: ", self.c.getGreen(), str(total_cluster_filtered))
        failed_lst = []
        failed_lst.clear()
        for i in range(len(cluster_lst[:])):
            if cluster_lst[i] not in cluster_filtered_lst:
                failed_lst.append(cluster_lst[i])
            # [end-if]
        # [end-loop[i]]
        # Length of the failed runs
        total_cluster_failed = len(failed_lst[:])
        # Data to plot
        labels = ['Total Runs', 'Total filtered Runs', 'Total failed Runs']
        sizes = [total_cluster, total_cluster_filtered, total_cluster_failed ]
        colors = ['blue', 'green', 'red']
        explode = (0, 0, 0.1)  # Highlight Failed Runs

        # Plot
        matplotlib.pyplot.figure(figsize=(8, 8))
        matplotlib.pyplot.pie(sizes,
                              labels=labels, autopct='%1.1f%%',
                              colors=colors, explode=explode, shadow=True, startangle=140)

        matplotlib.pyplot.title("["+str(mach_name)+"] "+str(message) + " ---> Failed Runs")

        #arg_list=repr(tuple(fields)).replace("'", "")[1:-1]
        plot_dir = "Plots"
        self.check_directory_if_exists(plot_dir)

        # output to file
        png_out_filename = "plot_PieChart_" + \
                           str(message) + "_" + \
                           str("FailedRuns") + \
                           "_" + \
                           str(mach_name) + ".png"
        output_file = os.path.join(plot_dir, png_out_filename)
        # print("png_out_filename --->: ", png_out_filename)
        self.m.printMesgAddStr("Grouped Bar plot saved to    --->: ", self.c.getMagenta(), output_file)
        base_width = 300
        matplotlib.pyplot.savefig(output_file, dpi=base_width)

        #matplotlib.pyplot.show()
        # Summary
        self.m.printMesgAddStr("Failed cluster lst           --->: ", self.c.getYellow(), failed_lst[:])
        self.m.printMesgAddStr("len(cluster_failed_lst)      --->: ", self.c.getRed(), str(total_cluster_failed))
        # Now plotting the pie chart.

        return rc, failed_lst[:]
        # [end-function]
        # ------------------------------------------------------------------------



    # ----------------------------------------------------------------------------
    def plot_BenchRes_group_Nodes_Rep_matplotlib(self,
                                                 df_su2_adj_lat,
                                                 mach_name, message):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Getting target file list      :", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------

        lattice_lst = df_su2_adj_lat['lattice'].unique().tolist()
        columns = ["Representation", "CG Run Time (s)","mpi_distribution","nodes", "FlOp/S (GFlOp/s)"]
        df_su2_adj_lattices = {lattice: df_su2_adj_lat.loc[df_su2_adj_lat["lattice"] == lattice, columns].copy() for lattice in lattice_lst}

        IPython.display.display(df_su2_adj_lattices)

        # Check whether the specified path exists or not
        plot_dir = "Plots"
        rc = self.check_directory_if_exists(plot_dir)

        # setting the main axis labels
        x_label = self.c.getXaxis_label()
        y_label = self.c.getYaxis_label()

        print(x_label)
        print(y_label)
        cnt_lattice = 0
        for lattice in lattice_lst:
            print(lattice)

            # --------------------------------------------------------------
            # plotting for each and for
            # --------------------------------------------------------------
            matplotlib.pyplot.figure(figsize=(15, 10))

            # Create bar plot
            #seaborn.barplot(data=df_sombrero_small_mach_lattice_case, x="mpi_distribution", y="Gflops_per_seconds", hue="ntpns", palette="viridis")
            seaborn.lineplot(data=df_su2_adj_lattices[lattice],
                             x=x_label, y=y_label, hue="mpi_distribution", marker="o", linewidth=2, markersize=8)

            # Add values on data points (Gflops_per_seconds)
            for i, row in df_su2_adj_lattices[lattice].iterrows():
                matplotlib.pyplot.text(row[x_label], row[y_label], f'{row["mpi_distribution"]}',
                                       ha='center', va='top', fontsize=8, fontweight='bold', color='black')
                # Label the nodes on the graph
                matplotlib.pyplot.text(row[x_label], row[y_label], f'Nodes: {row["nodes"]}',
                                       ha='left', va='bottom', fontsize=8, fontweight='bold', color='black')
            # [end-for-loop [i, row]]

            # Add labels and title
            matplotlib.pyplot.xlabel(x_label, fontsize=12, fontweight='bold', color="darkgreen")
            matplotlib.pyplot.ylabel(y_label, fontsize=12, fontweight='bold', color="darkred")
            matplotlib.pyplot.xticks(rotation=45)  # Rotate labels by 45 degrees
            matplotlib.pyplot.title(message +", [" + str(mach_name) + "]" + ", " + str(lattice).replace(".","x"))
            matplotlib.pyplot.legend(title="mpi_distribution")
            matplotlib.pyplot.grid(True, linestyle='-.', color='gray')
            # --------------------------------------------------------------
            # Getting the plots out to screen and to file.
            # --------------------------------------------------------------
            # Now getting the plot onto disk
            png_out_filename = "plot_Grouped_" + \
                               str(message) + "_" + \
                               str(self.c.getXaxis_label()).replace(" ","_").replace("/","").replace("(","").replace(")","") + \
                               "_vs_" + \
                               str(self.c.getYaxis_label()).replace(" ","_").replace("/","").replace("(","").replace(")","") + \
                               "_" + \
                               "lat" + str(lattice).replace(".","x") + \
                               "_" + \
                               str(mach_name) + ".png"
            output_file = os.path.join(plot_dir, png_out_filename)
            # print("png_out_filename --->: ", png_out_filename)
            self.m.printMesgAddStr("Grouped FlopsCG saved to   --->: ", self.c.getMagenta(), output_file)
            base_width = 300
            matplotlib.pyplot.savefig(output_file, dpi=base_width)
            #matplotlib.pyplot.show()
            # --------------------------------------------------------------
            # Incrementing hte case counter for the graph title
            # --------------------------------------------------------------
            cnt_lattice += 1
        # [end-for-loop [lattice]]

        return rc
        # [end-function]
        # --------------------------------------------------------------------------



    # ----------------------------------------------------------------------------
    def plot_BenchRes_group_Nodes_matplotlib(self, scale,
                                             df_su2_adj_lat,
                                             df_su2_fun_lat,
                                             df_su3_fun_lat,
                                             mach_name, message):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Ploting group nodes           :", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------
        columns = ["Representation", "CG Run Time (s)","mpi_distribution","nodes", "FlOp/S (GFlOp/s)"]
        lattice_lst = df_su2_adj_lat['lattice'].unique().tolist()

        df_combined_lat = pandas.concat([df_su2_adj_lat, df_su2_fun_lat, df_su3_fun_lat], ignore_index=True)
        df_combined_lattices = {lattice: df_combined_lat.loc[df_combined_lat["lattice"] == lattice, columns].copy() for lattice in lattice_lst}

        # Check whether the specified path exists or not
        plot_dir = "Plots"
        rc = self.check_directory_if_exists(plot_dir)

        # setting the main axis labels
        x_label = self.c.getXaxis_label()
        y_label = self.c.getYaxis_label()

        cnt_lattice = 0
        custom_colors = seaborn.color_palette("hls", 3)
        for lattice in lattice_lst:
            print(lattice)
            # --------------------------------------------------------------
            # plotting for each and for
            # --------------------------------------------------------------
            #matplotlib.pyplot.figure(figsize=(15, 10))
            fig, ax = matplotlib.pyplot.subplots(figsize=(15, 10))
            seaborn.scatterplot(
                data=df_combined_lattices[lattice],
                x=x_label,
                y=y_label,
                hue="mpi_distribution",
                style="mpi_distribution",
                s=100,
                alpha=0.8,
                legend='full',        # Avoid duplicate legends
                palette="tab10"
            )
            seaborn.lineplot(
                data=df_combined_lattices[lattice],
                x=x_label,
                y=y_label,
                hue="Representation",  # Different lines for different lattice sizes
                style="Representation",# Different line styles for Small/Large Simul_size
                markers=True,          # Show markers at data points
                markersize=8,
                dashes=True,           # Use solid lines
                linewidth=2.5,
                legend='full',         # Avoid duplicate legends
                palette=custom_colors
            )
            for item, color in zip(df_combined_lattices[lattice].groupby('Representation'),custom_colors):
                #item[1] is a grouped data frame
                for x,y,m in item[1][[x_label, y_label, 'Representation']].values:
                    ax.text(x,y,m,color=color)
                # [end-for-loop [x,y,m]]
            #[end-for-loop [item,color]]

            # Add values on data points (Gflops_per_seconds)
            for i, row in df_combined_lattices[lattice].iterrows():
                matplotlib.pyplot.text(row[x_label], row[y_label], f'{row["mpi_distribution"]}',
                                       ha='center', va='top', fontsize=8, fontweight='bold', color='black')
            # [end-for-loop []i , row]
            # Add labels and title
            matplotlib.pyplot.xlabel(x_label, fontsize=12, fontweight='bold', color="darkgreen")
            matplotlib.pyplot.ylabel(y_label, fontsize=12, fontweight='bold', color="darkred")
            if scale == "log_scale":
                matplotlib.pyplot.yscale('log')
            # [end-if [scale]]
            matplotlib.pyplot.xticks(rotation=45)  # Rotate labels by 45 degrees
            matplotlib.pyplot.title(message +", [" + str(mach_name) + "]" + ", " + str(lattice).replace(".","x"))
            matplotlib.pyplot.legend(title="mpi_distribution")
            matplotlib.pyplot.grid(True, linestyle='-.', color='gray')
            # --------------------------------------------------------------
            # Getting the plots out to screen and to file.
            # --------------------------------------------------------------
            # Now getting the plot onto disk
            png_out_filename = "plot_Grouped_Nodes_" + \
                               str(message) + "_" + \
                               str(self.c.getXaxis_label()).replace(" ","_").replace("/","").replace("(","").replace(")","") + \
                               "_vs_" + \
                               str(self.c.getYaxis_label()).replace(" ","_").replace("/","").replace("(","").replace(")","") + \
                               "_" + \
                               "lat" + str(lattice).replace(".","x") + \
                               "_" + \
                               str(mach_name) + ".png"
            print("png_out_filename --->: ", png_out_filename)
            output_file = os.path.join(plot_dir, png_out_filename)
            print("output_file      --->: ", output_file)
            self.m.printMesgAddStr("Grouped Nodes saved to     --->: ", self.c.getMagenta(), output_file)
            base_width = 300
            matplotlib.pyplot.savefig(output_file, dpi=base_width)
            #matplotlib.pyplot.show()
            # --------------------------------------------------------------
            # Incrementing hte case counter for the graph title
            # --------------------------------------------------------------
            cnt_lattice += 1
        # [end-for-loop [lattice]]

        return rc
        # [end-function]
        # --------------------------------------------------------------------------

    # ----------------------------------------------------------------------------
    def plot_BenchRes_group_FlopsCG_matplotlib(self, scale,
                                               df_su2_adj_lat,
                                               df_su2_fun_lat,
                                               df_su3_fun_lat,
                                               batch_act, sim_sz, mach_name, message):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Plotting group Flops CG(s)    :", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------
        columns = ["Representation", "CG Run Time (s)","mpi_distribution","nodes", "FlOp/S (GFlOp/s)"]
        lattice_lst = df_su2_adj_lat['lattice'].unique().tolist()

        df_combined_lat = pandas.concat([df_su2_adj_lat, df_su2_fun_lat, df_su3_fun_lat], ignore_index=True)
        df_combined_lattices = {lattice: df_combined_lat.loc[df_combined_lat["lattice"] == lattice, columns].copy() for lattice in lattice_lst}

        # Check whether the specified path exists or not
        plot_dir = "Plots"
        rc = self.check_directory_if_exists(plot_dir)

        # setting the main axis labels
        x_label = self.c.getXaxis_label() #"FlOp/S (GFlOp/s)"
        y_label = self.c.getYaxis_label() #"CG Run Time (s)"

        cnt_lattice = 0
        custom_colors = seaborn.color_palette("hls", 3)
        for lattice in lattice_lst:
            print(lattice)
            # --------------------------------------------------------------
            # plotting for each and for
            # --------------------------------------------------------------
            #matplotlib.pyplot.figure(figsize=(15, 10))
            fig, ax = matplotlib.pyplot.subplots(figsize=(15, 10))
            custom_colors = seaborn.color_palette("hls", 3)
            seaborn.scatterplot(
                data=df_combined_lattices[lattice],
                x=x_label,
                y=y_label,
                hue="Representation",
                style="Representation",
                s=100,
                alpha=0.8,
                legend=True,            # Avoid duplicate legends
                palette="tab10"
            )
            seaborn.lineplot(
                data=df_combined_lattices[lattice],
                x=x_label,
                y=y_label,
                hue="Representation",   # Different lines for different lattice sizes
                style="Representation", # Different line styles for Small/Large Simul_size
                markers=False,          # Show markers at data points
                dashes=True,            # Use solid lines
                linewidth=2.5,
                legend=True,            # Avoid duplicate legends
                palette=custom_colors
            )
            # Add labels for each point
            for i, row in df_combined_lattices[lattice].iterrows():
                # Mpi_distribution
                matplotlib.pyplot.text(row[x_label], row[y_label], f"{row['mpi_distribution']}",
                                       ha='center', va='top', fontsize=8, fontweight='bold', color='black')
                # nodes labeling
                matplotlib.pyplot.text(row[x_label], row[y_label], f'Nodes: {row["nodes"]}',
                                       ha='left', va='bottom', fontsize=8, fontweight='bold', color='black')
            # [end-for-loop [i, row]]

            # Finalize the plot
            matplotlib.pyplot.title(f"[{mach_name}] {batch_act}_{sim_sz}_lat{str(lattice).replace(".","x")}")
            matplotlib.pyplot.xlabel(x_label, fontsize=12, fontweight='bold', color="darkgreen")
            matplotlib.pyplot.ylabel(y_label, fontsize=12, fontweight='bold', color="darkred")
            if scale == "log_scale":
                matplotlib.pyplot.yscale('log')
            matplotlib.pyplot.legend(title="Representation")
            matplotlib.pyplot.grid(True, linestyle='-.', color='gray')
            # --------------------------------------------------------------
            # Getting the plots out to screen and to file.
            # --------------------------------------------------------------
            # Now getting the plot onto disk
            png_out_filename = "plot_Grouped_" + \
                               str(message) + "_" + \
                               str(self.c.getXaxis_label()).replace(" ","_").replace("/","").replace("(","").replace(")","") + \
                               "_vs_" + \
                               str(self.c.getYaxis_label()).replace(" ","_").replace("/","").replace("(","").replace(")","") + \
                               "_" + \
                               "lat" + str(lattice).replace(".","x") + \
                               "_" + \
                               str(mach_name) + ".png"
            output_file = os.path.join(plot_dir, png_out_filename)
            # print("png_out_filename --->: ", png_out_filename)
            self.m.printMesgAddStr("Grouped FlopsCG saved to   --->: ", self.c.getMagenta(), output_file)
            base_width = 300
            matplotlib.pyplot.savefig(output_file, dpi=base_width)
            #matplotlib.pyplot.show()
            # --------------------------------------------------------------
            # Incrementing hte case counter for the graph title
            # --------------------------------------------------------------
            cnt_lattice += 1
        # [end-for-loop [lattice]]

        return rc
        # [end-function]
        # --------------------------------------------------------------------------


















    # ----------------------------------------------------------------------------
    def plot_BenchRes_group_FlopsCG_per_Nodes_matplotlib(self, scale,
                                                         df_su2_adj_lat,
                                                         df_su2_fun_lat,
                                                         df_su3_fun_lat,
                                                         batch_act, sim_sz, mach_name, message):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Plotting group Flops CG(s)    :", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------
        columns = ["Representation", "CG Run Time (s)","mpi_distribution","nodes", "FlOp/S (GFlOp/s)"]
        lattice_lst = df_su2_adj_lat['lattice'].unique().tolist()
        nodes_lst   = df_su2_adj_lat['nodes'  ].unique().tolist()

        df_combined_lat = pandas.concat([df_su2_adj_lat, df_su2_fun_lat, df_su3_fun_lat], ignore_index=True)
        df_combined_lattices = {lattice: df_combined_lat.loc[df_combined_lat["lattice"] == lattice, columns].copy() for lattice in lattice_lst}

        # Check whether the specified path exists or not
        plot_dir = "Plots"
        rc = self.check_directory_if_exists(plot_dir)

        # setting the main axis labels
        x_label = self.c.getXaxis_label() #"FlOp/S (GFlOp/s)"
        y_label = self.c.getYaxis_label() #"CG Run Time (s)"

        cnt_lattice = 0
        custom_colors = seaborn.color_palette("hls", 3)
        for lattice in lattice_lst:
            print(lattice)
            # --------------------------------------------------------------
            # plotting for each lattice and for nodes
            # --------------------------------------------------------------
            for node in nodes_lst[:]:
                print (node)
                df_combined_lattices_node = df_combined_lattices[lattice][
                    df_combined_lattices[lattice]['nodes'] == node][["Representation",
                                                                     "CG Run Time (s)",
                                                                     "mpi_distribution",
                                                                     "FlOp/S (GFlOp/s)"]]
                #matplotlib.pyplot.figure(figsize=(15, 10))
                fig, ax = matplotlib.pyplot.subplots(figsize=(15, 10))
                custom_colors = seaborn.color_palette("hls", 3)
                seaborn.scatterplot(
                    data=df_combined_lattices_node,
                    x=x_label,
                    y=y_label,
                    hue="Representation",
                    style="Representation",
                    s=100,
                    alpha=0.8,
                    legend=True,            # Avoid duplicate legends
                    palette="tab10"
                )

                IPython.display.display(df_combined_lattices_node)
                ''''
                # It flags an error on the hue with an umarked Jupyter nodebook works but
                # in project at the momment. Will look into that later 
                seaborn.lineplot(
                    data=df_combined_lattices_node,
                    x=x_label,
                    y=y_label,
                    hue  ="Representation", # Different lines for different lattice sizes
                    style="Representation", # Different line styles for Small/Large Simul_size
                    markers=False,          # Show markers at data points
                    dashes=True,            # Use solid lines
                    linewidth=2.5,
                    legend=True,            # Avoid duplicate legends
                    palette=custom_colors
                )
                '''
                # Add labels for each point
                for i, row in df_combined_lattices_node.iterrows():
                    # Mpi_distribution
                    matplotlib.pyplot.text(row[x_label], row[y_label], f"{row['mpi_distribution']}",
                                           ha='center', va='top', fontsize=8, fontweight='bold', color='black')
                # [end-for-loop [i, row]]

                # Finalize the plot
                matplotlib.pyplot.title(f"[{mach_name}] {batch_act}_{sim_sz}_lat{str(lattice).replace(".","x")}_node{node}")
                matplotlib.pyplot.xlabel(x_label, fontsize=12, fontweight='bold', color="darkgreen")
                matplotlib.pyplot.ylabel(y_label, fontsize=12, fontweight='bold', color="darkred")
                if scale == "log_scale":
                    matplotlib.pyplot.yscale('log')
                matplotlib.pyplot.legend(title="Representation")
                matplotlib.pyplot.grid(True, linestyle='-.', color='gray')
                # --------------------------------------------------------------
                # Getting the plots out to screen and to file.
                # --------------------------------------------------------------
                # Now getting the plot onto disk
                png_out_filename = "plot_Grouped_" + \
                                   str(message) + "_" + \
                                   str(self.c.getXaxis_label()).replace(" ","_").replace("/","").replace("(","").replace(")","") + \
                                   "_vs_" + \
                                   str(self.c.getYaxis_label()).replace(" ","_").replace("/","").replace("(","").replace(")","") + \
                                   "_" + "node" + str(node) + "_" + \
                                   "lat" + str(lattice).replace(".","x") + \
                                   "_" + \
                                   str(mach_name) + ".png"
                output_file = os.path.join(plot_dir, png_out_filename)
                # print("png_out_filename --->: ", png_out_filename)
                self.m.printMesgAddStr("Grouped FlopsCG saved to   --->: ", self.c.getMagenta(), output_file)
                base_width = 300
                matplotlib.pyplot.savefig(output_file, dpi=base_width)
                #matplotlib.pyplot.show()
            # --------------------------------------------------------------
            # Incrementing hte case counter for the graph title
            # --------------------------------------------------------------
            cnt_lattice += 1
        # [end-for-loop [lattice]]

        return rc
        # [end-function]
        # --------------------------------------------------------------------------


















    # ----------------------------------------------------------------------------
    def plot_BenchRes_groupByBars_matplotlib(self, df_mpi_distr,
                                             df_su2_adj,
                                             df_su2_fun,
                                             df_su3_fun,
                                             mach_name, message):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Getting target file list      :", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------
        species = tuple(df_mpi_distr)
        #print(type(species))
        #print(species)
        grouped_data = {
            'SU(2) Adj': df_su2_adj,
            'SU(2) Fun': df_su2_fun,
            'SU(3) Fun': df_su3_fun,
        }
        colors = ['magenta', 'blue', 'green'] #, 'red', 'black']

        x = numpy.arange(len(species))  # the label locations
        width = 0.3  # the width of the bars
        multiplier = 0

        fig, ax = matplotlib.pyplot.subplots(layout='constrained', figsize=(16, 10))

        #for attribute, measurement in penguin_means.items():
        for (attribute, measurement), color in zip(grouped_data.items(), colors):
            offset = width * multiplier
            rects = ax.bar(x + offset, measurement, width, label=attribute, color=color)
            ax.bar_label(rects, padding=3)
            multiplier += 1

        # Add some text for labels, title and custom x-axis tick labels, etc.
        ax.set_xlabel(self.c.getXaxis_label()) #'MPI distribution'
        ax.set_ylabel(self.c.getYaxis_label()) #'CG Run Time (s)'

        matplotlib.pyplot.setp(ax.get_xticklabels(), rotation=45, ha='right')
        # , "+str(lattice).replace(".","x")
        ax.set_title("["+str(mach_name)+"] "+str(message))
        ax.set_xticks(x + width, species)
        ax.legend(loc='upper left', ncols=3)

        #arg_list=repr(tuple(fields)).replace("'", "")[1:-1]
        plot_dir = "Plots"
        self.check_directory_if_exists(plot_dir)

        png_out_filename = "plot_GroupedBars_" + \
                           str(message) + "_" + \
                           str(self.c.getYaxis_label()).replace(" ","_").replace("/","").replace("(","").replace(")","") + \
                           "_" + \
                           str(mach_name) + ".png"
        output_file = os.path.join(plot_dir, png_out_filename)
        # print("png_out_filename --->: ", png_out_filename)
        self.m.printMesgAddStr("Grouped Bar plot saved to  --->: ", self.c.getMagenta(), output_file)
        base_width = 300
        matplotlib.pyplot.savefig(output_file, dpi=base_width)

        #matplotlib.pyplot.show()

        return rc
        # [end-function]
        # --------------------------------------------------------------------------
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
        # constructing the leading zeros according to number
        # -------------------------------------------------------------------
        zero_lead = 0
        # counting the number of digits in number
        import math
        if number > 0:
            digits = int(math.log10(number)) + 1
        elif number == 0:
            digits = 1
        else:
            digits = int(math.log10(-number)) + 2
        zero_lead = numpy.power(10, digits)
        # -------------------------------------------------------------------
        # End of method return statement
        # -------------------------------------------------------------------
        return rc, zero_lead
        #--------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Checkers]
    #------------------------------------------------------------------------
    def check_directory_if_exists(self, dir):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgStr("Getting target file list      :", self.c.getGreen(), __func__)
        # ----------------------------------------------------------------------
        # Check whether the specified path exists or not
        dir_exist = os.path.exists(dir)
        if not dir_exist:
            self.m.printMesgAddStr(" Directory does not exists --->: ", self.c.getRed(), dir)
            # Create a new directory because it does not exist
            self.m.printMesgAddStr(" Directory is created      --->: ", self.c.getMagenta(), dir)
            try:
                os.makedirs(dir)
            except IOError:
                self.m.printMesgAddStr(" Unable to create directory--->: ", self.c.getMagenta(), dir)
                dir = "./"
                self.m.printMesgAddStr(" Output directory          --->: ", self.c.getMagenta(), dir)
        else:
            self.m.printMesgAddStr(" Directory already exists  --->: ", self.c.getMagenta(), dir)
        # [end-if]
        return rc
        # [end-function]
        # ------------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Writers]
    #------------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Reader]
    #------------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Getters]
    #------------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Printers]
    #------------------------------------------------------------------------
    def printFileNames(self):
        rc = self.c.get_RC_SUCCESS()

        return rc
    #------------------------------------------------------------------------
#----------------------------------------------------------------------------
# end of LatticeModel_Analyser class
#----------------------------------------------------------------------------
