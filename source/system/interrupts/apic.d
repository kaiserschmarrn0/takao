// apic.d - APIC enabling
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module system.interrupts.apic;

void enableAPIC() {
    disablePIC();
}

void disablePIC() {
    import io.ports: inb, outb, wait;

    // Each chip (master and slave) has a command port and a data port.
    // When no command is issued, the data port allows us to access the
    // interrupt mask of the PIC.
    // 0x20 = Master PIC - Command
    // 0x21 = Master PIC - Data
    // 0xA0 = Slave PIC - Command
    // 0xA1 = Slave PIC - Data

    // It needs wait() cause on old machines the PIC can take some time to
    // process the things.

    // Save the masks
    auto masterPICMask = inb(0x21);
    auto slavePICMask  = inb(0xA1);

    // 0x11 starts the initialization sequence (in cascade mode)
    outb(0x20, 0x11);
    wait();
    outb(0xA0, 0x11);
    wait();

    outb(0x21, 0xEF); // Move master to its new offset
    wait();
    outb(0xA1, 0xF7); // Same with the slave PIC
    wait();

    outb(0x21, 4); // Tell master that the slave PIC is at IRQ2 (0000 0100)
    wait();
    outb(0xA1, 2); // Tell the slave PIC its cascade identity (0000 0010)
    wait();

    outb(0x21, 1); // 1 =  8086/88 (MCS-80/85) mode
    wait();
    outb(0xA1, 1);
    wait();

    // Restore the masks
    outb(0x21, masterPICMask);
    wait();
    outb(0xA1, slavePICMask);
    wait();

    // We can tell the PIC to shut (mask all of its interrupts) passing 0xFF to
    // its data ports.
    outb(0xA1, 0xFF);
    outb(0x21, 0xFF);
}
