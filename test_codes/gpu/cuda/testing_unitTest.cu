//
// Created by Frederic on 12/13/2023.
//
// Systems imports
#include <iostream>
#include <stdint.h>
#include <string>
#include <cstring>

// Application imports
#if defined (WINDOWS)
#endif

//#include "../../include/Exception.cuh"
//#include "../../include/resmap_Sizes.cuh"
#include "../../../global.cuh"

#include "../../../include/testing_unitTest.cuh"

//#include "../../include/deviceTools_gpu.cuh"
//#include "../../include/get_deviceQuery_gpu.cuh"
//#include "../../include/get_systemQuery_cpu.cuh"

namespace namespace_Testing {

#ifdef __cplusplus
    extern "C" {
#endif

#if defined (CUDA) /*preprossing for the CUDA environment */

        testing_UnitTest::testing_UnitTest() {
            int rc = RC_SUCCESS;
            /* initializing the structure variables */
            rc = testing_UnitTest::_initialize();
            std::cout<<B_RED<<"Class testing_UnitTest::testing_UnitTest() has been instantiated, return code: "<<B_GREEN<<rc<<COLOR_RESET<<std::endl;
        }/* end of testing_UnitTest constructor */
        int testing_UnitTest::_initialize() {
            int rc = RC_SUCCESS;
            /* TODO: insert the initialisers in the method when needed */
            return rc;
        }/* end of _initialize method */
        int testing_UnitTest::testing_compilers() {
            int rc = RC_SUCCESS;
            std::cout<<B_BLUE<<"*------- compilers --------------------*"<<std::endl;
            std::cout<<p_SystemQuery_cpu_o->get_compiler_info()<<std::endl;
            std::cout<<B_BLUE<<"*--------------------------------------*"<<std::endl;
            return rc;
        }/* end of testing_compilers method */
        int testing_UnitTest::testing_system_cpu(namespace_System_cpu::SystemQuery_cpu *p_SystemQuery_cpu_o,
            systemDetails *hstD) {
            int rc = RC_SUCCESS;
            int *nCPU_cores = 0;
            long long int *memSize = 0;
            long long int *availMem = 0;
            std::cout<<"hstD->n_phys_proc                  ---> "<<hstD->n_phys_proc<<std::endl;
            std::cout<<"hstD->nCPUcores                    ---> "<<hstD->nCPUlogical<<std::endl;
            std::cout<<"hstD->hyper_threads                ---> "<<hstD->hyper_threads<<std::endl;
            std::cout<<"hstD->cpuFeatures                  ---> "<<hstD->cpuFeatures<<std::endl;
            std::cout<<"hstD->cpuVendor                    ---> "<<hstD->cpuVendor<<std::endl;
            std::cout<<"hstD->total_phys_mem (kB)          ---> "<<hstD->total_phys_mem<<std::endl;
            std::cout<<"hstD->avail_phys_mem (kB)          ---> "<<hstD->avail_phys_mem<<std::endl;
            std::cout<<"hstD->ProcessorArchitecture        ---> "<<hstD->ProcessorArchitecture<<std::endl;
#if defined (WINDOWS)
            std::cout<<"hstD->MemoryLoad_pc (kB)           ---> "<<hstD->MemoryLoad_pc<<std::endl;
            std::cout<<"hstD->TotalPhys_kB (kB)            ---> "<<hstD->TotalPhys_kB<<std::endl;
            std::cout<<"hstD->AvailPhys_kB (kB)            ---> "<<hstD->AvailPhys_kB<<std::endl;
            std::cout<<"hstD->TotalPageFile_kB (kB)        ---> "<<hstD->TotalPageFile_kB<<std::endl;
            std::cout<<"hstD->AvailPageFile_kB (kB)        ---> "<<hstD->AvailPageFile_kB<<std::endl;
            std::cout<<"hstD->TotalVirtual_kB (kB)         ---> "<<hstD->TotalVirtual_kB<<std::endl;
            std::cout<<"hstD->AvailVirtual_kB (kB)         ---> "<<hstD->AvailVirtual_kB<<std::endl;
            std::cout<<"hstD->AvailExtendedVirtual_kB (kB) ---> "<<hstD->AvailExtendedVirtual_kB<<std::endl;
#endif
	    
            rc = namespace_System_cpu::get_CPU_cores(nCPU_cores, hstD);
            if (rc != RC_SUCCESS){ std::cout<<"namespace_System::get_CPU_cores rc = "<<rc<<std::endl;}
            rc = namespace_System_cpu::get_memorySize_host(memSize, hstD);
            if (rc != RC_SUCCESS){ std::cout<<"namespace_System::get_memorySize_host rc = "<<rc<<std::endl; }
            rc = namespace_System_cpu::get_available_memory_host(availMem, hstD);
            if (rc!=RC_SUCCESS){std::cout<<"namespace_System::get_available_memory_host rc = "<<rc<<std::endl;}

            rc = print_systemDetails_data_structure(hstD); if (rc!=RC_SUCCESS) {rc = RC_WARNING;}

            /* testing the systrem class SystemQuery_cpu */
            rc = p_global_o->_initialize_systemDetails(hstD); if (rc!=RC_SUCCESS) {rc = RC_WARNING;}
            rc = print_systemDetails_data_structure(hstD); if (rc!=RC_SUCCESS) {rc = RC_WARNING;}

            rc = p_SystemQuery_cpu_o->get_Number_CPU_cores(nCPU_cores, hstD); if (rc!=RC_SUCCESS) {rc = RC_WARNING;}
            rc = p_SystemQuery_cpu_o->get_memorySize_host(memSize, hstD); if (rc!=RC_SUCCESS) {rc = RC_WARNING;}
            rc = p_SystemQuery_cpu_o->get_available_memory_host(memSize, hstD); if (rc!=RC_SUCCESS) {rc = RC_WARNING;}
            rc = print_systemDetails_data_structure(hstD); if (rc!=RC_SUCCESS) {rc = RC_WARNING;}

            return rc;
        } /* end of testing_system_cpu method */
        int testing_UnitTest::print_systemDetails_data_structure(systemDetails *hstD) {
            int rc = RC_SUCCESS;
            std::cout<<B_BLUE<<"*------- systemDetails struct ---------*"<<std::endl;
            std::cout<<B_BLUE<<"hstD->n_phys_proc                  ---> "<<B_YELLOW<<hstD->n_phys_proc<<std::endl;
            std::cout<<B_BLUE<<"hstD->nCPUcores                    ---> "<<B_YELLOW<<hstD->nCPUlogical<<std::endl;
            std::cout<<B_BLUE<<"hstD->hyper_threads                ---> "<<B_YELLOW<<hstD->hyper_threads<<std::endl;
            std::cout<<B_BLUE<<"hstD->cpuVendor                    ---> "<<B_YELLOW<<hstD->cpuVendor<<std::endl;
            std::cout<<B_BLUE<<"hstD->cpuFeatures                  ---> "<<B_YELLOW<<hstD->cpuFeatures<<std::endl;
            std::cout<<B_BLUE<<"hstD->total_phys_mem (kB)          ---> "<<B_YELLOW<<hstD->total_phys_mem<<std::endl;
            std::cout<<B_BLUE<<"hstD->avail_phys_mem (kB)          ---> "<<B_YELLOW<<hstD->avail_phys_mem<<std::endl;
            std::cout<<B_BLUE<<"hstD->ProcessorArchitecture        ---> "<<B_YELLOW<<hstD->ProcessorArchitecture<<std::endl;
#if defined (WINDOWS)
            std::cout<<B_BLUE<<"hstD->MemoryLoad_pc (kB)           ---> "<<B_YELLOW<<hstD->MemoryLoad_pc<<std::endl;
            std::cout<<B_BLUE<<"hstD->TotalPhys_kB (kB)            ---> "<<B_YELLOW<<hstD->TotalPhys_kB<<std::endl;
            std::cout<<B_BLUE<<"hstD->AvailPhys_kB (kB)            ---> "<<B_YELLOW<<hstD->AvailPhys_kB<<std::endl;
            std::cout<<B_BLUE<<"hstD->TotalPageFile_kB (kB)        ---> "<<B_YELLOW<<hstD->TotalPageFile_kB<<std::endl;
            std::cout<<B_BLUE<<"hstD->AvailPageFile_kB (kB)        ---> "<<B_YELLOW<<hstD->AvailPageFile_kB<<std::endl;
            std::cout<<B_BLUE<<"hstD->TotalVirtual_kB (kB)         ---> "<<B_YELLOW<<hstD->TotalVirtual_kB<<std::endl;
            std::cout<<B_BLUE<<"hstD->AvailVirtual_kB (kB)         ---> "<<B_YELLOW<<hstD->AvailVirtual_kB<<std::endl;
            std::cout<<B_BLUE<<"hstD->AvailExtendedVirtual_kB (kB) ---> "<<B_YELLOW<<hstD->AvailExtendedVirtual_kB<<std::endl;
#endif
            std::cout<<B_BLUE<<"*--------------------------------------*"<<std::endl;
            std::cout<<COLOR_RESET;
            return rc;
        } /* end of print_systemDetails_data_structure method */
        int testing_UnitTest::testing_system_gpu(
            namespace_System_gpu::SystemQuery_gpu *p_SystemQuery_gpu_o,
            namespace_System_gpu::DeviceTools_gpu *p_DeviceTools_gpu_o,
            Devices *devices, deviceDetails *devD) {
            int rc = RC_SUCCESS;
            /* testing the Device populator data structure */
            rc = testing_Devices_data_structure_populator(p_DeviceTools_gpu_o, devices); if (rc != RC_SUCCESS){rc = RC_WARNING;}
            /* testing the deviceDetails populator data structure */
            rc = testing_deviceDetails_data_structure_populator(p_SystemQuery_gpu_o, devD); if (rc != RC_SUCCESS){rc = RC_WARNING;}
            return rc;
        } /* end of testing_system_gpu method */
        int testing_UnitTest::testing_deviceDetails_data_structure_populator (
                namespace_System_gpu::SystemQuery_gpu *p_SystemQuery_gpu_o,
                deviceDetails *devD
                ) {
            int rc = RC_SUCCESS;
            std::cout<<"*------- deviceDetails struct ---------*"<<std::endl;
            std::cout<<"devD->best_devID                   ---> "<<devD->best_devID<<std::endl;
            std::cout<<"devD->best_devID_name              ---> "<<devD->best_devID_name<<std::endl;
            std::cout<<"devD->best_devID_compute_maj.min   ---> "<<devD->best_devID_compute_major<<"."<<devD->best_devID_compute_minor<<std::endl;
            std::cout<<"devD->ndev                         ---> "<<devD->ndev<<std::endl;
            std::cout<<"devD->dev_name                     ---> "<<devD->dev_name<<std::endl;
            std::cout<<"devD->d_ver                        ---> "<<devD->d_ver<<std::endl;
            std::cout<<"devD->d_runver                     ---> "<<devD->d_runver<<std::endl;
            std::cout<<"devD->tot_global_mem_MB            ---> "<<devD->tot_global_mem_MB<<std::endl;
            std::cout<<"devD->tot_global_mem_bytes         ---> "<<devD->tot_global_mem_bytes<<std::endl;
            std::cout<<"devD->nMultiProc                   ---> "<<devD->nMultiProc<<std::endl;
            std::cout<<"devD->ncudacores_per_MultiProc     ---> "<<devD->ncudacores_per_MultiProc<<std::endl;
            std::cout<<"devD->ncudacores                   ---> "<<devD->ncudacores<<std::endl;
            std::cout<<"devD->is_SMsuitable                ---> "<<devD->is_SMsuitable<<std::endl;
            std::cout<<"devD->nregisters_per_blk           ---> "<<devD->nregisters_per_blk<<std::endl;
            std::cout<<"devD->warpSze                      ---> "<<devD->warpSze<<std::endl;
            std::cout<<"devD->maxthreads_per_mp            ---> "<<devD->maxthreads_per_mp<<std::endl;
            std::cout<<"devD->maxthreads_per_blk           ---> "<<devD->maxthreads_per_blk<<std::endl;
            std::cout<<"devD->is_ecc                       ---> "<<devD->is_ecc<<std::endl;
            std::cout<<"*--------------------------------------*"<<std::endl;
            //s_device_details->is_p2p = new int [MAX_N_GPU][MAX_N_GPU];

            /* populating the data structure with the object methods */
            int idev = 0;
            cudaDeviceProp devProp_testing;
            cudaError_t error_id = cudaGetDeviceProperties(&devProp_testing, idev);
            if (error_id != cudaSuccess) { rc = namespace_System_gpu::get_error_id (error_id); }

            //int devID = namespace_System_gpu::findCudaDevice(devProp_testing, devD);
            devD->best_devID = namespace_System_gpu::findCudaDevice(devProp_testing);

            std::cout<<B_BLUE<<"Most suitable GPU Device           ---> devID= "<<
                B_YELLOW<<devD->best_devID<<": "<<B_CYAN<<"\""<<devProp_testing.name<<"\""<<
                    B_GREEN" with compute capability ---> "<<B_MAGENTA<<devProp_testing.major<<"."<<devProp_testing.minor<<COLOR_RESET<<std::endl;
             strcpy(devD->best_devID_name, devProp_testing.name);
            devD->best_devID_compute_major = devProp_testing.major;
            devD->best_devID_compute_minor = devProp_testing.minor;

            rc = namespace_System_gpu::get_dev_count(devD); if (rc != RC_SUCCESS){rc = RC_WARNING;}
            rc = namespace_System_gpu::get_dev_Name(devProp_testing, devD); if (rc != RC_SUCCESS){rc = RC_WARNING;}
            int ver =5.0;
            rc = namespace_System_gpu::get_cuda_driverVersion(&ver, devD); if (rc != RC_SUCCESS){rc = RC_WARNING;}
            rc = namespace_System_gpu::get_cuda_runtimeVersion(&ver, devD); if (rc != RC_SUCCESS){rc = RC_WARNING;}
            float mem = 10.0;
            rc = namespace_System_gpu::get_tot_global_mem_MB(devProp_testing, &mem, devD); if (rc != RC_SUCCESS){rc = RC_WARNING;}
            rc = namespace_System_gpu::get_tot_global_mem_bytes(devProp_testing, &devD->tot_global_mem_bytes, devD); if (rc != RC_SUCCESS){rc = RC_FAIL;}

            int nmp = 1; int cuda_cores_per_mp = 1; int ncuda_cores = 1;
            rc = namespace_System_gpu::get_CUDA_cores(&devD->best_devID, devProp_testing,
                &devD->best_devID_compute_major, &devD->best_devID_compute_minor,
                &nmp, &cuda_cores_per_mp, &ncuda_cores, devD);  if (rc != RC_SUCCESS){rc = RC_FAIL;}

            int nregisters_per_blk = 1;
            rc = namespace_System_gpu::get_nregisters(devProp_testing, &nregisters_per_blk, devD); if (rc != RC_SUCCESS){rc = RC_WARNING;}

            int warpSize = devD->warpSze; int max_threads_per_mp = devD->maxthreads_per_mp;
            int max_threads_per_blk = devD->maxthreads_per_blk;

            rc = namespace_System_gpu::get_thread_details(devProp_testing, &warpSize, &max_threads_per_mp,
                &max_threads_per_blk, devD);if (rc != RC_SUCCESS){rc = RC_WARNING;}

            int ecc = 1;
            rc = namespace_System_gpu::get_eec_support(devProp_testing, &ecc, &devD->best_devID, devD);  if (rc != RC_SUCCESS){rc = RC_WARNING;}

            rc = namespace_System_gpu::get_peer_to_peer_capabilities(devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}


            rc = print_deviceDetails_data_structure(devD); if (rc != RC_SUCCESS){rc = RC_WARNING;}

            /* initialising the data structure to make sur ethat it works before and after */
            rc = p_global_o->_initialize_deviceDetails(devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}
            rc = print_deviceDetails_data_structure(devD); if (rc != RC_SUCCESS){rc = RC_WARNING;}

            /* populating the data structure with the object methods */
            rc = p_SystemQuery_gpu_o->_initialize(devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}
            rc = p_SystemQuery_gpu_o->get_dev_count(devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}
            rc = p_SystemQuery_gpu_o->get_dev_Name(devProp_testing, devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}
            rc = p_SystemQuery_gpu_o->get_cuda_driverVersion((int*)&devD->d_ver, devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}
            rc = p_SystemQuery_gpu_o->get_cuda_runtimeVersion((int*)&devD->d_runver, devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}
            rc = p_SystemQuery_gpu_o->get_tot_global_mem_MB(devProp_testing, (float*)&devD->tot_global_mem_MB, devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}
            rc = p_SystemQuery_gpu_o->get_tot_global_mem_bytes(devProp_testing, &devD->tot_global_mem_bytes, devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}
            rc = p_SystemQuery_gpu_o->get_CUDA_cores(&devD->best_devID, devProp_testing,&devD->best_devID_compute_major, &devD->best_devID_compute_minor, &devD->nMultiProc, &devD->ncudacores_per_MultiProc, &devD->ncudacores, devD);  if (rc != RC_SUCCESS){rc = RC_FAIL;}
            rc = p_SystemQuery_gpu_o->get_nregisters(devProp_testing, &devD->nregisters_per_blk, devD); if (rc != RC_SUCCESS){rc = RC_WARNING;}
            rc = p_SystemQuery_gpu_o->get_thread_details(devProp_testing, &devD->warpSze, &devD->maxthreads_per_mp, &devD->maxthreads_per_blk, devD);if (rc != RC_SUCCESS){rc = RC_WARNING;}
            rc = p_SystemQuery_gpu_o->get_eec_support(devProp_testing, &devD->is_ecc, &devD->best_devID, devD);  if (rc != RC_SUCCESS){rc = RC_WARNING;}
            rc = p_SystemQuery_gpu_o->get_peer_to_peer_capabilities(devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}

            rc = print_deviceDetails_data_structure(devD); if (rc != RC_SUCCESS){rc = RC_WARNING;}

            return rc;
        } /* end of testing_deviceDetails_data_structure_populator method */
        int testing_UnitTest::print_deviceDetails_data_structure(deviceDetails *devD) {
            int rc = RC_SUCCESS;
            std::cout<<COLOR_RESET;
            std::cout<<B_BLUE<<"*------- deviceDetails struct ---------*"<<std::endl;
            std::cout<<B_BLUE<<"devD->best_devID                   ---> "<<B_YELLOW<<devD->best_devID<<std::endl;
            std::cout<<B_BLUE<<"devD->best_devID_name              ---> "<<B_YELLOW<<devD->best_devID_name<<std::endl;
            std::cout<<B_BLUE<<"devD->best_devID_compute_maj.min   ---> "<<B_YELLOW<<devD->best_devID_compute_major<<"."<<devD->best_devID_compute_minor<<std::endl;
            std::cout<<B_BLUE<<"devD->ndev                         ---> "<<B_YELLOW<<devD->ndev<<std::endl;
            std::cout<<B_BLUE<<"devD->dev_name                     ---> "<<B_YELLOW<<devD->dev_name<<std::endl;
            std::cout<<B_BLUE<<"devD->d_ver                        ---> "<<B_YELLOW<<devD->d_ver<<std::endl;
            std::cout<<B_BLUE<<"devD->d_runver                     ---> "<<B_YELLOW<<devD->d_runver<<std::endl;
            std::cout<<B_BLUE<<"devD->tot_global_mem_MB            ---> "<<B_YELLOW<<devD->tot_global_mem_MB<<std::endl;
            std::cout<<B_BLUE<<"devD->tot_global_mem_bytes         ---> "<<B_YELLOW<<devD->tot_global_mem_bytes<<std::endl;
            std::cout<<B_BLUE<<"devD->nMultiProc                   ---> "<<B_YELLOW<<devD->nMultiProc<<std::endl;
            std::cout<<B_BLUE<<"devD->ncudacores_per_MultiProc     ---> "<<B_YELLOW<<devD->ncudacores_per_MultiProc<<std::endl;
            std::cout<<B_BLUE<<"devD->ncudacores                   ---> "<<B_YELLOW<<devD->ncudacores<<std::endl;
            std::cout<<B_BLUE<<"devD->is_SMsuitable                ---> "<<B_YELLOW<<devD->is_SMsuitable<<std::endl;
            std::cout<<B_BLUE<<"devD->nregisters_per_blk           ---> "<<B_YELLOW<<devD->nregisters_per_blk<<std::endl;
            std::cout<<B_BLUE<<"devD->warpSze                      ---> "<<B_YELLOW<<devD->warpSze<<std::endl;
            std::cout<<B_BLUE<<"devD->maxthreads_per_mp            ---> "<<B_YELLOW<<devD->maxthreads_per_mp<<std::endl;
            std::cout<<B_BLUE<<"devD->maxthreads_per_blk           ---> "<<B_YELLOW<<devD->maxthreads_per_blk<<std::endl;
            std::cout<<B_BLUE<<"devD->is_ecc                       ---> "<<B_YELLOW<<devD->is_ecc<<std::endl;
            std::cout<<B_BLUE<<"*--------------------------------------*"<<std::endl;
	    //s_device_details->is_p2p = new int [MAX_N_GPU][MAX_N_GPU];
            std::cout<<COLOR_RESET;

            return rc;
        } /* end of print_deviceDetails_data_structure method */
        int testing_UnitTest::testing_Devices_data_structure_populator(namespace_System_gpu::DeviceTools_gpu *p_DeviceTools_gpu_o, Devices *devices) {
            int rc = RC_SUCCESS;
            /* blind test of the initialisation of the data structure */
            std::cout<<"devices->nDev                      ---> "<<devices->nDev<<std::endl;
            std::cout<<"devices->max_perf_dev              ---> "<<devices->max_perf_dev<<std::endl;
            std::cout<<"devices->ncuda_cores               ---> "<<devices->ncuda_cores<<std::endl;
            /* filling in the device data structure */
            *devices = namespace_System_gpu::devices_gpuGetMaxGflopsDeviceId(*devices);
            /* printing the data structure */
            rc = print_Devices_data_structure(devices);
            /* TODO complete if neccessary and expand the Devices data structure
             * Check if the object has been working corrcetly */

            return rc;
        } /* end of testing_Devices_data_structure_populator method */
        int testing_UnitTest::print_Devices_data_structure(Devices *devices) {
            int rc = RC_SUCCESS;
            std::cout<<B_BLUE<<"*------- Devices struct ---------------*"<<std::endl;
            std::cout<<B_BLUE<<"devices->nDev                      ---> "<<B_YELLOW<<devices->nDev<<std::endl;
            std::cout<<B_BLUE<<"devices->max_perf_dev              ---> "<<B_YELLOW<<devices->max_perf_dev<<std::endl;
            std::cout<<B_BLUE<<"devices->ncuda_cores               ---> "<<B_YELLOW<<*(devices->ncuda_cores)<<std::endl;
            std::cout<<B_BLUE<<"*--------------------------------------*"<<std::endl;
            std::cout<<COLOR_RESET;
            return rc;
        } /* end of print_Devices_data_structure method */
        int testing_UnitTest::_finalize() {
            int rc = RC_SUCCESS;
            try{
                //TODO: free the alocated pointers here, bring in the Eception class
            }
            catch(Exception<std::invalid_argument> &e){std::cerr<<e.what()<<std::endl;}
            catch(...){
                std::cerr<<B_YELLOW
                  "Program error! Unknown type of exception occured."<<std::endl;
                std::cerr<<B_RED"Aborting."<<std::endl;
                rc = RC_FAIL;
                return rc;
            }
            return rc;
        } /* end of _finalize method */
        testing_UnitTest::~testing_UnitTest() {
            int rc = RC_SUCCESS;
            rc = _finalize();
            if (rc != RC_SUCCESS) {
                std::cerr<<B_RED"return code: "<<rc
                         <<" line: "<<__LINE__<<" file: "<<__FILE__<<C_RESET<<std::endl;
                exit(rc);
            } else {rc = RC_SUCCESS; /*print_destructor_message("DataDeviceManag");*/}
            rc = get_returnCode(rc, "SystemQuery_cpu", 0);
        } /* end of ~testing_UnitTest destructor */

#endif

#ifdef __cplusplus
    }
#endif

}/* End of namespace namespace_testing_gpu */










