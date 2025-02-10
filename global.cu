//
// Created by Frederic on 12/2/2023.
//
//Systems includes
#include <iostream>
// Apllication includes
#include "global.cuh"

// Global variable declarations
int Vx_o = 10;                //!<Volume size in x direction.
int Vy_o = 10;                //!<Volume size in y direction.
int Vz_o = 10;                //!<Volume size in z direction.
int nBases_o;            //!<Number of basis for the steerable filters
// Allocating the data structure
kernel_calc *s_kernel  = (struct kernel_calc*)malloc(sizeof(struct kernel_calc));
debug_gpu *s_debug_gpu = (struct debug_gpu*)malloc(sizeof(struct debug_gpu));
bench *s_bench = (struct bench*)malloc(sizeof(struct bench));
/* systems and accelerator structures */
Devices *s_Devices = (struct Devices*)malloc(sizeof(struct Devices));
deviceDetails *s_device_details = (struct deviceDetails*)malloc(sizeof(struct deviceDetails));
resources_avail *s_resources_avail = (struct resources_avail*)malloc(sizeof(struct resources_avail));
systemDetails *s_systemDetails = (struct systemDetails*)malloc(sizeof(struct systemDetails));
/* network structures */
machine_struct *s_machine_struct = (struct machine_struct*)malloc(sizeof(machine_struct));

//IPAddresses_struct *s_IPAddresses_struct = (struct IPAddresses_struct*)malloc(sizeof(IPAddresses_struct));
//adapters_struct *s_adapters_struct =  (struct adapters_struct*)malloc(sizeof(adapters_struct));
//socket_struct *s_socket_struct =  (struct socket_struct*)malloc(sizeof(socket_struct));
//network_struct *s_network_struct =  (struct network_struct*)malloc(sizeof(network_struct));

/* unite tests structure */
unitTest *s_unitTest = (struct unitTest*)malloc(sizeof(struct unitTest));
// Instantiating the class objects pointers
//namespace_Network::Network *p_network_o = new namespace_Network::Network(s_network_struct);
global *p_global_o = new global();

/*
namespace_Network::Socket *p_sockets_o = new namespace_Network::Socket(s_socket_struct);
namespace_Network::Network *p_network_o = new namespace_Network::Network(
  s_machine_struct,
  s_IPAddresses_struct,
  s_adapters_struct,
  s_socket_struct,
  s_network_struct);
*/

namespace_System_cpu::SystemQuery_cpu *p_SystemQuery_cpu_o = new namespace_System_cpu::SystemQuery_cpu();
namespace_System_gpu::SystemQuery_gpu *p_SystemQuery_gpu_o = new namespace_System_gpu::SystemQuery_gpu();
namespace_System_gpu::DeviceTools_gpu *p_DeviceTools_gpu_o = new namespace_System_gpu::DeviceTools_gpu();
namespace_Testing::testing_UnitTest *p_UnitTest_o = new namespace_Testing::testing_UnitTest();
////////////////////////////////////////////////////////////////////////////////
// Class global definition
////////////////////////////////////////////////////////////////////////////////
/* constructor */
global::global()  {int rc = RC_SUCCESS;
    /* initializing the structure variables */
    rc = global::_initialize();
  std::cout<<B_YELLOW<<"Class global::global() has been instantiated, return code: "<<B_GREEN<<rc<<COLOR_RESET<<std::endl;
}/* end of global constructor */
int global::_initialize() {
  int rc = RC_SUCCESS;
  /* TODO: insert the data structur einitialisers in the method when needed */
  rc = _initialize_kernel(s_kernel);                         if (rc != RC_SUCCESS) {rc = RC_WARNING;}
  rc = _initialize_debug(s_debug_gpu);                       if (rc != RC_SUCCESS) {rc = RC_WARNING;}
  rc = _initialize_bench(s_bench);                           if (rc != RC_SUCCESS) {rc = RC_WARNING;}
  /* system data structure initialisation */
  rc = _initialize_Devices(s_Devices);                       if (rc != RC_SUCCESS) {rc = RC_WARNING;}
  rc = _initialize_deviceDetails(s_device_details);          if (rc != RC_SUCCESS) {rc = RC_WARNING;}
  rc = _initialize_resources_avail(s_resources_avail);       if (rc != RC_SUCCESS) {rc = RC_WARNING;}
  rc = _initialize_systemDetails(s_systemDetails);           if (rc != RC_SUCCESS) {rc = RC_WARNING;}
  /* network data structure initialisation */
  rc = _initialize_machine_struct(s_machine_struct);            if (rc != RC_SUCCESS) {rc = RC_WARNING;}
  //rc = _initialize_IPAddresses_struct(s_IPAddresses_struct); if (rc != RC_SUCCESS) {rc = RC_WARNING;}
  //rc = _initialize_adapters_struct(s_adapters_struct);         if (rc != RC_SUCCESS) {rc = RC_WARNING;}
  //rc = _initialize_socket_struct(s_socket_struct);               if (rc != RC_SUCCESS) {rc = RC_WARNING;}
  //rc = _initialize_network_struct(s_network_struct);           if (rc != RC_SUCCESS) {rc = RC_WARNING;}
  /* unit test data structure initialisation */
  rc = _initialize_unitTest(s_unitTest);                     if (rc != RC_SUCCESS) {rc = RC_WARNING;}
  return rc;
} /* end of _initialize method */
int global::_initialize_kernel(kernel_calc *s_kernel) {
  int rc = RC_SUCCESS;
  s_kernel->time = 1.0;
  s_kernel->ikrnl = 1;
  s_kernel->threadsPerBlock = nthrdsBlock;
  s_kernel->nthrdx = nx_3D;
  s_kernel->nthrdy = ny_3D;
  s_kernel->nthrdz = nz_3D;
  return rc;
} /* end of _initialize_kernel method */
int global::_initialize_debug(debug_gpu *s_debug_gpu) {
  int rc = RC_SUCCESS;
  s_debug_gpu->debug_i = 1;
  s_debug_gpu->debug_cpu_i = 1;
  s_debug_gpu->debug_high_i = 1;
  // TODO: create a pointer towards a data structure debug_high *next
  s_debug_gpu->debug_high_s_Devices_i = 1;
  s_debug_gpu->debug_high_device_details_i = 1;
  s_debug_gpu->debug_high_s_resources_avail_i =1;
  s_debug_gpu->debug_high_s_systemDetails_i =1;
  s_debug_gpu->debug_high_s_network_struct_i = 1;
  s_debug_gpu->debug_high_s_socket_struct_i = 1;
  s_debug_gpu->debug_write_i = 1;
  s_debug_gpu->debug_write_C_i = 0;
  s_debug_gpu->debug_high_IPAddresses_struct_i = 1;
  s_debug_gpu->debug_adapters_struct_i = 1;
  s_debug_gpu->debug_high_adapters_struct_i = 1;
  return rc;
}/* end of _initialize_debug method */
int global::_initialize_bench(bench *s_bench) {
  int rc = RC_SUCCESS;
  s_bench->bench_i = 0;
  s_bench->bench_write_i = 0;
  return rc;
}/* end of _initialize_bench method */
int global::_initialize_Devices(Devices *s_Devices) {
  int rc = RC_SUCCESS;
  int ncuda_cores = 1;//!<Total number of cuda cores
  s_Devices->nDev = 1234;
  s_Devices->max_perf_dev = 12;
  s_Devices->ncuda_cores = &ncuda_cores;
  return rc;
} /* end of _initialize_Devices method */
int global::_initialize_deviceDetails(deviceDetails *s_device_details) {
  int rc = RC_SUCCESS;
  s_device_details->best_devID = 4567;//!<Best device for computation
  s_device_details->best_devID_name = (char*)malloc(256*sizeof(char));
  strcpy(s_device_details->best_devID_name,"Best Device");//!<Best device name
  s_device_details->best_devID_compute_major = 1;//!<Best device computa ability
  s_device_details->best_devID_compute_minor = 5;//!<Best device computa ability
  s_device_details->ndev = 1234;//!<Number of devices
  /* TODO: fix the initialisation of the array *dev_name */
  s_device_details->dev_name = (char*)malloc(256*sizeof(char));//!<Device name as a character
  strcpy(s_device_details->dev_name, "Some GPU Device");
  s_device_details->d_ver = 12.123; //!<Device version
  s_device_details->d_runver = 23.456;//!<Device runnning version
  s_device_details->tot_global_mem_MB = 34.789;//!<Total global memeory available in MB
  s_device_details->tot_global_mem_bytes = 12345;//!<Total global mem available bytes
  s_device_details->nMultiProc = 1;//!<Number of multiprocessors
  s_device_details->ncudacores_per_MultiProc = 23;//!<Number of cuda cores per MultiProcessors
  s_device_details->ncudacores = 456;//!<Total number of cuda cores
  s_device_details->is_SMsuitable = 789;//!<Is it SM suitable
  s_device_details->nregisters_per_blk = 12;//!<Number of registers per block
  s_device_details->warpSze = 21;//!<Warp size (usually 32)
  s_device_details->maxthreads_per_mp = 43;//!< Maximum number of threads per MultiProccessors
  s_device_details->maxthreads_per_blk = 56;//!<Maximum number of threads per blocks
  s_device_details->is_ecc = 78;//!<Is Device ECC enabled
  /* TODO: fix the initialisation of the array is_p2p */
  //s_device_details->is_p2p = new int [MAX_N_GPU][MAX_N_GPU];
  //s_device_details->is_p2p[MAX_N_GPU][MAX_N_GPU] = 123;//!<2D array for peer-2-peer computing
  return rc;
}/* end of _initialize_deviceDetails method */
int global::get_Devices_struct(Devices *s_Dev) {
  int rc = RC_SUCCESS;
  *s_Dev = namespace_System_gpu::devices_gpuGetMaxGflopsDeviceId(*s_Dev);
  return rc;
} /* end of get_deviceDetails_struct method */
int global::get_deviceDetails_struct(int idev, deviceDetails *devD) {
  int rc = RC_SUCCESS;
  cudaDeviceProp devProp_testing;
  cudaError_t error_id = cudaGetDeviceProperties(&devProp_testing, idev);
  if (error_id != cudaSuccess) { rc = namespace_System_gpu::get_error_id (error_id); }
  /* populating the data structure with the object methods */
  rc = p_SystemQuery_gpu_o->_initialize(devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}
  rc = p_SystemQuery_gpu_o->get_dev_count(devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}
  rc = p_SystemQuery_gpu_o->get_dev_Name(devProp_testing, devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}
  rc = p_SystemQuery_gpu_o->get_cuda_driverVersion((int*)&devD->d_ver, devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}
  rc = p_SystemQuery_gpu_o->get_cuda_runtimeVersion((int*)&devD->d_runver, devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}
  rc = p_SystemQuery_gpu_o->get_tot_global_mem_MB(devProp_testing, (float*)&devD->tot_global_mem_MB, devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}
  rc = p_SystemQuery_gpu_o->get_tot_global_mem_bytes(devProp_testing, &devD->tot_global_mem_bytes, devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}
  rc = p_SystemQuery_gpu_o->get_CUDA_cores(&devD->best_devID, devProp_testing,&devD->best_devID_compute_major, &devD->best_devID_compute_minor, &devD->nMultiProc, &devD->ncudacores_per_MultiProc, &devD->ncudacores, devD);  if (rc != RC_SUCCESS){rc = RC_FAIL;}
  rc = p_SystemQuery_gpu_o->get_nregisters(devProp_testing, &devD->nregisters_per_blk, devD); if (rc != RC_SUCCESS){rc = RC_WARNING;}
  rc = p_SystemQuery_gpu_o->get_thread_details(devProp_testing, &devD->warpSze, &devD->maxthreads_per_mp, &devD->maxthreads_per_blk, devD);if (rc != RC_SUCCESS){rc = RC_WARNING;}
  rc = p_SystemQuery_gpu_o->get_eec_support(devProp_testing, &devD->is_ecc, &devD->best_devID, devD);  if (rc != RC_SUCCESS){rc = RC_WARNING;}
  rc = p_SystemQuery_gpu_o->get_peer_to_peer_capabilities(devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}
  return rc;
} /* end of get_deviceDetails_struct method */
int global::_initialize_resources_avail(resources_avail *s_resources_avail) {
  int rc = RC_SUCCESS;
  /* TODO: implement the _initialize_bench method */
  return rc;
}/* end of _initialize_resources_avail method */
int global::_initialize_systemDetails(systemDetails *s_systemDetails) {
  int rc = RC_SUCCESS;
  s_systemDetails->n_phys_proc             = 1;
  s_systemDetails->nCPUlogical             = 1;
  s_systemDetails->hyper_threads           = false;
  s_systemDetails->cpuFeatures             = 0;
  s_systemDetails->cpuVendor               = (char*) malloc(12*sizeof(char));
  strcpy(s_systemDetails->cpuVendor, "SomeCPU");
  s_systemDetails->ProcessorArchitecture   = 0;
  s_systemDetails->total_phys_mem          = 0;
  s_systemDetails->avail_phys_mem          = 0;
#if defined (WINDOWS)
  s_systemDetails->MemoryLoad_pc           = 0.0;
  s_systemDetails->TotalPhys_kB            = 0;
  s_systemDetails->AvailPhys_kB            = 0;
  s_systemDetails->TotalPageFile_kB        = 0;
  s_systemDetails->AvailPageFile_kB        = 0;
  s_systemDetails->TotalVirtual_kB         = 0;
  s_systemDetails->AvailVirtual_kB         = 0;
  s_systemDetails->AvailExtendedVirtual_kB = 0;
#endif
  return rc;
}/* end of _initialize_systemDetails method */
int global::_initialize_machine_struct(machine_struct *s_machine) {
  int rc = RC_SUCCESS;
  //TODO: initialise the data global::_initialize_machine_struct(machine_struct *s_machine_struct)
  s_machine->nMachine_ipv4          = 1;
  s_machine->nMachine_macs          = 1;
  s_machine->hostname               = (char*) malloc((DEFAULT_MINIMUM_ENTITIES+4)*sizeof(char));
  strcpy(s_machine->hostname, "Some hostname");
  s_machine->platform               = (char*) malloc((DEFAULT_MINIMUM_ENTITIES+4)*sizeof(char));
  strcpy(s_machine->platform, "Some platform");
  return rc;
} /* end of _initialize_machine_struct method */

int global::_initialize_unitTest(unitTest *s_unitTest) {
  int rc = RC_SUCCESS;
  s_unitTest->launch_unitTest = 1;
  s_unitTest->launch_unitTest_systemDetails = 0;
  s_unitTest->launch_unitTest_deviceDetails = 0;
  s_unitTest->launch_unitTest_networks = 1;
  return rc;
}/* end of _initialize_unitTest method */
int global::_finalize() {
  int rc = RC_SUCCESS;
  try{
    //TODO: free the alocated pointers here, bring in the Eception class
  }
  catch(Exception<std::invalid_argument> &e){std::cerr<<e.what()<<std::endl;}
  catch(...){
    std::cerr<<B_YELLOW
      "Program error! Unknown type of exception occured."<<std::endl;
    std::cerr<<B_RED"Aborting."<<std::endl;
    rc = RC_FAIL;
    return rc;
  }
  return rc;
} /* end of _finalize method */
global::~global() {        int rc = RC_SUCCESS;
  rc = _finalize();
  if (rc != RC_SUCCESS) {
    std::cerr<<B_RED"return code: "<<rc
             <<" line: "<<__LINE__<<" file: "<<__FILE__<<C_RESET<<std::endl;
    exit(rc);
  } else {rc = RC_SUCCESS; /*print_destructor_message("DataDeviceManag");*/}
  rc = get_returnCode(rc, "global", 0);
}/* end of ~global destructor */
////////////////////////////////////////////////////////////////////////////////
// Helper methods
////////////////////////////////////////////////////////////////////////////////
// Get current date/time, format is YYYY-MM-DD.HH:mm:ss
const std::string currentDateTime() {
    time_t     now = time(0);
    struct tm  tstruct;
    char       buf[80];
    tstruct = *localtime(&now);
    // Visit http://en.cppreference.com/w/cpp/chrono/c/strftime
    // for more information about date/time format
    strftime(buf, sizeof(buf), "%Y-%m-%d.%X", &tstruct);

    return buf;
}/* end of currentDateTime method */
