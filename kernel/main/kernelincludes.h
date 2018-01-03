#pragma once

// The kernel library, with memcpy, strlen, etc.
#include "../libk/libk.h"

// Arch dependent kernel functions, like serial port, graphics,
// and the common ones, all together to be used by our kernel.
#include "../includes/include.h"
