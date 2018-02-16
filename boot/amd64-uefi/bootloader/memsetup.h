// memsetup.h

// Description: Memory things

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#pragma once

#include "uefifunc.h"
#include "utils.h"

#define FOR_EACH_MEMORY_DESCRIPTOR(bootmain, desc) \
	EFI_MEMORY_DESCRIPTOR *desc = bootmain->uefi.boot_memmap.descrs;\
	uint8_t **descr_offsetter = (uint8_t **)&(desc);\
	uint64_t offset = bootmain->uefi.boot_memmap.descr_size;\
	for(uint64_t __i = 0; \
		__i < bootmain->uefi.boot_memmap.entries;\
		__i += 1, *descr_offsetter += offset)

struct memory {
	uint64_t *first_free_page;
	uint64_t *pml4_table;
	uint64_t max_addr;
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

struct bootmain;

EFI_STATUS init_memory(struct bootmain *bootmain);