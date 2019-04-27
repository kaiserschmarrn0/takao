// package.d - Memory functions
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module memory;

immutable size_t physicalMemoryOffset       = 0xFFFF800000000000;
immutable size_t kernelPhysicalMemoryOffset = 0xFFFFFFFFC0000000;

immutable size_t pageSize         = 4096;
immutable size_t pageTableEntries = 512;

immutable size_t memoryBase = 0x1000000;
immutable size_t bitmapBase = memoryBase / pageSize;

void initMemoryManagers() {
    import memory.e820;
    import memory.physical;
    import memory.virtual;
    import util.term;

    info("Initialising memory managers");

    debug {
        print("\tObtaining the e820 memory map\n");
    }

    getE820();

    debug {
        print("\tInitialising physical memory bitmap\n");
    }

    initPhysicalBitmap();

    debug {
        print("\tInitialising virtual memory and mapping\n");
    }

    mapGlobalMemory();
}
