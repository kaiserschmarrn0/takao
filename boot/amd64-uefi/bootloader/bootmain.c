// bootmain.c

// Description: Main function of the bootloader

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

// UEFI protocol stuff
#include <efi.h>
#include <efiprot.h>

// The function prototype and needed things
#include "bootmain.h"
#include <main/bootinfo.h> // Boot info
#include <main/main.h> // Main kernel

#include "bootmain-inc.h" //All includes

struct bootmain bootmain;
struct bootinfo bootinfo;

// Here we will setup all related to UEFI
EFI_STATUS efi_main (EFI_HANDLE ih, EFI_SYSTEM_TABLE *st)
{
	bootmain.uefi.image_handle = ih;
	bootmain.uefi.system_table = st;

	EFI_STATUS status;

	// With all finished, pass info to the main kernel
	// The struct is declared in bootinfo.h

	// Here assign values when we have something to pass

	kernel_main(&bootinfo);
}