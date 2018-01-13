// File: unknown.c
//
// Description: unknown handler.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "unknown.h"

__attribute__((naked)) void unknown_handler()
{
	__asm__(".intel_syntax;"
            "mov dx, 03f8h;"
            "mov al, 023h;"
            "out dx, al;"
            "mov al, '?';"
            "out dx, al;"
            "mov al, '?';"
            "out dx, al;"
            "mov al, 0Ah;"
            "out dx, al;"
            "1:"
            "hlt;"
            "jmp 1b;");
}