import sys
import os
import time
import threading
sys.path.append(os.path.join(os.getcwd(), '.'))
#from state import State
import utils.StateMachine.state
#-------------------------------------------------------------------------------
# [LockedState] state to indicates limited device capabilities
#-------------------------------------------------------------------------------
class LockedState(utils.StateMachine.state.State):
    def __init__(self,c,m):
        self.c = c
        self.m = m
    def on_event(self, event):
        if event == 'Start_computation':
            self.m.printMesg("Start_computation event return UnlockedState")
            #Call tasks to perform here...
            return self.Computing(event)
        return self
    #Here perform tasks until signal is sent to locak state again
    def Computing(self,event):
        for i in range(1):
            self.m.printMesgStr("The computation is starting: ",
                                self.c.getGreen(),str(i))
        #self.m.printMesg("   Done with computation.")
        return UnlockedState(self.c, self.m)
#-------------------------------------------------------------------------------
# [RunningState] running state fo the machine until Stop button is pressed
#-------------------------------------------------------------------------------
class RunningState(utils.StateMachine.state.State):
    def __init__(self,c,m):
        self.c = c
        self.m = m
    def on_event(self, event):
        if event == 'Start_computation': return LockedState(self.c, self.m)
        return self
#-------------------------------------------------------------------------------
# [UnlockedState] state for unlocking the device
#-------------------------------------------------------------------------------
class UnlockedState(utils.StateMachine.state.State):
    def __init__(self,c,m):
        self.c = c
        self.m = m
    def on_event(self, event):
        if event == 'device_locked': return LockedState(self.c,self.m)
        return self
