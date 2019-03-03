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

private extern extern (C) void get_e820(E820Entry*);

void getE820() {
    import io.term:      print, printLine;
    import util.convert: toHex, toDecimal;

    size_t memorySize = 0;

    get_e820(&e820Map[0]);

    // Print the memory map
    printLine("E820:");

    for (auto i = 0; e820Map[i].type; i++) {
        print("\t[");
        print(toHex(e820Map[i].base));
        print(" -> ");
        print(toHex(e820Map[i].base + e820Map[i].length));
        print("] ");
        print(toHex(e820Map[i].length));
        print(" <");
        print(e820Type(e820Map[i].type));
        printLine(">");

        if (e820Map[i].type == 1) {
            memorySize += e820Map[i].length;
        }
    }

    print("E820: Total usable memory: ");
    print(toDecimal(memorySize / 1024 / 1024));
    printLine(" MiB");
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
