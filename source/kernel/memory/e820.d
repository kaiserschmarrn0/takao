/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

module memory.e820;

struct E820Entry {
    ulong base;
    ulong length;
    uint  type;
    uint  unused;
}

__gshared E820Entry[256] e820Map; /// the e820 memory map filled by `getE820`

private extern(C) void get_e820(E820Entry*);

/**
 * Getting the e820 map and putting it in `e820Map`
 *
 * To accomplish this it will make a real mode call defined in `get_e820`
 */
void getE820() {
    import util.lib.messages;

    get_e820(&e820Map[0]);

    debug {
        ulong memorySize = 0;

        foreach(entry; e820Map) {
            if (!entry.type) {
                break;
            }

            log("[%x -> %x] %x <%s>", entry.base,
                  entry.base + entry.length, entry.length,
                  e820Type(entry.type));

            if (entry.type == 1) memorySize += entry.length;
        }

        log("Total usable memory: %u MiB", memorySize / 1024 / 1024);
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
