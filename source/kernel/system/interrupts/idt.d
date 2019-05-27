/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

module system.interrupts.idt;

struct IDTDescriptor {
    ushort offsetLow;    // Offset bits 0..15
    ushort selector;     // A code segment selector in GDT or LDT
    ubyte  ist;          // Interrupt Stack Table
    ubyte  flags;        // Various flags, namely:
                         // 0..4: type
                         // 5: zero
                         // 6..7: descriptor privilege level
                         // 15: segment present flag
    ushort offsetMiddle; // Offset bits 16..31
    uint   offsetHigh;   // Offset bits 32..63
    uint   reserved;     // Unused, set to 0
}

struct IDTPointer {
    align(1):

    ushort size;
    ulong  offset;
}

private __gshared IDTDescriptor[256] idt;

/**
 * Sets the system IDT, exceptions and IRQs
 */
void setIDT() {
    import system.interrupts.exceptions;
    import system.interrupts.irq;

    IDTPointer idtPointer = {
        size:   idt.sizeof - 1,
        offset: cast(ulong)&idt
    };

    // Set all the interrupts at first
    foreach (uint i; 0..idt.length) {
        registerInterrupt(i, &defaultInterruptHandler, false);
    }

    registerInterrupt(0x00, &DEHandler, false);
    registerInterrupt(0x01, &DBHandler, false);
    registerInterrupt(0x02, &NMIHandler, false);
    registerInterrupt(0x03, &BPHandler, false);
    registerInterrupt(0x04, &OFHandler, false);
    registerInterrupt(0x05, &BRHandler, false);
    registerInterrupt(0x06, &UDHandler, false);
    registerInterrupt(0x07, &NMHandler, false);
    registerInterrupt(0x08, &DFHandler, true);
    registerInterrupt(0x09, &CSOHandler, false);
    registerInterrupt(0x0A, &TSHandler, false);
    registerInterrupt(0x0B, &NPHandler, false);
    registerInterrupt(0x0C, &SSHandler, false);
    registerInterrupt(0x0D, &GPHandler, false);
    registerInterrupt(0x0E, &PFHandler, false);
    // 0xF is reserved.
    registerInterrupt(0x10, &MFHandler, false);
    registerInterrupt(0x11, &ACHandler, false);
    registerInterrupt(0x12, &MCHandler, false);
    registerInterrupt(0x13, &XFHandler, false);
    registerInterrupt(0x14, &VEHandler, false);
    // 0x15..0x1D are reserved.
    registerInterrupt(0x1E, &SXHandler, false);
    // 0x1F is reserved.

    registerInterrupt(0x20, &pitHandler, false);

    foreach (i; 0..16) {
        registerInterrupt(0x90 + i, &apicNMIHandler, true);
    }

    foreach (i; 0..8) {
        registerInterrupt(0xA0 + i, &masterPICHandler, true);
    }

    foreach (i; 0..8) {
        registerInterrupt(0xA8 + i, &slavePICHandler, true);
    }

    registerInterrupt(0xFF, &apicSpuriousHandler, true);

    asm {
        lidt [idtPointer];
    }
}

private void registerInterrupt(uint number, void function() handler, bool ist) {
    auto address = cast(ulong)handler;

    idt[number].offsetLow    = cast(ushort)address;
    idt[number].selector     = 0x08;
    idt[number].ist          = ist ? 1 : 0;
    idt[number].flags        = 0x8E;
    idt[number].offsetMiddle = cast(ushort)(address >> 16);
    idt[number].offsetHigh   = cast(uint)(address >> 32);
    idt[number].reserved     = 0;
}
