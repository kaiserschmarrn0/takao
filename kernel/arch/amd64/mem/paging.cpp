// File: paging.cpp
//
// Description: Paging for AMD64 architecture
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "paging.hpp"
#include <cpu/check.hpp>

void paging_init(void)
{
	// We use IA32e paging, which involves setting following registers:
	// MSR IA32_EFER.LME = 1
	// CR4.PAE = 1
	// We must check if IA32_EFER is available by checking 
	// CPUID.80000001H.EDX[bit 20 or 29] == 1.
	const uint32_t IA32_EFER_MSR = 0xC0000080;
	const uint64_t CR4_PAE_BIT = (1ull << 5);
	const uint64_t IA32_EFER_LME_BIT = (1ull << 8);
	const uint64_t IA32_EFER_NXE_BIT = (1ull << 11);

	uint64_t efer = cpu_read_msr(IA32_EFER_MSR);
	efer |= IA32_EFER_LME_BIT;
	efer |= IA32_EFER_NXE_BIT;
	cpu_write_msr(IA32_EFER_MSR, efer);
	uint64_t cr4;
	__asm__("movq %%cr4, %0" : "=r"(cr4));
	cr4 |= CR4_PAE_BIT;
	__asm__("movq %0, %%cr4" :: "r"(cr4));
}