// File: includes.h
//
// Description: Includes of the kernel
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

#include "../libk/libk.h"         // Libk
#include "../includes/cpucheck.h" // Cpu info and arch dependent things
#include "../includes/serial.h"   // Serial port
#include "../includes/panic.h"    // Panic function

struct main {
	struct cpuinfo cpuinfo;
};