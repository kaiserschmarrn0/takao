/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

module memory.physical;

import memory;
import util.lib.spinlock;

private immutable auto bitmapReallocStep = 1;
private immutable size_t memoryBase = 0x1000000;
private immutable size_t bitmapBase = memoryBase / pageSize;

private __gshared uint*  memoryBitmap;
private __gshared uint[] initialBitmap = [0xFFFFFF7F];
private __gshared uint*  tempBitmap;

// 32 entries because initialBitmap is a single dword.
private __gshared size_t bitmapEntries = 32;

private __gshared size_t currentPointer = bitmapBase;

/**
 * Initialises the physical bitmap, the base of the memory management in the OS
 */
void initPhysicalBitmap() {
    import memory.e820: e820Map;

    memoryBitmap = &initialBitmap[0];
    tempBitmap   = cast(uint*)pmmAlloc(bitmapReallocStep, false);

    assert(tempBitmap);

    tempBitmap = cast(uint*)(cast(ulong)tempBitmap + physicalMemoryOffset);

    foreach (i; 0..bitmapReallocStep * pageSize / uint.sizeof) {
        tempBitmap[i] = 0xFFFFFFFF;
    }

    memoryBitmap = tempBitmap;

    bitmapEntries = ((pageSize / uint.sizeof) * 32) * bitmapReallocStep;

    // For each region specified by the e820, iterate over each page which
    // fits in that region and if the region type indicates the area itself
    // is usable, write that page as free in the bitmap. Otherwise, mark the
    // page as used.
    for (auto i = 0; e820Map[i].type; i++) {
        size_t alignedBase;

        if (e820Map[i].base % pageSize) {
            alignedBase = e820Map[i].base +
                          (pageSize - (e820Map[i].base % pageSize));
        } else alignedBase = e820Map[i].base;

        size_t alignedLength = (e820Map[i].length / pageSize) * pageSize;

        if ((e820Map[i].base % pageSize) && alignedLength) {
            alignedLength -= pageSize;
        }

        for (auto j = 0; j * pageSize < alignedLength; j++) {
            size_t addr = alignedBase + j * pageSize;

            size_t page = addr / pageSize;

            if (addr < memoryBase + pageSize) {
                continue;
            }

            // Reallocate bitmap
            if (addr >= (memoryBase + bitmapEntries * pageSize)) {
                size_t currentBitmapSizeInPages = ((bitmapEntries / 32) *
                                                  uint.sizeof) / pageSize;
                size_t newBitmapSizeInPages = currentBitmapSizeInPages +
                                              bitmapReallocStep;
                tempBitmap = cast(uint*)pmmAlloc(newBitmapSizeInPages, false);

                assert(tempBitmap);

                tempBitmap = cast(uint*)(cast(size_t)tempBitmap +
                             physicalMemoryOffset);

                // Copy over previous bitmap
                foreach (k;
                         0..currentBitmapSizeInPages * pageSize / uint.sizeof) {
                    tempBitmap[k] = memoryBitmap[k];
                }

                // Fill in the rest
                for (auto k = (currentBitmapSizeInPages * pageSize) /
                     uint.sizeof;
                     k < (newBitmapSizeInPages * pageSize) / uint.sizeof; k++) {
                    tempBitmap[k] = 0xFFFFFFFF;
                }

                bitmapEntries += ((pageSize / uint.sizeof) * 32) *
                                 bitmapReallocStep;
                auto oldBitmap = cast(uint*)(cast(ulong)memoryBitmap -
                                 physicalMemoryOffset);
                memoryBitmap = tempBitmap;
                pmmFree(oldBitmap, currentBitmapSizeInPages);
            }

            writeBitmap(page, 0);
        }
    }
}

private shared SpinLock lock = unlocked;

/**
 * Allocate a number of pages
 *
 * Params:
 *     pageCount = Number of pages to allocate
 *     zero      = Zero out the pages or not
 *
 * Returns: A `void*` to the first of the allocated pages, `null` in failure
 */
void* pmmAlloc(size_t pageCount, bool zero) {
    acquireSpinlock(&lock);

    auto currentPageCount = pageCount;

    foreach (i; 0..bitmapEntries) {
        if (currentPointer == bitmapBase + bitmapEntries) {
            currentPointer   = bitmapBase;
            currentPageCount = pageCount;
        }

        if (!readBitmap(currentPointer++)) {
            if (!--currentPageCount) goto found;
        } else currentPageCount = pageCount;
    }

    releaseSpinlock(&lock);
    return null;

found:
    auto start = currentPointer - pageCount;

    foreach (i; 0..pageCount) {
        writeBitmap(i, true);
    }

    void* ret = cast(void*)(start * pageSize);

    if (zero) {
        auto ptr = cast(ulong*)(cast(ulong)ret + physicalMemoryOffset);

        foreach (i; 0..(pageCount * pageSize) / ulong.sizeof) {
            ptr[i] = 0;
        }
    }

    releaseSpinlock(&lock);
    return ret;
}

/**
 * Free a number of pages from a pointer
 *
 * Params:
 *     pointer   = The pointer to be freed
 *     pageCount = The number of pages to free
 */
void pmmFree(void* pointer, size_t pageCount) {
    acquireSpinlock(&lock);

    auto start = cast(size_t)pointer / pageSize;

    for (auto i = start; i < (start + pageCount); i++) {
        writeBitmap(i, false);
    }

    releaseSpinlock(&lock);
}

private bool readBitmap(size_t i) {
    i -= bitmapBase;

    bool ret = false;

    asm {
        mov RAX, bitmapBase;
        mov RBX, i;
        bt [RAX], RBX;
        setc ret;
    }

    return ret;
}

private void writeBitmap(size_t i, bool val) {
    i -= bitmapBase;

    if (val) {
        asm {
            mov RAX, bitmapBase;
            mov RBX, i;
            bts [RAX], RBX;
        }
    } else {
        asm {
            mov RAX, bitmapBase;
            mov RBX, i;
            btr [RAX], RBX;
        }
     }
}
