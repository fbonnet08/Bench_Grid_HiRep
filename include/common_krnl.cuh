//
// Created by Frederic on 12/3/2023.
//
//#if defined (CUDA) /*preprossing for the CUDA environment */
#include <cuda_runtime.h>
#include <cuda_runtime_api.h>
#include <cuda_device_runtime_api.h>
#include <cufftXt.h>
//#endif
//application headers

#include "common.cuh"

#ifndef COMMON_KRNL_CUH
#define COMMON_KRNL_CUH

#define nthrdsBlock      256 // Kernel option for optimized kernels
#define ikernel          6   // kernel number
#define nx_3D            16  // Number of threads in the x-mesh on the GPU for kernel launch
#define ny_3D            16  // Number of threads in the y-mesh on the GPU for kernel launch
#define nz_3D            4   // Number of threads in the z-mesh on the GPU for kernel launch

/*! \brief C Structure.
 *Structure of type typedef for the parameters to be used to launch the GPU
 *kernel. The structure, takes care of the grid, kernel and theads
 *\param time            Time taken
 *\param ikrnl           Which kernel to be used switch as an integer
 *\param threadsPerBlock Number of threads per block
 *\param nthrdx          N threads in the x direction of the device mesh
 *\param nthrdy          N threads in the y direction of the device mesh
 *\param nthrdz          N threads in the z direction of the device mesh
 */
typedef struct kernel_calc {
    float time;          //!<Time taken
    int ikrnl;           //!<Which kernel to be used switch as an integer
    int threadsPerBlock; //!<Number of threads per block
    int nthrdx;          //!<N threads in the x direction of the device mesh
    int nthrdy;          //!<N threads in the y direction of the device mesh
    int nthrdz;          //!<N threads in the z direction of the device mesh
} kernel_calc_t;

//#if defined (CUDA) /*preprossing for the CUDA environment */
/* atomic function to calculate the radius */
__host__ __device__ static __inline__ int cuReRadius(float x, float y,
                             float z, double alpha) {
    double x1 = (double) x;
    double y1 = (double) y;
    double z1 = (double) z;

    return (int)(floor( alpha * sqrt((x1 * x1 + y1 * y1 + z1 * z1 ) ) ) );
} /* end of inline cuReRadius methdod */
//#endif /* CUDA */

typedef struct time_and_date {
}time_and_date_t;

#ifdef __cplusplus
extern "C" {
#endif

//#if defined (CUDA) /*preprossing for the CUDA environment */

/* atomic function to calculate the radius */

  __global__ void map_3D_mat_C2S_scaled(float *A, cuFloatComplex *B,
					float scale, int vx, int vy, int vz);

  __global__ void map_3D_mat_Ss2C(cuFloatComplex *A,
				  float *re_in, float *im_in,
				  int vx, int vy, int vz);

  __global__ void map_3D_mat_C2Ss(float *re_out, float *im_out,
				  cuFloatComplex *A, int vx, int vy, int vz);

  __global__ void map_3D_mat_C2S_MGPU(float *convE2, cufftComplex *A,
				      int size, float scale);

  __global__ void pro_3D_mat_CC2C_scaled_MGPU(cufftComplex *A, cufftComplex *B,
					      int size, float scale);

  __global__ void map_3D_mat_C2S(float *convE2, cuFloatComplex *A,
				 int vx, int vy, int vz);

  __global__ void pro_3D_mat_CC2C_scaled(cuFloatComplex *A, cuFloatComplex *B,
					 int vx, int vy, int vz);

  __global__ void make_3D_mat_S2C(float *A, cuFloatComplex *B,
				  int vx, int vy, int vz);

  int multiplyCoefficient(cudaLibXtDesc *d_signal, cudaLibXtDesc *d_filter,
			  dim3 grid, dim3 threads, float scale , int nGPUs);
  /*! \brief
   * Macro definition for SPHERICALAVE in multiple kernel definitions. Used
   * for the Shperical average kernel list
   * \param *s_kernel   kernel structure, takes care of grid, krnl id & theads
   * \param *Ra          Radial component
   * \param *Na          Number of element in the shell
   * \param *Vol         Volume in question
   * \param vx           Volume size in x direction.
   * \param vy           Volume size in y direction.
   * \param vz           Volume size in z direction.
   * \param *s_bench     Benchmarking struct
   * \param *s_debug_gpu Debugging structure 0:no 1:yes
   */
#define SPHERICALAVE( name ) int sphericalAve_gpu_##name(kernel_calc_t *s_kernel, float *Ra, float *Na, const float *Vol, int vx, int vy, int vz, bench_t *s_bench, debug_gpu_t *s_debug_gpu)
  /*!\brief Spherical average */
  SPHERICALAVE( A_B                        );

  /*! \brief
   * Macro definition for CONVOLUTION in multiple kernel definitions. Used
   * for convolution via cufft. A_B: single GPU, A_M: Multi-GPU.
   * \param *s_kernel    kernel structure, takes care of grid, krnl id & theads
   * \param *Vol         Volume in question
   * \param  *W          The filter
   * \param *convE2      The convoluted signal
   * \param nBases       Number of bases
   * \param wnSz         Window size for the filter
   * \param vx           Volume size in x direction.
   * \param vy           Volume size in y direction.
   * \param vz           Volume size in z direction.
   * \param *s_bench     Benchmarking struct
   * \param *s_debug_gpu Debugging structure 0:no 1:yes
   */
#define CONVOLUTION( name ) int convolution_gpu_##name(kernel_calc_t *s_kernel, const float *Vol, const float *W, float *convE2, int nBases, int wnSz, int vx, int vy, int vz, bench_t *s_bench, debug_gpu_t *s_debug_gpu)
  /*!\brief Convolution Single-GPU */
  CONVOLUTION( A_B                         );
  /*!\brief Convolution Multi-GPU  */
  CONVOLUTION( A_M                         );

  /*! \brief
   * Macro definition for CUFFT_3D_S2C in multiple kernel definitions. Used
   * for taking the 3D Fourier transfor using the cuFFT library from Single
   * precision float ---> Single precision float complex C.
   * A_B: single GPU, A_M: Multi-GPU.
   * \param *s_kernel    kernel structure, takes care of grid, krnl id & theads
   * \param vx           Volume size in x direction.
   * \param vy           Volume size in y direction.
   * \param vz           Volume size in z direction.
   * \param *in          Pointer to volume in question 3D float
   * \param *re_out      Pointer to complex Fourier transform the real part
   * \param *im_out      Pointer complex Fourier transform the imaginary part
   * \param *s_bench     Benchmarking struct
   * \param *s_debug_gpu Debugging structure 0:no 1:yes
   */
#define CUFFT_3D_S2C( name ) int cufft_3D_S2C_tgpu_##name(kernel_calc_t *s_kernel, int vx, int vy, int vz, const cufftReal *in, cufftReal *re_out, cufftReal *im_out, bench_t *s_bench, debug_gpu_t *s_debug_gpu)
  /*!\brief cuFFT S2C Single-GPU */
  CUFFT_3D_S2C( A_B                        );
  /*!\brief cuFFT S2C Multi-GPU */
  CUFFT_3D_S2C( A_M                        );

  /*! \brief
   * Macro definition for CUFFT_3D_C2S in multiple kernel definitions. Used
   * for taking the 3D Fourier transfor using the cuFFT library from
   * Single precision float complex C ---> Single precision float.
   * A_B: single GPU, A_M: Multi-GPU.
   * \param *s_kernel    kernel structure, takes care of grid, krnl id & theads
   * \param vx           Volume size in x direction.
   * \param vy           Volume size in y direction.
   * \param vz           Volume size in z direction.
   * \param *re_in       Pointer to complex Fourier transform the real part
   * \param *im_in       Pointer complex Fourier transform the imaginary part
   * \param *out         Pointer to volume in question 3D float
   * \param *s_bench     Benchmarking struct
   * \param *s_debug_gpu Debugging structure 0:no 1:yes
   */
#define CUFFT_3D_C2S( name ) int cufft_3D_C2S_tgpu_##name(kernel_calc_t *s_kernel, int vx, int vy, int vz, const cufftReal *re_in, const cufftReal *im_in, cufftReal *out, bench_t *s_bench, debug_gpu_t *s_debug_gpu)
  /*!\brief cuFFT C2S Single-GPU */
  CUFFT_3D_C2S( A_B                        );
  /*!\brief cuFFT C2S Multi-GPU */
  CUFFT_3D_C2S( A_M                        );

  /*! \brief
   * Macro definition for FSC_3D in multiple kernel definitions. Used
   * for computing the Fourier Shell Correlation (FSC) of two Gold std float
   * volume by taking the the two 3D Fourier transfor using the cuFFT library
   * from Single precision float ---> Single precision float complex C.
   * \param *s_kernel        Structure, takes care of grid, krnl id & theads
   * \param TRANSA           Swithing mechanism for kernel selection main
   * \param TRANSB           Swithing mechanism for kernel selection main
   * \param vx               Volume size in x direction.
   * \param vy               Volume size in y direction.
   * \param vz               Volume size in z direction.
   * \param *h_reVl1F_in     Volume 1 real part of in Fourier space
   * \param *h_imVl1F_in     Volume 1 imaginary part of in Fourier space
   * \param *h_reVl2F_in     Volume 2 real part of in Fourier space
   * \param *h_imVl2F_in     Volume 1 imaginary part of in Fourier space
   * \param *h_FstarG_out    \sum{F} * {G^{*}}(r)
   * \param *h_sumFFs_out    \sum{F} * {F*}(r)
   * \param *h_sumGGs_out    \sum{G} * {*}(r)
   * \param *s_bench         Benchmarking struct
   * \param *s_debug_gpu     Debugging structure 0:no 1:yes
   */
#define FSC_3D( name ) int Fsc_3D_gpu_##name(kernel_calc_t *s_kernel, int vx, int vy, int vz, const float *reVl1F_in, const float *imVl1F_in, const float *reVl2F_in, const float *imVl2F_in, float *FstarG_out, float *sumFFs_out, float *sumGGs_out, float vxSize, int bin_size, bench_t *s_bench, debug_gpu_t *s_debug_gpu);
  /*!\brief FSC Single-GPU */
  FSC_3D( A_B                        );

//#endif /* CUDA */

#ifdef __cplusplus
}
#endif











#endif //COMMON_KRNL_CUH
