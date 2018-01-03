//File distributed under the LICENSE of the package (GNU GPL V3)
//Check LICENSE for more information

#pragma once

#include "utils.h"
#include "uefifunc.h"

KABI EFI_STATUS get_memmap(const struct uefi *uefi, struct efi_memory_map *map_info);

