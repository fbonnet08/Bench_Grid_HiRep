import os


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


