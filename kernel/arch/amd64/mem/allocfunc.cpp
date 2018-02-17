// allocfunc.cpp

// Description: kmalloc, kfree, etc.

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#include <mem/allocfunc.hpp>
#include "pages.hpp"
#include <err/panic.hpp>

extern uint64_t *memory_first_free_page;
extern uint64_t *memory_pml4_table;

typedef union header {
	struct {
		union header *next;
		uint64_t size;       // in bytes
	} s;
	uint64_t _Align; // alignment
} Header;

static Header base;                // Used to get an initial member for free list
static Header *freep = NULL;       // Free list starting point
static uint64_t brk = 0x200000000; // 8GB onwards is heap

static Header *morecore(uint64_t nblocks);

void *mem::kmalloc(uint64_t nbytes)
{
	Header *currp;
	Header *prevp;

	// Number of pages needed to provide at least nbytes of memory.
	uint64_t pages = ((nbytes + sizeof(Header) - 1) / 0x1000) + 1;

	if (freep == NULL) {
		// Create degenerate free list; base points to itself and has size 0
		base.s.next = &base;
		base.s.size = 0;
		// Set free list starting point to base address
		freep = &base;
	}

	// Initialize pointers to two consecutive blocks in the free list, which we
	// call prevp (the previous block) and currp (the current block)
	prevp = freep;
	currp = prevp->s.next;

	// Step through the free list looking for a block of memory large enough.
	for (; ; prevp = currp, currp = currp->s.next) {
		if (currp->s.size >= nbytes) {
			if (currp->s.size == nbytes) {
				// Found exactly sized partition, good for us!
				prevp->s.next = currp->s.next;
			} else {
				uint64_t old_size = currp->s.size;
				union header *old_next = currp->s.next;
				// Changes the memory stored at currp to reflect the reduced block size
				currp->s.size = nbytes;
				// Find location at which to create the block header for the new block
				prevp->s.next = (Header *)((uint64_t)currp + nbytes + sizeof(Header));
				// Store the block size in the new header
				prevp->s.next->s.next = old_next;
				prevp->s.next->s.size = old_size - nbytes - sizeof(Header);
			}
			// Set global starting position to the previous pointer
			freep = prevp;
			// Return the location of the start of the memory, not header
			return (void *) (currp + 1);
		}

		// no block found
		if (currp == freep) {
			if ((currp = morecore(pages)) == NULL) {
				return NULL;
			}
		}
	}
}

void mem::kfree(void *ptr)
{
	Header *insertp, *currp;

	// Find address of block header for the data to be inserted
	insertp = ((Header *) ptr) - 1;

	// Step through the free list looking for the position in the list to place
	// the insertion block.
	for (currp = freep; !((currp < insertp) && (insertp < currp->s.next)); currp = currp->s.next) {
		// currp >= currp->s.ptr implies that the current block is the rightmost
		// block in the free list.
		if ((currp >= currp->s.next) && ((currp < insertp) || (insertp < currp->s.next))) {
			break;
		}
	}

	if ((insertp + insertp->s.size) == currp->s.next) {
		insertp->s.size += currp->s.next->s.size;
		insertp->s.next = currp->s.next->s.next;
	} else {
		insertp->s.next = currp->s.next;
	}

	if ((currp + currp->s.size) == insertp) {
		currp->s.size += insertp->s.size;
		currp->s.next = insertp->s.next;
	} else {
		currp->s.next = insertp;
	}

	freep = currp;
}

static Header *morecore(uint64_t pages)
{
	void *freemem;    // The address of the newly created memory
	Header *insertp;  // Header ptr for integer arithmatic and constructing header

	freemem = (void *)brk;
	// Request for as many pages as necessary
	for(uint64_t p = 0; p < pages; p += 1) {
		void *page = allocate_page(memory_pml4_table, memory_first_free_page);
		// unable to allocate more memory; allocate_page returns NULL
		if (page == NULL) {
			err::panic(25); // out of memory!
		}
		// Map the page into our heap
		map_page(memory_pml4_table, memory_first_free_page, brk, 0, (uint64_t)page);
		brk += 0x1000;
	}
	// Construct new block
	insertp = (Header *)freemem;
	insertp->s.size = 0x1000 * pages;

	mem::kfree((void *) (insertp + 1));

	return freep;
}
