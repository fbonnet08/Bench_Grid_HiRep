//
// Created by Frederic on 12/13/2023.
//
//#include "../global.cuh"

#include "get_systemQuery_cpu.hpp"
//#include "get_deviceQuery_gpu.cuh"
//#include "deviceTools_gpu.cuh"

#if defined (WINDOWS)
#endif

#ifndef TESTING_UNITTEST_HPP
#define TESTING_UNITTEST_HPP

#define PRECISION_z

namespace namespace_Testing {

#ifdef __cplusplus
    extern "C" {
#endif

class testing_UnitTest {
private:
public:
    /* constructor */
    testing_UnitTest();
    /* methods for constructor and destructor */
    int _initialize();
    int _finalize();
    /* methods for the unit tests */
    int testing_compilers();
    int testing_system_cpu(
        namespace_System_cpu::SystemQuery_cpu *p_SystemQuery_cpu_o,
        systemDetails *hstD);
    /*
    int testing_system_gpu(
    namespace_System_gpu::SystemQuery_gpu *p_SystemQuery_gpu_o,
    namespace_System_gpu::DeviceTools_gpu *p_DeviceTools_gpu_o,
    Devices *devices, deviceDetails *devD);
    */
    /* network testing methods */
    /* populators methods */
    /*
    int testing_deviceDetails_data_structure_populator(
        namespace_System_gpu::SystemQuery_gpu *p_SystemQuery_gpu_o,
        deviceDetails *devD
        );
    int testing_Devices_data_structure_populator(
            namespace_System_gpu::DeviceTools_gpu *p_DeviceTools_gpu_o,
            Devices *devices);
    */
    /* helpers function */
    int print_systemDetails_data_structure(systemDetails *hstD);
    /*
    int print_deviceDetails_data_structure(deviceDetails *devD);
    int print_Devices_data_structure(Devices *devices);
    */
    /* destructor */
    ~testing_UnitTest();
};

#if defined (CUDA) /*preprossing for the CUDA environment */
#endif

#ifdef __cplusplus
    }
#endif

} /* end of namespace namespace_testing_gpu */

#undef PRECISION_z

#endif /* end of TESTING_UNITTEST_HPP header */
