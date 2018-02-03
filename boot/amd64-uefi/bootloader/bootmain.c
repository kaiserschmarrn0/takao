// File: bootmain.c
//
// Description: Main script of the bootloader
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

// UEFI protocol stuff
#include <efi.h>
#include <efiprot.h>

// The function prototype and needed things
#include "bootmain.h"
#include "../../../kernel/main/main.h" //Main kernel

#include "bootmain-inc.h" //All includes

struct bootmain bootmain;

// Here we will setup all related to UEFI
EFI_STATUS efi_main (EFI_HANDLE ih, EFI_SYSTEM_TABLE *st)
{
	bootmain.uefi.image_handle = ih;
	bootmain.uefi.system_table = st;

	EFI_STATUS status;

	kernel_main();
}