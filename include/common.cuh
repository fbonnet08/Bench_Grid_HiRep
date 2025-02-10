//
// Created by Frederic on 12/3/2023.
//
//System header
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <iostream>
#include <vector_types.h>
#include <vector>

#if defined(__GNUC__)
#include <stdint.h>
#endif /* __GNUC__ */

/*preprossing for the CUDA environment */
#if defined (CUDA)
#include <cuda.h>
#include <cuda_runtime_api.h>
#include <cublas.h>
#endif
/*
#include <time.h>
#include <stdio.h>
#include <sys/types.h>
*/
#if defined (MACOSX)
#include <stdint.h>
#include <sys/param.h>
#include <sys/sysctl.h>
#include <sys/syscall.h>
#elif defined (LINUX)
#include <sys/time.h>
#include <sys/resource.h>
#include <unistd.h>
#include <linux/param.h>
#include <linux/sysctl.h>
#endif

#ifndef COMMON_CUH
#define COMMON_CUH

#if defined (CUDA)
//System header
#include <cufftXt.h>
/*
#include <cuda.h>
#include <cuda_runtime_api.h>
#include <cublas.h>
*/
#endif

#if defined (WINDOWS)
// Specify the width of the field in which to print the numbers.
// The asterisk in the format specifier "%*I64d" takes an integer
// argument and uses it to pad and right justify the number.
#define WIDTH 7
// Use to convert bytes to KB
#define DIV 1024
//#include <windows.h>
//#include <winsock2.h>
//#include <ws2tcpip.h>
//#include <iphlpapi.h>
//PIP_ADAPTER_INFO pinfo;
//PIP_ADAPTER_INFO pinfo;
#define MAX_ADAPTER_DESCRIPTION_LENGTH  128 // arb.
#define MAX_ADAPTER_NAME_LENGTH         256 // arb.
#define MAX_ADAPTER_ADDRESS_LENGTH      8   // arb.

#define MAX_IPV4_ADDRESS_LENGTH         15   // arb.

#define DEFAULT_MINIMUM_ENTITIES        32  // arb.
#define MAX_HOSTNAME_LEN                128 // arb.
#define MAX_DOMAIN_NAME_LEN             128 // arb.
#define MAX_SCOPE_ID_LEN                256 // arb.
#define MAX_DHCPV6_DUID_LENGTH          130 // RFC 3315.
#define MAX_DNS_SUFFIX_STRING_LENGTH    256
//
// types
//
// Node Type
#define BROADCAST_NODETYPE              1
#define PEER_TO_PEER_NODETYPE           2
#define MIXED_NODETYPE                  4
#define HYBRID_NODETYPE                 8

#define WORKING_BUFFER_SIZE             15000
#define MAX_TRIES                       3

#endif


/*! Definitions of the matrix operation based on the LAPACKS convention lib*/
#define SimpleLeft          'L'//!<Left multiplication
#define SimpleRight         'R'//!<Right multiplication
#define SimpleUpper         'U'//!<Upper triangular matrix
#define SimpleNoTrans       'N'//!<No transpose matrix
#define SimpleNonUnit       'N'//!<Not unit matrix
#define SimpleLower         'L'//!<Lower triangular matrix
#define SimpleUnit          'U'//!<Unit matrix

/*! definitions of the state machine */
#define STATE_PASS          "PASS"    //!<State pass ie successful
#define STATE_FAIL          "FAIL"    //!<State fail ie unsuccessful
#define STATE_WARNING       "WARNING" //!<State warning ie warning

/*! Size of floating point types (in bytes).*/
#define size_of_float          4  //!<Size of a float
#define size_of_double         8  //!<Size of a double
#define size_of_complex        8  //!<Size of a complex
#define size_of_double_complex 16 //!<Size of a double complex

/*! Macro functions */
#define SIMPLE_MAX(a,b) (a > b ? a : b) //!<Macro for MAX(a,b)
#define SIMPLE_MIN(a,b) (a < b ? a : b) //!<Macro for MIN(a,b)
/*! x:0 false 1: true */
#define get_bool(x)(x?"true":"false") //!<Macro for bolean switch

/*! maximum number of GPU */
#define MAX_N_GPU            8 //!<Maximum number of GPUs

/*! the return variables */
#define RC_SUCCESS           0 //!<Overall return code (rc) for SUCCESS
#define RC_FAIL             -1 //!<Overall return code (rc) for FAIL
#define RC_STOP             -3 //!<Overall return code (rc) for STOP
#define RC_WARNING          -4 //!<Overall return code (rc) for WARNING

/*! \brief some color definitons for color output*/
#define ANSI_COLOR_BLACK   "\x1b[30m"
#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_YELLOW  "\x1b[33m"
#define ANSI_COLOR_BLUE    "\x1b[34m"
#define ANSI_COLOR_MAGENTA "\x1b[35m"
#define ANSI_COLOR_CYAN    "\x1b[36m"
#define ANSI_COLOR_WHITE   "\x1b[37m"

#define ANSI_COLOR_BOLD_BLACK   "\x1b[1;30m"
#define ANSI_COLOR_BOLD_RED     "\x1b[1;31m"
#define ANSI_COLOR_BOLD_GREEN   "\x1b[1;32m"
#define ANSI_COLOR_BOLD_YELLOW  "\x1b[1;33m"
#define ANSI_COLOR_BOLD_BLUE    "\x1b[1;34m"
#define ANSI_COLOR_BOLD_MAGENTA "\x1b[1;35m"
#define ANSI_COLOR_BOLD_CYAN    "\x1b[1;36m"
#define ANSI_COLOR_BOLD_WHITE   "\x1b[1;37m"

#define ANSI_COLOR_BRIGHT_BLACK   "\x1b[0;90m"
#define ANSI_COLOR_BRIGHT_RED     "\x1b[0;91m"
#define ANSI_COLOR_BRIGHT_GREEN   "\x1b[0;92m"
#define ANSI_COLOR_BRIGHT_YELLOW  "\x1b[0;93m"
#define ANSI_COLOR_BRIGHT_BLUE    "\x1b[0;94m"
#define ANSI_COLOR_BRIGHT_MAGENTA "\x1b[0;95m"
#define ANSI_COLOR_BRIGHT_CYAN    "\x1b[0;96m"
#define ANSI_COLOR_BRIGHT_WHITE   "\x1b[0;97m"

#define ANSI_COLOR_BOLD_BRIGHT_BLACK   "\x1b[1;90m"
#define ANSI_COLOR_BOLD_BRIGHT_RED     "\x1b[1;91m"
#define ANSI_COLOR_BOLD_BRIGHT_GREEN   "\x1b[1;92m"
#define ANSI_COLOR_BOLD_BRIGHT_YELLOW  "\x1b[1;93m"
#define ANSI_COLOR_BOLD_BRIGHT_BLUE    "\x1b[1;94m"
#define ANSI_COLOR_BOLD_BRIGHT_MAGENTA "\x1b[1;95m"
#define ANSI_COLOR_BOLD_BRIGHT_CYAN    "\x1b[1;96m"
#define ANSI_COLOR_BOLD_BRIGHT_WHITE   "\x1b[1;97m"

#define ANSI_COLOR_RESET               "\x1b[0m"
/*! Shorter than short for colors */
#define C_BLACK   ANSI_COLOR_BLACK
#define C_RED     ANSI_COLOR_RED
#define C_GREEN   ANSI_COLOR_GREEN
#define C_YELLOW  ANSI_COLOR_YELLOW
#define C_BLUE    ANSI_COLOR_BLUE
#define C_MAGENTA ANSI_COLOR_MAGENTA
#define C_CYAN    ANSI_COLOR_CYAN
#define C_WHITE   ANSI_COLOR_WHITE
/*! shorter than short for colors */
#define B_BLACK   ANSI_COLOR_BRIGHT_BLACK
#define B_RED     ANSI_COLOR_BRIGHT_RED
#define B_GREEN   ANSI_COLOR_BRIGHT_GREEN
#define B_YELLOW  ANSI_COLOR_BRIGHT_YELLOW
#define B_BLUE    ANSI_COLOR_BRIGHT_BLUE
#define B_MAGENTA ANSI_COLOR_BRIGHT_MAGENTA
#define B_CYAN    ANSI_COLOR_BRIGHT_CYAN
#define B_WHITE   ANSI_COLOR_BRIGHT_WHITE
/*!Resets all the coloring */
#define COLOR_RESET    ANSI_COLOR_RESET //!<Color reset on ANSI definition
#define C_RESET        ANSI_COLOR_RESET //!<Short hand notation for color reset
/*!Short hand notation for the bold bright ANSI color type definitions */
#define B_B_BLACK   ANSI_COLOR_BOLD_BRIGHT_BLACK
#define B_B_RED     ANSI_COLOR_BOLD_BRIGHT_RED
#define B_B_GREEN   ANSI_COLOR_BOLD_BRIGHT_GREEN
#define B_B_YELLOW  ANSI_COLOR_BOLD_BRIGHT_YELLOW
#define B_B_BLUE    ANSI_COLOR_BOLD_BRIGHT_BLUE
#define B_B_MAGENTA ANSI_COLOR_BOLD_BRIGHT_MAGENTA
#define B_B_CYAN    ANSI_COLOR_BOLD_BRIGHT_CYAN
#define B_B_WHITE   ANSI_COLOR_BOLD_BRIGHT_WHITE

/*! the return variables */
#define RC_SUCCESS           0 //!<Overall return code (rc) for SUCCESS
#define RC_FAIL             -1 //!<Overall return code (rc) for FAIL
#define RC_STOP             -3 //!<Overall return code (rc) for STOP
#define RC_WARNING          -4 //!<Overall return code (rc) for WARNING

/*! definitions of the state machine */
#define STATE_PASS          "PASS"    //!<State pass ie successful
#define STATE_FAIL          "FAIL"    //!<State fail ie unsuccessful
#define STATE_WARNING       "WARNING" //!<State warning ie warning

/*! CUBLAS status type returns */
/** \addtogroup <label>
 *  @{
 */
#define  CUBLAS_STATUS_SUCCESS           0 //!< Completed successfully.
#define  CUBLAS_STATUS_NOT_INITIALIZED   1 //!< cuBLAS library was not initialized. This is usually caused by the lack of a prior cublasCreate() call, an error in the CUDA Runtime API called by the cuBLAS routine, or an error in the hardware setup. To correct: call cublasCreate() prior to the function call; and check that the hardware, an appropriate version of the driver, and the cuBLAS library are correctly installed.
#define  CUBLAS_STATUS_ALLOC_FAILED      3//!< Resource allocation failed inside the cuBLAS library. This is usually caused by a cudaMalloc() failure. To correct: prior to the function call, deallocate previously allocated memory as much as possible.
#define  CUBLAS_STATUS_INVALID_VALUE     7//!<An unsupported value or parameter was passed to the function (a negative vector size, for example). To correct: ensure that all the parameters being passed have valid values. Example: if incx, incy, or elemSize <= 0
#define  CUBLAS_STATUS_ARCH_MISMATCH     8//!<The function requires a feature absent from the device architecture; usually caused by the lack of support for double precision. To correct: compile and run the application on a device with appropriate compute capability, which is 1.3 for double precision.
#define  CUBLAS_STATUS_MAPPING_ERROR     11//!<An access to GPU memory space failed, which is usually caused by a failure to bind a texture. To correct: prior to the function call, unbind any previously bound textures.
#define  CUBLAS_STATUS_EXECUTION_FAILED  13//!<The GPU program failed to execute. This is often caused by a launch failure of the kernel on the GPU, which can be caused by multiple reasons. To correct: check that the hardware, an appropriate version of the driver, and the cuBLAS library are correctly installed.
#define  CUBLAS_STATUS_INTERNAL_ERROR    14//!<An internal cuBLAS operation failed. This error is usually caused by a cudaMemcpyAsync() failure. To correct: check that the hardware, an appropriate version of the driver, and the cuBLAS library are correctly installed. Also, check that the memory passed as a parameter to the routine is not being deallocated prior to the routine’s completion.
#define  CUBLAS_STATUS_NOT_SUPPORTED     15//!<The functionnality requested is not supported
#define  CUBLAS_STATUS_LICENSE_ERROR     16//!<The functionnality requested requires some license and an error was detected when trying to check the current licensing. This error can happen if the license is not present or is expired or if the environment variable NVIDIA_LICENSE_FILE is not set properly.
/** @}*/

/* CURAND status type returns */
/*
#define  CURAND_STATUS_SUCCESS                    0
#define  CURAND_STATUS_VERSION_MISMATCH           100
#define  CURAND_STATUS_NOT_INITIALIZED            101
#define  CURAND_STATUS_ALLOCATION_FAILED          102
#define  CURAND_STATUS_TYPE_ERROR                 103
#define  CURAND_STATUS_OUT_OF_RANGE               104
#define  CURAND_STATUS_LENGTH_NOT_MULTIPLE        105
#define  CURAND_STATUS_DOUBLE_PRECISION_REQUIRED  106
#define  CURAND_STATUS_LAUNCH_FAILURE             201
#define  CURAND_STATUS_PREEXISTING_FAILURE        202
#define  CURAND_STATUS_INITIALIZATION_FAILED      203
#define  CURAND_STATUS_ARCH_MISMATCH              204
#define  CURAND_STATUS_INTERNAL_ERROR             999
*/
/*!\brief Enumerated typedef cufftXtResult coming from cufftResult enumarated
 structure from NVIDIA. The structure is used in the error handling catch
 when the an operation is done on the library. For example cufftXtMalloc is
 called and we pass the key *XtMalloc into the error method
 get_error_id_cufftXt_gpu with the line number __LINE__, __FILE__ and
 __FUNCTION__ C definitions. The method:
 \code
  cufftResult cufftXt_err;
  cufftXt_err = cufftXtMalloc(plan_input, (cudaLibXtDesc **)&d_Xt_in, format);
  if (cufftXt_err != CUFFT_SUCCESS) {
    rc = get_error_id_cufftXt_gpu((cufftXtResult_t)cufftXt_err,"*XtMalloc", __LINE__,__FILE__,__FUNCTION__); }
 \endcode
 then maps the error code to a message and provides the line, file and the
 function where the error has occured. This gives effective debugging
 capabilities.
*/
typedef enum cufftXtResult {
  CUFFTXT_SUCCESS         = 0x0,//!<Completed successfully
  CUFFTXT_INVALID_PLAN    = 0x1,//!<cuFFT was passed an invalid plan handle
  CUFFTXT_ALLOC_FAILED    = 0x2,//!<cuFFT failed to allocate GPU or CPU memory
  CUFFTXT_INVALID_TYPE    = 0x3,//!<No longer used
  CUFFTXT_INVALID_VALUE   = 0x4,//!<User specified invalid pointer or parameter
  CUFFTXT_INTERNAL_ERROR  = 0x5,//!<Driver or internal cuFFT library error
  CUFFTXT_EXEC_FAILED     = 0x6,//!<Failed to execute an FFT on the GPU
  CUFFTXT_SETUP_FAILED    = 0x7,//!<The cuFFT library failed to initialize
  CUFFTXT_INVALID_SIZE    = 0x8,//!<User specified an invalid transform size
  CUFFTXT_UNALIGNED_DATA  = 0x9,//!<No longer used
  CUFFTXT_INCOMPLETE_PARAMETER_LIST = 0xA,//!<Missing parameters in call
  CUFFTXT_INVALID_DEVICE  = 0xB,//!<Execution of a plan was on different GPU than plan creation
  CUFFTXT_PARSE_ERROR     = 0xC,//!<Internal plan database error
  CUFFTXT_NO_WORKSPACE    = 0xD,//!<No workspac provided prior to plan execution
  CUFFTXT_NOT_IMPLEMENTED = 0xE,//!<Function does not implement functionality for parameters given.
  CUFFTXT_LICENSE_ERROR   = 0x0F,//!<Used in previous versions.
  CUFFTXT_NOT_SUPPORTED   = 0x10,//!<Operation is not supported for parameters
  CUFFTXT_MEMCPY_FAILED   = 0x11 //!<Memory copy failed
} cufftXtResult_t;
/*! CUDNN value type mapped to the data structure cudnnDataType passed and the
  template classes
*/
/** \addtogroup <label>
 *  @{
 */
#define  VALUE_TYPE_FLOAT   0//!<CUDNN value type for float
#define  VALUE_TYPE_DOUBLE  1//!<CUDNN value type for double
#define  VALUE_TYPE_HALF    2//!<CUDNN value type for half type
#define  VALUE_TYPE_INT     3//!<CUDNN value type for int
/** @}*/
/*!\brief The typedef struct definitions for the device ptr*/
typedef size_t devptr_t;
/*!\brief
  unit Test data structure for details
  \param launch_unitTest Launches the unit test procedure
 */
typedef struct unitTest {
  int launch_unitTest;
  int launch_unitTest_systemDetails;
  int launch_unitTest_deviceDetails;
  int launch_unitTest_networks;
} unitTest_t;
/*!\brief
  system structure for details
  \param n_phys_proc Number of physical cores usually a factor 1/2 of total
  \param nCPUcores   Number of CPU cores
  \param mem_Size    Memory size #if defined (MACOSX)
  \param mem_User    Memory available #if defined (MACOSX)
  \param mem_Size    Total memory available #elif defined (LINUX)
  \param avail_Mem   Available memory #elif defined (LINUX)
  \param mem_size    Memory size
  \param TODO: update the doc for the data structure systemDetails
 */
typedef struct systemDetails {
  int n_phys_proc;
  int nCPUlogical;
  bool hyper_threads;
  unsigned cpuFeatures;
  char *cpuVendor;
  unsigned short ProcessorArchitecture;
  long long int total_phys_mem;
  long long int avail_phys_mem;
#if defined (MACOSX)
  uint64_t mem_Size;
  int mem_User;
#elif defined (LINUX)

#elif defined (WINDOWS)
  float MemoryLoad_pc;
  long long int TotalPhys_kB;
  long long int AvailPhys_kB;
  long long int TotalPageFile_kB;
  long long int AvailPageFile_kB;
  long long int TotalVirtual_kB;
  long long int AvailVirtual_kB;
  long long int AvailExtendedVirtual_kB;
#else
  int mem_size;
#endif
} systemDetails_t;
/*!\brief best device suitable for multi-gpu computation
  \param nDev         Number of devices
  \param max_perf_dev Device which gives maximum performance on system
  \param *ncuda_cores Total number of cuda cores
 */
typedef struct Devices {
  int nDev;//!<Number of devices
  int max_perf_dev;//!<Device which gives maximum performance on system
  int *ncuda_cores;//!<Total number of cuda cores
} devices_t;
/*!\brief Data structure used to store information about the Device and the
  system, this structure has the following varuables in it:
  \param ndev                     Number of devices
  \param *dev_name                Device name as a character
  \param d_ver                    Device version
  \param d_runver                 Device runnning version
  \param tot_global_mem_MB        Total global memeory available in MB
  \param tot_global_mem_bytes     Total global mem available bytes
  \param nMultiProc               Number of multiprocessors
  \param ncudacores_per_MultiProc Number of cuda cores per MultiProcessors
  \param ncudacores               Total number of cuda cores
  \param is_SMsuitable            Is it SM suitable
  \param nregisters_per_blk       Number of registers per block
  \param warpSze                  Warp size (usually 32)
  \param maxthreads_per_mp        Maximum number of threads per MultiProccessors
  \param maxthreads_per_blk       Maximum number of threads per blocks
  \param is_ecc                   Is Device ECC enabled
  \param is_p2p[MAX_N_GPU][MAX_N_GPU] 2D array for peer-2-peer computing
 */
typedef struct deviceDetails {
  int best_devID;                         //!<Best device for computation
  char *best_devID_name;                  //!<Best device name
  int best_devID_compute_major;           //!<Best device computa ability major
  int best_devID_compute_minor;           //!<Best device computa ability minor
  int ndev;                               //!<Number of devices
  char *dev_name;                         //!<Device name as a character
  float d_ver;                            //!<Device version
  float d_runver;                         //!<Device runnning version
  float tot_global_mem_MB;                //!<Total global memeory available in MB
  unsigned long long tot_global_mem_bytes;//!<Total global mem available bytes
  int nMultiProc;                         //!<Number of multiprocessors
  int ncudacores_per_MultiProc;           //!<Number of cuda cores per MultiProcessors
  int ncudacores;                         //!<Total number of cuda cores
  int is_SMsuitable;                      //!<Is it SM suitable
  int nregisters_per_blk;                 //!<Number of registers per block
  int warpSze;                            //!<Warp size (usually 32)
  int maxthreads_per_mp;                  //!< Maximum number of threads per MultiProccessors
  int maxthreads_per_blk;                 //!<Maximum number of threads per blocks
  int is_ecc;                             //!<Is Device ECC enabled
  int is_p2p[MAX_N_GPU][MAX_N_GPU];       //!<2D array for peer-2-peer computing
} deviceDetails_t;
/*!\brief
 * polarFT structure, takers care of the mesh dimensions. Not used here
 */
typedef struct polar_corr_calc {
  float r_polar;
  float sumasq_polar;
  float sumbsq_polar;
  int ikrnl;
  int threadsPerBlock;
  int nx,ny,nz;
} polar_corr_calc_t;
/*!\brief
 * Projector structure. Not used here
 */
typedef struct projector {
  int vx,vy,vz;
  int phys_x,phys_y,phys_z;
  int logi_x,logi_y,logi_z;
  float vec_x,vec_y,vec_z;
  float loc_x,loc_y,loc_z;
} projector_t;

/*!\brief Debugging structure 0:no 1:yes used to substitute through out.
  \param debug_i           Debug the code a low verbose
  \param debug_cpu_i       Debug the cpu code as well
  \param debug_high_i      Debug with high verbose
  \param debug_write_i     Debug & write to disk (can be very disk intensive)
  \param debug_write_C_i   Debug & write to disk complex matrices
*/
typedef struct debug_gpu {
  int debug_i;         //!<General degug integer switch true
  int debug_cpu_i;     //!<CPU debug integer switch false
  int debug_high_i;    //!<High debug details integer switch true
  int debug_high_s_Devices_i;
  int debug_high_IPAddresses_struct_i;
  int debug_adapters_struct_i;
  int debug_high_adapters_struct_i;
  int debug_high_device_details_i;
  int debug_high_s_resources_avail_i;
  int debug_high_s_systemDetails_i;
  int debug_high_s_network_struct_i;
  int debug_high_s_socket_struct_i;
  int debug_write_i;   //!<Writing to disk debug integer switch false
  int debug_write_C_i; //!<Complex writing to disk debug integer switch false
} debug_gpu_t;



typedef struct machine_struct {
  int nMachine_ipv4;
  int nMachine_macs;
  char *platform;
  char *hostname;
  char *device_name;
  char *machine_name;
  // The arrays
  char **array_machines_ipv4;
  char **array_machines_macs;
  //socket_struct_t my_socket_struct;
  char **array_network_nmap_IPv4;
  char **array_network_nmap_MACs;
} machine_struct_t;


/*!\brief Benchmarking struct used in additions to DBENCH for more precisions
  \param bench_i       bench marking variable switch 0:no 1: yes
  \param bench_write_i bench marking variable switch disk writes 0:no 1: yes
*/
typedef struct bench {
  int bench_i;       //!<bench marking variable switch 0:no 1: yes
  int bench_write_i; //!<bench marking variable switch disk writes 0:no 1: yes
} bench_t;
/*!\brief Data structure for the file_utils and handlers
   \param nnodes           N of nodes wanted to be used
   \param size_socket_logi N of logical cores on each sockets
   \param size_socket_phys N physical cores on each socket
*/
typedef struct resources_avail {
  int nnodes;           //!<N of nodes wanted to be used
  int size_socket_logi; //!<N of logical cores on each sockets
  int size_socket_phys; //!<N physical cores on each socket
}resources_avail_t;

#ifdef __cplusplus
extern "C" {
#endif

  /* /////////////////////////////////////////////////////////////////////////////
     -- Error handlers for the cublas and the curand on GPU
  */
  /*!\brief Error handlers for the cublas \param err error code */
  //int simple_cublas_stat_return_c(int err);
  /*!\brief Error handlers for the curand \param err error code */
  //int simple_curand_stat_return_c(int err);

#if defined (CUDA) /*! CUDA environment */
#endif /*! CUDA */
  /**/
#if defined (CUDA) && defined (MAGMA) /* CUDA and MAGMA environment */

  /* ////////////////////////////////////////////////////////////////////////////
     -- MAGMA function definitions / Data on CPU
  */

  /* ////////////////////////////////////////////////////////////////////////////
     -- MAGMA function definitions / Data on GPU
  */

  /* ////////////////////////////////////////////////////////////////////////////
   -- MAGMA function definitions / Some getters
  */

#endif /* CUDA and MAGMA */

#ifdef __cplusplus
}
#endif

#undef PRECISION_z
#endif //COMMON_CUH
