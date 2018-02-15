// bootinfo.h

// Description: Bootinfo struct

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#pragma once

#include <inttypes.h>
#include <stdbool.h>
#include <stddef.h>

struct graphics {
	void*    buffer_base;
	uint64_t buffer_size;
	uint32_t horizontal_res;
	uint32_t vertical_res;
};
struct bootinfo {
	struct graphics graphics;
};