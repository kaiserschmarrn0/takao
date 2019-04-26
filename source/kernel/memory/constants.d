// constants.d - Constants related to kernel's memory
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module memory.constants;

immutable size_t physicalMemoryOffset       = 0xFFFF800000000000;
immutable size_t kernelPhysicalMemoryOffset = 0xFFFFFFFFC0000000;

immutable size_t pageSize         = 4096;
immutable size_t pageTableEntries = 512;

immutable size_t memoryBase = 0x1000000;
immutable size_t bitmapBase = memoryBase / pageSize;
