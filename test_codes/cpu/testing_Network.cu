//
// Created by Frederic on 12/19/2023.
//

#include "../../global.cuh"
//#include "../../include/common.cuh"
#include "testing_Network.cuh"
//#include "../../include/Exception.cuh"
//#include "../../include/resmap_Sizes.cuh"


namespace namespace_Testing {
  ////////////////////////////////////////////////////////////////////////////////
// Class deepL_ClassTemplate_t mirrored valued type class definition
////////////////////////////////////////////////////////////////////////////////
/*
********************************************************************************
*/
////////////////////////////////////////////////////////////////////////////////
// Class Networks definition extended from the CUDA NPP sdk library
////////////////////////////////////////////////////////////////////////////////
  testing_Network::testing_Network() {
    int rc = RC_SUCCESS;
    namespace_Testing::testing_Network_t<float>
      *cBaseLayer_t = new namespace_Testing::testing_Network_t<float>();
    rc = _initialize(); if (rc != RC_SUCCESS){rc = RC_WARNING;}
  } /* end of deepL_ClassTemplate constructor */
////////////////////////////////////////////////////////////////////////////////
// Class checkers
////////////////////////////////////////////////////////////////////////////////
  int testing_Network::hello() {
    int rc = RC_SUCCESS;
    return rc;
  } /* end of hello checker method */
////////////////////////////////////////////////////////////////////////////////
// Initialiser
////////////////////////////////////////////////////////////////////////////////
  int testing_Network::_initialize() {
    int rc = RC_SUCCESS;
    //rc = print_object_header_deepL(__FUNCTION__, __FILE__);
    return rc;
  } /* end of _initialize method */
////////////////////////////////////////////////////////////////////////////////
//Finaliser deaalicate sthe arrays and cleans up the environement
////////////////////////////////////////////////////////////////////////////////
  int testing_Network::_finalize() {
    int rc = RC_SUCCESS;
    try{
      //TODO: need to free m_tinfo calloc
    } /* end of try */
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
////////////////////////////////////////////////////////////////////////////////
//Destructor
////////////////////////////////////////////////////////////////////////////////
  testing_Network::~testing_Network() {
    int rc = RC_SUCCESS;
    //finalising the the method and remmmoving all of of the alocated arrays
    rc = _finalize();
    if (rc != RC_SUCCESS) {
      std::cerr<<B_RED"return code: "<<rc
               <<" line: "<<__LINE__<<" file: "<<__FILE__<<C_RESET<<std::endl;
      exit(rc);
    } else {rc = RC_SUCCESS; print_destructor_message("testing_Network");}
    rc = get_returnCode(rc, "testing_Network", 0);
  } /* end of ~deepL_FileHandler method */
////////////////////////////////////////////////////////////////////////////////
// Methods that gets interfaced to extern C code for the API and the helper
////////////////////////////////////////////////////////////////////////////////
#ifdef __cplusplus
extern "C" {
#endif

#ifdef __cplusplus
}
#endif


  ////////////////////////////////////////////////////////////////////////////////
  // end of deepLEM namespace
  ////////////////////////////////////////////////////////////////////////////////
} /* End of namespace namespace_Network */
////////////////////////////////////////////////////////////////////////////////

