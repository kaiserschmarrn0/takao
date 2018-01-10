// File: gdt.c
//
// Description: Set-up the Global Descriptor Table and provides ways to modify it. 
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "gdt.h"

#include "../utils/lowpanic.h"

KABI void init_gdt()
{
	// we have segments set up already, we just want to replace them with our own (e.g. no 32bit
	// mode). All we got to do is basicaly replace the known-used descriptors with our own and
	// reload the segments afterwards.
	struct GDT *gdt;
	uint16_t data_segment, code_segment;
	__asm__("cli; sgdt (%0);"
		"movw %%ds, %1;"
		"movw %%cs, %2;" : "=r"(gdt), "=r"(data_segment), "=r"(code_segment));
	data_segment /= 8;
	code_segment /= 8;
	memset((uint8_t *)gdt->offset, gdt->limit + 1, 0);
	((uint64_t *)gdt->offset)[data_segment] = 0xFFFF | 0xFull << 48
						| 1ull << 55 // this is a number of pages, not bytes
						| 1ull << 47 // present
						| 1ull << 44 // 1 for code and data segments
						| 1ull << 41 // writeable
						;
	((uint64_t *)gdt->offset)[code_segment] = 0xFFFF | 0xFull << 48
						| 1ull << 55
						| 1ull << 53 // executable
						| 1ull << 47
						| 1ull << 44
						| 1ull << 43 // executable
						| 1ull << 41 // readable
						;
	// Set the other selectors to new segments and load up our “new” global descriptor table.
	__asm__("lgdt (%0);"
		// We didn’t change the index of data segment descriptor, thus reloading it like this
		// should suffice.
		"mov %%ds, %%ax;"
		"mov %%ax, %%ds;"
		"mov %%ax, %%ss;"
		"mov %%ax, %%es;"
		"mov %%ax, %%fs;"
		"mov %%ax, %%gs;"
		// Now, reload the code segment. Calling our no-op interrupt should suffice.
		"sti; int $32;" :: "r"(gdt) : "%ax");
}

KABI void add_gdt_entry(uint64_t entry, uint16_t *byte)
{
	struct GDT *gdt;
	__asm__("cli; sgdt (%0);" : "=r"(gdt));
	for(uint16_t i = 1; i < gdt->limit + 1 / 8; i += 1) {
		uint64_t *e = ((uint64_t *)gdt->offset) + i;
		if(*e == 0) {
		*e = entry;
		*byte = i * 8;
		__asm__("lgdt (%0); sti;" : "=r"(gdt));
		}
	}
	low_panic(3);
}
