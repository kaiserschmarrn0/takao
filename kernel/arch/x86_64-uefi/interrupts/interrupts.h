// File: interrupts.h
//
// Description: Struct and header of interrupts.c
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

#include "../specifics/uefifunc.h"
#include "../utils/utils.h"

struct interrupts {
	uint16_t idt_limit;
	struct idt_descriptor *idt_address;
	struct {
		bool has_pic;
		uint8_t local_apic_id;
		uint8_t io_apic_id;
		uint32_t *io_apic_address;
		uint32_t gsi_base;
	} apic;
};

struct archmain;

KABI EFI_STATUS init_interrupts(struct archmain *archmain);