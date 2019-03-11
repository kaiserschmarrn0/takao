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
    import memory.pmm: pmmAlloc;

    size_t pageCount = (size + pageSize - 1) / pageSize;

    auto ptr = cast(ubyte*)pmmAlloc(pageCount + 1);

    if (!ptr) return null;

    auto metadata = cast(allocMetadata*)ptr;
    ptr          += pageSize;

    metadata.pages = pageCount;
    metadata.size  = size;

    // Zero pages.
    foreach (i; 0..pageCount * pageSize) {
        ptr[i] = 0;
    }

    return cast(void*)ptr;
}

void free(void* ptr) {
    import memory.constants;
    import memory.pmm: pmmFree;

    auto metadata = cast(allocMetadata*)(cast(ulong)ptr - pageSize);

    pmmFree(cast(void*)metadata, metadata.pages + 1);
}
