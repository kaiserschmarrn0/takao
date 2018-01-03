//File distributed under the LICENSE of the package (GNU GPL V3)
//Check LICENSE for more information

#include "utils.h"

struct GDT {
	uint16_t limit;
	uint64_t offset;
} __attribute__((packed));

KABI void init_gdt();
KABI void add_gdt_entry(uint64_t entry, uint16_t *byte);