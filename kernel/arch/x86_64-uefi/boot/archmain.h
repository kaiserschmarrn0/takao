// File: archmain.h
//
// Description: Main header of archmain.c
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

#include "../utils/utils.h"

// Functions for rescuing CPU info and doing things with it.
#include "../cpu/cpu.h"
// Functions for restoring uefi boot info
#include "../specifics/uefifunc.h"
// GDT and related stuff
#include "../mem/gdt.h"
// Paging setup
#include "../mem/paging.h"
// Graphic initialization
#include "../output/graphics.h"
// Memory map provided by UEFI
#include "../mem/memmap.h"
// Memory routines
#include "../mem/mem.h"

// A struct for storing some info
struct archmain {
	struct cpu cpu;
	struct uefi uefi;
	struct graphics graphics;
	struct mem mem;
};

// The "arch_main" function, crucial in our boot process
EFI_STATUS efi_main (EFI_HANDLE ih, EFI_SYSTEM_TABLE *st);