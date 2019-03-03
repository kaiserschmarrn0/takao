// constants.d - Constants related to kernel's memory
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module memory.constants;

immutable auto physicalMemoryOffset       = 0xFFFF800000000000;
immutable auto kernelPhysicalMemoryOffset = 0xFFFFFFFFC0000000;

immutable auto pageSize         = 4096;
immutable auto pageTableEntries = 512;

immutable auto memoryBase = 0x1000000;
immutable auto bitmapBase = memoryBase / pageSize;
