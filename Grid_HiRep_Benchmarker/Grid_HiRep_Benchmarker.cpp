#include <stdio.h>
#include <iostream>
// Application includes
#include "include/common_main_app.hpp"
#include "include/cmd_Line.hpp"
#include "include/global_app.hpp"

int main(int argc, char *argv[])
{
    int rc = RC_SUCCESS;

    bool benchmark = checkCmdLineFlag(argc,(const char **)argv,"benchmark") != 0;
    if (checkCmdLineFlag(argc, (const char **)argv, "help")) {
        std::cout<<"TODO: insert the documentnation..."<<std::endl;//displayUsage(program, __FUNCTION__, __FILE__);
        std::cout<<"Try running without the --help flag."<<std::endl;//displayUsage(program, __FUNCTION__, __FILE__);
        exit(rc);
    }
    bool MobiusSp2f_DWF = checkCmdLineFlag(argc,(const char **)argv,"MobiusSp2f_DWF") != 0;
    bool get_site_SU3_plaquette = checkCmdLineFlag(argc,(const char **)argv,"get_site_SU3_plaquette") != 0;

    if (!benchmark) {
        std::cout<<B_WHITE<<"TODO: implement runBenchmark()..."<<__FILE__<<COLOR_RESET<<std::endl;
        std::cout<<B_WHITE<<"TODO: Or add --benchmark in the configuration ..."<<COLOR_RESET<<std::endl;//displayUsage(program, __FUNCTION__, __FILE__);
    } else if (benchmark) {s_bench->bench_i = 1;}
    /* initialising the data structure debug_gpu */
    p_global_o->_initialize_unitTest(s_unitTest);
    /* running the test suits code */
    if (s_unitTest->launch_unitTest == 1) {
        //p_UnitTest_o->testing_compilers();
        if (s_unitTest->launch_unitTest_systemDetails == 1) {
            p_UnitTest_o->testing_system_cpu(p_SystemQuery_cpu_o, s_systemDetails);
        }
        if (s_unitTest->launch_unitTest_deviceDetails == 1) {
            //p_UnitTest_o->testing_system_gpu(p_SystemQuery_gpu_o,
            //    p_DeviceTools_gpu_o, s_Devices, s_device_details);
        }
        if (s_unitTest->launch_unitTest_networks == 1) {
            //p_UnitTest_o->testing_Network(p_network_o, p_sockets_o,
            //    s_network_struct, s_socket_struct);
        }
    }
    /* initialising the data structure kernel_calc */
    //p_global_o->_initialize_kernel(s_kernel);
    /* initialising the data structure debug_gpu */
    p_global_o->_initialize_debug(s_debug_gpu);
    /* initialising the systemDetails data structure */
    p_global_o->_initialize_systemDetails(s_systemDetails);
    /* initialising the deviceDeatils data structure */
    p_global_o->_initialize_deviceDetails(s_device_details);
    /* initialising the deviceDeatils data structure */
    p_global_o->_initialize_Devices(s_Devices);
    /* initialising the network data structure */
    p_global_o->_initialize_machine_struct(s_machine_struct);
    /* populating systemDetails data structure */
    rc = p_SystemQuery_cpu_o->get_Number_CPU_cores(0, s_systemDetails); if (rc!=RC_SUCCESS) {rc = RC_WARNING;}
    rc = p_SystemQuery_cpu_o->get_memorySize_host(0, s_systemDetails); if (rc!=RC_SUCCESS) {rc = RC_WARNING;}
    rc = p_SystemQuery_cpu_o->get_available_memory_host(0, s_systemDetails); if (rc!=RC_SUCCESS) {rc = RC_WARNING;}
    rc = p_global_o->get_deviceDetails_struct(s_device_details->best_devID, s_device_details); if (rc!=RC_SUCCESS) {rc = RC_WARNING;}
    rc = p_global_o->get_Devices_struct(s_Devices); if (rc!=RC_SUCCESS) {rc = RC_WARNING;}
    if (s_debug_gpu->debug_high_i == 1) {
        if (s_debug_gpu->debug_high_s_systemDetails_i == 1) rc = p_UnitTest_o->print_systemDetails_data_structure(s_systemDetails); if (rc!=RC_SUCCESS) {rc = RC_WARNING;}
    }

    // Hello test code
    p_Bencher_Grid_o->hello();
    // Benchmarker starts Grid stuff
    if (get_site_SU3_plaquette) {
        std::string file = "/home/frederic/SwanSea/SourceCodes/DWF_ensembles_GRID/nf2_fund_sp4/b6p9_m0p08_LNt32L24Ls8/ckpoint_EODWF_rng.7280";
        rc = p_Bencher_Grid_o->get_site_SU3_plaquette(argc, argv, file);
    }
    if (benchmark) {
        // Starting MobiusSp2f_DWF
        if (MobiusSp2f_DWF){rc = p_Bencher_Grid_o->run_MobiusSp2f_DWF(argc, argv);}

    } else if (!benchmark) {s_bench->bench_i = 0;}

    // Cleaning up the project and getting the destructors
    p_Bencher_Grid_o->~Bencher_Grid();
    p_UnitTest_o->~testing_UnitTest();
    p_SystemQuery_cpu_o->~SystemQuery_cpu();
    // Destroying the global object
    p_global_o->~global();
    // Final exit statement.
    rc = get_returnCode(rc, "Grid_HiRep_Benchmarker", 1);
    std::cout<<B_BLUE<<"Main code has executed, return code: "<<B_GREEN<<rc<<COLOR_RESET<<std::endl;
    return rc;
}
