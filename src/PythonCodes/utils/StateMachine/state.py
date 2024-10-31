import sys
import os
sys.path.append(os.path.join(os.getcwd(), '.'))
#-------------------------------------------------------------------------------
# [State] constructor and to string methos that writes out the current state.
# It provides some utility functions for the individual states within the state
# machine.
#-------------------------------------------------------------------------------
class State(object):
    def __init__(self): print("Processing current state:", str(self) )
    def __str__(self): return self.__class__.__name__
