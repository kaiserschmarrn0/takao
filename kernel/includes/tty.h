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