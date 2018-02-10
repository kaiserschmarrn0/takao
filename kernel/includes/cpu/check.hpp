// check.hpp

// Description: CPU checking

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#pragma once

#include "../cpu.hpp"

struct cpuinfo {
	bool has_apic;
	bool has_x2apic;
	bool has_msr;
	bool has_ia32_efer;
	bool has_sse;
	bool has_sse2;
	bool has_sse3;
	bool has_ssse3;
};

namespace cpu {
	void check(struct cpuinfo *cpuinfo);
}

uint64_t cpu_read_msr(uint32_t msr /*rcx*/);
void cpu_write_msr(uint32_t msr /*rcx*/, uint64_t data/*rdx*/);

uint64_t read_cr0();

void write_cr0(uint64_t value);

uint64_t read_cr3();

void write_cr3(uint64_t value);

uint64_t read_cr4();

void write_cr4(uint64_t value);
