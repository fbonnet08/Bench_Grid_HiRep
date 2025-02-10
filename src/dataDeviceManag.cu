/*!\file
 *   -- ResMap addon: (C++ code)
 *      \author Frederic Bonnet
 *      \date 13th Apr 2018
 *
 *      Yale University April 2018
 *
 * Name:
 * ---
 * dataDeviceManag.cpp - C++ code for data management
 *
 * Description:
 * ---
 * C++ code to manage via template programing data on the device
 *
 * @precisions normal z -> s d c
 */
/*system headers */
#include <stdlib.h>
#include <iostream>
#include <iomanip>
#include <stdio.h>
//#if defined (CUDA) /*preprossing for the CUDA environment */
#include <cufftXt.h>
#include <cuda_runtime.h>
#include <cuda_runtime_api.h>
#include <cuda_device_runtime_api.h>
//#endif
//application headers
#include "../include/common.cuh"
#include "../include/Exception.cuh"

#include "../include/dataDeviceManag.cuh"
#include "../include/resmap_Sizes.cuh"

#ifdef __cplusplus
extern "C" {
#endif
//*****************************************************************************/
/*
 *  C - C++ - CUDA-C - FORTRAN - Python API - functions (ResMap interface)
 */

//#if defined (CUDA) /*preprossing for the CUDA environment */
  /*!***************************************************************************
   * \brief Getting the result for cuFFT
   * \param result Result for the cuFFT
   */
  int result_CUFFTXt(cufftResult result) {
    int rc = RC_SUCCESS;

    if (result == CUFFT_SUCCESS) {
      std::cerr<<B_CYAN<<"cufftXtSetGPUs: "
	       <<B_GREEN<<"CUFFT_SUCCESS"<<C_RESET<<std::endl;
    } else if (result == CUFFT_INVALID_DEVICE ) {
      std::cerr<<B_CYAN<<"cufftXtSetGPUs: "
	       <<B_YELLOW<<"CUFFT_INVALID_DEVICE"<<C_RESET<<std::endl;
      std::cerr<<B_RED<<"This sample requires two GPUs on the same board."
	       <<" Or you have requested too many GPUs."
	       <<C_RESET<<std::endl;
      std::cerr<<B_CYAN<<"No such board was found. Waiving sample."
	       <<C_RESET<<std::endl;
      std::cerr<<B_RED<<"failed: exiting--> RC_FAIL: "
	       <<B_MAGENTA<<RC_FAIL<<C_RESET<<std::endl;
      rc = RC_FAIL;
    } else {
      std::cerr<<B_CYAN<<"cufftXtSetGPUs: "
	       <<B_RED<<"failed: exiting--> RC_FAIL: "
	       <<B_MAGENTA<<RC_FAIL<<C_RESET<<std::endl;
      rc = RC_FAIL;
    }

    return rc;

  } /* end of result_CUFFT method */
  /*!***************************************************************************
   * \brief Getting the error id from the cuda
   * \param error_id Cuda error id
   * \param line     The line at which this occurs
   * \param file     The file at which this occurs
   * \param function The function which the error occurs
   */
  int get_error_id_cuda_gpu(cudaError_t error_id, int line,
			    std::string file, std::string function) {
    int rc = 0;
    std::cerr<<std::endl;
    std::cerr<<B_RED"cudaDriver API call returned: "
	     <<B_YELLOW<<(int)error_id<<C_RESET<<std::endl;;
    std::cerr<<B_CYAN<<"cudaGetErrorString("<<B_YELLOW<<(int)error_id
	     <<B_CYAN<<") -> "
	     <<B_MAGENTA<<cudaGetErrorString(error_id)
	     <<C_RESET<<std::endl;;
    std::cerr<<"Result = "<<B_RED<<"FAIL"<<std::endl;
    std::cerr<<B_CYAN"[function: "<<B_GREEN<<function
	     <<B_CYAN<<", line: "<<B_YELLOW<<line
	     <<B_CYAN<<", in file: "<<B_YELLOW<<file<<B_CYAN<<"]"
	     <<C_RESET<<std::endl;
    rc = (int)error_id;
    exit(RC_FAIL);
    return rc;
  } /* end of get_error_id_cuda_gpu method */
  /*!***************************************************************************
   * \brief The aliases for external access
   */
  //extern "C" int get_error_id_cuda_gpu_() __attribute__((weak,alias("get_error_id_cuda_gpu")));
  //extern "C" int result_CUFFTXt_() __attribute__((weak,alias("result_CUFFTXt")));

//#endif /* CUDA */

#ifdef __cplusplus
}
#endif

/*****************************************************************************
 * Class declaration for the devcice management
 */
//#if defined (CUDA) /*preprossing for the CUDA environment */
//////////////////////////////////////////////////////////////////////////////
// Error handler methods
//////////////////////////////////////////////////////////////////////////////
/*!\brief C++ Method
 * Prints the Error code from msg
 * \param error_id Error id of type cufftXtResult_t
 * \param msg      Input meassage of type std::string
 * \param line     Line in file where the error code is called of type int
 * \param file     File in file where the error code is called of type string
 * \param function Functn in file where the error code is called of type string
*/
/* Prints the Error code from msg for cufftXt operation */
template <typename T>
int DataDeviceManag<T>::print_error_id_cufftXt(cufftXtResult_t error_id,
					       std::string msg,
					       int line, std::string file,
					       std::string function) {
  //T *unused_variable = NULL; //!<So that compilation passes when T not used
  int rc = RC_SUCCESS;

  std::cerr<<B_RED"cufftXt API call returned: "
	   <<B_YELLOW<<(int)error_id<<C_RESET<<std::endl;;
  std::cerr<<B_CYAN<<"GetErrorString("<<B_YELLOW<<(int)error_id<<B_CYAN<<") -> "
	   <<B_CYAN<<"["<<B_MAGENTA<<msg<<" failed"
	   <<B_CYAN<<"]: ["<<B_RED<<STATE_FAIL<<B_CYAN "]:"<<std::endl;
  std::cerr<<B_CYAN"[function: "<<B_GREEN<<function
	   <<B_CYAN<<", line: "<<B_YELLOW<<line
	   <<B_CYAN<<", in file: "<<B_YELLOW<<file<<B_CYAN<<"]"
	   <<C_RESET<<std::endl;
  rc = (int)error_id;
  std::cerr<<B_CYAN "return code  : [" B_MAGENTA<<rc<<B_CYAN "]"
	   <<C_RESET<<std::endl;
  exit(RC_FAIL);

  return rc;
} /* end of print_error_id_cufftXt method */

/*!\brief Error handler Method to get the error code on enumerated type
  definition cufftXtResult_t via a printer method print_error_id_cufftXt
  \param error_id Error id of type cufftXtResult_t
  \param msg_in   Input meassage of type std::string
  \param line     Line in file where the error code is called of type int
  \param file     File in file where the error code is called of type string
  \param function Function in file where the error code is called of type string
*/
template <typename T>
int DataDeviceManag<T>::get_error_id_cufftXt_gpu(cufftXtResult_t error_id,
						 std::string msg_in,
						 int line, std::string file,
						 std::string function) {
  int rc = RC_SUCCESS;
  //T *unused_variable = NULL; //So that compilation passes when T not used
  std::string msg;

  std::cerr<<std::endl;
  std::cerr<<B_CYAN<<"Incoming Error: ["<<B_MAGENTA<<msg_in<<B_CYAN<<"]"
	   <<std::endl;

  switch ( hshit(error_id)[error_id] ) {
//case CUFFTXT_SUCCESS: msg ="CUFFTXT_SUCCESS something strange happened";break;
  case CUFFTXT_SUCCESS: msg ="*XTSuccess";break;
  case CUFFTXT_INVALID_PLAN: msg ="*XtInvalid_Plan"; break;
  case CUFFTXT_ALLOC_FAILED: msg = "*XtMalloc";break;
  case CUFFTXT_INVALID_TYPE: msg ="*XtInvalid_Type"; break;
  case CUFFTXT_INVALID_VALUE: msg ="*XtInvalid_Value"; break;
  case CUFFTXT_INTERNAL_ERROR: msg ="*XtInternal_Error"; break;
  case CUFFTXT_EXEC_FAILED: msg ="*XtExec"; break;
  case CUFFTXT_SETUP_FAILED: msg ="*XtSetup_Failed"; break;
  case CUFFTXT_INVALID_SIZE: msg ="*XtInvalid_Size"; break;
  case CUFFTXT_UNALIGNED_DATA: msg ="*XtUnaligned_Data"; break;
  case CUFFTXT_INCOMPLETE_PARAMETER_LIST: msg ="*XtIncomplete_Parameter_List";
    break;
  case CUFFTXT_INVALID_DEVICE: msg ="*XtInvalid_Device"; break;
  case CUFFTXT_PARSE_ERROR: msg ="*XtParse_Error"; break;
  case CUFFTXT_NO_WORKSPACE: msg ="*XtNo_Workspace"; break;
  case CUFFTXT_NOT_IMPLEMENTED: msg ="*XtNot_Implemented"; break;
  case CUFFTXT_LICENSE_ERROR: msg ="*XtLicense_Error"; break;
  case CUFFTXT_NOT_SUPPORTED: msg = "*XtNot_Supported"; break;
  case CUFFTXT_MEMCPY_FAILED: msg = "*XtMemcpy"; break;
  default:
    rc = (int)error_id;
    std::cerr<<B_CYAN "Error: ["<<B_MAGENTA<< "Unknown error"
             <<B_CYAN<< "]: ["<<B_RED<<STATE_FAIL<<B_CYAN "]:" <<std::endl;
    std::cerr<<B_CYAN "return code  : [" B_MAGENTA<<rc<<B_CYAN "]"
             <<C_RESET<<std::endl;
    exit(RC_FAIL);
    break;
  }

  rc = print_error_id_cufftXt(error_id, msg, line, file, function);

} /* end of get_error_id_cufftXt_gpu method */

/*!\brief Method to hash an error code of cufftXtResult_t
  \param err Error code to be hashed into map<int, cufftXtResult_t> s_map_rctype
  \return Method returns std::map<int, cufftXtResult_t> s_map_rctype structure
*/
template <typename T>
std::map<int, cufftXtResult_t> DataDeviceManag<T>::hshit(int err) {
  std::map<int, cufftXtResult_t> s_map_rctype;
  //T *unused_variable = NULL; //So that compilation passes when T not used
  if (err == 0x0 ) s_map_rctype[err] = CUFFTXT_SUCCESS;
  if (err == 0x1 ) s_map_rctype[err] = CUFFTXT_INVALID_PLAN;
  if (err == 0x2 ) s_map_rctype[err] = CUFFTXT_ALLOC_FAILED;
  if (err == 0x3 ) s_map_rctype[err] = CUFFTXT_INVALID_TYPE;
  if (err == 0x4 ) s_map_rctype[err] = CUFFTXT_INVALID_VALUE;
  if (err == 0x5 ) s_map_rctype[err] = CUFFTXT_INTERNAL_ERROR;
  if (err == 0x6 ) s_map_rctype[err] = CUFFTXT_EXEC_FAILED;
  if (err == 0x7 ) s_map_rctype[err] = CUFFTXT_SETUP_FAILED;
  if (err == 0x8 ) s_map_rctype[err] = CUFFTXT_INVALID_SIZE;
  if (err == 0x9 ) s_map_rctype[err] = CUFFTXT_UNALIGNED_DATA;
  if (err == 0xA ) s_map_rctype[err] = CUFFTXT_INCOMPLETE_PARAMETER_LIST;
  if (err == 0xB ) s_map_rctype[err] = CUFFTXT_INVALID_DEVICE;
  if (err == 0xC ) s_map_rctype[err] = CUFFTXT_PARSE_ERROR;
  if (err == 0xD ) s_map_rctype[err] = CUFFTXT_NO_WORKSPACE;
  if (err == 0xE ) s_map_rctype[err] = CUFFTXT_NOT_IMPLEMENTED;
  if (err == 0x0F) s_map_rctype[err] = CUFFTXT_LICENSE_ERROR;
  if (err == 0x10) s_map_rctype[err] = CUFFTXT_NOT_SUPPORTED;
  if (err == 0x11) s_map_rctype[err] = CUFFTXT_MEMCPY_FAILED;
  return s_map_rctype;
} /* end of hshit method */
//////////////////////////////////////////////////////////////////////////////
// Data manangement methods
//////////////////////////////////////////////////////////////////////////////
/*!\brief Constructor
 */
template <typename T>
DataDeviceManag<T>::DataDeviceManag() {
  int rc = RC_SUCCESS;
  /* initializing the structure variables */
  rc = _initialize();
  std::cout<<B_MAGENTA<<"Class DataDeviceManag<T>::DataDeviceManag() has been instantiated, return code: "<<B_GREEN<<rc<<COLOR_RESET<<std::endl;
} /* end of DataDeviceManag constructor */

/*!\brief Method to initialize general varaiable
  \return Method returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc.
*/
template <typename T>
int DataDeviceManag<T>::_initialize() {
  int rc = RC_SUCCESS;
  //T *d_self = NULL;
  //cudaLibXtDesc *d_Xt_self = NULL;
  return rc;
} /* end of _initialize method */

/*!\brief Template method to allocate
  \param npts_in Number of points in the data structure
  \param *d_in [input] typename T device pointer
  \return Method returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc.
*/
/* Template methode to alloc different types */
template <typename T>
int DataDeviceManag<T>::t_alloc_gpu(int npts_in, T *d_in) {
  int rc = RC_SUCCESS;          //return code
  int npts = npts_in;
  //Error handlers from the cuda library
  cudaError_t err;

  err = cudaMalloc((void**)&d_in, npts*sizeof(T));
  if ( (int)err != CUDA_SUCCESS ) {
    rc = get_error_id_cuda_gpu(err,__LINE__,__FILE__,__FUNCTION__);
  }
  //setting the pointer value
  rc = set_DevicePtr(d_in);

  return rc;
} /* end of t_alloc_gpu method */

/*!\brief Template method to de allocate
  \param *d_in [input] typename T device pointer
  \return Method returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc.
*/
/* Template methode to alloc and set different types */
template <typename T>
int DataDeviceManag<T>::t_dealloc_gpu(T *d_in) {
  int rc = RC_SUCCESS;          //return code
  //the error handlers from the cuda library
  cudaError_t err;

  err = cudaFree(d_in);
  if ( (int)err != CUDA_SUCCESS ) {
    rc = get_error_id_cuda_gpu(err,__LINE__,__FILE__,__FUNCTION__);
  }

  return rc;
} /* end of t_dealloc_gpu method */

/*!\brief Template method to allocate the input pointer *d_Xt_in via
  cufftXtMalloc
  \param plan_input cufftHandle returned by cufftCreate
  \param *d_Xt_in Pointer to a pointer to a cudaLibXtDesc object
  \param format cufftXtSubFormat value is an enumerated type that indicates
    if the buffer will be used for input or output and the ordering of the data.

  \return Method returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc.
       cufftXtMalloc descriptor Pointer to a pointer to a cudaLibXtDesc object
 */
/*
template <typename T>
int DataDeviceManag<T>::t_cufftXtalloc_gpu(cufftHandle plan_input,
					   cudaLibXtDesc *d_Xt_in,
					   cufftXtSubFormat format) {
  int rc = RC_SUCCESS;          //return code
  cufftResult cufftXt_err;
  cufftXt_err = cufftXtMalloc(plan_input, (cudaLibXtDesc **)&d_Xt_in, format);
  if (cufftXt_err != CUFFT_SUCCESS) {
    rc = get_error_id_cufftXt_gpu((cufftXtResult_t)cufftXt_err,"*XtMalloc",
				  __LINE__,__FILE__,__FUNCTION__);}
  //setting the pointer value
  rc = set_DeviceXtPtr(d_Xt_in);

  return rc;
} /* end of t_cufftXtalloc_gpu method */

/*!\brief Template method to deallocate the input pointer *d_Xt_in via
  cufftXtFree

  \return Method returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc.
 */
/*
template <typename T>
int DataDeviceManag<T>::t_cufftXtdealloc_gpu(cudaLibXtDesc *d_Xt_in) {
  int rc = RC_SUCCESS;          //return code
  cufftResult cufftXt_err;
  cufftXt_err = cufftXtFree(d_Xt_in);
  if (cufftXt_err != CUFFT_SUCCESS) {
    rc = get_error_id_cufftXt_gpu((cufftXtResult_t)cufftXt_err,"*XtDealloc",
				  __LINE__,__FILE__,__FUNCTION__);}

  //setting the pointer value
  rc = set_DeviceXtPtr(NULL);

  return rc;
} /* end of t_cufftXtdealloc_gpu method */

/*!\brief Template method to allocate and set different types onto the device
  \param plan_input cufftHandle returned by cufftCreate
  \param *h_in    Pointer to a pointer to a host data
  \param *d_Xt_in Pointer to a pointer to a cudaLibXtDesc object
  \param format  cufftXtSubFormat value is an enumerated type that indicates
    if the buffer will be used for input or output and the ordering of the data.
  \return        Returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc
 */
/*
template <typename T>
int DataDeviceManag<T>::t_cufftXtallocset_gpu(cufftHandle plan_input, T *h_in,
					      cudaLibXtDesc *d_Xt_in,
					      cufftXtSubFormat format) {
  int rc = RC_SUCCESS;          //return code
  cufftResult cufftXt_err;
  cufftXt_err = cufftXtMalloc(plan_input, (cudaLibXtDesc **)&d_Xt_in, format);
  if (cufftXt_err != CUFFT_SUCCESS) {
    rc = get_error_id_cufftXt_gpu((cufftXtResult_t)cufftXt_err,"*XtMalloc",
				  __LINE__,__FILE__,__FUNCTION__); }

  cufftXt_err = cufftXtMemcpy(plan_input, d_Xt_in, h_in,
			      CUFFT_COPY_HOST_TO_DEVICE);
  if (cufftXt_err != CUFFT_SUCCESS) {
    rc = get_error_id_cufftXt_gpu((cufftXtResult_t)cufftXt_err,"*XtMemcpy",
				  __LINE__,__FILE__,__FUNCTION__); }

  //setting the pointer value
  rc = set_DeviceXtPtr(d_Xt_in);

  return rc;
} /* end of t_cufftXtallocset_gpu method */

/*!\brief Template method to alloc and set different types onto the device
  \param npts_in Number of points on the array
  \param *h_in   Template T Host data pointer to be alocated and transfered
  \param *d_in   Template T Device pointer to data alocated & transfered to GPU
  \return        Returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc
 */
template <typename T>
int DataDeviceManag<T>::t_allocset_gpu(int npts_in, const T *h_in, T *d_in) {
  int rc = RC_SUCCESS;     //Return code
  int npts = npts_in;
  //error handlers from the cuda library
  cudaError_t err;

  err = cudaMalloc((void**)&d_in, npts*sizeof(T));
  if ( (int)err != CUDA_SUCCESS ) {
    rc = get_error_id_cuda_gpu(err, __LINE__,__FILE__,__FUNCTION__);
  }

  err = cudaMemcpy(d_in, h_in, npts * sizeof(T), cudaMemcpyHostToDevice);
  if ( (int)err != CUDA_SUCCESS ) {
    rc = get_error_id_cuda_gpu(err, __LINE__,__FILE__,__FUNCTION__);
  }

  //setting the pointer value
  rc = set_DevicePtr(d_in);

  return rc;
} /* end of t_allocset_gpu method */

/*!\brief Template method to get and dealloc different types from the device
  to the host
  \param npts_in Number of points on the array
  \param *h_out  Template T Host data pointer to be transfered to from device
  \param *d_out  Template T Device pointer to data alocated & transfered to GPU
  \return        Returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc
 */
template <typename T>
int DataDeviceManag<T>::t_deallocget_gpu(int npts_in, T *h_out, T *d_out) {
  int rc = RC_SUCCESS;          //return code
  int npts = npts_in;
  //the error handlers from the cuda library
  cudaError_t err;

  err = cudaMemcpy(h_out, d_out, npts*sizeof(T), cudaMemcpyDeviceToHost);
  if ( (int)err != CUDA_SUCCESS ) {
    rc = get_error_id_cuda_gpu(err,__LINE__,__FILE__,__FUNCTION__);
  }
  err = cudaFree(d_out);
  if ( (int)err != CUDA_SUCCESS ) {
    rc = get_error_id_cuda_gpu(err,__LINE__,__FILE__,__FUNCTION__);
  }

  return rc;
} /* end of t_deallocget_gpu method */

/*!\brief Template method to set device to private variable *d_Xt_self
  \param *d_Xt_in Template T Device pointer to data alocated & transfered to GPU
  \return        Returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc
 */
template <typename T>
int DataDeviceManag<T>::set_DeviceXtPtr(cudaLibXtDesc *d_Xt_in) {
  int rc = RC_SUCCESS;
  //T *unused_variable = NULL; //So that compilation passes when T not used
  d_Xt_self = d_Xt_in;
  return rc;
} /* end of set_DeviceXtPtr method */

/*!\brief Template method to get device to private variable *d_Xt_self
  \return        Returns d_Xt_self
 */
template <typename T>
cudaLibXtDesc * DataDeviceManag<T>::get_DeviceXtPtr() {
  //T *unused_variable = NULL; //So that compilation passes when T not used
  return d_Xt_self;
} /* end of get_DeviceXtPtr method */

/*!\brief Returns a device pointer
  \param *d_in Device pointer to be set
  \return Returns a device pointer after it has been allocatedd and set
 */
template <typename T>
int DataDeviceManag<T>::set_DevicePtr(T *d_in) {
  int rc = RC_SUCCESS;
  d_self = d_in;
  return rc;
} /* end of set_DevicePtr method */

/*!\brief Teamplate method to get a device pointer
  \return Returns a device pointer after it has been allocatedd and set
 */
template <typename T>
T * DataDeviceManag<T>::get_DevicePtr() {
  return d_self;
} /* end of get_DevicePtr method */

/*!\brief Template method to finalize deallocate pointers & throw exception if
  needed
  \param npts_in Number of points on the array
  \exception     Exception<std::invalid_argument> &e
  \return        Returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc
 */
template <typename T>
int DataDeviceManag<T>::_finalize() {
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

/*!\brief Destructor for the Template class and calls _finalize() to clean up
  allocated pointers
  \return        Returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc
 */
template <typename T>
DataDeviceManag<T>::~DataDeviceManag() {
  int rc = RC_SUCCESS;
  //finalising the the method and remmmoving all of of the alocated arrays
  rc = _finalize();
  if (rc != RC_SUCCESS) {
    std::cerr<<B_RED"return code: "<<rc
             <<" line: "<<__LINE__<<" file: "<<__FILE__<<C_RESET<<std::endl;
    exit(rc);
  } else {rc = RC_SUCCESS; /*print_destructor_message("DataDeviceManag");*/}
  rc = get_returnCode(rc, "DataDeviceManag<T>", 0);
} /* end of get_DevicePtr method */
//////////////////////////////////////////////////////////////////////////////
// Instructing the compiler to instantiate the template class
//////////////////////////////////////////////////////////////////////////////
template class DataDeviceManag<int>;
template class DataDeviceManag<float>;
template class DataDeviceManag<cufftComplex>;
//////////////////////////////////////////////////////////////////////////////
// End of the dataDeviceManag.cpp template class
//////////////////////////////////////////////////////////////////////////////
//#endif /* CUDA */










