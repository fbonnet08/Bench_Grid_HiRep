#!/usr/bin/env python3
'''!\file
   -- DataManage addon: (Python3 code) class for handling some of the command line
      of the common variables
      \author Frederic Bonnet
      \date 03rd of March 2024

      Universite de Perpignan March 2024

Name:
---
Command_line: class MathematicalModel_Analyser for analyzing network transfers between
two interfaces.

Description of classes:
---
This class generates an object that contains and handlers

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
#import psutil
#import time
import datetime
import os
import pandas # as pd
import seaborn # as sns
import csv
import scipy
# plotting imports
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
# Path extension
sys.path.append(os.path.join(os.getcwd(), '.'))
sys.path.append(os.path.join(os.getcwd(), '..'))
#Application imports
# Definiiton of the constructor
class MathematicalModel_Analyser:
    #---------------------------------------------------------------------------
    # [Constructor] for the
    #---------------------------------------------------------------------------
    # Constructor
    def __init__(self, c, m):
        __func__= sys._getframe().f_code.co_name
        self.rc = 0
        self.c = c
        self.m = m
        self.app_root = self.c.getApp_root()  #app_root
        self.m.printMesgStr("Instantiating the class : ", self.c.getGreen(), "MathematicalModel_Analyser")
        
        #gettign the csv file
        self.ext_asc = ".asc"
        self.ext_csv = ".csv"
        self.csv_len = 0
        self.csv_col = 0
        self.rows = []
        #initialising the lists
        self.indnx = []
        self.columns_lst = []
        self.date = []
        self.time = []
        self.upload = []
        self.download = []
        self.newnumber = []
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
        self.csvfile = self.c.getCSV_file()
        
        #[IO-Reader] reading the csv file
        rc, self.csv_len, self.csv_col, self.rows = self.read_csv_file(self.csvfile)
        self.m.printMesgAddStr("Printing the first five rows of the csv file", self.c.getYellow(), " ...")
        self.m.printMesgAddStr("Number of columns in csv:  --->: ", self.c.getYellow(), self.csv_col)
        if self.csv_len >= 5:
            for i in range(0,5):
                self.m.printMesgAddStr("rows["+str(i)+"]: ", self.c.getYellow(), str(self.rows[i]))
                
        #[IO-Writer] writting the asc file
        rc, self.basename, ext = self.write_csvToAsc_file(self.csvfile)
        
        #Put asc file into lists
        rc = self.read_ascFile_to_list()
        #-----------------------------------------------------------------------
        # [Constructor-end] end of the constructor
        #-----------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Driver]
    #---------------------------------------------------------------------------
    def make_histogram(self, csvfile, targetdir):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        
        self.m.printMesgStr("Data analysis for the transfer files : ", self.c.getYellow(),
                            self.basename.split("_")[len(self.basename.split("_"))-1])
        self.m.printMesgAddStr("[file_csv]:     (csv file) --->: ", self.c.getYellow(), csvfile)
        self.m.printMesgAddStr("[targetdir]:               --->: ", self.c.getGreen(), targetdir)
        
        #Creating the scatter plots and box plots
        #rc = self.plot_RunMean(csvfile, targetdir)
        rc, distr_file = self.plot_Distr(self.upload, csvfile, targetdir, "upload")
        rc, distr_file = self.plot_Distr(self.download, csvfile, targetdir, "download")
        rc = self.plot_scatters_and_boxplots(self.upload, self.download, csvfile, targetdir)

        return rc
    #---------------------------------------------------------------------------
    # [Plotters]
    #---------------------------------------------------------------------------
    def plot_Distr(self, dataset, setname, targetdir, which_way):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        dataset_plot = pandas.DataFrame(dataset, columns = [setname])
        filename = os.path.basename(setname)
        filename_without_ext = os.path.splitext(filename)[0]

        dist = seaborn.displot(data=dataset_plot, x=setname,
                               kde=True, kind="hist", bins = 100, aspect = 1.5)
        dist.set(xlabel=which_way+" (MB/s)", ylabel='Transfer (MB/s) [100]').set(title=filename_without_ext)
        #print("setname: ", setname)
        self.m.printMesgAddStr("setname                    --->: ", self.c.getMagenta(), setname)
        
        last_time_stamp = self.time[len(self.time[:])-1].split(":")
        some_time = ""
        for i in range(len(last_time_stamp)): some_time += last_time_stamp[i]+"_"
        
        distr_file = targetdir+os.path.sep+"transfer_distr_"+which_way+"_"+some_time+self.get_filename_postfix(filename_without_ext)+ ".png"
        #distr_file = targetdir+os.path.sep+"dose_Distr_"+filename_without_ext+ ".png"
        #print("Function --> "+__func__+" --> distr_file: ", distr_file)
        basewidth = 300
        plt.savefig(distr_file, dpi=basewidth)
        self.m.printMesgAddStr("Distribution file saved to --->: ", self.c.getMagenta(), distr_file)
        
        return rc, distr_file
    
    def plot_scatters_and_boxplots(self, newnumber, dose, setname, targetdir):
        rc = self.c.get_RC_SUCCESS()
        n_all_means = len(newnumber)
        #print ("newnumber[:]: ", newnumber[:])
        n_all_stds = len(dose)
        filename = os.path.basename(setname)
        filename_without_ext = os.path.splitext(filename)[0]
        fig, axes = plt.subplots(nrows=1, ncols=2, figsize=(15, 7))
        #Boxplot of the data
        axes[0].set_title("Transfer speed (MB/s) --> "+filename_without_ext)
        #Scatter plot data
        xaxis_cnt_entries_lst = []
        for i in range(len(newnumber)): xaxis_cnt_entries_lst.append(i)
        
        data = [newnumber, dose]
        bp1 = axes[0].boxplot(data) #newnumber)
        axes[0].legend([bp1["boxes"][0]], ['Upload [MB/s]'], loc='upper left')
        axes[0].set_xlabel(filename_without_ext)
        axes[0].set_ylabel("Transfer speed (MB/s)") #Fractions in Time
        #self.m.printMesgAddStr("xaxis_[0:10]               --->: ", self.c.getMagenta(), xaxis_cnt_entries_lst[0:10])
        
        axes[1].set_title(filename_without_ext)
        axes[1].set_xlabel("Tranfers in time")
        axes[1].grid(True)
        axes[1].xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m-%d %H:%M:%S'))
        axes[1].set_ylabel("Transfer speed (MB/s)")
        axes[1].annotate('n=%d'%n_all_means, xy=(0.05, 0.95), xycoords='axes fraction', fontsize=14)
        date_time = []
        for i in range(len(self.date[:])):
            date_time.append(datetime.datetime.strptime(self.date[i]+" "+self.time[i],'%Y-%m-%d %H:%M:%S'))

        sc1 = axes[1].plot(date_time, newnumber, color='magenta', linestyle='-', marker='o', markersize=2)
        sc2 = axes[1].plot(date_time, dose, color='blue', linestyle='-', marker='o', markersize=2)
        axes[1].legend(['upload', 'download'], loc='upper right', fontsize=14)
        # Rotates and right-aligns the x labels so they don't crowd each other.
        for label in axes[1].get_xticklabels(which='major'):
            label.set(rotation=30, horizontalalignment='right')
        
        fig.tight_layout()
        #plt.show()
        last_time_stamp = self.time[len(self.time[:])-1].split(":")
        some_time = ""
        for i in range(len(last_time_stamp)): some_time += last_time_stamp[i]+"_"
        self.m.printMesgAddStr("Last time stamp transfer   --->: ", self.c.getYellow(), last_time_stamp)
        boxScatter_file = targetdir+"/"+"transfer_plots_" + some_time + \
                          self.get_filename_postfix(filename_without_ext) + ".png"
        basewidth = 300
        plt.savefig(boxScatter_file, dpi=basewidth)
        self.m.printMesgAddStr("Scatter/Box plot saved to  --->: ", self.c.getMagenta(), boxScatter_file)
        
        return rc
    #---------------------------------------------------------------------------
    # [Handlers]
    #---------------------------------------------------------------------------
    def get_filename_postfix(self,filename_without_ext):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        
        #Strip ProjectName content from filename_without_ext to standardize
        self.m.printMesgAddStr("filename_without_ext       --->: ", self.c.getMagenta(), filename_without_ext)
        filename_without_ext_split = []
        filename_without_ext_split = filename_without_ext.split("_")
        self.m.printMesgAddStr("file_without_ext_split[:]  --->: ", self.c.getGreen(), filename_without_ext_split[:])
        
        #Initialiszing the variable to default value
        filename_postfix = filename_without_ext
        #Recasting the proper filename postfix
        #filename_postfix = filename_without_ext_split[0] + "_" + \
        #                   filename_without_ext_split[1] + "_" + \
        #                   filename_without_ext_split[2]
        filename_postfix = filename_without_ext_split[-1]
        
        return filename_postfix
    #---------------------------------------------------------------------------
    # [Writters]
    #---------------------------------------------------------------------------
    def write_csvToAsc_file(self, csvfile):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name

        basename = os.path.splitext(csvfile)[0]
        ext = ""
        if len(os.path.splitext(csvfile)) > 1: ext = os.path.splitext(csvfile)[1]

        #print("basename: ", basename)
        self.m.printMesgAddStr("basename                   --->: ", self.c.getMagenta(), basename)
        file_asc = basename+self.ext_asc
        if ( file_asc != self.file_asc):
            rc = self.c.get_RC_WARNING()
            print("[file_asc]: Could not open file incoherent files names:", self.file_asc)
            print("Return code: ", self.c.get_RC_FAIL())
            exit(self.c.get_RC_FAIL())
        else:
            self.m.printMesgAddStr("[file_asc]:       coherent --->: ", self.c.getRed(), self.file_asc)
            #print("self.file_asc: ", self.file_asc)

        try:
            file = open(self.file_asc,'w')
            counter = 0
            for i in range(self.csv_len):
                counter += 1
                columns = ""
                for j in range(self.csv_col):
                    columns += self.rows[i][j]+" "
                    #Takes a csv with first two columns
                    # 2022-05-03_13:16:44 50.66708579937758E+21
                    # date-time           : 2022-05-03_13:16:44
                    # exponentiated number: 50.66708579937758E+21
                    # "2024-03-03_17:50:19","0.0000","0.0000"
                    #print("self.rows["+str(counter)+"]["+str(j)+"]", self.rows[i][j])
                    if j == 0:
                        time =  self.rows[i][j].split("_")[len(self.rows[i][j].split("_"))-1]
                        date = self.rows[i][j].split("_")[len(self.rows[i][j].split("_"))-2]
                    if j == 1:
                        #exp = int((str(self.rows[i][j]).split("e+")[0].split("E+"))[1])
                        up_value = str(self.rows[i][j])
                        try:
                            number = float((str(self.rows[i][j]).split("e+")[0].split("E+"))[0])
                        except ValueError:
                            #Filtering out numbers types:-..1445432162182349E+19"
                            number = (str(self.rows[i][j]).split("e+")[0].split("E+"))[0]
                            if number != None and "-.." in number: flag = "yes"
                            basenumber = number.split("-..")[1]
                            if (basenumber != ""): number = basenumber
                    if j == 2:
                        down_value = str(self.rows[i][j])
                #Constructing the ouptput string to go to asc file
                msg = str(counter).strip()    + "," + \
                      str(columns).strip()    + "," + \
                      str(date).strip()       + "," + \
                      str(time).strip()       + "," + \
                      str(up_value).strip()   + "," + \
                      str(down_value).strip() + "\n "
                
                file.write(msg)
                
            #End of for loop i
            file.close()
        except IOError:
            rc = self.c.get_RC_WARNING()
            print("[file_asc]: Could not open file:",self.file_asc)
            print("Return code: ", self.c.get_RC_FAIL())
            exit(self.c.get_RC_FAIL())
        return rc, basename, ext
    #---------------------------------------------------------------------------
    # [Reader]
    #---------------------------------------------------------------------------
    def read_csv_file(self, csvfile):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name

        try:
            file = open(csvfile)
            type(file)
            csvreader = csv.reader(file)
            rows = []
            for row in csvreader: rows.append(row)
            csv_len = len(rows)
            if csv_len != 0:
                csv_col = len(rows[0])
            file.close()
        except IOError:
            rc = self.c.get_RC_WARNING()
            print("[csv_len]: Could not open file:", csvfile, csv_len)
            csv_len = 0
            print("Return code: ", self.c.get_RC_FAIL())
            exit(self.c.get_RC_FAIL())
        
        #print("Read from file: ",csvfile, " ---> length csv_len: ", csv_len)
        msg = self.c.getBlue() + "Read from file: " + \
              self.c.getYellow()  + csvfile + \
              self.c.getBlue() + " ---> length csv_len: "
        self.m.printMesgAddStr(msg, self.c.getMagenta(), str(csv_len))
    
        return rc, csv_len, csv_col, rows
    
    def read_ascFile_to_list(self):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()
        
        fh = open(self.file_asc,'r')
        lines = fh.readlines()
        fh.close()

        cnt_lines = -1
        for il in lines:
            cnt_lines += 1
            sp = il.split(",")
            if ( cnt_lines < self.csv_len ):
                self.indnx          .append(sp[0])
                self.columns_lst    .append(sp[1])
                self.date           .append(sp[2])
                self.time           .append(sp[3])
                self.upload   .append(float(sp[4]))
                self.download.append( float(sp[5].split("\n")[0]))
        
        return rc
    #---------------------------------------------------------------------------
    # [Getters]
    #---------------------------------------------------------------------------
    def get_statistics_for_list(self, in_list):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        
        self.sample_min      = min(in_list)
        self.sample_max      = max(in_list)
        self.sample_mean     = scipy.mean(in_list)
        self.sample_variance = scipy.var(in_list)
        
        print("sample min     : ", self.sample_min)
        print("sample max     : ", self.sample_max)
        print("sample mean    : ", self.sample_mean)
        print("sample variance: ", self.sample_variance)
        
        return rc
    def get_statistics(self):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        
        self.sample_min      = min(self.newnumber)
        self.sample_max      = max(self.newnumber)
        self.sample_mean     = scipy.mean(self.newnumber)
        self.sample_variance = scipy.var(self.newnumber)
        
        print("sample min     : ", self.sample_min)
        print("sample max     : ", self.sample_max)
        print("sample mean    : ", self.sample_mean)
        print("sample variance: ", self.sample_variance)
        
        return rc
    #---------------------------------------------------------------------------
    # [Printers]
    #---------------------------------------------------------------------------
    def printMesg(self, msg):
        rc = self.c.get_RC_SUCCESS()
        self.m.printMesgAddStr("[file_asc]:     (asc file) --->: ", self.c.getRed(), self.c.getPlot_asc())
        self.m.printMesgAddStr("[file_csv]:     (csv file) --->: ", self.c.getYellow(), self.c.getCSV_file())
        return rc

#---------------------------------------------------------------------------
# end of MathematicalModel_Analyser
#---------------------------------------------------------------------------
