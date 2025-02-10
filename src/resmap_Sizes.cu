//
// Created by Frederic on 12/7/2023.
//
#include <iostream>

#include "../include/common.cuh"
#include "../include/resmap_Sizes.cuh"
#include "../global.cuh"
#include "../include/common_Helpr_gpu.cuh"

/*!\brief Contructor
  \param vx_in Volume size in x
  \param vy_in Volume size in y
  \param vz_in Volume size in z
*/
resmap_Sizes::resmap_Sizes(int vx_in, int vy_in, int vz_in) {
  Vx_o = vx_in;
  Vy_o = vy_in;
  Vz_o = vz_in;
}
/*!\brief Overloaded contructor
  \param vx_in Volume size in x
  \param vy_in Volume size in y
  \param vz_in Volume size in z
  \param nBases_in Number of bases to be used
*/
/* overloading the constructor */
resmap_Sizes::resmap_Sizes(int vx_in, int vy_in, int vz_in, int nBases_in) {
  Vx_o = vx_in;
  Vy_o = vy_in;
  Vz_o = vz_in;
  nBases_o = nBases_in;
}
/* setters */
/*!\brief Sets the number of sites in the x direction
  \param vx Volume size in x
*/
void resmap_Sizes::set_vx(int vx) { Vx_o = vx; }
/*!\brief Sets the number of sites in the x direction
  \param vy Volume size in y
*/
void resmap_Sizes::set_vy(int vy) { Vy_o = vy; }
/*!\brief Sets the number of sites in the x direction
  \param vz Volume size in z
*/
void resmap_Sizes::set_vz(int vz) { Vz_o = vz; }
/*!\brief Sets the number of bases
  \param nBases Number of bases
*/
void resmap_Sizes::set_nBases(int nBases) { nBases_o = nBases; }
/* getters */
/*!\brief Gets size of Vol in x direction */
int resmap_Sizes::get_vx()          {return Vx_o;                           }
/*!\brief Gets size of Vol in y direction */
int resmap_Sizes::get_vy()          {return Vy_o;                           }
/*!\brief Gets size of Vol in z direction */
int resmap_Sizes::get_vz()          {return Vz_o;                           }
/*!\brief Gets center of Vol in x direction */
float resmap_Sizes::get_cx()        {return (float)(Vx_o-1)/2;              }
/*!\brief Gets center of Vol in y direction */
float resmap_Sizes::get_cy()        {return (float)(Vy_o-1)/2;              }
/*!\brief Gets center of Vol in z direction */
float resmap_Sizes::get_cz()        {return (float)(Vz_o-1)/2;              }
/*!\brief gets the number of bases */
int resmap_Sizes::get_nBases()      {return nBases_o;                       }
/*!\brief Gets scaled by 2 of Vol in x direction: Vx*2 */
int resmap_Sizes::get_v2x()         {return Vx_o * 2;                       }
/*!\brief Gets scaled by 2 of Vol in y direction: Vy*2 */
int resmap_Sizes::get_v2y()         {return Vy_o * 2;                       }
/*!\brief Gets scaled by 2 of Vol in z direction: Vz*2 */
int resmap_Sizes::get_v2z()         {return Vz_o * 2;                       }
/*!\brief Gets scaled by 1/2 of Vol in x direction: Vx*1/2 */
int resmap_Sizes::get_vhlfx()       {return Vx_o / 2;                       }
/*!\brief Gets scaled by 1/2 of Vol in y direction: Vy*1/2 */
int resmap_Sizes::get_vhlfy()       {return Vy_o / 2;                       }
/*!\brief Gets scaled by 1/2 of Vol in z direction: Vz*1/2 */
int resmap_Sizes::get_vhlfz()       {return Vz_o / 2;                       }
/*!\brief Gets Volume size via direct multiplication of object variable*/
int resmap_Sizes::get_VolSize()     {return Vx_o * Vy_o * Vz_o;             }
/*!\brief Gets Volume size via multiplication of object getters variable*/
int resmap_Sizes::get_VolSize_cr3D(){return get_vx() * get_vy() * get_vz(); }
/*!\brief Destructor */
/* the destructor */
resmap_Sizes::~resmap_Sizes() {
  std::cerr << B_GREEN "Object resmap_Sizes has been destroyed"
	    << C_RESET<<std::endl;
}




#ifdef __cplusplus
extern "C" {
#endif
  //*****************************************************************************/
/*
 *  C - C++ - CUDA-C - FORTRAN - Python API - functions (ResMap interface)
 */

//#if defined (CUDA) /*preprossing for the CUDA environment */

  /*!***************************************************************************
   * \brief C++ Method.
   * C++ wrapper code over CUDA-C method for printing the center of volume
   * \param *cx         Volume center location in x direction
   * \param *cy         Volume center location in y direction
   * \param *cz         Volume center location in z direction
   * \return Method returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc.
   */
  /* C++ wrapper method for the center printer */
  int get_Center_xyz(float *cx, float *cy, float *cz) {
    int rc = RC_SUCCESS;

    rc = print_Center_xyz(*cx, *cy, *cz);

    return rc;
  } /* end of get_Center_xyz method */

  /*!***************************************************************************
   * \brief C++ Method.
   * C++ code for Embedding the filter
   * \param *filter    Pointer to the filter to be padded
   * \param *pad_fltr  Pointer to the padded filter full volume size
   * \param wnSz       Window size
   * \param vx         Volume size in x direction
   * \param vy         Volume size in y direction
   * \param vz         Volume size in z direction
   * \return Method returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc.
   */
  /* C++ code for Embedding the filter */
  int EmbbedFilter2Volume(const float *filter, float *pad_fltr,
			  int wnSz, int vx, int vy, int vz) {
  /* return code */
    int rc = RC_SUCCESS;          //return code
    //float depthv = vx;              //printer index depth
    /* center movers */
    float i_ctr, j_ctr, k_ctr;
    int i_p, j_p, k_p;
    /* initialising the coordinate movers cx cy and cz and fx fy and fz */
    int cx=(int)(vx/2);
    int cy=(int)(vy/2);
    int cz=(int)(vz/2);

    rc = print_Center_xyz(cx, cy, cz);

    int fx=(int)((wnSz-1)/2);
    int fy=fx;
    int fz=fy;

    rc = print_Center_xyz(fx, fy, fz);

    for(int i=0; i<wnSz; i++){
      for(int j=0; j<wnSz; j++){
	for(int k=0; k<wnSz; k++){

	  i_ctr = i - fx;
	  j_ctr = j - fy;
	  k_ctr = k - fz;

	  i_p = int( i_ctr + cx) + 1 + vx%2;
	  j_p = int( j_ctr + cy) + 1 + vy%2;
	  k_p = int( k_ctr + cz) + 1 + vz%2;
	  /*
          printf("i: %i ,j: %i, k: %i, i_p: %i, j_p: %i,  k_p: %i \n",
                i, j, k, i_p, j_p, k_p );
	  */
	  pad_fltr[(j_p + vy*i_p)*vz + k_p ] = filter[(j + wnSz*i)*wnSz + k];

	}
      }
    }

    return rc;
  } /* end of EmbbedFilter2Volume method */

  /*!***************************************************************************
   * \brief C++ Method.
   * C++ code final return code for the entire program
   * \param rc_in       Input return code
   * \param prg         Program where this is being called from
   * \param final_main  Final return code being returned from the computation
   * \return Method returns one of {RC_SUCCESS, RC_FAIL, RC_STOP} via int rc.
   */
  /* C++ code final return code for the entire program */
  int get_returnCode(int rc_in, std::string prg, int final_main) {
    int rc = RC_SUCCESS;
    char* arr = new char[prg.length() + 1];
    std::cerr<<std::endl;
    switch(final_main) {
    case 0:
      std::cerr<<B_B_YELLOW
	       <<"rc="<<prg<<C_RESET<<std::endl;
      std::cerr<<B_CYAN "return code  : [" B_MAGENTA<<rc_in<<B_CYAN "]"
	       <<C_RESET<<std::endl;
      rc = rc_in;
      print_destructor_message(strcpy(arr,prg.c_str()));
      exit(rc);
      break;
    case 1:
      std::cerr<<B_B_YELLOW
	       <<"Final rc="<<prg<<C_RESET<<std::endl;
      std::cerr<<B_CYAN "return code  : [" B_MAGENTA<<rc<<B_CYAN "]"
	       <<C_RESET<<std::endl;
      rc = rc_in;
      print_destructor_message(strcpy(arr,prg.c_str()));
      exit(rc);
      break;
    default:
      break;
    }

    return rc;
  } /* end of get_returnCode method */

  /* the aliases for external access */
#if defined (LINUX)
  extern "C" int get_Center_xyz_() __attribute__((weak,alias("get_Center_xyz")));
  extern "C" int EmbbedFilter2Volume_() __attribute__((weak,alias("EmbbedFilter2Volume")));
  extern "C" int get_returnCode_() __attribute__((weak,alias("get_returnCode")));
#endif

//#endif /* CUDA */

#ifdef __cplusplus
}
#endif






