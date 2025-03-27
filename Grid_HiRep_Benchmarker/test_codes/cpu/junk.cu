
cmd = "\&\'C:\\Program Files (x86)\\Nmap\\nmap.exe\' -sP "+ip+netmask+" |Select-String -NotMatch \"host down\"";


#include "include/common_systemProg.cuh"
#include "../include/common_systemProg.cuh"


rc = get_dev_count(devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}
rc = get_dev_Name(deviceProp, devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}
rc = get_cuda_driverVersion((int*)&devD->d_ver, devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}
rc = get_cuda_runtimeVersion((int*)&devD->d_runver, devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}
rc = get_tot_global_mem_MB(deviceProp, (float*)&devD->tot_global_mem_MB, devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}
rc = get_tot_global_mem_bytes(deviceProp, &devD->tot_global_mem_bytes, devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}
rc = get_CUDA_cores(&devD->best_devID, deviceProp, &devD->best_devID_compute_major, &devD->best_devID_compute_minor, &devD->nMultiProc, &devD->ncudacores_per_MultiProc, &devD->ncudacores, devD);  if (rc != RC_SUCCESS){rc = RC_FAIL;}
rc = get_nregisters(deviceProp, &devD->nregisters_per_blk, devD); if (rc != RC_SUCCESS){rc = RC_WARNING;}
rc = get_thread_details(deviceProp, &devD->warpSze, &devD->maxthreads_per_mp, &devD->maxthreads_per_blk, devD);if (rc != RC_SUCCESS){rc = RC_WARNING;}
rc = get_eec_support(deviceProp, &devD->is_ecc, &devD->best_devID, devD);  if (rc != RC_SUCCESS){rc = RC_WARNING;}
rc = get_peer_to_peer_capabilities(devD); if (rc!=RC_SUCCESS){rc = RC_WARNING;}




int get_dev_Name(deviceDetails_t *devD);



int SystemQuery_gpu::get_dev_Name(deviceDetails_t *devD) {
    int rc = RC_SUCCESS;

    strcpy(devD->dev_name, deviceProp.name);
    if (strlen(devD->dev_name) == 0) {
        rc = RC_WARNING;
        std::cout<<" devD->dev_name is an empty string ---> "<<devD->dev_name<<std::endl;
    }

    return rc;
} /* end of get_dev_Name method */




