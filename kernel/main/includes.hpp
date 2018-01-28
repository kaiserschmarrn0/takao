// File: includes.hpp
//
// Description: Includes of the kernel
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

extern "C" {
	#include "../libk/libk.h"       // Libk
}

#include "../includes/cpucheck.hpp" // Cpu info and arch dependent things
#include "../includes/serial.hpp"   // Serial port
#include "../includes/panic.hpp"    // Panic function

struct maininfo {
	struct cpuinfo cpuinfo;
};