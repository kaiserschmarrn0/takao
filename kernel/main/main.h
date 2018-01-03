//File distributed under the LICENSE of the package (GNU GPL V3)
//Check LICENSE for more information

#pragma once

// The kernel library, with memcpy, strlen, etc.
#include "../libk/libk.h"

// The main kernel function (the no arch-dependent one)
KABI void kernel_main(void);