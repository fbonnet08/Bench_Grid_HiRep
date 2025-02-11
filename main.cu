//System includes
#include <iostream>
#include <chrono>

#include <cuda_runtime.h>
#include <cuda_runtime_api.h>
#include <cufftXt.h>
#include <cufft.h>
#include <cuda.h>

// Global include
#include "global.cuh"
// Other application include
#include "include/GetPID.h"
#include "include/carte_mesh_3D.cuh"
#include "include/dataDeviceManag.cuh"
#include "include/resmap_Sizes.cuh"
#include "include/cuAtomics.cuh"
#include "include/cmdLine.cuh"
#include "include/deviceTools_gpu.cuh"
#include "include/cuAtomics.cuh"
// Now let's bring Grid into the project
//#include "Grid/Grid.h"
//#include <Grid/Grid.h>

/* TODO: need to put this enum structure in the correct place */
static const char *_cuFFTGetErrorEnum(cufftResult error) {
    switch (error) {
        case CUFFT_SUCCESS        : return "CUFFT_SUCCESS";
        case CUFFT_INVALID_PLAN   : return "CUFFT_INVALID_PLAN";
        case CUFFT_ALLOC_FAILED   : return "CUFFT_ALLOC_FAILED";
        case CUFFT_INVALID_TYPE   : return "CUFFT_INVALID_TYPE";
        case CUFFT_INVALID_VALUE  : return "CUFFT_INVALID_VALUE";
        case CUFFT_INTERNAL_ERROR : return "CUFFT_INTERNAL_ERROR";
        case CUFFT_EXEC_FAILED    : return "CUFFT_EXEC_FAILED";
        case CUFFT_SETUP_FAILED   : return "CUFFT_SETUP_FAILED";
        case CUFFT_INVALID_SIZE   : return "CUFFT_INVALID_SIZE";
        case CUFFT_UNALIGNED_DATA : return "CUFFT_UNALIGNED_DATA";
        case CUFFT_INCOMPLETE_PARAMETER_LIST: return "CUFFT_INCOMPLETE_PARAMETER_LIST";
        case CUFFT_INVALID_DEVICE : return "CUFFT_INVALID_DEVICE";
        case CUFFT_PARSE_ERROR    : return "CUFFT_PARSE_ERROR";
        case CUFFT_NO_WORKSPACE   : return "CUFFT_NO_WORKSPACE";
        case CUFFT_NOT_IMPLEMENTED: return "CUFFT_NOT_IMPLEMENTED";
        case CUFFT_LICENSE_ERROR  : return "CUFFT_LICENSE_ERROR";
    }
    return "<unknown>";
}
/* TODO: need to put this into the corrcet place with the CUDA code cuFFT stuff */
template <typename T>
int get_error_fft123D_gpu(T result, int const line, const char *const file,
              char const *const func) {
    int rc = 0;
    if (result) {
        fprintf(stderr, "CUDA error at %s:%d code=%d(%s) \"%s\" \n",
            file, line, static_cast<unsigned int>(result),
            _cuFFTGetErrorEnum(result), func);
        cudaDeviceReset();
    }
    rc = static_cast<unsigned int>(result);
    return rc;
}
//////////////////////////////////////////////////////////////////////////////
// Variable constant declaration
//////////////////////////////////////////////////////////////////////////////
const int GPU_N_MIN = 1;
//////////////////////////////////////////////////////////////////////////////
// Main code
// //////////////////////////////////////////////////////////////////////////////
int main(int argc, char *argv[]) {
    int rc = RC_SUCCESS;
    /* commands line flags */
    bool benchmark = checkCmdLineFlag(argc,(const char **)argv,"benchmark") != 0;
    if (checkCmdLineFlag(argc, (const char **)argv, "help")) {
        std::cout<<"TODO: insert the documentation..."<<std::endl;//displayUsage(program, __FUNCTION__, __FILE__);
        std::cout<<"Try running without the --help flag."<<std::endl;//displayUsage(program, __FUNCTION__, __FILE__);
        exit(rc);
    }
    if (!benchmark) {
        std::cout<<B_WHITE<<"TODO: implement runBenchmark()..."<<__FILE__<<COLOR_RESET<<std::endl;
        std::cout<<B_WHITE<<"TODO: Or add --benchmark in the configuration ..."<<COLOR_RESET<<std::endl;//displayUsage(program, __FUNCTION__, __FILE__);
    } else if (benchmark) {s_bench->bench_i = 1;}
    /* initialising the data structure debug_gpu */
    p_global_o->_initialize_unitTest(s_unitTest);
    /* running the test suits code */
    if (s_unitTest->launch_unitTest == 1) {
        p_UnitTest_o->testing_compilers();
        if (s_unitTest->launch_unitTest_systemDetails == 1) {
            p_UnitTest_o->testing_system_cpu(p_SystemQuery_cpu_o, s_systemDetails);}
        if (s_unitTest->launch_unitTest_deviceDetails == 1) {
            p_UnitTest_o->testing_system_gpu(p_SystemQuery_gpu_o, p_DeviceTools_gpu_o, s_Devices, s_device_details);}
    }
    /* initialising the data structure kernel_calc */
    p_global_o->_initialize_kernel(s_kernel);
    /* initialising the data structure debug_gpu */
    p_global_o->_initialize_debug(s_debug_gpu);
    /* initialising the systemDetails data structure */
    p_global_o->_initialize_systemDetails(s_systemDetails);
    /* initialising the deviceDetails data structure */
    p_global_o->_initialize_deviceDetails(s_device_details);
    /* initialising the deviceDetails data structure */
    p_global_o->_initialize_Devices(s_Devices);
    /* initialising the network data structure */
    p_global_o->_initialize_machine_struct(s_machine_struct);
    /* populating systemDetails data structure */
    rc = p_SystemQuery_cpu_o->get_Number_CPU_cores     (0, s_systemDetails); if (rc!=RC_SUCCESS) {rc = RC_WARNING;}
    rc = p_SystemQuery_cpu_o->get_memorySize_host      (0, s_systemDetails); if (rc!=RC_SUCCESS) {rc = RC_WARNING;}
    rc = p_SystemQuery_cpu_o->get_available_memory_host(0, s_systemDetails); if (rc!=RC_SUCCESS) {rc = RC_WARNING;}
    rc = p_SystemQuery_gpu_o->_initialize              (s_device_details); if (rc!=RC_SUCCESS) {rc = RC_WARNING;}
    rc =          p_global_o->get_deviceDetails_struct (s_device_details->best_devID, s_device_details); if (rc!=RC_SUCCESS) {rc = RC_WARNING;}
    rc =          p_global_o->get_Devices_struct       (s_Devices); if (rc!=RC_SUCCESS) {rc = RC_WARNING;}
    if (s_debug_gpu->debug_high_i == 1) {
        if (s_debug_gpu->debug_high_s_systemDetails_i == 1) rc = p_UnitTest_o->print_systemDetails_data_structure(s_systemDetails); if (rc!=RC_SUCCESS) {rc = RC_WARNING;}
        if (s_debug_gpu->debug_high_s_Devices_i == 1      ) rc = p_UnitTest_o->print_Devices_data_structure      (s_Devices); if (rc!=RC_SUCCESS) {rc = RC_WARNING;}
        if (s_debug_gpu->debug_high_device_details_i == 1 ) rc = p_UnitTest_o->print_deviceDetails_data_structure(s_device_details); if (rc!=RC_SUCCESS) {rc = RC_WARNING;}
    }
    //TODO: remove the debug_write = 1 statement once te network structure is finished ...
    if (s_debug_gpu->debug_write_i == 1 ){
    /* the error handlers from the cuda library */
    cudaError_t err;
    cufftResult cufft_err;
    cufftResult cufftXt_err;
    /* greeting message */
    std::cout << "Main ---> Current date time ---> "<< currentDateTime() <<std::endl;
    int vx=256, vy=256, vz=256;
    int seed = 1234;
    float *h_A = NULL;
    float *h_B = NULL;
    cufftComplex *h_C = NULL;
    float *d_re_in = NULL;
    float *d_im_in = NULL;
    cufftComplex *d_inC = NULL;
    /* assignments of values from local variables values initialized in global.cu */
    Vx_o = vx; Vy_o = vy; Vz_o = vz;




    /*****************************************************************************
     *     cufftXtSetGPUs() - Define which GPUs to use
     ****************************************************************************/
    int device_count;
    /* First Counting the number of available GPUs on system */
    err = cudaGetDeviceCount(&device_count);
    if ( (int)err != CUDA_SUCCESS ) {
        rc = get_error_id_cuda_gpu(err, __LINE__,__FILE__,__FUNCTION__);
    }
    Devices devices;
    devices.ncuda_cores = (int*)malloc(device_count*sizeof(int));
#if defined (CUDA)
    devices = namespace_System_gpu::devices_gpuGetMaxGflopsDeviceId(devices);
#endif
    /*###########################################################################*
     *     Temp code
     *#########################################################################*/
    printf("devices.max_perf_dev: %i\n", devices.max_perf_dev);
    for(int i=0; i < devices.nDev; i++) {
        printf("devices.ncuda_cores[%i]= %i\n",i, devices.ncuda_cores[i]);
    }
    /*###########################################################################*
     *
     *#########################################################################*/
    int nGPUs = 2;
    int nDevices;
    int *whichGPUs ;
    whichGPUs = (int*) malloc(sizeof(int) * nGPUs);

    nDevices = device_count;
    rc = namespace_System_gpu::minGPU_required_message(nGPUs, device_count, GPU_N_MIN);
    std::cout<<"nDevices                    --> : "<<nDevices<<std::endl;
    std::cout<<"nwhichGPUs                  --> : "<<*whichGPUs<<std::endl;

    /* get the pid method */
    rc = getpid();
    /* Getting the socket from the Socket class */
    //std::cout<<"Return code the get_sockets() --> : "<<p_sockets_o->get_sockets()<<std::endl;
    /* instantiating the carte_mesh_3D class */
    //carte_mesh_3D *p_carte_mesha
    carte_mesh_3D *p_carte_mesh_3D_o = new carte_mesh_3D(s_kernel, Vx_o, Vy_o, Vz_o);
    printf("nx %i\n", p_carte_mesh_3D_o->get_CarteMesh3D_nthrdx() );
    printf("ny %i\n", p_carte_mesh_3D_o->get_CarteMesh3D_nthrdy() );
    printf("nz %i\n", p_carte_mesh_3D_o->get_CarteMesh3D_nthrdz() );
    printf("gridx %i\n", p_carte_mesh_3D_o->get_CarteMesh3D_gridx() );
    printf("gridy %i\n", p_carte_mesh_3D_o->get_CarteMesh3D_gridy() );
    printf("gridz %i\n", p_carte_mesh_3D_o->get_CarteMesh3D_gridz() );
    int ntrx = p_carte_mesh_3D_o->get_CarteMesh3D_nthrdx();
    int ntry = p_carte_mesh_3D_o->get_CarteMesh3D_nthrdy();
    int ntrz = p_carte_mesh_3D_o->get_CarteMesh3D_nthrdz();
    int gridx = p_carte_mesh_3D_o->get_CarteMesh3D_gridx();
    int gridy = p_carte_mesh_3D_o->get_CarteMesh3D_gridy();
    int gridz = p_carte_mesh_3D_o->get_CarteMesh3D_gridz();
    dim3 threads (ntrx, ntry, ntrz);
    dim3 grid(gridx, gridy, gridz);
    /* */
    resmap_Sizes *p_Vol_Sizes_o = new resmap_Sizes(Vx_o, Vy_o, Vz_o);
    int npts_Vol = p_Vol_Sizes_o->get_VolSize();

    if (s_debug_gpu->debug_i == 1 /* 1:true, 0:false */) {
        rc = print_Vol_3D_mesh(1,p_carte_mesh_3D_o,
            s_kernel, p_Vol_Sizes_o,ntrx,ntry,ntrz);
    }
    DataDeviceManag<float> *p_DevMag_f = new DataDeviceManag<float>();
    DataDeviceManag<cufftComplex> *p_DevMag_fc = new DataDeviceManag<cufftComplex>();

    // Allocating memory on the host
    h_A = (float*)malloc(sizeof( float)*npts_Vol);
    h_B = (float*)malloc(sizeof( float)*npts_Vol);
    h_C = (cufftComplex*)malloc(sizeof( cufftComplex)*npts_Vol);
    // Initialising the ranmdom seed
    srand(seed);
    // Filling the host matrices A and B with random numbers
//#pragma omp parallel private(i,j,k) reduction(+:prod) for num_threads(8)
    for (int i=0 ; i<vx; i++) {
        for (int j=0 ; j<vy ; j++) {
            for (int k=0 ; k<vz ; k++) {
                h_A[(j+vy*i)*vz+k] = (float)rand()/(float)RAND_MAX;
                h_B[(j+vy*i)*vz+k] = (float)rand()/(float)RAND_MAX;
                h_C[(j+vy*i)*vz+k] = cuR2Cf(0.0,0.0); /* 0.0;*/
            }
        }
    }
    // allocating memory on the device
    rc = p_DevMag_f->t_allocset_gpu(npts_Vol, h_A, d_re_in);
    d_re_in = p_DevMag_f->get_DevicePtr();

    rc = p_DevMag_f->t_allocset_gpu(npts_Vol, h_B, d_im_in);
    d_im_in = p_DevMag_f->get_DevicePtr();

    rc = p_DevMag_fc->t_alloc_gpu(npts_Vol, d_inC);
    d_inC = p_DevMag_fc->get_DevicePtr();
    /*****************************************************************************
     *     mapping the float in --> cufftComplex outC(in,0.0)
     ****************************************************************************/
    /* Call the kernel here for the mapping to the XC complex matrix */
    map_3D_mat_Ss2C<<<grid,threads>>>(d_inC, d_re_in, d_im_in, vx, vy, vz);
    //TODO: add link to cufftXt libarry or add the -Xcompiler flagg in the cmake?
    cuCtxSynchronize();
    // Releasing memory from the device to allow more room on it
    rc = p_DevMag_f->t_dealloc_gpu(d_re_in);
    rc = p_DevMag_f->t_dealloc_gpu(d_im_in);
    /*****************************************************************************
     *     taking the fourier transforms of d_inC into d_inC in place
     ****************************************************************************/
    //CUFFT plan advanced API
    cufftHandle plan_adv;
    size_t workSize;
    long long int new_size_long[3];
    new_size_long[0] = vx; new_size_long[1] = vy; new_size_long[2] = vz;

    cufftCreate(&plan_adv);

    cufftXt_err = cufftXtMakePlanMany(plan_adv, 3, new_size_long, NULL, 1, 1,
                      CUDA_C_32F, NULL, 1, 1, CUDA_C_32F, 1,
                      &workSize, CUDA_C_32F);
    if(cufftXt_err != CUFFT_SUCCESS) {
        rc = p_DevMag_fc->get_error_id_cufftXt_gpu((cufftXtResult_t)cufftXt_err,
                              "*XtMakePlanMany",
                              __LINE__,__FILE__,__FUNCTION__);}
    ///*
    std::cerr<<B_GREEN<<"Temporary buffer size: "
         <<B_YELLOW<<workSize<<B_GREEN<<" bytes"<<C_RESET<<std::endl;
    //*/
    //std::cerr<<B_GREEN<<"(cuFFTinvers) cufftExecC2C..."<<C_RESET<<std::endl;
    //
    cufft_err = cufftExecC2C(plan_adv, (cufftComplex*)d_inC,
                 (cufftComplex*)d_inC, CUFFT_INVERSE);

    if ( cufft_err != CUFFT_SUCCESS) {
        rc = get_error_fft123D_gpu(cufft_err,__LINE__,__FILE__,__FUNCTION__);}

    } //TODO: remove the debug_write = 1 statement once te network structure is finished ...








    /* Object destructiuon and pointer deallocation */
    // delete the data structures
    delete s_kernel;
    delete s_debug_gpu;
    delete s_bench;
    delete s_Devices;
    delete s_device_details;
    delete s_resources_avail;
    delete s_systemDetails;
    delete s_unitTest;
    //delete s_network_struct;
    //delete s_socket_struct;
    // destroying the global objects
    //p_sockets_o->~Socket();
    //p_network_o->~Network();
    p_SystemQuery_cpu_o->~SystemQuery_cpu();
    p_SystemQuery_gpu_o->~SystemQuery_gpu();
    p_DeviceTools_gpu_o->~DeviceTools_gpu();
    p_UnitTest_o->~testing_UnitTest();
    //Destroying the local objects
    if ( s_debug_gpu->debug_write_i == 1) {
        //TODO undio the commented statements once the debug_write = 1 statement is udone
        /*
        p_carte_mesh_3D_o->~carte_mesh_3D();
        p_DevMag_f->~DataDeviceManag();
        p_DevMag_fc->~DataDeviceManag();
        */
    }
    p_global_o->~global();
    /* end of the main code */
    return rc;
} /* end of the mian code */
