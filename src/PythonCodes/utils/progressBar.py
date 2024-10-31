#!/usr/bin/env python
'''!\file
   -- ResMap addon: (Python3 code) class and methods for Progress bar
      \author Frederic Bonnet
      \date 17th of August 2017

      Yale University August 2017

Name:
---
progressBar: class and methods for rendering a progress bar on execution

Description of classes:
---
This class and methods are used to rendering a progress bar. The class uses 
{@link StopWatch} class for accurate timing.

Requirements (system):
---
* sys

Requirements (application):
---
* StopWatch
* progressBar
* ResMap_common
* messageHandler
'''
#----------------------------------------------------------------------------
# ProgressBar definitions and methods
# Author: Frederic Bonnet
# Date: 17/08/2017
#----------------------------------------------------------------------------
#System tools
import os
import sys
#appending the utils path
sys.path.append(os.path.join(os.getcwd(), '.'))
sys.path.append(os.path.join(os.getcwd(), '..'))
#application imports

import src.PythonCodes.DataManage_common

#from DataManage_common import *
#from StopWatch import *
import src.PythonCodes.utils.StopWatch
#from progressBar import *
#from messageHandler import *
import src.PythonCodes.utils.messageHandler
#---------------------------------------------------------------------------
# Defintion of the class
#---------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#ProgressBar class
#*******************************************************************************
class ProgressBar:
    #***************************************************************************
    ##\brief Python3 method.
    #ProgressBar class constructor. Initialisation of the Progress bar object
    #calls initialize method
    #***************************************************************************
    #\param self     Self object
    def __init__(self):
        '''!
        Initialisation of the Progress bar object
        calls initialize method
        '''
        #print("Hello ProgressBar")
        __func__= sys._getframe().f_code.co_name
        # first instantiating the common class
        self.c = src.PythonCodes.DataManage_common.DataManage_common()
        #instantiating messaging class
        logfile = self.c.getLogfileName()
        self.m = src.PythonCodes.utils.messageHandler.messageHandler(logfile = logfile)
        #initialize the method
        self.initialize()
        self.stopwatch = src.PythonCodes.utils.StopWatch.createTimer()
        src.PythonCodes.utils.StopWatch.StartTimer(self.stopwatch)
    #---------------------------------------------------------------------------
    # class methods
    #---------------------------------------------------------------------------
    #***************************************************************************
    ##\brief Python3 method.
    #initialises the variables
    #***************************************************************************
    #\param self     Self object
    def initialize(self):
        '''!
        Initialzes the class variable for the progress bar 
        '''
        self.firstPartOfpBar = "["
        self.lastPartOfpBar  = "]"
        self.pBarFiller      = ">"
        self.pBarUpdater     = ">"
        # data */
        self.printTimerEvent = True  #initialized but should be passed & set
        self.timer           = None
        self.prevTime        = 0.0
        self.pBarLength      = 50
        self.currUpdateVal   = 0
        self.currentProgress = 0
    
    #---------------------------------------------------------------------------
    #Resets the progress bar
    #---------------------------------------------------------------------------
    #***************************************************************************
    ##\brief Python3 method.
    #Resets the progress bar
    #***************************************************************************
    #\param self     Self object
    def resetprogressBar(self):
        '''!
        Resets the progress bar.
        '''
        src.PythonCodes.utils.StopWatch.ResetTimer(self.stopwatch)
        self.prevTime        = 0.0
        self.pBarLength      = 50
        self.currUpdateVal   = 0
        self.currentProgress = 0
    
    #---------------------------------------------------------------------------
    #Updates the progress bar
    #---------------------------------------------------------------------------
    #***************************************************************************
    ##\brief Python3 method.
    #Updates the progress bar
    #***************************************************************************
    #\param self     Self object
    def update(self, newProgress, nstep):
        '''!
        Updates the progress bar.
        '''
        self.neededProgress = nstep
        self.currentProgress += newProgress
        self.amountOfFiller = (int)((self.currentProgress/self.neededProgress) *
			            self.pBarLength )

    #---------------------------------------------------------------------------
    #Progress bar printer with adequate coloring depending on OS
    #---------------------------------------------------------------------------
    #***************************************************************************
    ##\brief Python3 method.
    #Progress bar printer with adequate coloring depending on OS
    #***************************************************************************
    #\param self     Self object
    def printEv(self): 
        '''!
        Prints the evolution of the progress bar. The coloring depends on OS
        Linux and Darwin: colored progress bar
        Windows         : colors are switched off
        '''
        self.currUpdateVal %= len(self.pBarUpdater)
        print(self.c.getCyan()+"\r"+self.firstPartOfpBar,end='',file=sys.stdout)
        for a in list(range(self.amountOfFiller)): #Prints current progress
            print(self.c.getGreen()+self.pBarFiller,end='',file=sys.stdout)
        print(self.pBarUpdater[self.currUpdateVal],end='',file=sys.stdout)
        #Prints spaces
        for b in list(range(self.pBarLength - self.amountOfFiller)):
            print(" ",end='',file=sys.stdout)
        self.prevTime = src.PythonCodes.utils.StopWatch.GetTimerValue_msecs(self.stopwatch)
        updatePrct = (int)(100*(self.currentProgress/self.neededProgress));
        print(self.c.getCyan()+self.lastPartOfpBar
	      +self.c.getCyan()+" ("+self.c.getMagenta()+ str(updatePrct)
	      + self.c.getCyan()+"%, "+self.c.getYellow()+"{0:>.4f}"
	      .format(self.prevTime/1000)
	      + self.c.getCyan()+" (secs))"+self.c.get_C_Reset(),end='',
              file=sys.stdout )
        self.currUpdateVal = self.currUpdateVal + 1

#print('{0: >#016.4f}'. format(float(x)))
#---------------------------------------------------------------------------
# end of progressBar module
#---------------------------------------------------------------------------
