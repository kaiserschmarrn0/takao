// File: gdt.h
//
// Description: GDT setup code
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "utils.h"

struct GDT {
	uint16_t limit;
	uint64_t offset;
} __attribute__((packed));

void init_gdt();