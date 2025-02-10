//
// Created by Fred on 12/6/2023.
//

#include "../include/timming.cuh"

#include <winsock.h>
#include <timezoneapi.h>

#include <time.h>
#include <windows.h>
//winsock2.h

/*Header for the MACOSX clock environment */
#if defined (MACOSX)
#include <mach/clock.h>
#include <mach/mach.h>
#endif
#define M_LN10 2.30258509299404568402  /* log_e 10 */
/*
 *
 * getcpunanotime_c will get the cpu time in nano seconds.
 *
 */

#ifdef __cplusplus
extern "C" {
#endif
/******************************************************************************/
/**
 *  FORTRAN API - timming functions (simple interface)
 **/

/* /////////////////////////////////////////////////////////////////////////////
 * -- C function definitions / Data on CPU to get the time of instance
 * void gettimeofday_c(struct timeval *restrict tp, void *restrict tzp);
*/
#define timezone _timezone
  void GETTIMEOFDAY_C( double Time[2] ) {
    //TODO: find the equivalent timezone in windows
/*
    struct timeval tp;
    struct timezone tz;

    gettimeofday(&tp, &tz);

    Time[0] = tp.tv_sec;
    Time[1] = tp.tv_usec;
    */
  }
/* /////////////////////////////////////////////////////////////////////////////
 * -- C function definitions / Data on CPU calculates the time diffrence between
 *    time instances
 *    void elapsed_time_c( double start_Time[2], double end_Time[2],
 *                         double *elapsed_time)
*/
  void ELAPSED_TIME_C( double start_Time[2], double end_Time[2],
                       double *elapsed_time) {
    *elapsed_time = (end_Time[0] - start_Time[0]) +
                    (end_Time[1] - start_Time[1])/1000000.0;
  }
/* /////////////////////////////////////////////////////////////////////////////
 * -- C function definitions / Data on CPU gets the cpu time, true time
 * void GETCPUTIME_C( double cpu_time[2], double *elapsed_cpu_time)
*/
  void GETCPUTIME_C( double cpu_time[2], double *elapsed_cpu_time) {
    //TODO: fix the the Windows version of the of he time structure
    /*
    int process= 0;
    struct rusage cpu_usage;
    getrusage(process, &cpu_usage);
    cpu_time[0] = cpu_usage.ru_utime.tv_sec+((cpu_usage.ru_utime.tv_usec)/1000000.);
    cpu_time[1] = cpu_usage.ru_stime.tv_sec+((cpu_usage.ru_stime.tv_usec)/1000000.);
    *elapsed_cpu_time = cpu_time[0]+cpu_time[1];
    */
  }
/* /////////////////////////////////////////////////////////////////////////////
 * -- C function definitions / Data on CPU gets the cpu time, true time nano
 * secs unsigned long long int GETCPUNANOTIME_C(long long int t)
*/
  unsigned long long int GETCPUNANOTIME_C(long long int t) {
    //struct timespec time;

#if defined (LINUX)
    clock_gettime(CLOCK_REALTIME, &time);
    t  = time.tv_sec;
    t *= 1000000000;
    t += time.tv_nsec;
#elif defined (MACOSX)
    clock_serv_t cclock;
    mach_timespec_t mtime;
    host_get_clock_service(mach_host_self(), CALENDAR_CLOCK, &cclock);
    clock_get_time(cclock, &mtime);
    mach_port_deallocate(mach_host_self(), cclock);
    t  = mtime.tv_sec;
    t *= 1000000000;
    t += mtime.tv_nsec;
#endif
    return(t);
  }
/* /////////////////////////////////////////////////////////////////////////////
 * -- C function definitions that gets the length in terms of digits a positive
 * integer, float and double
*/
  int get_length_of_string(int *int_in){
    int length = 1;
    int num = *int_in;
    if (num > 0) length = floor(log10(abs(num))) + 1;
    return length;
  }
  int get_length_of_stringf(float *float_in){
    int length = 1;
    float num = *float_in;
    if (num > 0) length = floor(log10(abs(num))) + 1;
    return length;
  }
  int get_length_of_stringd(double *double_in){
    int length = 1;
    double num = *double_in;
    if (num > 0) length = floor(log10(abs(num))) + 1;
    return length;
  }
/* /////////////////////////////////////////////////////////////////////////////
 * -- C function definitions that copnverts a integer to a string when input
 * int is greater or equal to 0 with the input already setup with input integer
*/
  int convert_int2char_pos(char *char_out, int *int_in) {
    int rc = RC_SUCCESS; //return code
    int length = get_length_of_string(int_in);
    int size_int_in = (length) * sizeof(char);
    char *buff = (char*)malloc(size_int_in);
    sprintf(buff,"%i",*int_in);
    //copying over the buffer into the char_out
    for (int il=0 ; il < length ; il++) {
      char_out[il] = buff[il];
    }
    free(buff);
    return rc;
  } /* end of convert_int2char_pos method */
/* ////////////////////////////////////////////////////////////////////////////
 * -- C function definitions that converts a real to a string when input
 * real is greater or equal to 0 with the input already setup with input integer
*/
  int convert_float2char_pos(char *char_out, float *float_in) {
    int rc = RC_SUCCESS; //return code
    int length = get_length_of_stringf(float_in);
    int size_float_in = (length) * sizeof(char);
    char *buff = (char*)malloc(size_float_in);
    sprintf(buff,"%f",*float_in);
    //copying over the buffer into the char_out
    for (int il=0 ; il < length ; il++) {
      char_out[il] = buff[il];
    }
    free(buff);
    return rc;
  } /* end of convert_float2char_pos method */
/* /////////////////////////////////////////////////////////////////////////////
 * -- C function definitions that converts a real to a string when input
 * real is greater or equal to 0 with the input already setup with input integer
*/
  int convert_double2char_pos(char *char_out, double *double_in) {
    int rc = RC_SUCCESS; //return code
    int length = get_length_of_stringd(double_in);
    int size_double_in = (length) * sizeof(char);
    char *buff = (char*)malloc(size_double_in);
    sprintf(buff,"%f",*double_in);
    //copying over the buffer into the char_out
    for (int il=0 ; il < length ; il++) {
      char_out[il] = buff[il];
    }
    free(buff);
    return rc;
  } /* end of convert_double2char_pos method */
/* /////////////////////////////////////////////////////////////////////////////
 * -- C function definitions that copnverts a integer to a string when input
 * int is greater or equal to 0 with the input not setup with input integer
*/
  int convert_int2char_indexed(char *char_out, int *iter, int *iint,
                               int *max_iter) {
    int rc = RC_SUCCESS; //return code
    int length = get_length_of_string(max_iter);
    int indexed_int = get_indexed_int(length);
    int num = indexed_int + *iint + *iter;
    int length_num = get_length_of_string(&num);
    //int size_iter = (indexed_int) * sizeof(char);
    //char *buff = (char*)malloc(size_iter);
    char *buff = (char*)malloc(length);
    sprintf(buff,"%i",num);
    /*
    printf("length: %i, indexed_int: %i, num: %i, length_num: %i, size_iter: %i, *iter: %i, *iint: %i\n",
           length,
           indexed_int,
           num,
           length_num,
           size_iter,
           *iter,
           *iint);   */
    //copying over the buffer into the char_out
    for (int il=0 ; il < length_num ; il++) {
      char_out[il] = buff[il];
    }
    free(buff);
    return rc;
  } /* end of convert_int2char_indexed method */
/* /////////////////////////////////////////////////////////////////////////////
 * -- C function definitions that increases the indexing by a power based 10 the
 * index of the number
*/
  int get_indexed_int(int length) {
    int indexed_int;
    indexed_int = 0;
#if defined (LINUX)
    int indexed_int = exp10(length-1);
#elif defined (MACOSX)
    int indexed_int = exp(M_LN10 * length - 1);
#endif
    return indexed_int = exp(length-1)  ;
  } /* end of get_indexed_int method */
/* /////////////////////////////////////////////////////////////////////////////
 *  -- C function definitions aliases for external access
*/
  /* the aliases for external access */
/*
  extern "C" int convert_int2char_pos_() __attribute__((weak,alias("convert_int2char_pos")));
  extern "C" int convert_float2char_pos_() __attribute__((weak,alias("convert_float2char_pos")));
  extern "C" int convert_double2char_pos_() __attribute__((weak,alias("convert_double2char_pos")));
  extern "C" int convert_int2char_indexed_() __attribute__((weak,alias("convert_int2char_indexed")));
  extern "C" int get_length_of_string_() __attribute__((weak,alias("get_length_of_string")));
  extern "C" int get_length_of_stringf_() __attribute__((weak,alias("get_length_of_stringf")));
  extern "C" int get_length_of_stringd_() __attribute__((weak,alias("get_length_of_stringd")));
  extern "C" int get_indexed_int_() __attribute__((weak,alias("get_indexed_int")));
  extern "C" void gettimeofday_c_() __attribute__((weak,alias("GETTIMEOFDAY_C")));
  extern "C" void elapsed_time_c_() __attribute__((weak,alias("ELAPSED_TIME_C")));
  extern "C" void getcputime_c_() __attribute__((weak,alias("GETCPUTIME_C")));
  extern "C" void getcpunanotime_c_() __attribute__((weak,alias("GETCPUNANOTIME_C")));
*/
#ifdef __cplusplus
}
#endif
