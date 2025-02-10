
      //std::cout<<B_RED<<"                      result.size()---> "<<B_RED<<result.size()<<std::endl;


//if (std::string(s_adptrs->my_IpAddressList.IpAddress.String) == trim(std::string(s_mach->array_machines_ipv4[i]))){
//std::cout<<" -- - - >"<<s_adptrs->my_IpAddressList.IpAddress.String<<"!="<<trim(std::string(s_mach->array_machines_ipv4[i]))<<std::endl;

      std::cout<<B_RED<<"                      result.size()---> "<<B_RED<<result.size()<<std::endl;


std::cout<<B_RED<<"  result.size()          "<<result.size()<<COLOR_RESET<<std::endl;
      std::cout<<B_BLUE<<"result.size()                      ---> "<<B_RED<<result.size()<<std::endl;

    //s_network->p_v_network_scan_result = (std::vector<std::string, std::string>*)malloc(s_mach->nMachine_ipv4*sizeof(std::vector<std::string, std::string>));
    //s_network->p_v_network_scan_result<std::vector<std::string, std::string>[s_mach->nMachine_ipv4];
    //= (std::vector<std::string, std::string>*)malloc(s_mach->nMachine_ipv4*sizeof(std::vector<std::string, std::string>));

    // aloocating the memory for the string command

    //std::vector<std::string, std::string> *p_v_network_scan_result = new std::vector<std::string, std::string> [s_mach->nMachine_ipv4];

    //*s_network->array_network_scan_result =
    //        (char*)malloc(s_mach->nMachine_ipv4*sizeof(char*));




      //}





      //s_network->p_v_network_scan_result
/*
      std::vector<std::vector<int> > x(100, std::vector<int>(100));
      std::vector<int> *x = new vector<int>[100];

*/
/*
      s_network->array_network_scan_result =
              (char**)malloc(s_mach->nMachine_ipv4*(MAX_IPV4_ADDRESS_LENGTH+4)*sizeof(char));
*/



s_mach->array_machines_ipv4[i]

// for this to work I need a enum list like I did else where maybe later
switch(get_string) {
  case "IPs":  delimiter = "Nmap scan report for"; break;
  case "MACs": delimiter = "MAC Address: "; break;
  default:     delimiter = "Nmap scan report for";
}

std::cout<<result<<std::endl;


std::cout<<v_ip_char.size()<<std::endl;
std::cout<<v_ip_char[0]<<" --- "<<v_ip_char[1]<<std::endl;



std::cout<<v_temp[i]<<std::endl;


std::string result = "";
char buffer[MAX_ADAPTER_NAME_LENGTH]; // MAX_ADAPTER_NAME_LENGTH         256 // arb.
std::vector<std::string> v_temp;
std::vector<std::string> v_ith_temp;
std::vector<std::string> v_ip_char;


//v_ip_char = split(v_temp[i],delimiter);
//std::cout<<buffer <<std::endl;
//printf("%s\n", result);


std::vector<std::string> res;

for (i = 0 ; i < v_temp.size() ; i++) {
    res = split(v_temp[i],delimiter);
}


//std::cout<<v_ip_char[i].erase(  remove( v_ip_char[i].begin(), v_ip_char[i].end(), ' ' ), v_ip_char[i].end()   )<<std::endl;
//v_temp[i].erase(std::remove_if(v_temp[i].begin(), v_temp[i].end(), ::isspace), v_temp[i].end()         );
//v_temp[i].erase(std::remove_if(v_temp[i].begin(), v_temp[i].end(), 'Nmapscanreportfor' ), v_temp[i].end()   );


// Creating a string containing multiple whitespaces.
std::string s = "\tHello \n World";

std::cout << "String s before removing whitespaces: " << s << std::endl << std::endl;

// Using the erase, remove_if, and ::isspace functions.
s.erase(std::remove_if(s.begin(), s.end(), ::isspace),
    s.end());

std::cout << "String s after removing whitespaces: " << s;

s.erase( remove( s.begin(), s.end(), ' ' ), s.end() );



FILE *pin = _popen(scan,"r");
 if ( pin ) {
      while (!feof(pin)) {
           const char *line = readLine(pin);
printf("%s\n", line);
        }
      _pclose(pin);
   }






char line[MAX_ADAPTER_NAME_LENGTH]; // MAX_ADAPTER_NAME_LENGTH         256 // arb.
/* Open the command for reading. */
//sprintf(line, "%s %s", APP_SIGN, dstfilename);
char sign[MAX_ADAPTER_NAME_LENGTH];

/* Read the output a line at a time - output it. */
if (fscanf(fp, "%s", sign) > 0) {
    printf("%s\n", sign);
    //LOG_PRINT(info_e,"SIGN: '%s'\n", sign);
}



/*------------------From the global class ----------------------------------------------------------------------------*/

//#include "include/common.cuh"
//#include "include/common_krnl.cuh"

//#include "src/Network.cuh"
//#include "include/Sockets.cuh"
//#include "include/resmap_Sizes.cuh"
//#include "include/get_systemQuery_cpu.cuh"

//#include "include/get_deviceQuery_gpu.cuh"
//#include "include/get_systemQuery_gpu.cuh"
//#include "include/Exception.cuh"
//#include "include/testing_unitTest.cuh"

/*--------------------------------------------------------------------------------------------------------------------*/

s_IPAddrs
//v_AdapterMACAddress.push_back(ss.str().substr(0,ss.str().length()-1));

adapterName.push_back(p_Adapter->AdapterName);
adapterDesc.push_back(p_Adapter->Description);
adapterIpAddr.push_back(p_Adapter->IpAddressList.IpAddress.String);
 string stream variable


v_DhcpEnabled_server_ip.push_back(p_Adapter->DhcpServer.IpAddress.String);


std::vector<std::string> adapterName;
std::vector<std::string> adapterDesc;
std::vector<std::string> adapterIpAddr;

// It is possible for an adapter to have multiple IPv4 addresses, gateways, and secondary WINS servers
// assigned to the adapter.

if (v_DhcpEnabled_server_ip.empty()) {v_DhcpEnabled_server_ip.}

v_AdapterMACAddress.push_back(ss.str().substr(0,ss.str().length()-1));


for (j = 0; j < s_adapters->nAdapters; j++) {
      if (v_DhcpEnabled_server_ip.size() <= s_adapters->nAdapters) {


        } else {

        }
      }

          //std::cout<<" "<<std::hex<<(int)p_Adapter->Address[i]<<" ";
                    //std::replace( s.begin(), s.end(), 'x', 'y'); // replace all 'x' to 'y'
          //ss.str().replace(ss.str().end()-1,ss.str().end(), "-","");

                    //ss.str().erase(ss.str().end()-1);
                    if (! ss.str().empty()) {
            std::cout<<v_result[0][v_result[0].length()-1]<<std::endl;



          }
//v_result[0][v_result[0].length()-1]
          //s4.replace(s4.end() - 7, s4.end(), "geeks from- here", 12);


// Display the data
std::vector<unsigned long>::iterator it;
for(it = s_adapters->v_ComboIndex.begin(); it != s_adapters->v_ComboIndex.end(); ++it)
  std::cout << *it;
std::cout<<B_BLUE<<"s_adapters->HaveWins               ---> "<<B_YELLOW<<s_adapters->array_ComboIndex_ul[i]<<std::endl;


std::vector<unsigned long>::iterator it;
for(it = v_ComboIndex.begin(); it != v_ComboIndex.end(); ++it)
    std::cout << *it << std::endl;
std::vector<std::string>::iterator itn;
for (itn = v_AdapterName.begin(); itn != v_AdapterName.end(); ++itn)
    std::cout<<*itn<<std::endl;
std::vector<std::string>::iterator itd;
for (itd = v_adapterDesc.begin(); itd != v_adapterDesc.end(); ++itd)
    std::cout<<*itd<<std::endl;


//std::cout<<v_result[0][v_result[0].length()-1]<<std::endl;
for (j = 0; j < v_result.size(); j++ ){ std::cout<<" "<<v_result[j] ;  }  std::cout<<std::endl;

//std::cout<<std::endl;
// 84  7b  eb  51  5a 3D
//printf("\tIndex: \t%d\n", p_Adapter->Index);



//std::stringstream sstream;
//sstream << std::hex << my_integer;
//std::string result = sstream.str();


std::cout<<typeid(p_Adapter->ComboIndex).name()<<std::endl;

s_adapters->v_ComboIndex.push_back(p_Adapter->ComboIndex);
s_adapters->v_AdapterName.push_back(p_Adapter->AdapterName);

std::vector<unsigned long> v_ComboIndex;
std::vector<std::string> v_AdapterName;
std::vector<std::string> v_AdapterDesc;
std::vector<std::string> v_AdapterIpAddr;



/*------------------Adapters_ClassTemplate_t(IPAddresses_struct *s_IPAddresses, adapters_struct *s_adapters)----------*/
template <typename T, typename S> std::string Adapters_ClassTemplate_t<T,S>::decimalToBinary_32bit(unsigned long n, int base) {
    std::string binary = "";
    int rc = RC_SUCCESS;
    unsigned long arr[32]; int i = 0; // num = n;
    int npad = 0;
    std::string pad_string = "0";
    std::string::iterator it;

    while(n != 0) {
        arr[i] = n % base;
        i++;
        n = n / base;
    }
    for(i = i - 1; i >= 0;i--){ binary += std::to_string(arr[i]); }

    npad = 0;
    if (binary.size() < 32 ) {
        npad = 32 - binary.size();
        std::cout<<std::endl<<" binary.size() < 32 ===> "<< binary.size()<< " so padding by ===> " << npad<<std::endl;
        binary.insert (0, npad, '0');
    } else if (binary.size() == 32) {
        std::cout<<std::endl<<" binary.size() = 32 ===> "<< binary.size()<< " so padding by ===> " << npad<<std::endl;
    }
    return binary;
} /* end of decimalToBinary_32bit method */

template <typename T, typename S> std::string Adapters_ClassTemplate_t<T,S>::convertBinaryToASCII_IP_32bit(std::string binary) {
    std::string ip = "";
    std::vector<std::string> ret;
    std::vector<std::string> sub_ip;
    std::string full_ip = "etst";

    int k = 0, j = 0, l = 0;
    int splitlength = 8;
    int sum = 0;

    int numsubstrings = binary.length() / splitlength;
    std::cout<<" binary          ---> "<<binary<<std::endl;
    std::cout<<" binary.length() ---> "<<binary.length()<<std::endl;
    std::cout<<" numsubstrings   ---> "<<numsubstrings<<std::endl;

    for (auto i = 0; i < numsubstrings; i++) {
        ret.push_back(binary.substr(i * splitlength, splitlength));
    }

    // if there are leftover characters, create a shorter item at the end.
    if (binary.length() % splitlength != 0) {
        ret.push_back(binary.substr(splitlength * numsubstrings));
    }

    for (auto i = 0 ; i < ret.size() ; i++ ) {
        std::cout<<"binary           ---> " << ret[i]; //<<std::endl;

        k= splitlength - 1;;
        sum = 0;
        l = 0;
        for (j = ret[i].size() - 1 ; j >= 0 ; j--) {
            //std::cout<< " ||| ret["<<i<<"]"<<"["<<l<<"] --> "<<ret[i][l]<<" k = "<< k <<" ";
            if ( ret[i][l]  == '1' ) { sum += pow(2,k); }
            k--; l++;
        }
        std::cout<< " ---- decimal ---> " << sum <<std::endl;
        sub_ip.push_back(std::to_string(sum));
    }
    //for (k = 0 ; k < sub_ip.size() ; k++) {std::cout<< " sub_ip["<<k<<"]: --> " << sub_ip[k]<< std::endl;}

    // now constructing the IP string name for each ip addresses
    // full IPv4 IP adress
    full_ip = sub_ip[3]+"."+sub_ip[2]+"."+sub_ip[1]+"."+sub_ip[0];

    return full_ip;
} /* end of convertBinaryToASCII_IP_32bit method */

/*
* code developped in the clang compiler tool chain (Windows)
* remove [ template <typename T, typename S> std::string Adapters_ClassTemplate_t<T,S>:: ]
* when there is no class declaration and no header file
* make sure to have the correct include statements in the compilation tool chain
* the methods must be above the main
* compliation et execution g++ ou cle.exe fichier.cpp -o out.exe
* $> g++ fichier.cpp -o out.exe
* $> ./out.exe
*/
#include <stdio.h>
#include <vector>
#inlcude <iostream>
#include <string.h>
int main () {
    std::string ip = "Some.IP.000.000";
    unsigned long n = 369207488;
    // Calling the converters:
    // replace s_IPAddrs->current_Mask_ul with a decimal ex: n = 369207488
    // 2: base 2
    ip = convertBinaryToASCII_IP_32bit(decimalToBinary_32bit(s_IPAddrs->current_Mask_ul,2));
    std::cout<<" IPv4 address: ---> "<<ip<<std::endl;
} /* end of main */


/*--------------------------------------------------------------------------------------------------------------------*/



IPAddr.S_un.S_addr = (u_long) p_IPAddrTable->table[0].dwBCastAddr;
s_IPAddrs->current_BCastAddr_string = inet_ntoa(IPAddr);

IPAddr.S_un.S_addr = (u_long) p_IPAddrTable->table[0].dwReasmSize;
s_IPAddrs->current_ReassemblySize_string = inet_ntoa(IPAddr);

IPAddr.S_un.S_addr = (u_short) p_IPAddrTable->table[0].unused1;
s_IPAddrs->current_unused1_string = inet_ntoa(IPAddr);

IPAddr.S_un.S_addr = (u_short) p_IPAddrTable->table[0].wType;
s_IPAddrs->current_Type_string = inet_ntoa(IPAddr);




for (int j = 0 ; j < ip.size() ; j++) {
    std::cout<< ip[j];//<<" ";
    ip_tmp[j] = ip[j];
    //s_IPAddrs->ip_address_ipv4_array[i] += ip[j];
}
std::cout<<std::endl;



size_t x = columns[column];
size_t y = rows[row];
int desired_value = distances[x + y * columns.size()];

        std::string str1 ( "Hello World" );

std::basic_string <char>::iterator str_Iter;
char array1 [ 20 ] = { 0 };
char array2 [ 10 ] = { 0 };
std::basic_string <char>:: pointer array1Ptr = array1;
std::basic_string <char>:: value_type *array2Ptr = array2;

std::cout << "The original string str1 is: ";
for ( str_Iter = str1.begin( ); str_Iter != str1.end( ); str_Iter++ )
    std::cout << *str_Iter;
std::cout << std::endl;

std::basic_string <char>:: size_type nArray1;
// Note: string::copy is potentially unsafe, consider
// using string::_Copy_s instead.
nArray1 = str1.copy ( array1Ptr , 12 );  // C4996
std::cout << "The number of copied characters in array1 is: "
     << nArray1 << std::endl;
std::cout << "The copied characters array1 is: " << array1 << std::endl;

std::basic_string <char>:: size_type nArray2;
// Note: string::copy is potentially unsafe, consider
// using string::_Copy_s instead.
nArray2 = str1.copy ( array2Ptr , 5 , 6  );  // C4996
std::cout << "The number of copied characters in array2 is: "
        << nArray2 << std::endl;
std::cout << "The copied characters array2 is: " << array2Ptr << std::endl;


The original string str1 is: Hello World
The number of copied characters in array1 is: 11
The copied characters array1 is: Hello World
The number of copied characters in array2 is: 5
The copied characters array2 is: World



// Converting decimals to IP addresses
ip = convertBinaryToASCII_IP_32bit(decimalToBinary_32bit(s_IPAddrs->array_ipv4_ul[i],2));
ip.push_back('\0'); // to get rud of the junk at the end of string what a pain that was!!

s_IPAddrs->ip_address_ipv4_array[i] = (char*)malloc(ip.size()*sizeof(char));
p_array_ipv4 = s_IPAddrs->ip_address_ipv4_array[i];
nArray_ipv4 = ip.copy ( p_array_ipv4 , ip.size(), 0 ); if (nArray_ipv4 < 1 ){rc = RC_FAIL;}

printf("\tIP Address:       \t%s (%lu%)\n", s_IPAddrs->current_ipv4_string, s_IPAddrs->current_ipv4_ul);
printf("\tIP Address:       \t%s (%lu%)\n", s_IPAddrs->ip_address_ipv4_array[i], s_IPAddrs->current_ipv4_ul);



printf("\tIP Address [%i]                 --->: \t%s (%lu%)\n",i,  s_IPAddrs->array_ipv4[i], p_IPAddrTable->table[i].dwAddr);

if (i = 0 ){strcpy(s_IPAddrs->current_ipv4_string , ip.c_str());}


std::cout<<B_BLUE<<"s_IPAddresses->ithIPIndex          ---> "<<B_YELLOW<<s_IPAddresses->ip_address_ipv4_array[i]<<std::endl;
std::cout<<s_IPAddrs->ip_address_ipv4_array[i]<<std::endl;

std::cout<<B_BLUE<<"s_IPAddresses->ip_address_mask_array["<<B_GREEN<<i<<B_BLUE"] ---> "<<B_YELLOW<<s_IPAddrs->ip_address_mask_array[i]<<B_BLUE" ("<<B_MAGENTA<<s_IPAddrs->array_mask_ul[i]<<B_BLUE")"<<std::endl;
std::cout<<B_BLUE<<"s_IPAddresses->array_ipv4["<<B_GREEN<<i<<B_BLUE"]            ---> "<<B_YELLOW<<s_IPAddrs->array_ipv4[i]<<B_BLUE" ("<<B_MAGENTA<<s_IPAddrs->array_ipv4_ul[i]<<B_BLUE")"<<std::endl;



std::cout<<" IP: "<<s_IPAddrs->ip_address_ipv4_array[0]<<" Mask: "<<s_IPAddrs->ip_address_mask_array[0]<<" BCastAddr: "<<s_IPAddrs->ip_address_BCastAddr_array[0]<<" ReassemblySize: "<<s_IPAddrs->ip_address_ReassemblySize_array[0]<< " unused1: "<<s_IPAddrs->ip_address_unused1_array[0]<<" Type: "<<s_IPAddrs->ip_address_Type_array[0]<<std::endl;
std::cout<<" IP: "<<s_IPAddrs->ip_address_ipv4_array[1]<<" Mask: "<<s_IPAddrs->ip_address_mask_array[1]<<std::endl;
std::cout<<" IP: "<<s_IPAddrs->ip_address_ipv4_array[2]<<" Mask: "<<s_IPAddrs->ip_address_mask_array[2]<<std::endl;





//strcpy(s_IPAddrs->ip_address_ipv4_array[i] , ip.c_str());//inet_ntoa((IPAddr));
char *ip_tmp = (char*)malloc(ip.size()* sizeof(char));

std::cout<<" ip                                          ---> "<<ip<<std::endl;
std::cout<<" typeid(ip)                                  ---> "<< typeid(ip).name()<<std::endl;
std::cout<<" typeid(ip.c_str())                          ---> "<< typeid(ip.c_str()).name()<<std::endl;
std::cout<<" typeid(s_IPAddrs->ip_address_ipv4_array[i]) ---> "<< typeid(s_IPAddrs->ip_address_ipv4_array[i]).name()<<std::endl;
std::cout<<" ip.size():                                  ---> "<<ip.size()<<std::endl;
std::cout<<" ip[0]                                       ---> "<< ip[0] << std::endl;
std::string str1 ( "Hello World" );
std::cout<<" typeid(str1)                                ---> "<< typeid(str1).name()<<std::endl;


//192.168.1.22��������
//192.168.56.1��������

//std::basic_string <char>:: value_type *array2Ptr = array2;



// C4996
std::cout << "The number of copied characters in array1 is: " << nArray1 << std::endl;
std::cout << "The copied characters array1 is: " << s_IPAddrs->ip_address_ipv4_array[i] << std::endl;


// Note: string::copy is potentially unsafe, consider
// using string::_Copy_s instead.






        //strncpy(s_IPAddrs->current_ipv4_string, ip.c_str(), ip.size()-1 );
        //s_IPAddrs->array_ipv4.push_back(ip) ;
/*
        std::cout<<" typeid(ip_tmp)                              ---> "<< typeid(ip_tmp).name()<<std::endl;
        std::cout<<" typeid(\"123.345.567.890\")                   ---> "<< typeid("123.345.567.890").name()<<std::endl;
        std::cout<<" typeid(ip)                                  ---> "<< typeid(ip).name()<<std::endl;
                std::cout<<" typeid(ip.c_str())                          ---> "<< typeid(ip.c_str()).name()<<std::endl;
                std::cout<<" typeid(s_IPAddrs->ip_address_ipv4_array[i]) ---> "<< typeid(s_IPAddrs->ip_address_ipv4_array[i]).name()<<std::endl;
        */

        //strcpy(s_IPAddrs->ip_address_ipv4_array[i] , ip_tmp);
        //strcpy(s_IPAddrs->ip_address_ipv4_array[i] , "s");

    //fflush(stdout);
//if (p_IPAddrTable) FREE(p_IPAddrTable);


// Nowe getting the interface information from the intrinsic method

// Make an initial call to GetInterfaceInfo to get
// the necessary size in the ulOutBufLen variable
dw_RetVal = GetInterfaceInfo(NULL, &outBuffLen_ul);
std::cout<<"outBuffLen_ul --> "<<outBuffLen_ul<<", dwRetVal --> "<<dw_RetVal<<std::endl;

if (dw_RetVal == ERROR_INSUFFICIENT_BUFFER) {
    p_interface_info = (IP_INTERFACE_INFO*)MALLOC(outBuffLen_ul);
    if (p_interface_info == NULL) {
        printf ("Unable to allocate memory needed to call GetInterfaceInfo\n");
        rc = RC_FAIL;
    }
}


// Make a second call to GetInterfaceInfo to get
// the actual data we need
dw_RetVal = GetInterfaceInfo(p_interface_info, &outBuffLen_ul);
if (dw_RetVal == NO_ERROR) {
    std::cout<<B_BLUE<<"Number of Adapters --> "<<B_MAGENTA<<p_interface_info->NumAdapters<<B_BLUE<<" ---> dwRetVal --> "<<B_GREEN<<dw_RetVal<<std::endl;
    s_adapters_struct->nAdapters = p_interface_info->NumAdapters;
    for (int i =0; i < p_interface_info->NumAdapters; i++ ) {
        std::cout<<B_BLUE<<"Adapter Index["<<B_GREEN<<i<<B_BLUE<<"] ---> : "<<B_MAGENTA<<p_interface_info->Adapter[i].Index<<COLOR_RESET<<std::endl;
        std::cout<<B_BLUE<<"Adapter  Name["<<B_GREEN<<i<<B_BLUE<<"] ---> : "<<B_MAGENTA<<p_interface_info->Adapter[i].Name<<COLOR_RESET<<std::endl;
        printf(B_BLUE"Adapter  Name[");printf(B_GREEN"%d",i);printf(B_BLUE"] ---> : ");printf(B_MAGENTA"%ws\n",p_interface_info->Adapter[i].Name);
        std::cout<<COLOR_RESET<<std::endl;
    }
    rc = RC_SUCCESS;
} else if (dw_RetVal == ERROR_NO_DATA) {
    printf
        ("There are no network adapters with IPv4 enabled on the local system\n");
    rc = RC_SUCCESS;
} else {
    printf("GetInterfaceInfo failed with error: %d\n", dw_RetVal);
    rc = RC_FAIL;
}
FREE(p_interface_info);











fflush(stdout);

IPAddr.S_un.S_addr = (u_long) p_IPAddrTable->table[i].dwAddr;
IPAddr.S_un.S_addr = (u_long) p_IPAddrTable->table[i].dwMask;

printf("\tIP Address:       \t%s (%lu%)\n", inet_ntoa(IPAddr), p_IPAddrTable->table[i].dwAddr);
std::cout<<"pIPAddrTable->table["<<i<<"].dwAddr ---> = "<<inet_ntoa(IPAddr)<< " IPAddr.S_un.S_addr ---> "<<IPAddr.S_un.S_addr<<std::endl;

s_IPAddrs->ip_address_ipv4_array[i] = inet_addr(IPAddr.S_un.S_addr);//  "s";


std::cout<<s_IPAddrs->ip_address_ipv4_array[i]<<std::endl;

std::string binaryIP = decimalToBinary_32bit(s_IPAddrs->array_ipv4_ul[i],2);   //IPAddr.S_un.S_addr, 2);
std::string ip = convertBinaryToASCII_IP_32bit(binaryIP);

std::string binaryIP = decimalToBinary_32bit(s_IPAddrs->array_ipv4_ul[i],2);   //IPAddr.S_un.S_addr, 2);






std::cout<<" IPAddr "<<&IPAddr<<"  IPAddr.S_un.S_addr: "<<IPAddr.S_un.S_addr <<std::endl;



dw_Size_tmp = dw_Size;

std::cout<<B_BLUE<<"dw_Size_tmp (@after second call)   ---> "<<B_MAGENTA<<dw_Size<<COLOR_RESET<<std::endl;
p2_IPAddrTable = (MIB_IPADDRTABLE *) MALLOC(sizeof (MIB_IPADDRTABLE));

if ((dw_RetVal = GetIpAddrTable(p2_IPAddrTable, &dw_Size_tmp, 0)) == NO_ERROR) {
    /*
            IPAddr.S_un.S_addr = (u_long) p2_IPAddrTable->table[0].dwMask;
            s_IPAddrs->current_Mask_string = inet_ntoa(IPAddr);
            s_IPAddrs->current_Mask_ul = p2_IPAddrTable->table[0].dwMask;
            printf("\tSubnet Mask:      \t%s (%lu%)\n", inet_ntoa(IPAddr), p2_IPAddrTable->table[0].dwMask);
    */

} else {
    printf("Call to GetIpAddrTable failed with error %d.\n", dw_RetVal);
    if (p2_IPAddrTable) FREE(p2_IPAddrTable);
    exit(RC_FAIL);
}
//fflush(stdout);
/*
IPAddr.S_un.S_addr = (u_long) p_IPAddrTable->table[0].dwBCastAddr;
s_IPAddrs->current_BCastAddr_string = inet_ntoa(IPAddr);
s_IPAddrs->current_BCastAddr_ul = p_IPAddrTable->table[0].dwBCastAddr;
printf("\tBroadCast Address:\t%s (%lu%)\n", inet_ntoa(IPAddr), p_IPAddrTable->table[0].dwBCastAddr);

IPAddr.S_un.S_addr = (u_long) p_IPAddrTable->table[0].dwReasmSize;
s_IPAddrs->current_ReassemblySize_string = inet_ntoa(IPAddr);
s_IPAddrs->current_ReassemblySize_ul = p_IPAddrTable->table[0].dwReasmSize;
printf("\tReassembly size:  \t%s (%lu)\n", inet_ntoa(IPAddr), p_IPAddrTable->table[0].dwReasmSize);

IPAddr.S_un.S_addr = (u_short) p_IPAddrTable->table[0].unused1;
s_IPAddrs->current_unused1_string = inet_ntoa(IPAddr);
s_IPAddrs->current_unused1_us = p_IPAddrTable->table[0].unused1;
printf("\tUnused1 Address:  \t%s (%lu%)\n", inet_ntoa(IPAddr), p_IPAddrTable->table[0].unused1);
*/



template <typename T, typename S> std::string Adapters_ClassTemplate_t<T,S>::decimalToBinary_32bit(int n, int base) {
    std::string ip = "";
    int arr[32], i = 0, num = n;

    // Until the value of n becomes 0.
    while(n != 0){
        arr[i] = n % 2;
        i++;
        n = n / 2;
    }
    std::cout << num << " in Binary is ";

    // Printing the array in Reversed Order.
    for(i = i - 1; i >= 0;i--){
        std::cout << arr[i];
    }
    std::cout << std::endl;
    return ip;
}

//ret[i].size()


//std::cout<<typeid(ret[i][j]).name()<<std::endl;


//printf(" sum %i ", sum);


//std::cout << std::endl;
std::cout <<"Binary IP in string format is --->: ";
std::cout << std::setw(32) << std::setfill('0')<< binary << " !--->! (Inverted string:  d.c.b.a ==> a.b.c.d)"<<std::endl;



splitlength - 1;



template <typename T, typename S> std::string Adapters_ClassTemplate_t<T,S>::decimalToBinary_32bit(int n, int base) {
    std::string binary = "";
    int rc = RC_SUCCESS;
    int arr[32], i = 0, num = n;

    //int len = *(&arr + 1) - arr;
    //std::cout << "length of array : "<<len << std::endl;

    // first initialise the array to 0
    //for (i = 0 ; i < ( len + 1 ) ; i++) { arr[i] = 0; }

    // Until the value of n becomes 0.
    while(n != 0) {
        arr[i] = n % base;
        i++;
        //std::cout << " n "<< n << std::endl;;
        //std::cout << " arr["<<i<<"] "<< arr[i] << std::endl;;
        n = n / base;
        //std::cout << " n "<< n << std::endl;;
    }
    //std::cout << num << " in Binary is ";

    // Printing the array in Reversed Order.
    //std::cout.fill('0');
    //std::setw(32);
    for(i = i - 1; i >= 0;i--){
        //std::cout << arr[i];
        binary += std::to_string(arr[i]);
    }
    //std::cout << std::endl;
    std::cout <<"Binary IP in string format is ---> ";
    std::cout << std::setw(32) << std::setfill('0')<< binary << std::endl;
    return binary;
}




/*------------------Adapters_ClassTemplate_t(IPAddresses_struct *s_IPAddresses, adapters_struct *s_adapters)----------*/


    template <typename T, typename S> Adapters_ClassTemplate_t<T,S>::Adapters_ClassTemplate_t(IPAddresses_struct *s_IPAddresses, adapters_struct *s_adapters) {
        int rc = RC_SUCCESS;


    std::cout<<"START IMPLEMENMTING HERE THE NETWORK CLASS"
           "(Network_ClassTemplate_t<T,S>::Network_ClassTemplate_t(network_struct *s_network)) ....."<<std::endl;
    std::cout<<B_B_RED<<" s_adapters->nAdapters ---> "<<B_B_MAGENTA<<s_adapters->nAdapters<<COLOR_RESET<<std::endl;
        /* Variables used by GetIpAddrTable */
        PMIB_IPADDRTABLE pIPAddrTable;
        DWORD dwSize = 0;
        DWORD dwRetVal = 0;
        IN_ADDR IPAddr;
        DWORD ifIndex;


        // Before calling AddIPAddress we use GetIpAddrTable to get
        // an adapter to which we can add the IP.
        pIPAddrTable = (MIB_IPADDRTABLE *) MALLOC(sizeof (MIB_IPADDRTABLE));
        if (pIPAddrTable == NULL) {
            printf("Error allocating memory needed to call GetIpAddrTable\n");
            exit (1);
        } else {
            dwSize = 0;
            // Make an initial call to GetIpAddrTable to get the
            // necessary size into the dwSize variable
            if (GetIpAddrTable(pIPAddrTable, &dwSize, 0) == ERROR_INSUFFICIENT_BUFFER) {
                FREE(pIPAddrTable);
                pIPAddrTable = (MIB_IPADDRTABLE *) MALLOC(dwSize);
            }
            if (pIPAddrTable == NULL) {
                printf("Memory allocation failed for GetIpAddrTable\n");
                exit(1);
            }
        }
        // Make a second call to GetIpAddrTable to get the
        // actual data we want
        if ((dwRetVal = GetIpAddrTable(pIPAddrTable, &dwSize, 0)) == NO_ERROR) {
            // Save the interface index to use for adding an IP address
            ifIndex = pIPAddrTable->table[0].dwIndex;
            printf("\n\tInterface Index:\t%ld\n", ifIndex);
            s_IPAddresses->ithIPIndex = ifIndex;

            IPAddr.S_un.S_addr = (u_long) pIPAddrTable->table[0].dwAddr;
            std::cout<<" IPAddr "<<&IPAddr<<"  IPAddr.S_un.S_addr: "<<IPAddr.S_un.S_addr <<std::endl;
            s_IPAddresses->current_ipv4_string = inet_ntoa(IPAddr);
            s_IPAddresses->current_ipv4_ul = pIPAddrTable->table[0].dwAddr;
            printf("\tIP Address:       \t%s (%lu%)\n", inet_ntoa(IPAddr), pIPAddrTable->table[0].dwAddr);

            IPAddr.S_un.S_addr = (u_long) pIPAddrTable->table[0].dwMask;
            s_IPAddresses->current_Mask_string = (char*)inet_ntoa(IPAddr);
            s_IPAddresses->current_Mask_ul = pIPAddrTable->table[0].dwMask;
            printf("\tSubnet Mask:      \t%s (%lu%)\n", inet_ntoa(IPAddr), pIPAddrTable->table[0].dwMask);

            IPAddr.S_un.S_addr = (u_long) pIPAddrTable->table[0].dwBCastAddr;
            s_IPAddresses->current_BCastAddr_string = inet_ntoa(IPAddr);
            s_IPAddresses->current_BCastAddr_ul = pIPAddrTable->table[0].dwBCastAddr;
            printf("\tBroadCast Address:\t%s (%lu%)\n", inet_ntoa(IPAddr), pIPAddrTable->table[0].dwBCastAddr);

            IPAddr.S_un.S_addr = (u_long) pIPAddrTable->table[0].dwReasmSize;
            s_IPAddresses->current_ReassemblySize_string = inet_ntoa(IPAddr);
            s_IPAddresses->current_ReassemblySize_ul = pIPAddrTable->table[0].dwReasmSize;
            printf("\tReassembly size:  \t%s (%lu)\n", inet_ntoa(IPAddr), pIPAddrTable->table[0].dwReasmSize);

            IPAddr.S_un.S_addr = (u_short) pIPAddrTable->table[0].unused1;
            s_IPAddresses->current_unused1_string = inet_ntoa(IPAddr);
            s_IPAddresses->current_unused1_us = pIPAddrTable->table[0].unused1;
            printf("\tUnused1 Address:  \t%s (%lu%)\n", inet_ntoa(IPAddr), pIPAddrTable->table[0].unused1);

            IPAddr.S_un.S_addr = (u_short) pIPAddrTable->table[0].wType;
            s_IPAddresses->current_Type_string = inet_ntoa(IPAddr);
            s_IPAddresses->current_Type_us = pIPAddrTable->table[0].wType;
            printf("\tType Address   :  \t%s (%lu%)\n\n", inet_ntoa(IPAddr), pIPAddrTable->table[0].wType);

        } else {
            printf("Call to GetIpAddrTable failed with error %d.\n", dwRetVal);
            if (pIPAddrTable) FREE(pIPAddrTable);
            exit(1);
        }
        fflush(stdout);



    s_IPAddresses->nIPs = pIPAddrTable->dwNumEntries;
    // allocating the array of ip address of size nIPs obtained from GetIpAddrTable
    s_IPAddresses->ip_address_ipv4_array = (char**)malloc(s_IPAddresses->nIPs*sizeof(char*));
    s_IPAddresses->array_ipv4_ul = (unsigned long*)malloc(s_IPAddresses->nIPs*sizeof(unsigned long));


    for (int i = 0; i < pIPAddrTable->dwNumEntries; i++) {
        fflush(stdout);

        IPAddr.S_un.S_addr = (u_long) pIPAddrTable->table[i].dwAddr;
        std::cout<<"pIPAddrTable->table["<<i<<"].dwAddr ---> = "<<inet_ntoa(IPAddr)<< " IPAddr.S_un.S_addr ---> "<<IPAddr.S_un.S_addr<<std::endl;

        s_IPAddresses->ip_address_ipv4_array[i] = inet_ntoa((IPAddr));
        s_IPAddresses->array_ipv4_ul[i] = IPAddr.S_un.S_addr;

        std::cout<<s_IPAddresses->ip_address_ipv4_array[i]<<std::endl;
    }


        for (int j = 0; j < s_IPAddresses->nIPs; j++ ) {

            std::cout<<s_IPAddresses->ip_address_ipv4_array[j]<<std::endl;
/*

            //std::cout<<B_BLUE<<"s_IPAddresses->ithIPIndex          ---> "<<B_YELLOW<<s_IPAddresses->ip_address_ipv4_array[i]<<std::endl;
            //std::cout<<s_IPAddresses->ip_address_ipv4_array[i]<<std::endl;
            std::cout<<B_BLUE<<"s_IPAddresses->ip_address_ipv4_array["<<B_GREEN<<i<<B_BLUE"] ---> "<<B_YELLOW<<
                s_IPAddresses->ip_address_ipv4_array[i]<<B_BLUE"("<<B_MAGENTA<<
                    s_IPAddresses->array_ipv4_ul[i]<<B_BLUE")"<<std::endl;
*/

        }





    PIP_INTERFACE_INFO pInfo = NULL;
    ULONG ulOutBufLen = 0;

    // Make an initial call to GetInterfaceInfo to get
    // the necessary size in the ulOutBufLen variable
    dwRetVal = GetInterfaceInfo(NULL, &ulOutBufLen);
    std::cout<<"ulOutBufLen --> "<<ulOutBufLen<<", dwRetVal --> "<<dwRetVal<<std::endl;

    if (dwRetVal == ERROR_INSUFFICIENT_BUFFER) {
        pInfo = (IP_INTERFACE_INFO*)MALLOC(ulOutBufLen);
        if (pInfo == NULL) {
            printf ("Unable to allocate memory needed to call GetInterfaceInfo\n");
            rc = RC_FAIL;
        }
    }

       /*char **orderedIds;

        orderedIds = malloc(variableNumberOfElements * sizeof(char*));
        for (int i = 0; i < variableNumberOfElements; i++)
            orderedIds[i] = malloc((ID_LEN+1) * sizeof(char)); // yeah, I know sizeof(char)
            *
            *


        #include <iostream>
 #include <string>
 #include <locale>
 #include <codecvt>

 int main() {
     char16_t wstr16[2] = {0x266A, 0};
     auto conv = std::wstring_convert<std::codecvt_utf8_utf16<char16_t>, char16_t>{};
     auto u8str = std::string{conv.to_bytes(wstr16)};
     std::cout << u8str << '\n';
 }

        s_IPAddresses->current_adapter_name_uuid = pInfo->Adapter[i].Name
        */

    // Make a second call to GetInterfaceInfo to get
    // the actual data we need
    dwRetVal = GetInterfaceInfo(pInfo, &ulOutBufLen);
    if (dwRetVal == NO_ERROR) {
        std::cout<<B_BLUE<<"Number of Adapters --> "<<B_MAGENTA<<pInfo->NumAdapters<<B_BLUE<<" ---> dwRetVal --> "<<B_GREEN<<dwRetVal<<std::endl;
        s_adapters->nAdapters = pInfo->NumAdapters;
        for (int i =0; i < pInfo->NumAdapters; i++ ) {
            std::cout<<B_BLUE<<"Adapter Index["<<B_GREEN<<i<<B_BLUE<<"] ---> : "<<B_MAGENTA<<pInfo->Adapter[i].Index<<COLOR_RESET<<std::endl;
            std::cout<<B_BLUE<<"Adapter  Name["<<B_GREEN<<i<<B_BLUE<<"] ---> : "<<B_MAGENTA<<pInfo->Adapter[i].Name<<COLOR_RESET<<std::endl;
            printf(B_BLUE"Adapter  Name[");printf(B_GREEN"%d",i);printf(B_BLUE"] ---> : ");printf(B_MAGENTA"%ws\n",pInfo->Adapter[i].Name);
            std::cout<<COLOR_RESET<<std::endl;
        }
        rc = RC_SUCCESS;
    } else if (dwRetVal == ERROR_NO_DATA) {
        printf
            ("There are no network adapters with IPv4 enabled on the local system\n");
        rc = RC_SUCCESS;
    } else {
        printf("GetInterfaceInfo failed with error: %d\n", dwRetVal);
        rc = RC_FAIL;
    }
    FREE(pInfo);

    /* calling the initilisation method */
    rc = _initialize_t(s_adapters, s_IPAddresses); if (rc != RC_SUCCESS) {rc = RC_FAIL;}

    /* printing the data structure */
    rc = print_adapters_data_structure(s_adapters); if (rc != RC_SUCCESS) {rc = RC_WARNING;}
    rc = print_IPAddresses_data_structure(s_IPAddresses);; if (rc != RC_SUCCESS) {rc = RC_WARNING;}

  } /* end of Network_ClassTemplate_t constructor */






/*--------------------------------------------------------------------------------------------------------------------*/


std::cout<<B_B_RED<<" s_adapters->nAdapters ---> "<<B_B_MAGENTA<<s_adapters->nAdapters<<COLOR_RESET<<std::endl;
std::cout<<B_BLUE<<"s_IPAdds->ithIPIndex               ---> "<<B_YELLOW<<s_IPAdds->ithIPIndex<<std::endl;


std::string machineIPAdrdr = getMachineIPAddr(s_network);
std::cout << "machineIPAddr: " << machineIPAdrdr << std::endl;


std::cout << ": " <<  << std::endl;
std::cout<<B_BLUE<<"s_IPAdds->ithIPIndex               ---> "<<B_YELLOW<<getMachineIPAddr_t(s_adapters, s_IPAdds)<<std::endl;


std::cout<<B_RED<<" Socket::get_sockets() ---> "<<B_B_CYAN<<"socket information"<<COLOR_RESET<<std::endl;
std::cout<<B_RED<<"machineIPAddr                      ---> "<<B_YELLOW<<getMachineIPAddr_t(s_adapters, s_IPAdds)<<std::endl;


/*------------------getMachineIPAddr(adapters_struct *s_adapters, IPAddresses_struct *s_IPAdds)-----------------------*/



  template <typename T, typename S> std::string Adapters_ClassTemplate_t<T,S>::getMachineIPAddr(
              adapters_struct *s_adapters,
              IPAddresses_struct *s_IPAdds) {
    //std::string outAdapterIPAddr = "";


      /* Declare and initialize variables */
      std::vector<std::string> adapterName;
      std::vector<std::string> adapterDesc;
      std::vector<std::string> adapterIpAddr;

      int count = 0;

      // It is possible for an adapter to have multiple IPv4 addresses, gateways, and secondary WINS servers
      // assigned to the adapter.
      //
      // Note that this sample code only prints out the first entry for the IP address/mask, and gateway,
      // and the primary and secondary WINS server for each adapter.

      PIP_ADAPTER_INFO pAdapterInfo;
      PIP_ADAPTER_INFO pAdapter = NULL;
      DWORD dwRetVal = 0;
      UINT i;

      /* variables used to print DHCP time info */
      struct tm newtime;
      char buffer[32];
      errno_t error;
      std::string err_str = "Err: Exiting function!";

      ULONG ulOutBufLen = sizeof(IP_ADAPTER_INFO);
      pAdapterInfo = (IP_ADAPTER_INFO*)MALLOC(sizeof(IP_ADAPTER_INFO));
      if (pAdapterInfo == NULL) {
          printf("Error allocating memory needed to call GetAdaptersinfo\n");
          return err_str;
      }
      // Make an initial call to GetAdaptersInfo to get
      // the necessary size into the ulOutBufLen variable
      if (GetAdaptersInfo(pAdapterInfo, &ulOutBufLen) == ERROR_BUFFER_OVERFLOW) {
          FREE(pAdapterInfo);
          pAdapterInfo = (IP_ADAPTER_INFO*)MALLOC(ulOutBufLen);
          if (pAdapterInfo == NULL) {
              printf("Error allocating memory needed to call GetAdaptersinfo\n");
              return err_str;
          }
      }

      PIP_INTERFACE_INFO pInfo = NULL;
      ULONG ulOutBufLen_pinfo = 0;
      DWORD interfaceRetVal = GetInterfaceInfo(pInfo, &ulOutBufLen_pinfo);

      if ((dwRetVal = GetAdaptersInfo(pAdapterInfo, &ulOutBufLen)) == NO_ERROR) {
          pAdapter = pAdapterInfo;
          while (pAdapter) {
              printf("\tComboIndex  : \t%d\n", pAdapter->ComboIndex);
              //printf("\tAdaptorIndex: \t%d\n", pAdapter->Address);

              printf("\tAdapter Name: \t%s\n", pAdapter->AdapterName);
              printf("\tAdapter Desc: \t%s\n", pAdapter->Description);
              if (pAdapter->ComboIndex == s_IPAdds->ithIPIndex) {
                  s_IPAdds->current_adapter_name_uuid = pAdapter->AdapterName;
                  s_IPAdds->current_adapter_name_Desc = pAdapter->Description;
              }


            printf("\tAdapter Addr: \t");

            adapterName.push_back(pAdapter->AdapterName);
            adapterDesc.push_back(pAdapter->Description);
            adapterIpAddr.push_back(pAdapter->IpAddressList.IpAddress.String);

            for (i = 0; i < pAdapter->AddressLength; i++) {
                if (i == (pAdapter->AddressLength - 1))
                    printf("%.2X\n", (int)pAdapter->Address[i]);
                else
                    printf("%.2X-", (int)pAdapter->Address[i]);
            }
            printf("\tIndex: \t%d\n", pAdapter->Index);
            printf("\tType: \t");
            switch (pAdapter->Type) {
                case MIB_IF_TYPE_OTHER:
                    printf("Other\n");
                break;
                case MIB_IF_TYPE_ETHERNET:
                    printf("Ethernet\n");
                break;
                case MIB_IF_TYPE_TOKENRING:
                    printf("Token Ring\n");
                break;
                case MIB_IF_TYPE_FDDI:
                    printf("FDDI\n");
                break;
                case MIB_IF_TYPE_PPP:
                    printf("PPP\n");
                break;
                case MIB_IF_TYPE_LOOPBACK:
                    printf("Lookback\n");
                break;
                case MIB_IF_TYPE_SLIP:
                    printf("Slip\n");
                break;
                default:
                    printf("Unknown type %ld\n", pAdapter->Type);
                break;
            }


            printf("\tIP Address: \t%s\n",
                           pAdapter->IpAddressList.IpAddress.String);
            printf("\tIP Mask: \t%s\n", pAdapter->IpAddressList.IpMask.String);

            printf("\tGateway: \t%s\n", pAdapter->GatewayList.IpAddress.String);
            printf("\t***\n");

            if (pAdapter->DhcpEnabled) {
                printf("\tDHCP Enabled: Yes\n");
                printf("\t  DHCP Server: \t%s\n",
                    pAdapter->DhcpServer.IpAddress.String);

                printf("\t  Lease Obtained: ");
                /* Display local time */
                error = _localtime32_s(&newtime, (__time32_t*)&pAdapter->LeaseObtained);
                if (error)
                    printf("Invalid Argument to _localtime32_s\n");
                else {
                    // Convert to an ASCII representation
                    error = asctime_s(buffer, 32, &newtime);
                    if (error)
                        printf("Invalid Argument to asctime_s\n");
                    else
                        /* asctime_s returns the string terminated by \n\0 */
                            printf("%s", buffer);
                }


                printf("\t  Lease Expires:  ");
                error = _localtime32_s(&newtime, (__time32_t*)&pAdapter->LeaseExpires);
                if (error)
                    printf("Invalid Argument to _localtime32_s\n");
                else {
                    // Convert to an ASCII representation
                    error = asctime_s(buffer, 32, &newtime);
                    if (error)
                        printf("Invalid Argument to asctime_s\n");
                    else
                        /* asctime_s returns the string terminated by \n\0 */
                            printf("%s", buffer);
                }
            }
            else
              printf("\tDHCP Enabled: No\n");

              if (pAdapter->HaveWins) {
                  printf("\tHave Wins: Yes\n");
                  printf("\t  Primary Wins Server:    %s\n",
                      pAdapter->PrimaryWinsServer.IpAddress.String);
                  printf("\t  Secondary Wins Server:  %s\n",
                  pAdapter->SecondaryWinsServer.IpAddress.String);
              }
              else
                  printf("\tHave Wins: No\n");
              pAdapter = pAdapter->Next;
              printf("\n");
          }
      }else {
          printf("GetAdaptersInfo failed with error: %d\n", dwRetVal);

    }

    // THIS IS CODE TO ELIMINATE ADAPTERS WITH 'MICROSOFT' OR 'VIRTUAL'
    // IN THE ADAPTER DESCRIPTIONS
/*
    std::vector<std::string>::iterator it = adapterDesc.begin();
    std::vector<std::string>::iterator it2 = adapterIpAddr.begin();

    std::string compareStr1 = "Microsoft";
    std::string compareStr2 = "Virtual";
    std::string outAdapterDesc = "";
*/
    std::string outAdapterIPAddr = "";

/*
    for (it = adapterDesc.begin(), it2 = adapterIpAddr.begin(); it != adapterDesc.end(); it++, it2++)
    {
      printf("*it: %s\n", it->c_str());
      printf("*it2: %s\n", it2->c_str());

      size_t found = it->find("Microsoft");
      size_t found2 = it->find("Virtual");

      if ((found == std::string::npos) || (found2 == std::string::npos))
      {
        outAdapterDesc = *it;
        outAdapterIPAddr = *it2;
      }
    }

    printf("outAdapterDesc: %s\n", outAdapterDesc.c_str());
    printf("outAdapterIPAddr: %s\n", outAdapterIPAddr.c_str());

*/


    if (pAdapterInfo)
      FREE(pAdapterInfo);

    return outAdapterIPAddr;
  } /* end of Network_ClassTemplate_t<T,S>::getMachineIPAddr() method */


/*--------------------------------------------------------------------------------------------------------------------*/


/*--------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------*/
/*------------------family = AF_INET; //for IPv4 --- family = AF_INET6; //for IPv6 -----------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------*/
std::cout<<"MAX_TRIES:           ---> "<<MAX_TRIES<<std::endl;
std::cout<<"WORKING_BUFFER_SIZE: ---> "<<WORKING_BUFFER_SIZE<<std::endl;

    /* Declare and initialize variables */

    DWORD dwSize = 0;
    DWORD dwRetVal = 0;

    unsigned int i = 0;

    // Set the flags to pass to GetAdaptersAddresses
    ULONG flags = GAA_FLAG_INCLUDE_PREFIX;

    // default to unspecified address family (both)
    ULONG family = AF_UNSPEC;

    LPVOID lpMsgBuf = NULL;

    PIP_ADAPTER_ADDRESSES pAddresses = NULL;
    ULONG outBufLen = 0;
    ULONG Iterations = 0;

    PIP_ADAPTER_ADDRESSES pCurrAddresses = NULL;
    PIP_ADAPTER_UNICAST_ADDRESS pUnicast = NULL;
    PIP_ADAPTER_ANYCAST_ADDRESS pAnycast = NULL;
    PIP_ADAPTER_MULTICAST_ADDRESS pMulticast = NULL;
    IP_ADAPTER_DNS_SERVER_ADDRESS *pDnServer = NULL;
    IP_ADAPTER_PREFIX *pPrefix = NULL;
/*
int argc = 1;

    if (argc != 2) {
        printf(" Usage: getadapteraddresses family\n");
        printf("        getadapteraddresses 4 (for IPv4)\n");
        printf("        getadapteraddresses 6 (for IPv6)\n");
        printf("        getadapteraddresses A (for both IPv4 and IPv6)\n");
        exit(1);
    }

    if (atoi(argv[1]) == 4)      family = AF_INET;
    else if (atoi(argv[1]) == 6) family = AF_INET6;
*/

family = AF_INET; //for IPv4
        //family = AF_INET6; //for IPv6

    printf("Calling GetAdaptersAddresses function with family = ");
    if (family == AF_INET)
        printf("AF_INET\n");
    if (family == AF_INET6)
        printf("AF_INET6\n");
    if (family == AF_UNSPEC)
        printf("AF_UNSPEC\n\n");

    // Allocate a 15 KB buffer to start with.
    outBufLen = WORKING_BUFFER_SIZE;

    do {

        pAddresses = (IP_ADAPTER_ADDRESSES *) MALLOC(outBufLen);
        if (pAddresses == NULL) {
            printf
                ("Memory allocation failed for IP_ADAPTER_ADDRESSES struct\n");
            exit(1);
        }

        dwRetVal =
            GetAdaptersAddresses(family, flags, NULL, pAddresses, &outBufLen);

        if (dwRetVal == ERROR_BUFFER_OVERFLOW) {
            FREE(pAddresses);
            pAddresses = NULL;
        } else {
            break;
        }

        Iterations++;

    } while ((dwRetVal == ERROR_BUFFER_OVERFLOW) && (Iterations < MAX_TRIES));

    if (dwRetVal == NO_ERROR) {
        // If successful, output some information from the data we received
        pCurrAddresses = pAddresses;
        while (pCurrAddresses) {
            printf("\tLength of the IP_ADAPTER_ADDRESS struct: %ld\n",
                   pCurrAddresses->Length);
            printf("\tIfIndex (IPv4 interface): %u\n", pCurrAddresses->IfIndex);
            printf("\tAdapter name: %s\n", pCurrAddresses->AdapterName);

            pUnicast = pCurrAddresses->FirstUnicastAddress;
            if (pUnicast != NULL) {
                for (i = 0; pUnicast != NULL; i++)
                    pUnicast = pUnicast->Next;
                printf("\tNumber of Unicast Addresses: %d\n", i);
            } else
                printf("\tNo Unicast Addresses\n");

            pAnycast = pCurrAddresses->FirstAnycastAddress;
            if (pAnycast) {
                for (i = 0; pAnycast != NULL; i++)
                    pAnycast = pAnycast->Next;
                printf("\tNumber of Anycast Addresses: %d\n", i);
            } else
                printf("\tNo Anycast Addresses\n");

            pMulticast = pCurrAddresses->FirstMulticastAddress;
            if (pMulticast) {
                for (i = 0; pMulticast != NULL; i++)
                    pMulticast = pMulticast->Next;
                printf("\tNumber of Multicast Addresses: %d\n", i);
            } else
                printf("\tNo Multicast Addresses\n");

            pDnServer = pCurrAddresses->FirstDnsServerAddress;
            if (pDnServer) {
                for (i = 0; pDnServer != NULL; i++)
                    pDnServer = pDnServer->Next;
                printf("\tNumber of DNS Server Addresses: %d\n", i);
            } else
                printf("\tNo DNS Server Addresses\n");

            printf("\tDNS Suffix: %wS\n", pCurrAddresses->DnsSuffix);
            printf("\tDescription: %wS\n", pCurrAddresses->Description);
            printf("\tFriendly name: %wS\n", pCurrAddresses->FriendlyName);

            if (pCurrAddresses->PhysicalAddressLength != 0) {
                printf("\tPhysical address: ");
                for (i = 0; i < (int) pCurrAddresses->PhysicalAddressLength;
                     i++) {
                    if (i == (pCurrAddresses->PhysicalAddressLength - 1))
                        printf("%.2X\n",
                               (int) pCurrAddresses->PhysicalAddress[i]);
                    else
                        printf("%.2X-",
                               (int) pCurrAddresses->PhysicalAddress[i]);
                }
            }
            printf("\tFlags: %ld\n", pCurrAddresses->Flags);
            printf("\tMtu: %lu\n", pCurrAddresses->Mtu);
            printf("\tIfType: %ld\n", pCurrAddresses->IfType);
            printf("\tOperStatus: %ld\n", pCurrAddresses->OperStatus);
            printf("\tIpv6IfIndex (IPv6 interface): %u\n",
                   pCurrAddresses->Ipv6IfIndex);
            printf("\tZoneIndices (hex): ");
            for (i = 0; i < 16; i++)
                printf("%lx ", pCurrAddresses->ZoneIndices[i]);
            printf("\n");

            printf("\tTransmit link speed: %I64u\n", pCurrAddresses->TransmitLinkSpeed);
            printf("\tReceive link speed: %I64u\n", pCurrAddresses->ReceiveLinkSpeed);

            pPrefix = pCurrAddresses->FirstPrefix;
            if (pPrefix) {
                for (i = 0; pPrefix != NULL; i++)
                    pPrefix = pPrefix->Next;
                printf("\tNumber of IP Adapter Prefix entries: %d\n", i);
            } else
                printf("\tNumber of IP Adapter Prefix entries: 0\n");

            printf("\n");

            pCurrAddresses = pCurrAddresses->Next;
        }
    } else {
        printf("Call to GetAdaptersAddresses failed with error: %d\n",
               dwRetVal);
        if (dwRetVal == ERROR_NO_DATA)
            printf("\tNo addresses were found for the requested parameters\n");
        else {

            if (FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER |
                    FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
                    NULL, dwRetVal, MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
                    // Default language
                    (LPTSTR) & lpMsgBuf, 0, NULL)) {
                printf("\tError: %s", lpMsgBuf);
                LocalFree(lpMsgBuf);
                if (pAddresses)
                    FREE(pAddresses);
                exit(1);
            }
        }
    }

    if (pAddresses) {
        FREE(pAddresses);
    }
/*--------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------*/


std::cout<<typeid(pAdapter->AdapterName).name()<<std::endl;;




std::cout<<" the index = "<< s_IPAdds->ithIPIndex <<std::endl;


/* IPv4 address and subnet mask we will be adding */
UINT iaIPAddress;
UINT iaIPMask;

/* Variables where handles to the added IP are returned */
ULONG NTEContext = 0;
ULONG NTEInstance = 0;

/* Variables used to return error message */
LPVOID lpMsgBuf;


IPAddr.S_un.S_addr = (u_long) pIPAddrTable->table[0].dwReasmSize;
printf("\tReasmSize Address:\t%s (%lu%)\n", inet_ntoa(IPAddr), pIPAddrTable->table[0].dwReasmSize);




std::cout<<B_B_RED<<" typeid(inet_ntoa(IPAddr)) ---> "<<B_B_MAGENTA<<typeid(inet_ntoa(IPAddr)).name()<<COLOR_RESET<<std::endl;
std::cout<<B_B_RED<<" IPAddr.S_un.S_addr ---> "<<B_B_MAGENTA<<IPAddr.S_un.S_addr<<COLOR_RESET<<std::endl;



std::string getMachineIPAddr(network_struct *s_network);


  template <typename T, typename S> std::string Network_ClassTemplate_t<T,S>::getMachineIPAddr(network_struct *s_network) {
    std::string outAdapterIPAddr = "";

    return outAdapterIPAddr;
  } /* end of Network_ClassTemplate_t<T,S>::getMachineIPAddr() method */





/*----------------------------------------------------*/

template <typename T, typename S> int Network_ClassTemplate_t<T,S>::_initialize_t(network_struct *s_network) {
    int rc = RC_SUCCESS;
    //std::cout << "machineIPAddr: " << getMachineIPAddr(s_network) << std::endl;

    namespace_Network::Adapters_ClassTemplate_t<T,S> *cOverAdapterLayer_t =
        new namespace_Network::Adapters_ClassTemplate_t<T, S>(s_network);


    return rc;
}




template <typename T, typename S>
    Network_ClassTemplate_t<T,S>::Network_ClassTemplate_t(network_struct *s_network) {
    int rc = RC_SUCCESS;

    /*//TODO: instantiate the template class Socket
     * namespace_Network::Socket_ClassTemplate_t<float, std::string> *cSocketLayer_t =
                new namespace_Network::Socket_ClassTemplate_t<float, std::string>();  */

    rc = _initialize_t(s_network); if (rc != RC_SUCCESS){rc = RC_FAIL;}

/*



        std::cout<<"START IMPLEMENMTING HERE THE NETWORK CLASS"
           "(Network_ClassTemplate_t<T,S>::Network_ClassTemplate_t(network_struct *s_network)) ....."<<std::endl;

        //rc = Socket::get_sockets();

    // Variables used by GetIpAddrTable
    PMIB_IPADDRTABLE pIPAddrTable;
    DWORD dwSize = 0;
    DWORD dwRetVal = 0;
    IN_ADDR IPAddr;
    DWORD ifIndex;

    // IPv4 address and subnet mask we will be adding
    UINT iaIPAddress;
    UINT iaIPMask;

    // Variables where handles to the added IP are returned
    ULONG NTEContext = 0;
    ULONG NTEInstance = 0;

    // Variables used to return error message
    LPVOID lpMsgBuf;

    // Before calling AddIPAddress we use GetIpAddrTable to get
    // an adapter to which we can add the IP.
    pIPAddrTable = (MIB_IPADDRTABLE *) MALLOC(sizeof (MIB_IPADDRTABLE));
    if (pIPAddrTable == NULL) {
      printf("Error allocating memory needed to call GetIpAddrTable\n");
      exit (1);
    } else {
      dwSize = 0;
      // Make an initial call to GetIpAddrTable to get the
      // necessary size into the dwSize variable
      if (GetIpAddrTable(pIPAddrTable, &dwSize, 0) == ERROR_INSUFFICIENT_BUFFER) {
          FREE(pIPAddrTable);
          pIPAddrTable = (MIB_IPADDRTABLE *) MALLOC(dwSize);
      }
      if (pIPAddrTable == NULL) {
        printf("Memory allocation failed for GetIpAddrTable\n");
        exit(1);
      }
    }
    // Make a second call to GetIpAddrTable to get the
    // actual data we want
    if ((dwRetVal = GetIpAddrTable(pIPAddrTable, &dwSize, 0)) == NO_ERROR) {
      // Save the interface index to use for adding an IP address
      ifIndex = pIPAddrTable->table[0].dwIndex;
      printf("\n\tInterface Index:\t%ld\n", ifIndex);
      IPAddr.S_un.S_addr = (u_long) pIPAddrTable->table[0].dwAddr;
      printf("\tIP Address:       \t%s (%lu%)\n", inet_ntoa(IPAddr), pIPAddrTable->table[0].dwAddr);
      IPAddr.S_un.S_addr = (u_long) pIPAddrTable->table[0].dwMask;
      printf("\tSubnet Mask:      \t%s (%lu%)\n", inet_ntoa(IPAddr), pIPAddrTable->table[0].dwMask);
      IPAddr.S_un.S_addr = (u_long) pIPAddrTable->table[0].dwBCastAddr;
      printf("\tBroadCast Address:\t%s (%lu%)\n", inet_ntoa(IPAddr), pIPAddrTable->table[0].dwBCastAddr);
      printf("\tReassembly size:  \t%lu\n\n", pIPAddrTable->table[0].dwReasmSize);
    } else {
      printf("Call to GetIpAddrTable failed with error %d.\n", dwRetVal);
      if (pIPAddrTable) FREE(pIPAddrTable);
      exit(1);
    }

    for (int i = 0; i < pIPAddrTable->dwNumEntries; i++) {
        IPAddr.S_un.S_addr = (u_long) pIPAddrTable->table[i].dwAddr;
        std::cout<<"pIPAddrTable->table["<<i<<"].dwAddr ---> = "<<inet_ntoa(IPAddr)<<std::endl;
    }

    PIP_INTERFACE_INFO pInfo = NULL;
    ULONG ulOutBufLen = 0;

    // Make an initial call to GetInterfaceInfo to get
    // the necessary size in the ulOutBufLen variable
    dwRetVal = GetInterfaceInfo(NULL, &ulOutBufLen);
    std::cout<<"ulOutBufLen --> "<<ulOutBufLen<<", dwRetVal --> "<<dwRetVal<<std::endl;

    if (dwRetVal == ERROR_INSUFFICIENT_BUFFER) {
      pInfo = (IP_INTERFACE_INFO*)MALLOC(ulOutBufLen);
      if (pInfo == NULL) {
        printf ("Unable to allocate memory needed to call GetInterfaceInfo\n");
        rc = RC_FAIL;
      }
    }
    // Make a second call to GetInterfaceInfo to get
    // the actual data we need
    dwRetVal = GetInterfaceInfo(pInfo, &ulOutBufLen);
    if (dwRetVal == NO_ERROR) {
      std::cout<<B_BLUE<<"Number of Adapters --> "<<B_MAGENTA<<pInfo->NumAdapters<<B_BLUE<<" ---> dwRetVal --> "<<B_GREEN<<dwRetVal<<std::endl;
      for (int i =0; i < pInfo->NumAdapters; i++ ) {
          std::cout<<B_BLUE<<"Adapter Index["<<B_GREEN<<i<<B_BLUE<<"] ---> : "<<B_MAGENTA<<pInfo->Adapter[i].Index<<COLOR_RESET<<std::endl;
          std::cout<<B_BLUE<<"Adapter  Name["<<B_GREEN<<i<<B_BLUE<<"] ---> : "<<B_MAGENTA<<pInfo->Adapter[i].Name<<COLOR_RESET<<std::endl;
          printf(B_BLUE"Adapter  Name[");printf(B_GREEN"%d",i);printf(B_BLUE"] ---> : ");printf(B_MAGENTA"%ws\n",pInfo->Adapter[i].Name);
          std::cout<<COLOR_RESET<<std::endl;
      }
      rc = RC_SUCCESS;
    } else if (dwRetVal == ERROR_NO_DATA) {
      printf
          ("There are no network adapters with IPv4 enabled on the local system\n");
      rc = RC_SUCCESS;
    } else {
      printf("GetInterfaceInfo failed with error: %d\n", dwRetVal);
      rc = RC_FAIL;
    }
    FREE(pInfo);


*/

} /* end of Network_ClassTemplate_t constructor */



  template <typename T, typename S> std::string Network_ClassTemplate_t<T,S>::getMachineIPAddr(network_struct *s_network) {
    //std::string outAdapterIPAddr = "";


    /* Declare and initialize variables */
    std::vector<std::string> adapterName;
    std::vector<std::string> adapterDesc;
    std::vector<std::string> adapterIpAddr;

    int count = 0;

    // It is possible for an adapter to have multiple IPv4 addresses, gateways, and secondary WINS servers
    // assigned to the adapter.
    //
    // Note that this sample code only prints out the first entry for the IP address/mask, and gateway,
    // and the primary and secondary WINS server for each adapter.

    PIP_ADAPTER_INFO pAdapterInfo;
    PIP_ADAPTER_INFO pAdapter = NULL;
    DWORD dwRetVal = 0;
    UINT i;

    //variables used to print DHCP time info
    struct tm newtime;
    char buffer[32];
    errno_t error;
    std::string err_str = "Err: Exiting function!";

    ULONG ulOutBufLen = sizeof(IP_ADAPTER_INFO);
    pAdapterInfo = (IP_ADAPTER_INFO*)MALLOC(sizeof(IP_ADAPTER_INFO));
    if (pAdapterInfo == NULL) {
      printf("Error allocating memory needed to call GetAdaptersinfo\n");
      return err_str;
    }
    // Make an initial call to GetAdaptersInfo to get
    // the necessary size into the ulOutBufLen variable
    if (GetAdaptersInfo(pAdapterInfo, &ulOutBufLen) == ERROR_BUFFER_OVERFLOW) {
      FREE(pAdapterInfo);
      pAdapterInfo = (IP_ADAPTER_INFO*)MALLOC(ulOutBufLen);
      if (pAdapterInfo == NULL) {
        printf("Error allocating memory needed to call GetAdaptersinfo\n");
        return err_str;
      }
    }

    PIP_INTERFACE_INFO pInfo = NULL;
    ULONG ulOutBufLen_pinfo = 0;
    DWORD interfaceRetVal = GetInterfaceInfo(pInfo, &ulOutBufLen_pinfo);



    if ((dwRetVal = GetAdaptersInfo(pAdapterInfo, &ulOutBufLen)) == NO_ERROR) {
        pAdapter = pAdapterInfo;
        while (pAdapter) {
            printf("\tComboIndex  : \t%d\n", pAdapter->ComboIndex);

            //printf("\tAdaptorIndex: \t%d\n", pAdapter->Address);

            printf("\tAdapter Name: \t%s\n", pAdapter->AdapterName);
            printf("\tAdapter Desc: \t%s\n", pAdapter->Description);
            printf("\tAdapter Addr: \t");

            adapterName.push_back(pAdapter->AdapterName);
            adapterDesc.push_back(pAdapter->Description);
            adapterIpAddr.push_back(pAdapter->IpAddressList.IpAddress.String);

            for (i = 0; i < pAdapter->AddressLength; i++) {
                if (i == (pAdapter->AddressLength - 1))
                    printf("%.2X\n", (int)pAdapter->Address[i]);
                else
                    printf("%.2X-", (int)pAdapter->Address[i]);
            }
            printf("\tIndex: \t%d\n", pAdapter->Index);
            printf("\tType: \t");
            switch (pAdapter->Type) {
                case MIB_IF_TYPE_OTHER:
                    printf("Other\n");
                break;
                case MIB_IF_TYPE_ETHERNET:
                    printf("Ethernet\n");
                break;
                case MIB_IF_TYPE_TOKENRING:
                    printf("Token Ring\n");
                break;
                case MIB_IF_TYPE_FDDI:
                    printf("FDDI\n");
                break;
                case MIB_IF_TYPE_PPP:
                    printf("PPP\n");
                break;
                case MIB_IF_TYPE_LOOPBACK:
                    printf("Lookback\n");
                break;
                case MIB_IF_TYPE_SLIP:
                    printf("Slip\n");
                break;
                default:
                    printf("Unknown type %ld\n", pAdapter->Type);
                break;
            }


            printf("\tIP Address: \t%s\n",
                           pAdapter->IpAddressList.IpAddress.String);
            printf("\tIP Mask: \t%s\n", pAdapter->IpAddressList.IpMask.String);

            printf("\tGateway: \t%s\n", pAdapter->GatewayList.IpAddress.String);
            printf("\t***\n");

            if (pAdapter->DhcpEnabled) {
                printf("\tDHCP Enabled: Yes\n");
                printf("\t  DHCP Server: \t%s\n",
                    pAdapter->DhcpServer.IpAddress.String);

                printf("\t  Lease Obtained: ");
                /* Display local time */
                error = _localtime32_s(&newtime, (__time32_t*)&pAdapter->LeaseObtained);
                if (error)
                    printf("Invalid Argument to _localtime32_s\n");
                else {
                    // Convert to an ASCII representation
                    error = asctime_s(buffer, 32, &newtime);
                    if (error)
                        printf("Invalid Argument to asctime_s\n");
                    else
                        /* asctime_s returns the string terminated by \n\0 */
                            printf("%s", buffer);
                }


                printf("\t  Lease Expires:  ");
                error = _localtime32_s(&newtime, (__time32_t*)&pAdapter->LeaseExpires);
                if (error)
                    printf("Invalid Argument to _localtime32_s\n");
                else {
                    // Convert to an ASCII representation
                    error = asctime_s(buffer, 32, &newtime);
                    if (error)
                        printf("Invalid Argument to asctime_s\n");
                    else
                        /* asctime_s returns the string terminated by \n\0 */
                            printf("%s", buffer);
                }
            }
            else
              printf("\tDHCP Enabled: No\n");

          if (pAdapter->HaveWins) {
            printf("\tHave Wins: Yes\n");
            printf("\t  Primary Wins Server:    %s\n",
                pAdapter->PrimaryWinsServer.IpAddress.String);
            printf("\t  Secondary Wins Server:  %s\n",
                pAdapter->SecondaryWinsServer.IpAddress.String);
          }
          else
            printf("\tHave Wins: No\n");
          pAdapter = pAdapter->Next;
          printf("\n");
        }
    }else {
      printf("GetAdaptersInfo failed with error: %d\n", dwRetVal);

    }

    // THIS IS CODE TO ELIMINATE ADAPTERS WITH 'MICROSOFT' OR 'VIRTUAL'
    // IN THE ADAPTER DESCRIPTIONS
/*
    std::vector<std::string>::iterator it = adapterDesc.begin();
    std::vector<std::string>::iterator it2 = adapterIpAddr.begin();

    std::string compareStr1 = "Microsoft";
    std::string compareStr2 = "Virtual";
    std::string outAdapterDesc = "";
*/
    std::string outAdapterIPAddr = "";

/*
    for (it = adapterDesc.begin(), it2 = adapterIpAddr.begin(); it != adapterDesc.end(); it++, it2++)
    {
      printf("*it: %s\n", it->c_str());
      printf("*it2: %s\n", it2->c_str());

      size_t found = it->find("Microsoft");
      size_t found2 = it->find("Virtual");

      if ((found == std::string::npos) || (found2 == std::string::npos))
      {
        outAdapterDesc = *it;
        outAdapterIPAddr = *it2;
      }
    }

    printf("outAdapterDesc: %s\n", outAdapterDesc.c_str());
    printf("outAdapterIPAddr: %s\n", outAdapterIPAddr.c_str());

*/


    if (pAdapterInfo)
      FREE(pAdapterInfo);

    return outAdapterIPAddr;
  } /* end of Network_ClassTemplate_t<T,S>::getMachineIPAddr() method */

/*----------------------------------------------------*/















































std::string machineIPAdrdr = getMachineIPAddr(s_network);
std::cout << "machineIPAddr: " << machineIPAdrdr << std::endl;


template<class T>
      DerivedClass(int m, T t)
      : BaseClass(t),
        m_(m)
{
    // If this function fails to compile then the
    // calling code is not passing the right number
    // of parameters
}



//int length = sizeof(pIPAddrTable->table) / sizeof(pIPAddrTable->table[0]);



std::cout<<B_BLUE<<"Adapter  Name["<<B_GREEN<<i<<B_BLUE<<"] ---> :"<<B_MAGENTA<<printf("%ws\n", pInfo->Adapter[i].Name );

std::cout<<B_BLUE<<"Adapter  Name["<<B_GREEN<<i<<B_BLUE<<"] ---> :"<<B_MAGENTA<<std::format("{}", pInfo->Adapter[i].Name );

std::cout<<typeid(pInfo->Adapter[i].Name).name()<<std::endl;
std::cout<<typeid(pInfo->Adapter[i].Name).raw_name()<<std::endl;
std::cout<<typeid(pInfo->Adapter[i].Name).hash_code()<<std::endl;

std::cout << std::format("The answer is {}.\n", 42);
std::cout << std::putf("this is a number: %d\n",i);

printf("Adapter Index[%d]: %ld\n", i, pInfo->Adapter[i].Index);
printf("Adapter Name[%d]: %ws\n\n", i, pInfo->Adapter[i].Name);

cout << "hex|dec|oct (sticky)" << endl;
cout << "|dec: " << dec << "|" << 1024 << "|" << -1024 << "|" << endl;
cout << "|hex: " << hex << "|" << 1024 << "|" << -1024 << "|" << endl;
cout << "|oct: " << oct << "|" << 1024 << "|" << -1024 << "|" << endl;
cout << endl;


//std::cout<<B_BLUE<<"Adapter  Name["<<B_GREEN<<i<<B_BLUE<<"] ---> :"<<B_MAGENTA<<std::format("{}", pInfo->Adapter[i].Name );

//std::cout<<typeid(pInfo->Adapter[i].Name).name()<<std::endl;
//std::cout<<typeid(pInfo->Adapter[i].Name).raw_name()<<std::endl;
//std::cout<<typeid(pInfo->Adapter[i].Name).hash_code()<<std::endl;

//std::cout << std::format("The answer is {}.\n", 42);
//std::cout << std::putf("this is a number: %d\n",i);


//printf("Adapter Index[%d]: %ld\n", i, pInfo->Adapter[i].Index);
//printf("Adapter Name[%d]: %ws\n\n", i, pInfo->Adapter[i].Name);





    PIP_INTERFACE_INFO pInfo = NULL;
    ULONG ulOutBufLen_pinfo = 0; //sizeof(PIP_INTERFACE_INFO);
    //pInfo = (PIP_INTERFACE_INFO*)MALLOC(sizeof(PIP_INTERFACE_INFO));
    GetInterfaceInfo(pInfo, &ulOutBufLen_pinfo);

        std::cout<<B_BLUE<<pInfo->Adapter[i].Name<<std::endl;

explicit Network_ClassTemplate_t() {
    /*
    namespace_Network::Socket_ClassTemplate_t<float,
                std::string> *cSocketLayer_t =
                    new namespace_Network::Socket_ClassTemplate_t<float,
                std::string>();
                */
}



#include <winsock2.h>
#include <ws2ipdef.h>
#include <iphlpapi.h>
#include <stdio.h>

#pragma comment(lib, "iphlpapi.lib")

#define MALLOC(x) HeapAlloc(GetProcessHeap(), 0, (x))
#define FREE(x) HeapFree(GetProcessHeap(), 0, (x))

/* Note: could also use malloc() and free() */

int main()
{

// Declare and initialize variables
    PIP_INTERFACE_INFO pInfo = NULL;
    ULONG ulOutBufLen = 0;

    DWORD dwRetVal = 0;
    int iReturn = 1;

    int i;

// Make an initial call to GetInterfaceInfo to get
// the necessary size in the ulOutBufLen variable
    dwRetVal = GetInterfaceInfo(NULL, &ulOutBufLen);
    if (dwRetVal == ERROR_INSUFFICIENT_BUFFER) {
        pInfo = (IP_INTERFACE_INFO *) MALLOC(ulOutBufLen);
        if (pInfo == NULL) {
            printf
                ("Unable to allocate memory needed to call GetInterfaceInfo\n");
            return 1;
        }
    }
// Make a second call to GetInterfaceInfo to get
// the actual data we need
    dwRetVal = GetInterfaceInfo(pInfo, &ulOutBufLen);
    if (dwRetVal == NO_ERROR) {
        printf("Number of Adapters: %ld\n\n", pInfo->NumAdapters);
        for (i = 0; i < pInfo->NumAdapters; i++) {
            printf("Adapter Index[%d]: %ld\n", i,
                   pInfo->Adapter[i].Index);
            printf("Adapter Name[%d]: %ws\n\n", i,
                   pInfo->Adapter[i].Name);
        }
        iReturn = 0;
    } else if (dwRetVal == ERROR_NO_DATA) {
        printf
            ("There are no network adapters with IPv4 enabled on the local system\n");
        iReturn = 0;
    } else {
        printf("GetInterfaceInfo failed with error: %d\n", dwRetVal);
        iReturn = 1;
    }

    FREE(pInfo);
    return (iReturn);
}


    IP_ADAPTER_ADDRESSES *head, *curr;
    IP_ADAPTER_UNICAST_ADDRESS *uni;
    int buflen, err, i;

    buflen = sizeof(IP_ADAPTER_UNICAST_ADDRESS) * 500;  //  enough for 500 interfaces
    head = (IP_ADAPTER_ADDRESSES *)malloc(buflen);

    if (!head) exit(1);

    //for (curr = head; curr; curr = curr->Next) {
      //if (curr->IfType != IF_TYPE_IEEE80211) continue;

/*
      for (uni = curr->FirstUnicastAddress; uni; uni = uni->Next) {
        if (curr->OperStatus == IfOperStatusUp) {
          char addrstr[INET6_ADDRSTRLEN];

          inet_ntop(uni->Address.lpSockaddr->sa_family, uni->Address.lpSockaddr,
                    addrstr, uni->Address.iSockaddrLength);
          printf("interface name: %s\n", curr->AdapterName);
          printf("interface address: %s\n", addrstr);
        }
      }
*/

    //}
    free(head);












    namespace_Network::Socket_ClassTemplate_t<float,
                std::string> *cSocketLayer_t =
                    new namespace_Network::Socket_ClassTemplate_t<float,
                std::string>();
    int rc = Socket::get_sockets();


explicit Network_ClassTemplate_t(network_struct *s_network);
/*
        {
            namespace_Network::Socket_ClassTemplate_t<float,
                        std::string> *cSocketLayer_t =
                            new namespace_Network::Socket_ClassTemplate_t<float,
                        std::string>();
            int rc = Socket::get_sockets();
        }
*/

namespace_Network::Socket_ClassTemplate_t<float,
            std::string> *cSocketLayer_t =
                new namespace_Network::Socket_ClassTemplate_t<float,
            std::string>()



#pragma comment(lib, "iphlpapi.lib")
#pragma comment(lib, "ws2_32.lib")

#include <winsock2.h>
#include <ws2tcpip.h>
#include <iphlpapi.h>
#include <stdio.h>

#define MALLOC(x) HeapAlloc(GetProcessHeap(), 0, (x))
#define FREE(x) HeapFree(GetProcessHeap(), 0, (x))

/* Note: could also use malloc() and free() */

int __cdecl main(int argc, char **argv)
{

    /* Variables used by GetIpAddrTable */
    PMIB_IPADDRTABLE pIPAddrTable;
    DWORD dwSize = 0;
    DWORD dwRetVal = 0;
    IN_ADDR IPAddr;
    DWORD ifIndex;

    /* IPv4 address and subnet mask we will be adding */
    UINT iaIPAddress;
    UINT iaIPMask;

    /* Variables where handles to the added IP are returned */
    ULONG NTEContext = 0;
    ULONG NTEInstance = 0;

    /* Variables used to return error message */
    LPVOID lpMsgBuf;

    // Validate the parameters
    if (argc != 3) {
        printf("usage: %s IPAddress SubnetMask\n", argv[0]);
        exit(1);
    }

    iaIPAddress = inet_addr(argv[1]);
    if (iaIPAddress == INADDR_NONE) {
        printf("usage: %s IPAddress SubnetMask\n", argv[0]);
        exit(1);
    }

    iaIPMask = inet_addr(argv[2]);
    if (iaIPMask == INADDR_NONE) {
        printf("usage: %s IPAddress SubnetMask\n", argv[0]);
        exit(1);
    }

    // Before calling AddIPAddress we use GetIpAddrTable to get
    // an adapter to which we can add the IP.
    pIPAddrTable = (MIB_IPADDRTABLE *) MALLOC(sizeof (MIB_IPADDRTABLE));
    if (pIPAddrTable == NULL) {
        printf("Error allocating memory needed to call GetIpAddrTable\n");
        exit (1);
    }
    else {
        dwSize = 0;
        // Make an initial call to GetIpAddrTable to get the
        // necessary size into the dwSize variable
        if (GetIpAddrTable(pIPAddrTable, &dwSize, 0) ==
            ERROR_INSUFFICIENT_BUFFER) {
            FREE(pIPAddrTable);
            pIPAddrTable = (MIB_IPADDRTABLE *) MALLOC(dwSize);

        }
        if (pIPAddrTable == NULL) {
            printf("Memory allocation failed for GetIpAddrTable\n");
            exit(1);
        }
    }
    // Make a second call to GetIpAddrTable to get the
    // actual data we want
    if ((dwRetVal = GetIpAddrTable(pIPAddrTable, &dwSize, 0)) == NO_ERROR) {
        // Save the interface index to use for adding an IP address
        ifIndex = pIPAddrTable->table[0].dwIndex;
        printf("\n\tInterface Index:\t%ld\n", ifIndex);
        IPAddr.S_un.S_addr = (u_long) pIPAddrTable->table[0].dwAddr;
        printf("\tIP Address:       \t%s (%lu%)\n", inet_ntoa(IPAddr),
               pIPAddrTable->table[0].dwAddr);
        IPAddr.S_un.S_addr = (u_long) pIPAddrTable->table[0].dwMask;
        printf("\tSubnet Mask:      \t%s (%lu%)\n", inet_ntoa(IPAddr),
               pIPAddrTable->table[0].dwMask);
        IPAddr.S_un.S_addr = (u_long) pIPAddrTable->table[0].dwBCastAddr;
        printf("\tBroadCast Address:\t%s (%lu%)\n", inet_ntoa(IPAddr),
               pIPAddrTable->table[0].dwBCastAddr);
        printf("\tReassembly size:  \t%lu\n\n",
               pIPAddrTable->table[0].dwReasmSize);
    } else {
        printf("Call to GetIpAddrTable failed with error %d.\n", dwRetVal);
        if (pIPAddrTable)
            FREE(pIPAddrTable);
        exit(1);
    }

    if (pIPAddrTable) {
        FREE(pIPAddrTable);
        pIPAddrTable = NULL;
    }

    if ((dwRetVal = AddIPAddress(iaIPAddress,
                                 iaIPMask,
                                 ifIndex,
                                 &NTEContext, &NTEInstance)) == NO_ERROR) {
        printf("\tIPv4 address %s was successfully added.\n", argv[1]);
    } else {
        printf("AddIPAddress failed with error: %d\n", dwRetVal);

        if (FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS, NULL, dwRetVal, MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),       // Default language
                          (LPTSTR) & lpMsgBuf, 0, NULL)) {
            printf("\tError: %s", lpMsgBuf);
            LocalFree(lpMsgBuf);
            exit(1);
        }
    }

// Delete the IP we just added using the NTEContext
// variable where the handle was returned
    if ((dwRetVal = DeleteIPAddress(NTEContext)) == NO_ERROR) {
        printf("\tIPv4 address %s was successfully deleted.\n", argv[1]);
    } else {
        printf("\tDeleteIPAddress failed with error: %d\n", dwRetVal);
        exit(1);
    }

    exit(0);
}








IP_ADAPTER_ADDRESSES *head, *curr;
IP_ADAPTER_UNICAST_ADDRESS *uni;
int buflen, err, i;

buflen = sizeof(IP_ADAPTER_UNICAST_ADDRESS) * 500;  //  enough for 500 interfaces
head = malloc(buflen);
if (!head) exit(1);



if ((err = GetAdaptersAddresses(AF_UNSPEC, 0, NULL, head,
                                &buflen)) != ERROR_SUCCESS) {
    char errbuf[300];
    FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, NULL, err,
                  0, errbuf, sizeof(errbuf), NULL);
    printf("GetAdaptersAddresses failed: (%d) %s", err, errbuf);
    free(head);
    exit(1);
}
for (curr = head; curr; curr = curr->Next) {
    if (curr->IfType != IF_TYPE_IEEE80211) continue;
    for (uni = curr->FirstUnicastAddress; uni; uni = uni->Next) {
        if (curr->OperStatus == IfOperStatusUp) {
            char addrstr[INET6_ADDRSTRLEN];

            inet_ntop(uni->Address.lpSockaddr->sa_family, uni->Address.lpSockaddr,
                      addrstr, uni->Address.iSockaddrLength);
            printf("interface name: %s\n", curr->AdapterName);
            printf("interface address: %s\n", addrstr);
        }
    }
}
free(head);


















#include <stdio.h>
#include <Windows.h>
#include <Iphlpapi.h>
#include <Assert.h>
#pragma comment(lib, "iphlpapi.lib")

char* getMAC();

int main(){
    char* pMac = getMAC();
    system("pause");
    free(pMac);
}
char* getMAC() {
    PIP_ADAPTER_INFO AdapterInfo;
    DWORD dwBufLen = sizeof(IP_ADAPTER_INFO);
    char *mac_addr = (char*)malloc(18);

    AdapterInfo = (IP_ADAPTER_INFO *) malloc(sizeof(IP_ADAPTER_INFO));
    if (AdapterInfo == NULL) {
        printf("Error allocating memory needed to call GetAdaptersinfo\n");
        free(mac_addr);
        return NULL; // it is safe to call free(NULL)
    }

    // Make an initial call to GetAdaptersInfo to get the necessary size into the dwBufLen variable
    if (GetAdaptersInfo(AdapterInfo, &dwBufLen) == ERROR_BUFFER_OVERFLOW) {
        free(AdapterInfo);
        AdapterInfo = (IP_ADAPTER_INFO *) malloc(dwBufLen);
        if (AdapterInfo == NULL) {
            printf("Error allocating memory needed to call GetAdaptersinfo\n");
            free(mac_addr);
            return NULL;
        }
    }

    if (GetAdaptersInfo(AdapterInfo, &dwBufLen) == NO_ERROR) {
        // Contains pointer to current adapter info
        PIP_ADAPTER_INFO pAdapterInfo = AdapterInfo;
        do {
            // technically should look at pAdapterInfo->AddressLength
            //   and not assume it is 6.
            sprintf(mac_addr, "%02X:%02X:%02X:%02X:%02X:%02X",
              pAdapterInfo->Address[0], pAdapterInfo->Address[1],
              pAdapterInfo->Address[2], pAdapterInfo->Address[3],
              pAdapterInfo->Address[4], pAdapterInfo->Address[5]);
            printf("Address: %s, mac: %s\n", pAdapterInfo->IpAddressList.IpAddress.String, mac_addr);
            // print them all, return the last one.
            // return mac_addr;

            printf("\n");
            pAdapterInfo = pAdapterInfo->Next;
        } while(pAdapterInfo);
    }
    free(AdapterInfo);
    return mac_addr; // caller must free.
}







#ifdef __cplusplus
    extern "C" {
#endif

#ifdef __cplusplus
    }
#endif


namespace namespace_Network {
#ifdef __cplusplus
        extern "C" {
#endif

#ifdef __cplusplus
}
#endif











int devID = 0;

/* TODO: insert the initialisers in the method when needed */
/*
    devID = findCudaDevice(deviceProp);

    std::cout<<B_BLUE<<"Most suitable GPU Device           ---> devID= "<<
        B_YELLOW<<devID<<": "<<B_CYAN<<"\""<<deviceProp.name<<"\""<<
            B_GREEN" with compute capability ---> "
    <<B_MAGENTA<<deviceProp.major<<"."<<deviceProp.minor<<COLOR_RESET<<std::endl;




std::cout<<"major: "<<major<<"  minor: "<<minor<<std::endl;
std::cout<<"typeid(deviceProp.totalGlobalMem) ---> "<<typeid(deviceProp.totalGlobalMem).name()<<std::endl;
std::cout<<"deviceProp.totalGlobalMem ---> "<<deviceProp.totalGlobalMem<<std::endl;
//std::cout<<typeid(deviceProp.name).name();


std::cout<<"npm --->"<<nmp<< " cuda_cores_per_mp ---> "<<cuda_cores_per_mp<<"  ncuda_cores ---> "<<ncuda_cores<<std::endl;





int get_CUDA_cores(cudaDeviceProp deviceProp, int idev, int gpu_major, int gpu_minor, int nmp,
           int cuda_cores_per_mp, int ncuda_cores,
           deviceDetails_t *devD);


/* getting # of Multiprocessors, CUDA cores/MP and total # of CUDA cores */
int get_CUDA_cores(cudaDeviceProp deviceProp, int idev, int gpu_major, int gpu_minor, int nmp,
       int cuda_cores_per_mp, int ncuda_cores,
       deviceDetails_t *devD) {
    int rc = RC_SUCCESS;
    int dev = idev;
    int major = gpu_major; int minor = gpu_minor;


    std::cout<<"major: "<<major<<"  minor: "<<minor<<std::endl;

    nmp = deviceProp.multiProcessorCount;


    devD->nMultiProc = nmp;
    cuda_cores_per_mp = _ConvertSMVer2Cores(deviceProp.major, deviceProp.minor);
    devD->ncudacores_per_MultiProc = cuda_cores_per_mp;
    ncuda_cores = _ConvertSMVer2Cores(deviceProp.major, deviceProp.minor) *
                   deviceProp.multiProcessorCount;
    devD->ncudacores = ncuda_cores;
    if (devD->ncudacores == 0 ) { rc = get_cuda_cores_error(devD->ncudacores); }

    /*requiring at leat a gpu_major.gpu_minor architecture Tesla card */
    bool bVal = checkCudaCapabilities(major,minor);
    /*    printf(B_BLUE"Device %d: < "
           B_YELLOW"%16s"B_BLUE
           " >, Compute SM %d.%d detected, **suitable: %s**\n",
     dev, deviceProp.name, deviceProp.major, deviceProp.minor,
           bVal?B_GREEN"yes"C_RESET :
                  B_RED"no" C_RESET);
    */
    devD->is_SMsuitable = bVal;

    return rc;
}








devD->best_dev = devID;
std::cout<<typeid(deviceProp.name).name();
strcpy(devD->best_dev_name, deviceProp.name);
devD->best_dev_compute_major = deviceProp.major;
devD->best_dev_compute_minor = deviceProp.minor;

std::cout<<B_BLUE<<"Most suitable GPU Device           ---> devID= "<<
    B_YELLOW<<devID<<": "<<B_CYAN<<"\""<<deviceProp.name<<"\""<<
        B_GREEN" with compute capability ---> "
<<B_MAGENTA<<deviceProp.major<<"."<<deviceProp.minor<<COLOR_RESET<<std::endl;




printf("Most suitable GPU Device %d: \"%s\" with compute capability %d.%d\n\n",
 devID, deviceProp.name, deviceProp.major, deviceProp.minor);


    /* getting the system informaiton class inatntiation */
    //std::cout<<p_SystemQuery_cpu_o->get_compiler_info()<<std::endl;



    _tprintf (TEXT("There are %*I64d total KB of paging file.\n"),
              WIDTH, statex.ullTotalPageFile/DIV);
    _tprintf (TEXT("There are %*I64d free  KB of paging file.\n"),
              WIDTH, statex.ullAvailPageFile/DIV);
    _tprintf (TEXT("There are %*I64d total KB of virtual memory.\n"),
              WIDTH, statex.ullTotalVirtual/DIV);
    _tprintf (TEXT("There are %*I64d free  KB of virtual memory.\n"),
              WIDTH, statex.ullAvailVirtual/DIV);
    _tprintf (TEXT("There are %*I64d free  KB of extended memory.\n"),
              WIDTH, statex.ullAvailExtendedVirtual/DIV);



#if defined (WINDOWS)
	int get_memorystatusex_windows(MEMORYSTATUSEX statex);
#endif

#if defined (WINDOWS)
  int get_memorystatusex_windows(MEMORYSTATUSEX statex) {
    int rc = RC_SUCCESS;
    MEMORYSTATUSEX statex;

    statex.dwLength = sizeof (statex);

    GlobalMemoryStatusEx (&statex);

    return rc;;
  }
#endif




    std::cout<<"wProcessorArchitecture -- > "<<sysinfo.wProcessorArchitecture<<std::endl;
    std::cout << " cpuVendor: " << cpuVendor << std::endl;
    std::cout << " cpuFeatures: " << cpuFeatures << std::endl;
    std::cout << " logical cpus: " << logical << std::endl;
    std::cout << "    cpu cores: " << cores << std::endl;
    std::cout << "hyper-threads: " << (hyperThreads ? "true" : "false") << std::endl;



    std::cout << "hyper-threads: " << (hyperThreads ? "true" : "false") << std::endl;
    std::cout << "    cpu cores: " << cores << std::endl;
    std::cout << " logical cpus: " << logical << std::endl;
    std::cout << " cpuFeatures: " << cpuFeatures << std::endl;
    std::cout << " cpuVendor: " << cpuVendor << std::endl;
    std::cout<<"wProcessorArchitecture -- > "<<sysinfo.wProcessorArchitecture<<std::endl;




    /*----------------------------------------------------*/




    nCPU_cores = 0;
    unsigned int nCores = std::thread::hardware_concurrency();
    unsigned int nCores_1 = 0;
    unsigned int nCores_2 = 0;
    nCPU_cores = 0;
    SYSTEM_INFO sysinfo;
    GetSystemInfo(&sysinfo);
    nCores_2 = sysinfo.dwNumberOfProcessors;
    hstD->nCPUlogical = nCores_2;
    //std::cout<<"wProcessorArchitecture -- > "<<sysinfo.wProcessorArchitecture<<std::endl;
    hstD->ProcessorArchitecture = sysinfo.wProcessorArchitecture;
    if (hstD->nCPUlogical < 1 ) {rc = RC_FAIL;}

    X86Regs *p_Regs_out = (struct X86Regs*)malloc(sizeof(struct X86Regs));

    // Get vendor
    char vendor[12];
    cpuID(0, p_Regs_out);
    ((unsigned *)vendor)[0] = p_Regs_out->ebx;//regs[1]; // EBX
    ((unsigned *)vendor)[1] = p_Regs_out->edx;//regs[3]; // EDX
    ((unsigned *)vendor)[2] = p_Regs_out->ecx;//regs[2]; // ECX
    std::string cpuVendor = std::string(vendor, 12);
    //std::cout << " cpuVendor: " << cpuVendor << std::endl;
    strcpy(hstD->cpuVendor, cpuVendor.c_str());

    // Get CPU features
    cpuID(1, p_Regs_out);
    unsigned cpuFeatures = p_Regs_out->edx;//regs[3]; // EDX
    //std::cout << " cpuFeatures: " << cpuFeatures << std::endl;
    hstD->cpuFeatures = cpuFeatures;

    // Logical core count per CPU
    cpuID(1, p_Regs_out);
    unsigned logical = (p_Regs_out->ebx >> 16) & 0xff; // EBX[23:16]
    //std::cout << " logical cpus: " << logical << std::endl;
    unsigned cores = logical;
    hstD->nCPUlogical = logical;

    if (cpuVendor == "GenuineIntel") {
      // Get DCP cache info
      cpuID(4, p_Regs_out);
      cores = ((p_Regs_out->eax >> 26) & 0x3f) + 1; // EAX[31:26] + 1

    } else if (cpuVendor == "AuthenticAMD") {
      // Get NC: Number of CPU cores - 1
      cpuID(0x80000008, p_Regs_out);
      cores = ((unsigned)(p_Regs_out->ecx & 0xff)) + 1; // ECX[7:0] + 1
    }
    //std::cout << "    cpu cores: " << cores << std::endl;
    hstD->n_phys_proc = cores;

    // Detect hyper-threads
    bool hyperThreads = cpuFeatures & (1 << 28) && cores < logical;
    //std::cout << "hyper-threads: " << (hyperThreads ? "true" : "false") << std::endl;
    hstD->hyper_threads = (hyperThreads ? "true" : "false");



/*----------------------------------------------------*/
    //std::cout<<"wProcessorArchitecture -- > "<<sysinfo.wProcessorArchitecture<<std::endl;
    //std::cout << " cpuVendor: " << cpuVendor << std::endl;
    //std::cout << " cpuFeatures: " << cpuFeatures << std::endl;
    //std::cout << " logical cpus: " << logical << std::endl;
    //std::cout << "    cpu cores: " << cores << std::endl;
    //std::cout << "hyper-threads: " << (hyperThreads ? "true" : "false") << std::endl;




cudaError_t err;







    s_systemDetails->n_phys_proc = 1;
    s_systemDetails->nCPUcores   = 1;
    s_systemDetails->mem_size    = 0;
    s_systemDetails->avail_Mem   = 0;

        s_kernel->time = 1.0;
        s_kernel->ikrnl = 1;
        s_kernel->threadsPerBlock = nthrdsBlock;
        s_kernel->nthrdx = nx_3D;
        s_kernel->nthrdy = ny_3D;
        s_kernel->nthrdz = nz_3D;

    s_debug_gpu->debug_i = 1;
    s_debug_gpu->debug_cpu_i = 1;
    s_debug_gpu->debug_high_i = 0;
    s_debug_gpu->debug_write_i = 0;
    s_debug_gpu->debug_write_C_i = 0;


    std::cout<<"in get_CPU_cores   ---> "<<" before structure mapping"<<std::endl;


    std::cout<<"hstD->n_phys_proc ---> "<<hstD->n_phys_proc<<std::endl;
    std::cout<<"hstD->nCPUcores   ---> "<<hstD->nCPUcores<<std::endl;
    std::cout<<"hstD->mem_size    ---> "<<hstD->mem_size<<std::endl;


    hstD->n_phys_proc = 0;
    hstD->nCPUcores = nCores;
    hstD->mem_size = 0;

    printf(B_GREEN "CPU_cores: %i\n" C_RESET, hstD->nCPUcores);


    std::cout << typeid(sysinfo.wProcessorArchitecture).name() << std::endl;



    //rc = get_warning_message_linux_cpu();
    std::cout<<B_BLUE<<"The number of cores on the machine : ---> "<<B_YELLOW<<hstD->nCPUcores<<std::endl;
    /* poupulating the systemDetails_t datastructure */
    //hstD->n_phys_proc = n_phys_proc;
    //hstD->nCPUcores = *nCPU_cores;

            std::cout<<B_BLUE<<"n_phys_proc         --> "<<B_YELLOW<<hstD->n_phys_proc<<std::endl;
            std::cout<<B_BLUE<<"nCPUcores           --> "<<B_YELLOW<<hstD->nCPUlogical<<std::endl;
            std::cout<<B_BLUE<<"mem_size            --> "<<B_YELLOW<<hstD->mem_size<<std::endl;
            std::cout<<B_BLUE<<"hstD->hyper_threads --> "<<B_YELLOW<<hstD->hyper_threads<<std::endl;
            std::cout<<B_BLUE<<"hstD->cpuFeatures   --> "<<B_YELLOW<<hstD->cpuFeatures<<std::endl;



*cpuVendor = (char*)malloc(sizeof(char)*12);
s_systemDetails->cpuVendor.assign("GenuineIntel", sizeof("GenuineIntel"+12));




std::cout<< "nthreads ---> "<< nthreads <<std::endl;
std::cout<< "nthreads ---> "<<sysinfo.dwNumberOfProcessors<<std::endl;



asm volatile ( "cpuid": "=a"(Regs_out->eax), "=b"(Regs_out->ebx),
  "=c"(Regs_out->ecx), "=d"(Regs_out->edx):"a"(eax_in)   );


asm volatile
      ("cpuid" : "=a" (regs[0]), "=b" (regs[1]), "=c" (regs[2]), "=d" (regs[3])
       : "a" (i), "c" (0));


/*
asm volatile ("cpuid"	: 	"=a"(Regs_out->eax),
              "=b"(Regs_out->ebx),
              "=c"(Regs_out->ecx),
              "=d"(Regs_out->edx)
              :	"a"(eax_in));
*/


int eax, ebx, ecx, edx;

union
{
  char vchar[16];
  int  vint[4];
} vendor;

cpuid(0, Regs_out->eax, &Regs_out->ebx, Regs_out->ecx, Regs_out->edx);





#if defined (WINDOWS)
            rc = namespace_System::get_warning_message_linux_cpu();
#endif



//
// Created by Frederic on 12/3/2023.
//
std::cout<< (float)strftime(buf, sizeof(buf), "%X", &(localtime(&(time(0)))))<<std::endl;

strftime(buf_secs, sizeof(buf_secs), "%X", &tstruct);
printf("%s\n",buf_secs);
char       buf_secs[80];



//auto start = std::chrono::system_clock::now();
//std::chrono::duration<double> start_seconds = start;
//char buf[80];


s_kernel_o->time = (float)ctime(&(time(0)));

printf("Number of threads in the z direction time = %f\n",s_kernel_o->time);
printf("Number of threads in the z direction ntrdz = %i\n",s_kernel_o->nthrdz);
printf("Number of threads in the z direction ntrdz = %i\n",nx_3D);

