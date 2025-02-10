/*******************************************************************************
* SIMPLE StopWatch handler for the saxs and other parts of the library        *
 *******************************************************************************
 *
 *   -- SIMPLE addon
 *      Author: Frederic Bonnet, Date: 14th January 2017
 *      Monash University
 *      January 2017
 *
 *      command line handler
 *
 * @precisions normal z -> s d c
 *
 */
#include <stdio.h>
// Application specific
#include "../include/cmdLine.cuh"

#ifdef __cplusplus
extern "C" {
#endif

//////////////////////////////////////////////////////////////////////////////
//checks the command line flags
//////////////////////////////////////////////////////////////////////////////
  int checkCmdLineFlag(const int argc, const char **argv,
		       const char *string_ref) {
    bool bFound = false;
    if (argc >= 1) {
      for (int i=1; i < argc; i++) {
	int string_start = stringRemoveDelimiter('-', argv[i]);
	const char *string_argv = &argv[i][string_start];
	const char *equal_pos = strchr(string_argv, '=');
	int argv_length = (int)(equal_pos == 0 ? strlen(string_argv) :
				equal_pos - string_argv);
	int length = (int)strlen(string_ref);
	if (length == argv_length &&
	    !STRNCASECMP(string_argv, string_ref, length)) {
	  bFound = true;
	  continue;
	}
      }
    }
    return (int)bFound;
  } /* end of checkCmdLineFlag method */
//////////////////////////////////////////////////////////////////////////////
//Removes string delimiter
//////////////////////////////////////////////////////////////////////////////
  int stringRemoveDelimiter(char delimiter, const char *string) {
    int string_start = 0;
    while (string[string_start] == delimiter) {
      string_start++;
    }

    if (string_start >= (int)strlen(string)-1) {
      return 0;
    }
    return string_start;
  } /* end of stringRemoveDelimiter method */
//////////////////////////////////////////////////////////////////////////////
//Removes string delimiter
//////////////////////////////////////////////////////////////////////////////
int getFileExtension(char *filename, char **extension) {
  int string_length = static_cast<int>(strlen(filename));

  while (filename[string_length--] != '.') {
    if (string_length == 0) break;
  }

  if (string_length > 0) string_length += 2;

  if (string_length == 0)
    *extension = NULL;
  else
    *extension = &filename[string_length];

  return string_length;
} /* end of getFileExtension */
//////////////////////////////////////////////////////////////////////////////
//Get the command line argument as an integer
//////////////////////////////////////////////////////////////////////////////
  int getCmdLineArgumentInt(const int argc, const char **argv,
			    const char *string_ref) {
    bool bFound = false;
    int value = -1;

    if (argc >= 1) {
      for (int i=1; i < argc; i++) {
	int string_start = stringRemoveDelimiter('-', argv[i]);
	const char *string_argv = &argv[i][string_start];
	int length = (int)strlen(string_ref);

	if (!STRNCASECMP(string_argv, string_ref, length)) {
	  if (length+1 <= (int)strlen(string_argv)) {
	    int auto_inc = (string_argv[length] == '=') ? 1 : 0;
	    value = atoi(&string_argv[length + auto_inc]);
	  } else {
	    value = 0;
	  }
	  bFound = true;
	  continue;
	}
      }
    }

    if (bFound) {
      return value;
    } else {
      return 0;
    }
  } /* end of getCmdLineArgumentInt method */
//////////////////////////////////////////////////////////////////////////////
//Get the command line argument as a float
//////////////////////////////////////////////////////////////////////////////
  float getCmdLineArgumentFloat(const int argc, const char **argv,
				const char *string_ref) {
    bool bFound = false;
    float value = -1;

    if (argc >= 1) {
      for (int i=1; i < argc; i++) {
	int string_start = stringRemoveDelimiter('-', argv[i]);
	const char *string_argv = &argv[i][string_start];
	int length = (int)strlen(string_ref);

	if (!STRNCASECMP(string_argv, string_ref, length)) {
	  if (length+1 <= (int)strlen(string_argv)) {
	    int auto_inc = (string_argv[length] == '=') ? 1 : 0;
	    value = (float)atof(&string_argv[length + auto_inc]);
	  } else {
	    value = 0.f;
	  }
	  bFound = true;
	  continue;
	}
      }
    }

    if (bFound) {
      return value;
    } else {
      return 0;
    }
  } /* end of getCmdLineArgumentFloat method */
//////////////////////////////////////////////////////////////////////////////
//Get the command line argument as a string
//////////////////////////////////////////////////////////////////////////////
  bool getCmdLineArgumentString(const int argc, const char **argv,
				const char *string_ref,
				char **string_retval) {
    bool bFound = false;

    if (argc >= 1) {
      for (int i = 1; i < argc; i++) {
	int string_start = stringRemoveDelimiter('-', argv[i]);
	char *string_argv = const_cast<char*>(&argv[i][string_start]);
	int length = static_cast<int>(strlen(string_ref));

	if (!STRNCASECMP(string_argv, string_ref, length)) {
	  *string_retval = &string_argv[length + 1];
	  bFound = true;
	  continue;
	}
      }
    }

    if (!bFound) { *string_retval = NULL; }

    return bFound;
  } /* end of getCmdLineArgumentString */
  //TODO: need to check the return statement because it gives a seg fault
  char *getCmdLineArgumentStringReturn(const int argc, const char **argv,
				       const char *string_ref) {
    char **string_retval;
    bool bFound = false;

    if (argc >= 1) {
      for (int i = 1; i < argc; i++) {
	int string_start = stringRemoveDelimiter('-', argv[i]);
	char *string_argv = const_cast<char*>(&argv[i][string_start]);
	int length = static_cast<int>(strlen(string_ref));

	//std::cerr<<" *string_argv   : "<<  string_argv  << std::endl;

	if (!STRNCASECMP(string_argv, string_ref, length)) {
	  *string_retval = &string_argv[length + 1];
	  bFound = true;
	  continue;
	}
      }
    }

    if (!bFound) { *string_retval = NULL; }

    return *string_retval;

  } /* end of getCmdLineArgumentStringReturn */
//////////////////////////////////////////////////////////////////////////////
//! Find the path for a file assuming that
//! files are found in the searchPath.
//!
//! @return the path if succeeded, otherwise 0
//! @param filename         name of the file
//! @param executable_path  optional absolute path of the executable
//////////////////////////////////////////////////////////////////////////////
char *FindFilePath(const char *filename,
                             const char *executable_path) {
  // <executable_name> defines a variable that is replaced with the name of the
  // executable

  // Typical relative search paths to locate needed companion files (e.g. sample
  // input data, or JIT source files) The origin for the relative search may be
  // the .exe file, a .bat file launching an .exe, a browser .exe launching the
  // .exe or .bat, etc
  const char *searchPath[] = {
      "./",                             // same dir
      "./<executable_name>_data_files/",
      "./common/",                      // "/common/" subdir
      "./common/data/",                 // "/common/data/" subdir
      "./data/",                        // "/data/" subdir
      "./src/",                         // "/src/" subdir
      "./src/<executable_name>/data/",  // "/src/<executable_name>/data/" subdir
      "./inc/",                         // "/inc/" subdir
  };

  // Extract the executable name
  std::string executable_name;

  if (executable_path != 0) {
    executable_name = std::string(executable_path);

#if defined(WIN32) || defined(_WIN32) || defined(WIN64) || defined(_WIN64)
    // Windows path delimiter
    size_t delimiter_pos = executable_name.find_last_of('\\');
    executable_name.erase(0, delimiter_pos + 1);

    if (executable_name.rfind(".exe") != std::string::npos) {
      // we strip .exe, only if the .exe is found
      executable_name.resize(executable_name.size() - 4);
    }

#else
    // Linux & OSX path delimiter
    size_t delimiter_pos = executable_name.find_last_of('/');
    executable_name.erase(0, delimiter_pos + 1);
#endif
  }

  // Loop over all search paths and return the first hit
  for (unsigned int i = 0; i < sizeof(searchPath) / sizeof(char *); ++i) {
    std::string path(searchPath[i]);
    size_t executable_name_pos = path.find("<executable_name>");

    // If there is executable_name variable in the searchPath
    // replace it with the value
    if (executable_name_pos != std::string::npos) {
      if (executable_path != 0) {
        path.replace(executable_name_pos, strlen("<executable_name>"),
                     executable_name);
      } else {
        // Skip this path entry if no executable argument is given
        continue;
      }
    }

#ifdef _DEBUG
    printf("FindFilePath <%s> in %s\n", filename, path.c_str());
#endif

    // Test if the file exists
    path.append(filename);
    FILE *fp;
    FOPEN(fp, path.c_str(), "rb");

    if (fp != NULL) {
      fclose(fp);
      // File found
      // returning an allocated array here for backwards compatibility reasons
      char *file_path = reinterpret_cast<char *>(malloc(path.length() + 1));
      STRCPY(file_path, path.length() + 1, path.c_str());
      return file_path;
    }

    if (fp) {
      fclose(fp);
    }
  }

  // File not found
  return 0;
} /* end of FindFilePath */
//////////////////////////////////////////////////////////////////////////////
//API functions for external calls
//////////////////////////////////////////////////////////////////////////////
  int saxs_checkCmdLineFlag(const int argc, const char **argv,
			    const char *string_ref) {
    return checkCmdLineFlag(argc, argv, string_ref);
  }
  int saxs_stringRemoveDelimiter(char delimiter, const char *string) {
    return stringRemoveDelimiter(delimiter, string);
  }
  int saxs_getCmdLineArgumentInt(const int argc, const char **argv,
				 const char *string_ref) {
    return getCmdLineArgumentInt(argc, argv, string_ref);
  }
  float saxs_getCmdLineArgumentFloat(const int argc, const char **argv,
				     const char *string_ref) {
    return getCmdLineArgumentFloat(argc, argv, string_ref);
  }
  bool saxs_getCmdLineArgumentString(const int argc, const char **argv,
                                     const char *string_ref,
                                     char **string_retval) {
    return getCmdLineArgumentString(argc, argv, string_ref, string_retval);
  }
  char *saxs_getCmdLineArgumentStringReturn(const int argc, const char **argv,
					    const char *string_ref){
    return getCmdLineArgumentStringReturn(argc, argv,string_ref);
  }
  char *saxs_FindFilePath(const char *filename, const char *executable_path) {
    return FindFilePath(filename, executable_path);
  }
  int saxs_getFileExtension(char *filename, char **extension) {
    return getFileExtension(filename, extension);
  }
  /* the aliases for external access */
#if defined (LINUX)
  extern "C" int saxs_getFileExtension_() __attribute__((weak,alias("saxs_getFileExtension")));
  extern "C" int saxs_checkCmdLineFlag_() __attribute__((weak,alias("saxs_checkCmdLineFlag")));
  extern "C" int saxs_stringRemoveDelimiter_() __attribute__((weak,alias("saxs_stringRemoveDelimiter")));
  extern "C" int saxs_getCmdLineArgumentInt_() __attribute__((weak,alias("saxs_getCmdLineArgumentInt")));
  extern "C" float saxs_getCmdLineArgumentFloat_() __attribute__((weak,alias("saxs_getCmdLineArgumentFloat")));
  extern "C" bool saxs_getCmdLineArgumentString_() __attribute__((weak,alias("saxs_getCmdLineArgumentString")));
  extern "C" char *saxs_FindFilePath_() __attribute__((weak,alias("saxs_FindFilePath")));
#endif

#ifdef __cplusplus
}
#endif


