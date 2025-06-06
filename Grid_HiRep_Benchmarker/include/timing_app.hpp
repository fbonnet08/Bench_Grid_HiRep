//
// Created by Fred on 12/6/2023.
//
#include "../include/common_main.hpp"

#ifndef TIMMING_CUH
#define TIMMING_CUH

#define PRECISION_z

#ifdef __cplusplus
extern "C" {
#endif

    /* ////////////////////////////////////////////////////////////////////////////
       -- routines used to interface back to fortran
       *
       *  FORTRAN API -
       *
       */

    void GETTIMEOFDAY_C(double Time[2] );
    void ELAPSED_TIME_C(double start_Time[2], double end_Time[2],
                        double *elapsed_time);
    void GETCPUTIME_C(double cpu_time[2], double *elapsed_cpu_time);
    unsigned long long int GETCPUNANOTIME_C(long long int t);
    int get_length_of_string(int *int_in);
    int convert_int2char_pos(char *char_out, int *int_in);
    int get_indexed_int(int length);
    int get_int2char_pos(char *char_out, int *int_in);
    int convert_int2char_indexed(char *char_out, int *iter, int *iint,
                                 int *max_iter);
    /*TODO: need to fix the converters for the float and double case*/
    int get_length_of_stringf(float *float_in);
    int get_length_of_stringd(double *double_in);
    int convert_float2char_pos(char *char_out, float *float_in);
    int convert_double2char_pos(char *char_out, double *double_in);
    /**/
    /*TODO: need to implement these methods if neccessary*/
    /*
      int get_float2char_pos(char *char_out, float *int_in);
      int get_double2char_pos(char *char_out, double *int_in);
    */

#ifdef __cplusplus
}
#endif

#undef PRECISION_z


#endif //TIMMING_CUH
