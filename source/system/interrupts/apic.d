// apic.d - APIC enabling
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module system.interrupts.apic;

void enableAPIC() {
    disablePIC();
}

void disablePIC() {
    import io.ports: outb, wait;

    // Each chip (master and slave) has a command port and a data port.
    // When no command is issued, the data port allows us to access the
    // interrupt mask of the PIC.
    // 0x20 = Master PIC - Command
    // 0x21 = Master PIC - Data
    // 0xA0 = Slave PIC - Command
    // 0xA1 = Slave PIC - Data

    // We can tell the PIC to shut passing 0xFF to its data ports.
    // It needs wait() cause on old machines the PIC can take some time to
    // process the things.
    outb(0x20, 0x11);
    outb(0xA0, 0x11);

    outb(0x21, 0xEF);
    outb(0xA1, 0xF7);

    // master/slave wiring
    outb(0x21, 4);
    outb(0xA1, 2);
    outb(0x21, 1);
    outb(0xA1, 1);

    // And tell them to shut their traps, for ever.
    outb(0xA1, 0xFF);
    outb(0x21, 0xFF);
}
