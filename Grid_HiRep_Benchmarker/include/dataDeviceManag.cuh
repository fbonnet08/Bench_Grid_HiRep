/*! \file
 *   -- ResMap addon: (C++ code)
 *      \author Frederic Bonnet
 *      \date: 16th April 2018
 *
 *      Yale University April 2018
 *
 * Name:
 * ---
 * dataDeviceManag.hpp - C++ Header file for the data management on device.
 * These are common methods used in kernel calculation on GPU
 * Description:
 * ---
 * C++ header file for the management of data on the device using template
 * programming in pre processing environment. The management is done via
 * standard cuda cuda alloc/memcpy and the Xt descriptors from the cuFFT
 * library. The error handling handled via error messaging methods build from
 * NVIDIA cuFFT and CUDA C structures.
 *
 * @precisions normal z -> s d c
 */
//system headers
#include <string>
#include <map>
//application headers
#include "common_krnl.cuh"

#ifndef _DATADEVICEMANAG_HPP_
#define _DATADEVICEMANAG_HPP_
//***************************************************************************/
/*
 *  C - C++ - CUDA-C - FORTRAN - Python API - functions (ResMap interface)
 */
#ifdef __cplusplus
extern "C" {
#endif

//#if defined (CUDA)

  int result_CUFFTXt(cufftResult result);
  int get_error_id_cuda_gpu(cudaError_t error_id, int line,
			    std::string file, std::string function);
//#endif /* CUDA */

#ifdef __cplusplus
}
#endif
/*****************************************************************************
 * Class declaration for the device management
 */

//#if defined (CUDA)
/*!*****************************************************************************
 * \brief C++ class for the device management designed on
 * template<typename T> */
/* Exception definition class */
template <typename T>
class DataDeviceManag {
public:
 /* constructor */
  DataDeviceManag();  //!<Constructor
  /* destructor */
  ~DataDeviceManag(); //!<Destructor
  /* methods */
  int _initialize();  //!<Initializing method
  int _finalize();    //!<Finalizing method
  int t_alloc_gpu(int npts_in, T *d_in);
  int t_dealloc_gpu(T *d_in);
  int t_allocset_gpu(int npts_in, const T *h_in, T *d_in);
  int t_deallocget_gpu(int npts_in, T *h_out, T *d_out);
  //int t_cufftXtdealloc_gpu(cudaLibXtDesc *d_Xt_in);

//TODO: fix the problem with the multi GPU case with the include header
  //int t_cufftXtalloc_gpu(cufftHandle plan_input, cudaLibXtDesc *d_Xt_in, cufftXtSubFormat format);
  //int t_cufftXtallocset_gpu(cufftHandle plan_input, T *h_in, cudaLibXtDesc *d_Xt_in, cufftXtSubFormat format);
  /* ERROR HANDLER */
  std::map<int, cufftXtResult_t> hshit(int err);
  int print_error_id_cufftXt(cufftXtResult_t error_id, std::string msg,
			     int line, std::string file, std::string function);
  int get_error_id_cufftXt_gpu(cufftXtResult_t error_id, std::string msg,
			       int line, std::string file,
			       std::string function);
  //std::map<std::string, cufftXtResult_t> hshit(std::string const& iStrg);
  /* SETTERS */
  int set_DevicePtr(T *d_in);
  int set_DeviceXtPtr(cudaLibXtDesc *d_Xt_in);
  /* getterss */
  T * get_DevicePtr();
  cudaLibXtDesc * get_DeviceXtPtr();
private:
  T *d_self = NULL;
  cudaLibXtDesc *d_Xt_self = NULL;
}; /* end of DataDeviceManag class */

//#endif /* end of the CUDA preprocessing */

/*****************************************************************************
 * End of header file dataDeviceManag.hpp
 */
#endif /* _DATADEVICEMANAG_HPP_ */



