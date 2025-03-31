//
// Created by Frederic on 12/19/2023.
//
#ifndef BENCHER_GRID_HPP
#define BENCHER_GRID_HPP
// External headers
#include <Grid/Grid.h>
// Application headers
#include "common_main_app.hpp"

//////////////////////////////////////////////////////////////////////////////
// Namespace declaration
//////////////////////////////////////////////////////////////////////////////
namespace namespace_Bencher {
    //////////////////////////////////////////////////////////////////////////
    // Class Bencher_Grid_ClassTemplate_t mirrored valued type class definition
    //////////////////////////////////////////////////////////////////////////
    template<typename T, typename S> class Bencher_Grid_ClassTemplate_t {
    private:
        machine_struct *s_mach_o_t;
    public:
        /* constructors */
        explicit Bencher_Grid_ClassTemplate_t();
        explicit Bencher_Grid_ClassTemplate_t(machine_struct *s_machine);
        /* destructors */
        ~Bencher_Grid_ClassTemplate_t();
        /* methods */
        /* runners */
        int run_MobiusSp2f_DWF_t(int argc, char *argv[]);
        /* starters */
        int start_Grid_t(int argc, char *argv[]);
        /* finisher */
        int stop_Grid_t();
        /* Setters */
        int set_machine_struct_t(machine_struct *s_mach);
        /* Getters */
        machine_struct* get_machine_struct_t();
        int hello_t();
        int get_site_SU3_plaquette_t(int argc, char *argv[], std::string file);
        int get_network_map_nmap();
        int get_network_foreachIPs(machine_struct *s_machine);
        int get_network_localIPs(machine_struct *s_machine,
                                 std::string delimiter_string_in);
        /* helper methods */
        std::string trim(const std::string &s);
        std::vector<std::string> split(std::string s, std::string delimiter);
        /* some global variables to the class */
    protected:
        int _initialize_t();
        int _initialize_t(machine_struct *s_machine);
        /* finalizers */
        int _finalize_t();
    }; /* end of Network_ClassTemplate_t mirrored class */
    //////////////////////////////////////////////////////////////////////////
    // Class Bencher_Grid class definition entery points
    //////////////////////////////////////////////////////////////////////////
    class Bencher_Grid {
    private:
        namespace_Bencher::Bencher_Grid_ClassTemplate_t<float, std::string> *p_cBaseBenchGrid_t_o;
        namespace_Bencher::Bencher_Grid_ClassTemplate_t<float, std::string> *p_cOverBenchGrid_t_o;
    public:
        /* constructors */
        Bencher_Grid();
        Bencher_Grid(machine_struct *s_machine);
        /* starters */
        int start_Grid(int argc, char *argv[]);
        /* finisher */
        int stop_Grid();
        /* destructors */
        ~Bencher_Grid();
        /* checkers */
        int hello();
        /* Method */
        int run_MobiusSp2f_DWF(int argc, char *argv[]);
        /* getters */
        int get_site_SU3_plaquette(int argc, char *argv[], std::string file);

    protected:
        int _initialize();
        int _finalize();
    }; /* end of Bencher_Grid class */
    //extern namespace_Bencher::Bencher_Grid_ClassTemplate_t<float, std::string> *p_cBaseBenchGrid_t_o;
    //extern namespace_Bencher::Bencher_Grid_ClassTemplate_t<float, std::string> *p_cOverBenchGrid_t_o;
    ////////////////////////////////////////////////////////////////////////////////
    // Methods that gets interfaced to extern C code for the API and the helper
    ////////////////////////////////////////////////////////////////////////////////
#ifdef __cplusplus
    extern "C" {
#endif

#ifdef __cplusplus
    }
#endif

} /* End of namespace namespace_Bencher */

#endif // BENCHER_GRID_CUH

