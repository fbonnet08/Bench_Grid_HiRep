//
// Created by Frederic on 12/7/2023.
//

//system headers
#include <stdlib.h>
#include <iostream>
#include <iomanip>
#include <stdio.h>
#include <string>
#include <cstring>
#if defined (CUDA) /*preprossing for the CUDA environment */
#include <cufftXt.h>
#endif
//application headers
#include "../include/common_main_app.hpp"
//#include "../include/common_krnl.cuh"
//#include "../include/resmap_Sizes.cuh"
#include "../include/common_Helpr_cpu.hpp"
//#if defined (OPENMP) /*preprossing for the OpenMP environment */
//#include <omp.h>
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

//////////////////////////////////////////////////////////////////////////////
// -- CUDA-C methods common helpers declarartion and implementation
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
// Checkers and Printers
//////////////////////////////////////////////////////////////////////////////
#ifdef __cplusplus
extern "C" {
#endif
    //***********************************************************************/
    /*
     *  C - C++ - CUDA-C - FORTRAN - Python API - functions (ResMap interface)
     */
    //#if defined (CUDA) /*preprossing for the CUDA environment */
    //////////////////////////////////////////////////////////////////////////
    // [Printers]
    //////////////////////////////////////////////////////////////////////////
    int print_empty_method_message(const char *model_Name) {
        int rc = RC_SUCCESS;

        std::cerr<<B_CYAN"Screening  ...: "<<C_RESET;
        std::cerr<<B_CYAN"[function: "<<B_GREEN<<__FUNCTION__
                 <<B_CYAN<<", in file: "<<B_MAGENTA<<__FILE__
                 <<B_CYAN<<"]"<<C_RESET<<std::endl;

        std::cerr<<B_CYAN<<"                ["<<B_YELLOW<<model_Name
                 <<B_CYAN<<"] function printing. "<<C_RESET;

        std::cerr<<B_CYAN "return code: [" B_MAGENTA<<rc<<B_CYAN "]."
                 <<C_RESET<<std::endl;

        return RC_SUCCESS;
    } /* end of print_machine_data_structure(machine_struct* s_mach) method */

    int print_machine_data_structure(machine_struct* s_mach) {
        int rc = RC_SUCCESS;
        std::cout<<B_BLUE<<"*------- Machine struct ---------------*"<<std::endl;
        std::cout<<B_BLUE<<"s_mach->nMachine_ipv4              ---> "<<B_YELLOW<<s_mach->nMachine_ipv4<<std::endl;
        std::cout<<B_BLUE<<"s_mach->nMachine_macs              ---> "<<B_YELLOW<<s_mach->nMachine_macs<<std::endl;
        std::cout<<B_BLUE<<"s_mach->hostname                   ---> "<<B_YELLOW<<s_mach->hostname<<std::endl;
        std::cout<<B_BLUE<<"s_mach->device_name                ---> "<<B_YELLOW<<s_mach->device_name<<std::endl;
        std::cout<<B_BLUE<<"s_mach->machine_name               ---> "<<B_YELLOW<<s_mach->machine_name<<std::endl;
        std::cout<<B_BLUE<<"*--------------------------------------*"<<std::endl;
        std::cout<<COLOR_RESET;
        if (s_mach->nMachine_ipv4 != 1){rc = RC_FAIL;}
        return rc;
    } /* end of print_machine_data_structure(machine_struct* s_mach) method */
    //////////////////////////////////////////////////////////////////////////
    // [Getters]
    //////////////////////////////////////////////////////////////////////////
    /*!***********************************************************************
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
            //std::cerr<<B_B_YELLOW<<"prog          : "<<prg<<C_RESET<<std::endl;
            std::cerr<<B_CYAN    <<"return code   : [" B_MAGENTA<<rc_in<<B_CYAN "]"
                 <<C_RESET<<std::endl;
            rc = rc_in;
            print_destructor_message(strcpy(arr,prg.c_str()));
            //exit(rc);
            break;
        case 1:
            //std::cerr<<B_B_YELLOW<<"Final prog    : "<<prg<<C_RESET<<std::endl;
            std::cerr<<B_CYAN    <<"return code   : [" B_MAGENTA<<rc<<B_CYAN "]"
                 <<C_RESET<<std::endl;
            rc = rc_in;
            print_destructor_message(strcpy(arr,prg.c_str()));
            //exit(rc);
            break;
        default:
            break;
        }

        return rc;
    } /* end of get_returnCode method */

    /* the aliases for external access */
#if defined (LINUX)
    extern "C" int get_returnCode_() __attribute__((weak,alias("get_returnCode")));
    extern "C" int print_machine_data_structure_() __attribute__((weak,alias("print_machine_data_structure")));
#endif

//#endif /* CUDA */

#ifdef __cplusplus
}
#endif

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
             <<B_CYAN<<", in file: "<<B_MAGENTA<<__FILE__
             <<B_CYAN<<"]"<<C_RESET<<std::endl;

    std::cerr<<B_CYAN<<"                ["<<B_YELLOW<<model_Name
             <<B_CYAN<<"] object has been destroyed. "<<C_RESET;

    std::cerr<<B_CYAN "return code: [" B_MAGENTA<<rc<<B_CYAN "]."
             <<C_RESET<<std::endl;

    return RC_SUCCESS;
} /* end of print_destructor_message method */
//////////////////////////////////////////////////////////////////////////////
// Debugging functionProgram main
//////////////////////////////////////////////////////////////////////////////

/* the aliases for external access */
#if defined (LINUX)
extern "C" int print_destructor_message_() __attribute__((weak,alias("print_destructor_message")));
#endif

//#endif
