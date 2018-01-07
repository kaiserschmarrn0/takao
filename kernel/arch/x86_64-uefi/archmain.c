// File: archmain.c
//
// Description: Main script of all the arch-dependent things of the kernel
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

// UEFI protocol stuff
#include <efi.h>
#include <efiprot.h>

// The function prototype and needed things
#include "archmain.h"

// The "kernel_main" and "arch_main" functions prototypes
#include "../../main/main.h"

struct archmain archmain;

EFI_STATUS efi_main (EFI_HANDLE ih, EFI_SYSTEM_TABLE *st)
{
	// Store the efi handle and system table in our archmain struct
	archmain.uefi.image_handle = ih;
	archmain.uefi.system_table = st;

	EFI_STATUS status;
    
	// UEFI give us a x86_64 enviroment, now we call the "arch_main" things
	// to setup all arch-dependent stuff and then we will call
	// "kernel_main"

	//TODO: This is a temporal solution, the optimal way would be by calling
	// 2 different executables, one for arch_main, that would do as a bootloader
	// and kernel_main as the main kernel, but UEFI makes this a little bit difficult
	// plus the difficulty of this process, for the moment this will work.

	// Here different things related to setting up an enviroment
	// for our kernel will happen

	// First, lets get CPU info and enable SSE if it is present
	// All of this is in "cpu.c/h"
	init_cpu(&archmain.cpu);

	// Then, we will init our graphics output system, in CKA the graphics are arch-dependent,
	// So the kernel will only recive a set-pixel function in order to make the main kernel
	// freestanding.
	// All of this in "graphics.c/h" and "set_pixel.c"
	status = init_graphics(&archmain.uefi, &archmain.graphics);
	ASSERT_EFI_STATUS(status);
	
	// Init our Global Descriptor Table (GDT)
	// All of this in "gdt.c/h"
	init_gdt();

	// Init our paging
	// All of this in "paging.c/h"
	init_paging(&archmain.cpu);

	// Get the memory map
	// All of this in "uefifunc.c/h"
	status = get_memmap(&archmain.uefi, &archmain.uefi.boot_memmap);
	ASSERT_EFI_STATUS(status);
	
	// Exit the UEFI boot services
	// All of this in "uefifunc.c/h"
	status = exit_bootservices(&archmain.uefi);

	// With all finished, we can call the kernel main
	
	kernel_main();

}