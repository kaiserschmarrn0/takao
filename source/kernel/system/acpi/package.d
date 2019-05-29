/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

module system.acpi;

struct RSDP {
    align(1):

    ubyte[8] signature;
    ubyte    checksum;
    ubyte[6] oemID;
    ubyte    revision;
    uint     rsdt;

    // ver 2.0 only
    uint     length;
    ulong    xsdt;
    ubyte    extraChecksum;
    ubyte[3] reserved;
}

struct SDT {
    align(1):

    ubyte[4] signature;
    uint     length;
    ubyte    revision;
    ubyte    checksum;
    ubyte[6] oemID;
    ubyte[8] oemTableID;
    uint     oemRevision;
    uint     creatorID;
    uint     creatorRevision;
}

struct RSDT {
    align(1):

    SDT    sdt;
    uint   sdtPointers;
}

struct XSDT {
    align(1):

    SDT     sdt;
    ulong   sdtPointers;
}

__gshared RSDP* rsdp; /// The RSDP, that always is found
__gshared RSDT* rsdt; /// The RSDT if found
__gshared XSDT* xsdt; /// The XSDT is found

/**
 * Searches for the RSDP table from `0x80000 + physicalMemoryOffset` to
 * `0x100000 + physicalMemoryOffset` (physicalMemoryOffset -> kernel constant)
 *
 * Once RSDP is located, it either defines XSDT or RSDT for use, prefering XSDT.
 * The chosen one will have a value while the other will be `null`.
 *
 * If RSDP is not found, panics
 */
void getACPIInfo() {
    import memory:           physicalMemoryOffset;
    import system.acpi.madt: initMADT;
    import util.lib;

    info("Searching for ACPI tables...");

    for (auto i = 0x80000 + physicalMemoryOffset; i < 0x100000 + physicalMemoryOffset; i += 16) {
        // Skip video mem and mapped hardware
        if (i == 0xA0000 + physicalMemoryOffset) {
            i = 0xE0000 - 16 + physicalMemoryOffset;
            continue;
        }

        if (areEquals(cast(char*)i, "RSD PTR ", 8)) {
            rsdp = cast(RSDP*)i;
            goto RSDPFound;
        }
    }

    panic("Non-ACPI compliant system");
    return;

RSDPFound:
    debug {
        log("Available, revision %u", rsdp.revision);
    }

    if (rsdp.revision >= 2 && rsdp.xsdt) {
        debug {
            log("Using the XSDT");
        }

        rsdt = null;
        xsdt = cast(XSDT*)(rsdp.xsdt + physicalMemoryOffset);
    } else {
        debug {
            log("Using the RSDT");
        }

        rsdt = cast(RSDT*)(rsdp.rsdt + physicalMemoryOffset);
        xsdt = null;
    }

    initMADT();
}

/**
 * Finds an ACPI SDT inside either XSDT or RSDT, the one choosen by
 * `getACPIInfo`
 *
 * Params:
 *     signature = The string signature of the table to be found
 *
 * Return: A pointer to the table
 *
 * Bugs: Will #PF if both the XSDT and RSDT point to `null`
 */
void* findSDT(const(char)* signature) {
    import memory:   physicalMemoryOffset;
    import util.lib;

    SDT* pointer;

    if (xsdt) {
        foreach (i; 0..xsdt.sdt.length) {
            pointer = cast(SDT*)((&xsdt.sdtPointers)[i] + physicalMemoryOffset);

            if (areEquals(cast(char*)pointer.signature, signature, 4)) {
                return cast(void*)pointer;
            }
        }
    } else {
        foreach (i; 0..rsdt.sdt.length) {
            pointer = cast(SDT*)((&rsdt.sdtPointers)[i] + physicalMemoryOffset);

            if (areEquals(cast(char*)pointer.signature, signature, 4)) {
                return cast(void*)pointer;
            }
        }
    }

    return null;
}
