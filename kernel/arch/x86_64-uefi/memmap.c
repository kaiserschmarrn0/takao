// File: memmap.c
//
// Description: Using UEFI methods, gets a memory map.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "memmap.h"

KABI EFI_STATUS get_memmap(const struct uefi *uefi, struct efi_memory_map *map_info)
{
	efi_memory_map(uefi, map_info);
}