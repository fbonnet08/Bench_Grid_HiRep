//
// Created by Frederic on 12/19/2023.
//
// System headers
//Application headers
#include "../include/global_app.hpp"
#include "../include/Bencher_Grid.hpp"
#include "../include/Exception_app.hpp"

#if defined (WINDOWS)
#elif defined (LINUX)
//TODO: insert the headers here for the Linux environment
#endif
//////////////////////////////////////////////////////////////////////////////
// Namespace delaration
//////////////////////////////////////////////////////////////////////////////
namespace namespace_Bencher {
    ////////////////////////////////////////////////////////////////////////////////
    // Class Bencher_Grid_ClassTemplate_t mirrored valued type class definition
    ////////////////////////////////////////////////////////////////////////////////
    /*
    *
    ********************************************************************************
    */
    ////////////////////////////////////////////////////////////////////////////////
    /// [Constructors] Template class constructors
    ////////////////////////////////////////////////////////////////////////////////
    /* constructors Bencher_Grid_ClassTemplate_t<T,S>::Bencher_Grid_ClassTemplate_t */
    template <typename T, typename S>
    Bencher_Grid_ClassTemplate_t<T,S>::Bencher_Grid_ClassTemplate_t() {}
    template <typename T, typename S>
    Bencher_Grid_ClassTemplate_t<T,S>::Bencher_Grid_ClassTemplate_t(machine_struct *s_machine) {
        int rc = RC_SUCCESS;
        rc = _initialize_t(s_machine); if (rc != RC_SUCCESS){rc = RC_FAIL;}
    } /* end of Bencher_Grid_ClassTemplate_t(machine_struct *s_machine) constructor */
    ////////////////////////////////////////////////////////////////////////////////
    /// [Initializers] Template class constructors
    ////////////////////////////////////////////////////////////////////////////////
    template <typename T, typename S>
    int Bencher_Grid_ClassTemplate_t<T,S>::_initialize_t() {return RC_SUCCESS;}
    /* end of Bencher_Grid_ClassTemplate_t<T,S>::_initialize_t() method */
    template <typename T, typename S>
    int Bencher_Grid_ClassTemplate_t<T,S>::_initialize_t(machine_struct *s_machine) {
        int rc = RC_SUCCESS;
        std::cerr<<B_RED"return code: "<<rc
        <<" line: "<<__LINE__<<" function: "<<__func__<<C_RESET<<std::endl;
        //rc = get_network_foreachIPs(s_machine); ; if (rc != RC_SUCCESS) {rc = RC_FAIL;}
        rc = set_machine_struct(s_machine);
        return rc;
    } /* end of Bencher_Grid_ClassTemplate_t<T,S>::_initialize_t(machine_struct *s_machine) method */
    ////////////////////////////////////////////////////////////////////////////////
    /// [Finalizers] Template class constructors
    ////////////////////////////////////////////////////////////////////////////////
    template <typename T, typename S>
    int Bencher_Grid_ClassTemplate_t<T,S>::_finalize_t() {int rc = RC_SUCCESS; return rc;}
    ////////////////////////////////////////////////////////////////////////////////
    /// [Setters] Template class getters
    ////////////////////////////////////////////////////////////////////////////////
    template <typename T, typename S> int
    Bencher_Grid_ClassTemplate_t<T,S>::set_machine_struct(machine_struct *s_mach) {
        int rc = RC_SUCCESS;
        s_mach_o_t = s_mach;
        return rc;
    } /* end of set_machine_struct method */
    ////////////////////////////////////////////////////////////////////////////////
    /// [Getters] Template class getters
    ////////////////////////////////////////////////////////////////////////////////
    template <typename T, typename S> machine_struct*
    Bencher_Grid_ClassTemplate_t<T,S>::get_machine_struct() {
        return s_mach_o_t;
    } /* end of get_machine_struct method */

    template <typename T, typename S> int
    Bencher_Grid_ClassTemplate_t<T,S>::get_network_localIPs(machine_struct *s_mach, std::string delimiter_string_in) {
        int rc = RC_SUCCESS;
        std::cerr<<B_RED"return code: "<<rc
        <<" line: "<<__LINE__<<" function: "<<__func__<<C_RESET<<std::endl;
        return rc;
    } /* end of get_network_localIPs method */

    template <typename T, typename S> int
    Bencher_Grid_ClassTemplate_t<T,S>::get_network_foreachIPs(machine_struct *s_mach) {
        int rc = RC_SUCCESS;
        std::cerr<<B_RED"return code: "<<rc
        <<" line: "<<__LINE__<<" function: "<<__func__<<C_RESET<<std::endl;
        return rc;
    } /* end of get_network_foreachIPs method */
    ////////////////////////////////////////////////////////////////////////////////
    /// Helper methods
    ////////////////////////////////////////////////////////////////////////////////
    // for string delimiter
    template <typename T, typename S>
    std::vector<std::string> Bencher_Grid_ClassTemplate_t<T,S>::split(std::string s, std::string delimiter) {
        size_t pos_start = 0, pos_end, delim_len = delimiter.length();
        std::string token;
        std::vector<std::string> res;

        while ((pos_end = s.find(delimiter, pos_start)) != std::string::npos) {
            token = s.substr (pos_start, pos_end - pos_start);
            pos_start = pos_end + delim_len;
            res.push_back (token);
        }
        res.push_back (s.substr (pos_start));
        return res;
    } /* end of split method */
    template <typename T, typename S>
    std::string Bencher_Grid_ClassTemplate_t<T,S>::trim(const std::string &s) {
      auto start = s.begin();
      while (start != s.end() && std::isspace(*start)) {start++;}
      auto end = s.end();
      do {end--;} while (std::distance(start, end) > 0 && std::isspace(*end));
      return std::string(start, end + 1);
  } /* end trim method */
    ////////////////////////////////////////////////////////////////////////////////
    /// Template class destructors
    ////////////////////////////////////////////////////////////////////////////////
    /* destructor Bencher_Grid_ClassTemplate_t<T,S>::Bencher_Grid_ClassTemplate_t */
    template <typename T, typename S> Bencher_Grid_ClassTemplate_t<T,S>::~Bencher_Grid_ClassTemplate_t() {}
    ////////////////////////////////////////////////////////////////////////////////
    // Class Bencher_Grid constructors overloaded methods
    ////////////////////////////////////////////////////////////////////////////////
    Bencher_Grid::Bencher_Grid() {
        int rc = RC_SUCCESS;
        *cBaseBenchGrid_t_o = new namespace_Bencher::Bencher_Grid_ClassTemplate_t<float, std::string>();
        rc = _initialize();
        std::cout
                <<B_YELLOW<<"Class Bencher_Grid::Bencher_Grid has been instantiated, return code: "
                <<B_GREEN<<rc<<COLOR_RESET<<std::endl;
    } /* end of Bencher_Grid::Bencher_Grid() constructor */
    Bencher_Grid::Bencher_Grid(machine_struct *s_machine) {
        int rc = RC_SUCCESS;
        *cOverBenchGrid_t_o = new namespace_Bencher::Bencher_Grid_ClassTemplate_t<float, std::string>(s_machine);
        rc = _initialize();
        std::cout<<B_CYAN
        <<"Class Bencher_Grid::Bencher_Grid(machine_struct *s_machine)"
        <<" has been instantiated,"
        <<" return code: "<<B_GREEN<<rc<<COLOR_RESET<<std::endl;
    } /* end of Bencher_Grid::Bencher_Grid(machine_struct *s_machine) constructor */
    ////////////////////////////////////////////////////////////////////////////////
    /// [Starters] Class starters
    ////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////
    ///  Class starters
    ////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////
    /// Class checkers
    ////////////////////////////////////////////////////////////////////////////////
    int Bencher_Grid::hello() {
        int rc = RC_SUCCESS;
        std::cerr<<B_RED"return code: "<<rc<<" line: "<<__LINE__
        <<" function: "<<__func__<<C_RESET<<std::endl;
        return rc;
    } /* end of hello checker method */
    ////////////////////////////////////////////////////////////////////////////////
    // Initialiser
    ////////////////////////////////////////////////////////////////////////////////
    int Bencher_Grid::_initialize() {
        int rc = RC_SUCCESS;

        std::cerr<<B_RED"return code: "<<rc
        <<" line: "<<__LINE__<<" function: "<<__func__<<C_RESET<<std::endl;

        return rc;
    } /* end of _initialize method */
    ////////////////////////////////////////////////////////////////////////////////
    // [Finilazers] deallocate the arrays and cleans up the environment
    ////////////////////////////////////////////////////////////////////////////////
    int Bencher_Grid::_finalize() {
        int rc = RC_SUCCESS;
        try{
            //TODO: need to free m_tinfo calloc
        } /* end of try */
        catch(Exception<std::invalid_argument> &e){std::cerr<<e.what()<<std::endl;}
        catch(...){
            std::cerr<<B_YELLOW<<"Program error! Unknown type of exception occured."<<std::endl;
            std::cerr<<B_RED"Aborting."<<std::endl;
            rc = RC_FAIL;
            return rc;
        }
        return rc;
    } /* end of _finalize method */
    ////////////////////////////////////////////////////////////////////////////////
    //Destructor
    ////////////////////////////////////////////////////////////////////////////////
    Bencher_Grid::~Bencher_Grid() {
        int rc = RC_SUCCESS;
        //finalising the the method and remmmoving all of of the alocated arrays
        rc = _finalize();
        if (rc != RC_SUCCESS) {
            std::cerr<<B_RED"return code: "<<rc
            <<" line: "<<__LINE__<<" file: "<<__FILE__<<C_RESET<<std::endl;
            exit(rc);
        } else {rc = RC_SUCCESS; /*print_destructor_message("Bencher_Grid");*/}
        rc = get_returnCode(rc, "Bencher_Grid", 0);
    } /* end of ~Bencher_Grid method */
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
  ////////////////////////////////////////////////////////////////////////////////
} /* End of namespace namespace_Bencher */
////////////////////////////////////////////////////////////////////////////////

