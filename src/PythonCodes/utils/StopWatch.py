#!/usr/bin/env python
'''!\file
   -- DataManage addon: (Python3 code) Stopwatch code for benchmarking
      \author Frederic Bonnet
      \date 17th of August 2017

      Yale University August 2017
      Leiden University March 2020

Name:
---
StopWatch: module containing all the methods for Stopwatch class used in
           benchmarking.

Description of classes:
---
StopWatch is a self contained class used for benchmarking and progreess 
bars. It is a stop watch that measures time in milliseconds.

Requirements (system):
---
* sys

'''
#-------------------------------------------------------------------------------
# StopWatch definitions and methods
# Author: Frederic Bonnet
# Date: 17/08/2017
#-------------------------------------------------------------------------------
#System tools
#import sys
import datetime
#-------------------------------------------------------------------------------
# Timer handlers creaters and starters and reporters
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 class.
#StopWatch class for benchmarking and timing code accuaretly. It is a stop watch
class StopWatch:
    #***************************************************************************
    ##\brief Python3 method.
    #StopWatch class constructor, and initializes staopwatch variables. The
    #class is intantiated where ever there is a benchmarking or timing required
    #It can be instantiated anywhere as a one liner.
    #***************************************************************************
    #\param self          The Self Object
    def __init__(self):
        self.diff_time = 0
        self.total_time = 0
        self.clock_sessions = 0
        self.gtime = 1.0
        self.running = False
    #---------------------------------------------------------------------------
    # class methods
    #---------------------------------------------------------------------------
    #_gettimeofday = None
    #***************************************************************************
    ##\brief Python3 method.
    #Gets the time of the day using a C method called gettimeofday which is a
    #standard C method coming from time.h
    #***************************************************************************
    #\param self          The Self Object
    #\return gtime the time value.
    def gettimeofday(self):
        import ctypes
        import platform
        global _gettimeofday
        # getting the platform dependent libarary dependence
        system = platform.system()
        class timeval(ctypes.Structure):
            _fields_ = [("tv_sec", ctypes.c_long), ("tv_usec", ctypes.c_long)]
        tv = timeval()
        
        if (system == 'Linux'):
            _gettimeofday = ctypes.cdll.LoadLibrary("libc.so.6").gettimeofday
            _gettimeofday(ctypes.byref(tv), None)
            self.gtime = float(tv.tv_sec) + (float(tv.tv_usec) / 1000000)
        elif (system == 'Darwin'):
            _gettimeofday = ctypes.cdll.LoadLibrary("libc.dylib").gettimeofday
            _gettimeofday(ctypes.byref(tv), None)
            self.gtime = float(tv.tv_sec) + (float(tv.tv_usec) / 1000000)
        elif (system == 'Windows' or system != 'Darwin' or system != 'Linux'):
            _gettimeofday = ctypes.cdll.LoadLibrary("Kernel32.dll")
            #print("DataManage 1.0 is not supported under Windows")
            #print("Setting time to a constant value 1.0")
            #self.gtime = 1.0
            t_sec = datetime.datetime.now().second
            t_msec = datetime.datetime.now().microsecond
            self.gtime = float(t_sec) + (float(t_msec) / 1000000)

        return self.gtime

    #---------------------------------------------------------------------------
    # get the differential times
    #---------------------------------------------------------------------------
    #***************************************************************************
    ##\brief Python3 method.
    #Gets the time in milliseconds.
    #***************************************************************************
    #\param self          The Self Object
    #\return time the time value in milliseconds.
    def getDiffTime_msecs(self):
        self.t_time = self.gettimeofday()
        return (float)(1000.0 * (self.t_time - self.start_time))

    #***************************************************************************
    ##\brief Python3 method.
    #Gets the time in seconds.
    #***************************************************************************
    #\param self          The Self Object
    #\return time the time value in seconds.
    def getDiffTime_secs(self):
        self.t_time = self.gettimeofday()
        return (float)(self.t_time - self.start_time)
    #---------------------------------------------------------------------------
    # start
    #---------------------------------------------------------------------------
    #***************************************************************************
    ##\brief Python3 method.
    #Starts the timing
    #***************************************************************************
    #\param self          The Self Object
    #\return Sets object variable running to true and gets the starting time
    #from gettimeofday method
    def start(self):
        self.start_time = self.gettimeofday()
        self.running = True
    #---------------------------------------------------------------------------
    # stop in milliseconds and seconds
    #---------------------------------------------------------------------------
    #***************************************************************************
    ##\brief Python3 method.
    #Stops the timing in milliseconds
    #***************************************************************************
    #\param self          The Self Object
    #\return Sets object variable running to false and add the times
    def stop_msecs(self):
        self.diff_time = self.getDiffTime_msecs()
        self.total_time += self.diff_time
        self.running = False
        self.clock_sessions += self.clock_sessions

    #***************************************************************************
    ##\brief Python3 method.
    #Stops the timing in seconds
    #***************************************************************************
    #\param self          The Self Object
    #\return Sets object variable running to false and add the times
    def stop_secs(self):
        self.diff_time = self.getDiffTime_secs()
        self.total_time += self.diff_time
        self.running = False
        self.clock_sessions += self.clock_sessions
    #---------------------------------------------------------------------------
    # reset the stopwatch
    #---------------------------------------------------------------------------
    #***************************************************************************
    ##\brief Python3 method.
    #Resets the stop watch.
    #***************************************************************************
    #\param self          The Self Object
    def reset(self):
        self.diff_time = 0
        self.total_time = 0
        self.clock_sessions = 0
        #if (self.running) {gettimeofday(&start_time, 0);}
    #---------------------------------------------------------------------------
    # get the time in seconds and milliseconds after start
    #---------------------------------------------------------------------------
    #***************************************************************************
    ##\brief Python3 method.
    #Get the time in secsonds.
    #***************************************************************************
    #\param self          The Self Object
    #\return Gets the time in seconds.
    def getTime_secs(self):
        self.time = self.total_time;
        if (self.running):
            self.time+=self.getDiffTime_secs()
        return self.time

    #***************************************************************************
    ##\brief Python3 method.
    #Get the time in millisecsonds.
    #***************************************************************************
    #\param self          The Self Object
    #\return Gets the time in milliseconds.
    def getTime_msecs(self):
        self.time = self.total_time
        if (self.running):
            self.time+=self.getDiffTime_msecs()
        return self.time;
    #---------------------------------------------------------------------------
    # gets the average time in seconds after start
    #---------------------------------------------------------------------------
    #***************************************************************************
    ##\brief Python3 method.
    #Get the avreage time.
    #***************************************************************************
    #\param self          The Self Object
    #\return Average time.
    def getAverageTime(self):
        if (self.clock_sessions > 0 ):
            return self.total_time / self.clock_sessions  
        else:
            return 0.0
#---------------------------------------------------------------------------
# Timer handlers creaters and starters and reporters
#---------------------------------------------------------------------------
#***************************************************************************
##\brief Python3 method.
#Creates the timer
#***************************************************************************
#\return StopWatch
def createTimer():
    return StopWatch()

#***************************************************************************
##\brief Python3 method.
#Starts the timmer.
#***************************************************************************
def StartTimer(stopWath):
    stopWath.start()

#***************************************************************************
##\brief Python3 method.
#Stop the timer in milliseconds.
#***************************************************************************
def StopTimer_msecs(stopWath):
    stopWath.stop_msecs()

#***************************************************************************
##\brief Python3 method.
#Stop the timer in seconds.
#***************************************************************************
def StopTimer_secs(stopWath):
    stopWath.stop_secs()

#***************************************************************************
##\brief Python3 method.
#Resets the timer.
#***************************************************************************
def ResetTimer(stopWath):
    stopWath.reset()

#***************************************************************************
##\brief Python3 method.
#Gets the average timer value.
#***************************************************************************
def GetAverageTimerValue(stopWath):
    if (stopWath):
      return stopWath.getAverageTime()
    else:
      return 0.0

#***************************************************************************
##\brief Python3 method.
#Gets the timer value in milliseconds.
#***************************************************************************
def GetTimerValue_msecs(stopWath):
    if (stopWath):
      return stopWath.getTime_msecs()
    else:
      return 0.0

#***************************************************************************
##\brief Python3 method.
#Gets the timer value in seconds.
#***************************************************************************
def GetTimerValue_secs(stopWath):
    if (stopWath):
      return stopWath.getTime_secs();
    else:
      return 0.0
#---------------------------------------------------------------------------
# end of StopWatch module
#---------------------------------------------------------------------------
