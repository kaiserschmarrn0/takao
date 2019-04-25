// apic.d - APIC enabling
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module system.interrupts.apic;

import memory.constants: physicalMemoryOffset;
import system.acpi.madt;

immutable uint apicICR0 = 0x300;
immutable uint apicICR1 = 0x310;

__gshared uint* localAPICEOIPointer;

void enableAPIC() {
    import util.term: print;

    debug {
        print("\tDisabling PIC...\n");
    }

    disablePIC();

    debug {
        print("\tInstalling non-maskable interrupts (NMIs)...\n");
    }

    installLocalAPICNMIs();

    debug {
        print("\tEnabling local APIC...\n");
    }

    enableLocalAPIC();

    size_t localAPICBase = madt.localControllerAddress + physicalMemoryOffset;
    localAPICEOIPointer = cast(uint*)(localAPICBase + 0xB0);
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

    outb(0x21, 0xA0); // Move master to its new offset in the IDT
    wait();
    outb(0xA1, 0xA8); // Same with the slave PIC
    wait();

    outb(0x21, 4); // Tell master that the slave PIC is at IRQ2 (0000 0100)
    wait();
    outb(0xA1, 2); // Tell the slave PIC its cascade identity (0000 0010)
    wait();

    outb(0x21, 1); // 1 = 8086/88 (MCS-80/85) mode
    wait();
    outb(0xA1, 1);
    wait();

    // Restore the masks
    outb(0x21, masterPICMask);
    wait();
    outb(0xA1, slavePICMask);
    wait();
}

void installLocalAPICNMIs() {
    foreach (i; 0..madtNMICount) {
        // Reserve vectors 0x90 .. length of(madtNMIs) for NMIs
        setLocalAPICNMI(0x90 + i, madtNMIs[i].flags, madtNMIs[i].lint);
    }
}

void setLocalAPICNMI(ulong vector, ushort flags, ubyte lint) {
    auto nmi = cast(uint)(800 | vector);

    if (flags & 2) {
        nmi |= (1 << 13);
    }

    if (flags & 8) {
        nmi |= (1 << 15);
    }

    if (lint == 1) {
        writeLocalAPIC(0x360, nmi);
    } else if (lint == 0) {
        writeLocalAPIC(0x350, nmi);
    }
}

void enableLocalAPIC() {
    writeLocalAPIC(0xF0, readLocalAPIC(0xF0) | 0x1FF);
}

uint readLocalAPIC(uint reg) {
    auto base = madt.localControllerAddress + physicalMemoryOffset;
    return *(cast(uint*)(base + reg));
}

void writeLocalAPIC(uint reg, uint data) {
    auto base = madt.localControllerAddress + physicalMemoryOffset;
    *(cast(uint*)(base + reg)) = data;
}

void eoiLocalAPIC() {
    writeLocalAPIC(0xB0, 0);
}
