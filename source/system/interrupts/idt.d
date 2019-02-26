// idt.d - IDT loading and filling
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module system.interrupts.idt;

// The strategy for interrupts in this kernel is thus:
// We will be using interrupts from 255 backwards for hardware interrupts 
// delivered by the APIC.
// Interrupts 0 to 31 are used for CPU exceptions.
// Interrupts 32 through 128 will be used as software interrupts, which gives 
// us ~100 interrupts.
// We do not use DOS-like interrupts where the function is selected through 
// values in registers, in order to:
//     1. Reduce number of instructions necessary for common syscalls.
//     2. Have less clobbered registers.
// The 129th interrupt is for misc software interrupts: this is where rarely 
// used interrupts go and these use DOS-like model (i.e. number in some 
// register) for selecting exact function.

struct IDTDescriptor {
    ushort offsetLow;    // Offset bits 0..15
    ushort selector;     // A code segment selector in GDT or LDT
    ushort flags;        // Various flags, namely:
                         // 0..2: Interrupt stack table
                         // 3..7: zero
                         // 8..11: type
                         // 12: zero
                         // 13..14: descriptor privilege level
                         // 15: segment present flag
    ushort offsetMiddle; // Offset bits 16..31
    uint   offsetHigh;   // Offset bits 32..63
    uint   reserved;     // Unused, set to 0
}

struct IDTPointer {
    align(1):     // Equivalent to __attribute((packed)) in GCC
    ushort size;
    ulong  offset;
}

static __gshared IDTDescriptor[256] idt;

void setIDT() {
    import system.interrupts.exceptions;

    // Load the IDT
    IDTPointer idtPointer;

    idtPointer.size   = idt.sizeof - 1;
    idtPointer.offset = cast(ulong) &idt;

    asm {
        lidt [idtPointer];
    }

    // Exception handlers
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

    // Then set all entries as unhandled interrupts
    for (ubyte vec = 32; vec < 129; vec++) {
        registerInterruptHandler(vec, &unhandledInterruptHandler);
    }
}

void registerInterruptHandler(ubyte number, void function() handler) {
    ulong address = cast(ulong) handler;

    idt[number].offsetLow    = cast(ushort) address;
    idt[number].selector     = 0x08;
    idt[number].flags        = 0x8E00;
    idt[number].offsetMiddle = cast(ushort) (address >> 16);
    idt[number].offsetHigh   = cast(uint)   (address >> 32);
    idt[number].reserved     = 0;
}
