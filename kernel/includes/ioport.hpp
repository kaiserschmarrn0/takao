// File: ioport.hpp
//
// Description: The header that defines the interface for I/O ports.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

extern "C" {
	#include "../libk/libk.h"
}


// ioport namespace

namespace ioport {
	uint8_t outb(uint16_t port, uint8_t value);
	uint8_t inb(uint16_t port);
}