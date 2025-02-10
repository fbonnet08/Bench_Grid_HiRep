//
// Created by Fred on 12/7/2023.
//
// System includes
#include <iostream>
#include <sstream>

#if defined (WINDOWS)
#include <windows.h>
#include <thread>
//#include <SDKDDKVer.h>
//#include <processthreadsapi.h>
//#include <psapi.h>
#include <tchar.h>

#include <intrin.h>
#include <array>
#include <iomanip>
#include <string>
#include<conio.h>

#endif


// Application includes
//#include "../include/common.cuh"
//#include "../include/get_systemQuery_cpu.cuh"

#include "../global.cuh"
//#include "../include/Exception.cuh"
//#include "../include/resmap_Sizes.cuh"

namespace namespace_System_cpu {

SystemQuery_cpu::SystemQuery_cpu() {
  int rc = RC_SUCCESS;
  /* initializing the structure variables */
  rc = SystemQuery_cpu::_initialize();
  std::cout<<B_CYAN<<"Class SystemQuery_cpu::SystemQuery_cpu() has been instantiated, return code: "<<B_GREEN<<rc<<COLOR_RESET<<std::endl;
  } /* end of SystemQuery_cpu constructor */
int SystemQuery_cpu::_initialize() {
    int rc = RC_SUCCESS;
    /* TODO: insert the initialisers in the method when needed */
    return rc;
  } /* end of _initialize method */
inline void SystemQuery_cpu::cpuID(uint32_t eax_in, X86Regs *Regs_out) {
    std::array<int, 4> cpuInfo;
    //__cpuid(cpuInfo.data(), eax_in);
    __cpuid(cpuInfo.data(), eax_in);
    std::ostringstream buffer;
    buffer
      << std::uppercase << std::hex << std::setfill('0')
      << std::setw(8) << cpuInfo.at(0)<< " "
      << std::setw(8) << cpuInfo.at(1)<< " "
      << std::setw(8) << cpuInfo.at(2)<< " "
      << std::setw(8) << cpuInfo.at(3);
    //std::cout<<" buffer.str() ---> "<< buffer.str()<<std::endl;
    Regs_out->eax = cpuInfo.at(0);
    Regs_out->ebx = cpuInfo.at(1);
    Regs_out->ecx = cpuInfo.at(2);
    Regs_out->edx = cpuInfo.at(3);
  } /* end of cpuID method */
int SystemQuery_cpu::use_cpuid_to_fill_systemDetails(int *nCPU_cores, systemDetails *hstD) {
    int rc = RC_SUCCESS;
    //unsigned int nCores = 0;
    //unsigned int nCores_1 = 0;
    unsigned int nCores_2 = 0;
    nCPU_cores = 0;
    SYSTEM_INFO sysinfo;
    GetSystemInfo(&sysinfo);
    nCores_2 = sysinfo.dwNumberOfProcessors;
    hstD->nCPUlogical = nCores_2;
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
    strcpy(hstD->cpuVendor, cpuVendor.c_str());

    // Get CPU features
    cpuID(1, p_Regs_out);
    unsigned cpuFeatures = p_Regs_out->edx;//regs[3]; // EDX
    hstD->cpuFeatures = cpuFeatures;

    // Logical core count per CPU
    cpuID(1, p_Regs_out);
    unsigned logical = (p_Regs_out->ebx >> 16) & 0xff; // EBX[23:16]
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
    hstD->n_phys_proc = cores;

    // Detect hyper-threads
    bool hyperThreads = cpuFeatures & (1 << 28) && cores < logical;
    hstD->hyper_threads = (hyperThreads ? "true" : "false");
    return rc;
  } /* end of use_cpuid_to_fill_systemDetails method */
int SystemQuery_cpu::get_Number_CPU_cores(int *nCPU_cores, systemDetails *hstD) {
    int rc = RC_SUCCESS;
    unsigned int nCores = 0;
    unsigned int nCores_1 = 0;
    unsigned int nCores_2 = 0;
    nCores_1 = std::thread::hardware_concurrency();
    int n_phys_proc = 0;
#if defined (LINUX)
    *nCPU_cores = 0;
    *nCPU_cores = sysconf(_SC_NPROCESSORS_ONLN);
    hstD->nCPUcores = *nCPU_cores;
    if (hstD->nCPUcores < 1 ) {rc = RC_FAIL;}
    //printf(B_GREEN "CPU_cores: %i\n" C_RESET, hstD->nCPUcores);
#elif defined (WINDOWS)
    rc = use_cpuid_to_fill_systemDetails(nCPU_cores, hstD);
#elif
    nCores_2 = nCores_1;
#endif
    /* checking the windows case with this crazy SYSTEM_INFO data structure */
    if (nCores_1 == nCores_2){nCores = nCores_1;}
    return nCores;
  } /* end of get_Number_CPU_cores method */
int SystemQuery_cpu::get_memorySize_host(long long int *memSize, systemDetails *hstD) {
  int rc = RC_SUCCESS;
  std::cout<<B_BLUE<<"*------- Memory host ------------------*"<<std::endl;
#if defined (LINUX)
  *memSize = 0;
  *memSize = sysconf(_SC_PHYS_PAGES) * sysconf(_SC_PAGESIZE);
  hstD->mem_Size = *memSize;
  printf(B_BLUE"Sys total memory: "
   B_YELLOW"%6.2f MBytes,"
   B_GREEN" %lli bytes. \n"
   C_RESET,
   convert_memory(hstD->mem_Size), hstD->mem_Size);
#elif defined (WINDOWS)
  memSize = 0;
  MEMORYSTATUSEX statex;
  statex.dwLength = sizeof (statex);

  GlobalMemoryStatusEx (&statex);

  hstD->total_phys_mem = (long long int)(statex.ullTotalPhys/DIV);
  std::cout<<B_BLUE<<"Total physical memory (kB)         ---> "<<
    B_YELLOW<<convert_memory(hstD->total_phys_mem)<<B_BLUE<<" (GB)"<<std::endl;
  std::cout<<COLOR_RESET;
#elif defined (MACOSX)
  rc = get_warning_message_macosx_cpu();
#endif
  std::cout<<B_BLUE<<"*--------------------------------------*"<<std::endl;

  if (rc == RC_FAIL) { rc = get_error_cpu(); }
  return rc;
} /* end of get_memorySize_host method */
int SystemQuery_cpu::get_available_memory_host(long long int *availMem, systemDetails *hstD) {
    int rc = RC_SUCCESS;
    std::cout<<B_BLUE<<"*------- Memory available host --------*"<<std::endl;
#if defined (LINUX)
    *availMem = 0;
    *availMem = sysconf(_SC_AVPHYS_PAGES) * sysconf(_SC_PAGESIZE);
    hstD->avail_Mem = *availMem;
    printf(B_BLUE "Available memory: "
           B_YELLOW"%6.2f MBytes,"
           B_GREEN" %lli bytes\n"
           C_RESET,
	   convert_memory(hstD->avail_Mem), hstD->avail_Mem);
#elif defined (WINDOWS)
    availMem = 0;
    MEMORYSTATUSEX statex;
    statex.dwLength = sizeof (statex);

    GlobalMemoryStatusEx (&statex);
    //print_tprintf_windows(statex);

    hstD->MemoryLoad_pc = (float)(statex.dwMemoryLoad);
    std::cout<<B_BLUE<<"Memory in use (%)                  ---> "<<
      B_YELLOW<<hstD->MemoryLoad_pc<<B_BLUE<<" (%)"<<std::endl;
    std::cout<<COLOR_RESET;

    hstD->TotalPhys_kB = (long long int)(statex.ullTotalPhys/DIV);
    std::cout<<B_BLUE<<"Total physical memory              ---> "<<
      B_YELLOW<<convert_memory(hstD->TotalPhys_kB)<<B_BLUE<<" (GB)"<<std::endl;
    std::cout<<COLOR_RESET;

    hstD->avail_phys_mem = (long long int)(statex.ullAvailPhys/DIV);
    std::cout<<B_BLUE<<"Free physical memory               ---> "<<
      B_YELLOW<<convert_memory(hstD->avail_phys_mem)<<B_BLUE<<" (GB)"<<std::endl;
    std::cout<<COLOR_RESET;

    hstD->TotalPageFile_kB = (long long int)(statex.ullTotalPageFile/DIV);
    std::cout<<B_BLUE<<"Total of paging file               ---> "<<
      B_YELLOW<<convert_memory(hstD->TotalPageFile_kB)<<B_BLUE<<" (GB)"<<std::endl;
    std::cout<<COLOR_RESET;

    hstD->AvailPageFile_kB = (long long int)(statex.ullAvailPageFile/DIV);
    std::cout<<B_BLUE<<"Free of paging file                ---> "<<
      B_YELLOW<<convert_memory(hstD->AvailPageFile_kB)<<B_BLUE<<" (GB)"<<std::endl;
    std::cout<<COLOR_RESET;

    hstD->TotalVirtual_kB = (long long int)(statex.ullTotalVirtual/DIV);
    std::cout<<B_BLUE<<"Total of virtual memory            ---> "<<
      B_YELLOW<<convert_memory(hstD->TotalVirtual_kB)<<B_BLUE<<" (GB)"<<std::endl;
    std::cout<<COLOR_RESET;

    hstD->AvailVirtual_kB = (long long int)(statex.ullAvailVirtual/DIV);
    std::cout<<B_BLUE<<"Free virtual memory                ---> "<<
      B_YELLOW<<convert_memory(hstD->AvailVirtual_kB)<<B_BLUE<<" (GB)"<<std::endl;
    std::cout<<COLOR_RESET;

    // Show the amount of extended memory available.
    hstD->AvailExtendedVirtual_kB = (long long int)(statex.ullAvailExtendedVirtual/DIV);
    std::cout<<B_BLUE<<"Free virtual extended memory       ---> "<<
      B_YELLOW<<hstD->AvailExtendedVirtual_kB<<B_BLUE<<" (kB)"<<std::endl;
    std::cout<<COLOR_RESET;

#elif defined (MACOSX)
    rc = get_warning_message_macosx_cpu();
#endif
  std::cout<<B_BLUE<<"*--------------------------------------*"<<std::endl;

    if (rc == RC_FAIL) { rc = get_error_cpu(); }
    return rc;
} /* end of get_available_memory_host method */
float SystemQuery_cpu::convert_memory(long long int mem) {
  int rc = RC_SUCCESS;
  float mem_conv = 0.0f;
  mem_conv = mem / (1024 * 1024);

  if (mem_conv == 0 ) { rc = RC_FAIL;}
  if (rc == RC_FAIL) { rc = get_error_cpu(); }

  return mem_conv;
} /* end of convert_memory method */
std::string SystemQuery_cpu::get_compiler_info() {
  std::stringstream str;
#if defined (__clang__)
    str<<"clang "<<__clang_major__<<'.'<<__clang_minor__<<'.'<<__clang_patchlevel__;
#elif defined (__GNUC__) && !defined (__ICC)
    str<<"gcc "<<__GNUC__<<'.'<<__GNUC_MINOR__<<'.'<<__GNUC_PATCHLEVEL__;
#elif defined (_MSC_VER)
    str<<B_BLUE    <<"compiler info msvc                 ---> "<<B_CYAN<<_MSC_VER<<COLOR_RESET;
  #elif defined (_ICC)
    str<<"icc "<<__version__;
#endif
    SystemQuery_cpu::ver_o = str.str();
    return str.str();
  } /* end of get_compiler_info method */
int SystemQuery_cpu::_finalize() {
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
SystemQuery_cpu::~SystemQuery_cpu() {
    int rc = RC_SUCCESS;
    rc = _finalize();
    if (rc != RC_SUCCESS) {
      std::cerr<<B_RED"return code: "<<rc
	       <<" line: "<<__LINE__<<" file: "<<__FILE__<<C_RESET<<std::endl;
      exit(rc);
    } else {rc = RC_SUCCESS; /*print_destructor_message("DataDeviceManag");*/}
    rc = get_returnCode(rc, "SystemQuery_cpu", 0);
  } /* end of ~SystemQuery_cpu destructor */
/***************************************************************************/
/**
***/
#ifdef __cplusplus
extern "C" {
#endif
  /***************************************************************************/
  /**
   * API - functions (interface)
   *
   ***/
  float convert_memory(long long int mem) {
    int rc = RC_SUCCESS;
    float mem_conv = 0.0f;
    mem_conv = mem / (1024 * 1024);

    if (mem_conv == 0 ) { rc = RC_FAIL;}
    if (rc == RC_FAIL) { rc = get_error_cpu(); }

    return mem_conv;
  } /* end of convert_memory method */
  /* determine the physical usable memory size on Linux */
  int get_memorySize_host(long long int *memSize, systemDetails *hstD) {
    int rc = RC_SUCCESS;
#if defined (LINUX)
    *memSize = 0;
    *memSize = sysconf(_SC_PHYS_PAGES) * sysconf(_SC_PAGESIZE);
    hstD->mem_Size = *memSize;
    printf(B_BLUE"Sys total memory: "
	   B_YELLOW"%6.2f MBytes,"
	   B_GREEN" %lli bytes. \n"
	   C_RESET,
	   convert_memory(hstD->mem_Size), hstD->mem_Size);
#elif defined (WINDOWS)
    memSize = 0;
    MEMORYSTATUSEX statex;
    statex.dwLength = sizeof (statex);

    GlobalMemoryStatusEx (&statex);

    hstD->total_phys_mem = (long long int)(statex.ullTotalPhys/DIV);
    std::cout<<B_BLUE<<"Total physical memory (kB)         ---> "<<
      B_YELLOW<<convert_memory(hstD->total_phys_mem)<<B_BLUE<<" (GB)"<<std::endl;
    std::cout<<COLOR_RESET;
#elif defined (MACOSX)
    rc = get_warning_message_macosx_cpu();
#endif

    if (rc == RC_FAIL) { rc = get_error_cpu(); }
    return rc;
  } /* end of get_memorySize_host method */
#if defined (WINDOWS)
  int print_tprintf_windows(MEMORYSTATUSEX statex) {
    int rc = RC_SUCCESS;
    _tprintf (TEXT("There is  %*ld percent of memory in use.\n"),
               WIDTH, statex.dwMemoryLoad);
    _tprintf (TEXT("There are %*I64d total KB of physical memory.\n"),
              WIDTH, statex.ullTotalPhys/DIV);
    _tprintf (TEXT("There are %*I64d free  KB of physical memory.\n"),
              WIDTH, statex.ullAvailPhys/DIV);
    _tprintf (TEXT("There are %*I64d total KB of paging file.\n"),
              WIDTH, statex.ullTotalPageFile/DIV);
    _tprintf (TEXT("There are %*I64d free  KB of paging file.\n"),
              WIDTH, statex.ullAvailPageFile/DIV);
    _tprintf (TEXT("There are %*I64d total KB of virtual memory.\n"),
              WIDTH, statex.ullTotalVirtual/DIV);
    _tprintf (TEXT("There are %*I64d free  KB of virtual memory.\n"),
              WIDTH, statex.ullAvailVirtual/DIV);
    // Show the amount of extended memory available.
    _tprintf (TEXT("There are %*I64d free  KB of extended memory.\n"),
              WIDTH, statex.ullAvailExtendedVirtual/DIV);
    return rc;
  } /* end of print_tprintf_windows method */
#endif
  /* determine the available memory size on Linux */
  int get_available_memory_host(long long int *availMem, systemDetails *hstD) {
    int rc = RC_SUCCESS;
#if defined (LINUX)
    *availMem = 0;
    *availMem = sysconf(_SC_AVPHYS_PAGES) * sysconf(_SC_PAGESIZE);
    hstD->avail_Mem = *availMem;
    printf(B_BLUE "Available memory: "
           B_YELLOW"%6.2f MBytes,"
           B_GREEN" %lli bytes\n"
           C_RESET,
	   convert_memory(hstD->avail_Mem), hstD->avail_Mem);
#elif defined (WINDOWS)
    availMem = 0;
    MEMORYSTATUSEX statex;
    statex.dwLength = sizeof (statex);

    GlobalMemoryStatusEx (&statex);
    //if (s_debug_gpu->debug_high_i == 1) {rc = print_tprintf_windows(statex);}

    hstD->MemoryLoad_pc = (float)(statex.dwMemoryLoad);
    std::cout<<B_BLUE<<"Memory in use (%)                  ---> "<<
      B_YELLOW<<hstD->MemoryLoad_pc<<B_BLUE<<" (%)"<<std::endl;
    std::cout<<COLOR_RESET;

    hstD->TotalPhys_kB = (long long int)(statex.ullTotalPhys/DIV);
    std::cout<<B_BLUE<<"Total physical memory              ---> "<<
      B_YELLOW<<convert_memory(hstD->TotalPhys_kB)<<B_BLUE<<" (GB)"<<std::endl;
    std::cout<<COLOR_RESET;

    hstD->avail_phys_mem = (long long int)(statex.ullAvailPhys/DIV);
    std::cout<<B_BLUE<<"Free physical memory               ---> "<<
      B_YELLOW<<convert_memory(hstD->avail_phys_mem)<<B_BLUE<<" (GB)"<<std::endl;
    std::cout<<COLOR_RESET;

    hstD->TotalPageFile_kB = (long long int)(statex.ullTotalPageFile/DIV);
    std::cout<<B_BLUE<<"Total of paging file               ---> "<<
      B_YELLOW<<convert_memory(hstD->TotalPageFile_kB)<<B_BLUE<<" (GB)"<<std::endl;
    std::cout<<COLOR_RESET;

    hstD->AvailPageFile_kB = (long long int)(statex.ullAvailPageFile/DIV);
    std::cout<<B_BLUE<<"Free of paging file                ---> "<<
      B_YELLOW<<convert_memory(hstD->AvailPageFile_kB)<<B_BLUE<<" (GB)"<<std::endl;
    std::cout<<COLOR_RESET;

    hstD->TotalVirtual_kB = (long long int)(statex.ullTotalVirtual/DIV);
    std::cout<<B_BLUE<<"Total of virtual memory            ---> "<<
      B_YELLOW<<convert_memory(hstD->TotalVirtual_kB)<<B_BLUE<<" (GB)"<<std::endl;
    std::cout<<COLOR_RESET;

    hstD->AvailVirtual_kB = (long long int)(statex.ullAvailVirtual/DIV);
    std::cout<<B_BLUE<<"Free virtual memory                ---> "<<
      B_YELLOW<<convert_memory(hstD->AvailVirtual_kB)<<B_BLUE<<" (GB)"<<std::endl;
    std::cout<<COLOR_RESET;

    // Show the amount of extended memory available.
    hstD->AvailExtendedVirtual_kB = (long long int)(statex.ullAvailExtendedVirtual/DIV);
    std::cout<<B_BLUE<<"Free virtual extended memory       ---> "<<
      B_YELLOW<<hstD->AvailExtendedVirtual_kB<<B_BLUE<<" (kB)"<<std::endl;
    std::cout<<COLOR_RESET;

#elif defined (MACOSX)
    rc = get_warning_message_macosx_cpu();
#endif

    if (rc == RC_FAIL) { rc = get_error_cpu(); }
    return rc;
  } /* end of get_available_memory_host method */
  inline void cpuID(uint32_t eax_in, X86Regs *Regs_out) {
    std::array<int, 4> cpuInfo;
    //__cpuid(cpuInfo.data(), eax_in);
    __cpuid(cpuInfo.data(), eax_in);
    std::ostringstream buffer;
    buffer
      << std::uppercase << std::hex << std::setfill('0')
      << std::setw(8) << cpuInfo.at(0)<< " "
      << std::setw(8) << cpuInfo.at(1)<< " "
      << std::setw(8) << cpuInfo.at(2)<< " "
      << std::setw(8) << cpuInfo.at(3);
    //std::cout<<" buffer.str() ---> "<< buffer.str()<<std::endl;
    Regs_out->eax = cpuInfo.at(0);
    Regs_out->ebx = cpuInfo.at(1);
    Regs_out->ecx = cpuInfo.at(2);
    Regs_out->edx = cpuInfo.at(3);
  } /* end of cpuID method */
  /* determine the number of cores on the host on Linux */
  int get_CPU_cores(int *nCPU_cores, systemDetails *hstD) {
    int rc = RC_SUCCESS;
    int n_phys_proc = 0;
#if defined (LINUX)
    *nCPU_cores = 0;
    *nCPU_cores = sysconf(_SC_NPROCESSORS_ONLN);
    hstD->nCPUcores = *nCPU_cores;
    if (hstD->nCPUcores < 1 ) {rc = RC_FAIL;}
    printf(B_GREEN "CPU_cores: %i\n" C_RESET, hstD->nCPUcores);
#elif defined(WINDOWS)
    nCPU_cores = 0;
    //unsigned int nCores = std::thread::hardware_concurrency();
    //unsigned int nCores_1 = 0;
    unsigned int nCores_2 = 0;
    nCPU_cores = 0;
    SYSTEM_INFO sysinfo;
    GetSystemInfo(&sysinfo);
    nCores_2 = sysinfo.dwNumberOfProcessors;
    hstD->nCPUlogical = nCores_2;
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
    strcpy(hstD->cpuVendor, cpuVendor.c_str());

    // Get CPU features
    cpuID(1, p_Regs_out);
    unsigned cpuFeatures = p_Regs_out->edx;//regs[3]; // EDX
    hstD->cpuFeatures = cpuFeatures;

    // Logical core count per CPU
    cpuID(1, p_Regs_out);
    unsigned logical = (p_Regs_out->ebx >> 16) & 0xff; // EBX[23:16]
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
    hstD->n_phys_proc = cores;

    // Detect hyper-threads
    bool hyperThreads = cpuFeatures & (1 << 28) && cores < logical;
    hstD->hyper_threads = (hyperThreads ? "true" : "false");

#elif defined (MACOSX)
    rc = get_warning_message_macosx_cpu();
#endif
    if (rc == RC_FAIL) { rc = get_error_cpu(); }
    return rc;
  } /* end of get_CPU_cores method */
  /* getting the warning message from the cuda */
  int get_warning_message_linux_cpu() {
    int rc = RC_SUCCESS;

    printf("***************************WARNING*****************************\n");
    printf("You need to compile with -DLINUX to acces the linux environment\n");
    printf("operating system                                               \n");
    printf("***************************************************************\n");
    printf("\n");
    printf("Exit at Line %i in file %s %s\n",__LINE__,__FILE__,__FUNCTION__);
    printf("\n");
    rc = RC_FAIL;

    return rc;
  } /* end of get_warning_message_linux_cpu method */
  /* getting the warning message from the cuda */
  int get_warning_message_macosx_cpu() {
    int rc = RC_SUCCESS;

    printf("***************************WARNING*****************************\n");
    printf("You need to compile with -DMACOSX for the macosx environment   \n");
    printf("operating system                                               \n");
    printf("***************************************************************\n");
    printf("\n");
    printf("Exit at Line %i in file %s %s\n",__LINE__,__FILE__,__FUNCTION__);
    printf("\n");
    rc = RC_FAIL;

    return rc;
  } /* end of get_warning_message_macosx_cpu method */
  /*getting the error message and return code */
  int get_error_cpu() {
    int rc = RC_SUCCESS;
    printf("rc  = %i, at Line %i in file %s %s\n",
	   rc,__LINE__,__FILE__,__FUNCTION__);
    printf("Result = FAIL\n");
    rc = RC_FAIL;
    exit(EXIT_FAILURE);
    return rc;
  } /* end of get_error_cpu method */
  /* ////////////////////////////////////////////////////////////////////////////
       -- routines used to interface back to fortran
       *
       *  C-FORTRAN-Python API - functions
       *
  */
#if defined (LINUX)
  /* the aliases for external access */
  extern "C" int get_cpu_cores_() __attribute__((weak,alias("get_CPU_cores")));
  extern "C" int get_memorysize_host_() __attribute__((weak,alias("get_memorySize_host")));
  extern "C" int get_available_memory_host_() __attribute__((weak,alias("get_available_memory_host")));
#endif

#ifdef __cplusplus
}
#endif

} /* end of namespace namespace_System */

