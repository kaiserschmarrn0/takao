// File: archmain.h
//
// Description: Main header of archmain.c
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

#include "utils.h"

// Functions for rescuing CPU info and doing things with it.
#include "cpu.h"
// Functions for restoring uefi boot info
#include "uefifunc.h"
// GDT and related stuff
#include "gdt.h"
// Paging setup
#include "paging.h"
// Graphic initialization
#include "graphics.h"
// Memory map provided by UEFI
#include "memmap.h"

// A struct for storing some info
struct archmain {
	struct cpu cpu;
	struct uefi uefi;
	struct graphics graphics;
};

// The "arch_main" function, crucial in our boot process
EFI_STATUS efi_main (EFI_HANDLE ih, EFI_SYSTEM_TABLE *st);