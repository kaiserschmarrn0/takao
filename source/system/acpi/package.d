// package.d - ACPI table definition and usage
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

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

    ubyte[3] signature;
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
    uint[] sdtPointers;
}

struct XSDT {
    align(1):

    SDT     sdt;
    ulong[] sdtPointers;
}

__gshared RSDP* rsdp;
__gshared RSDT* rsdt;
__gshared XSDT* xsdt;

void initACPI() {
    import util.convert:     toDecimal;
    import util.lib:         areEquals;
    import io.term:          print, error;
    import memory.constants: physicalMemoryOffset;
    import system.acpi.madt: initMADT;

    print("ACPI: Initialising\n");

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

    error("Non-ACPI compliant system");
    return;

RSDPFound:
    print("\tACPI available, revision ");
    print(toDecimal(cast(ulong)rsdp.revision));

    if (rsdp.revision >= 2 && rsdp.xsdt) {
        print(", using the XSDT\n");

        rsdt = null;
        xsdt = cast(XSDT*)(rsdp.xsdt + physicalMemoryOffset);
    } else {
        print(", using the RSDT\n");

        rsdt = cast(RSDT*)(rsdp.rsdt + physicalMemoryOffset);
        xsdt = null;
    }

    initMADT();
}

void* findSDT(string signature) {
    import util.lib:         areEquals;
    import memory.constants: physicalMemoryOffset;

    SDT* pointer;

    if (xsdt) {
        foreach (i; 0..xsdt.sdt.length) {
            pointer = cast(SDT*)(xsdt.sdtPointers[i] + physicalMemoryOffset);

            if (areEquals(cast(char*)pointer.signature, signature, 4)) {
                return cast(void*)pointer;
            }
        }
    } else {
        foreach (i; 0..rsdt.sdt.length) {

            pointer = cast(SDT*)(rsdt.sdtPointers[i] + physicalMemoryOffset);

            if (areEquals(cast(char*)pointer.signature, signature, 4)) {
                return cast(void*)pointer;
            }
        }
    }

    return null;
}
