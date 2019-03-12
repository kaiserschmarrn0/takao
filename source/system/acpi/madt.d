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
__gshared ulong           madtLocalAPICID;

__gshared MADTIOAPIC** madtIOAPICs;
__gshared ulong        madtIOAPICID;

__gshared MADTISO** madtISOs;
__gshared ulong     madtISOID;

__gshared MADTNMI** madtNMIs;
__gshared ulong     madtNMIID;

void initMADT() {
    import util.convert: toDecimal;
    import util.lib:     areEquals;
    import io.term:      print, error;
    import system.acpi:  findSDT;
    import memory.alloc: alloc;

    madt = cast(MADT*)findSDT("APIC");

    if (!madt) {
        error("The MADT is not available");
    }

    // We wont find more than 256 of each (I hope)
    madtLocalAPICs = cast(MADTLocalAPIC**)alloc(256);
    madtIOAPICs    = cast(MADTIOAPIC**)   alloc(256);
    madtISOs       = cast(MADTISO**)      alloc(256);
    madtNMIs       = cast(MADTNMI**)      alloc(256);
}
