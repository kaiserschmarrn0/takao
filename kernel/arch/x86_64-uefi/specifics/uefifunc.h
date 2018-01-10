// File: uefifunc.h
//
// Description: uefifunc.c main header
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once
#include <efi.h>
#include <efiprot.h>

#include "../utils/utils.h"

#define EFI_ACPI_TABLE_GUID {0x8868e871,0xe4f1,0x11d3, {0xbc,0x22,0x00,0x80,0xc7,0x3c,0x88,0x81}}

struct efi_memory_map {
	EFI_MEMORY_DESCRIPTOR *descrs;
	uint64_t entries;
	uint64_t map_key;
	uint64_t descr_size;
	uint32_t descr_version;
};

struct uefi {
	EFI_SYSTEM_TABLE *system_table;
	EFI_HANDLE image_handle;
	struct efi_memory_map boot_memmap;
};

KABI void *find_configuration_table(const struct uefi *uefi, EFI_GUID *guid);
KABI bool compare_guid(EFI_GUID *g1, EFI_GUID *g2);
KABI EFI_STATUS efi_memory_map(const struct uefi *uefi, struct efi_memory_map *map_info);
KABI EFI_STATUS exit_bootservices(const struct uefi *uefi);