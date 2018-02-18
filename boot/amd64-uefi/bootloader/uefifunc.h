// uefifunc.h

// Description: UEFI specifics (header)

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#pragma once
#include <efi.h>
#include <efiprot.h>

#include "utils.h"

#define EFI_ACPI_TABLE_GUID {0x8868e871,0xe4f1,0x11d3, {0xbc,0x22,0x00,0x80,0xc7,0x3c,0x88,0x81}}

struct memory_map {
	EFI_MEMORY_DESCRIPTOR *descrs;
	uint64_t entries;
	uint64_t map_key;
	uint64_t descr_size;
	uint32_t descr_version;
};

struct uefi {
	EFI_SYSTEM_TABLE *system_table;
	EFI_HANDLE image_handle;
	struct memory_map boot_memmap;
};

void *find_configuration_table(const struct uefi *uefi, EFI_GUID *guid);
bool compare_guid(EFI_GUID *g1, EFI_GUID *g2);
EFI_STATUS memory_map(const struct uefi *uefi, struct memory_map *map_info);