// idt.cpp

// Description: Interrupt things

// Copyright 2016 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#include <syscall/idt.hpp>

struct idt_descriptor {
   uint16_t offset_1;    // offset bits 0..15
   uint16_t selector;    // a code segment selector in GDT or LDT
   uint16_t flags;       // various flags, namely:
						 // 0..2: Interrupt stack table
						 // 3..7: zero
						 // 8..11: type
						 // 12: zero
						 // 13..14: descriptor privilege level
						 // 15: segment present flag
   uint16_t offset_2;    // offset bits 16..31
   uint32_t offset_3;    // offset bits 32..63
   uint32_t reserved;    // unused, set to 0
} __attribute__((packed));

struct idt_pointer {
	uint16_t limit;
	uint64_t offset;
} __attribute__((packed));

idt_descriptor idt_entries[256];
idt_pointer idt_ptr;

namespace syscall {
	namespace idt {
		void init(void) 
		{
			idt_ptr.limit = (sizeof(idt_descriptor) * 256) -1;
			idt_ptr.offset = reinterpret_cast<uint64_t>(&idt_entries);
			
			memset(&idt_ptr, 0, sizeof(idt_descriptor)*256);

			// Set all the gates

			idt::cli();
			
			asm("lidt %0":"=m"(idt_ptr));

			idt::sti();
		}

		void set_gate(uint8_t num, void (*handler)())
		{
			uint64_t address = (uint64_t)handler;

			idt_entries[num].selector = 0x28;
			idt_entries[num].flags = 0x8E00;
			idt_entries[num].offset_1 = address & 0xffff;
			idt_entries[num].offset_2 = address >> 16;
			idt_entries[num].offset_3 = address >> 32;
		}

		void sti(void)
		{
			asm("sti");
		}

		void cli(void)
		{
			asm("cli");
		}
	}
}