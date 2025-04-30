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
                        [--sombrero_action=SOMBRERO_ACTION]
                        [--simulation_size=SIMULATION_SIZE]

NOTE: select and option

Arguments: Either choose the --scan_number or the retention tim --RT

    Examples:
        python Bench_Grid_HiRep.py --help

        default is serial:
        python Bench_Grid_HiRep.py --grid
        python Bench_Grid_HiRep.py --hirep
        python Bench_Grid_HiRep.py --bkeeper_action=[BKeeper_run_cpu, BKeeper_run_gpu]
        python Bench_Grid_HiRep.py --sombrero_action=[Sombrero_weak, Sombrero_strong] --simulation_size=[small,large, small-large]

Options:
    --grid=GRID                       Grid switch to parse and analyse
    --hirep=HIREP                     HiRep switch to parse and analyse results
    --bkeeper_action=BKEEPER_ACTION   BKeeper switch to parse and analyse
    --sombrero_action=SOMBRERO_ACTION Sombrero action analysis
    --simulation_size=SIMULATION_SIZE Size of the simulation
    --help -h                         Show this help message and exit.
    --version                         Show version.
"""
# system imports
import os
import sys
from pathlib import Path
# path extension
sys.path.append(os.path.join(os.getcwd(), '.'))
sys.path.append(os.path.join(os.getcwd(), '.','src','PythonCodes'))
sys.path.append(os.path.join(os.getcwd(), '.','src','PythonCodes','utils'))
#Application imports
import src.PythonCodes.DataManage_common
import src.PythonCodes.utils.messageHandler
import src.PythonCodes.utils.Command_line
import src.PythonCodes.DataManage_header
import src.PythonCodes.utils.SystemCheck
import src.PythonCodes.utils.BatchOutTransformer
import src.PythonCodes.utils.LatticeModel_Analyser
import src.PythonCodes.utils.Bencher
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
    #------------------------------------------------------------------------
    # Main class instatiation
    #------------------------------------------------------------------------
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
    #------------------------------------------------------------------------
    # system details
    #------------------------------------------------------------------------
    syscheck = src.PythonCodes.utils.SystemCheck.SystemCheck(c, m)
    rc = syscheck.check_InstalledPackages()
    #------------------------------------------------------------------------
    # Some Path structure
    #------------------------------------------------------------------------
    c.setDebug(DEBUG)
    c.setApp_root(os.getcwd())
    m.printMesgStr("Application root path         :", c.getCyan(), c.getApp_root())
    #------------------------------------------------------------------------
    # Setting the variable into the common class
    #------------------------------------------------------------------------
    l = src.PythonCodes.utils.Command_line.Command_line(args, c, m)
    # building the command line
    l.createScan_number()
    l.createRet_time()
    #------------------------------------------------------------------------
    # [Paths-Setup]
    #------------------------------------------------------------------------
    current_path = str(Path(sys.path[0]))
    if current_path not in sys.path: sys.path.append(current_path)

    # linux VM machine
    if c.get_system() == "Linux":
        #DATA_PATH         = os.path.join(os.path.sep, 'data')    # , 'LC_MS'
        DATA_PATH         = os.path.join(os.path.sep, 'data', 'frederic','LatticeRuns','Clusters')
        DATAPROCINTERCOM  = os.path.join(os.path.sep, 'data', 'frederic', 'DataProcInterCom')
        TBLECNTS_DIR      = os.path.join(os.path.sep, 'data', 'frederic', 'DataProcInterCom', 'TableCounts')
        SQL_FULLPATH_DIR  = os.path.join(os.path.sep, 'data', 'frederic', 'SQLFiles_sql')
    # Windows Local machine
    if c.get_system() == "Windows":
        #DATA_PATH         = os.path.join('E:', 'data')    # , 'LC_MS'
        DATA_PATH         = os.path.join('E:','LatticeRuns','Clusters')
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
    #------------------------------------------------------------------------
    # [SystemPath-Appends]
    #------------------------------------------------------------------------
    sys.path.append(APP_ROOT)
    sys.path.append(APP_DATA_PATH)
    sys.path.append(DATA_PATH)
    sys.path.append(os.path.join(os.getcwd(), '..','..','..','..'))
    sys.path.append(os.path.join(APP_ROOT, '.'))
    sys.path.append(os.path.join(APP_ROOT, '.','src','PythonCodes'))
    sys.path.append(os.path.join(APP_ROOT, '.','src','PythonCodes','utils'))
    m.printMesgStr("Current Path              --->:", c.get_B_Blue(), current_path)
    m.printMesgStr("APP_ROOT                  --->:", c.get_B_Magenta(), APP_ROOT)
    m.printMesgStr("DATA_PATH                 --->:", c.get_B_Yellow(), DATA_PATH)
    m.printMesgStr("APP_DATA_PATH             --->:", c.get_B_Green(), APP_DATA_PATH)
    #------------------------------------------------------------------------
    c.setApp_root(APP_ROOT)
    c.setData_path(DATA_PATH)
    c.setProjectName(PROJECTNAME)
    c.setPool_componentdir(POOL_COMPONENTDIR)
    c.setSoftware(SOFTWARE)
    c.setDataProcInterCom(DATAPROCINTERCOM)
    c.setJSon_TableCounts_Dir(TBLECNTS_DIR)
    c.setSql_dir(SQL_DIR)
    c.setSql_fullPath_dir(SQL_FULLPATH_DIR)
    #------------------------------------------------------------------------
    # [Single-Multiprocessing]
    #------------------------------------------------------------------------
    l.createMultiprocessing_type()
    m.printMesgStr("Multiprocessing mode          :", c.get_B_Yellow(), c.getMultiprocessing_type())
    #------------------------------------------------------------------------
    # [Main-code]
    #------------------------------------------------------------------------
    m.printMesgStr("This is the main program      :", c.getCyan(), "Bench_Grid_HiRep.py")
    #------------------------------------------------------------------------
    # [Instantiating-Analysis-classes]
    #------------------------------------------------------------------------
    batch_transformer = src.PythonCodes.utils.BatchOutTransformer.BatchOutTransformer(c, m)
    lattice_bench_Analyser = src.PythonCodes.utils.LatticeModel_Analyser.LatticeModel_Analyser(c,m)
    bencher = src.PythonCodes.utils.Bencher.Bencher(c, m)
    # -----------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Analysis-Type]
    #------------------------------------------------------------------------
    if args['--grid']:
        l.createGrid()
        m.printMesgStr("Grid analysis                 :", c.getYellow(), c.getGrid())
    # [end-if args['--grid']]
    #------------------------------------------------------------------------
    if args['--hirep']:
        l.createHiRep()
        m.printMesgStr("HiRep analysis                :", c.getYellow(), c.getHiRep())
    # [end-if args['--hirep']]
    #------------------------------------------------------------------------
    msg_start = "--------------->"
    msg_end   = "<-------------->"
    if args['--sombrero_action'] == "Sombrero_weak":
        l.createSombreroAction()
        m.printMesgStr("Sombrero action and analysis  :", c.getYellow(), c.getSombreroAction())
        # -----------------------------------------------------------------------
        # [args['--simulation_size'] == "small":]
        # -----------------------------------------------------------------------
        if args['--simulation_size'] == "small":
            l.createSimulationSize()
            # -------------------------------------------------------------------
            m.printMesgStr("Simulation size for analysis  :", c.getYellow(), args['--simulation_size'])
            # -------------------------------------------------------------------
            # -------------------------------------------------------------------
            target_batch_action = "Sombrero_weak_cpu"
            batch_action = "Sombrero_weak"
            simulation_size   = "small"
            # -------------------------------------------------------------------
            # [Machine-list]
            # -------------------------------------------------------------------
            machine_name_sombrero_weak_small_lst = ["Lumi", "Vega", "Leonardo"]
            # -------------------------------------------------------------------
            # [Machine-loop]
            # -------------------------------------------------------------------
            for machine in machine_name_sombrero_weak_small_lst[:]:
                m.printMesgStr("Machine name  <---------------:", c.getBlue(), msg_start)
                m.printMesgStr("Machine name  --------------->:", c.getMagenta(), machine)
                #machine_name = "Lumi"
                DATA_PATH = os.path.join('E:','LatticeRuns','Clusters',machine,'LatticeRuns')
                # ---------------------------------------------------------------
                # ---------------------------------------------------------------
                rc = bencher.driver_BenchRes_Sombrero_weak(batch_transformer,
                                                            lattice_bench_Analyser,
                                                            machine,
                                                            target_batch_action,
                                                            batch_action, simulation_size,
                                                            DATA_PATH)
                # ---------------------------------------------------------------
                # ---------------------------------------------------------------
                m.printMesgStr("Machine name  <-------------->:", c.getMagenta(),
                               machine +" " + c.getBlue()+msg_end)
            # [end-for-loop [machine]]
        # -----------------------------------------------------------------------
        # [args['--simulation_size'] == "large":]
        # -----------------------------------------------------------------------
        # -----------------------------------------------------------------------
        # -----------------------------------------------------------------------
        if args['--simulation_size'] == "large":
            l.createSimulationSize()
            # -------------------------------------------------------------------
            m.printMesgStr("Simulation size for analysis  :", c.getYellow(), args['--simulation_size'])
            # -------------------------------------------------------------------
            # -------------------------------------------------------------------
            target_batch_action = "Sombrero_weak_cpu"
            batch_action = "Sombrero_weak"
            simulation_size   = "large"
            # -------------------------------------------------------------------
            # [Machine-list]
            # -------------------------------------------------------------------
            machine_name_sombrero_weak_large_lst = ["Lumi", "Vega", "Leonardo"]
            # -------------------------------------------------------------------
            # [Machine-loop]
            # -------------------------------------------------------------------
            for machine in machine_name_sombrero_weak_large_lst[:]:
                m.printMesgStr("Machine name  <---------------:", c.getBlue(), msg_start)
                m.printMesgStr("Machine name  --------------->:", c.getMagenta(), machine)
                #machine_name = "Lumi"
                DATA_PATH = os.path.join('E:','LatticeRuns','Clusters',machine,'LatticeRuns')
                # -------------------------------------------------------------------
                # -------------------------------------------------------------------
                rc = bencher.driver_BenchRes_Sombrero_weak(batch_transformer,
                                                            lattice_bench_Analyser,
                                                            machine,
                                                            target_batch_action,
                                                            batch_action, simulation_size,
                                                            DATA_PATH)
                # -------------------------------------------------------------------
                # -------------------------------------------------------------------
                m.printMesgStr("Machine name  <-------------->:", c.getMagenta(),
                               machine +" " + c.getBlue()+msg_end)
            # [end-for-loop [machine]]
        # -----------------------------------------------------------------------
        # [args['--simulation_size'] == "small-large":]
        # -----------------------------------------------------------------------
        if args['--simulation_size'] == "small-large":
            l.createSimulationSize()
            # -------------------------------------------------------------------
            m.printMesgStr("Simulation size for analysis  :", c.getYellow(), args['--simulation_size'])
            # -------------------------------------------------------------------
            simulation_size   = "small-large"
            # -------------------------------------------------------------------
            # [strength]
            # -------------------------------------------------------------------
            # -------------------------------------------------------------------
            target_batch_action = "Sombrero_weak_cpu"
            batch_action = "Sombrero_weak"
            # -------------------------------------------------------------------
            # [Machine-list]
            # -------------------------------------------------------------------
            machine_name_sombrero_weak_small_large_lst = ["Lumi", "Vega", "Leonardo"]
            # -------------------------------------------------------------------
            # [Machine-loop]
            # -------------------------------------------------------------------
            for machine in machine_name_sombrero_weak_small_large_lst[:]:
                m.printMesgStr("Machine name  <---------------:", c.getBlue(), msg_start)
                m.printMesgStr("Machine name  --------------->:", c.getMagenta(), machine)
                #machine_name = "Lumi"
                DATA_PATH = os.path.join('E:','LatticeRuns','Clusters',machine,'LatticeRuns')
                # --------------------------------------------------------------
                # --------------------------------------------------------------
                rc = bencher.driver_BenchRes_Sombrero_small_large(batch_transformer,
                                                                    lattice_bench_Analyser,
                                                                    machine,
                                                                    target_batch_action,
                                                                    batch_action, simulation_size,
                                                                    DATA_PATH)
                # --------------------------------------------------------------
                # --------------------------------------------------------------
                m.printMesgStr("Machine name  <-------------->:", c.getMagenta(),
                               machine +" " + c.getBlue()+msg_end)
            # [end-for-loop [machine]]
    # [end-if args['--sombrero_action']]
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    if args['--sombrero_action'] == "Sombrero_strong":
        l.createSombreroAction()
        m.printMesgStr("Sombrero action and analysis  :", c.getYellow(), c.getSombreroAction())
        # ----------------------------------------------------------------------
        # [args['--simulation_size'] == "small":]
        # ----------------------------------------------------------------------
        if args['--simulation_size'] == "small":
            l.createSimulationSize()
            # -------------------------------------------------------------------
            m.printMesgStr("Simulation size for analysis  :", c.getYellow(), args['--simulation_size'])
            # -------------------------------------------------------------------
            # -------------------------------------------------------------------
            simulation_size   = "small"
            # -------------------------------------------------------------------
            # [strength]
            # -------------------------------------------------------------------
            target_batch_action = "Sombrero_strg_cpu"
            batch_action = "Sombrero_strong"
            # -------------------------------------------------------------------
            # [Machine-list]
            # -------------------------------------------------------------------
            machine_name_sombrero_strong_small_lst = ["Lumi", "Vega", "Leonardo"]
            # -------------------------------------------------------------------
            # [Machine-loop]
            # -------------------------------------------------------------------
            for machine in machine_name_sombrero_strong_small_lst[:]:
                m.printMesgStr("Machine name  <---------------:", c.getBlue(), msg_start)
                m.printMesgStr("Machine name  --------------->:", c.getMagenta(), machine)
                #machine_name = "Lumi"
                DATA_PATH = os.path.join('E:','LatticeRuns','Clusters',machine,'LatticeRuns')
                # ---------------------------------------------------------------
                # ---------------------------------------------------------------
                rc = bencher.driver_BenchRes_Sombrero(batch_transformer,
                                                        lattice_bench_Analyser,
                                                        machine,
                                                        target_batch_action,
                                                        batch_action, simulation_size,
                                                        DATA_PATH)
                # ---------------------------------------------------------------
                # ---------------------------------------------------------------
                m.printMesgStr("Machine name  <-------------->:", c.getMagenta(),
                               machine +" " + c.getBlue()+msg_end)
            # [end-for-loop [machine]]
            # -------------------------------------------------------------------
            # [args['--simulation_size'] == "small":]
            # -------------------------------------------------------------------
            # -------------------------------------------------------------------
            # -------------------------------------------------------------------
        # -----------------------------------------------------------------------
        # [args['--simulation_size'] == "large":]
        # -----------------------------------------------------------------------
        if args['--simulation_size'] == "large":
            l.createSimulationSize()
            # -------------------------------------------------------------------
            m.printMesgStr("Simulation size for analysis  :", c.getYellow(), args['--simulation_size'])
            # -------------------------------------------------------------------
            # -------------------------------------------------------------------
            simulation_size   = "large"
            # -------------------------------------------------------------------
            # [strength]
            # -------------------------------------------------------------------
            target_batch_action = "Sombrero_strg_cpu"
            batch_action = "Sombrero_strong"
            # -------------------------------------------------------------------
            # [Machine-list]
            # -------------------------------------------------------------------
            machine_name_sombrero_strong_large_lst = ["Lumi"]
            # -------------------------------------------------------------------
            # [Lumi]
            # -------------------------------------------------------------------
            machine_name_lumi = "Lumi"
            DATA_PATH         = os.path.join('E:','LatticeRuns','Clusters',machine_name_lumi,'LatticeRuns')
            # -------------------------------------------------------------------
            # -------------------------------------------------------------------
        # -----------------------------------------------------------------------
        # [args['--simulation_size'] == "large":]
        # -----------------------------------------------------------------------
        if args['--simulation_size'] == "small-large":
            l.createSimulationSize()
            # -------------------------------------------------------------------
            m.printMesgStr("Simulation size for analysis  :", c.getYellow(), args['--simulation_size'])
            # -------------------------------------------------------------------
            simulation_size   = "small-large"
            # -------------------------------------------------------------------
            # [strength]
            # -------------------------------------------------------------------
            target_batch_action = "Sombrero_strg_cpu"
            batch_action = "Sombrero_strong"
            # -------------------------------------------------------------------
            # [Machine-list]
            # -------------------------------------------------------------------
            machine_name_sombrero_strong_small_large_lst = ["Lumi", "Vega", "Leonardo"]
            # -------------------------------------------------------------------
            # [Machine-loop]
            # -------------------------------------------------------------------
            for machine in machine_name_sombrero_strong_small_large_lst[:]:
                m.printMesgStr("Machine name  <---------------:", c.getBlue(), msg_start)
                m.printMesgStr("Machine name  --------------->:", c.getMagenta(), machine)
                #machine_name = "Lumi"
                DATA_PATH = os.path.join('E:','LatticeRuns','Clusters',machine,'LatticeRuns')
                # ---------------------------------------------------------------
                # ---------------------------------------------------------------
                rc = bencher.driver_BenchRes_Sombrero_small_large(batch_transformer,
                                                                    lattice_bench_Analyser,
                                                                    machine,
                                                                    target_batch_action,
                                                                    batch_action, simulation_size,
                                                                    DATA_PATH)
                # ---------------------------------------------------------------
                # ---------------------------------------------------------------
                m.printMesgStr("Machine name  <-------------->:", c.getMagenta(),
                               machine +" " + c.getBlue()+msg_end)
            # [end-for-loop [machine]]
            # -------------------------------------------------------------------
            # [args['--simulation_size'] == "small":]
            # -------------------------------------------------------------------
    # [end-if args['--sombrero_action']]
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    # -----------------------------------------------------------------------
    # [args['--bkeeper_action'] == "BKeeper_run_gpu":]
    # -----------------------------------------------------------------------
    if args['--bkeeper_action'] == "BKeeper_run_gpu":
        l.createBKeeperAction()
        m.printMesgStr("BKeeper action and analysis   :", c.getYellow(), c.getBKeeperAction())
        # -------------------------------------------------------------------
        batch_action      = "BKeeper_run_gpu"
        # -----------------------------------------------------------------------
        # [args['--simulation_size'] == "small":]
        # -----------------------------------------------------------------------
        if args['--simulation_size'] == "small":
            l.createSimulationSize()
            # ---------------------------------------------------------------
            m.printMesgStr("Simulation size for analysis  :", c.getYellow(), args['--simulation_size'])
            # ---------------------------------------------------------------
            # ---------------------------------------------------------------
            simulation_size   = "small"
            # -------------------------------------------------------------------
            # [Machine-list]
            # -------------------------------------------------------------------
            machine_name_bkeeper_small_lst = ["Lumi", "Vega", "Leonardo", "Mi300"]
            # -------------------------------------------------------------------
            # [Machine-loop]
            # -------------------------------------------------------------------
            for machine in machine_name_bkeeper_small_lst[:]:
                m.printMesgStr("Machine name  <---------------:", c.getBlue(), msg_start)
                m.printMesgStr("Machine name  --------------->:", c.getMagenta(), machine)
                #machine_name = "Lumi"
                DATA_PATH = os.path.join('E:','LatticeRuns','Clusters',machine,'LatticeRuns')
                # ---------------------------------------------------------------
                # ---------------------------------------------------------------
                rc = bencher.driver_BenchRes_BKeeper(batch_transformer,
                                                    lattice_bench_Analyser,
                                                    machine, batch_action, simulation_size,
                                                    DATA_PATH)
                # ---------------------------------------------------------------
                # ---------------------------------------------------------------
                m.printMesgStr("Machine name  <-------------->:",
                               c.getMagenta(), machine +" " + c.getBlue()+msg_end)
            # [end-for-loop [machine]]
            # -------------------------------------------------------------------
            # [args['--simulation_size'] == "small":]
            # -------------------------------------------------------------------
            # -------------------------------------------------------------------
            # -------------------------------------------------------------------
        # -----------------------------------------------------------------------
        # [args['--simulation_size'] == "large":]
        # -----------------------------------------------------------------------
        if args['--simulation_size'] == "large":
            l.createSimulationSize()
            # ---------------------------------------------------------------
            m.printMesgStr("Simulation size for analysis  :", c.getYellow(), args['--simulation_size'])
            # ---------------------------------------------------------------
            # ---------------------------------------------------------------
            simulation_size   = "large"
            # -------------------------------------------------------------------
            # [Machine-list]
            # -------------------------------------------------------------------
            machine_name_bkeeper_large_lst = ["Lumi", "Vega", "Mi300"]
            # -------------------------------------------------------------------
            # [Machine-loop]
            # -------------------------------------------------------------------
            for machine in machine_name_bkeeper_large_lst[:]:
                m.printMesgStr("Machine name  <---------------:", c.getBlue(), msg_start)
                m.printMesgStr("Machine name  --------------->:", c.getMagenta(), machine)
                #machine_name = "Lumi"
                DATA_PATH = os.path.join('E:','LatticeRuns','Clusters',machine,'LatticeRuns')
                # ---------------------------------------------------------------
                # ---------------------------------------------------------------
                rc = bencher.driver_BenchRes_BKeeper(batch_transformer,
                                                     lattice_bench_Analyser,
                                                     machine, batch_action, simulation_size,
                                                     DATA_PATH)
                # ---------------------------------------------------------------
                # ---------------------------------------------------------------
                m.printMesgStr("Machine name  <-------------->:",
                               c.getMagenta(), machine +" " + c.getBlue()+msg_end)
            # [end-for-loop [machine]]
            # -------------------------------------------------------------------
            # [args['--simulation_size'] == "small":]
            # -------------------------------------------------------------------
            # -------------------------------------------------------------------
            # -------------------------------------------------------------------
    # [end-if args['--bkeeper_action']]
    #------------------------------------------------------------------------
    #------------------------------------------------------------------------
    # [Final] overall return code
    #------------------------------------------------------------------------
    # Final exit statements
    src.PythonCodes.DataManage_common.getFinalExit(c, m, rc)
    #------------------------------------------------------------------------
    # End of testing script
    #------------------------------------------------------------------------



