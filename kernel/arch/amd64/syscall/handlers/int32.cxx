// int32.cxx

// Description: Interrupt 32, our no-op int

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#include <syscall/handlers/int32.hxx>

namespace syscall {
	namespace idt {
		namespace handlers {
			__attribute__((naked)) void int32()
			{
				__asm__("iretq");
			}
		}
	}
}
