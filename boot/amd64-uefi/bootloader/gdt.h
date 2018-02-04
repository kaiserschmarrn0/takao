//File distributed under the LICENSE of the package (GNU GPL V3)
//Check LICENSE for more information

#include "utils.h"

struct GDT {
	uint16_t limit;
	uint64_t offset;
} __attribute__((packed));

void init_gdt();