// File: includes.hpp
//
// Description: Includes of the kernel
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

extern "C" {
	#include "../libk/libk.h"       // Libk
}

#include "../includes/cpu.hpp"       // CPU
#include "../includes/io/serial.hpp" // Serial port
#include "../includes/io/ports.hpp"  // IO ports
#include "../includes/err.hpp"       // Panic, warn, etc functions

struct maininfo {
	struct cpuinfo cpuinfo;
};
