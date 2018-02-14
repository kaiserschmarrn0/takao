// cpuinit.cpp

// Description: CPU init

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#include <cpu/init.hpp>

#include "check.hpp"

struct cpucheck cpucheck;

void cpu::init(void)
{
	check(&cpucheck); // Check CPU
}

namespace cpu {
	class cpuinfo {
		public:
			bool has_apic      = cpucheck.has_apic;
			bool has_x2apic    = cpucheck.has_x2apic;
			bool has_msr       = cpucheck.has_msr;
			bool has_ia32_efer = cpucheck.has_ia32_efer;
			bool has_sse       = cpucheck.has_sse;
			bool has_sse2      = cpucheck.has_sse2;
			bool has_sse3      = cpucheck.has_sse3;
			bool has_ssse3     = cpucheck.has_ssse3;
	};
}
