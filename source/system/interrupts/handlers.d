// handlers.d - Interrupt handlers
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module system.interrupts.handlers;

void defaultInterruptHandler() {
    import util.term: panic;

    panic("An unhandled interrupt ocurred!");
}

void pitHandler() {
    // PIT code
}

void keyboardHandler() {
    // Keyboard driver
}

void apicNMIHandler() {
    import system.interrupts.apic: eoiLocalAPIC;
    import util.term:              panic;

    eoiLocalAPIC();

    panic("Non-maskable APIC interrupt (NMI) occured. Possible hardware issue");
}

void masterPICHandler() {
    import io.ports:  outb;
    import util.term: panic;

    outb(0x20, 0x20);

    panic("An spurious interrupt sent by the master PIC occured");
}

void slavePICHandler() {
    import io.ports:  outb;
    import util.term: panic;

    outb(0xA0, 0x20);
    outb(0x20, 0x20);

    panic("An spurious interrupt sent by the slave PIC occured");
}

void apicSpuriousHandler() {
    import system.interrupts.apic: eoiLocalAPIC;
    import util.term:              panic;

    eoiLocalAPIC();

    panic("An spurious interrupt sent by the APIC occured");
}
