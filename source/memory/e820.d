// e820.d - E820
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module memory.e820;

struct E820Entry {
    ulong base;
    ulong length;
    uint  type;
    uint  unused;
}

__gshared E820Entry[256] e820Map;

private extern extern(C) void get_e820(E820Entry*);

void getE820() {
    import util.term: print;

    print("Obtaining the E820 memory map...\n");

    get_e820(&e820Map[0]);

    debug {
        ulong memorySize = 0;

        foreach (entry; e820Map) {
            if (!entry.type) break;

            print("\t[%x -> %x] %x <%s>\n", entry.base,
                  entry.base + entry.length, entry.length,
                  e820Type(entry.type));

            if (entry.type == 1) memorySize += entry.length;
        }

        print("\tTotal usable memory: %u MiB\n", memorySize / 1024 / 1024);
    }
}

private char* e820Type(uint type) {
    switch (type) {
        case 1:
            return cast(char*)"Usable RAM";
        case 2:
            return cast(char*)"Reserved";
        case 3:
            return cast(char*)"ACPI-Reclaim";
        case 4:
            return cast(char*)"ACPI-NVS";
        case 5:
            return cast(char*)"Bad memory";
        default:
            return cast(char*)"???";
    }
}
