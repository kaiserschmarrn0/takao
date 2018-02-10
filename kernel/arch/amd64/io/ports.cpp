// ports.cpp

// Description: I/O ports

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#include <io/ports.hpp>

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
