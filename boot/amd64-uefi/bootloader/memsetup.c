// memsetup.c

// Description: Memory things

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#include "memsetup.h"
#include "uefifunc.h"
#include "bootmain-inc.h"

EFI_STATUS init_memory(struct bootmain *bootmain)
{
	EFI_STATUS status;
	uint64_t max_address = 0;

	// First lets get the memory map
	status = memory_map(&bootmain->uefi, &bootmain->uefi.boot_memmap);

	// Now lets exit bootservices
	status = bootmain->uefi.system_table->BootServices->ExitBootServices(
		bootmain->uefi.image_handle,
		bootmain->uefi.boot_memmap.map_key
	);
	
	{FOR_EACH_MEMORY_DESCRIPTOR(bootmain, descr) {
		if(descr->Type == _EfiConventionalMemory) {
			for(uint64_t page = 0; page < descr->NumberOfPages; page++) {
				uint64_t *page_address = (uint64_t *)(descr->PhysicalStart + page * 0x1000);
				*page_address = (uint64_t)bootmain->memory.first_free_page;
				bootmain->memory.first_free_page = page_address;
			}
		}

		// Within the kernel we use identity mapping.
		descr->VirtualStart = descr->PhysicalStart;
		uint64_t phys_end = descr->PhysicalStart + 0x1000 * descr->NumberOfPages;
		if(phys_end > max_address) {
			max_address = phys_end;
		}
	}}
	bootmain->memory.max_addr = max_address;

	// We can inform UEFI runtime about our identity mapping scheme now.
	status = bootmain->uefi.system_table->RuntimeServices->SetVirtualAddressMap(
		bootmain->uefi.boot_memmap.entries * bootmain->uefi.boot_memmap.descr_size,
		bootmain->uefi.boot_memmap.descr_size,
		bootmain->uefi.boot_memmap.descr_version,
		bootmain->uefi.boot_memmap.descrs
	);
}