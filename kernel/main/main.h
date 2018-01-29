// File: main.h
//
// Description: Defines the main kernel function prototype
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

#include "../libk/libk.h"

#ifdef __cplusplus
	// The main kernel function (the no arch-dependent one)
	extern "C" void kernel_main(void);
#else
	// The main kernel function (the no arch-dependent one)
	void kernel_main(void);
#endif