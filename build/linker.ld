/* linker.ld - Linker script of the project
   (C) 2019 the takao authors (AUTHORS.md). All rights reserved
   This code is governed by a license that can be found in LICENSE.md */
ENTRY(start)

SECTIONS
{
    physicalKernelOffset = 0xFFFFFFFFC0000000;
    . = physicalKernelOffset + 1M;

    .text ALIGN(4K) : AT(ADDR(.text) - physicalKernelOffset)
    {
        *(.multiboot)
        *(.text*)
    }

    .rodata ALIGN(4K) : AT(ADDR(.rodata) - physicalKernelOffset)
    {
        *(.rodata*)
    }

    .data ALIGN(4K) : AT(ADDR(.data) - physicalKernelOffset)
    {
        *(.data*)
    }

    .bss ALIGN(4K) : AT(ADDR(.bss) - physicalKernelOffset)
    {
		*(COMMON)
		*(.bss)
    }
}
