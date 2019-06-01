/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

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

struct MADTLAPIC {
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

__gshared MADTLAPIC** madtLAPICs;
__gshared ubyte       madtLAPICCount = 0;

__gshared MADTIOAPIC** madtIOAPICs;
__gshared ubyte        madtIOAPICCount = 0;

__gshared MADTISO** madtISOs;
__gshared ubyte     madtISOCount = 0;

__gshared MADTNMI** madtNMIs;
__gshared ubyte     madtNMICount = 0;

/**
 * Uses ACPI's `findSDT` to find the MADT, and extract information that will get
 * saved in global variables
 *
 * It assumes we wont find more than 256 LAPIC, IOAPIC, ISO or NMI entries.
 */
void initMADT() {
    import system.acpi:  findSDT;
    import memory.alloc: alloc;
    import lib;

    madt = cast(MADT*)findSDT("APIC");

    assert(madt);

    madtLAPICs  = cast(MADTLAPIC**) alloc(256);
    madtIOAPICs = cast(MADTIOAPIC**)alloc(256);
    madtISOs    = cast(MADTISO**)   alloc(256);
    madtNMIs    = cast(MADTNMI**)   alloc(256);

    // parse the MADT entries
    for (ubyte* madtPtr = cast(ubyte*)(&madt.entriesBeginning);
        cast(ulong)madtPtr < cast(ulong)madt + madt.sdt.length;
        madtPtr += *(madtPtr + 1)) {
        switch (*(madtPtr)) {
            case 0:
                madtLAPICs[madtLAPICCount++] = cast(MADTLAPIC*)madtPtr;
                break;
            case 1:
                madtIOAPICs[madtIOAPICCount++] = cast(MADTIOAPIC*)madtPtr;
                break;
            case 2:
                madtISOs[madtISOCount++] = cast(MADTISO*)madtPtr;
                break;
            case 4:
                madtNMIs[madtNMICount++] = cast(MADTNMI*)madtPtr;
                break;
            default:
        }
    }

    debug {
        log("Found up to '%u' LAPICs", madtLAPICCount);
        log("Found up to '%u' IOAPICs", madtIOAPICCount);
        log("Found up to '%u' ISOs", madtISOCount);
        log("Found up to '%u' NMIs", madtNMICount);
    }
}
