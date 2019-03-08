// pmm.d - Physical memory manager
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module memory.pmm;

import memory.constants;

private immutable auto bitmapReallocStep = 1;

private __gshared uint*  memoryBitmap;
private __gshared uint[] initialBitmap = [0xFFFFFF7F];
private __gshared uint*  tempBitmap;

// 32 entries because initialBitmap is a single dword.
private __gshared size_t bitmapEntries = 32;

private __gshared size_t currentPointer = bitmapBase;

void initPMM() {
    import io.term:     error, printLine;
    import memory.e820: e820Map;

    printLine("PMM: Initialising");

    memoryBitmap = &initialBitmap[0];
    tempBitmap = cast(uint*)pmmAlloc(bitmapReallocStep);

    if (!tempBitmap) {
        error("pmmAlloc failure in initPMM()");
    }

    tempBitmap = cast(uint*)(cast(size_t)tempBitmap + physicalMemoryOffset);

    for (size_t i = 0; i < (bitmapReallocStep * pageSize) / uint.sizeof; i++) {
        tempBitmap[i] = 0xFFFFFFFF;
    }

    memoryBitmap = tempBitmap;

    bitmapEntries = ((pageSize / uint.sizeof) * 32) * bitmapReallocStep;

    // For each region specified by the e820, iterate over each page which
    // fits in that region and if the region type indicates the area itself
    // is usable, write that page as free in the bitmap. Otherwise, mark the
    // page as used.
    for (size_t i = 0; e820Map[i].type; i++) {
        size_t alignedBase;

        if (e820Map[i].base % pageSize) {
            alignedBase = e820Map[i].base +
                          (pageSize - (e820Map[i].base % pageSize));
        } else alignedBase = e820Map[i].base;

        size_t alignedLength = (e820Map[i].length / pageSize) * pageSize;

        if ((e820Map[i].base % pageSize) && alignedLength) {
            alignedLength -= pageSize;
        }

        for (size_t j = 0; j * pageSize < alignedLength; j++) {
            size_t addr = alignedBase + j * pageSize;

            size_t page = addr / pageSize;

            if (addr < (memoryBase + pageSize)) continue;

            // Reallocate bitmap
            if (addr >= (memoryBase + bitmapEntries * pageSize)) {
                size_t currentBitmapSizeInPages = ((bitmapEntries / 32) *
                                                  uint.sizeof) / pageSize;
                size_t newBitmapSizeInPages = currentBitmapSizeInPages +
                                              bitmapReallocStep;
                tempBitmap = cast(uint*)pmmAlloc(newBitmapSizeInPages);

                if (!tempBitmap) {
                    error("pmmAlloc failure in initPMM()");
                }

                tempBitmap = cast(uint*)(cast(size_t)tempBitmap +
                             physicalMemoryOffset);

                // Copy over previous bitmap
                for (size_t k = 0;
                     k < (currentBitmapSizeInPages * pageSize) / uint.sizeof;
                     k++) tempBitmap[k] = memoryBitmap[k];

                // Fill in the rest
                for (size_t k = (currentBitmapSizeInPages * pageSize) /
                     uint.sizeof;
                     k < (newBitmapSizeInPages * pageSize) / uint.sizeof;
                     k++) tempBitmap[k] = 0xFFFFFFFF;

                bitmapEntries += ((pageSize / uint.sizeof) * 32) *
                                 bitmapReallocStep;
                auto oldBitmap = cast(uint*)(cast(size_t)memoryBitmap -
                                  physicalMemoryOffset);
                memoryBitmap = tempBitmap;
                pmmFree(oldBitmap, currentBitmapSizeInPages);
            }

            writeBitmap(page, 0);
        }
    }
}

void* pmmAlloc(size_t pageCount) {
    auto currentPageCount = pageCount;

    for (size_t i = 0; i < bitmapEntries; i++) {
        if (currentPointer == bitmapBase + bitmapEntries) {
            currentPointer = bitmapBase;
        }

        if (!readBitmap(currentPointer++)) {
            if (!--currentPageCount) goto found;
        } else currentPageCount = pageCount;
    }

    return null;

found:
    auto start = currentPointer - pageCount;

    for (auto i = 0; i < pageCount; i++) writeBitmap(i, true);

    return cast(void*)(start * pageSize);
}

void pmmFree(void* pointer, size_t pageCount) {
    auto start = cast(size_t)pointer / pageSize;

    for (auto i = start; i < (start + pageCount); i++) writeBitmap(i, false);
}

private bool readBitmap(size_t i) {
    // import ldc.llvmasm;

    i -= bitmapBase;

    bool ret = false;

    asm {
        mov RAX, bitmapBase;
        mov RBX, i;
        bt [RAX], RBX;
        setc ret;
    }

    return ret;
    // return __asm!bool("btq $2, [$1] ; setc $0",
    //                   "=r,r,r,~{memory}",
    //                   bitmapBase, i);
}

private void writeBitmap(size_t i, bool val) {
    // import ldc.llvmasm;

    i -= bitmapBase;

    if (val) {
        // __asm("btsq $1, [$0]",
        //       "r,r,~{memory}",
        //       bitmapBase, i);
        asm {
            mov RAX, bitmapBase;
            mov RBX, i;
            bts [RAX], RBX;
        }
    } else {
        // __asm("btrq $1, [$0]",
        //       "r,r,~{memory}",
        //       bitmapBase, i);
        asm {
            mov RAX, bitmapBase;
            mov RBX, i;
            btr [RAX], RBX;
        }
     }
}

private struct allocMetadata {
    size_t pages;
    size_t size;
}

void* alloc(size_t size) {
    size_t pageCount = (size + pageSize - 1) / pageSize;

    auto ptr = cast(ubyte*)pmmAlloc(pageCount + 1);

    if (!ptr) return null;

    auto metadata = cast(allocMetadata*)ptr;
    ptr          += pageSize;

    metadata.pages = pageCount;
    metadata.size  = size;

    // Zero pages.
    for (auto i = 0; i < (pageCount * pageSize); i++) ptr[i] = 0;

    return cast(void*)ptr;
}

void free(void* ptr) {
    auto metadata = cast(allocMetadata*)(cast(size_t)ptr - pageSize);

    pmmFree(cast(void*)metadata, metadata.pages + 1);
}
