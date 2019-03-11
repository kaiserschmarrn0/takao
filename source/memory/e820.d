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
    import io.term:      print;
    import util.convert: toHex, toDecimal;

    size_t memorySize = 0;

    get_e820(&e820Map[0]);

    // Print the memory map
    print("E820 Memory map:\n");

    foreach (entry; e820Map) {
        if (!entry.type) break;

        print("\t[");
        print(toHex(entry.base));
        print(" -> ");
        print(toHex(entry.base + entry.length));
        print("] ");
        print(toHex(entry.length));
        print(" <");
        print(e820Type(entry.type));
        print(">\n");

        if (entry.type == 1) memorySize += entry.length;
    }

    print("\tTotal usable memory: ");
    print(toDecimal(memorySize / 1024 / 1024));
    print(" MiB\n");
}

private string e820Type(uint type) {
    switch (type) {
        case 1:
            return "Usable RAM";
        case 2:
            return "Reserved";
        case 3:
            return "ACPI-Reclaim";
        case 4:
            return "ACPI-NVS";
        case 5:
            return "Bad memory";
        default:
            return "???";
    }
}
