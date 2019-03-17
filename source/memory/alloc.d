// alloc.d - alloc and free using the physical memory manager
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module memory.alloc;

private struct allocMetadata {
    ulong pages;
    ulong size;
}

void* alloc(size_t size) {
    import memory.constants;
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

void free(void* ptr) {
    import memory.constants;
    import memory.physical: pmmFree;

    auto metadata = cast(allocMetadata*)(cast(ulong)ptr - pageSize);
    auto metadataPhys = cast(void*)(cast(ulong)metadata - physicalMemoryOffset);

    pmmFree(metadataPhys, metadata.pages + 1);
}
