/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

module memory;

/// The physical memory offset applied to all the address space
immutable size_t physicalMemoryOffset       = 0xFFFF800000000000;

/// The physical memory offset applied to the kernel symbols
immutable size_t kernelPhysicalMemoryOffset = 0xFFFFFFFFC0000000;

immutable size_t pageSize         = 4096; /// Page size of the kernel mapping
immutable size_t pageTableEntries = 512;  /// Entries of each page table

/**
 * Initialises all the memory managers with all they need to fully run
 */
void initMemoryManagers() {
    import memory.e820;
    import memory.physical;
    import memory.virtual;
    import util.term;

    info("Initialising memory managers");

    debug {
        log("Obtaining the e820 memory map...");
    }

    getE820();

    debug {
        log("Initialising physical memory bitmap...");
    }

    initPhysicalBitmap();

    debug {
        log("Initialising virtual memory and mapping...");
    }

    mapGlobalMemory();
}
