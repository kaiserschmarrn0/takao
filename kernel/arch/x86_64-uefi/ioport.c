// File: ioport.c
//
// Description: Provide the interface for reading I/O ports
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "../../includes/ioport.h"

KABI uint8_t port_outb(uint16_t port, uint8_t value)
{
	__asm__ volatile("outb %b0,%w1" : : "a" (value), "d"(port));
	return value;
}

KABI uint8_t port_inb(uint16_t port)
{
	uint8_t data;
	__asm__ volatile("inb %w1,%b0" : "=a" (data) : "d"(port));
	return data;
}
