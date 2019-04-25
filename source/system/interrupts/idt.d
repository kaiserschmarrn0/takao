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
    import system.interrupts.handlers;

    IDTPointer idtPointer = {
        size:   idt.sizeof - 1,
        offset: cast(ulong)&idt
    };

    // Set all the interrupts at first
    foreach (uint i; 0..idt.length) {
        registerInterruptHandler(i, &defaultInterruptHandler);
    }

    registerInterruptHandler(0x0, &DEHandler);
    registerInterruptHandler(0x1, &DBHandler);
    registerInterruptHandler(0x2, &NMIHandler);
    registerInterruptHandler(0x3, &BPHandler);
    registerInterruptHandler(0x4, &OFHandler);
    registerInterruptHandler(0x5, &BRHandler);
    registerInterruptHandler(0x6, &UDHandler);
    registerInterruptHandler(0x7, &NMHandler);
    registerInterruptHandler(0x8, &DFHandler);
    registerInterruptHandler(0x9, &CSOHandler);
    registerInterruptHandler(0xA, &TSHandler);
    registerInterruptHandler(0xB, &NPHandler);
    registerInterruptHandler(0xC, &SSHandler);
    registerInterruptHandler(0xD, &GPHandler);
    registerInterruptHandler(0xE, &PFHandler);
    // 0xF is reserved.
    registerInterruptHandler(0x10, &MFHandler);
    registerInterruptHandler(0x11, &ACHandler);
    registerInterruptHandler(0x12, &MCHandler);
    registerInterruptHandler(0x13, &XFHandler);
    registerInterruptHandler(0x14, &VEHandler);
    // 0x15..0x1D are reserved.
    registerInterruptHandler(0x1E, &SXHandler);
    // 0x1F is reserved.

    registerInterruptHandler(0x20, &pitHandler);
    registerInterruptHandler(0x21, &keyboardHandler);

    foreach (i; 0..16) {
        registerInterruptHandler(0x90 + i, &apicNMIHandler);
    }

    foreach (i; 0..8) {
        registerInterruptHandler(0xA0 + i, &masterPICHandler);
    }

    foreach (i; 0..8) {
        registerInterruptHandler(0xA8 + i, &slavePICHandler);
    }

    registerInterruptHandler(0xFF, &apicSpuriousHandler);

    asm {
        lidt [idtPointer];
    }
}

void registerInterruptHandler(uint number, void function() handler) {
    auto address = cast(ulong)handler;

    idt[number].offsetLow    = cast(ushort)address;
    idt[number].selector     = 0x08;
    idt[number].ist          = 0x00;
    idt[number].flags        = 0x8E;
    idt[number].offsetMiddle = cast(ushort)(address >> 16);
    idt[number].offsetHigh   = cast(uint)(address >> 32);
    idt[number].reserved     = 0;
}
