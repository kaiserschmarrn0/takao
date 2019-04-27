// idt.d - IDT loading and filling
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

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

void setIDT() {
    import system.interrupts.isr;

    IDTPointer idtPointer = {
        size:   idt.sizeof - 1,
        offset: cast(ulong)&idt
    };

    // Set all the interrupts at first
    foreach (uint i; 0..idt.length) {
        registerInterrupt(i, &defaultInterruptHandler, false);
    }

    registerInterrupt(0x0, &DEHandler, false);
    registerInterrupt(0x1, &DBHandler, false);
    registerInterrupt(0x2, &NMIHandler, false);
    registerInterrupt(0x3, &BPHandler, false);
    registerInterrupt(0x4, &OFHandler, false);
    registerInterrupt(0x5, &BRHandler, false);
    registerInterrupt(0x6, &UDHandler, false);
    registerInterrupt(0x7, &NMHandler, false);
    registerInterrupt(0x8, &DFHandler, true);
    registerInterrupt(0x9, &CSOHandler, false);
    registerInterrupt(0xA, &TSHandler, false);
    registerInterrupt(0xB, &NPHandler, false);
    registerInterrupt(0xC, &SSHandler, false);
    registerInterrupt(0xD, &GPHandler, false);
    registerInterrupt(0xE, &PFHandler, false);
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
