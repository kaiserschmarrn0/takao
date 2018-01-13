// File: cpu.h
//
// Description: Main header of cpu.c
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

#include "../utils/utils.h"


struct cpu {
	bool has_apic;
	bool has_x2apic;
	bool has_msr;
	bool has_ia32_efer;
	bool has_sse;
	bool has_sse2;
	bool has_sse3;
	bool has_ssse3;
};

KABI void init_cpu(struct cpu *cpu);
KABI uint64_t cpu_read_msr(uint32_t msr /*rcx*/);
KABI void cpu_write_msr(uint32_t msr /*rcx*/, uint64_t data/*rdx*/);


KABI INLINE uint64_t read_cr0();

KABI INLINE void write_cr0(uint64_t value);

KABI INLINE uint64_t read_cr3();

KABI INLINE void write_cr3(uint64_t value);

KABI INLINE uint64_t read_cr4();

KABI INLINE void write_cr4(uint64_t value);
