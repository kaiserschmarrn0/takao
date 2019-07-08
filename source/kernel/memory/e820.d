module memory.e820;

import lib;

/// One entry of the e820 memory map
struct E820Entry {
    ulong base;
    ulong length;
    uint  type;
    uint  unused;
}

shared(E820Entry)[256] e820Map; /// The e820 memory map filled by `getE820`

private extern(C) void get_e820(shared(E820Entry)*);

/**
 * Getting the e820 map and putting it in `e820Map`
 *
 * To accomplish this it will make a real mode call defined in `get_e820`
 */
void getE820() {
    get_e820(e820Map.ptr);

    debug {
        ulong memorySize = 0;

        foreach(entry; e820Map) {
            if (!entry.type) {
                break;
            }

            log("[%x -> %x] %x <%s>", entry.base,
                  entry.base + entry.length, entry.length,
                  e820Type(entry.type));

            if (entry.type == 1) {
                memorySize += entry.length;
            }
        }

        log("Total usable memory: %u MiB", memorySize / 1024 / 1024);
    }
}

private cstring e820Type(uint type) {
    switch (type) {
        case 1:  return "Usable RAM";
        case 2:  return "Reserved";
        case 3:  return "ACPI-Reclaim";
        case 4:  return "ACPI-NVS";
        case 5:  return "Bad memory";
        default: return "???";
    }
}
