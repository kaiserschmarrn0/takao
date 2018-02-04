// File: cpucheck.cpp
//
// Description: CPU info rescuing
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include <cpu/cpucheck.hpp>

const uint32_t HAS_APIC = 1 << 9;
const uint32_t HAS_X2APIC = 1 << 21;
const uint32_t HAS_MSR = 1 << 5;
const uint32_t HAS_IA32_EFER = 1 << 20 | 1 << 29;
const uint32_t HAS_SSE = 1 << 25;
const uint32_t HAS_SSE2 = 1 << 26;
const uint64_t CR0_EM_BIT = 1 << 2;
const uint64_t CR0_MP_BIT = 1 << 1;
const uint64_t CR4_OSFXSR_BIT = 1 << 9;
const uint64_t CR4_OSXMMEXCPT_BIT = 1 << 10;

namespace cpu {
	void check_cpu(struct cpuinfo *cpuinfo)
	{
		uint32_t b, c, d, a = 1;
		__asm__("cpuid" : "=d"(d), "=b"(b), "=c"(c), "+a"(a));

		cpuinfo->has_apic = (d & HAS_APIC) != 0;
		cpuinfo->has_x2apic = (c & HAS_X2APIC) != 0;
		cpuinfo->has_msr = (d & HAS_MSR) != 0;
		cpuinfo->has_sse = (d & HAS_SSE) != 0;
		cpuinfo->has_sse2 = (d & HAS_SSE2) != 0;
	
		a = 0x80000001;
		__asm__("cpuid" : "=d"(d), "=b"(b), "=c"(c), "+a"(a));
		cpuinfo->has_ia32_efer = d & HAS_IA32_EFER;
	
		// If SSE is present, enable it
		if(cpuinfo->has_sse || cpuinfo->has_sse2) {
			write_cr0((read_cr0() & ~CR0_EM_BIT) | CR0_MP_BIT);
			write_cr4(read_cr4() | CR4_OSFXSR_BIT | CR4_OSXMMEXCPT_BIT);
		}
	}
}

uint64_t cpu_read_msr(uint32_t msr)
{
	uint32_t a, d;
	__asm__ volatile("rdmsr" : "=a"(a), "=d"(d) : "c"(msr));
	return ((uint64_t)d) << 32 | a;
}

void cpu_write_msr(uint32_t msr, uint64_t data)
{
	__asm__ volatile("wrmsr;"::"c"(msr), "a"((uint32_t)data), "d"((uint32_t)(data>>32)));
}

uint64_t read_cr0()
{
	uint64_t value;
	__asm__("movq %%cr0, %0" : "=r"(value));
	return value;
}

void write_cr0(uint64_t value)
{
	__asm__("movq %0, %%cr0" :: "r"(value));
}

uint64_t read_cr3()
{
	uint64_t value;
	__asm__("movq %%cr3, %0" : "=r"(value));
	return value;
}

void write_cr3(uint64_t value)
{
	__asm__("movq %0, %%cr3" :: "r"(value));
}

uint64_t read_cr4()
{
	uint64_t value;
	__asm__("movq %%cr4, %0" : "=r"(value));
	return value;
}

void write_cr4(uint64_t value)
{
	__asm__("movq %0, %%cr4" :: "r"(value));
}
