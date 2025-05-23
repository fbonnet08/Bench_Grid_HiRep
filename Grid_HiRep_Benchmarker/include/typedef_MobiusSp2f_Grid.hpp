//
// Created by Frederic Bonnet on 3/27/2025.
//
#ifndef BENCH_GRID_HIREP_TYPEDEF_MOBIUSSP2F_GRID_HPP
#define BENCH_GRID_HIREP_TYPEDEF_MOBIUSSP2F_GRID_HPP

// External headers
// Application headers
#include "Bencher_Grid.hpp"
//////////////////////////////////////////////////////////////////////////////
// Namespace declaration
//////////////////////////////////////////////////////////////////////////////
namespace namespace_Bencher {
    //////////////////////////////////////////////////////////////////////////
    // Typedef declaration for the
    //////////////////////////////////////////////////////////////////////////

    struct hmc_params {
        int save_freq;
        int starttraj;
        double beta;
        double m;
        double tlen;
        int nsteps;
        std::string serial_seed = "1 2 3 4 5";
        std::string parallel_seed = "6 7 8 9 10";
        int Ls = 8;
        double M5 = 1.8; // domain wall height
        double b = 1.5; // controls exactly what action is being used
        double c = 0.5; // b-c=1.0 (fixed?); alpha=b+c=1 is Shamir (see e.g. 1411.7017)
        std::string cnfg_dir = ".";
    } hmc_params_t;
    // Parameter method for grid
    hmc_params ReadCommandLineHMC(int argc, char** argv);
    // Type definition declaration for the Mobius DWF runs S
    /*
     * The instantiations are generated by
     * Grid/qcd/action/fermion/instantiation/generate_instantiations.sh.
     * Niccolò added addition implementations to the list to generate for DWF.
     * There are additionally typedefs in Fermion.h and WilsonImpl.h`
     * that are probably needed.
     *
     * look at https://github.com/telos-collaboration/Grid/pull/1/files
     * if you want a complete listing; the only part you definitely don't need
     * is the Test_Sp_fft.cc file.
     *
     * Compulsory input parameters: --savefreq 2 --beta 2.13 --starttraj 0 --fermionmass 0.01 --tlen --nsteps 1
     * Optional input parameters  : --dw_mass --mobius_b --mobius_c --Ls --cnfg_dir
     */


    /* [Printers] */
    int print_hmc_params_data_structure(namespace_Bencher::hmc_params s_hmc_params);




//////////////////////////////////////////////////////////////////////////////
// Methods that gets interfaced to extern C code for the API and the helper
//////////////////////////////////////////////////////////////////////////////
#ifdef __cplusplus
    extern "C" {
#endif

#ifdef __cplusplus
    }
#endif

} /* End of namespace namespace_Bencher */


#endif //BENCH_GRID_HIREP_TYPEDEF_MOBIUSSP2F_GRID_HPP
