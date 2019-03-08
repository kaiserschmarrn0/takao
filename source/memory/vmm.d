// vmm.d - Virtual memory manager
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module memory.vmm;

import memory.constants;

alias PageTableEntry = size_t;

__gshared PageTableEntry* pageMap;

void initVMM() {
    import io.term:     error, printLine;
    import memory.e820: e820Map;
    import memory.pmm:  pmmAlloc;

    printLine("VMM: Initialising");

    // We will map the first 4GiB of memory, this saves issues
    // with MMIO hardware that lies on addresses < 4GiB later on.
    pageMap = cast(PageTableEntry*)(cast(size_t)pmmAlloc(1) +
                    physicalMemoryOffset);

    // Catch allocation failure
    if (cast(size_t)pageMap == physicalMemoryOffset) {
        error("pmmAlloc failure in initVMM()");
    }

    // Identity map the first 32 MiB and map 32 MiB for the phys mem area, and
    // 32 MiB for the kernel in the higher half
    for (auto i = 0; i < 0x2000000 / pageSize; i++) {
        size_t addr = i * pageSize;
        mapPage(pageMap, addr, addr, 0x03);
        mapPage(pageMap, physicalMemoryOffset + addr, addr, 0x03);
        mapPage(pageMap, kernelPhysicalMemoryOffset + addr, addr, 0x03);
    }

    // Reload new pagemap
    auto newCR3 = cast(size_t)pageMap - physicalMemoryOffset;

    asm {
        mov RAX, newCR3;
        mov CR3, RAX;
    }

    // Forcefully map the first 4 GiB for I/O into the higher half
    for (auto i = 0; i < 0x100000000 / pageSize; i++) {
        size_t addr = i * pageSize;
        mapPage(pageMap, physicalMemoryOffset + addr, addr, 0x03);
    }

    // Then use the e820 to map all the available memory (saves on allocation
    // time and it's easier).
    // The physical memory is mapped at the beginning of the higher half
    // (entry 256 of the pml4) onwards.
    for (auto i = 0; e820Map[i].type; i++) {
        size_t alignedBase   = e820Map[i].base - (e820Map[i].base % pageSize);
        size_t alignedLength = (e820Map[i].length + pageSize - 1) &
                               ~(pageSize - 1);

        if (e820Map[i].length % pageSize) alignedLength += pageSize;

        if (e820Map[i].base % pageSize) alignedLength += pageSize;

        for (auto j = 0; j * pageSize < alignedLength; j++) {
            size_t addr = alignedBase + j * pageSize;

            // Skip over first 4 GiB
            if (addr < 0x100000000) continue;

            mapPage(pageMap, physicalMemoryOffset + addr, addr, 0x03);
        }
    }
}

// map physaddr -> virtaddr using pml4 pointer
// Returns 0 on success, -1 on failure
int mapPage(PageTableEntry* pagemap, size_t virtualAddress,
            size_t physicalAddress, size_t flags) {
    import memory.pmm: pmmAlloc, pmmFree;

    // Calculate the indices in the various tables using the virtual address
    size_t pml4Entry = (virtualAddress & (cast(size_t)0x1FF << 39)) >> 39;
    size_t pdptEntry = (virtualAddress & (cast(size_t)0x1FF << 30)) >> 30;
    size_t pdEntry   = (virtualAddress & (cast(size_t)0x1FF << 21)) >> 21;
    size_t ptEntry   = (virtualAddress & (cast(size_t)0x1FF << 12)) >> 12;

    PageTableEntry* pdpt, pd, pt;

    if (pagemap[pml4Entry] & 0x1) {
        pdpt = cast(PageTableEntry*)((pagemap[pml4Entry] & 0xFFFFFFFFFFFFF000) +
               physicalMemoryOffset);
    } else {
        // Allocate a page for the pdpt.
        pdpt = cast(PageTableEntry*)(cast(size_t)pmmAlloc(1) +
               physicalMemoryOffset);

        // Catch allocation failure
        if (cast(size_t)pdpt == physicalMemoryOffset) goto fail1;

        // Present + writable + user (0b111)
        pagemap[pml4Entry] = cast(PageTableEntry)(cast(size_t)pdpt -
                             physicalMemoryOffset) | 0b111;
    }

    if (pdpt[pdptEntry] & 0x1) {
        pd = cast(PageTableEntry*)((pdpt[pdptEntry] & 0xFFFFFFFFFFFFF000) +
             physicalMemoryOffset);
    } else {
        // Allocate a page for the pd.
        pd = cast(PageTableEntry*)(cast(size_t)pmmAlloc(1) +
             physicalMemoryOffset);

        // Catch allocation failure
        if (cast(size_t)pdpt == physicalMemoryOffset) goto fail2;

        // Present + writable + user (0b111)
        pdpt[pdptEntry] = cast(PageTableEntry)(cast(size_t)pd -
                          physicalMemoryOffset) | 0b111;
    }

    if (pd[pdEntry] & 0x1) {
        pt = cast(PageTableEntry*)((pd[pdEntry] & 0xFFFFFFFFFFFFF000) +
             physicalMemoryOffset);
    } else {
        // Allocate a page for the pt.
        pt = cast(PageTableEntry*)(cast(size_t)pmmAlloc(1) +
             physicalMemoryOffset);

        // Catch allocation failure
        if (cast(size_t)pdpt == physicalMemoryOffset) goto fail3;

        // Present + writable + user (0b111)
        pd[pdEntry] = cast(PageTableEntry)(cast(size_t)pt -
                      physicalMemoryOffset) | 0b111;
    }

    // Set the entry as present and point it to the passed physical address
    // Also set the specified flags
    pt[ptEntry] = cast(PageTableEntry)(physicalAddress | flags);

    return 0;

fail3:
    for (auto i = 0; ; i++) {
        // We reached the end, table is free
        if (i == pageTableEntries) {
            pmmFree(cast(void*)pd - physicalMemoryOffset, 1);
            break;
        }

        // Table is not free
        if (pd[i] & 0x1) goto fail1;
    }

fail2:
    for (auto i = 0; ; i++) {
        // We reached the end, table is free
        if (i == pageTableEntries) {
            pmmFree(cast(void*)pdpt - physicalMemoryOffset, 1);
            break;
        }

        // Table is not free
        if (pdpt[i] & 0x1) goto fail1;
    }

fail1:
    return -1;
}

int unmapPage(PageTableEntry* pagemap, size_t virtualAddress) {
    import memory.pmm: pmmFree;

    // Calculate the indices in the various tables using the virtual address
    size_t pml4Entry = (virtualAddress & (cast(size_t)0x1FF << 39)) >> 39;
    size_t pdptEntry = (virtualAddress & (cast(size_t)0x1FF << 30)) >> 30;
    size_t pdEntry   = (virtualAddress & (cast(size_t)0x1FF << 21)) >> 21;
    size_t ptEntry   = (virtualAddress & (cast(size_t)0x1FF << 12)) >> 12;

    PageTableEntry* pdpt, pd, pt;

    // Get reference to the various tables in sequence and return -1 if one of
    // the tables is not present, since we cannot unmap a virtual address if
    // we don't know what it's mapped to in the first place.
    if (pagemap[pml4Entry] & 0x1) {
        pdpt = cast(PageTableEntry*)((pagemap[pml4Entry] & 0xFFFFFFFFFFFFF000) +
               physicalMemoryOffset);
    } else goto fail;

    if (pdpt[pdptEntry] & 0x1) {
        pd = cast(PageTableEntry*)((pdpt[pdptEntry] & 0xFFFFFFFFFFFFF000) +
             physicalMemoryOffset);
    } else goto fail;

    if (pd[pdEntry] & 0x1) {
        pt = cast(PageTableEntry*)((pd[pdEntry] & 0xFFFFFFFFFFFFF000) +
             physicalMemoryOffset);
    } else goto fail;

    // Unmap entry
    pt[ptEntry] = 0;

    // Free previous levels if empty
    for (size_t i = 0; ; i++) {
        // We reached the end, table is free
        if (i == pageTableEntries) {
            pmmFree(cast(void*)pt - physicalMemoryOffset, 1);
            break;
        }

        // Table is not free
        if (pt[i] & 0x1) goto done;
    }

    for (auto i = 0; ; i++) {
        if (i == pageTableEntries) {
            // We reached the end, table is free
            pmmFree(cast(void*)pd - physicalMemoryOffset, 1);
            break;
        }

        // Table is not free
        if (pd[i] & 0x1) goto done;
    }

    for (auto i = 0; ; i++) {
        // We reached the end, table is free
        if (i == pageTableEntries) {
            pmmFree(cast(void*)pdpt - physicalMemoryOffset, 1);
            break;
        }

        // Table is not free
        if (pdpt[i] & 0x1) goto done;
    }

done:
    return 0;

fail:
    return -1;
}
