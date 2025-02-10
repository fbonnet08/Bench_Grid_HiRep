/*!\file
 *   -- ResMap addon: (C++ code)
 *      \author: Frederic Bonnet
 *      \date: 29th March 2018
 *
 *      Yale University March 2018
 *      Revived (12/10/2023)
 *
 * Name:
 * ---
 * deviceTools_gpu.h - C header file for methods in deviceTools_gpu.cpp
 *
 * Description:
 * ---
 * C++ header code over CUDA-C to obtain the information of the device. Uses
 * structure {@link Devices} in common.h.
 *
 * @precisions normal z -> s d c
 */
/* Application headers */
#include "common.cuh"

#ifndef DEVICETOOLS_GPU_CUH
#define DEVICETOOLS_GPU_CUH

#define PRECISION_z

namespace namespace_System_gpu {
#ifdef __cplusplus
extern "C" {
#endif
  /* ////////////////////////////////////////////////////////////////////////////
   -- class declaration DeviceTools_gpu
*/
 class DeviceTools_gpu {
 private:
 public:
  //std::string ver_o;
  /* constructor */
  DeviceTools_gpu();
  /* methods */
  int _initialize();
  int _finalize();
  /* Helper functions */
  /* Destructor */
  ~DeviceTools_gpu();
 }; /* end of class SystemQuery_gpu declaration */
/* ////////////////////////////////////////////////////////////////////////////
*/
  /* ////////////////////////////////////////////////////////////////////////////
     -- routines used to interface back to fortran
     *
     *  C-FORTRAN-Python API - functions
     *
     */
#if defined (CUDA) /*preprossing for the CUDA environment */

 /* sets the device for computation */
 int setGPUDevice(int *idev);
 /*error and warning handlers methods */
 int get_resmap_error_id (cudaError_t error_id);

 Devices devices_gpuGetMaxGflopsDeviceId(Devices devices);
 int ConvertSMVer2Cores(int major, int minor);
 int print_GPUDevice_SM(int i_whichGPUs, cudaDeviceProp deviceProp);
 int minGPU_required_message(int nGPUs, int GPU_N, int GPU_N_MIN);
 int get_whichGPUs_message(int nGPUs, int *whichGPUs, int nDevices);

#endif /* CUDA */

#ifdef __cplusplus
}
#endif

#undef PRECISION_z


} /* end of namespace namespace_System_gpu */



#endif //DEVICETOOLS_GPU_CUH
