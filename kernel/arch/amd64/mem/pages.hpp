// pages.hpp

// Description: Paging functions, etc.

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#pragma once

extern "C" {
	#include <libk.h>
}

uint64_t *allocate_page_inner(uint64_t *first_free_page, bool ok);
uint64_t *allocate_tables(uint64_t *first_free_page, uint64_t offset, uint64_t max_address, 
						uint8_t level);

uint64_t *get_memory_entry_for(uint64_t *pml4_table, uint64_t address, uint8_t level);
uint64_t *create_memory_entry_for(uint64_t *pml4_table, uint64_t *first_free_page, 
								uint64_t address, uint8_t level);

void *allocate_page(uint64_t *pml4_table, uint64_t *first_free_page);
void deallocate_page(uint64_t *pml4_table, uint64_t *first_free_page, uint64_t *p);
void map_page(uint64_t *pml4_table, uint64_t *first_free_page, uint64_t address, 
			uint8_t level, uint64_t phys_addr);

void set_entry_present(uint64_t *entry, bool on);
void set_entry_writeable(uint64_t *entry, bool on);
void set_entry_supervisor(uint64_t *entry, bool on);
void set_entry_pagesize(uint64_t *entry, bool on);
void set_entry_physical(uint64_t *entry, uint64_t physical);
uint64_t get_entry_physical(uint64_t *entry);
void set_entry_exec(uint64_t *entry, bool on);





