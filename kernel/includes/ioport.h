// File: ioport.h
//
// Description: The header that defines the interface for I/O ports.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

#include "../libk/libk.h"

//port_inb and that things
uint8_t port_outb(uint16_t port, uint8_t value);
uint8_t port_inb(uint16_t port);