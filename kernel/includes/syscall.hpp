// File: syscall.hpp
//
// Description: Syscalls, like interrupts and etc.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

extern "C" {
	#include "../libk/libk.h"
}

namespace syscall {}

#include "syscall/idt.hpp"

