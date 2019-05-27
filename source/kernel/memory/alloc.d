/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

module memory.alloc;

import memory;

private struct allocMetadata {
    ulong pages;
    ulong size;
}

/**
 * Allocates some ammount of memory in bytes
 *
 * Params:
 *     size = The number of bytes being allocated
 *
 * Returns: A `void*` to the allocated chunk of memory, `null` in failure
 */
void* alloc(size_t size) {
    import memory.physical: pmmAlloc;

    size_t pageCount = (size + pageSize - 1) / pageSize;

    auto ptr = cast(ubyte*)pmmAlloc(pageCount + 1, true);

    if (!ptr) {
        return null;
    }

    ptr += physicalMemoryOffset;

    auto metadata = cast(allocMetadata*)ptr;
    ptr          += pageSize;

    metadata.pages = pageCount;
    metadata.size  = size;

    return cast(void*)ptr;
}

/**
 * Free's a previously allocated pointer with `alloc`
 *
 * Params:
 *     ptr = The pointer being deallocated
 */
void free(void* ptr) {
    import memory.physical: pmmFree;

    auto metadata     = cast(allocMetadata*)(cast(ulong)ptr - pageSize);
    auto metadataPhys = cast(void*)(cast(ulong)metadata - physicalMemoryOffset);

    pmmFree(metadataPhys, metadata.pages + 1);
}
