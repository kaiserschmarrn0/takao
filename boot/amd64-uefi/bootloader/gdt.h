// gdt.h

// Description: Init a GDT (header)

// Copyright 2016 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#include "utils.h"

struct GDT {
	uint16_t limit;
	uint64_t offset;
} __attribute__((packed));

void init_gdt();