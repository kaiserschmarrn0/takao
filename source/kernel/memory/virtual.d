module memory.virtual;

import memory;
import lib.spinlock;

alias PageTableEntry = size_t;

struct PageMap {
    PageTableEntry* pml4;
    SpinLock        lock;
}

shared PageMap* kernelPageMap; /// The kernel paging scheme

PageMap* createPageMap() {
    import memory.physical: pmmAlloc;
    import memory.alloc:    alloc, free;

    auto newPageMap = cast(PageMap*)alloc(PageMap.sizeof);

    assert(newPageMap);

    newPageMap.pml4 = cast(PageTableEntry*)pmmAlloc(1, true);

    if (!newPageMap.pml4) {
        free(newPageMap);
        return null;
    }

    newPageMap.pml4 = cast(PageTableEntry*)(cast(size_t)newPageMap.pml4 + physicalMemoryOffset);
    newPageMap.lock = unlocked;

    return newPageMap;
}

void freePageMap(shared PageMap* pagemap) {
    import memory.physical: pmmFree;
    import memory.alloc:    free;

    PageTableEntry* pdpt;
    PageTableEntry* pd;
    PageTableEntry* pt;

    acquireSpinlock(&pagemap.lock);

    foreach (i; 0..(pageTableEntries / 2)) {
        if (pagemap.pml4[i] & 1) {
            pdpt = cast(PageTableEntry*)((pagemap.pml4[i] & 0xFFFFFFFFFFFFF000) + physicalMemoryOffset);

            foreach (j; 0..pageTableEntries) {
                if (pdpt[j] & 1) {
                    pd = cast(PageTableEntry*)((pdpt[j] & 0xFFFFFFFFFFFFF000) + physicalMemoryOffset);

                    foreach (k; 0..pageTableEntries) {
                        if (pd[k] & 1) {
                            pt = cast(PageTableEntry*)((pd[k] & 0xFFFFFFFFFFFFF000) + physicalMemoryOffset);

                            foreach (l; 0..pageTableEntries) {
                                if (pt[l] & 1) {
                                    pmmFree(cast(void*)(pt[l] & 0xFFFFFFFFFFFFF000), 1);
                                }
                            }

                            pmmFree(cast(void*)(pd[k] & 0xFFFFFFFFFFFFF000), 1);
                        }
                    }

                    pmmFree(cast(void*)(pdpt[j] & 0xFFFFFFFFFFFFF000), 1);
                }
            }

            pmmFree(cast(void*)(pagemap.pml4[i] & 0xFFFFFFFFFFFFF000), 1);
        }
    }

    pmmFree(cast(void*)pagemap.pml4 - physicalMemoryOffset, 1);
    free(cast(void*)pagemap);
}

/**
 * Sets the paging scheme of the kernel
 *
 * This function will map the first 4GiB of memory, this saves issues
 * with MMIO hardware that lies on addresses < 4GiB later on.
 *
 * It will then identity map the first 32 MiB and map 32 MiB for the physical
 * memory area, and 32 MiB for the kernel in the higher half.
 *
 * Finally, it forcefully map from the first 32 MiB to the first 4 GiB for I/O
 * into the higher half and finally map all the available memory (e820)
 */
void mapGlobalMemory() {
    import memory.e820:     e820Map;
    import memory.physical: pmmAlloc;

    kernelPageMap = cast(shared)createPageMap();
    assert(kernelPageMap);

    // We will map the first 4GiB of memory, first identity mapping
    foreach (i; 0..(0x2000000 / pageSize)) {
        ulong addr = i * pageSize;

        mapPage(kernelPageMap, addr, addr, 0x03);
        mapPage(kernelPageMap, physicalMemoryOffset + addr, addr, 0x03);
        mapPage(kernelPageMap, kernelPhysicalMemoryOffset + addr, addr, 0x03);
    }

    // Reload new pagemap
    auto newCR3 = cast(size_t)kernelPageMap.pml4 - physicalMemoryOffset;

    asm {
        mov RAX, newCR3;
        mov CR3, RAX;
    }

    // Forcefully map from the first 32 MiB to the the first 4 GiB for I/O
    // into the higher half
    foreach (ulong i; 0..(0x100000000 / pageSize)) {
        ulong addr = i * pageSize;

        mapPage(kernelPageMap, physicalMemoryOffset + addr, addr, 0x03);
    }

    // Use the e820 to map all the available memory (saves on allocation
    // time and it's easier).
    // The physical memory is mapped at the beginning of the higher half
    // (entry 256 of the pml4) onwards.
    for (auto i = 0; e820Map[i].type; i++) {
        size_t alignedBase   = e820Map[i].base - (e820Map[i].base % pageSize);
        size_t alignedLength = (e820Map[i].length / pageSize) * pageSize;

        if (e820Map[i].length % pageSize) {
            alignedLength += pageSize;
        }

        if (e820Map[i].base % pageSize) {
            alignedLength += pageSize;
        }

        for (ulong j = 0; j * pageSize < alignedLength; j++) {
            ulong addr = alignedBase + j * pageSize;

            // Skip over first 4 GiB
            if (addr < 0x100000000) {
                continue;
            }

            mapPage(kernelPageMap, physicalMemoryOffset + addr, addr, 0x03);
        }
    }
}

/**
 * Maps a physical address to a virtual address using a pml4 pointer (pagemap)
 *
 * Params:
 *     pagemap         = The pml4 pointer to use
 *     virtualAddress  = The virtual address to map
 *     physicalAddress = The physical address to use
 *     flags           = Flags for the page
 *
 * Returns: `0` on success, `-1` on failure
 */
int mapPage(shared PageMap* pagemap, size_t virtualAddress, size_t physicalAddress, size_t flags) {
    import memory.physical: pmmAlloc, pmmFree;

    acquireSpinlock(&pagemap.lock);

    // Calculate the indices in the various tables using the virtual address
    size_t pml4Entry = (virtualAddress & (cast(size_t)0x1FF << 39)) >> 39;
    size_t pdptEntry = (virtualAddress & (cast(size_t)0x1FF << 30)) >> 30;
    size_t pdEntry   = (virtualAddress & (cast(size_t)0x1FF << 21)) >> 21;
    size_t ptEntry   = (virtualAddress & (cast(size_t)0x1FF << 12)) >> 12;

    PageTableEntry* pdpt, pd, pt;

    if (pagemap.pml4[pml4Entry] & 0x1) {
        pdpt = cast(PageTableEntry*)((pagemap.pml4[pml4Entry] & 0xFFFFFFFFFFFFF000) +
               physicalMemoryOffset);
    } else {
        // Allocate a page for the pdpt.
        pdpt = cast(PageTableEntry*)(cast(size_t)pmmAlloc(1, true) +
               physicalMemoryOffset);

        // Catch allocation failure
        if (cast(size_t)pdpt == physicalMemoryOffset) {
            goto fail1;
        }

        // Present + writable + user (0b111)
        pagemap.pml4[pml4Entry] = cast(PageTableEntry)(cast(size_t)pdpt -
                             physicalMemoryOffset) | 0b111;
    }

    if (pdpt[pdptEntry] & 0x1) {
        pd = cast(PageTableEntry*)((pdpt[pdptEntry] & 0xFFFFFFFFFFFFF000) +
             physicalMemoryOffset);
    } else {
        // Allocate a page for the pd.
        pd = cast(PageTableEntry*)(cast(size_t)pmmAlloc(1, true) +
             physicalMemoryOffset);

        // Catch allocation failure
        if (cast(size_t)pd == physicalMemoryOffset) {
            goto fail2;
        }

        // Present + writable + user (0b111)
        pdpt[pdptEntry] = cast(PageTableEntry)(cast(size_t)pd -
                          physicalMemoryOffset) | 0b111;
    }

    if (pd[pdEntry] & 0x1) {
        pt = cast(PageTableEntry*)((pd[pdEntry] & 0xFFFFFFFFFFFFF000) +
             physicalMemoryOffset);
    } else {
        // Allocate a page for the pt.
        pt = cast(PageTableEntry*)(cast(size_t)pmmAlloc(1, true) +
             physicalMemoryOffset);

        // Catch allocation failure
        if (cast(size_t)pt == physicalMemoryOffset) goto fail3;

        // Present + writable + user (0b111)
        pd[pdEntry] = cast(PageTableEntry)(cast(size_t)pt -
                      physicalMemoryOffset) | 0b111;
    }

    // Set the entry as present and point it to the passed physical address
    // Also set the specified flags
    pt[ptEntry] = cast(PageTableEntry)(physicalAddress | flags);

    releaseSpinlock(&pagemap.lock);
    return 0;

fail3:
    for (auto i = 0; ; i++) {
        // We reached the end, table is free
        if (i == pageTableEntries) {
            pmmFree(cast(void*)pd - physicalMemoryOffset, 1);
            break;
        }

        // Table is not free
        if (pd[i] & 0x1) {
            goto fail1;
        }
    }

fail2:
    for (auto i = 0; ; i++) {
        // We reached the end, table is free
        if (i == pageTableEntries) {
            pmmFree(cast(void*)pdpt - physicalMemoryOffset, 1);
            break;
        }

        // Table is not free
        if (pdpt[i] & 0x1) {
            goto fail1;
        }
    }

fail1:
    releaseSpinlock(&pagemap.lock);
    return -1;
}

/**
 * Unmaps a virtual address using a pml4 pointer (pagemap)
 *
 * Params:
 *     pagemap         = The pml4 pointer to use
 *     virtualAddress  = The virtual address to unmap
 *
 * Returns: `0` on success, `-1` on failure
 */
int unmapPage(shared PageMap* pagemap, size_t virtualAddress) {
    import memory.physical: pmmFree;

    acquireSpinlock(&pagemap.lock);

    // Calculate the indices in the various tables using the virtual address
    size_t pml4Entry = (virtualAddress & (cast(size_t)0x1FF << 39)) >> 39;
    size_t pdptEntry = (virtualAddress & (cast(size_t)0x1FF << 30)) >> 30;
    size_t pdEntry   = (virtualAddress & (cast(size_t)0x1FF << 21)) >> 21;
    size_t ptEntry   = (virtualAddress & (cast(size_t)0x1FF << 12)) >> 12;

    PageTableEntry* pdpt, pd, pt;

    // Get reference to the various tables in sequence and return -1 if one of
    // the tables is not present, since we cannot unmap a virtual address if
    // we don't know what it's mapped to in the first place.
    if (pagemap.pml4[pml4Entry] & 0x1) {
        pdpt = cast(PageTableEntry*)((pagemap.pml4[pml4Entry] & 0xFFFFFFFFFFFFF000) +
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
    releaseSpinlock(&pagemap.lock);
    return 0;

fail:
    releaseSpinlock(&pagemap.lock);
    return -1;
}

/* Update flags for a mapping */
int remapPage(shared PageMap* pagemap, size_t virtAddr, size_t flags) {
    acquireSpinlock(&pagemap.lock);

    // Calculate the indices in the various tables using the virtual address
    size_t pml4Entry = (virtAddr & (cast(size_t)0x1FF << 39)) >> 39;
    size_t pdptEntry = (virtAddr & (cast(size_t)0x1FF << 30)) >> 30;
    size_t pdEntry   = (virtAddr & (cast(size_t)0x1FF << 21)) >> 21;
    size_t ptEntry   = (virtAddr & (cast(size_t)0x1FF << 12)) >> 12;

    size_t cr3;

    PageTableEntry* pdpt, pd, pt;

    // Get reference to the various tables in sequence. Return -1 if one of the
    // tables is not present, since we cannot unmap a virtual address if we
    // don't know what it's mapped to in the first place
    if (pagemap.pml4[pml4Entry] & 0x1) {
        pdpt = cast(PageTableEntry*)((pagemap.pml4[pml4Entry] & 0xFFFFFFFFFFFFF000) + physicalMemoryOffset);
    } else {
        goto fail;
    }

    if (pdpt[pdptEntry] & 0x1) {
        pd = cast(PageTableEntry*)((pdpt[pdptEntry] & 0xFFFFFFFFFFFFF000) + physicalMemoryOffset);
    } else {
        goto fail;
    }

    if (pd[pdEntry] & 0x1) {
        pt = cast(PageTableEntry*)((pd[pdEntry] & 0xFFFFFFFFFFFFF000) + physicalMemoryOffset);
    } else {
        goto fail;
    }

    // Update flags
    pt[ptEntry] = (pt[ptEntry] & 0xFFFFFFFFFFFFF000) | flags;

    // Get CR3
    asm {
        mov RAX, CR3;
        mov cr3, RAX;
    }

    if (cast(PageTableEntry)pagemap.pml4 == cr3) {
        // TODO: TLB shootdown

        // Invalidate page
        asm {
            mov RBX, virtAddr;
            invlpg [RBX];
        }
    }

    releaseSpinlock(&pagemap.lock);
    return 0;

fail:
    releaseSpinlock(&pagemap.lock);
    return -1;
}
