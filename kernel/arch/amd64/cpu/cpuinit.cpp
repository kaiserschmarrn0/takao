// init.hpp

// Description: CPU init

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#include <cpu/init.hpp>

#include "check.hpp"

struct cpuinfo cpuinfo;

namespace cpu {
	void init(void)
	{
		// Check CPU
		check(&cpuinfo);
	}
}
