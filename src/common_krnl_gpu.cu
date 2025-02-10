/*!\file
*   -- ResMap common Kernels: (CUDA-C code)
 *      \author Frederic Bonnet
 *      \date 21th April 2018
 *
 *      Yale University  April 2018
 *
 * Name:
 * ---
 * common_krnl_gpu.cu - CUDA-C code for common kernels
 *
 * Description:
 * ---
 * CUDA-C methods and common Kernels used through out the application. These
 * are common to all and performs data manipulation like products element wise
 * scaling, mapping. All the element wise kernels are performed via atomics that
 * can be found in cuAtomics.h. All of the atomics have been declared as
 * __host__ __device__ static __inline__ T method(argument list)-->return T.
 *
 * @precisions normal z -> s d c
*/
//system headers
//#if defined (CUDA) /*preprossing for the CUDA environment */
#include <cufftXt.h>
//#endif
//application headers
#include "../include/common.cuh"
#include "../include/cuAtomics.cuh"
#include "../include/common_krnl.cuh"




//#if defined (CUDA) /*preprossing for the CUDA environment */

/* ////////////////////////////////////////////////////////////////////////////
   -- CUDA-C methods and common Kernels used through out the application. These
   are common to all and performs data manipulation like products element wise
   scaling, mapping. All the element wise kernels are performed via atomics that
   can be found in cuAtomics.h. All of the atomics have been declared as
   __host__ __device__ static __inline__ T method(argument list)-->return T.
   *
   */

/*!*****************************************************************************
 * \brief CUDA-C Method.
 * Multiplying and scaling for multi-GPU for complex to complex.
 * cuAtomics.h used cuCCmulf--->cuCCscalef.
 * \param *A    Pointer to incoming matrix, output that has been overwritten
 * \param *B    Pointer to incoming matrix
 * \param size  Size of the problem
 * \param scale Scale by which we are scaling by.
 * \return Pointer matrix A of type: cufftComplex
 */
/* printing out the true dimension of the problem */
/* Multiplying and scaling for multi-GPU */
extern "C" __global__ void
pro_3D_mat_CC2C_scaled_MGPU(cufftComplex *A, cufftComplex *B,
			    int size, float scale) {
  const int numThreadsx = blockDim.x * gridDim.x;
  const int idx = threadIdx.x + blockIdx.x * blockDim.x;

  for (int i = idx; i < size; i += numThreadsx) {
        A[i] = cuCCscalef(cuCCmulf(A[i], B[i]), scale);
    }
} /* end of pro_3D_mat_CC2C_scaled_MGPU method */
/*!*****************************************************************************
 * \brief CUDA-C Method.
 * Mapping the 3D matrix from complex float to float for Multu-GPU, scale
 * inserted but not used at the stage but might later. The set of threads is
 * just element wose for he entire volume. cuAtomics.h used: cuReCf
 * \param *convE2 Pointer to outgoing matrix convE2
 * \param *A    Pointer to incoming matrix A
 * \param size  Size of the problem
 * \param scale Scale by which we are scaling by.
 * \return Pointer matrix convE2 of type: float
 */
/* Mapping the real part of complex to float for multi-GPU */
extern "C" __global__ void
map_3D_mat_C2S_MGPU(float *convE2, cufftComplex *A, int size, float scale) {
  const int numThreadsx = blockDim.x * gridDim.x;
  const int idx = threadIdx.x + blockIdx.x * blockDim.x;

  for (int i = idx; i < size; i += numThreadsx) {
    convE2[i] = cuReCf(A[i]);
  }
}/* end of map_3D_mat_C2S_MGPU method */
/*!*****************************************************************************
 * \brief CUDA-C Method.
 * Creates a 3D complex matrix from the real and imaginary part of two float
 * 3D matrices. cuAtomics.h used: cuR2Cf
 * \param *A      Pointer to outgoing matrix A, output that has been overwritten
 * \param *re_in  Pointer to incoming matrix re_in the real part
 * \param *im_in  Pointer to incoming matrix im_in the imaginary part
 * \param vx      Volume size in x direction.
 * \param vy      Volume size in y direction.
 * \param vz      Volume size in z direction.
 * \return Pointer matrix A of type: cuFloatComplex
 */
/* Mapping the real part of complex to float */
extern "C" __global__ void
map_3D_mat_Ss2C(cuFloatComplex *A,
		float *re_in, float *im_in, int vx, int vy, int vz)
{
  int idx = threadIdx.x + blockIdx.x * blockDim.x;
  int idy = threadIdx.y + blockIdx.y * blockDim.y;
  int idz = threadIdx.z + blockIdx.z * blockDim.z;

  if (idx < vx) {
    if (idy < vy){
      if (idz < vz){
	A[(idy + vy*idx)*vz + idz ] = cuR2Cf(re_in[(idy + vy*idx)*vz + idz ],
					     im_in[(idy + vy*idx)*vz + idz ] );
      }
    }
  }

  __syncthreads();
}/* end of map_3D_mat_Ss2C method */
/*!*****************************************************************************
 * \brief CUDA-C Method.
 * Creates a two 3D float matrix from the real and imaginary part of a float
 * complex 3D matrix elementwise. cuAtomics.h used: cuReCf, cuImCf
 * \param *re_out  Pointer to outgoing matrix re_out the real part
 * \param *im_out  Pointer to outgoing matrix im_out the imaginary part
 * \param *A       Pointer to incoming matrix A
 * \param vx       Volume size in x direction.
 * \param vy       Volume size in y direction.
 * \param vz       Volume size in z direction.
 * \return Pointer matrix A of type: cuFloatComplex
 */
/* Mapping the real part of complex to float */
extern "C" __global__ void
map_3D_mat_C2Ss(float *re_out, float *im_out,
	       cuFloatComplex *A, int vx, int vy, int vz)
{
  int idx = threadIdx.x + blockIdx.x * blockDim.x;
  int idy = threadIdx.y + blockIdx.y * blockDim.y;
  int idz = threadIdx.z + blockIdx.z * blockDim.z;

  if (idx < vx) {
    if (idy < vy){
      if (idz < vz){
        re_out[(idy + vy*idx)*vz + idz ] = cuReCf(A[(idy + vy*idx)*vz + idz ]);
        im_out[(idy + vy*idx)*vz + idz ] = cuImCf(A[(idy + vy*idx)*vz + idz ]);
      }
    }
  }
//-DMAKE_CUDA_COMPILER="C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v12.2/bin/nvcc.exe"
  __syncthreads();
}
/*!*****************************************************************************
 * \brief CUDA-C Method.
 * Creates a 3D float matrix A from the float complex matrix by taking the
 * real part pf the B matrix and scales it with a factor scale elementwise.
 * cuAtomics.h used: cuReCf--->cuFFscalef
 * \param *A    Pointer to incoming matrix A matrix of type float
 * \param *B    Pointer to incoming matrix B matrix of type cuFloatComplex
 * \param scale Scale by which we are scaling by
 * \param vx    Volume size in x direction.
 * \param vy    Volume size in y direction.
 * \param vz    Volume size in z direction.
 * \return Pointer matrix A of type: float
 */
/* Mapping the real part of complex to float */
extern "C" __global__ void
map_3D_mat_C2S_scaled(float *A, cuFloatComplex *B, float scale,
		      int vx, int vy, int vz)
{
  int idx = threadIdx.x + blockIdx.x * blockDim.x;
  int idy = threadIdx.y + blockIdx.y * blockDim.y;
  int idz = threadIdx.z + blockIdx.z * blockDim.z;

  if (idx < vx) {
    if (idy < vy){
      if (idz < vz){
        A[(idy + vy*idx)*vz + idz ] =
	  cuFFscalef(cuReCf(B[(idy + vy*idx)*vz + idz ]), scale);
      }
    }
  }

  __syncthreads();
}
/*!*****************************************************************************
 * \brief CUDA-C Method.
 * Creates a 3D float matrix convE2 from the float complex matrix A by taking
 * the real part of the A matrix elementwise.
 * cuAtomics.h used: cuReCf
 * \param *A    Pointer to incoming matrix convE2 matrix of type float
 * \param *B    Pointer to incoming matrix A matrix of type cuFloatComplex
 * \param scale Scale by which we are scaling by
 * \param vx    Volume size in x direction.
 * \param vy    Volume size in y direction.
 * \param vz    Volume size in z direction.
 * \return Pointer matrix convE2 of type: float
 */
/* Mapping the real part of complex to float */
extern "C" __global__ void
map_3D_mat_C2S(float *convE2, cuFloatComplex *A, int vx, int vy, int vz)
{
  int idx = threadIdx.x + blockIdx.x * blockDim.x;
  int idy = threadIdx.y + blockIdx.y * blockDim.y;
  int idz = threadIdx.z + blockIdx.z * blockDim.z;

  if (idx < vx) {
    if (idy < vy){
      if (idz < vz){
        convE2[(idy + vy*idx)*vz + idz ] = cuReCf(A[(idy + vy*idx)*vz + idz ]);
      }
    }
  }

  __syncthreads();
}
/*!*****************************************************************************
 * \brief CUDA-C Method.
 * Creates a 3D complex float matrix A from the scaled product complex float
 * matrix A and B elementwise.
 * cuAtomics.h used: cuCCmulf--->cuCCscalef
 * \param *A    Pointer to incoming matrix A matrix of type cuFloatComplex
 * \param *B    Pointer to incoming matrix B matrix of type cuFloatComplex
 * \param vx    Volume size in x direction.
 * \param vy    Volume size in y direction.
 * \param vz    Volume size in z direction.
 * \return Pointer matrix A of type: cuFloatComplex
 */
/* doing the r product (A*B)/Vol */
extern "C" __global__ void
pro_3D_mat_CC2C_scaled(cuFloatComplex *A, cuFloatComplex *B,
		       int vx, int vy, int vz)
{
  int idx = threadIdx.x + blockIdx.x * blockDim.x;
  int idy = threadIdx.y + blockIdx.y * blockDim.y;
  int idz = threadIdx.z + blockIdx.z * blockDim.z;

  float npts_Vol = vx * vy * vz;
  float scale = 1.0f / npts_Vol;

  if (idx < vx) {
    if (idy < vy){
      if (idz < vz){
        A[(idy + vy * idx) * vz + idz ] = cuCCscalef(cuCCmulf(
	A[(idy + vy * idx) * vz + idz ],
	B[(idy + vy * idx) * vz + idz ] ) , scale);
      }
    }
  }

  __syncthreads();
}
/*!*****************************************************************************
 * \brief CUDA-C Method.
 * Creates a 3D complex float matrix B from float matrix A and 0 elementwise.
 * cuAtomics.h used: cuR2Cf
 * \param *A    Pointer to incoming matrix A matrix of type float
 * \param *B    Pointer to incoming matrix B matrix of type cuFloatComplex
 * \param vx    Volume size in x direction.
 * \param vy    Volume size in y direction.
 * \param vz    Volume size in z direction.
 * \return Pointer matrix A of type: cuFloatComplex
 */
/* Mapping float to complex A ---> B */
extern "C" __global__ void
make_3D_mat_S2C( float *A, cuFloatComplex *B, int vx, int vy, int vz) {

  int idx = threadIdx.x + blockIdx.x * blockDim.x;
  int idy = threadIdx.y + blockIdx.y * blockDim.y;
  int idz = threadIdx.z + blockIdx.z * blockDim.z;

  float zero = 0.0;

  if (idx < vx) {
    if (idy < vy){
      if (idz < vz){
	B[(idy+vy*idx)*vz+idz] = cuR2Cf(A[(idy+vy*idx)*vz+idz], zero);
      }
    }
  }

  __syncthreads();

} /* end of make_3D_mat_S2C kernel */

//#endif /* CUDA */
