// File: serial.hpp
//
// Description: Main include of our serial driver
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

extern "C" {
	#include "../../libk/libk.h"
}

namespace serial_port {
    void serial_init(void);
    uint64_t serial_port_write(uint8_t *buffer, uint64_t size);
    int serial_print(const char *print);
}