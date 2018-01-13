// File: mem.h
//
// Description: Main header of mem.c
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

#include "../utils/utils.h"
#include <efi.h>

struct mem {
    uint64_t              *first_free_page;
    uint64_t              *pml4_table;
    uint64_t              max_addr;
};

typedef enum {
	_EfiReservedMemoryType,
	_EfiLoaderCode,
	_EfiLoaderData,
	_EfiBootServicesCode,
	_EfiBootServicesData,
	_EfiRuntimeServicesCode,
	_EfiRuntimeServicesData,
	_EfiConventionalMemory,
	_EfiUnusableMemory,
	_EfiACPIReclaimMemory,
	_EfiACPIMemoryNVS,
	_EfiMemoryMappedIO,
	_EfiMemoryMappedIOPortSpace,
	_EfiPalCode,
	_EfiPersistentMemory,
	_EfiMaxMemoryType
} _EFI_MEMORY_TYPE;

struct archmain;

KABI EFI_STATUS init_memory(struct archmain *archmain);
KABI void *allocate_page(struct archmain *a);
KABI void deallocate_page(struct archmain *a, void *p);

/// Map a single page to a specified address.
KABI void map_page(struct archmain *a, uint64_t address, uint8_t level, uint64_t phys_addr);