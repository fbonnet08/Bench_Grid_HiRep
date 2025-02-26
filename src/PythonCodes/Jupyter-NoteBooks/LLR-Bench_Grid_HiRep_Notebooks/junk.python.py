
start_key_rep_lst = [
    'Performing benchmark for SU(2), adjoint',
    'Performing benchmark for SU(2), fundamental',
    'Performing benchmark for SU(3), fundamental',
    'Performing benchmark for Sp(4), fundamental'
]
print ("start_key_rep_lst[:]       --->: ", start_key_rep_lst[:] )
print ("len(start_key_rep_lst[:])  --->: ", len(start_key_rep_lst[:]) )



#start_key_rep_ith = start_key_rep_lst[ikey]
#cnt = 0
#for ikey in range(len(start_key_rep_lst[:])):
#ikey = 0
#start_key_rep_ith = start_key_rep_lst[ikey]
#appending = False
#print (start_key_rep_lst[ikey])
#print("j --->: ", j)
#if start_key_rep_lst[ikey] in lines[j].split('\n')[0]:
#    appending = True
#if end_key_rep in lines[j].split('\n')[0]:
#    appending = False
#if ikey + 1 < len(start_key_rep_lst[:]):
#    if start_key_rep_lst[ikey+1] in lines[j].split('\n')[0]:
#        appending = True
#elif ikey + 1 = len(start_key_rep_lst[:]):
#elif appending:
#rc, cg_run_time_lst, FlOps_GFlOps_lst, Comms_MB_lst, Memory_GB_lst, mpi_distribution_lst, nnodes_lst, lattice_size_lst, representation_lst =

print (start_key_rep_lst[:])
print (len(start_key_rep_lst[:]))
print ("representation_lst[:]      --->: ", representation_lst[:] )
print ("len(representation_lst[:]) --->: ", len(representation_lst[:]) )


ikey = 1
start_key_rep_ith = start_key_rep_lst[ikey]
appending = False
print (start_key_rep_lst[ikey])
for j in range(database_file_len):
    #print("j --->: ", j)
    if start_key_rep_lst[ikey] in lines[j].split('\n')[0]:
        appending = True
    if end_key_rep in lines[j].split('\n')[0]:
        appending = False
    #if ikey + 1 < len(start_key_rep_lst[:]):
    #    if start_key_rep_lst[ikey+1] in lines[j].split('\n')[0]:
    #        appending = True
    #elif ikey + 1 = len(start_key_rep_lst[:]):
    elif appending:

        rc, cg_run_time_lst, FlOps_GFlOps_lst, Comms_MB_lst, Memory_GB_lst, mpi_distribution_lst, nnodes_lst, lattice_size_lst, representation_lst = extract_dataframes_from_representation(
            c, lines[j], split_string,
            start_key_rep_lst[ikey],
            cg_run_time_lst, FlOps_GFlOps_lst,
            Comms_MB_lst, Memory_GB_lst,
            mpi_distribution_lst, nnodes_lst,
            lattice_size_lst, representation_lst
        )
    # [end-if]
# [end-for-loop [ikey]]



def read_BKeeper_file_out(c, m, batch_action, simulation_size, target_file_cluster_lst):
    __func__= sys._getframe().f_code.co_name
    rc = c.get_RC_SUCCESS()
    m.printMesgStr("Getting target file list      :", c.getGreen(), __func__)
    end_key_rep = "###############################################"
    bench_BKeeper_dict = {}
    start_key_rep_lst = [
        'Performing benchmark for SU(2), adjoint',
        'Performing benchmark for SU(2), fundamental',
        'Performing benchmark for SU(3), fundamental',
        'Performing benchmark for Sp(4), fundamental'
    ]
    start_bkeeper_key = "BKeeper"
    # Starting the parsing of files over the start_key_lst
    # TODO: loop over the representation key
    #ikey = 0
    cg_run_time_lst = []
    FlOps_GFlOps_lst = []
    Comms_MB_lst = []
    Memory_GB_lst = []
    mpi_distribution_lst = []
    nnodes_lst = []
    lattice_size_lst = []
    representation_lst = []
    # Making sure that the list are empty before inserting anything
    cg_run_time_lst.clear()
    FlOps_GFlOps_lst.clear()
    Comms_MB_lst.clear()
    Memory_GB_lst.clear()
    mpi_distribution_lst.clear()
    nnodes_lst.clear()
    lattice_size_lst.clear()
    representation_lst.clear()
    #
    print (start_key_rep_lst[:])
    print (len(start_key_rep_lst[:]))
    for i in range(6): #tqdm.tqdm(range(len(target_file_cluster_lst[:])), ncols=100, desc='bench_BKeeper_dict'):
        #for i in range(len(target_file_cluster_lst[:])):
        cluster_file = open(target_file_cluster_lst[i])
        # Getting the mpi_distribution, lattice size and number of nodes
        ith_file = os.path.basename(target_file_cluster_lst[i].split('\n')[0]).split('.out')[0].split('Run_')[1].split(batch_action+'_')[1].split('_'+simulation_size)[0]
        split_string = ith_file.split('_')

        lines = cluster_file.readlines()
        database_file_len = len(lines)
        #start_key_rep_ith = start_key_rep_lst[ikey]
        #cnt = 0
        for ikey in range(len(start_key_rep_lst[:])):
            #ikey = 0
            start_key_rep_ith = start_key_rep_lst[ikey]
            appending = False
            print (start_key_rep_lst[ikey])

            for j in range(database_file_len):
                #print("j --->: ", j)
                if start_key_rep_lst[ikey] in lines[j].split('\n')[0]:
                    appending = True
                if end_key_rep in lines[j].split('\n')[0]:
                    appending = False
                if ikey + 1 < len(start_key_rep_lst[:]):
                    if start_key_rep_lst[ikey+1] in lines[j].split('\n')[0]:
                        appending = False
                #elif ikey + 1 = len(start_key_rep_lst[:]):

                elif appending:

                    rc = extract_dataframes_from_representation(
                        c, lines[j], split_string,
                        start_key_rep_lst[ikey],
                        cg_run_time_lst, FlOps_GFlOps_lst,
                        Comms_MB_lst, Memory_GB_lst,
                        mpi_distribution_lst, nnodes_lst,
                        lattice_size_lst, representation_lst
                    )
                # [end-if]
            # [end-for-loop [ikey]]

        # [end-for-loop [j]]
    # [end-for-loop [i]]
    bench_BKeeper_dict["Representation"]   = representation_lst[:]
    bench_BKeeper_dict["CG Run Time (s)"]  = cg_run_time_lst[:]
    bench_BKeeper_dict["FlOp/S (GFlOp/s)"] = FlOps_GFlOps_lst[:]
    bench_BKeeper_dict["Comms  (MB)"]      = Comms_MB_lst[:]
    bench_BKeeper_dict["Memory (GB)"]      = Memory_GB_lst[:]
    bench_BKeeper_dict["lattice"]          = lattice_size_lst[:]
    bench_BKeeper_dict["nodes"]            = nnodes_lst[:]
    bench_BKeeper_dict["mpi_distribution"] = mpi_distribution_lst[:]

    # creating a dictionary from the output data
    #print(" printing the dictionay ---->: ", bench_BKeeper_dict)
    dataframe = pandas.DataFrame.from_dict(bench_BKeeper_dict)

    return rc, dataframe
# [end-function]
# --------------------------------------------------------------------------




def extract_dataframes_from_representation(c, m, j, lines, split_string,
                                           start_key_rep_ith, end_key_rep,
                                           appending,
                                           cg_run_time_lst,
                                           FlOps_GFlOps_lst,
                                           Comms_MB_lst,
                                           Memory_GB_lst,
                                           mpi_distribution_lst,
                                           nnodes_lst,
                                           lattice_size_lst,
                                           representation_lst):
    __func__= sys._getframe().f_code.co_name
    rc = c.get_RC_SUCCESS()
    #m.printMesgStr("Getting target file list      :", c.getGreen(), __func__)
    # ----------------------------------------------------------------------
    start_bkeeper_key = "BKeeper"

    if start_key_rep_ith in lines[j].split('\n')[0]:
        appending = True
    if end_key_rep in lines[j].split('\n')[0]:
        appending = False
    elif appending:
        if start_bkeeper_key in lines[j].split('\n')[0]:
            if "CG Run Time (s)" in  lines[j].split('\n')[0]:
                key   = "CG Run Time (s)" #str(lines[j]).split(':')[0]
                value = str(str(lines[j]).split(':')[4]).split('\n')[0]
                cg_run_time_lst.append(float(value))

                lattice_size_lst.append(str(split_string[0]).split('lat'  )[1])
                mpi_distribution_lst.append(str(split_string[2]).split('mpi'  )[1])
                nnodes_lst.append(str(split_string[1]).split('nodes')[1])
                representation_lst.append(str(start_key_rep_ith).split('Performing benchmark for ')[1])

            if "FlOp/S (GFlOp/s)" in  lines[j].split('\n')[0]:
                key   = "FlOp/S (GFlOp/s)" #str(lines[j]).split(':')[0]
                value = str(str(lines[j]).split(':')[4]).split('\n')[0]
                FlOps_GFlOps_lst.append(float(value))
            if "Comms  (MB)" in  lines[j].split('\n')[0]:
                key   = "Comms" #str(lines[j]).split(':')[0]
                value = str(str(lines[j]).split(':')[4]).split('\n')[0]
                Comms_MB_lst.append(float(value))
            if "Memory (GB)" in  lines[j].split('\n')[0]:
                key   = "Memory (GB)" #str(lines[j]).split(':')[0]
                value = str(str(lines[j]).split(':')[4]).split('\n')[0]
                Memory_GB_lst.append(float(value))
    # [end-if]
    # ----------------------------------------------------------------------
    return rc, appending
# [end-function]




def read_BKeeper_file_out(c, m, batch_action, simulation_size, target_file_cluster_lst):
    __func__= sys._getframe().f_code.co_name
    rc = c.get_RC_SUCCESS()
    m.printMesgStr("Getting target file list      :", c.getGreen(), __func__)
    end_key_rep = "###############################################"
    bench_BKeeper_dict = {}
    start_key_rep_lst = [
        'Performing benchmark for SU(2), adjoint',
        'Performing benchmark for SU(2), fundamental',
        'Performing benchmark for SU(3), fundamental',
        'Performing benchmark for Sp(4), fundamental'
    ]
    start_bkeeper_key = "BKeeper"
    # Starting the parsing of files over the start_key_lst
    # TODO: loop over the representation key
    ikey = 0
    cg_run_time_lst = []
    FlOps_GFlOps_lst = []
    Comms_MB_lst = []
    Memory_GB_lst = []
    mpi_distribution_lst = []
    nnodes_lst = []
    lattice_size_lst = []
    representation_lst = []
    # Making sure that the list are empty before inserting anything
    cg_run_time_lst.clear()
    FlOps_GFlOps_lst.clear()
    Comms_MB_lst.clear()
    Memory_GB_lst.clear()
    mpi_distribution_lst.clear()
    nnodes_lst.clear()
    lattice_size_lst.clear()
    representation_lst.clear()
    #
    for i in tqdm.tqdm(range(len(target_file_cluster_lst[:])), ncols=100, desc='bench_BKeeper_dict'):
        #for i in range(len(target_file_cluster_lst[:])):
        cluster_file = open(target_file_cluster_lst[i])
        # Getting the mpi_distribution, lattice size and number of nodes
        ith_file = os.path.basename(target_file_cluster_lst[i].split('\n')[0]).split('.out')[0].split('Run_')[1].split(batch_action+'_')[1].split('_'+simulation_size)[0]
        split_string = ith_file.split('_')

        lines = cluster_file.readlines()
        database_file_len = len(lines)
        start_key_rep_ith = start_key_rep_lst[ikey]
        appending = False
        cnt = 0
        for j in range(database_file_len):
            if start_key_rep_ith in lines[j].split('\n')[0]:
                appending = True
            if end_key_rep in lines[j].split('\n')[0]:
                appending = False
            elif appending:
                if start_bkeeper_key in lines[j].split('\n')[0]:
                    if "CG Run Time (s)" in  lines[j].split('\n')[0]:
                        key   = "CG Run Time (s)" #str(lines[j]).split(':')[0]
                        value = str(str(lines[j]).split(':')[4]).split('\n')[0]
                        cg_run_time_lst.append(float(value))

                        lattice_size_lst.append(str(split_string[0]).split('lat'  )[1])
                        mpi_distribution_lst.append(str(split_string[2]).split('mpi'  )[1])
                        nnodes_lst.append(str(split_string[1]).split('nodes')[1])
                        representation_lst.append(str(start_key_rep_ith).split('Performing benchmark for ')[1])

                    if "FlOp/S (GFlOp/s)" in  lines[j].split('\n')[0]:
                        key   = "FlOp/S (GFlOp/s)" #str(lines[j]).split(':')[0]
                        value = str(str(lines[j]).split(':')[4]).split('\n')[0]
                        FlOps_GFlOps_lst.append(float(value))
                    if "Comms  (MB)" in  lines[j].split('\n')[0]:
                        key   = "Comms" #str(lines[j]).split(':')[0]
                        value = str(str(lines[j]).split(':')[4]).split('\n')[0]
                        Comms_MB_lst.append(float(value))
                    if "Memory (GB)" in  lines[j].split('\n')[0]:
                        key   = "Memory (GB)" #str(lines[j]).split(':')[0]
                        value = str(str(lines[j]).split(':')[4]).split('\n')[0]
                        Memory_GB_lst.append(float(value))
            # [end-if]
        # [end-for-loop [j]]
    # [end-for-loop [i]]
    bench_BKeeper_dict["Representation"]   = representation_lst[:]
    bench_BKeeper_dict["CG Run Time (s)"]  = cg_run_time_lst[:]
    bench_BKeeper_dict["FlOp/S (GFlOp/s)"] = FlOps_GFlOps_lst[:]
    bench_BKeeper_dict["Comms  (MB)"]      = Comms_MB_lst[:]
    bench_BKeeper_dict["Memory (GB)"]      = Memory_GB_lst[:]
    bench_BKeeper_dict["lattice"]          = lattice_size_lst[:]
    bench_BKeeper_dict["nodes"]            = nnodes_lst[:]
    bench_BKeeper_dict["mpi_distribution"] = mpi_distribution_lst[:]

    # creating a dictionary from the output data
    #print(" printing the dictionay ---->: ", bench_BKeeper_dict)
    dataframe = pandas.DataFrame.from_dict(bench_BKeeper_dict)

    return rc, dataframe
# [end-function]
# --------------------------------------------------------------------------








import os

start_grid_key    = "Grid"


#with open(target_file_cluster_lst[i]) as cluster_file:
#nnodes = target_file_cluster_lst[i].split()
#print(" target_file_cluster_lst["+str(i)+"] --->: ", ith_file )
# The list in question
#print( " split_string --->: ", split_string)

#print("<---->: "+ str(split_string[0]).split('lat'  )[1] +" <--->" + \
#      str(split_string[1]).split('nodes')[1]  +" <--->" + \
#        str(split_string[2]).split('mpi'  )[1] +"\n"
#)

#print("the number of lines in file "+ str(target_file_cluster_lst[i]) + " is : "+str(database_file_len))

#print(lines[j].split('\n')[0])
# TODO: continue from here

#print(lines[j].split('\n')[0])
if start_grid_key in lines[j].split('\n')[0]:
    if "Lattice dimensions" in lines[j].split('\n')[0]:
        print(" in Lattice dimensions")
        key   = "Lattice dimensions" #str(lines[j]).split(':')[0]
        value = str(str(lines[j]).split(':')[4]).split('\n')[0]
        lattice_size_lst.append(value)
    if "MPI decomposition" in lines[j].split('\n')[0]:
        key   = "MPI decomposition" #str(lines[j]).split(':')[0]
        value = str(str(lines[j]).split(':')[4]).split('\n')[0]
        mpi_distribution_lst.append(value)
if target_file_cluster_lst[i].split('.sh')[0] in  lines[j].split('\n')[0]:
    value = str(split_string[1]).split('nodes')[1]
    nnodes_lst.append(value)


    #else:
    #    cg_run_time_lst.append('-')

    #else:
    #    cg_run_time_lst.append('-')
    #else:
    #    cg_run_time_lst.append('-')



    #else:
    #    cg_run_time_lst.append('-')




machine_name="Lumi"

APP_ROOT          = os.path.join(os.getcwd(), '..','..','..','..')
#DATA_PATH         = os.path.join(APP_ROOT, '.','src','PythonCodes','data','Lumi')
DATA_PATH         = os.path.join(APP_ROOT, '..','LatticeRuns','Clusters',machine_name,'LatticeRuns') #E:\LatticeRuns\Clusters

vega_path="sftp://eufredericb@login.vega.izum.si/ceph/hpc/home/eufredericb/SwanSea/SourceCodes/LatticeRuns/BKeeper_run_gpu/small/Run_BKeeper_run_gpu_lat24.24.24.32_nodes001_mpi01-01-04-01_small/Run_BKeeper_run_gpu_lat24.24.24.32_nodes001_mpi01-01-04-01_small.out"

os.system('cat %s'%vega_path)


# Reinitialising the paths and object content.
c.setData_path(DATA_PATH)
c.setTarget_File("target.txt")

target_file_default = c.getTarget_File()
m.printMesgStr("Default target file           :", c.getMagenta(), target_file_default)

msg_analysis = c.getTarget_File().split(".txt")[0] + c.undr_scr + \
               batch_action    + c.undr_scr                    + \
               simulation_size + c.undr_scr                    + \
               "batch_files"   + c.txt_ext

c.setTarget_File(str(msg_analysis))
m.printMesgStr("Target file for analysis      :", c.getMagenta(), c.getTarget_File())

c.setTargetdir( os.path.join(c.getData_path(), c.getTarget_File()))
m.printMesgStr("Full Path target file         :", c.getCyan(), c.getTargetdir())

if Path(c.getTargetdir()).is_file():
    m.printMesgAddStr("[Check]: target file       --->: ", c.getGreen(), "Exists")


