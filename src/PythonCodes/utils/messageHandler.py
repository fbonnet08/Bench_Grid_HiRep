'''!\file
   -- ResMap addon: (Python3 code) self contained module to handle messenging and loggin.
      \author Frederic Bonnet
      \date 28th of August 2017

      Yale University August 2017

Name:
---
messageHandler: module containing all the methods for loggin to file and
                printing messeneges to screen.

Description of classes:
---
messageHandler is a self contained class used for logging ResMap output to an
appended file. The class has no dependencies apart from standard logging Python3
package. All of the definitions are fully extendable and flexible. This allows
full portability and high flexibility and is highly custamable and can be fully
and easily maintained.

Convention used:
---

The construiction of the methods are done using the following convention for
parsing and message searching on keys on appended file ResMaps.log.

* == [      ---> All messages starts 
* ] ==      ---> All messages ends
* x         ---> Sepaartor for volume
*    [      ---> When adding a message to an start message started with == [
* :: [Time elapsed: ---> All timer messages starts
* TOTAL :: [Time elapsed: ---> Total time used by application
* << [      ---> All benchmarking coming from doBenchMarking switch
* print     ---> print a message
* C         ---> a colored message to be printed
* Mesg      ---> it is a message that is going to be printed
* Value     ---> A single value beong printed
* Buffer    ---> printing a buffer
* Str       ---> Value is of type string
* Bool      ---> Value is of type boolean
* Int       ---> Value is of type integer
* Float     ---> Value is of type float
* Add       ---> Add a value to an open braket == [ statement

Requirements (system):
---
* sys
* os
* logging
* logging.config

Requirements (application):
---
* ResMap_common
* StopWatch
'''
#----------------------------------------------------------------------------
# ProgressBar definitions and methods
# Author: Frederic Bonnet
# Date: 28/08/2017
#----------------------------------------------------------------------------
#System tools
import sys
import os
import time
import logging
import logging.config
import numpy as np
#appending the utils path
sys.path.append(os.path.join(os.getcwd(), '.'))
sys.path.append(os.path.join(os.getcwd(), '..'))
sys.path.append(os.path.join(os.getcwd(), '..','utils'))
#application imports
#from DataManage_common import *
import src.PythonCodes.DataManage_common
#from StopWatch import *
import src.PythonCodes.utils.StopWatch
#-------------------------------------------------------------------------------
# Printing the difference of the norm
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#Printing the difference of the norm, used in debugging the CUDA convolution.
#*******************************************************************************
#\param c             DataManage_common class object from DataManage_common.py
#\param m             messageHandler class from messageHandler.py
#\param str_conv1f    Sting value name for 3D Flatten 3D matrix 1
#\param conv1f        Flatten 3D matrix 1
#\param str_conv2f    Sting value name for 3D Flatten 3D matrix 2 
#\param conv2f        Flatten 3D matrix 2
#\return diff_12f the difference between two norms as a flatten 3D matrix
def print_linalgNorm_diff(c,m,str_conv1f, conv1f, str_conv2f, conv2f):

        import scipy
        m.printMesgStr("Extracting database content (database_file): ", self.c.getGreen(), __func__)
        diff_12f = conv1f - conv2f

        msg = c.getYellow()+"||"+str_conv1f+" - "+str_conv2f+"||              : " \
              + c.getGreen() + str(scipy.linalg.norm(diff_12f.flatten(),ord=2)) \
              + c.get_C_Reset()
        print(msg)
        m.printMesgAddStr("[message]: print_linalgNorm_diff --->: ", c.getMagenta(), msg)

        msg = c.getYellow()+"||"+str_conv1f+"||                        : " \
              + c.getYellow() + str(scipy.linalg.norm(conv1f.flatten(),ord=2)) \
              + c.get_C_Reset()
        print(msg)

        msg = c.getYellow()+"||"+str_conv1f+" - "+str_conv2f+"|| / ||"+str_conv1f+"||: " \
              + c.getMagenta() + str(scipy.linalg.norm(diff_12f.flatten(),ord=2) / scipy.linalg.norm(conv1f.flatten(),ord=2)) + c.get_C_Reset()

        print(msg)
        return diff_12f
#-------------------------------------------------------------------------------
# Class declaration for messageHandler
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 class.
#messageHandler class for handling the the File IO access
class messageHandler:
    #***************************************************************************
    ##\brief Python3 method.
    #messageHandler class constructor, and invokes initialize and instantiate
    #logging for file append to DataManages.log standard definition comes from
    #DataManage_common in DataManage_common.py.
    #***************************************************************************
    #\param self          The Self Object
    #\param **kwargs      Key value arguments list
    def __init__(self,**kwargs):
            self.logfile = kwargs.get('logfile',  None)
            logging.basicConfig(filename=self.logfile, level=logging.DEBUG)
            self.initialize()
    #---------------------------------------------------------------------------
    # class methods
    #---------------------------------------------------------------------------
    #initialises the variables
    def initialize(self):
        self.c = src.PythonCodes.DataManage_common.DataManage_common()
        if (self.c.getBench_cpu()==True):
            self.benchfile = open('resmapBench.asc','a')
    #Debug logging
    def logDebug(self,strg,color,value):
        logging.debug(color+"  " + strg +self.c.get_C_Reset())
    #Info logging
    def logInfo(self,strg,color,value):
        logging.info(color+"   " + strg + self.c.get_C_Reset())
    #warning loging
    def logWarning(self,strg,value):
        logging.warning(self.c.getRed() + strg + self.c.get_C_Reset())
    #---------------------------------------------------------------------------
    # [Gatan_PC_K3_fileMover] file handlers methods
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # [Printers]
    #---------------------------------------------------------------------------
    def print_unchanged_dir(self, c, data_path, target_dufile,
                            last_cnt, new_cnt):

        rc = c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name

        new_cnt_size = float(new_cnt)*1.0e-6
        last_cnt_size = float(last_cnt)*1.0e-6

        msg = c.getBlue()+"("                                               +\
              c.getGreen()+"Unchanged"                                      +\
              c.getBlue()+") Directory ["                                  +\
              c.getCyan()+"{message: <43}".format(message=data_path)        +\
              c.getBlue()+"] "                                             +\
              c.getYellow()+"not growing: "           +\
              c.getBlue()+"["+c.getCyan()+target_dufile                    +\
              c.getBlue()+"] ---> (Size: Last="                         +\
              c.getGreen()+str(last_cnt)                                    +\
              c.getBlue()+" ["                                              +\
              c.getCyan()+str("{0:.2f}".format(last_cnt_size))              +\
              c.getBlue()+" GB] ::: New="                                 +\
              c.getGreen()+str(new_cnt)                                     +\
              c.getBlue()+" ["                                              +\
              c.getCyan()+str("{0:.2f}".format(new_cnt_size))               +\
              c.getBlue()+" GB])"+ c.get_C_Reset()

        self.printMesg(msg)

        return rc

    def print_changed_dir(self, c, data_path, target_dufile,
                          last_cnt, new_cnt):
        rc = c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name

        new_cnt_size = float(new_cnt)*1.0e-6
        last_cnt_size = float(last_cnt)*1.0e-6

        msg = c.getBlue()+"("                                               +\
              c.getGreen()+"Changed"                                        +\
              c.getBlue()+"  ) Directory ["                                +\
              c.getCyan()+"{message: <43}".format(message=data_path)        +\
              c.getBlue()+"] "                                             +\
              c.getGreen()+"is growing : "            +\
              c.getBlue()+"["+c.getCyan()+target_dufile                    +\
              c.getBlue()+"] ---> (Size: Last="                         +\
              c.getGreen()+str(last_cnt)                                    +\
              c.getBlue()+" ["                                              +\
              c.getCyan()+str("{0:.2f}".format(last_cnt_size))              +\
              c.getBlue()+" GB] ::: New="                                 +\
              c.getGreen()+str(new_cnt)                                     +\
              c.getBlue()+" ["                                              +\
              c.getCyan()+str("{0:.2f}".format(new_cnt_size))               +\
              c.getBlue()+" GB])"+ c.get_C_Reset()

        self.printMesg(msg)

        return rc

    def print_extract_proj_sze(self, c, du_size, ith_project_target_list):
        rc = c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name

        du_size_GB = float(du_size)*1.0e-6
        msg = c.getBlue()+"("                                                     +\
              c.getGreen()+"Extracting"                                           +\
              c.getBlue()+"): Size of project folder [ "                          +\
              c.getCyan()+"{message: <63}".format(message=ith_project_target_list)+\
              c.getBlue()                                                         +\
              " ]  ---> ( Size: "                                                 +\
              c.getGreen()+"{message: <10}".format(message=str(du_size))          +\
              c.getBlue()+" ["+ c.getCyan()                                       +\
              "{message: <8}".format(message=str("{0:.2f}".format(du_size_GB)))   +\
              c.getBlue()+" GB]"+" )"+ c.get_C_Reset()

        self.printMesg(msg)

        return rc
    #---------------------------------------------------------------------------
    # [WarpMover_FileIO] file handlers methods
    #---------------------------------------------------------------------------
    def print_processing_msg(self, c, item, target):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        #Get the current time stamp
        rc,time_stamp = self.get_local_current_Time(c)
        #Create message
        msg = c.getBlue()   + "("                           + \
              c.getGreen()  + "processing" + time_stamp     + \
              c.getBlue()   + ") "+c.getYellow()            + \
              c.getYellow() + item                          + \
              c.getCyan()   + " ---> "                      + \
              c.getGreen()  + target + c.get_C_Reset()
        self.printMesg(msg)

        return rc

    def print_cp_msg(self, c, item, target):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        #Get the current time stamp
        rc,time_stamp = self.get_local_current_Time(c)
        #Create message
        msg = c.getBlue()   + "("                           + \
              c.getGreen()  + "Copying" + time_stamp        + \
              c.getBlue()   + ") "+c.getYellow()            + \
              c.getYellow() + item                          + \
              c.getCyan()   + " ---> "                      + \
              c.getGreen()  + target + c.get_C_Reset()
        self.printMesg(msg)

        return rc

    def print_key_val_table(self, c, table, key, val):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        #Get the current time stamp
        rc,time_stamp = self.get_local_current_Time(c)
        #Create message
        msg = c.getBlue()   + " ["                + \
              c.getBlue()   + "("                 + \
              c.getGreen()  + table + time_stamp  + \
              c.getBlue()   + ") "+c.getYellow()  + \
              c.getYellow() + key                 + \
              c.getCyan()   + " ---> "            + \
              c.getGreen()  + val.strip()         + \
              c.getBlue() + "]"+ c.get_C_Reset()
        self.printMesgAdd(msg)

        return rc

    def print_rsync_msg(self, c, item, target, file_handler):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        #Get the current time stamp
        rc,time_stamp = self.get_local_current_Time(c)
        #Create message
        msg = ""
        msg = c.getBlue() + "(" + c.getGreen()
        if file_handler == "rsync_copy":
                msg += "rsync copy" + time_stamp
        elif file_handler == "rsync_move":
                msg += "rsync move" + time_stamp
        msg += c.getBlue()   + ") "+c.getYellow()            + \
               c.getYellow() + item                          + \
               c.getCyan()   + " ---> "                      + \
               c.getGreen()  + target + c.get_C_Reset()
        self.printMesg(msg)

        return rc

    def print_mv_msg(self, c, item, target):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        #Get the current time stamp
        rc,time_stamp = self.get_local_current_Time(c)
        #Create message
        msg = c.getBlue()   + "("                           + \
              c.getGreen()  + "Moving" + time_stamp         + \
              c.getBlue()   + " ) "+c.getYellow()          + \
              c.getYellow() + item                          + \
              c.getCyan()   + " ---> "                      + \
              c.getGreen()  + target + c.get_C_Reset()
        self.printMesg(msg)

        return rc

    def print_converter_msg(self, c, item, target):
        rc = self.c.get_RC_SUCCESS()
        __func__= sys._getframe().f_code.co_name
        #Get the current time stamp
        rc,time_stamp = self.get_local_current_Time(c)
        #Create message
        msg = c.getBlue()   + "("                           + \
              c.getGreen()  + "Convert" + time_stamp        + \
              c.getBlue()   + ") "+c.getYellow()            + \
              c.getYellow() + item                          + \
              c.getCyan()   + " ---> "                      + \
              c.getGreen()  + target + c.get_C_Reset()
        self.printMesg(msg)

        return rc
    #***************************************************************************
    ##\brief Python3 method.
    ##writing to log file method. Using a coor coded scheme in the DataManages.log
    # - White      ---> DEBUG: string to be logged.
    # - (Bold) Red ---> WARNING: string to be logged.
    # - Other      ---> INFO: string to be logged.
    #***************************************************************************
    #\param self          The Self Object
    #\param color         Color to be used from DataManage_common.
    #\param strg          String to be logged.
    def writeToLog(self,color,strg):
        if(color == self.c.getWhite() ):
            logging.debug(strg)
        elif(color == self.c.getRed() or color == self.c.get_B_Red() ):
            logging.warning(strg)
        else:
            logging.info(strg)
    #main message
    def printMesg(self,strg):
        self.strg  = strg
        self.msg   = self.c.getCyan()+" == [" \
                     + self.c.getBlue()+self.strg+self.c.getCyan()+"] ==" \
                     + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(self.c.getCyan(),self.msg)

    def printMesgVal(self, strg, color, value):
        self.strg  = strg
        self.color = color
        self.msg   = self.c.getCyan()+" == [" \
                     + self.c.getBlue()+self.strg+self.color \
                     + "{0:>0.3f}".format(value)+self.c.getCyan()+"] ==" \
                     + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(color,self.msg)

    def printCMesg(self, strg, color):
        self.strg  = strg
        self.color = color
        self.msg   = self.c.getCyan()+" == ["+color+self.strg \
                     + self.c.getCyan()+"] ==" \
                     + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(color,self.msg)

    def printCBuffer(self, strg, color):
        self.strg  = strg
        self.color = color
        #self.msg   = self.c.getCyan()+" == [\n"
        self.msg   = self.c.getCyan()+"\n"
        self.msg   += color+self.strg + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(color,self.msg)
        
    def printCMesgVal(self, strg, color, value):
        self.strg  = strg
        self.color = color
        self.msg   = self.c.getCyan()+" == ["+color+self.strg  \
                     + "{0}".format(str(value))+self.c.getCyan()+"] ==" \
                     + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(color,self.msg)

    def printCMesgCVal(self,color1,strg,color2,value):
        self.strg  = strg
        self.color1 = color1
        self.color2 = color2
        self.msg   = self.c.getCyan()+" == ["+self.color1+self.strg     \
                     + self.color2+"{0}".format(str(value)) \
                     + self.c.getCyan()+"] ==" \
                     + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(color1,self.msg)

    def printCMesgValMesgVal(self,color1,strg1,color2,value,strg2,color3,val2):
        self.color1= color1
        self.strg1 = strg1
        self.color2= color2
        self.strg2 = strg2
        self.msg   = self.c.getCyan()+" == [" \
                     + self.color1+self.strg1 \
                     + self.color2+"{0}".format(str(value)) \
                     + self.color1+self.strg2+color3+"{0}".format(str(val2)) \
                     + self.c.getCyan()+"] ==" \
                     + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(self.color1,self.msg)
    
    def printCMesgValMesg(self,color1,strg1,color2,value,strg2):
        self.color1= color1
        self.strg1 = strg1
        self.color2= color2
        self.strg2 = strg2
        self.msg   = self.c.getCyan()+" == [" \
                     + self.color1+self.strg1 \
                     + self.color2+"{0}".format(str(value)) \
                     + self.color1+self.strg2+self.c.getCyan()+"] ==" \
                     + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(self.color1,self.msg)

    def printMesgStr(self,strg,color,value):
        self.strg  = strg
        self.color = color
        self.msg   = self.c.getCyan()+" == [" \
                     + self.c.getBlue()+self.strg+color \
                     + " {0}".format(str(value)) \
                     + self.c.getCyan()+"] =="      \
                     + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(color,self.msg)

    def printMesgBool(self,strg,color,value):
        self.strg  = strg
        self.color = color
        self.msg   = self.c.getCyan()+" == [" \
                     + self.c.getBlue()+self.strg+color \
                     + " {0}".format(str(value)) \
                     + self.c.getCyan()+"] =="      \
                     + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(color,self.msg)
        
    def printMesgInt(self,strg,color,value):
        self.strg  = strg
        self.color = color
        self.msg   = self.c.getCyan()+" == ["\
                     +self.c.getBlue()+self.strg+color \
                     + " {0:>6d}".format(value)+self.c.getCyan()+"] ==" \
                     + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(color,self.msg)
        
    def printMesgFloat(self,strg,color,value):
        self.strg  = strg
        self.color = color
        self.msg   = self.c.getCyan()+" == [" \
                     + self.c.getBlue()+self.strg+self.color \
                     + "{0:>0.3f}".format(value)+self.c.getCyan()+"] ==" \
                     + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(color,self.msg)
        
    #standard message printing
    def printMesgOutFloat(self,color1,strg,color2,value):
        self.strg  = strg
        self.color1= color1
        self.color2= color2
        self.msg   = self.color1+self.strg+self.color2 \
                     + "{0:>0.3f}".format(value) \
                     + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(color1,self.msg)

    def printMesgOut(self,color1,strg,color2,value):
        self.strg  = strg
        self.color1= color1
        self.color2= color2
        self.msg   = self.color1+self.strg + self.color2 \
                     + "{0}".format(value) \
                     + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(color1,self.msg)
    
    #add on to main message
    def printMesgAddVolume(self,strg,color,volume):
        self.strg  = strg
        self.color = color #passed but not used yet in the print
        self.vx, self.vy, self.vz = volume
        self.msg   = self.c.getCyan()   +"    "+self.c.getBlue()+self.strg \
                     + self.c.getGreen()+str(self.vx)  \
                     + self.c.getCyan() +" x "         \
                     + self.c.getGreen()+str(self.vy)  \
                     + self.c.getCyan() +" x "         \
                     + self.c.getGreen()+str(self.vz)  \
                     + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(color,self.msg)

    def printMesgAddTensor(self,strg,color,volume,nbases):
        self.strg  = strg
        self.color = color #passed but not used yet in the print
        self.vx, self.vy, self.vz = volume
        self.nbases = nbases
        self.msg   = self.c.getCyan()   +"    "+self.c.getBlue()+self.strg \
                     + self.c.getGreen()+str(self.vx)  \
                     + self.c.getCyan() +" x "         \
                     + self.c.getGreen()+str(self.vy)  \
                     + self.c.getCyan() +" x "         \
                     + self.c.getGreen()+str(self.vz)  \
                     + self.c.getCyan() +" x "         \
                     + self.c.getMagenta()+str(self.nbases)  \
                     + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(color,self.msg)

    def printVolume(self,strg,volume):
        self.strg  = strg
        self.vx, self.vy, self.vz = volume
        self.msg   = self.strg       \
                     + str(self.vx)  \
                     + " x "         \
                     + str(self.vy)  \
                     + " x "         \
                     + str(self.vz)
        return self.msg

    def printCVolume(self,strg,color,volume):
        self.strg  = strg
        self.color = color #passed but not used yet in the print
        self.vx, self.vy, self.vz = volume
        self.msg   = self.c.getCyan()   +"    "+self.c.getBlue()+self.strg \
                     + self.c.getGreen()+str(self.vx) \
                     + self.c.getCyan() +" x "        \
                     + self.c.getGreen()+str(self.vy) \
                     + self.c.getCyan() +" x "        \
                     + self.c.getGreen()+str(self.vz) \
                     + self.c.get_C_Reset()
        return self.msg
        
    def printMesgAddFloat(self,strg,color,value):
        self.strg  = strg
        self.color = color
        self.msg   = self.c.getCyan()+"    " \
                     + self.c.getBlue()+self.strg+self.color \
                     + "{0:>0.3f}".format(value) \
                     + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(color,self.msg)

    def printCMesgAddEq(self,strg,color):
        self.strg  = strg
        self.color = color
        self.msg   = self.c.getCyan()+"    [" \
                     + self.c.getBlue()+self.color + self.strg  \
                     + self.c.getCyan()+"] ==" \
                     + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(color,self.msg)

    def printMesgAddEq(self,strg,color):
        self.strg  = strg
        self.color = color
        self.msg   = self.c.getCyan()+"    [" \
                     + self.c.getBlue()+self.strg  \
                     + self.c.getCyan()+"] ==" \
                     + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(color,self.msg)

    def printMesgAddEqFloat(self,strg,color,value):
        self.strg  = strg
        self.color = color
        self.msg   = self.c.getCyan()+"    [" \
                     + self.c.getBlue()+self.strg+self.color \
                     + "{0:>0.3f}".format(value)+self.c.getCyan()+"] ==" \
                     + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(color,self.msg)

    def printMesgAddEqStr(self,strg,color,value):
        self.strg  = strg
        self.color = color
        self.msg   = self.c.getCyan()+"    [" \
                     + self.c.getBlue()+self.strg+self.color \
                     + value+self.c.getCyan()+"] ==" \
                     + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(color,self.msg)

    def printMesgAddEqLongFloat(self,strg,color,value):
        self.strg = strg
        self.color = color
        self.msg = self.c.getCyan()+"    [" \
                   + self.c.getBlue()+self.strg + self.color \
                   + "{0:>0.8f}".format(value)+self.c.getCyan()+"] ==" \
                   + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(color,self.msg)
        
    def printMesgAddEqInt(self,strg,color,value):
        self.strg  = strg
        self.color = color
        self.msg   = self.c.getCyan()+"    [" \
                     + self.c.getBlue()+self.strg + self.color \
                     + "{0:>6d}".format(value)+self.c.getCyan()+"] ==" \
                     + self.c.get_C_Reset()

        print(self.msg)
        self.writeToLog(color,self.msg)

    def printMesgAddEqBool(self,strg,color,value):
        self.strg  = strg
        self.color = color
        self.msg   = self.c.getCyan()+"    [" \
                     + self.c.getBlue()+self.strg+self.color \
                     + "{0}".format(value)+self.c.getCyan()+"] ==" \
                     + self.c.get_C_Reset()

        print(self.msg)
        self.writeToLog(color,self.msg)

    def printMesgAddStr(self,strg,color,value):
        self.strg  = strg
        self.color = color
        self.msg   = self.c.getCyan()+"    " \
                     + self.c.getBlue()+self.strg + self.color \
                     + "{0}".format(value) \
                     + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(color,self.msg)

    def printMesgAdd(self,strg):
        self.strg  = strg
        color = self.c.getCyan()
        self.msg   = self.c.getCyan()+"    " \
                     + self.c.getBlue()+self.strg  \
                     + self.c.get_C_Reset()
        print(self.msg)
        self.writeToLog(color,self.msg)

    #---------------------------------------------------------------------------
    # [Local-Timers]
    #---------------------------------------------------------------------------
    def get_zerolead_item(self, localtime_print):
        __func__= sys._getframe().f_code.co_name
        rc = self.c.get_RC_SUCCESS()

        import math
        if localtime_print > 0:
                if localtime_print < 10:
                        digits = int(math.log10(localtime_print))+1
                else:
                        digits = int(math.log10(localtime_print))
        elif localtime_print == 0:
                digits = 1
        else:
                digits = int(math.log10(-localtime_print))+2

        zerolead_item = np.power(10,digits)
        return rc, zerolead_item

    def get_local_current_Time(self,c):
        __func__= sys._getframe().f_code.co_name
        rc = c.get_RC_SUCCESS()
        #-----------------------------------------------------------------------
        # [Local-Time] Getting the local time
        #-----------------------------------------------------------------------
        rc, zerolead_mth = self.get_zerolead_item(time.localtime()[1])
        rc, zerolead_day = self.get_zerolead_item(time.localtime()[2])
        rc, zerolead_hrs = self.get_zerolead_item(time.localtime()[3])
        rc, zerolead_mns = self.get_zerolead_item(time.localtime()[4])
        rc, zerolead_scs = self.get_zerolead_item(time.localtime()[5])
        mth = str(time.localtime()[1]).zfill(len(str(zerolead_mth)))
        day = str(time.localtime()[2]).zfill(len(str(zerolead_day)))
        hrs = str(time.localtime()[3]).zfill(len(str(zerolead_hrs)))
        mns = str(time.localtime()[4]).zfill(len(str(zerolead_mns)))
        scs = str(time.localtime()[5]).zfill(len(str(zerolead_scs)))
        #Taking care of the day of the week
        which_day = ['Monday','Tuesday','Wednesday','Thursday','Friday',
                     'Saturday','Sunday']
        wd = time.localtime()[6]
        #Creating the time stamp message
        time_stamp = "["    + str(time.localtime()[0])  + \
                     "/"    + str(mth)                  + \
                     "/"    + str(day)                  + \
                     "<-->" + str(hrs)                  + \
                     ":"    + str(mns)                  + \
                     ":"    + str(scs)                  + \
                     "]*["  + which_day[wd]             + \
                     "-yd:" + str(time.localtime()[7])  + \
                     "]"

        return rc, time_stamp
    #---------------------------------------------------------------------------
    # [Timers]
    #---------------------------------------------------------------------------
    #printing the TimeElapsed message
    def printTimeElapsed(self,minutes,seconds):
        self.msg   = self.c.getCyan()    +" :: [Time elapsed: "       \
                     + self.c.getYellow()+str(minutes)                \
                     + self.c.getCyan()  +" minutes and"              \
                     + self.c.getYellow()+" {0:>.4f}".format(seconds) \
                     + self.c.getCyan()  +" seconds] ::"+self.c.get_C_Reset()
        print(self.msg)
        logging.info(self.msg)
        
    def printTotalTimeElapsed(self,minutes,seconds):
        self.msg   = self.c.getCyan()    +"TOTAL :: [Time elapsed: "  \
                     + self.c.getGreen() +str(minutes)                \
                     + self.c.getCyan()  +" minutes and"              \
                     + self.c.getYellow()+" {0:>.4f}".format(seconds) \
                     + self.c.getCyan()  +" seconds] ::"+self.c.get_C_Reset()
        print(self.msg)
        logging.info(self.msg)

    #BenchMarker printing methods
    def printBenchTotalTime_cpu(self,strg,color,tot_time,volume,info,__func__):
        time_taken = tot_time
        self.vx, self.vy, self.vz = volume
        minutes, secs = divmod(time_taken, 60)
        self.color = color
        self.msg = self.c.getCyan()     +" << ["                         \
                   + self.color         +strg                            \
                   + self.c.getCyan()   +": "                            \
                   + self.c.getCyan()   +"Line "                         \
                   + self.c.getGreen()  +"{0}".format(str(info.lineno))  \
                   + self.c.getCyan()   +": "                            \
                   + self.c.getYellow() +"{0}".format(info.filename)     \
                   + self.c.getCyan()   +" ---> "                        \
                   + self.c.getMagenta()+"{0}".format(__func__)          \
                   + self.c.getCyan()   +" ---> "                        \
                   + self.c.getGreen()  +str(self.vx)                    \
                   + self.c.getCyan()   +" x "                           \
                   + self.c.getGreen()  +str(self.vy)                    \
                   + self.c.getCyan()   +" x "                           \
                   + self.c.getGreen()  +str(self.vz)                    \
                   + self.c.getCyan()   +" ---> TOTAL :: "               \
                   + self.c.getYellow() +"{0:>.4f}".format(tot_time)     \
                   + self.c.getCyan()   +" secs"                         \
                   + self.c.getCyan()   +" ---> "                        \
                   + self.c.getYellow() +str(minutes)                    \
                   + self.c.getCyan()   +" min and"                      \
                   + self.c.getYellow() +" {0:>.4f}".format(secs)        \
                   + self.c.getCyan()   +" secs] >>"+self.c.get_C_Reset()
        print(self.msg)
        logging.info(self.msg)
        #writing to file bench for the total time
        if (self.c.getBench_cpu()==True):
            bf_msg = str(self.vx)+" "+"{0:>.4f}\n".format(tot_time)
            self.benchfile.write(bf_msg)

    def printBenchTime_cpu(self,strg,color,stopwatch,info,__func__):
        time_taken = src.PythonCodes.utils.StopWatch.GetTimerValue_secs(stopwatch)#GetTimerValue_secs(stopwatch)
        minutes, secs = divmod(time_taken, 60)
        self.color = color
        self.msg = self.c.getCyan()     +" << ["                         \
                   + self.color         +strg                            \
                   + self.c.getCyan()   +": "                            \
                   + self.c.getCyan()   +"Line "                         \
                   + self.c.getGreen()  +"{0}".format(str(info.lineno))  \
                   + self.c.getCyan()   +": "                            \
                   + self.c.getYellow() +"{0}".format(info.filename)     \
                   + self.c.getCyan()   +" ---> "                        \
                   + self.c.getMagenta()+"{0}".format(__func__)          \
                   + self.c.getCyan()   +" ---> "                        \
                   + self.c.getYellow() +str(minutes)                    \
                   + self.c.getCyan()   +" min and"                      \
                   + self.c.getYellow() +" {0:>.4f}".format(secs)        \
                   + self.c.getCyan()   +" secs] >>" + self.c.get_C_Reset()
        print(self.msg)
        logging.info(self.msg)

    def printBenchVolume(self,strg,color,vx,vy,vz,info,__func__):
        self.vx, self.vy, self.vz = (vx,vy,vz)
        self.color = color
        self.msg = self.c.getCyan()     +" << ["                         \
                   + self.color         +strg                            \
                   + self.c.getCyan()   +": "                            \
                   + self.c.getCyan()   +"Line "                         \
                   + self.c.getGreen()  +"{0}".format(str(info.lineno))  \
                   + self.c.getCyan()   +": "                            \
                   + self.c.getYellow() +"{0}".format(info.filename)     \
                   + self.c.getCyan()   +" ---> "                        \
                   + self.c.getMagenta()+"{0}".format(__func__)          \
                   + self.c.getCyan()   +" ---> "                        \
                   + self.c.getGreen()  +str(self.vx)                    \
                   + self.c.getCyan()   +" x "                           \
                   + self.c.getGreen()  +str(self.vy)                    \
                   + self.c.getCyan()   +" x "                           \
                   + self.c.getGreen()  +str(self.vz)                    \
                   + self.c.getCyan()   +" voxels] >>"+self.c.get_C_Reset()
        print(self.msg)
        logging.info(self.msg)

    def printBenchMap(self,strg,color,mapf,info,__func__):
        self.mapf = mapf
        self.color = color
        self.msg = self.c.getCyan()     +" << ["                         \
                   + self.c.getBlue()   +strg                            \
                   + self.c.getCyan()   +": "                            \
                   + self.c.getCyan()   +"Line "                         \
                   + self.c.getGreen()  +"{0}".format(str(info.lineno))  \
                   + self.c.getCyan()   +": "                            \
                   + self.c.getYellow() +"{0}".format(info.filename)     \
                   + self.c.getCyan()   +" ---> "                        \
                   + self.c.getMagenta()+"{0}".format(__func__)          \
                   + self.c.getCyan()   +" ---> "                        \
                   + self.color         +str(self.mapf)                  \
                   + self.c.getCyan()   +"] >>"+self.c.get_C_Reset()
        print(self.msg)
        logging.info(self.msg)
        
    #print an empty line    
    def printLine(self):
        print("")
#---------------------------------------------------------------------------
# Timer handlers creaters and starters and reporters
#---------------------------------------------------------------------------
