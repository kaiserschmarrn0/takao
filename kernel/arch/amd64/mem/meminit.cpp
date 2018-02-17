// meminit.cpp

// Description: Inits all the things needed by the mem allocation

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#include <mem/init.hpp>
#include "paging.hpp"
#include "gdt.hpp"
#include "pages.hpp"

namespace mem {
	uint64_t *first_free_page;
	uint64_t *pml4_table;
	uint64_t max_addr;
}

void mem::init(struct bootinfo *bootinfo)
{
	// Init GDT
	gdt_init();
	
	// Init paging (paging.cpp/hpp)
	paging_init();

	// Lets build out meminfo struct
	mem::first_free_page = bootinfo->kmem.first_free_page;
	mem::max_addr        = bootinfo->kmem.max_addr;

	// Figure out how many of each tables we need and allocate them all.
	mem::pml4_table = allocate_tables(mem::first_free_page, 0, mem::max_addr, 3);

	// Finally, we want NULL to be not present, so we get pagefault when null is dereferenced.
	uint64_t *e = get_memory_entry_for(mem::pml4_table, 0, 0);
	set_entry_present(e, false);

	// Redo graphics framebuffer mapping
	for(uint64_t i = 0; i <= bootinfo->graphics.buffer_size; i += 0x200000) {
		uint64_t *e = create_memory_entry_for(mem::pml4_table, mem::first_free_page, 
											  (uint64_t)bootinfo->graphics.buffer_base + i, 1);
		
		*e = (uint64_t)bootinfo->graphics.buffer_base + i;
		set_entry_present(e, true);
		set_entry_writeable(e, true);
		set_entry_pagesize(e, true);
	}

}

