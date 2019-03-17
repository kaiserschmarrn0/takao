// madt.d - MADT ACPI table structures and reading
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module system.acpi.madt;

import system.acpi: SDT;

struct MADT {
    align(1):

    SDT   sdt;
    uint  localControllerAddress;
    uint  flags;
    ubyte entriesBeginning;
}

struct MADTHeader {
    align(1):

    ubyte type;
    ubyte length;
}

struct MADTLocalAPIC {
    align(1):

    MADTHeader header;
    ubyte      processorID;
    ubyte      apicID;
    uint       flags;
}

struct MADTIOAPIC {
    align(1):

    MADTHeader header;
    ubyte      apicID;
    ubyte      reserved;
    uint       address;
    uint       gsib;
}

struct MADTISO {
    align(1):

    MADTHeader header;
    ubyte      busSource;
    ubyte      irqSource;
    uint       gsi;
    ushort     flags;
}

struct MADTNMI {
    align(1):

    MADTHeader header;
    ubyte      processor;
    ushort     flags;
    ubyte      lint;
}

__gshared MADT* madt;

__gshared MADTLocalAPIC** madtLocalAPICs;
__gshared ulong           madtLocalAPICID = 0;

__gshared MADTIOAPIC** madtIOAPICs;
__gshared ulong        madtIOAPICID = 0;

__gshared MADTISO** madtISOs;
__gshared ulong     madtISOID = 0;

__gshared MADTNMI** madtNMIs;
__gshared ulong     madtNMIID = 0;

void initMADT() {
    import system.acpi:  findSDT;
    import memory.alloc: alloc;
    import util.term:    panic;

    madt = cast(MADT*)findSDT("APIC");

    if (!madt) {
        panic("The MADT is not available");
    }

    // We wont find more than 256 of each (I hope)
    madtLocalAPICs = cast(MADTLocalAPIC**)alloc(256);
    madtIOAPICs    = cast(MADTIOAPIC**)   alloc(256);
    madtISOs       = cast(MADTISO**)      alloc(256);
    madtNMIs       = cast(MADTNMI**)      alloc(256);

    // parse the MADT entries
    for (ubyte* madtPtr = cast(ubyte*)(&madt.entriesBeginning);
        cast(ulong)madtPtr < cast(ulong)madt + madt.sdt.length;
        madtPtr += *(madtPtr + 1)) {
        switch (*(madtPtr)) {
            case 0:
                // Processor local APIC
                madtLocalAPICs[madtLocalAPICID++] = cast(MADTLocalAPIC*)madtPtr;
                break;
            case 1:
                // I/O APIC
                madtIOAPICs[madtIOAPICID++] = cast(MADTIOAPIC*)madtPtr;
                break;
            case 2:
                // Interrupt Source Override
                madtISOs[madtISOID++] = cast(MADTISO*)madtPtr;
                break;
            case 4:
                // NMI
                madtNMIs[madtNMIID++] = cast(MADTNMI*)madtPtr;
                break;
            default:
        }
    }
}
