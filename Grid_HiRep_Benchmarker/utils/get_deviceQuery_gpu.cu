//
// Created by Fred on 12/7/2023.
//
//#include "../include/common.cuh"
//#include "../include/get_deviceQuery_gpu.cuh"

#include "../global.cuh"
//#include "../include/Exception.cuh"
//#include "../include/resmap_Sizes.cuh"

namespace namespace_System_gpu {
#ifdef __cplusplus
extern "C" {
#endif

#if defined (CUDA)
  cudaDeviceProp deviceProp;
#endif
  /* ////////////////////////////////////////////////////////////////////////////
     -- class declaration SystemQuery_gpu
  */
  SystemQuery_gpu::SystemQuery_gpu() {
    int rc = RC_SUCCESS;
    /* initializing the structure variables */
    rc = SystemQuery_gpu::_initialize(); if (rc != RC_SUCCESS){rc = RC_WARNING;}
    std::cout<<B_BLUE<<"Class SystemQuery_gpu::SystemQuery_gpu() has been instantiated, return code: "<<B_GREEN<<rc<<COLOR_RESET<<std::endl;
  } /* end of SystemQuery_gpu constructor */
  SystemQuery_gpu::SystemQuery_gpu(deviceDetails_t *devD) {
    int rc = RC_SUCCESS;
    /* initializing the structure variables */
    rc = SystemQuery_gpu::_initialize(devD); if (rc != RC_SUCCESS){rc = RC_WARNING;}
    std::cout<<B_BLUE<<"Class SystemQuery_gpu::SystemQuery_gpu(deviceDetails_t *devD) has been instantiated, return code: "<<B_GREEN<<rc<<COLOR_RESET<<std::endl;
  } /* end of SystemQuery_gpu constructor */
  int SystemQuery_gpu::_initialize() {
    int rc = RC_SUCCESS;

    return rc;
  } /* end of _initialize method */
  int SystemQuery_gpu::_initialize(deviceDetails_t *devD) {
    int rc = RC_SUCCESS;
    /* populating the data structure */
    //int devID = 0; devID =
    findCudaDevice(deviceProp, devD);
    return rc;
  } /* end of _initialize(deviceDetails_t *devD) method */
  int SystemQuery_gpu::deviceDetails_init(int *idev, deviceDetails_t *devD) {
    int rc = RC_SUCCESS; //return code
    int dev = *idev;
#if defined (CUDA)
    cudaError_t error_id;

    //cudaSetDevice(dev); here sets the device for computation
    error_id = cudaGetDeviceProperties(&deviceProp, dev);
    if (error_id != cudaSuccess) { rc = get_error_id (error_id); }

    //method to find the device with the most capabilities
    //findCudaDevice(deviceProp);
    //TODO: add logic in case of additional multiple GPU selection process

    return rc;
  } /* end of deviceDetails_init method */
  int SystemQuery_gpu::deviceDetails_free(deviceDetails_t *devD) {
    int rc = RC_SUCCESS; //return code

    //TODO: insert freeing statement in case of allocations
#endif
    return rc;
  } /* end of deviceDetails_free method */
  int SystemQuery_gpu::findCudaDevice(cudaDeviceProp deviceProp, deviceDetails_t *devD) {
    int devID = 0;
    cudaError_t error_id;
    /*  pick the device with highest Gflops/s */
    devID = gpuGetMaxGflopsDeviceId();
    error_id = cudaSetDevice(devID); if (error_id != cudaSuccess) {get_error_id(error_id);}
    error_id = cudaGetDeviceProperties(&deviceProp, devID);
    devD->best_devID = devID;
    strcpy(devD->best_devID_name, deviceProp.name);
    devD->best_devID_compute_major = deviceProp.major;
    devD->best_devID_compute_minor = deviceProp.minor;

    std::cout<<B_BLUE<<"Most suitable GPU Device           ---> devID= "<<
        B_YELLOW<<devID<<": "<<B_CYAN<<"\""<<deviceProp.name<<"\""<<
            B_GREEN" with compute capability ---> "
    <<B_MAGENTA<<deviceProp.major<<"."<<deviceProp.minor<<COLOR_RESET<<std::endl;

    return devID;
  } /* --end of findCudaDevice method */
  /* This function returns the best GPU (with maximum GFLOPS) */
  inline int SystemQuery_gpu::gpuGetMaxGflopsDeviceId() {
    int current_device     = 0, sm_per_multiproc  = 0;
    int max_perf_device    = 0;
    int device_count       = 0, best_SM_arch      = 0;
    int devices_prohibited = 0;

    unsigned long long max_compute_perf = 0;
    cudaDeviceProp deviceProp;
    cudaError_t error_id;

    error_id = cudaGetDeviceCount(&device_count); if (error_id != cudaSuccess) {get_error_id(error_id);}

    if (device_count == 0) {
      fprintf(stderr, "gpuGetMaxGflopsDeviceId() CUDA error: no devices supporting CUDA.\n");
      exit(EXIT_FAILURE);
    }

    // Find the best major SM Architecture GPU device
    while (current_device < device_count) {
      cudaGetDeviceProperties(&deviceProp, current_device);

      // If this GPU is not running on Compute Mode prohibited,
      // then we can add it to the list
      if (deviceProp.computeMode != cudaComputeModeProhibited) {
        if (deviceProp.major > 0 && deviceProp.major < 9999) {
          best_SM_arch = SIMPLE_MAX(best_SM_arch, deviceProp.major);
        }
      } else {devices_prohibited++;}
      current_device++;
    }

    if (devices_prohibited == device_count) {
      fprintf(stderr, "gpuGetMaxGflopsDeviceId() CUDA error: all devices have compute mode prohibited.\n");
      exit(EXIT_FAILURE);
    }

    // Find the best CUDA capable GPU device
    current_device = 0;

    while (current_device < device_count) {
      cudaGetDeviceProperties(&deviceProp, current_device);

      // If this GPU is not running on Compute Mode prohibited, then we can add it to the list
      if (deviceProp.computeMode != cudaComputeModeProhibited) {
        if (deviceProp.major == 9999 && deviceProp.minor == 9999) {
          sm_per_multiproc = 1;
        } else {
          sm_per_multiproc = _ConvertSMVer2Cores(deviceProp.major,
                                                 deviceProp.minor);
        }

        unsigned long long compute_perf  =
          (unsigned long long) deviceProp.multiProcessorCount *
                               sm_per_multiproc               *
                               deviceProp.clockRate;

        if (compute_perf  > max_compute_perf) {
          // If we find GPU with SM major > 2, search only these
          if (best_SM_arch > 2) {
            // If our device==dest_SM_arch, choose this, or else pass
            if (deviceProp.major == best_SM_arch) {
              max_compute_perf  = compute_perf;
              max_perf_device   = current_device;
            }
          } else {
            max_compute_perf  = compute_perf;
            max_perf_device   = current_device;
          }
        }
      }
      ++current_device;
    }

    return max_perf_device;
  } /* --end of gpuGetMaxGflopsDeviceId */
  /* General check for CUDA GPU SM Capabilities */
  inline bool SystemQuery_gpu::checkCudaCapabilities(int major_version, int minor_version) {
#if defined (CUDA)
    if ((deviceProp.major > major_version) || (deviceProp.major == major_version && deviceProp.minor >= minor_version)) {
      return true;
    } else { return false; }
#elif
    return false;
#endif
  } /* end of checkCudaCapabilities method */
  /* sets the device for computation */
  int SystemQuery_gpu::setDevice(int *idev) {
    int rc = RC_SUCCESS;
    int dev = *idev;

    cudaError_t error_id;
    cudaDeviceProp deviceProp_m;

    //cudaSetDevice(dev); here sets the device for computation
    error_id = cudaGetDeviceProperties(&deviceProp_m, dev);
    if (error_id != cudaSuccess) { rc = get_error_id (error_id); }

    error_id = cudaSetDevice(dev); //here sets the device for computation
    if (error_id != cudaSuccess) { rc = get_error_id (error_id); }

    return rc;
  } /* end of setDevice method */
  /* Beginning of GPU Architecture definitions */
  inline int SystemQuery_gpu::_ConvertSMVer2Cores(int major, int minor) {
    /* Defines for GPU Architecture types (using the SM version to determine
     * the # of cores per SM)
     * 0xMm (hexidecimal notation),
     * M = SM Major version, and m = SM minor version */
    typedef struct {
      int SM;
      int Cores;
    } sSMtoCores;

    sSMtoCores nGpuArchCoresPerSM[] = {
      { 0x20, 32 }, /* Fermi Generation (SM 2.0) GF100 class */
      { 0x21, 48 }, /* Fermi Generation (SM 2.1) GF10x class */
      { 0x30, 192}, /* Kepler Generation (SM 3.0) GK10x class */
      { 0x32, 192}, /* Kepler Generation (SM 3.2) GK10x class */
      { 0x35, 192}, /* Kepler Generation (SM 3.5) GK11x class */
      { 0x37, 192}, /* Kepler Generation (SM 3.7) GK21x class */
      { 0x50, 128}, /* Maxwell Generation (SM 5.0) GM10x class */
      { 0x52, 128}, /* Maxwell Generation (SM 5.2) GM20x class */
      { 0x60, 64 }, // Pascal Generation (SM 6.0) GP100 class
      { 0x61, 128}, // Pascal Generation (SM 6.1) GP10x class
      { 0x62, 128}, // Pascal Generation (SM 6.2) GP10x class
      { 0x70, 64 }, // Volta Generation (SM 7.0) GV100 class
      {   -1, -1 }
    };

    int index = 0;

    while (nGpuArchCoresPerSM[index].SM != -1) {
        if (nGpuArchCoresPerSM[index].SM == ((major << 4) + minor)) {
            return nGpuArchCoresPerSM[index].Cores;
	  }
        index++;
      }

    /* If we don't find the values, we default use the previous one to run properly */
    printf("MapSMtoCores for SM %d.%d is undefined. Default to use %d Cores/SM\n",
	   major, minor, nGpuArchCoresPerSM[index-1].Cores);
    return nGpuArchCoresPerSM[index-1].Cores;
  } /* end of _ConvertSMVer2Cores method */
  /* getting the warning message from the cuda */
  int SystemQuery_gpu::get_ecc_warning_message(deviceDetails_t *devD) {
    int rc = RC_SUCCESS;

    printf(B_CYAN);
    printf("***************************WARNING*****************************\n");
    printf("Device: " B_RED "%s"
           B_CYAN
           " does not have error correcting code \n",devD->dev_name);
    printf("memory (ECC) enabled. This is probably because the device does \n");
    printf("not have CUDA computing capabilities. Check that the correct   \n");
    printf("device has been selected.                                      \n");
    printf("***************************************************************\n");
    printf(C_RESET);

    return rc;
  } /* end of get_ecc_warning_message method */
  /* getting the warning message from the cuda */
  int SystemQuery_gpu::get_warning_message() {
    int rc = RC_SUCCESS;

    printf("***************************WARNING*****************************\n");
    printf("You need to compile with -DCUDA to acces the CUDA environment  \n");
    printf("computation using GPU                                          \n");
    printf("***************************************************************\n");
    printf("\n");
    printf("Exit at Line %i in file %s %s\n",__LINE__,__FILE__,__FUNCTION__);
    printf("\n");
    rc = RC_FAIL;

    return rc;
  } /* end of get_warning_message method */
  /* getting the error id from the cuda */
  int SystemQuery_gpu::get_error_id(cudaError_t error_id) {
    int rc = RC_SUCCESS;
    printf("cudaDriverGetVersion returned %d\n-> %s\n",
	     (int)error_id, cudaGetErrorString(error_id));
    printf("Result = FAIL\n");
    printf("Exit at Line %i in file %s %s\n",__LINE__,__FILE__,__FUNCTION__);
    rc = (int)error_id;
    exit(EXIT_FAILURE);
    return rc;
  } /* end of get_error_id method */
  /* getting the cuda cores error */
  int SystemQuery_gpu::get_cuda_cores_error(int ncores) {
    int rc = RC_SUCCESS;
    /* TODO: need to fix up the function where this methdo has been called from */
    printf("There are no CUDA cores available on system %d\n",ncores);
    printf("Result = FAIL\n");
    printf("Exit at Line %i in file %s %s\n",__LINE__,__FILE__,__FUNCTION__);
    rc = RC_FAIL;
    //exit(EXIT_FAILURE);
    return rc;
  }/* --end of get_cuda_cores_error method --*/
  /* getting the driver version */
  int SystemQuery_gpu::get_cuda_driverVersion(int *driverVersion , deviceDetails_t *devD) {
    int rc = RC_SUCCESS;
    cudaError_t error_id;

    error_id = cudaDriverGetVersion(driverVersion);
    if (error_id != cudaSuccess) { rc = get_error_id (error_id); }

    devD->d_ver = (float)*driverVersion/1000;

    return rc;
  } /* end of get_cuda_driverVersion method */
  /* getting the runtime version */
  int SystemQuery_gpu::get_cuda_runtimeVersion(int *runtimeVersion , deviceDetails_t *devD) {
    int rc = RC_SUCCESS;
    cudaError_t error_id;

    error_id = cudaRuntimeGetVersion(runtimeVersion);
    if (error_id != cudaSuccess) { rc = get_error_id (error_id); }

    devD->d_runver = (float)*runtimeVersion / 1000;

    return rc;
  } /* end of get_cuda_runtimeVersion method */
  /* getting the name of the device */
  int SystemQuery_gpu::get_dev_Name(cudaDeviceProp deviceProp, deviceDetails_t *devD) {
    int rc = RC_SUCCESS;

    strcpy(devD->dev_name, deviceProp.name);
    if (strlen(devD->dev_name) == 0) {
      rc = RC_WARNING;
      std::cout<<" devD->dev_name is an empty string ---> "<<devD->dev_name<<std::endl;
    }

    return rc;
  } /* end of get_dev_Name method */
  /* get the number of devices avaible on the system */
  int SystemQuery_gpu::get_dev_count(deviceDetails_t *devD) {
    int rc = RC_SUCCESS; //return code
    int devCnt = 0;

    //#if defined (CUDA)
    cudaError_t error_id = cudaGetDeviceCount(&devCnt);
    devD->ndev = devCnt;
    //printf(B_GREEN"devD->ndev = %i Devices\n"C_RESET
    //       ,devD->ndev);
    if (error_id != cudaSuccess) { rc = get_error_id (error_id); }
    //#else
    //    rc = get_warning_message();
    //#endif
    return rc;
  } /* end of get_dev_count method */
  /* getting the memory from the devices */
  int SystemQuery_gpu::get_tot_global_mem_MB(cudaDeviceProp deviceProp, float *totalGlobalMem_MB, deviceDetails_t *devD) {
    int rc = RC_SUCCESS;

    *totalGlobalMem_MB = (float)deviceProp.totalGlobalMem/1048576.0f;
    devD->tot_global_mem_MB = *totalGlobalMem_MB;

    return rc;
  }/* end of get_tot_global_mem_MB method */
  /* getting the memory from the devices */
  int SystemQuery_gpu::get_tot_global_mem_bytes(cudaDeviceProp deviceProp, unsigned long long *totalGlobalMem_bytes, deviceDetails_t *devD) {
    int rc = RC_SUCCESS;

    *totalGlobalMem_bytes = (unsigned long long) deviceProp.totalGlobalMem;
    devD->tot_global_mem_bytes = *totalGlobalMem_bytes;

    return rc;
  } /* end of get_tot_global_mem_bytes method */
  /* getting the threads details */
  int SystemQuery_gpu::get_thread_details(cudaDeviceProp deviceProp, int *warpSize, int *max_threads_per_mp, int *max_threads_per_blk, deviceDetails_t *devD) {
    int rc = RC_SUCCESS;

    *warpSize = deviceProp.warpSize;
    devD->warpSze = *warpSize;
    *max_threads_per_mp = deviceProp.maxThreadsPerMultiProcessor;
    devD->maxthreads_per_mp = *max_threads_per_mp;
    *max_threads_per_blk = deviceProp.maxThreadsPerBlock;
    devD->maxthreads_per_blk = *max_threads_per_blk;

    return rc;
  } /* end of get_thread_details method */
  /* getting the number of registers */
  int SystemQuery_gpu::get_nregisters(cudaDeviceProp deviceProp, int *nregisters_per_blk, deviceDetails_t *devD) {
    int rc = RC_SUCCESS;

    *nregisters_per_blk = deviceProp.regsPerBlock;
    devD->nregisters_per_blk = *nregisters_per_blk;

    return rc;
  } /* end of get_nregisters method */
  /* getting # of Multiprocessors, CUDA cores/MP and total # of CUDA cores */
  int SystemQuery_gpu::get_CUDA_cores(int *idev, cudaDeviceProp deviceProp, int *gpu_major, int *gpu_minor, int *nmp, int *cuda_cores_per_mp, int *ncuda_cores,  deviceDetails_t *devD) {
    int rc = RC_SUCCESS;
    //int dev = *idev;
    int major = *gpu_major; int minor = *gpu_minor;

    *nmp = deviceProp.multiProcessorCount;
    devD->nMultiProc = *nmp;
    *cuda_cores_per_mp = _ConvertSMVer2Cores(deviceProp.major, deviceProp.minor);
    devD->ncudacores_per_MultiProc = *cuda_cores_per_mp;
    *ncuda_cores = _ConvertSMVer2Cores(deviceProp.major, deviceProp.minor) *
                   deviceProp.multiProcessorCount;
    devD->ncudacores = *ncuda_cores;
    if (devD->ncudacores == 0 ) { rc = get_cuda_cores_error(devD->ncudacores); }
    /* requiring at leat a gpu_major.gpu_minor architecture Tesla card */
    bool bVal = checkCudaCapabilities(major,minor);
    /*    printf(B_BLUE"Device %d: < "
           B_YELLOW"%16s"B_BLUE
           " >, Compute SM %d.%d detected, **suitable: %s**\n",
       dev, deviceProp.name, deviceProp.major, deviceProp.minor,
           bVal?B_GREEN"yes"C_RESET :
                  B_RED"no" C_RESET);
    */
    devD->is_SMsuitable = bVal;

    return rc;
  } /* end of get_CUDA_cores method */
  /* determine if peer to peer is allowed */
  int SystemQuery_gpu::get_peer_to_peer_capabilities(deviceDetails_t *devD) {
    int rc = RC_SUCCESS;

    //devD->is_p2p = false; /*initialises the p2p to false */

    cudaDeviceProp a_deviceProp[MAX_N_GPU];
    int gpuid[MAX_N_GPU];
    int ip2p = 0;
    for ( int i = 0 ; i < devD->ndev ; i++ ) {
      cudaGetDeviceProperties(&a_deviceProp[i], i);
     gpuid[ip2p++] = i;
    }
    /* getting the combinations for p2p support */
    int can_access_peer_0_1, can_access_peer_1_0;
    if ( devD->ndev >= 2) {
      if ( ip2p > 0 ) {

	for ( int i = 0 ; i < (ip2p-1) ; i++) {
	  for ( int j = 1 ; j < ip2p ; j++) {
	    cudaDeviceCanAccessPeer(&can_access_peer_0_1, gpuid[i], gpuid[j]);
	    printf(B_BLUE"> Peer access from "
                   B_YELLOW"%s (GPU%d)"
                   B_BLUE" -> "
                   B_YELLOW"%s (GPU%d) : %s\n"
                   C_RESET,
		   a_deviceProp[gpuid[i]].name, gpuid[i],
		   a_deviceProp[gpuid[j]].name, gpuid[j] ,
		   can_access_peer_0_1 ?
                   B_GREEN"Yes" :
                   B_RED"No"
                   C_RESET);
	    devD->is_p2p[i][j] = can_access_peer_0_1;
	  }
	}

	for ( int i = 1 ; i < ip2p ; i++) {
	  for ( int j = 0 ; j < (ip2p-1) ; j++) {
	    cudaDeviceCanAccessPeer(&can_access_peer_1_0, gpuid[i], gpuid[j]);
	    printf(B_BLUE"> Peer access from "
                   B_YELLOW"%s (GPU%d)"
                   B_BLUE" -> "
                   B_YELLOW"%s (GPU%d) : %s\n"
                   C_RESET,
		   a_deviceProp[gpuid[i]].name, gpuid[i],
		   a_deviceProp[gpuid[j]].name, gpuid[j] ,
		   can_access_peer_1_0 ?
                   B_GREEN "Yes" :
                   B_RED"No"
                   C_RESET);
	    devD->is_p2p[i][j] = can_access_peer_1_0;
	  }
	}

      }
    }

    return rc;
  } /* end of get_peer_to_peer_capabilities method */
  /* getting the error correcting code memory device true or flase*/
  int SystemQuery_gpu::get_eec_support(cudaDeviceProp deviceProp, int *ecc, int *idev, deviceDetails_t *devD) {
    int rc = RC_SUCCESS;

    *ecc = deviceProp.ECCEnabled ? 1 : get_ecc_warning_message(devD);
    devD->is_ecc = *ecc;
    return rc;
  } /* end of get_eec_support method */
  /* wrapper function to find the most suitable device on system */
  int SystemQuery_gpu::get_findCudaDevice(int *idev) {
    int dev = 0;
#if defined (CUDA)
    cudaError_t error_id;
    cudaDeviceProp deviceProp_m;
    //cudaSetDevice(dev); here sets the device for computation
    error_id = cudaGetDeviceProperties(&deviceProp_m, dev);
    if (error_id != cudaSuccess) {get_error_id (error_id); }
    //method to find the device with the most capabilities
    ///    *idev = findCudaDevice(deviceProp_m);
    *idev = gpuGetMaxGflopsDeviceId();
    error_id = cudaSetDevice(*idev);
    error_id = cudaGetDeviceProperties(&deviceProp_m, *idev);

    std::cout<<B_BLUE<<"Most suitable GPU Device           ---> devID= "<<
        B_YELLOW<<*idev<<": "<<B_CYAN<<"\""<<deviceProp_m.name<<"\""<<
            B_GREEN" with compute capability ---> "
    <<B_MAGENTA<<deviceProp_m.major<<"."<<deviceProp_m.minor<<COLOR_RESET<<std::endl;
#endif

    return *idev;
  } /* end of get_findCudaDevice method */
  int SystemQuery_gpu::_finalize() {
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
  SystemQuery_gpu::~SystemQuery_gpu() {
    int rc = RC_SUCCESS;
    rc = _finalize();
    if (rc != RC_SUCCESS) {
      std::cerr<<B_RED"return code: "<<rc
	       <<" line: "<<__LINE__<<" file: "<<__FILE__<<C_RESET<<std::endl;
      exit(rc);
    } else {rc = RC_SUCCESS; /*print_destructor_message("DataDeviceManag");*/}
    rc = get_returnCode(rc, "SystemQuery_gpu", 0);
  } /* end of ~SystemQuery_gpu destructor */
  /* ////////////////////////////////////////////////////////////////////////////*/
  /* ////////////////////////////////////////////////////////////////////////////
       -- routines used to interface back to fortran
       *
       *  C-FORTRAN-Python API - functions
       *
  */
#if defined (CUDA) /*preprossing for the CUDA environment */

  /* sets the device for computation */
  int setDevice(int *idev) {
    int rc = RC_SUCCESS;
    int dev = *idev;

    cudaError_t error_id;
    cudaDeviceProp deviceProp_m;

    //cudaSetDevice(dev); here sets the device for computation
    error_id = cudaGetDeviceProperties(&deviceProp_m, dev);
    if (error_id != cudaSuccess) { rc = get_error_id (error_id); }

    error_id = cudaSetDevice(dev); //here sets the device for computation
    if (error_id != cudaSuccess) { rc = get_error_id (error_id); }

    return rc;
  } /* end of setDevice method */
  /* wrapper function to find the most suitable device on system */
  int get_findCudaDevice(int *idev) {
    //int rc = RC_SUCCESS;
    int dev = 0;
    cudaError_t error_id;
    cudaDeviceProp deviceProp_m;
    //cudaSetDevice(dev); here sets the device for computation
    error_id = cudaGetDeviceProperties(&deviceProp_m, dev);
    if (error_id != cudaSuccess) {get_error_id (error_id); }
    //method to find the device with the most capabilities
    *idev = findCudaDevice(deviceProp_m);
    return *idev;
  } /* end of get_findCudaDevice method */
  /* initialising the data structure */
  int deviceDetails_init(int *idev, deviceDetails_t *devD) {
    int rc = RC_SUCCESS; //return code
    int dev = *idev;
    cudaError_t error_id;
    //cudaSetDevice(dev); here sets the device for computation
    error_id = cudaGetDeviceProperties(&deviceProp, dev);
    if (error_id != cudaSuccess) { rc = get_error_id (error_id); }
    //method to find the device with the most capabilities
    //findCudaDevice(deviceProp);
    //TODO: add logic in case of additional multiple GPU selection process
    return rc;
  } /* end of deviceDetails_init method */
  /* freeing the data structure from memory */
  int deviceDetails_free(deviceDetails_t *devD) {
    int rc = RC_SUCCESS; //return code

    /*TODO: insert freeing statement in case of allocations */

    return rc;
  } /* end of deviceDetails_free method */
  /* determine if peer to peer is allowed */
  int get_peer_to_peer_capabilities(deviceDetails_t *devD) {
    int rc = RC_SUCCESS;

    //devD->is_p2p = false; /*initialises the p2p to false */

    cudaDeviceProp a_deviceProp[MAX_N_GPU];
    int gpuid[MAX_N_GPU];
    int ip2p = 0;
    for ( int i = 0 ; i < devD->ndev ; i++ ) {
      cudaGetDeviceProperties(&a_deviceProp[i], i);
     gpuid[ip2p++] = i;
    }
    /* getting the combinations for p2p support */
    int can_access_peer_0_1, can_access_peer_1_0;
    if ( devD->ndev >= 2) {
      if ( ip2p > 0 ) {

	for ( int i = 0 ; i < (ip2p-1) ; i++) {
	  for ( int j = 1 ; j < ip2p ; j++) {
	    cudaDeviceCanAccessPeer(&can_access_peer_0_1, gpuid[i], gpuid[j]);
	    printf(B_BLUE"> Peer access from "
                   B_YELLOW"%s (GPU%d)"
                   B_BLUE" -> "
                   B_YELLOW"%s (GPU%d) : %s\n"
                   C_RESET,
		   a_deviceProp[gpuid[i]].name, gpuid[i],
		   a_deviceProp[gpuid[j]].name, gpuid[j] ,
		   can_access_peer_0_1 ?
                   B_GREEN"Yes" :
                   B_RED"No"
                   C_RESET);
	    devD->is_p2p[i][j] = can_access_peer_0_1;
	  }
	}

	for ( int i = 1 ; i < ip2p ; i++) {
	  for ( int j = 0 ; j < (ip2p-1) ; j++) {
	    cudaDeviceCanAccessPeer(&can_access_peer_1_0, gpuid[i], gpuid[j]);
	    printf(B_BLUE"> Peer access from "
                   B_YELLOW"%s (GPU%d)"
                   B_BLUE" -> "
                   B_YELLOW"%s (GPU%d) : %s\n"
                   C_RESET,
		   a_deviceProp[gpuid[i]].name, gpuid[i],
		   a_deviceProp[gpuid[j]].name, gpuid[j] ,
		   can_access_peer_1_0 ?
                   B_GREEN "Yes" :
                   B_RED"No"
                   C_RESET);
	    devD->is_p2p[i][j] = can_access_peer_1_0;
	  }
	}

      }
    }

    return rc;
  } /* end of get_peer_to_peer_capabilities method */
  /* getting the error correcting code memory device true or flase*/
  int get_eec_support(cudaDeviceProp deviceProp, int *ecc, int *idev, deviceDetails_t *devD) {
    int rc = RC_SUCCESS;

    *ecc = deviceProp.ECCEnabled ? 1 : get_ecc_warning_message(devD);
    devD->is_ecc = *ecc;
    return rc;
  } /* end of get_eec_support method */
  /* getting the threads details */
  int get_thread_details(cudaDeviceProp deviceProp, int *warpSize, int *max_threads_per_mp,
                         int *max_threads_per_blk, deviceDetails_t *devD) {
    int rc = RC_SUCCESS;

    *warpSize = deviceProp.warpSize;
    devD->warpSze = *warpSize;
    *max_threads_per_mp = deviceProp.maxThreadsPerMultiProcessor;
    devD->maxthreads_per_mp = *max_threads_per_mp;
    *max_threads_per_blk = deviceProp.maxThreadsPerBlock;
    devD->maxthreads_per_blk = *max_threads_per_blk;

    return rc;
  } /* end of get_thread_details method */
  /* getting the number of registers */
  int get_nregisters(cudaDeviceProp deviceProp, int *nregisters_per_blk, deviceDetails_t *devD) {
    int rc = RC_SUCCESS;

    *nregisters_per_blk = deviceProp.regsPerBlock;
    devD->nregisters_per_blk = *nregisters_per_blk;

    return rc;
  } /* end of get_nregisters method */
  /* getting # of Multiprocessors, CUDA cores/MP and total # of CUDA cores */
  int get_CUDA_cores(int *idev, cudaDeviceProp deviceProp, int *gpu_major, int *gpu_minor, int *nmp,
         int *cuda_cores_per_mp, int *ncuda_cores, deviceDetails_t *devD) {
    int rc = RC_SUCCESS;
    //int dev = *idev;
    int major = *gpu_major; int minor = *gpu_minor;

    *nmp = deviceProp.multiProcessorCount;
    devD->nMultiProc = *nmp;
    *cuda_cores_per_mp = _ConvertSMVer2Cores(deviceProp.major, deviceProp.minor);
    devD->ncudacores_per_MultiProc = *cuda_cores_per_mp;
    *ncuda_cores = _ConvertSMVer2Cores(deviceProp.major, deviceProp.minor) *
                   deviceProp.multiProcessorCount;
    devD->ncudacores = *ncuda_cores;
    if (devD->ncudacores == 0 ) { rc = get_cuda_cores_error(devD->ncudacores); }
    /* requiring at leat a gpu_major.gpu_minor architecture Tesla card */
    bool bVal = checkCudaCapabilities(major,minor);
    /*    printf(B_BLUE"Device %d: < "
           B_YELLOW"%16s"B_BLUE
           " >, Compute SM %d.%d detected, **suitable: %s**\n",
       dev, deviceProp.name, deviceProp.major, deviceProp.minor,
           bVal?B_GREEN"yes"C_RESET :
                  B_RED"no" C_RESET);
    */
    devD->is_SMsuitable = bVal;

    return rc;
  } /* end of get_CUDA_cores method */
  /* General check for CUDA GPU SM Capabilities */
  inline bool checkCudaCapabilities(int major_version, int minor_version) {
    if ((deviceProp.major > major_version) ||
  (deviceProp.major == major_version && deviceProp.minor >= minor_version)) {
      return true;
  } else { return false; }
  } /* end of checkCudaCapabilities method */
  /* getting the memory from the devices */
  int get_tot_global_mem_MB(cudaDeviceProp deviceProp, float *totalGlobalMem_MB, deviceDetails_t *devD) {
    int rc = RC_SUCCESS;

    *totalGlobalMem_MB = (float)deviceProp.totalGlobalMem/1048576.0f;
    devD->tot_global_mem_MB = *totalGlobalMem_MB;

    return rc;
  }/* end of get_tot_global_mem_MB method */
  /* getting the memory from the devices */
  int get_tot_global_mem_bytes(cudaDeviceProp deviceProp, unsigned long long *totalGlobalMem_bytes,
                               deviceDetails_t *devD) {
    int rc = RC_SUCCESS;

    *totalGlobalMem_bytes = (unsigned long long) deviceProp.totalGlobalMem;
    devD->tot_global_mem_bytes = *totalGlobalMem_bytes;

    return rc;
  } /* end of get_tot_global_mem_bytes method */
  /* getting the driver version */
  int get_cuda_driverVersion(int *driverVersion , deviceDetails_t *devD) {
    int rc = RC_SUCCESS;
    cudaError_t error_id;

    error_id = cudaDriverGetVersion(driverVersion);
    if (error_id != cudaSuccess) { rc = get_error_id (error_id); }

    devD->d_ver = (float)*driverVersion/1000;

    return rc;
  } /* end of get_cuda_driverVersion method */
  /* getting the runtime version */
  int get_cuda_runtimeVersion(int *runtimeVersion , deviceDetails_t *devD) {
    int rc = RC_SUCCESS;
    cudaError_t error_id;

    error_id = cudaRuntimeGetVersion(runtimeVersion);
    if (error_id != cudaSuccess) { rc = get_error_id (error_id); }

    devD->d_runver = (float)*runtimeVersion / 1000;

    return rc;
  } /* end of get_cuda_runtimeVersion method */
  /* getting the name of the device */
  int get_dev_Name(cudaDeviceProp deviceProp, deviceDetails_t *devD) {
    int rc = RC_SUCCESS;

    strcpy(devD->dev_name, deviceProp.name);
    if (strlen(devD->dev_name) == 0) {
      rc = RC_WARNING;
      std::cout<<" devD->dev_name is an empty string ---> "<<devD->dev_name<<std::endl;
    }

    return rc;
  } /* end of get_dev_Name method */
  /* get the number of devices avaible on the system */
  int get_dev_count(deviceDetails_t *devD) {
    int rc = RC_SUCCESS; //return code
    int devCnt = 0;

//#if defined (CUDA)
    cudaError_t error_id = cudaGetDeviceCount(&devCnt);
    devD->ndev = devCnt;
    //printf(B_GREEN"devD->ndev = %i Devices\n"C_RESET
    //       ,devD->ndev);
    if (error_id != cudaSuccess) { rc = get_error_id (error_id); }
//#else
//    rc = get_warning_message();
//#endif
    return rc;
  } /* end of get_dev_count method */
  /* getting the warning message from the cuda */
  int get_warning_message() {
    int rc = RC_SUCCESS;

    printf("***************************WARNING*****************************\n");
    printf("You need to compile with -DCUDA to acces the CUDA environment  \n");
    printf("computation using GPU                                          \n");
    printf("***************************************************************\n");
    printf("\n");
    printf("Exit at Line %i in file %s %s\n",__LINE__,__FILE__,__FUNCTION__);
    printf("\n");
    rc = RC_FAIL;

    return rc;
  } /* end of get_warning_message method */
  /* getting the error id from the cuda */
  int get_error_id (cudaError_t error_id) {
    int rc = RC_SUCCESS;
    printf("cudaDriverGetVersion returned %d\n-> %s\n",
	     (int)error_id, cudaGetErrorString(error_id));
    printf("Result = FAIL\n");
    printf("Exit at Line %i in file %s %s\n",__LINE__,__FILE__,__FUNCTION__);
    rc = (int)error_id;
    exit(EXIT_FAILURE);
    return rc;
  }
  /* getting the cuda cores error */
  int get_cuda_cores_error(int ncores) {
    int rc = RC_SUCCESS;
    /* TODO: need to fix up the function where this methdo has been called from */
    printf("There are no CUDA cores available on system %d\n",ncores);
    printf("Result = FAIL\n");
    printf("Exit at Line %i in file %s %s\n",__LINE__,__FILE__,__FUNCTION__);
    rc = RC_FAIL;
    //exit(EXIT_FAILURE);
    return rc;
  }/* --end of get_cuda_cores_error method --*/
  /* getting the warning message from the cuda */
  int get_ecc_warning_message(deviceDetails_t *devD) {
    int rc = RC_SUCCESS;

    printf(B_CYAN);
    printf("***************************WARNING*****************************\n");
    printf("Device: " B_RED "%s"
           B_CYAN
           " does not have error correcting code \n",devD->dev_name);
    printf("memory (ECC) enabled. This is probably because the device does \n");
    printf("not have CUDA computing capabilities. Check that the correct   \n");
    printf("device has been selected.                                      \n");
    printf("***************************************************************\n");
    printf(C_RESET);

    return rc;
  } /* end of get_ecc_warning_message method */
  /* Initialization code to find the best CUDA Device */
  int findCudaDevice(cudaDeviceProp deviceProp) {
    int devID = 0;
    cudaError_t error_id;
    // pick the device with highest Gflops/s
    devID = gpuGetMaxGflopsDeviceId();
    error_id = cudaSetDevice(devID);  if (error_id != cudaSuccess) {get_error_id(error_id);}
    error_id = cudaGetDeviceProperties(&deviceProp, devID); if (error_id != cudaSuccess) {get_error_id(error_id);}
    /*
    printf("Most suitable GPU Device %d: \"%s\" with compute capability %d.%d\n\n",
           devID, deviceProp.name, deviceProp.major, deviceProp.minor);
    */
    return devID;
  } /* --end of findCudaDevice method */
  /* This function returns the best GPU (with maximum GFLOPS) */
  inline int gpuGetMaxGflopsDeviceId() {
    int current_device     = 0, sm_per_multiproc  = 0;
    int max_perf_device    = 0;
    int device_count       = 0, best_SM_arch      = 0;
    int devices_prohibited = 0;

    unsigned long long max_compute_perf = 0;
    cudaDeviceProp deviceProp;
    cudaError_t error_id;

    error_id = cudaGetDeviceCount(&device_count); if (error_id != cudaSuccess) {get_error_id(error_id);}

    if (device_count == 0) {
      fprintf(stderr, "gpuGetMaxGflopsDeviceId() CUDA error: no devices supporting CUDA.\n");
      exit(EXIT_FAILURE);
    }

    // Find the best major SM Architecture GPU device
    while (current_device < device_count) {
      cudaGetDeviceProperties(&deviceProp, current_device);

      // If this GPU is not running on Compute Mode prohibited,
      // then we can add it to the list
      if (deviceProp.computeMode != cudaComputeModeProhibited) {
        if (deviceProp.major > 0 && deviceProp.major < 9999) {
          best_SM_arch = SIMPLE_MAX(best_SM_arch, deviceProp.major);
        }
      } else {devices_prohibited++;}
      current_device++;
    }

    if (devices_prohibited == device_count) {
      fprintf(stderr, "gpuGetMaxGflopsDeviceId() CUDA error: all devices have compute mode prohibited.\n");
      exit(EXIT_FAILURE);
    }

    // Find the best CUDA capable GPU device
    current_device = 0;

    while (current_device < device_count) {
      cudaGetDeviceProperties(&deviceProp, current_device);

      // If this GPU is not running on Compute Mode prohibited, then we can add it to the list
      if (deviceProp.computeMode != cudaComputeModeProhibited) {
        if (deviceProp.major == 9999 && deviceProp.minor == 9999) {
          sm_per_multiproc = 1;
        } else {
          sm_per_multiproc = _ConvertSMVer2Cores(deviceProp.major,
                                                 deviceProp.minor);
        }

        unsigned long long compute_perf  =
          (unsigned long long) deviceProp.multiProcessorCount *
                               sm_per_multiproc               *
                               deviceProp.clockRate;

        if (compute_perf  > max_compute_perf) {
          // If we find GPU with SM major > 2, search only these
          if (best_SM_arch > 2) {
            // If our device==dest_SM_arch, choose this, or else pass
            if (deviceProp.major == best_SM_arch) {
              max_compute_perf  = compute_perf;
              max_perf_device   = current_device;
            }
          } else {
            max_compute_perf  = compute_perf;
            max_perf_device   = current_device;
          }
        }
      }
      ++current_device;
    }

    return max_perf_device;
  } /* --end of gpuGetMaxGflopsDeviceId */
  /* Beginning of GPU Architecture definitions */
  inline int _ConvertSMVer2Cores(int major, int minor) {
    /* Defines for GPU Architecture types (using the SM version to determine
     * the # of cores per SM)
     * 0xMm (hexidecimal notation),
     * M = SM Major version, and m = SM minor version */
    typedef struct {
      int SM;
      int Cores;
    } sSMtoCores;

    sSMtoCores nGpuArchCoresPerSM[] = {
      { 0x20, 32 }, /* Fermi Generation (SM 2.0) GF100 class */
      { 0x21, 48 }, /* Fermi Generation (SM 2.1) GF10x class */
      { 0x30, 192}, /* Kepler Generation (SM 3.0) GK10x class */
      { 0x32, 192}, /* Kepler Generation (SM 3.2) GK10x class */
      { 0x35, 192}, /* Kepler Generation (SM 3.5) GK11x class */
      { 0x37, 192}, /* Kepler Generation (SM 3.7) GK21x class */
      { 0x50, 128}, /* Maxwell Generation (SM 5.0) GM10x class */
      { 0x52, 128}, /* Maxwell Generation (SM 5.2) GM20x class */
      { 0x60, 64 }, // Pascal Generation (SM 6.0) GP100 class
      { 0x61, 128}, // Pascal Generation (SM 6.1) GP10x class
      { 0x62, 128}, // Pascal Generation (SM 6.2) GP10x class
      { 0x70, 64 }, // Volta Generation (SM 7.0) GV100 class
      {   -1, -1 }
    };

    int index = 0;

    while (nGpuArchCoresPerSM[index].SM != -1) {
        if (nGpuArchCoresPerSM[index].SM == ((major << 4) + minor)) {
            return nGpuArchCoresPerSM[index].Cores;
	  }
        index++;
      }

    /* If we don't find the values, we default use the previous one to run properly */
    printf("MapSMtoCores for SM %d.%d is undefined. Default to use %d Cores/SM\n",
	   major, minor, nGpuArchCoresPerSM[index-1].Cores);
    return nGpuArchCoresPerSM[index-1].Cores;
  } /* end of _ConvertSMVer2Cores method */
  /* ////////////////////////////////////////////////////////////////////////////
       -- routines used to interface back to fortran
       *
       *  C-FORTRAN-Python API - functions
       *
  */
#if defined (LINUX)
  /* the aliases for external access */
  extern "C" int setdevice_() __attribute__((weak,alias("setDevice")));
  extern "C" int devicedetails_init_() __attribute__((weak,alias("deviceDetails_init")));
  extern "C" int devicedetails_free_() __attribute__((weak,alias("deviceDetails_free")));

  extern "C" int findcudadevice_() __attribute__((weak,alias("findCudaDevice")));
  extern "C" int get_findcudadevice_() __attribute__((weak,alias("get_findCudaDevice")));

  extern "C" int get_dev_count_() __attribute__((weak,alias("get_dev_count")));
  extern "C" int get_dev_name_() __attribute__((weak,alias("get_dev_Name")));
  extern "C" int get_cuda_runtimeversion_() __attribute__((weak,alias("get_cuda_runtimeVersion")));
  extern "C" int get_cuda_driverversion_() __attribute__((weak,alias("get_cuda_driverVersion")));
  extern "C" int get_tot_global_mem_mb_() __attribute__((weak,alias("get_tot_global_mem_MB")));
  extern "C" int get_tot_global_mem_bytes_() __attribute__((weak,alias("get_tot_global_mem_bytes")));
  extern "C" int get_cuda_cores_() __attribute__((weak,alias("get_CUDA_cores")));
  extern "C" int get_nregisters_() __attribute__((weak,alias("get_nregisters")));
  extern "C" int get_thread_details_() __attribute__((weak,alias("get_thread_details")));
  extern "C" int get_eec_support_() __attribute__((weak,alias("get_eec_support")));
  extern "C" int get_peer_to_peer_capabilities_() __attribute__((weak,alias("get_peer_to_peer_capabilities")));
#endif

#endif /* CUDA */

#ifdef __cplusplus
}
#endif


} /* end of namespace namespace_System_gpu */

