//
// Created by Frederic on 12/3/2023.
//

#ifndef EXCEPTION_CUH
#define EXCEPTION_CUH


/* system headers */
#include <exception>
#include <stdexcept>
#include <iostream>
#include <stdlib.h>
#include <sstream>
/* application headers */
#include "common.cuh"
//////////////////////////////////////////////////////////////////////////////
// Macros definition for the cuda definition
//////////////////////////////////////////////////////////////////////////////
//#if defined (CUDA) /* prepropressing for the cuda environment */
/*!*****************************************************************************
 * \brief C++ macro for fatal error message
 * \param s String to throw the error on fatal error on CUDA*/
/* Fatal error macro*/
#define FatalError(s) {                                                \
    std::stringstream _where, _message;                                \
    _where << __FILE__ << ':' << __LINE__;                             \
    _message << std::string(s) + "\n" << __FILE__ << ':' << __LINE__;  \
    std::cerr << _message.str() << "\nAborting...\n";                  \
    cudaDeviceReset();                                                 \
    exit(EXIT_FAILURE);                                                \
}
/*!*****************************************************************************
 *\brief C++ macro for tradditional check for CUDA error, gets the error
 * back as a string
 * \param status status return code from cuda method call */
/* tradditional check for CUDA error, gets the error back as a string */
#define checkCudaErrors(status) {                                      \
    std::stringstream _error;                                          \
    if (status != 0) {                                                 \
      _error << "Cuda failure\nError: " << cudaGetErrorString(status); \
      FatalError(_error.str());                                        \
    }                                                                  \
}
//#else /* not CUDA */
/*!*****************************************************************************
 * \brief C++ macro for fatal error message
 * \param s String to throw the error on fatal error on not CUDA*/
/* Fatal error macro*/
/*
#define FatalError(s) {                                                \
    std::stringstream _where, _message;                                \
    _where <<__FILE__<<":"<< __LINE__;                                 \
    _message << std::string(s) + "\n" << __FILE__ << ':' << __LINE__;  \
    std::cerr << _message.str() << "\nAborting...\n";                  \
    exit(EXIT_FAILURE);                                                \
}
*/
//#endif /* end of prepropressing for the cuda environment */
////////////////////////////////////////////////////////////////////////////////
// Macros: runtime, logic and range
//
////////////////////////////////////////////////////////////////////////////////
// Not used but defined anyway could be used later on
/*!*****************************************************************************
 * \brief C++ macro for Run time exception handler
 * \param msg String to throw the error on*/
/* Exception caused by dynamic program behavior, e.g. file does not exist */
#define RUNTIME_EXCEPTION( msg)						\
  Exception<std::runtime_error>::throw_it( __FILE__, __LINE__, msg)
/*!*****************************************************************************
 * \brief C++ macro for Logic exception handler
 * \param msg String to throw the error on*/
/* Logic exception in program, e.g. an assert failed */
#define LOGIC_EXCEPTION( msg)      \
  Exception<std::logic_error>::throw_it( __FILE__, __LINE__, msg)
/*!*****************************************************************************
 * \brief C++ macro for  Range exception handler
 * \param msg String to throw the error on*/
/* Out of range exception */
#define RANGE_EXCEPTION( msg)      \
  Exception<std::range_error>::throw_it( __FILE__, __LINE__, msg)
/*!*****************************************************************************
 * \brief C++ macro for Invalid argument exception handler
 * \param msg String to throw the error on */
/* invalid argument passed to a method */
#define INVALID_ARGUMENT( msg)						\
  Exception<std::invalid_argument>::throw_it( __FILE__, __LINE__, msg)
/*!*****************************************************************************
 * \brief C++ macro for bad array new length exception handler
 * \param msg String to throw the error on*/
/* invalid argument passed to a method */
#define BAD_ARRAY_NEW_LENGTH( msg) \
  Exception<std::bad_array_new_length>::throw_it( __FILE__, __LINE__, msg)
////////////////////////////////////////////////////////////////////////////////
// Constructor which extends the Exception class from exception.h
//
////////////////////////////////////////////////////////////////////////////////
/*!*****************************************************************************
 * \brief C++ class for throwing the exception and extends std::exception */
/* Exception definition class */
template<class Std_Exception>class Exception : public Std_Exception {
 public:
  static int throw_it(const char *file, const int line,
		      const char *detailed = "-");
  static int throw_it(const char *file, const int line,
		      const std::string &detailed);
  /* virtual destructor and thrower */
  virtual ~Exception() throw();
private:
  Exception();
  Exception(const std::string &str);
};
////////////////////////////////////////////////////////////////////////////////
// Exception handler function for arbitrary exceptions
//
////////////////////////////////////////////////////////////////////////////////
/*!*****************************************************************************
 * \brief C++ class for handling the exception
 * \param ex   Exception
 */
/* Exception definition class */
template<class Exception_Typ>
inline int handleException(const Exception_Typ &ex) {
  //int rc = RC_SUCCESS;
  std::cerr<<ex.what()<<std::endl;
  exit(RC_FAIL);
  return RC_FAIL;
} /* end handleException class */
////////////////////////////////////////////////////////////////////////////////
// Implementation of the polymorphic class
//
////////////////////////////////////////////////////////////////////////////////
/*!*****************************************************************************
 * \brief C++ constructor for throwing exception
 * \param *file       File
 * \param line        Line
 * \param detailed    Detail message
 */
/* throw the exception */
template<class Std_Exception>
int Exception<Std_Exception>::throw_it(const char *file, const int line,
				       const char *detailed) {
  //int rc = RC_SUCCESS;
  std::stringstream s;
  s << B_YELLOW<<" Exception in file "
    << B_GREEN << file
    << B_YELLOW<<" at line "<< line << std::endl
    << B_BLUE  <<" Detailed description: "
    << B_RED   << detailed
    << C_RESET<<std::endl;
  throw Exception(s.str());
  //return rc;
} /* end overloaded throw_it method */
/*!*****************************************************************************
 * \brief C++ overloaded method for throwing exception
 * \param *file       File
 * \param line        Line
 * \param msg         Detail message
 */
/* overloaded method to throw the exception */
template<class Std_Exception>
int Exception<Std_Exception>::throw_it(const char *file, const int line,
				       const std::string &msg) {
  int rc = RC_SUCCESS;
  throw_it(file, line, msg.c_str());
  return rc;
} /* end overloaded throw_it method */
////////////////////////////////////////////////////////////////////////////////
// Constructor dafault and returned by what() (private)
//
////////////////////////////////////////////////////////////////////////////////
/*!*****************************************************************************
 * \brief C++ default constructor for Exception class
 */
/* contructor */
template<class Std_Exception>
Exception<Std_Exception>::Exception():Std_Exception("Unknow Exception.\n"){}
/*!***************************************************************************
 * \brief C++ overloaded constructor for Exception. String return by what()
 * \param s    String to throw
 */
/* overloaded constructor */
template<class Std_Exception>
Exception<Std_Exception>::Exception(const std::string &s):Std_Exception(s){}
////////////////////////////////////////////////////////////////////////////////
// Destructor
//
////////////////////////////////////////////////////////////////////////////////
/*!*****************************************************************************
 * \brief C++ virtual destructor
 */
/* virtual destructor */
template<class Std_Exception>
Exception<Std_Exception>::~Exception() throw(){}

#endif //EXCEPTION_CUH
