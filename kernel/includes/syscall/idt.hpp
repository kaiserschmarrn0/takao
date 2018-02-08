// idt.hpp

// Description: Interrupt things

// Copyright 2016 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#pragma once

#include "../syscall.hpp"

namespace syscall {
	namespace idt {
		void init(void);
		void set_gate(void);
		void sti(void);
		void cli(void);
	}
}
