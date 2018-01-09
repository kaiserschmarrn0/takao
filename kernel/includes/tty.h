// File: tty.h
//
// Description: The header that defines the tty driver
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

// Include our shiny and "optimal" libk
#include "../libk/libk.h"

// tty_init: Cleans the screen and setup all.
KABI void tty_init(void);

KABI void put_char(char c, uint8_t x, uint8_t y, uint32_t rgb);

KABI void put_string(const char* str, uint8_t x, uint8_t y, uint32_t rgb);