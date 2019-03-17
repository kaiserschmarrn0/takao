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
    import system.interrupts.exceptions;
    import system.interrupts.handlers;

    IDTPointer idtPointer = {
        size:   idt.sizeof - 1,
        offset: cast(ulong)&idt
    };

    // Set all the interrupts at first
    foreach (i; 0..256) {
        registerInterruptHandler(i, &defaultInterruptHandler);
    }

    registerInterruptHandler(0,  &DEHandler);
    registerInterruptHandler(1,  &DBHandler);
    registerInterruptHandler(2,  &NMIHandler);
    registerInterruptHandler(3,  &BPHandler);
    registerInterruptHandler(4,  &OFHandler);
    registerInterruptHandler(5,  &BRHandler);
    registerInterruptHandler(6,  &UDHandler);
    registerInterruptHandler(7,  &NMHandler);
    registerInterruptHandler(8,  &DFHandler);
    registerInterruptHandler(9,  &CSOHandler);
    registerInterruptHandler(10, &TSHandler);
    registerInterruptHandler(11, &NPHandler);
    registerInterruptHandler(12, &SSHandler);
    registerInterruptHandler(13, &GPHandler);
    registerInterruptHandler(14, &PFHandler);
    // 15 is reserved.
    registerInterruptHandler(16, &MFHandler);
    registerInterruptHandler(17, &ACHandler);
    registerInterruptHandler(18, &MCHandler);
    registerInterruptHandler(19, &XFHandler);
    registerInterruptHandler(20, &VEHandler);
    // 21 to 29 are reserved.
    registerInterruptHandler(30, &SXHandler);
    // 31 is reserved.

    registerInterruptHandler(32, &irq0Handler);
    registerInterruptHandler(33, &irq1Handler);

    foreach (i; 0..16) {
        registerInterruptHandler(144 + i, &apicNMIHandler);
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
