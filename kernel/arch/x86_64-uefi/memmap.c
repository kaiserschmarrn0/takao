//File distributed under the LICENSE of the package (GNU GPL V3)
//Check LICENSE for more information

#include "memmap.h"

KABI EFI_STATUS get_memmap(const struct uefi *uefi, struct efi_memory_map *map_info)
{
	efi_memory_map(uefi, map_info);
}