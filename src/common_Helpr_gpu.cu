//
// Created by Frederic on 12/7/2023.
//

//system headers
#include <stdlib.h>
#include <iostream>
#include <iomanip>
#include <stdio.h>
#if defined (CUDA) /*preprossing for the CUDA environment */
#include <cufftXt.h>
#endif
//application headers
#include "../include/common.cuh"
#include "../include/common_krnl.cuh"
#include "../include/resmap_Sizes.cuh"
#include "../include/common_Helpr_gpu.cuh"
//#if defined (OPENMP) /*preprossing for the OpenMP environment */
#include <omp.h>
//#endif

/** \addtogroup <label>
 *  @{
 */
#define debug false
#define debug_high false
#define debug_write false
#define debug_write_AandB false
#define debug_write_C true
/** @}*/

//#if defined (CUDA) /*preprossing for the CUDA environment */

/* ////////////////////////////////////////////////////////////////////////////
 -- CUDA-C methods common helpers declarartion and implementation
*/
/*!*****************************************************************************
 * \brief CUDA-C Method.
 * Printing out the cudaLibXtDesc descriptor TODO: will need to be moved
 * to the dataDeviceManag.cpp class because of the sizeof(cufftComplex)
 * \param *d_signal Pointer to cudaLibXtDesc
 * \return Method returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc.
 */
extern "C" int
print_signalDescriptor(cudaLibXtDesc *d_signal) {
  int rc = RC_SUCCESS;

  std::cerr<<B_CYAN<<"Value of Library Descriptor"<<C_RESET<<std::endl;

  std::cerr<<B_CYAN<<"Number of GPUs: "
	   <<B_MAGENTA<<d_signal->descriptor->nGPUs<<C_RESET<<std::endl;

  std::cerr<<B_CYAN<<"Device id: "
	   <<B_GREEN<<d_signal->descriptor->GPUs[0]<<" "
	   <<B_YELLOW<<d_signal->descriptor->GPUs[1]
	   <<C_RESET<<std::endl;
  std::cerr<<B_CYAN<<"Data size on GPU: "
	   <<B_GREEN<<(long)(d_signal->descriptor->size[0]/
			     sizeof(cufftComplex))<<" "
	   <<B_YELLOW<<(long)(d_signal->descriptor->size[1]/
			      sizeof(cufftComplex))<<" "
	   <<C_RESET<<std::endl;

  return rc;
} /* end of print_Volxyz method */

/*!*****************************************************************************
 * \brief CUDA-C Method.
 * Printing out the true dimension of the problem
 * \param vx Volume size in x direction
 * \param vy Volume size in y direction
 * \param vz Volume size in z direction
 * \return Method returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc.
 */
/* printing out the true dimension of the problem */
extern "C" int
print_Volxyz(int vx, int vy, int vz) {
  int rc = RC_SUCCESS;
  int npts = vx * vy * vz;

  std::cerr<<B_CYAN "Volume Size   : "
	   <<B_YELLOW "vx="<<vx<<", "
	   <<B_GREEN  "vy="<<vy<<", "
	   <<B_BLUE   "vz="<<vz<<", "
	   <<B_CYAN   "npts="<<npts<<", vx*vy*vz="<<vx*vy*vz
	   <<C_RESET<<std::endl;

  std::cerr<<B_CYAN"Memory Volume : "
	   <<B_RED "vx*vy*vz*sizeof(float)="<<vx*vy*vz*sizeof(float)
	   <<", Memory="<<vx*vy*vz*sizeof(float)/1.e6
	   <<C_RESET<<std::endl;

  return rc;
} /* end of print_Volxyz method */

/*!*****************************************************************************
 * \brief CUDA-C Method.
 * Printing out the center of the true dimension of the problem
 * \param cx Center of volume size in x direction
 * \param cy Center of volume size in y direction
 * \param cz Center of volume size in z direction
 * \return Method returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc.
 */
/* printing out the true dimension of the problem */
extern "C" int
print_Center_xyz(float cx, float cy, float cz) {
  int rc = RC_SUCCESS;
  int npts = cx * cy * cz;

  std::cerr<<B_CYAN "Center pts    : "
	   <<B_YELLOW "cx="<<cx<<", "
	   <<B_GREEN  "cy="<<cy<<", "
	   <<B_BLUE   "cz="<<cz<<", "
	   <<B_CYAN   "npts="<<npts<<", cx*cy*cz="<<cx*cy*cz
	   <<C_RESET<<std::endl;

  std::cerr<<B_CYAN"Memory Volume : "
	   <<B_RED "cx*cy*cz*sizeof(float)="<<cx*cy*cz*sizeof(float)
	   <<", Memory="<<cx*cy*cz*sizeof(float)/1.e6
	   <<C_RESET<<std::endl;
  return rc;
} /* end of print_Center_xyz method */
/*!*****************************************************************************
 * \brief CUDA-C Method.
 * Printing out the resmap_Sizes class values and cross check values
 * \param *p_resmap_Sizes Data values of resmap C structure
 * \return Method returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc.
 */
/* Printing out the resmap_Sizes class values */
extern "C" int
print_resmap_sizes(resmap_Sizes *p_resmap_Sizes) {
  int rc = RC_SUCCESS;
  printf(B_CYAN"p_resmap_Sizes: "
         B_YELLOW"p_resmap_Sizes->get_vx()=%i, "
         B_YELLOW"p_resmap_Sizes->get_vy()=%i, "
         B_YELLOW"p_resmap_Sizes->get_vz()=%i, \n"
         B_GREEN "                p_resmap_Sizes->get_vhlfy()=%i, "
         B_BLUE  "p_resmap_Sizes->get_v2y()=%i, \n"
         B_YELLOW"                p_resmap_Sizes->get_v2x()=%i, "
         B_GREEN "p_resmap_Sizes->get_VolSize()=%i, \n"

         B_BLUE  "                p_resmap_Sizes->get_VolSize_cr3D()=%i\n"
         C_RESET,
         p_resmap_Sizes->get_vx(), p_resmap_Sizes->get_vy(),
	 p_resmap_Sizes->get_vz(), p_resmap_Sizes->get_vhlfy(),
	 p_resmap_Sizes->get_v2y(), p_resmap_Sizes->get_v2x(),
	 p_resmap_Sizes->get_VolSize(),
	 p_resmap_Sizes->get_VolSize_cr3D());
  return rc;
}
/*!*****************************************************************************
 * \brief CUDA-C Method.
 * Printing info for s_kernel struct and cross check values
 * \param *s_kernel kernel values of C structure
 * \return Method returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc.
 */
/* printing info for s_kernel struct */
extern "C"
int print_s_kernel_struct(kernel_calc_t *s_kernel) {
  int rc = RC_SUCCESS;

  printf(B_CYAN"s_kernel      : "
         B_YELLOW"s_kernel->time=%f, "
         B_GREEN "s_kernel->ikrnl=%i, "
         B_BLUE  "s_kernel->threadsPerBlock=%i, \n"
         B_YELLOW"                s_kernel->nthrdx=%i, "
         B_GREEN "s_kernel->nthrdy=%i, "
         B_BLUE  "s_kernel->nthrdz=%i, "
         B_BLUE  "at Line %i %s\n"
         C_RESET,
         s_kernel->time,
         s_kernel->ikrnl, s_kernel->threadsPerBlock,
         s_kernel->nthrdx,s_kernel->nthrdy,s_kernel->nthrdz,
         __LINE__,__FUNCTION__);

  return rc;
}
/*!*****************************************************************************
 * \brief CUDA-C Method.
 * Used for debugging mechanisms using the debug C structure. Prining the
 * values of the 3D mesh, of the kernel_calc_t, resmap sizes and the
 * number of threads on the 3D GPU mesh used to launched the kernels. The
 * method  prints and cross chekcs the values of the structure. This C-structure
 * is called when debug_i == true or set to 1.
 \param s_cnstr_mesh_3D  Switch for the debugging mechanisms
 \param *p_carte_mesh_3D Kernel mesh in 3D
 \param *s_kernel        kernel_cacl_t structure values
 \param *p_resmap_Sizes  resmap_Sizes structure values
 \param nx               Number of threads in the x ex: 16
 \param ny               Number of threads in the y ex: 16
 \param nz               Number of threads in the z ex: 4
 * \return Method returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc.
 */
/* Prining the values of the 3D mesh */
extern "C"
int print_Vol_3D_mesh(int s_cnstr_mesh_3D, carte_mesh_3D *p_carte_mesh_3D,
		      kernel_calc_t *s_kernel, resmap_Sizes *p_resmap_Sizes,
		      int nx, int ny, int nz) {
  int rc = RC_SUCCESS;

  int gridx,gridy,gridz;
  int vtot = p_carte_mesh_3D->get_CarteMesh3D_vx() *
             p_carte_mesh_3D->get_CarteMesh3D_vy() *
             p_carte_mesh_3D->get_CarteMesh3D_vz() ;
  int gtot = p_carte_mesh_3D->get_CarteMesh3D_gridx() *
             p_carte_mesh_3D->get_CarteMesh3D_gridy() *
             p_carte_mesh_3D->get_CarteMesh3D_gridz() ;

  std::cerr<<B_CYAN"mesh3D Objct  : "
	   <<B_YELLOW"p_carte_mesh_3D->get_CarteMesh3D_vx() = "
	   <<p_carte_mesh_3D->get_CarteMesh3D_vx()<<", "
	   <<B_GREEN "p_carte_mesh_3D->get_CarteMesh3D_vy() = "
	   <<p_carte_mesh_3D->get_CarteMesh3D_vy()<<", "
	   <<B_BLUE  "p_carte_mesh_3D->get_CarteMesh3D_vz() = "
	   <<p_carte_mesh_3D->get_CarteMesh3D_vz()<<", "
           <<B_CYAN  "total(nx*ny*nz)= "
	   <<vtot
	   <<C_RESET<<std::endl;

  if ( s_cnstr_mesh_3D == 1) {
  std::cerr<<B_CYAN"              : "
	   <<B_YELLOW"p_carte_mesh_3D->get_CarteMesh3D_gridx() = "
	   <<p_carte_mesh_3D->get_CarteMesh3D_gridx()<<", "
	   <<B_GREEN "p_carte_mesh_3D->get_CarteMesh3D_gridy() = "
	   <<p_carte_mesh_3D->get_CarteMesh3D_gridy()<<", "
	   <<B_BLUE  "p_carte_mesh_3D->get_CarteMesh3D_gridz() = "
	   <<p_carte_mesh_3D->get_CarteMesh3D_gridz()<<", "
           <<B_CYAN  "total(gridx*gridy*gridz) = "
	   <<gtot
	   <<C_RESET<<std::endl;
  }
  std::cerr<<B_CYAN"Dim_3D        : "
	   <<B_YELLOW"(float)nx = "<<(float)nx<<", "
	   <<B_GREEN "(float)ny = "<<(float)ny<<", "
	   <<B_BLUE  "(float)nz = "<<(float)nz<<", "
	   <<C_RESET<<std::endl;

  std::cerr<<B_CYAN   "Threads       : "
	   <<B_YELLOW "nx = "<<nx<<", "
	   <<B_GREEN  "ny = "<<ny<<", "
	   <<B_BLUE   "nz = "<<nz<<", "
	   <<B_CYAN   "total(nx*ny*nz) = "<<nx*ny*nz
	   <<C_RESET<<std::endl;

  gridx =  p_resmap_Sizes->get_vx()/(float)s_kernel->nthrdx +
         ( p_resmap_Sizes->get_vx()%s_kernel->nthrdx!=0     );
  gridy =  p_resmap_Sizes->get_vy()/(float)s_kernel->nthrdy +
         ( p_resmap_Sizes->get_vy()%s_kernel->nthrdy!=0     );
  gridz =  p_resmap_Sizes->get_vz()/(float)s_kernel->nthrdz +
         ( p_resmap_Sizes->get_vz()%s_kernel->nthrdz!=0     );

  printf(B_CYAN"Grid3D        : "
         B_YELLOW"vx/(float)nx+(vx mod(nthrdx)!=0) = %i, "
         B_GREEN "vy/(float)ny+(vy mod(nthrdy)!=0) = %i, "
         B_BLUE  "vz/(float)nz+(vz mod(nthrdz)!=0) = %i, total(*) = %i\n"
         C_RESET,
         gridx,gridy,gridz, gridx*gridy*gridz);

  return rc;
} /* end of print_Vol_3D_mesh method */

/*!*****************************************************************************
 * \brief CUDA-C Method.
 * Printing out the first few elements of the matrices A and B. Used for
 * debugging mechanisms using the debug C structure.
 * The swicthing mechanisms is s_debug_gpu->debug_gpu is true for screen output,
 * for disk output set debug_write_i to true by setting to 1:true
 * (default 0:false).
 * \param *Vol            Pointer onto the Volume
 * \param *p_resmap_Sizes resmap_Sizes structure values
 * \param vx              Volume size in x
 * \param vy              Volume size in y
 * \param vz              Volume size in z
 * \param depth           Depth of tjhe printing on screen
 * \param *s_debug_gpu    Pointer on the debugging C structure debug_gpu_t
 * \return Method returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc.
 */
/* Printing out the first few elements of the matrices A and B */
extern "C" int
print_Vol_depth(const float *Vol,
		resmap_Sizes *p_resmap_Sizes,
		int vx, int vy, int vz,
		int depth, debug_gpu_t *s_debug_gpu) {
  int rc = RC_SUCCESS;
  int i,j,k;

  /* the loops go from */
  for (i=0; i<vx-(vx-depth) ; i++) {
    for (j=0; j<vy-(vy-depth) ; j++) {
      for (k=0; k<vz-(vz-depth) ; k++) {
	std::cerr<<C_GREEN << "Vol"
		 <<"[" << C_CYAN << i <<C_GREEN << "]"
		 <<"[" << C_CYAN << j <<C_GREEN << "]"
		 <<"[" << C_CYAN << k <<C_GREEN << "] = "
		 <<std::setw(15)<<std::setprecision(8)<< Vol[(j+vy*k)*vx+i]
		 <<C_RESET<<std::endl;
      }
    }
  }
  /* the loops go from */
  if ( s_debug_gpu->debug_write_i == 1 ) {

    FILE * VolFile;
    VolFile = fopen("Vol_A_gpu_CUDA.log","a");

    for (i=0; i<  p_resmap_Sizes->get_vx() ; i++) {
      for (j=0; j<  p_resmap_Sizes->get_vy() ; j++) {
        for (k=0; k<  p_resmap_Sizes->get_vz() ; k++) {
          fprintf(VolFile,"A[%i][%i][%i]=(%15.8f) \n",
                  i,j,k, Vol[(j+ p_resmap_Sizes->get_vy()*k) *
			   p_resmap_Sizes->get_vx()+i]);
        }
      }
    }
    fclose(VolFile);
  }
  return rc;
} /* end of print_Vol_depth method */
//////////////////////////////////////////////////////////////////////////////
// Checkers
//////////////////////////////////////////////////////////////////////////////
/*!*****************************************************************************
 * \brief CUDA-C Method.
 * Checker method for the dim3 grid(gridx, gridy, gridz) 3D dimensional
 * variable
 * \param gridx           Size of the device mesh in x
 * \param gridy           Size of the device mesh in y
 * \param gridz           Size of the device mesh in z
 * \param *s_kernel       Pointer top the kernel_calc_t C structure
 * \param *p_resmap_Sizes Pointer to the resmap_Sizes Class
 * \return Method returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc.
 */
/* Checker for the mesh3D via mesh3D getting the kernel call info */
extern "C"
int check_Vol_grid3D(int gridx, int gridy, int gridz,
		     kernel_calc_t *s_kernel,
		     resmap_Sizes *p_resmap_Sizes) {
  int rc = RC_SUCCESS;

  if ( gridx != ( p_resmap_Sizes->get_vx()/(float)s_kernel->nthrdx   +
                  ( p_resmap_Sizes->get_vx()%s_kernel->nthrdx!=0 )   ) )
    {rc = RC_FAIL;}
  if ( gridy != ( p_resmap_Sizes->get_vy()/(float)s_kernel->nthrdy +
                  ( p_resmap_Sizes->get_vy()%s_kernel->nthrdy!=0 ) ) )
    {rc = RC_FAIL;}
  if ( gridz != ( p_resmap_Sizes->get_vz()/(float)s_kernel->nthrdz      +
                  ( p_resmap_Sizes->get_vz()%s_kernel->nthrdz!=0      ) ) )
    {rc = RC_FAIL;}

  return rc;
} /* end of check_Vol_grid3D method */
//////////////////////////////////////////////////////////////////////////////
// Destructor methods
//////////////////////////////////////////////////////////////////////////////
/*!*****************************************************************************
 * \brief CUDA-C Method.
 * Printing method for the destructor handler.
 * \param *model_Name Pointer to object being destroyed.
 * \return Method returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc.
 */
/* printinng the destructor message */
extern "C"
int print_destructor_message(const char *model_Name) {
  int rc = RC_SUCCESS;

  std::cerr<<B_CYAN"Cleaning up...: "<<C_RESET;
  std::cerr<<B_CYAN"[function: "<<B_GREEN<<__FUNCTION__
           <<B_CYAN<<", in file: "<<B_YELLOW<<__FILE__
           <<B_CYAN<<"]"<<C_RESET<<std::endl;

  std::cerr<<B_CYAN<<"                ["<<B_GREEN<<model_Name
           <<B_CYAN<<"] object has been destroyed. "<<C_RESET;

  std::cerr<<B_CYAN "return code: [" B_MAGENTA<<rc<<B_CYAN "]."
           <<C_RESET<<std::endl;

  return rc;
} /* end of print_destructor_message method */
//////////////////////////////////////////////////////////////////////////////
// Debugging functionProgram main
//////////////////////////////////////////////////////////////////////////////

/* the aliases for external access */
#if defined (LINUX)
extern "C" int print_signalDescriptor_() __attribute__((weak,alias("print_signalDescriptor")));
extern "C" int print_s_kernel_struct_() __attribute__((weak,alias("print_s_kernel_struct")));
extern "C" int print_Volxyz_() __attribute__((weak,alias("print_Volxyz")));
extern "C" int print_Center_xyz_() __attribute__((weak,alias("print_Center_xyz")));
extern "C" int print_destructor_message_() __attribute__((weak,alias("print_destructor_message")));
#endif

//#endif
