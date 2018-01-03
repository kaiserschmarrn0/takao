//File distributed under the LICENSE of the package (GNU GPL V3)
//Check LICENSE for more information

#pragma once

#include "../libk/libk.h"

KABI void init_serial(void);
KABI uint64_t serial_port_write(uint8_t *buffer, uint64_t size);
KABI void serial_print(const char *print);
KABI void serial_print_int(uint64_t n);
KABI void serial_print_hex(uint64_t n);
