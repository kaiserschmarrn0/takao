// File: serial.h
//
// Description: Main include of our serial driver
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

#include "../../libk/libk.h"

KABI void init_serial(void);
KABI uint64_t serial_port_write(uint8_t *buffer, uint64_t size);
KABI void serial_print(const char *print);
KABI void serial_print_int(uint64_t n);
KABI void serial_print_hex(uint64_t n);
