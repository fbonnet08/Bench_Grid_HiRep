#!/usr/bin/env python
"""!\file
    -- Bench_Grid_HiRep.py usage addon: (Python3 code) Module for benchmarking Lattice QCD
        codes: Grid and HiRep.

Contributors:
    Main author: F.D.R. Bonnet 26 September 2024

Usage:
    Bench_Grid_HiRep.py [--grid=GRID]
                        [--hirep=HIREP]
                        [--bkeeper_action=BKEEPER_ACTION]

NOTE: select and option

Arguments: Either choose the --scan_number or the retention tim --RT

    Examples:
        python Bench_Grid_HiRep.py --help

        default is serial:
        python Bench_Grid_HiRep.py --grid
        python Bench_Grid_HiRep.py --hirep
        python Bench_Grid_HiRep.py --bkeeper_action=[BKeeper_run_cpu, BKeeper_run_gpu]

Options:
    --grid=GRID                      Grid switch to parse and analyse
    --hirep=HIREP                    HiRep switch to parse and analyse results
    --bkeeper_action=BKEEPER_ACTION  BKeeper switch to parse and analyse
    --help -h                        Show this help message and exit.
    --version                        Show version.
"""
# system imports
import os
import sys
# path extension
sys.path.append(os.path.join(os.getcwd(), '.'))
sys.path.append(os.path.join(os.getcwd(), '.','src','PythonCodes'))
sys.path.append(os.path.join(os.getcwd(), '.','src','PythonCodes','utils'))
#Application imports
import src.PythonCodes.DataManage_common
import src.PythonCodes.utils.messageHandler
import src.PythonCodes.utils.Command_line
import src.PythonCodes.DataManage_header
#
import src.PythonCodes.docopt

ext_asc = ".asc"
ext_csv = ".csv"
ext_raw = ".raw"
DEBUG = 0   # main debug switch in the entire application
# Main
if __name__ == "__main__":
    __func__= sys._getframe().f_code.co_name
    global version
    version = src.PythonCodes.DataManage_common.DataManage_version()
    c = src.PythonCodes.DataManage_common.DataManage_common()
    rc = c.get_RC_SUCCESS()
    # Getting the log file
    logfile = c.getLogfileName()  #getting the name of the global log file
    m = src.PythonCodes.utils.messageHandler.messageHandler(logfile = logfile)
    # setting up the argument list and parsing it
    args = src.PythonCodes.docopt.docopt(__doc__, version=version)
    # printing the header of Application
    src.PythonCodes.DataManage_header.print_Bench_Grid_header(common=c, messageHandler=m)
    #---------------------------------------------------------------------------
    # system details
    #---------------------------------------------------------------------------
    # TODO: need to insert the system details but ot needed now
    # platform, release  = whichPlatform()
    sysver, platform, system, release, node, processor, cpu_count = src.PythonCodes.DataManage_common.whichPlatform()
    #if (system == 'Linux'):
    m.printMesgStr("System                        : ", c.get_B_Green(), system)
    m.printMesgStr("System time stamp             : ", c.get_B_Yellow(), sysver)
    m.printMesgStr("Release                       : ", c.get_B_Magenta(), release)
    m.printMesgStr("Kernel                        : ", c.get_B_Cyan(), platform)
    m.printMesgStr("Node                          : ", c.get_B_Magenta(), node)
    m.printMesgStr("Processor type                : ", c.getMagenta(), processor)
    m.printMesgStr("CPU cores count               : ", c.get_B_Green(), cpu_count)
    #---------------------------------------------------------------------------
    # Some Path structure
    #---------------------------------------------------------------------------
    c.setDebug(DEBUG)
    c.setApp_root(os.getcwd())
    m.printMesgStr("Application root path         :", c.getCyan(), c.getApp_root())
    #---------------------------------------------------------------------------
    # Setting the variable into the common class
    #---------------------------------------------------------------------------
    l = src.PythonCodes.utils.Command_line.Command_line(args, c, m)
    # building the command line
    l.createScan_number()
    l.createRet_time()
    # --------------------------------------------------------------------------
    # [Paths-Setup]
    # --------------------------------------------------------------------------

    # linux VM machine
    if c.get_system() == "Linux":
        DATA_PATH         = os.path.join(os.path.sep, 'data')    # , 'LC_MS'
        DATAPROCINTERCOM  = os.path.join(os.path.sep, 'data', 'frederic', 'DataProcInterCom')
        TBLECNTS_DIR      = os.path.join(os.path.sep, 'data', 'frederic', 'DataProcInterCom', 'TableCounts')
        SQL_FULLPATH_DIR  = os.path.join(os.path.sep, 'data', 'frederic', 'SQLFiles_sql')
    # Windows Local machine
    if c.get_system() == "Windows":
        DATA_PATH         = os.path.join('E:', 'data')    # , 'LC_MS'
        DATAPROCINTERCOM  = os.path.join('E:', 'DataProcInterCom')
        TBLECNTS_DIR      = os.path.join('E:', 'DataProcInterCom', 'TableCounts')
        SQL_FULLPATH_DIR  = os.path.join('E:', 'SQLFiles_sql')
        #DATA_PATH         = os.path.join('C:', os.path.sep, 'Users', 'Frederic', 'OneDrive', 'UVPD-Perpignan', 'SourceCodes', 'SmallData')
        #DATAPROCINTERCOM  = os.path.join('C:', os.path.sep, 'Users', 'Frederic', 'OneDrive', 'UVPD-Perpignan', 'SourceCodes', 'SmallData','DataProcInterCom')
        #TBLECNTS_DIR      = os.path.join('C:', os.path.sep, 'Users', 'Frederic', 'OneDrive', 'UVPD-Perpignan', 'SourceCodes', 'SmallData','DataProcInterCom', 'TableCounts')
        #SQL_FULLPATH_DIR  = os.path.join('C:', os.path.sep, 'Users', 'Frederic', 'OneDrive', 'UVPD-Perpignan', 'SourceCodes', 'SmallData','SQLFiles_sql')
    # [end-if] statement
    APP_ROOT          = os.getcwd()
    PROJECTNAME       = ""
    POOL_COMPONENTDIR = ""
    SOFTWARE          = "N/A"
    SQL_DIR           = 'SQLFiles_sql'
    APP_DATA_PATH     = "N/A"
    # putting statting
    c.setApp_root(APP_ROOT)
    c.setData_path(DATA_PATH)
    c.setProjectName(PROJECTNAME)
    c.setPool_componentdir(POOL_COMPONENTDIR)
    c.setSoftware(SOFTWARE)
    c.setDataProcInterCom(DATAPROCINTERCOM)
    c.setJSon_TableCounts_Dir(TBLECNTS_DIR)
    c.setSql_dir(SQL_DIR)
    c.setSql_fullPath_dir(SQL_FULLPATH_DIR)
    # --------------------------------------------------------------------------
    # [Single-Multiprocessing]
    # --------------------------------------------------------------------------
    l.createMultiprocessing_type()
    m.printMesgStr("Multiprocessing mode          :", c.get_B_Yellow(), c.getMultiprocessing_type())
    # --------------------------------------------------------------------------
    # [Paths-Setup]
    # --------------------------------------------------------------------------
    m.printMesgStr("This is the main program      :", c.getCyan(), "Bench_Grid_HiRep.py")
    # --------------------------------------------------------------------------
    # [Main-code]
    # --------------------------------------------------------------------------
    if args['--grid']:
        l.createGrid()
        m.printMesgStr("Grid analysis                 :", c.getYellow(), c.getGrid())
    if args['--hirep']:
        l.createHiRep()
        m.printMesgStr("HiRep analysis                :", c.getYellow(), c.getHiRep())
    if args['--bkeeper_action']:
        l.createBKeeperAction()
        m.printMesgStr("BKeeper action and analysis   :", c.getYellow(), c.getBKeeperAction())
        # TODO: insert the main code here.


# ---------------------------------------------------------------------------
    # [Final] overall return code
    # ---------------------------------------------------------------------------
    # Final exit statements
    src.PythonCodes.DataManage_common.getFinalExit(c, m, rc)
    # ---------------------------------------------------------------------------
    # End of testing script
    # ---------------------------------------------------------------------------



