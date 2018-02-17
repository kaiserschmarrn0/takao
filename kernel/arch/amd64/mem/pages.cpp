// pages.cpp

// Description: Paging functions, etc.

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#include "pages.hpp"
#include <err/panic.hpp>

uint64_t *allocate_page_inner(uint64_t *first_free_page, bool ok)
{
	// Figure out the page we can return.
	uint64_t *ret = first_free_page;
	
	// Out of mem 
	if(ret == NULL) {
		err::panic(3);
	}
	// Now we note that next first_free_page is recorded in the page being returned.
	
	// TODO: perhaps something more reliable like checking for existence of page tables and doing
	// smart things depending on that?
	if(ok) first_free_page = (uint64_t *)*ret;
	
	// Return the page.
	return ret;
}

uint64_t *allocate_tables(uint64_t *first_free_page, uint64_t offset, uint64_t max_address, 
						uint8_t level) 
{
	uint64_t entry_size;
	switch(level) {
		case 0: entry_size = 0x1000ull; break;
		case 1: entry_size = 0x1000ull * 512; break;
		case 2: entry_size = 0x1000ull * 512 * 512; break;
		case 3: entry_size = 0x1000ull * 512 * 512 * 512; break;
		default: err::panic(5); // bad level!
	}
	uint64_t *new_page = allocate_page_inner(first_free_page, true);
	if(level != 0) {
		for(uint64_t i = 0; i < 512 && offset + i * entry_size < max_address; i++) {
			uint64_t *child = allocate_tables(first_free_page, offset + i * entry_size, max_address, level - 1);
			// We initialize all intermediate pages as present, writable, executable etc, because
			// book-keeping these is pain.
			new_page[i] = (uint64_t)child | 1ull | 1ull << 1 | 1ull << 2 | 1ull << 11;
		}
	} else {
		for(uint64_t i = 0; i < 512 && offset + i * entry_size < max_address; i++) {
			new_page[i] = offset + i * entry_size | 1ull | 1ull << 1 | 1ull << 2 | 1ull << 11;
		}
	}
	return new_page;
}

uint64_t *get_memory_entry_for(uint64_t *pml4_table, uint64_t address, uint8_t level)
{
	uint64_t index = address / 0x1000;
	uint64_t indices[4] = {
		index % 512,
		(index >> 9) % 512,
		(index >> 18) % 512,
		(index >> 27) % 512
	};
	uint64_t *current = pml4_table;
	for(uint8_t l = 3; l > level; l -= 1) {
		current = (uint64_t *)get_entry_physical(current + indices[l]);
	}
	return current + indices[level];
}

uint64_t *create_memory_entry_for(uint64_t *pml4_table, uint64_t *first_free_page, 
								uint64_t address, uint8_t level)
{
    uint64_t index = address / 0x1000;
    uint64_t indices[4] = {
        index % 512,
        (index >> 9) % 512,
        (index >> 18) % 512,
        (index >> 27) % 512
    };
    uint64_t *current = pml4_table;
    for(uint8_t l = 4; l > level;) {
        l -= 1;
        uint64_t *next = current + indices[l];
        if(l == level) return next;
        if((*next & 1) == 0) {
            uint64_t *new_page = allocate_page_inner(first_free_page, true);
            memset(new_page, 0, 0x1000);
            
			*next = (uint64_t)new_page;
            set_entry_present(next, true);
            set_entry_writeable(next, true);
            set_entry_supervisor(next, true);
        }
        current = (uint64_t *)get_entry_physical(next);
    }
    return NULL;
}

void *allocate_page(uint64_t *pml4_table, uint64_t *first_free_page)
{
    uint64_t *ret = allocate_page_inner(first_free_page, false);
    uint64_t *e = get_memory_entry_for(pml4_table, (uint64_t)ret, 0);
    set_entry_present(e, true);
    
	first_free_page = (uint64_t *)*ret;
    set_entry_writeable(e, true);
    set_entry_exec(e, false);
    set_entry_supervisor(e, true);
    
	// Zero out the next-pointer, in order to not leak the internals.
    *ret = 0;
    return ret;
}

void deallocate_page(uint64_t *pml4_table, uint64_t *first_free_page, uint64_t *p)
{
    // Special case.
    if(p == NULL) return;
    
	// Re-set the entry for this page.
    uint64_t *entry = get_memory_entry_for(pml4_table, (uint64_t)p, 0);
    
	// Then we re-set the first_free_page pointer for this page.
    *((uint64_t *)p) = (uint64_t)first_free_page;
    set_entry_present(entry, false);
    
	// And now this page is our new first_free_page.
    first_free_page = p;
}

void map_page(uint64_t *pml4_table, uint64_t *first_free_page, uint64_t address, 
			uint8_t level, uint64_t phys_addr)
{
    uint64_t *entry = create_memory_entry_for(pml4_table, first_free_page, address, level);
    set_entry_physical(entry, phys_addr);
    set_entry_present(entry, true);
    set_entry_exec(entry, true);
    set_entry_writeable(entry, true);
}

void set_entry_present(uint64_t *entry, bool on)
{
	const uint64_t flag = 1ull;
	if(on) { *entry |= flag; } else { *entry &= ~flag; }
}

void set_entry_writeable(uint64_t *entry, bool on)
{
	const uint64_t flag = 1ull << 1;
	if(on) { *entry |= flag; } else { *entry &= ~flag; }
}

void set_entry_supervisor(uint64_t *entry, bool on)
{
	const uint64_t flag = 1ull << 2;
	if(on) { *entry |= flag; } else { *entry &= ~flag; }
}

void set_entry_pagesize(uint64_t *entry, bool on)
{
	const uint64_t flag = 1ull << 7;
	if(on) { *entry |= flag; } else { *entry &= ~flag; }
}

void set_entry_physical(uint64_t *entry, uint64_t physical)
{
	if((physical & 0xFFF) != 0) {
		err::panic(12); // Bad physical address
	}
	*entry |= physical;
}

uint64_t get_entry_physical(uint64_t *entry)
{
	return *entry & 0x0007FFFFFFFFF000;
}

void set_entry_exec(uint64_t *entry, bool on)
{
	const uint64_t flag = 1ull << 63;
	if(!on) { *entry |= flag; } else { *entry &= ~flag; }
}