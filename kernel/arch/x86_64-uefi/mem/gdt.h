// File: gdt.h
//
// Description: Main header of gdt.c
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

#include "../utils/utils.h"

struct GDT {
	uint16_t limit;
	uint64_t offset;
} __attribute__((packed));

KABI void init_gdt();
KABI void add_gdt_entry(uint64_t entry, uint16_t *byte);