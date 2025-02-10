//
// Created by Fred on 12/7/2023.
//
// System include
#include <iostream>
#include <sstream>

// Application includes
#include "common.cuh"

#ifndef GET_SYSTEMQUERY_CPU_CUH
#define GET_SYSTEMQUERY_CPU_CUH

#define PRECISION_z

namespace namespace_System_cpu {

#if defined (WINDOWS)
/* ////////////////////////////////////////////////////////////////////////////
   -- class declaration SystemQuery_cpu
*/
//X86 CPU registers relevant to CPUID, in a struct to keep them together.
struct X86Regs
{
	uint32_t	eax;
	uint32_t	ebx;
	uint32_t	ecx;
	uint32_t	edx;
};
//Information returned by CPUID subfunction 1, in a struct to keep them together.
struct	X86CPUInfo
{
	uint32_t	Stepping;
	uint32_t	Model;
	uint32_t	Family;
	uint32_t	Type;
	uint32_t	ExtendedModel;
	uint32_t	ExtendedFamily;
};
#endif
/* ////////////////////////////////////////////////////////////////////////////
   -- class declaration SystemQuery_cpu
*/
class SystemQuery_cpu {
private:
public:
	std::string ver_o;
	/* constructor */
	SystemQuery_cpu();
    /* methods */
    int _initialize();
    int _finalize();
    std::string get_compiler_info();
    /* Helper functions */
	inline void cpuID(uint32_t eax_in, X86Regs* Regs_out);
	int use_cpuid_to_fill_systemDetails(int *nCPU_cores, systemDetails *hstD);
	int get_Number_CPU_cores(int *nCPU_cores, systemDetails *hstD);
	int get_memorySize_host(long long int *memSize, systemDetails *hstD);
	int get_available_memory_host(long long int *availMem, systemDetails *hstD);
	float convert_memory(long long int mem);
	/* Destructor */
    ~SystemQuery_cpu();
}; /* end of class SystemQuery_cpu declaration */
/* ////////////////////////////////////////////////////////////////////////////
*/
#ifdef __cplusplus
extern "C" {
#endif

    /*error and warning handlers methods */
    int get_error_cpu();
    int get_warning_message_linux_cpu();
    int get_warning_message_macosx_cpu();
    /* quering handlers methods */
	inline void cpuID(uint32_t eax_in, X86Regs *Regs_out);
	int get_CPU_cores(int *nCPU_cores, systemDetails *hstD);
	int get_memorySize_host(long long int *memSize, systemDetails *hstD);
	int get_available_memory_host(long long int *availMem, systemDetails *hstD);
	float convert_memory(long long int mem);
	//int print_tprintf_windows(MEMORYSTATUSEX statex);
#ifdef __cplusplus
}
#endif

#undef PRECISION_z

} /* end of namespace namespace_System */


#endif //GET_SYSTEMQUERY_CPU_CUH
