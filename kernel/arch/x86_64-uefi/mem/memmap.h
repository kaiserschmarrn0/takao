// File: memmap.h
//
// Description: Main header of memmap.h
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

#include "../utils/utils.h"

#include "../specifics/uefifunc.h"

KABI EFI_STATUS get_memmap(const struct uefi *uefi, struct efi_memory_map *map_info);

