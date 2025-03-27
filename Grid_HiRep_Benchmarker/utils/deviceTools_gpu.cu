/*!\file
 *   -- ResMap addon: (C++ code)
 *      \author: Frederic Bonnet
 *      \date: 25th March 2018
 *
 *      Yale University March 2018
 *
 * Name:
 * ---
 * deviceTools_gpu.cpp - C++ code wrapper and metods
 *
 * Description:
 * ---
 * C++ tool method and code to obtain information from the GPU cards, manage
 * GPU activation and the like
 *
 * @precisions normal z -> s d c
 */
//system headers
#include <stdlib.h>
#include <iostream>
#include <iomanip>
#include <stdio.h>

//application headers
#include "../global.cuh"

#include "../include/dataDeviceManag.cuh"

/*
#include "../include/common.cuh"

#include "../include/deviceTools_gpu.cuh"
*/
namespace namespace_System_gpu {
#ifdef __cplusplus
extern "C" {
#endif

#if defined (CUDA)
//cudaDeviceProp deviceProp;
#endif
  /* ////////////////////////////////////////////////////////////////////////////
     -- class declaration DeviceTools_gpu
  */
  DeviceTools_gpu::DeviceTools_gpu() {
    int rc = RC_SUCCESS;
    /* initializing the structure variables */
    rc = DeviceTools_gpu::_initialize(); if (rc != RC_SUCCESS){rc = RC_WARNING;}
    std::cout<<B_GREEN<<"Class DeviceTools_gpu::DeviceTools_gpu() has been instantiated, return code: "<<B_GREEN<<rc<<COLOR_RESET<<std::endl;
  } /* end of DeviceTools_gpu constructor */
  int DeviceTools_gpu::_initialize() {
    int rc = RC_SUCCESS;
    //int devID = 0;
#if defined (CUDA)
    /* TODO: insert the initialisers in the method when needed */
    *s_Devices = namespace_System_gpu::devices_gpuGetMaxGflopsDeviceId(*s_Devices);
#endif
    return rc;
  } /* end of _initialize method */
  int DeviceTools_gpu::_finalize() {
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
  DeviceTools_gpu::~DeviceTools_gpu() {
    int rc = RC_SUCCESS;
    rc = _finalize();
    if (rc != RC_SUCCESS) {
      std::cerr<<B_RED"return code: "<<rc
         <<" line: "<<__LINE__<<" file: "<<__FILE__<<C_RESET<<std::endl;
      exit(rc);
    } else {rc = RC_SUCCESS; /*print_destructor_message("DataDeviceManag");*/}
    rc = get_returnCode(rc, "SystemQuery_gpu", 0);
  } /* end of ~DeviceTools_gpu destructor */

/* ////////////////////////////////////////////////////////////////////////////
*/
  //*****************************************************************************/
/*
 *  C - C++ - CUDA C - FORTRAN API - device tools interface
 */
#if defined (CUDA) /*preprossing for the CUDA environment */

  /*!***************************************************************************
   * \brief C++ method.
   * Sets the device for computation.
   * \param *idev
   */
  int setGPUDevice(int *idev) {
    int rc = RC_SUCCESS;
    int dev = *idev;

    cudaError_t error_id;
    cudaDeviceProp deviceProp_m;

    // get the device properties
    error_id = cudaGetDeviceProperties(&deviceProp_m, dev);
    if (error_id != cudaSuccess) {
      rc = get_error_id_cuda_gpu(error_id,__LINE__,__FILE__,__FUNCTION__); }

    error_id = cudaSetDevice(dev); //here sets the device for computation
    if (error_id != cudaSuccess) {
      rc = get_error_id_cuda_gpu(error_id,__LINE__,__FILE__,__FUNCTION__); }

    return rc;
  }
  /*!***************************************************************************
   * \brief C++ method.
   * This function returns the best GPU (with maximum GFLOPS) and fills
   * in a data structure Devices defined in common.h. It returns the number of
   * cuda cores for each device used to work out the fastest gpus. Used in
   * Multi-GPUs computation.
   * \param devices
   * \return devices
   */
  Devices devices_gpuGetMaxGflopsDeviceId(Devices devices) {
    //int rc = RC_SUCCESS;
    int current_device     = 0, sm_per_multiproc  = 0;
    int max_perf_device    = 0;
    int device_count       = 0, best_SM_arch      = 0;
    int devices_prohibited = 0;

    unsigned long long max_compute_perf = 0;
    cudaDeviceProp deviceProp;
    cudaError_t error_id;

    error_id = cudaGetDeviceCount(&device_count); if (error_id != cudaSuccess){get_error_id(error_id);}
    /* filling in the data structure */
    devices.nDev = device_count;

    if (device_count == 0) {
      printf("gpuGetMaxGflopsDeviceId() CUDA error: no devices found (CUDA)\n");
      exit(RC_FAIL);
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
      printf("gpuGetMaxGflopsDeviceId() CUDA error: all devices have compute" \
             "mode prohibited.\n");
      exit(RC_FAIL);
    }

    // Find the best CUDA capable GPU device
    current_device = 0;

    while (current_device < device_count) {
      cudaGetDeviceProperties(&deviceProp, current_device);

      // If this GPU is not running on Compute Mode prohibited, then we can
      // add it to the list
      if (deviceProp.computeMode != cudaComputeModeProhibited) {
        if (deviceProp.major == 9999 && deviceProp.minor == 9999) {
          sm_per_multiproc = 1;
        } else {
          sm_per_multiproc = ConvertSMVer2Cores(deviceProp.major,
                                                deviceProp.minor);
        }

        devices.ncuda_cores[current_device] = sm_per_multiproc *
          deviceProp.multiProcessorCount;

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

    devices.max_perf_dev = max_perf_device;
    /* retruning the updated data structure */
    return devices;
  } /* end of gpuGetMaxGflopsDeviceId method */
  /*!***************************************************************************
   * \brief C++ method.
   * Converts SM ver to number of cuda cores for a given device
   * Beginning of GPU Architecture definitions
   * \param major Major value cuda 6, 7, 8, 9 or 10
   * \param minor Ninor value 0.1, 0.2, ...
   * \return nGpuArchCoresPerSM[index-1].Cores
   */
  int ConvertSMVer2Cores(int major, int minor) {
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
      { 0x60, 64 }, /* Pascal Generation (SM 6.0) GP100 class */
      { 0x61, 128}, /* Pascal Generation (SM 6.1) GP10x class */
      { 0x62, 128}, /* Pascal Generation (SM 6.2) GP10x class */
      { 0x70, 64 }, /* Volta Generation (SM 7.0) GV100 class */
      {   -1, -1 }
    };

    int index = 0;

    while (nGpuArchCoresPerSM[index].SM != -1) {
      if (nGpuArchCoresPerSM[index].SM == ((major << 4) + minor)) {
        return nGpuArchCoresPerSM[index].Cores;
      }
      index++;
    }

    /* If we don't find the values, we default use the previous one to run
       properly
    */
    printf("MapSMtoCores for SM %d.%d is undefined. Default to use %d " \
           "Cores/SM\n", major, minor, nGpuArchCoresPerSM[index-1].Cores);
    return nGpuArchCoresPerSM[index-1].Cores;
  } /* end of ConvertSMVer2Cores method */
  /*!***************************************************************************
   * \brief C++ method. Printing the GPU device capabilities
   * \param i_whichGPUs
   * \param deviceProp
   * \return Method returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc.
   */
  int print_GPUDevice_SM(int i_whichGPUs, cudaDeviceProp deviceProp) {
    int rc = RC_SUCCESS;
    std::cerr<<B_CYAN<<"GPU Device "<<B_MAGENTA<<i_whichGPUs<<B_CYAN<<":"
	     <<B_YELLOW<<" \""<<deviceProp.name<<"\""
	     <<B_CYAN<<" with compute capability "
	     <<B_BLUE<<deviceProp.major<<"."<<deviceProp.minor
	     <<C_RESET<<std::endl;
    return rc;
  } /* end of print_GPUDevice_SM method */
  /*!***************************************************************************
   * \brief C++ method. Getting the which gpu message
   * \param nGPUs      nGPUs required
   * \param GPU_N      Number of GPU on node
   * \param GPU_N_MIN  Minimum number of GPUs required
   * \return Method returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc.
   */
  int minGPU_required_message(int nGPUs, int GPU_N, int GPU_N_MIN) {
    int rc = RC_SUCCESS;

    if (GPU_N < GPU_N_MIN /* GPU_N_MIN = 2 */) {
      std::cerr<<B_RED<<"No. of GPU on node "<< GPU_N<<C_RESET<<std::endl;
      std::cerr<<B_RED<<"Two GPUs are required to run simpleCUFFT_MGPU sample"
	       <<"code"<<C_RESET<<std::endl;
      exit(RC_FAIL);
    } else if  (GPU_N > GPU_N_MIN) {
      std::cerr<<B_GREEN"nGPUs required, nGPUs                     : "
	       <<B_BLUE<<nGPUs<<C_RESET<<std::endl;
      std::cerr<<B_GREEN"Minimum number of GPUs required, GPU_N_MIN: "
	       <<B_BLUE<<GPU_N_MIN<<C_RESET<<std::endl;
      std::cerr<<B_GREEN"CUDA Capable devices found, GPU_N         : "
	       <<B_BLUE<<GPU_N<<C_RESET<<std::endl;
    }
    return rc;
  } /* end of minGPU_required_message method */
  /*!***************************************************************************
   * \brief C++ method. Getting the which gpu message
   * \param nGPUs     Total number of GPUs
   * \param *whichGPUs Which GPU
   * \param nDevices Number of nDevices
   * \return Method returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc.
   */
  int get_whichGPUs_message(int nGPUs, int *whichGPUs, int nDevices) {
    int rc = RC_SUCCESS;

    if ( nGPUs < 2 ) {
      std::cerr<<B_CYAN<<"Number of nDevices: "<<B_GREEN<<nDevices
	       <<B_CYAN<<" is inferior to 2 GPUS, multi-GPUs required here."
	       <<C_RESET<<std::endl;
    } else if ( nGPUs > 1 ) {
      std::cerr<<B_CYAN<<"Number of nDevices: "<<B_GREEN<<nDevices
	       <<B_CYAN<<" filling up whichGPUs array"
	       <<C_RESET<<std::endl;
      for (int i = 0; i < nGPUs; i++) {
	whichGPUs[i] = i;
	std::cerr<<B_CYAN<<"whichGPUs["<<B_GREEN<<i<<B_CYAN<<"]: "
		 <<B_BLUE<<whichGPUs[i]
		 <<C_RESET<<std::endl;
      }
    }

    return rc;
  } /* end of get_whichGPUs_message method */
  /* ////////////////////////////////////////////////////////////////////////////
       -- routines used to interface back to fortran
       *
       *  C-FORTRAN-Python API - functions
       *
  */
#if defined (LINUX)
  /* the aliases for external access */
  extern "C" int setgpudevice_() __attribute__((weak,alias("setGPUDevice")));
  extern "C" int gpuGetMaxGflopsDeviceId_() __attribute__((weak,alias("gpuGetMaxGflopsDeviceId")));
  extern "C" int minGPU_required_message_() __attribute__((weak,alias("minGPU_required_message")));
  extern "C" int get_whichGPUs_message_() __attribute__((weak,alias("get_whichGPUs_message")));
#endif

#endif /* CUDA */

#ifdef __cplusplus
}
#endif


} /* end of namespace namespace_System_gpu */


