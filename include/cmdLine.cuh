/*
*   -- SIMPLE addon
 *      Author: Frederic Bonnet, Date: 07th of January 2017
 *                           Modified: 07th of January 2017
 *
 *      January 2017
 *
 *   code for the command line handling
 *
 * @precisions normal z -> s d c
 */
//system headers
#include <cstdlib>
#include <cstdio>
#include <algorithm>
#include <assert.h>
#include <math.h>
#include <string>
#include <sstream>
#include <vector>
#include <iostream>
#include <iterator>
#include <stdio.h>
#include <stdlib.h>
#include <fstream>
#include <string.h>
//incldue application header
#include "common.cuh"

#ifndef CMDLINE_CUH
#define CMDLINE_CUH

//Windows macros
#if defined(WIN32) || defined(_WIN32) || defined(WIN64) || defined(_WIN64)
#ifndef _CRT_SECURE_NO_DEPRECATE
#define _CRT_SECURE_NO_DEPRECATE
#endif
#ifndef STRCASECMP
#define STRCASECMP _stricmp
#endif
#ifndef STRNCASECMP
#define STRNCASECMP _strnicmp
#endif
#ifndef STRCPY
#define STRCPY(sFilePath, nLength, sPath) strcpy_s(sFilePath, nLength, sPath)
#endif

#ifndef FOPEN
#define FOPEN(fHandle, filename, mode) fopen_s(&fHandle, filename, mode)
#endif
#ifndef FOPEN_FAIL
#define FOPEN_FAIL(result) (result != 0)
#endif
#ifndef SSCANF
#define SSCANF sscanf_s
#endif
#ifndef SPRINTF
#define SPRINTF sprintf_s
#endif
#endif
//Linux macros
#ifndef STRNCASECMP
#define STRNCASECMP strncasecmp
#endif

#define TOSTR_(s)   #s
#define TOSTR(s)    TOSTR_(s)
#if defined(__GNUC__)
#define COMPILER_NAME "GCC"
#define COMPILER_VER  TOSTR(__GNUC__) "." TOSTR(__GNUC_MINOR__) "." TOSTR(__GNUC_PATCHLEVEL__)
#elif defined(__clang_major__)
#define COMPILER_NAME "CLANG"
#define COMPILER_VER  TOSTR(__clang_major__ ) "." TOSTR(__clang_minor__) "." TOSTR(__clang_patchlevel__)
#endif

#ifndef STRCPY
#define STRCPY(sFilePath, nLength, sPath) strcpy(sFilePath, sPath)
#endif
#ifndef FOPEN
#define FOPEN(fHandle, filename, mode) (fHandle = fopen(filename, mode))
#endif
/*
#ifndef FOPEN_FAIL
#define FOPEN_FAIL(result) (result != 0)
#endif
*/
///#define STRNCASECMP strncasecmp
#define CUDNN_VERSION_STR  TOSTR(CUDNN_MAJOR) "." TOSTR (CUDNN_MINOR) "." TOSTR(CUDNN_PATCHLEVEL)
//////////////////////////////////////////////////////////////////////////////
// Macros definition for the cuda definition error handling
//////////////////////////////////////////////////////////////////////////////
//#if defined (CUDA) /* prepropressing for the cuda environment */

/* checks the CUDA error and gets the error back as a string */
#define checkCudaErrors(status) {                                        \
    std::stringstream _error;                                            \
    if (status != 0) {                                                   \
      _error << "Cuda failure\nError: " << cudaGetErrorString(status);   \
      FatalError(_error.str());                                          \
    }                                                                    \
}
/* embedded into the CUDA directive, checks the CUDNN error: returns a string */
#define checkCUDNN(status) {                                             \
    std::stringstream _error;                                            \
    if (status != CUDNN_STATUS_SUCCESS) {                                \
      _error << "CUDNN failure\nError: " << cudnnGetErrorString(status); \
      FatalError(_error.str());                                          \
    }                                                                    \
}
/* checks the Cublas error: returns a string */
#define checkCublasErrors(status) {                                      \
    std::stringstream _error;                                            \
    if (status != 0) {                                                   \
      _error << "Cublas failure\nError code " << status;                 \
      FatalError(_error.str());                                          \
    }                                                                    \
}
//#endif /* end of prepropressing for the cuda environment */

#ifdef __cplusplus
extern "C" {
#endif
//////////////////////////////////////////////////////////////////////////////
// Command line helper function for the command line
//////////////////////////////////////////////////////////////////////////////
  int getFileExtension(char *filename, char **extension);
  int checkCmdLineFlag(const int argc, const char **argv,
		       const char *string_ref);
  int stringRemoveDelimiter(char delimiter, const char *string);
  int getCmdLineArgumentInt(const int argc, const char **argv,
			    const char *string_ref);
  float getCmdLineArgumentFloat(const int argc, const char **argv,
				const char *string_ref);
  bool getCmdLineArgumentString(const int argc, const char **argv,
				const char *string_ref,
				char **string_retval);
  char *getCmdLineArgumentStringReturn(const int argc, const char **argv,
				       const char *string_ref);
  char *FindFilePath(const char *filename, const char *executable_path);
//////////////////////////////////////////////////////////////////////////////
//API functions for external calls
//////////////////////////////////////////////////////////////////////////////
  int saxs_getFileExtension(char *filename, char **extension);
  char *saxs_FindFilePath(const char *filename, const char *executable_path);
  int saxs_checkCmdLineFlag(const int argc, const char **argv,
			    const char *string_ref);
  int saxs_stringRemoveDelimiter(char delimiter, const char *string);
  int saxs_getCmdLineArgumentInt(const int argc, const char **argv,
				 const char *string_ref);
  float saxs_getCmdLineArgumentFloat(const int argc, const char **argv,
				     const char *string_ref);
  bool saxs_getCmdLineArgumentString(const int argc, const char **argv,
                                     const char *string_ref,
                                     char **string_retval);
  char *saxs_getCmdLineArgumentStringReturn(const int argc, const char **argv,
					    const char *string_ref);
#ifdef __cplusplus
}
#endif

























#endif //CMDLINE_CUH
