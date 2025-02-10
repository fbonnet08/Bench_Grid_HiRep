//
// Created by Frederic on 12/14/2023.
//
/*
#include <math.h>
#include <ctype.h>
#include <stddef.h>
#include <math.h>
#include <stdbool.h> //TODO: check inm case it does not compile under MacOsX
*/

int _initialize_IPAddresses_struct(IPAddresses_struct* s_IPAddresses);
int _initialize_adapters_struct(adapters_struct* s_adapters);
int _initialize_socket_struct(socket_struct* s_socket);
int _initialize_network_struct(network_struct* s_network);

/* apodisation structure */
/* typedef struct apodisation {} apodisation_t; */


typedef struct network_struct {
    int nVLAN;
    unsigned char a,b,c,d;
    unsigned int ipAddrString;
    char *network_name;
    char *network_type;
    int VLAN;
    char *VLAN_name;
    //std::vector<std::string, std::string> *p_v_network_scan_result;

    std::vector<std::pair<std::string, std::string>> *p_v_network_scan_result;


    char **array_network_scan_result;
} network_struct_t;

typedef struct socket_struct {
    struct socket_struct* Next;
    int *socket_number; // here for each IP get the sockets


} socket_struct_t;

typedef struct IPAddresses_struct {
    int nIPs;
    int ithIPIndex;
    char *current_ipv4_string;
    unsigned long current_ipv4_ul;
    char *current_ipv6_string;
    unsigned long current_ipv6_ul;
    char *current_Mask_string;
    unsigned long current_Mask_ul;
    char *current_BCastAddr_string;
    unsigned long current_BCastAddr_ul;
    char *current_ReassemblySize_string;
    unsigned long current_ReassemblySize_ul;
    char *current_unused1_string;
    unsigned short current_unused1_us;
    char *current_Type_string;
    unsigned short current_Type_us;
    char *current_adapter_name_uuid;
    char *current_adapter_name_Desc;
    //std::vector<std::string> array_ipv4;
    //TODO: replace this char ** kwith vectors later once hte mapping is worked out
    char **ip_address_ipv4_array;
    unsigned long *array_ipv4_ul;
    char **ip_address_mask_array;
    unsigned long *array_mask_ul;
    char **ip_address_BCastAddr_array;
    unsigned long *array_BCastAddr_ul;
    char **ip_address_ReassemblySize_array;
    unsigned long *array_ReassemblySize_ul;
    char **ip_address_unused1_array;
    unsigned short *array_unused1_us;
    char **ip_address_Type_array;
    unsigned short *array_Type_us;
    char **ip_address_ipv6_array;
    unsigned long *array_ipv6_ul;
    char **adapter_name_uuid_array;
    char **adapter_name_Desc_array;
} IPAddresses_struct_t;

typedef struct {
    char *String; //[4 * 4];
}my_IP_ADDRESS_STRING, *my_PIP_ADDRESS_STRING, my_IP_MASK_STRING, *my_PIP_MASK_STRING;//IP_ADDRESS_STRING, *PIP_ADDRESS_STRING, IP_MASK_STRING, *PIP_MASK_STRING;

typedef struct my_IP_ADDR_STRING {
    struct my_IP_ADDR_STRING* Next; //IP_ADDRESS_STRING IpAddress; //IP_MASK_STRING IpMask;
    my_IP_ADDRESS_STRING IpAddress;
    my_IP_MASK_STRING IpMask;
    unsigned long Context;
} my_IP_ADDR_STRING, *my_PIP_ADDR_STRING;



typedef struct adapters_struct {
    int nAdapters;
    char *adapter_name_raw;
    char *adapter_name_uuid;
    int adapter_index;
#if defined (WINDOWS)
    unsigned long      ComboIndex;
    char               AdapterName[MAX_ADAPTER_NAME_LENGTH + 4];
    char               Description[MAX_ADAPTER_DESCRIPTION_LENGTH + 4];
    unsigned int       AddressLength;
    unsigned char      Address[MAX_ADAPTER_ADDRESS_LENGTH];
    unsigned long      Index;
    unsigned int       Type_ui;
    char              *Type_char;
    unsigned int       DhcpEnabled_ui;
    char              *DhcpEnabled_char;
    char              *LeaseObtained_char;
    char              *LeaseExpires_char;
    my_PIP_ADDR_STRING my_CurrentIpAddress;
    my_IP_ADDR_STRING  my_IpAddressList;
    my_IP_ADDR_STRING  my_GatewayList;
    my_IP_ADDR_STRING  my_DhcpServer;
    int                HaveWins_int;
    char              *HaveWins_char;
    my_IP_ADDR_STRING  my_PrimaryWinsServer;
    my_IP_ADDR_STRING  my_SecondaryWinsServer;
    time_t             LeaseObtained;
    time_t             LeaseExpires;
    /*
  } IP_ADAPTER_INFO, *PIP_ADAPTER_INFO;
    */
    /*
    typedef struct _IP_ADAPTER_INFO {
    struct _IP_ADAPTER_INFO *Next;
    DWORD                   ComboIndex;
    char                    AdapterName[MAX_ADAPTER_NAME_LENGTH + 4];
    char                    Description[MAX_ADAPTER_DESCRIPTION_LENGTH + 4];
    UINT                    AddressLength;
    BYTE                    Address[MAX_ADAPTER_ADDRESS_LENGTH];
    DWORD                   Index;
    UINT                    Type;
    UINT                    DhcpEnabled;
    PIP_ADDR_STRING         CurrentIpAddress;
    IP_ADDR_STRING          IpAddressList;
    IP_ADDR_STRING          GatewayList;
    IP_ADDR_STRING          DhcpServer;
    BOOL                    HaveWins;
    IP_ADDR_STRING          PrimaryWinsServer;
    IP_ADDR_STRING          SecondaryWinsServer;
    time_t                  LeaseObtained;
    time_t                  LeaseExpires;
    } IP_ADAPTER_INFO, *PIP_ADAPTER_INFO;
    */
    /*
    printf("\tComboIndex  : \t%d\n", pAdapter->ComboIndex);
    printf("\tAdapter Name: \t%s\n", pAdapter->AdapterName);
    printf("\tAdapter Desc: \t%s\n", pAdapter->Description);
    printf("\tAdapter Addr: \t");
    printf("\tIndex: \t%d\n", pAdapter->Index);
    printf("\tType: \t");

    printf("\tIP Address: \t%s\n", pAdapter->IpAddressList.IpAddress.String);
    printf("\tIP Mask: \t%s\n", pAdapter->IpAddressList.IpMask.String);

    printf("\tGateway: \t%s\n", pAdapter->GatewayList.IpAddress.String);
    printf("\t***\n");

    printf("\tDHCP Enabled: Yes / No\n");
    printf("\t  DHCP Server: \t%s\n", pAdapter->DhcpServer.IpAddress.String);

    printf("\t  Lease Obtained: ");
    printf("\t  Lease Expires:  ");

    printf("\tHave Wins: Yes / No\n");
    printf("\t  Primary Wins Server:    %s\n", pAdapter->PrimaryWinsServer.IpAddress.String);
    printf("\t  Secondary Wins Server:  %s\n", pAdapter->SecondaryWinsServer.IpAddress.String);
  */
    unsigned long *array_ComboIndex_ul;
    char **array_AdapterName;
    char **array_AdapterDesc;
    char **array_AdapterIpAddr;
    char **array_MacAddress;
    char **array_Type;
    char **array_IpAddressList_ip;
    char **array_IpAddressList_mask;
    char **array_GatewayList_ip;
    char **array_GatewayList_mask;
    //DHCP stuff details
    char **array_DhcpEnabled_char;
    char **array_DhcpEnabled_server_ip;
    char **array_DhcpEnabled_LeaseObtained_char;
    char **array_DhcpEnabled_LeaseExpires_char;
#endif
} my_IP_ADAPTER_INFO, *my_PIP_ADAPTER_INFO, adapters_struct_t;
typedef struct {
    char *String;
} my_SOCKET_STRING;




#ifndef JUNK_CUH
#define JUNK_CUH

#pragma warning(push)
#pragma warning(disable:D9002)
#pragma warning(disable:#550-D)

//#pragma warning(pop)




#endif //JUNK_CUH
