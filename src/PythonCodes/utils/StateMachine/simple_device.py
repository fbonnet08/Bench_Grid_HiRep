import sys
import os
#appending the utils path
from DataManage_common import *
#platform, release  = whichPlatform()
sysver, platform, system, release, node, processor, cpu_count = whichPlatform()
#TODO: If statement will be removed after checking
sys.path.append(os.path.join(os.getcwd(), '.'))
sys.path.append(os.path.join(os.getcwd(), '..'))
#local dir imports
#import my_states
import utils.StateMachine.my_states
# Applciation imports
#from messageHandler import *
#-------------------------------------------------------------------------------
# [SimpleDevice] StateMachine for DataManage application GUI and command line.
#-------------------------------------------------------------------------------
class SimpleDevice(object):
    def __init__(self,c,m):
        m.printMesg("Initialize the SimpleDevice components.") 
        # Start with a default state.
        self.state = utils.StateMachine.my_states.LockedState(c,m)
    def on_event(self, event):
        #Event handler for the new states
        self.state = self.state.on_event(event)
