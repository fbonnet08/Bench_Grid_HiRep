//
// Created by Frederic on 12/2/2023.
//
// System headers
#include <string>
/// Application headers

#include "include/common.cuh"
#include "include/common_krnl.cuh"

//#include "include/Sockets.cuh"
//#include "include/Network.cuh"
#include "include/get_systemQuery_cpu.cuh"
#include "include/get_deviceQuery_gpu.cuh"
#include "include/deviceTools_gpu.cuh"
#include "include/testing_unitTest.cuh"

//#include "include/get_deviceQuery_gpu.cuh"
//#include "include/deviceTools_gpu.cuh"
#include "include/resmap_Sizes.cuh"
#include "include/Exception.cuh"

#ifndef GLOBAL_CUH
#define GLOBAL_CUH
/*
namespace namespace_Network {
  class Network;
}
*/
// Class definition
class global {
public:
    /* constructors */
    global();

    /* initialisors */
    int _initialize();
    int _initialize_kernel(kernel_calc* s_kernel);
    int _initialize_debug(debug_gpu* s_debug_gpu);
    int _initialize_bench(bench* s_bench);
    /* unitest data structure */
    int _initialize_unitTest(unitTest* s_unitTest);
    /* system and GPU retalted data structure */
    int _initialize_Devices(Devices* s_Devices);
    int _initialize_deviceDetails(deviceDetails* s_device_details);
    int _initialize_resources_avail(resources_avail* s_resources_avail);
    /* network related data structures */
    int _initialize_machine_struct(machine_struct* s_machine);
    /* CPU related data structure */
    int _initialize_systemDetails(systemDetails* s_systemDetails);
    /* getter */
    int get_deviceDetails_struct(int idev, deviceDetails* devD);
    int get_Devices_struct(Devices* s_Dev);
    /* finalisors */
    int _finalize();
    /* destructors */
    ~global();
};
// Structure definition
extern kernel_calc* s_kernel;
extern debug_gpu* s_debug_gpu;
extern bench* s_bench;
extern Devices* s_Devices;
extern deviceDetails* s_device_details;
extern resources_avail* s_resources_avail;
extern systemDetails* s_systemDetails;
extern unitTest* s_unitTest;
extern machine_struct* s_machine_struct;

//extern network_struct* s_network_struct;
//extern socket_struct* s_socket_struct;
//extern IPAddresses_struct* s_IPAddresses_struct;
//extern adapters_struct* s_adapters_struct;
// Object pointers
extern global* p_global_o;
//extern namespace_Network::Socket* p_sockets_o;
//extern namespace_Network::Network* p_network_o;
extern namespace_System_cpu::SystemQuery_cpu* p_SystemQuery_cpu_o;
extern namespace_System_gpu::SystemQuery_gpu* p_SystemQuery_gpu_o;
extern namespace_System_gpu::DeviceTools_gpu* p_DeviceTools_gpu_o;
extern namespace_Testing::testing_UnitTest* p_UnitTest_o;
//extern carte_mesh_3D *p_carte_mesh_3D_o;
// Global variables definitions
extern int Vx_o, Vy_o, Vz_o, nBases_o;

const std::string currentDateTime();

#endif //GLOBAL_CUH
