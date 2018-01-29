// File: ports.cpp
//
// Description: Provide the interface for reading I/O ports
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "../../../includes/io/ports.hpp"

namespace ioport {
	uint8_t outb(uint16_t port, uint8_t value)
	{
		__asm__ volatile("outb %b0,%w1" : : "a" (value), "d"(port));
		return value;
	}

	uint8_t inb(uint16_t port)
	{
		uint8_t data;
		__asm__ volatile("inb %w1,%b0" : "=a" (data) : "d"(port));
		return data;
	}
}