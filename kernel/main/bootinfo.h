// bootinfo.h

// Description: Bootinfo struct

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#pragma once

#include "../lib/types.hxx"

// Graphics buffer
struct graphics {
	void*    buffer_base;
	uint64_t buffer_size;
	uint32_t horizontal_res;
	uint32_t vertical_res;
};

// Memmap
struct kmem {
	uint64_t *first_free_page;
	uint64_t max_addr;
};

// Not the global struct
struct bootinfo {
	struct graphics graphics;
	struct kmem kmem;
};