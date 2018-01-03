//File distributed under the LICENSE of the package (GNU GPL V3)
//Check LICENSE for more information

#pragma once

// Include our shiny and "optimal" libk
#include "../libk/libk.h"

//port_inb and that things
KABI uint8_t port_outb(uint16_t port, uint8_t value);
KABI uint8_t port_inb(uint16_t port);