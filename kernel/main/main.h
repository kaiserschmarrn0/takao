// File: main.h
//
// Description: Defines the main kernel function prototype
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

// The kernel library, with memcpy, strlen, etc.
#include "../libk/libk.h"

// The main kernel function (the no arch-dependent one)
KABI void kernel_main(void);