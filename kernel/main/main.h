// main.h

// Description: The header of main.cpp and the bootloader

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#pragma once

#include "../libk/libk.h"

#ifdef __cplusplus
	// The main kernel function (the no arch-dependent one)
	extern "C" void kernel_main(struct bootinfo *bootinfo);
#else
	// The main kernel function (the no arch-dependent one)
	void kernel_main(struct bootinfo *bootinfo);
#endif