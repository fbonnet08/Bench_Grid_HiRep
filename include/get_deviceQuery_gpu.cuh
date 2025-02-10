//
// Created by Fred on 12/7/2023.
//

/* The Simple header */
#include "common.cuh"

#ifndef GET_DEVICEQUERY_GPU_CUH
#define GET_DEVICEQUERY_GPU_CUH

#define PRECISION_z

namespace namespace_System_gpu {
#ifdef __cplusplus
extern "C" {
#endif
/* ////////////////////////////////////////////////////////////////////////////
   -- class declaration SystemQuery_gpu
*/

	class SystemQuery_gpu {
	private:
	public:
		//std::string ver_o;
		/* constructor */
		SystemQuery_gpu();
		SystemQuery_gpu(deviceDetails_t *devD);
		/* methods */
		int _initialize();
		int _initialize(deviceDetails_t *devD);
		int findCudaDevice(cudaDeviceProp deviceProp, deviceDetails_t *devD);
		/* methods used to fill in the data structure */
		int deviceDetails_init(int *idev, deviceDetails_t *devD);
		int deviceDetails_free(deviceDetails_t *devD);

		inline int gpuGetMaxGflopsDeviceId();
		inline bool checkCudaCapabilities(int major_version, int minor_version);
		/* sets the device for computation */
		int setDevice(int *idev);
		/* helper methods from CUDA */
		inline int _ConvertSMVer2Cores(int major, int minor);
		/*error and warning handlers methods */
		int get_warning_message();
		int get_error_id (cudaError_t error_id);
		int get_cuda_cores_error(int ncores);
		int get_ecc_warning_message(deviceDetails_t *devD);
		/* quering handlers methods */
		int get_dev_count(deviceDetails_t *devD);
		int get_dev_Name(cudaDeviceProp deviceProp, deviceDetails_t *devD);
		int get_cuda_driverVersion(int *driverVersion, deviceDetails_t *devD);
		int get_cuda_runtimeVersion(int *runtimeVersion, deviceDetails_t *devD);
		int get_tot_global_mem_MB(cudaDeviceProp deviceProp, float *totalGlobalMem_MB, deviceDetails_t *devD);
		int get_tot_global_mem_bytes(cudaDeviceProp deviceProp, unsigned long long *totalGlobalMem_bytes,
						 deviceDetails_t *devD);
		int get_CUDA_cores(int *idev, cudaDeviceProp deviceProp, int *gpu_major, int *gpu_minor, int *nmp,
				   int *cuda_cores_per_mp, int *ncuda_cores, deviceDetails_t *devD);
		int get_nregisters(cudaDeviceProp deviceProp, int *nregisters, deviceDetails_t *devD);
		int get_thread_details(cudaDeviceProp deviceProp, int *warpSize, int *max_threads_per_mp,
				 int *max_threads_per_blk, deviceDetails_t *devD);
		int get_eec_support(cudaDeviceProp deviceProp, int *is_ecc, int *idev, deviceDetails_t *devD);
		int get_peer_to_peer_capabilities(deviceDetails_t *devD);
		/* wrapper function to find the most suitable device on system */
		int get_findCudaDevice(int *idev);

		/* Helper functions */

		/* finaliser methods */
		int _finalize();
		/* Destructor */
		~SystemQuery_gpu();
	}; /* end of class SystemQuery_gpu declaration */
	/* ////////////////////////////////////////////////////////////////////////////*/
	/* ////////////////////////////////////////////////////////////////////////////
		   -- routines used to interface back to fortran
		   *
		   *  C-FORTRAN-Python API - functions
		   *
	*/
#if defined (CUDA) /*preprossing for the CUDA environment */
	int findCudaDevice(cudaDeviceProp deviceProp);
	int deviceDetails_init(int *idev, deviceDetails_t *devD);
	int deviceDetails_free(deviceDetails_t *devD);
	/* */
	inline int gpuGetMaxGflopsDeviceId();
	inline bool checkCudaCapabilities(int major_version, int minor_version);
	/* sets the device for computation */
	int setDevice(int *idev);
	/* helper methods from CUDA */
	inline int _ConvertSMVer2Cores(int major, int minor);
	/*error and warning handlers methods */
	int get_warning_message();
	int get_error_id (cudaError_t error_id);
	int get_cuda_cores_error(int ncores);
	int get_ecc_warning_message(deviceDetails_t *devD);
	/* quering handlers methods */
	int get_dev_count(deviceDetails_t *devD);
	int get_dev_Name(cudaDeviceProp deviceProp, deviceDetails_t *devD);
	int get_cuda_driverVersion(int *driverVersion, deviceDetails_t *devD);
	int get_cuda_runtimeVersion(int *runtimeVersion, deviceDetails_t *devD);
	int get_tot_global_mem_MB(cudaDeviceProp deviceProp, float *totalGlobalMem_MB, deviceDetails_t *devD);
	int get_tot_global_mem_bytes(cudaDeviceProp deviceProp, unsigned long long *totalGlobalMem_bytes,
					 deviceDetails_t *devD);

	int get_CUDA_cores(int *idev, cudaDeviceProp deviceProp, int *gpu_major, int *gpu_minor, int *nmp,
			   int *cuda_cores_per_mp, int *ncuda_cores, deviceDetails_t *devD);

	int get_nregisters(cudaDeviceProp deviceProp, int *nregisters, deviceDetails_t *devD);

	int get_thread_details(cudaDeviceProp deviceProp, int *warpSize, int *max_threads_per_mp,
			 int *max_threads_per_blk, deviceDetails_t *devD);

	int get_eec_support(cudaDeviceProp deviceProp, int *is_ecc, int *idev, deviceDetails_t *devD);
	int get_peer_to_peer_capabilities(deviceDetails_t *devD);
	/* wrapper function to find the most suitable device on system */
	int get_findCudaDevice(int *idev);
#endif /* CUDA */

#ifdef __cplusplus
}
#endif

} /* end of namespace namespace_System_gpu */


#undef PRECISION_z

#endif //GET_DEVICEQUERY_GPU_CUH




