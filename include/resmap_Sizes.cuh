/*!\file
*   -- ResMap addon: (C++ code)
 *      \author Frederic Bonnet
 *      \date 12th April 2018
 *
 *      Yale University April 2018
 *      Revisited (12/7/2023)
 *
 * Name:
 * ---
 * common_resmap.hpp - header file for the common for ResMap
 *
 * Description:
 * ---
 * C++ header for methods used in kernel calculation on GPU. Common header
 * block for the class used in ResMap:
 * - carte_mesh_3D
 * - resmap_Sizes
 *
 * These classes are then instatentiated and used for the GPU kernels
 *
 * @precisions normal z -> s d c
 */
//system headers
#include <string>
// Cuda includes
//#if defined (CUDA) /*preprossing for the CUDA environment */
#include <cufftXt.h>
//#endif

// Application includes
#include "common_krnl.cuh"
#include "carte_mesh_3D.cuh"

#ifndef RESMAP_SIZES_CUH
#define RESMAP_SIZES_CUH

#ifdef __cplusplus
extern "C" {
#endif

/* ////////////////////////////////////////////////////////////////////////////
 -- common resmap kernel function definitions / Data on GPU
*/

  /* TRANSFORMERS */
  int EmbbedFilter2Volume(const float *filter, float *pad_fltr,
			  int wnSz, int vx, int vy, int vz);
  /* GETTERS */
  /*!\brief
    Gets the return code
    \param rc_in input return code
    \param prg Program where the return code is coming from
    \param final_main
   */
  int get_returnCode(int rc_in, std::string prg, int final_main);
  /* ACTIVATORS */
  /* CHECKERS */
  int get_Center_xyz(float *cx, float *cy, float *cz);
  /* OPTIMSATION*/
  /* helper methods from CUDA */
  /* CLASSES */
  /*!\brief Class for the volume sizes and related to ResMap */
  /* class for the resmap_Sizes */
  class resmap_Sizes {
  private:
  public:
    /*global variables*/
    int vx_in; //!<Volume size in x direction
    int vy_in; //!<Volume size in y direction
    int vz_in; //!<Volume size in z direction
    /*constructor*/
    resmap_Sizes(int vx_in, int vy_in, int vz_in);
    resmap_Sizes(int vx_in, int vy_in, int vz_in, int nBases_in);
    /*setters*/
    void set_vx(int vx);
    void set_vy(int vy);
    void set_vz(int vz);
    void set_nBases(int nBases);
    /*getters*/
    int get_nBases();
    int get_vx(); int get_vy(); int get_vz();
    float get_cx(); float get_cy(); float get_cz();
    int get_v2x(); int get_v2y(); int get_v2z();
    int get_vhlfx(); int get_vhlfy(); int get_vhlfz();
    int get_VolSize();
    int get_VolSize_cr3D();
    /*destructors*/
    ~resmap_Sizes();
  };
  /* ERROR and WARNING handlers methods */
  /* GETTERS */
  int get_Center_xyz(float *cx, float *cy, float *cz);
  /* CHECKERS */
  int check_Vol_grid3D(int gridx, int gridy, int gridz,
		       kernel_calc_t *s_kernel,
		       resmap_Sizes *p_resmap_Sizes);
  /* PRINTERS */
  int print_signalDescriptor(cudaLibXtDesc *d_signal);
  int print_destructor_message(const char *model_Name);
  int print_s_kernel_struct(kernel_calc_t *s_kernel);
  int print_Vol_depth(const float *Vol,	resmap_Sizes *p_resmap_Sizes,
		      int vx, int vy, int vz,
		      int depth, debug_gpu_t *s_debug_gpu);

  int print_Vol_3D_mesh(int s_cnstr_mesh_3D, carte_mesh_3D *p_carte_mesh_3D,
			kernel_calc_t *s_kernel, resmap_Sizes *p_resmap_Sizes,
			int nx, int ny, int nz);
  int print_resmap_sizes(resmap_Sizes *p_resmap_Sizes);
  int print_Volxyz(int vx, int vy, int vz);
  int print_Center_xyz(float cx, float cy, float cz);
  /* CPU CALCULATORS */

#ifdef __cplusplus
}
#endif

#endif //RESMAP_SIZES_CUH
