//
// Created by Frederic on 12/19/2023.
//
// System headers
//Application headers
#include <Grid/Grid.h>

#include "../include/global_app.hpp"
#include "../include/Exception_app.hpp"
// Application headers for Bencher
#include "../include/Bencher_Grid.hpp"
#include "../include/typedef_MobiusSp2f_Grid.hpp"
#include "../include/common_Helpr_cpu.hpp"

#if defined (WINDOWS)
#elif defined (LINUX)
//TODO: insert the headers here for the Linux environment
#endif
//////////////////////////////////////////////////////////////////////////////
// Namespace declaration
//////////////////////////////////////////////////////////////////////////////
namespace namespace_Bencher {
    ////////////////////////////////////////////////////////////////////////////////
    // Class Bencher_Grid_ClassTemplate_t mirrored valued type class definition
    ////////////////////////////////////////////////////////////////////////////////
    /*
    *
    ********************************************************************************
    * struct hmc_params defined in "../include/typedef_MobiusSp2f_Grid.hpp"
    */
    // Header definition is in "../include/typedef_MobiusSp2f_Grid.hpp"
    hmc_params ReadCommandLineHMC(int argc, char** argv) {
        hmc_params HMCParams;
        if (Grid::GridCmdOptionExists(argv, argv + argc, "--savefreq")) {
            HMCParams.save_freq = std::stoi(Grid::GridCmdOptionPayload(argv, argv + argc, "--savefreq"));
        } else { std::cout << Grid::GridLogError << "--savefreq must be specified" << std::endl; exit(1);  }

        if (Grid::GridCmdOptionExists(argv, argv + argc, "--beta")) {
            HMCParams.beta = std::stod(Grid::GridCmdOptionPayload(argv, argv + argc, "--beta"));
        } else { std::cout << Grid::GridLogError << "--beta must be specified" << std::endl; exit(1);}

        if (Grid::GridCmdOptionExists(argv, argv + argc, "--starttraj")) {
            HMCParams.starttraj = std::stod(Grid::GridCmdOptionPayload(argv, argv + argc, "--starttraj"));
        } else {std::cout << Grid::GridLogError << "--starttraj must be specified" << std::endl; exit(1);}

        if (Grid::GridCmdOptionExists(argv, argv + argc, "--fermionmass")) {
            HMCParams.m = std::stod(Grid::GridCmdOptionPayload(argv, argv + argc, "--fermionmass"));
        } else {std::cout << Grid::GridLogError << "--fermionmass must be specified" << std::endl; exit(1);}

        if (Grid::GridCmdOptionExists(argv, argv + argc, "--tlen")) {
            HMCParams.tlen = std::stod(Grid::GridCmdOptionPayload(argv, argv + argc, "--tlen"));
        } else { std::cout << Grid::GridLogError << "--tlen must be specified" << std::endl; exit(1); }

        if (Grid::GridCmdOptionExists(argv, argv + argc, "--nsteps")) {
            HMCParams.nsteps = std::stoi(Grid::GridCmdOptionPayload(argv, argv + argc, "--nsteps"));
        } else {std::cout << Grid::GridLogError << "--nsteps must be specified" << std::endl; exit(1);}

        if (Grid::GridCmdOptionExists(argv, argv + argc, "--serialseed")) {
            HMCParams.serial_seed = Grid::GridCmdOptionPayload(argv, argv + argc, "--serialseed");
        }

        if (Grid::GridCmdOptionExists(argv, argv + argc, "--parallelseed")) {
            HMCParams.parallel_seed = Grid::GridCmdOptionPayload(argv, argv + argc, "--parallelseed");
        }

        if (Grid::GridCmdOptionExists(argv, argv + argc, "--dw_mass")) {
            HMCParams.M5 = std::stod(Grid::GridCmdOptionPayload(argv, argv + argc, "--dw_mass"));
        }

        if (Grid::GridCmdOptionExists(argv, argv + argc, "--mobius_b")) {
            HMCParams.b = std::stod(Grid::GridCmdOptionPayload(argv, argv + argc, "--mobius_b"));
        }

        if (Grid::GridCmdOptionExists(argv, argv + argc, "--mobius_c")) {
            HMCParams.c = std::stod(Grid::GridCmdOptionPayload(argv, argv + argc, "--mobius_c"));
        }

        if (Grid::GridCmdOptionExists(argv, argv + argc, "--Ls")) {
            HMCParams.Ls = std::stoi(Grid::GridCmdOptionPayload(argv, argv + argc, "--Ls"));
        }

        if (Grid::GridCmdOptionExists(argv, argv + argc, "--cnfg_dir")) {
            HMCParams.cnfg_dir = Grid::GridCmdOptionPayload(argv, argv + argc, "--cnfg_dir");
        }

        return HMCParams;
    }
    //////////////////////////////////////////////////////////////////////////
// [Printers]
//////////////////////////////////////////////////////////////////////////
    int print_hmc_params_data_structure(namespace_Bencher::hmc_params s_hmc_params) {
        int rc = RC_SUCCESS;
        std::cout<<B_BLUE<<"*------- Machine struct ---------------*"<<std::endl;
        std::cout<<B_BLUE<<"s_hmc_params.save_freq             ---> "<<B_YELLOW<<s_hmc_params.save_freq<<std::endl;
        std::cout<<B_BLUE<<"s_hmc_params.starttraj             ---> "<<B_YELLOW<<s_hmc_params.starttraj<<std::endl;
        std::cout<<B_BLUE<<"s_hmc_params.beta                  ---> "<<B_YELLOW<<s_hmc_params.beta<<std::endl;
        std::cout<<B_BLUE<<"s_hmc_params.m                     ---> "<<B_YELLOW<<s_hmc_params.m<<std::endl;
        std::cout<<B_BLUE<<"s_hmc_params.tlen                  ---> "<<B_YELLOW<<s_hmc_params.tlen<<std::endl;
        std::cout<<B_BLUE<<"s_hmc_params.nsteps                ---> "<<B_YELLOW<<s_hmc_params.nsteps<<std::endl;
        std::cout<<B_BLUE<<"s_hmc_params.serial_seed           ---> "<<B_YELLOW<<s_hmc_params.serial_seed<<std::endl;
        std::cout<<B_BLUE<<"s_hmc_params.parallel_seed         ---> "<<B_YELLOW<<s_hmc_params.parallel_seed<<std::endl;
        std::cout<<B_BLUE<<"s_hmc_params.Ls                    ---> "<<B_YELLOW<<s_hmc_params.Ls<<std::endl;
        std::cout<<B_BLUE<<"s_hmc_params.M5                    ---> "<<B_YELLOW<<s_hmc_params.M5<<std::endl;
        std::cout<<B_BLUE<<"s_hmc_params.b                     ---> "<<B_YELLOW<<s_hmc_params.b<<std::endl;
        std::cout<<B_BLUE<<"s_hmc_params.c                     ---> "<<B_YELLOW<<s_hmc_params.c<<std::endl;
        std::cout<<B_BLUE<<"s_hmc_params.cnfg_dir              ---> "<<B_YELLOW<<s_hmc_params.cnfg_dir<<std::endl;
        std::cout<<B_BLUE<<"*--------------------------------------*"<<std::endl;
        std::cout<<COLOR_RESET;
        if (s_hmc_params.save_freq == 0){rc = RC_FAIL;}
        return rc;
    } /* end of print_IPAddresses_data_structure_t(IPAddresses_struct *s_IPAdds) constructor */

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
        std::string method = __func__;
        char* arr = new char[method.length() + 1];
        rc = print_empty_method_message(strcpy(arr,method.c_str()));
        // Setting the machine name
        rc = set_machine_struct_t(s_machine);
        return rc;
    } /* end of Bencher_Grid_ClassTemplate_t<T,S>::_initialize_t(machine_struct *s_machine) method */
    ////////////////////////////////////////////////////////////////////////////////
    /// [Starters] Template class starters
    ////////////////////////////////////////////////////////////////////////////////
    template <typename T, typename S>
    int Bencher_Grid_ClassTemplate_t<T,S>::start_Grid_t(int argc, char *argv[]) {
        int rc = RC_SUCCESS;
        Grid::Grid_init(&argc, &argv);
        return rc;
    }/* end of start_Grid_t method */
    ////////////////////////////////////////////////////////////////////////////////
    /// [stoppers] Template class stoppers
    ////////////////////////////////////////////////////////////////////////////////
    template <typename T, typename S>
    int Bencher_Grid_ClassTemplate_t<T,S>::stop_Grid_t() {
        int rc = RC_SUCCESS;
        std::cout << Grid::GridLogMessage << B_BLUE<<"Grid is finalising now" << COLOR_RESET<< std::endl;
        Grid::Grid_finalize();
        return rc;
    } /* end of stop_Grid_t method */
    ////////////////////////////////////////////////////////////////////////////////
    /// [Runners] Class runners
    ////////////////////////////////////////////////////////////////////////////////
    template <typename T, typename S>
    int Bencher_Grid_ClassTemplate_t<T,S>::run_MobiusSp2f_DWF_t(int argc, char *argv[]) {
        int rc = RC_SUCCESS;
        // Brining in the Grid namespace
        using namespace Grid;
        // Retrieving the machine structure.
        machine_struct *s_mach = get_machine_struct_t();
        if (s_mach == nullptr){rc = RC_FAIL;}
        else {rc = RC_SUCCESS;}
        // Getting the parameters from the command line
        namespace_Bencher::hmc_params HMCParams = ReadCommandLineHMC(argc, argv);

        // Starting Grid
        rc = start_Grid_t(argc, argv);
        if (rc != RC_SUCCESS){
            std::cout<<C_RED<<"Grid did not start properly ...: "<<__FILE__<<COLOR_RESET<<std::endl;
        }


        // Creating the Domain wall fermion with Sp(2N)



        int threads = GridThread::GetThreads();
        // here make a routine to print all the relevant information on the run
        std::cout << GridLogMessage << "Grid is setup to use " << threads << " threads" << std::endl;

        // Typedefs to simplify notation
        typedef SpWilsonImplR FermionImplPolicy;
        //typedef WilsonImplR FermionImplPolicy;
        typedef MobiusFermion<SpWilsonImplD> FermionAction;
        //typedef MobiusFermion<WilsonImplD> FermionAction;
        //typedef MobiusFermionD FermionAction;
        typedef typename FermionAction::FermionField FermionField;
        typedef Representations<SpFundamentalRepresentation> TheRepresentations;
        //typedef Representations<FundamentalRepresentation> TheRepresentations;

        //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        //  typedef GenericHMCRunner<LeapFrog> HMCWrapper;
        //  MD.name    = std::string("Leap Frog");
        //  typedef GenericHMCRunner<ForceGradient> HMCWrapper;
        //  MD.name    = std::string("Force Gradient");
        typedef GenericHMCRunnerHirep<TheRepresentations, MinimumNorm2> HMCWrapper;

        HMCWrapper TheHMC;
        TheHMC.Parameters.MD.MDsteps = HMCParams.nsteps;
        TheHMC.Parameters.MD.trajL = HMCParams.tlen;

        TheHMC.Parameters.StartTrajectory = HMCParams.starttraj;

        // Grid from the command line arguments --grid and --mpi
        TheHMC.Resources.AddFourDimGrid("gauge"); // use default simd lanes decomposition

        CheckpointerParameters CPparams;
        CPparams.config_prefix = HMCParams.cnfg_dir + "/ckpoint_EODWF_lat";
        CPparams.rng_prefix    = HMCParams.cnfg_dir + "/ckpoint_EODWF_rng";
        CPparams.saveInterval  = HMCParams.save_freq;
        CPparams.format        = "IEEE64BIG";
        TheHMC.Resources.LoadNerscCheckpointer(CPparams);

        RNGModuleParameters RNGpar;
        RNGpar.serial_seeds = HMCParams.serial_seed;
        RNGpar.parallel_seeds = HMCParams.parallel_seed;
        TheHMC.Resources.SetRNGSeeds(RNGpar);

        // Construct observables
        // here there is too much indirection
        typedef PlaquetteMod<HMCWrapper::ImplPolicy> PlaqObs;
        TheHMC.Resources.AddObservable<PlaqObs>();
        //////////////////////////////////////////////

        const int Ls    = HMCParams.Ls;
        Real beta       = HMCParams.beta;
        Real light_mass = HMCParams.m;
        RealD M5        = HMCParams.M5;
        RealD b         = HMCParams.b;
        RealD c         = HMCParams.c;
        RealD pv_mass   = 1.0;

        // Printing the input data structure used in simulation
        rc = print_hmc_params_data_structure(HMCParams); if (rc != RC_SUCCESS){rc = RC_FAIL;}

        auto GridPtr   = TheHMC.Resources.GetCartesian();
        auto GridRBPtr = TheHMC.Resources.GetRBCartesian();
        auto FGrid     = SpaceTimeGrid::makeFiveDimGrid(Ls,GridPtr);
        auto FrbGrid   = SpaceTimeGrid::makeFiveDimRedBlackGrid(Ls,GridPtr);

        SpWilsonGaugeActionR GaugeAction(beta);
        //WilsonGaugeActionR GaugeAction(beta);

        // temporarily need a gauge field
        SpFundamentalRepresentation::LatticeField U(GridPtr);
        //FundamentalRepresentation::LatticeField U(GridPtr);

        // These lines are unecessary if BC are all periodic
        std::vector<Complex> boundary = {1,1,1,-1};
        FermionAction::ImplParams Params(boundary);

        double StoppingCondition = 1e-10;
        double MaxCGIterations = 30000;
        ConjugateGradient<FermionField>  CG(StoppingCondition,MaxCGIterations);

        ////////////////////////////////////
        // Collect actions
        ////////////////////////////////////
        ActionLevel<HMCWrapper::Field, TheRepresentations> Level1(1);
        ActionLevel<HMCWrapper::Field, TheRepresentations> Level2(4);

        //FermionAction FermOp(U, *FGrid, *FrbGrid, *GridPtr, *GridRBPtr, light_mass, M5, b, c, Params);
        //TwoFlavourEvenOddPseudoFermionAction<FermionImplPolicy> Nf2(FermOp, CG, CG);
        std::vector<FermionAction *> Numerators;
        std::vector<FermionAction *> Denominators;
        std::vector<TwoFlavourEvenOddRatioPseudoFermionAction<FermionImplPolicy> *> Quotients;
        //Nf2.is_smeared = false;

        //Level1.push_back(&Nf2);

        /*
        Numerators.push_back  (new FermionAction(U,*FGrid,*FrbGrid,*GridPtr,*GridRBPtr,pv_mass,M5,b,c, Params));
        Denominators.push_back(new FermionAction(U,*FGrid,*FrbGrid,*GridPtr,*GridRBPtr,light_mass,M5,b,c, Params));
        Quotients.push_back   (new TwoFlavourEvenOddRatioPseudoFermionAction<FermionImplPolicy>(*Numerators[0],*Denominators[0],CG,CG));


        Level1.push_back(Quotients[0]);
        /////////////////////////////////////////////////////////////
        // Gauge action
        /////////////////////////////////////////////////////////////
        Level2.push_back(&GaugeAction);
        TheHMC.TheAction.push_back(Level1);
        TheHMC.TheAction.push_back(Level2);
        std::cout << GridLogMessage << " Action complete "<< std::endl;

        /////////////////////////////////////////////////////////////
        // HMC parameters are serialisable

        std::cout << GridLogMessage << " Running the HMC "<< std::endl;
        TheHMC.ReadCommandLine(argc, argv); // these can be parameters from file
        TheHMC.Run();  // no smearing
        */
        /////////////////////////////////////////////////////////////




        // Stopping the Grid
        rc = stop_Grid_t();
        return rc;
    } /* end of run_MobiusSp2f_DWF method */
    ////////////////////////////////////////////////////////////////////////////////
    /// [Setters] Template class getters
    ////////////////////////////////////////////////////////////////////////////////
    template <typename T, typename S> int
    Bencher_Grid_ClassTemplate_t<T,S>::set_machine_struct_t(machine_struct *s_mach) {
        int rc = RC_SUCCESS;
        s_mach_o_t = s_mach;
        if (s_mach_o_t == nullptr){rc = RC_FAIL;}
        else {rc = RC_SUCCESS;}
        return rc;
    } /* end of set_machine_struct_t method */
    ////////////////////////////////////////////////////////////////////////////////
    /// [Getters] Template class getters
    ////////////////////////////////////////////////////////////////////////////////
    template <typename T, typename S> int
    Bencher_Grid_ClassTemplate_t<T,S>::get_site_SU3_plaquette_t(int argc, char *argv[],
                                                            std::string file) {
        int rc = RC_SUCCESS;
        // Brining in the Grid namespace
        //using namespace Grid;
        // Bringing to log
        rc = start_Grid_t(argc, argv);
        if (rc != RC_SUCCESS){
            std::cout<<C_RED<<"Grid did not start properly ...: "<<__FILE__<<COLOR_RESET<<std::endl;
        }
        std::cout<< Grid::GridLogMessage << "Grid is initializing now" << std::endl;

        // Getting the machine structure.
        auto lattice_sz  = Grid::GridDefaultLatt();
        auto simd_layout = Grid::GridDefaultSimd(Grid::Nd, Grid::vComplex::Nsimd());
        auto mpi_layout  = Grid::GridDefaultMpi();
        Grid::GridCartesian  Grid(lattice_sz, simd_layout, mpi_layout);

        Grid::LatticeGaugeField Umu(&Grid);
        std::vector<Grid::LatticeColourMatrix> U(4, &Grid);
        Grid::LatticeComplexD plaq(&Grid);

        Grid::FieldMetaData gauge_filed_header;
        //std::cout<< gauge_filed_header <<std::endl;

        double vol = Umu.Grid()->gSites();
        double faces = (1.0 * Grid::Nd * (Grid::Nd - 1)) / 2.0;
        double Ncdiv = 1.0/Grid::Nc;

        std::cout << "Vol     "<< B_YELLOW  << vol   << C_RESET <<std::endl;
        std::cout << "faces   "<< B_MAGENTA << faces << C_RESET <<std::endl;
        std::cout << "Ncdiv   "<< B_CYAN    << Ncdiv << C_RESET <<std::endl;

        std::cout << "Reading "<< file <<std::endl;
        Grid::NerscIO::readConfiguration(Umu, gauge_filed_header, file);
        for(int mu=0; mu < Grid::Nd; mu++){
            U[mu] = Grid::PeekIndex<LorentzIndex>(Umu,mu);
        }
        Grid::SU3WilsonLoops::sitePlaquette(plaq,U);

        plaq = plaq *(Ncdiv/faces);

        std::cout << "plaquette --->: "<< plaq  <<std::endl;

        return rc;
    } /* end of get_machine_struct method */

    template <typename T, typename S> machine_struct*
    Bencher_Grid_ClassTemplate_t<T,S>::get_machine_struct_t() {
        return s_mach_o_t;
    } /* end of get_machine_struct method */

    template <typename T, typename S> int
    Bencher_Grid_ClassTemplate_t<T,S>::get_network_localIPs(machine_struct *s_mach, std::string delimiter_string_in) {
        int rc = RC_SUCCESS;
        if (s_mach == nullptr){rc = RC_FAIL;}
        else {rc = RC_SUCCESS;}
        std::cerr<<B_RED"return code: "<<rc
        <<" line: "<<__LINE__<<" function: "<<__func__<<C_RESET<<std::endl;
        return rc;
    } /* end of get_network_localIPs method */

    template <typename T, typename S> int
    Bencher_Grid_ClassTemplate_t<T,S>::get_network_foreachIPs(machine_struct *s_mach) {
        int rc = RC_SUCCESS;
        if (s_mach == nullptr){rc = RC_FAIL;}
        else {rc = RC_SUCCESS;}
        std::cerr<<B_RED"return code: "<<rc
                 <<" line: "<<__LINE__<<" function: "<<__func__<<C_RESET<<std::endl;
        return rc;
    } /* end of get_network_foreachIPs method */
    ////////////////////////////////////////////////////////////////////////////////
    /// Helper methods
    ////////////////////////////////////////////////////////////////////////////////
    template <typename T, typename S> int
    Bencher_Grid_ClassTemplate_t<T,S>::hello_t(){
        int rc = RC_SUCCESS;
        std::cerr<<B_RED"return code: "<<rc
                 <<" line: "<<__LINE__<<" function: "<<__func__<<C_RESET<<std::endl;
        return rc;
    }
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
    /// [Finalizers] Template class constructors
    ////////////////////////////////////////////////////////////////////////////////
    template <typename T, typename S>
    int Bencher_Grid_ClassTemplate_t<T,S>::_finalize_t() {int rc = RC_SUCCESS; return rc;}
    ////////////////////////////////////////////////////////////////////////////////
    /// [Destructor] Template class destructors
    ////////////////////////////////////////////////////////////////////////////////
    /* destructor Bencher_Grid_ClassTemplate_t<T,S>::Bencher_Grid_ClassTemplate_t */
    template <typename T, typename S> Bencher_Grid_ClassTemplate_t<T,S>::~Bencher_Grid_ClassTemplate_t() {}
    //******************************************************************************
    //
    //==============================================================================
    //
    //******************************************************************************
    ////////////////////////////////////////////////////////////////////////////////
    // [Constructor] Class Bencher_Grid constructors overloaded methods
    ////////////////////////////////////////////////////////////////////////////////
    Bencher_Grid::Bencher_Grid() {
        int rc = RC_SUCCESS;
        p_cBaseBenchGrid_t_o = new namespace_Bencher::Bencher_Grid_ClassTemplate_t<float, std::string>();
        rc = _initialize();
        std::cout
                <<B_YELLOW<<"Class Bencher_Grid::Bencher_Grid has been instantiated, return code: "
                <<B_GREEN<<rc<<COLOR_RESET<<std::endl;
    } /* end of Bencher_Grid::Bencher_Grid() constructor */
    Bencher_Grid::Bencher_Grid(machine_struct *s_machine) {
        int rc = RC_SUCCESS;
        //namespace_Bencher::Bencher_Grid_ClassTemplate_t<float, std::string> *p_cOverBenchGrid_t_o = new namespace_Bencher::Bencher_Grid_ClassTemplate_t<float, std::string>(s_machine);
        p_cOverBenchGrid_t_o = new namespace_Bencher::Bencher_Grid_ClassTemplate_t<float, std::string>(s_machine);
        rc = _initialize();
        std::cout<<B_CYAN
        <<"Class Bencher_Grid::Bencher_Grid(machine_struct *s_machine)"
        <<" has been instantiated,"
        <<" return code: "<<B_GREEN<<rc<<COLOR_RESET<<std::endl;
    } /* end of Bencher_Grid::Bencher_Grid(machine_struct *s_machine) constructor */
    ////////////////////////////////////////////////////////////////////////////////
    /// [Starters] Class starters
    ////////////////////////////////////////////////////////////////////////////////
    int Bencher_Grid::start_Grid(int argc, char *argv[]){
        int rc = RC_SUCCESS;
        rc = p_cOverBenchGrid_t_o->start_Grid_t(argc, argv);
        return rc;
    } /* end of start_Grid method */
    ////////////////////////////////////////////////////////////////////////////////
    /// [Stoppers] Class starters
    ////////////////////////////////////////////////////////////////////////////////
    int Bencher_Grid::stop_Grid(){
        int rc = RC_SUCCESS;
        rc = p_cOverBenchGrid_t_o->stop_Grid_t();
        return rc;
    } /* end of stop_Grid method */
    ////////////////////////////////////////////////////////////////////////////////
    /// [Runners] Class runners
    ////////////////////////////////////////////////////////////////////////////////
    int Bencher_Grid::run_MobiusSp2f_DWF(int argc, char *argv[]) {
        int rc = RC_SUCCESS;
        rc = p_cOverBenchGrid_t_o->run_MobiusSp2f_DWF_t(argc, argv);
        return rc;
    } /* end of run_MobiusSp2f_DWF method */
    ////////////////////////////////////////////////////////////////////////////////
    /// [Checkers]
    ////////////////////////////////////////////////////////////////////////////////
    int Bencher_Grid::hello() {
        return RC_SUCCESS;
    } /* end of hello checker method */
    ////////////////////////////////////////////////////////////////////////////////
    // [Initializer]
    ////////////////////////////////////////////////////////////////////////////////
    int Bencher_Grid::_initialize() {
        int rc = RC_SUCCESS;
        std::string method = __func__;
        char* arr = new char[method.length() + 1];
        rc = print_empty_method_message(strcpy(arr,method.c_str()));
        return rc;
    } /* end of _initialize method */
    ////////////////////////////////////////////////////////////////////////////////
    // [Setters]
    ////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////
    // [Getters]
    ////////////////////////////////////////////////////////////////////////////////
    int Bencher_Grid::get_site_SU3_plaquette(int argc, char *argv[], std::string file) {
       int rc = RC_SUCCESS;
       rc = p_cOverBenchGrid_t_o->get_site_SU3_plaquette_t(argc, argv, file);
       return rc;
    }
    ////////////////////////////////////////////////////////////////////////////////
    // [Finalizers] deallocate the arrays and cleans up the environment
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

