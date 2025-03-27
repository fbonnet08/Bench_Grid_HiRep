//
// Created by Frederic on 12/7/2023.
//
//system headers
#include <string>

#ifndef COMMON_HELPR_CPU_HPP
#define COMMON_HELPR_CPU_HPP

#ifdef __cplusplus
extern "C" {
#endif
    /* ////////////////////////////////////////////////////////////////////////////
     -- common resmap kernel function definitions / Data on GPU
    */
    int print_empty_method_message(const char *model_Name);
    int print_machine_data_structure(machine_struct* s_machine);
    int get_returnCode(int rc_in, std::string prg, int final_main);
    int print_destructor_message(const char *model_Name);
#ifdef __cplusplus
}
#endif


#endif //COMMON_HELPR_CPU_HPP
