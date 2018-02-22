// int32.hxx

// Description: Interrupt 32, no-op

// Copyright 2016 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#pragma once

#include "../../syscall.hxx"

namespace syscall {
	namespace idt {
		namespace handlers {
			__attribute__((naked)) void int32();
		}
	}
}
