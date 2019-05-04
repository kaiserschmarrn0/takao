/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

module system.interrupts.irq;

import system.pit;
import system.interrupts.apic;
import util.term;

/**
 * The default interrupt handler
 */
void defaultInterruptHandler() {
    panic("An unhandled interrupt ocurred!");
}

/**
 * The PIT (IRQ0) interrupt handler
 */
void pitHandler() {
    asm {
        naked;

        push RAX;
        push RBX;
        push RCX;
        push RDX;
        push RSI;
        push RDI;
        push RBP;
        push R8;
        push R9;
        push R10;
        push R11;
        push R12;
        push R13;
        push R14;
        push R15;

        call pitInner; // In the PIT code

        mov RAX, lapicEOIPointer;
        mov int ptr [RAX], 0;

        pop R15;
        pop R14;
        pop R13;
        pop R12;
        pop R11;
        pop R10;
        pop R9;
        pop R8;
        pop RBP;
        pop RDI;
        pop RSI;
        pop RDX;
        pop RCX;
        pop RBX;
        pop RAX;

        iretq;
    }
}

/**
 * A handler for APIC Non maskable interrupts
 */
void apicNMIHandler() {
    eoiLAPIC();

    panic("Non-maskable APIC interrupt (NMI) occured. Possible hardware issue");
}

/**
 * A handler for the master PIC interrupts, which should be masked
 */
void masterPICHandler() {
    import io.ports: outb;

    outb(0x20, 0x20);

    panic("A spurious interrupt sent by the master PIC occured");
}

/**
 * A handler for the slave PIC interrupts, which should be masked
 */
void slavePICHandler() {
    import io.ports: outb;

    outb(0xA0, 0x20);
    outb(0x20, 0x20);

    panic("A spurious interrupt sent by the slave PIC occured");
}

/**
 * A handler for the spurious APIC interrupts, which should've never existed to
 * begin with
 */
void apicSpuriousHandler() {
    eoiLAPIC();

    panic("A spurious interrupt sent by the APIC occured");
}
