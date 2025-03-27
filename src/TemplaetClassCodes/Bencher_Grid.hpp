//
// Created by Frederic on 12/19/2023.
//
#ifndef BENCHER_GRID_HPP
#define BENCHER_GRID_HPP
//#include "../global.cuh"
#include "common_main_app.hpp"
namespace namespace_Bencher {

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
        /* Setters */
        int set_machine_struct(machine_struct *s_mach);
        /* Getters */
        machine_struct* get_machine_struct();

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

    class Bencher_Grid {
        private:
        namespace_Bencher::Bencher_Grid_ClassTemplate_t<float, std::string> *cOverBenchGrid_t_o;
        namespace_Bencher::Bencher_Grid_ClassTemplate_t<float, std::string> *cBaseBenchGrid_t_o;
        public:
        /* constructors */
        Bencher_Grid();
        Bencher_Grid(machine_struct *s_machine);
        /* destructors */
        ~Bencher_Grid();
        /* checkers */
        int hello();
        protected:
        int _initialize();
        int _finalize();
    }; /* end of Bencher_Grid class */
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

#endif //BENCHER_GRID_CUH

