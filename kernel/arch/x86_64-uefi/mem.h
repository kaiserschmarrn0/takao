// File: mem.h
//
// Description: Main header of mem.c
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

#include "utils.h"
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