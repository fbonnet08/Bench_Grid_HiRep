



namespace_Network::Network *p_network_o = new namespace_Network::Network(s_network_struct);

IPAddresses_struct *s_IPAddresses_struct = (struct IPAddresses_struct*)malloc(sizeof(IPAddresses_struct));
adapters_struct *s_adapters_struct =  (struct adapters_struct*)malloc(sizeof(adapters_struct));
socket_struct *s_socket_struct =  (struct socket_struct*)malloc(sizeof(socket_struct));
network_struct *s_network_struct =  (struct network_struct*)malloc(sizeof(network_struct));

namespace_Network::Socket *p_sockets_o = new namespace_Network::Socket(s_socket_struct);
namespace_Network::Network *p_network_o = new namespace_Network::Network(
  s_machine_struct,
  s_IPAddresses_struct,
  s_adapters_struct,
  s_socket_struct,
  s_network_struct);


rc = _initialize_IPAddresses_struct(s_IPAddresses_struct); if (rc != RC_SUCCESS) {rc = RC_WARNING;}
rc = _initialize_adapters_struct(s_adapters_struct);         if (rc != RC_SUCCESS) {rc = RC_WARNING;}
rc = _initialize_socket_struct(s_socket_struct);               if (rc != RC_SUCCESS) {rc = RC_WARNING;}
rc = _initialize_network_struct(s_network_struct);           if (rc != RC_SUCCESS) {rc = RC_WARNING;}



#include "include/common.cuh"
#include "include/get_systemQuery_cpu.cuh"
#include "include/get_deviceQuery_gpu.cuh"
#include "include/common_krnl.cuh"
#include "include/testing_unitTest.cuh"

//Time related includes
#include <time.h>


if (s_unitTest->launch_unitTest_networks == 1) {
//p_UnitTest_o->testing_Network(p_network_o, p_sockets_o, s_network_struct, s_socket_struct);
}


//#include <cuda_device_runtime_api.h>


/*

int global::_initialize_IPAddresses_struct(IPAddresses_struct *s_IPAddresses) {
  int rc = RC_SUCCESS;
//TODO: initialize global::_initialize_IPAddresses_struct(IPAddresses_struct *s_IPAddresses_struct)
  s_IPAddresses->nIPs = 1;
  s_IPAddresses->ithIPIndex = 1;

  s_IPAddresses->current_ipv4_string      = (char*) malloc((DEFAULT_MINIMUM_ENTITIES+4)*sizeof(char));
  strcpy(s_IPAddresses->current_ipv4_string, "001.002.003.004");
  s_IPAddresses->current_ipv4_ul = 123456789;

  s_IPAddresses->current_ipv6_string      = (char*) malloc((DEFAULT_MINIMUM_ENTITIES+4)*sizeof(char));
  strcpy(s_IPAddresses->current_ipv6_string, "fe80::1aa2:345f:678b:1234%13");
  s_IPAddresses->current_ipv6_ul = 111112222;

  s_IPAddresses->current_Mask_string      = (char*) malloc((DEFAULT_MINIMUM_ENTITIES+4)*sizeof(char));
  strcpy(s_IPAddresses->current_Mask_string, "005.055.555.0");
  s_IPAddresses->current_Mask_ul = 123456789;

  s_IPAddresses->current_BCastAddr_string      = (char*) malloc((DEFAULT_MINIMUM_ENTITIES+4)*sizeof(char));
  strcpy(s_IPAddresses->current_BCastAddr_string, "006.007.008.009");
  s_IPAddresses->current_BCastAddr_ul = 12;

  s_IPAddresses->current_ReassemblySize_string      = (char*) malloc((DEFAULT_MINIMUM_ENTITIES+4)*sizeof(char));
  strcpy(s_IPAddresses->current_ReassemblySize_string, "201.202.000.000");
  s_IPAddresses->current_ReassemblySize_ul = 123456;

  s_IPAddresses->current_unused1_string      = (char*) malloc((DEFAULT_MINIMUM_ENTITIES+4)*sizeof(char));
  strcpy(s_IPAddresses->current_unused1_string, "01.02.00.00");
  s_IPAddresses->current_unused1_us = 32;

  s_IPAddresses->current_Type_string      = (char*) malloc((DEFAULT_MINIMUM_ENTITIES+4)*sizeof(char));
  strcpy(s_IPAddresses->current_Type_string, "1.2.0.0");
  s_IPAddresses->current_Type_us = 15;

  s_IPAddresses->current_adapter_name_Desc     = (char*) malloc((MAX_ADAPTER_NAME_LENGTH+4)*sizeof(char));
  strcpy(s_IPAddresses->current_adapter_name_Desc, "Some Description");
  s_IPAddresses->current_adapter_name_uuid     = (char*) malloc((MAX_ADAPTER_NAME_LENGTH+4)*sizeof(char));
  strcpy(s_IPAddresses->current_adapter_name_uuid, "1234AAAA-BBBB-1234-CCCC-D56789EEEEE1");
  //The arrays are initilized on the fly
  return rc;
}  /* end of _initialize_IPAddresses_struct method */
/*
int global::_initialize_adapters_struct(adapters_struct *s_adapters) {
  int rc = RC_SUCCESS;
  //TODO: initialze global::_initialize_adapters_struct(adapters_struct *s_adapters_struct)
  //#define MAX_ADAPTER_DESCRIPTION_LENGTH  128 // arb.
  //#define MAX_ADAPTER_NAME_LENGTH         256 // arb.
  //#define MAX_ADAPTER_ADDRESS_LENGTH      8   // arb.
  //#define DEFAULT_MINIMUM_ENTITIES        32  // arb.
  //#define MAX_HOSTNAME_LEN                128 // arb.
  //#define MAX_DOMAIN_NAME_LEN             128 // arb.
  //#define MAX_SCOPE_ID_LEN                256 // arb.
  //#define MAX_DHCPV6_DUID_LENGTH          130 // RFC 3315.
  //#define MAX_DNS_SUFFIX_STRING_LENGTH    256


  s_adapters->nAdapters             = 1;
  s_adapters->adapter_name_raw      = (char*) malloc((DEFAULT_MINIMUM_ENTITIES+4)*sizeof(char));
  strcpy(s_adapters->adapter_name_raw, "000001AAAA23B4C5");
  s_adapters->adapter_name_uuid     = (char*) malloc((MAX_ADAPTER_NAME_LENGTH+4)*sizeof(char));
  strcpy(s_adapters->adapter_name_uuid, "1234AAAA-BBBB-1234-CCCC-D56789EEEEE1");
  s_adapters->adapter_index         = 1101;
#if defined (WINDOWS)
  s_adapters->ComboIndex            = 1102;
  //char               AdapterName[MAX_ADAPTER_NAME_LENGTH + 4];
  //char               Description[MAX_ADAPTER_DESCRIPTION_LENGTH + 4];
  s_adapters->AddressLength         = 1234;
  //unsigned char      Address[MAX_ADAPTER_ADDRESS_LENGTH];
  s_adapters->Index                 = 5678 ;
  s_adapters->Type_ui               = 201;
  s_adapters->Type_char             = (char*) malloc((MAX_ADAPTER_DESCRIPTION_LENGTH+4)*sizeof(char));
  strcpy(s_adapters->Type_char, "Some Connector");
  s_adapters->DhcpEnabled_ui        = 202;
  s_adapters->DhcpEnabled_char      = (char*) malloc((DEFAULT_MINIMUM_ENTITIES+4)*sizeof(char));
  strcpy(s_adapters->DhcpEnabled_char, "No");
  s_adapters->LeaseObtained_char    = (char*) malloc((DEFAULT_MINIMUM_ENTITIES+4)*sizeof(char));
  strcpy(s_adapters->LeaseObtained_char,"Sat Jan 01 11:20:27 1900");
  s_adapters->LeaseExpires_char     = (char*) malloc((DEFAULT_MINIMUM_ENTITIES+4)*sizeof(char));
  strcpy(s_adapters->LeaseExpires_char, currentDateTime().c_str());
  //my_PIP_ADDR_STRING CurrentIpAddress;
  //my_IP_ADDR_STRING  IpAddressList;
  //my_IP_ADDR_STRING  GatewayList;
  //my_IP_ADDR_STRING  DhcpServer;
  s_adapters->HaveWins_int          = 0;
  s_adapters->HaveWins_char         = (char*) malloc((DEFAULT_MINIMUM_ENTITIES+4)*sizeof(char));
  strcpy(s_adapters->HaveWins_char, "No");
  //my_IP_ADDR_STRING  PrimaryWinsServer;
  //my_IP_ADDR_STRING  SecondaryWinsServer;
  //time_t             LeaseObtained;
  //time_t             LeaseExpires;
#endif
  return rc;
}  /* end of _initialize_adapters_struct method */
/*
int global::_initialize_socket_struct(socket_struct *s_socket) {
  int rc = RC_SUCCESS;
  //TODO: initialize global::_initialize_socket_struct(socket_struct *s_socket_struct)
  return rc;
} /* end of _initialize_socket_struct method */
/*
int global::_initialize_network_struct(network_struct *s_network) {
  int rc = RC_SUCCESS;
  s_network->nVLAN = 1;
  s_network->a = 1;
  s_network->b = 2;
  s_network->c = 3;
  s_network->d  = 4;
  s_network->ipAddrString = 12345678;
  s_network->network_name     = (char*) malloc((DEFAULT_MINIMUM_ENTITIES+4)*sizeof(char));
  strcpy(s_network->network_name, "some netrwork name");
  s_network->network_type     = (char*) malloc((DEFAULT_MINIMUM_ENTITIES+4)*sizeof(char));
  strcpy(s_network->network_type, "some network type");
  s_network->VLAN = 1;
  //TODO: here inssert trhe initiailisation of the std::vector<std::string, std::string> *network_scan_result;

  return rc;
} /* end of _initialize_network_struct method */




int testing_UnitTest::testing_Network(namespace_Network::Network *p_network_o, namespace_Network::Socket *p_sockets_o, network_struct *net, socket_struct *sokt) {
    int rc = RC_SUCCESS;
    // testing the network data structure populator
    rc = testing_Network_populator(p_network_o, net); if (rc != RC_SUCCESS){rc = RC_WARNING;}
    // testing the socket data structure populator
    rc = testing_Socket_populator(p_sockets_o, sokt); if (rc != RC_SUCCESS){rc = RC_WARNING;}
    return rc;
} /* end of testing_network method */
int testing_UnitTest::testing_Socket_populator(namespace_Network::Socket *p_sockets_o, socket_struct *sokt) {
    int rc = RC_SUCCESS;
    return rc;
} /* end of testing_Socket method */
int testing_UnitTest::testing_Network_populator(namespace_Network::Network *p_network_o, network_struct *net) {
    int rc = RC_SUCCESS;
    return rc;
} /* end of testing_Socket method */







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




