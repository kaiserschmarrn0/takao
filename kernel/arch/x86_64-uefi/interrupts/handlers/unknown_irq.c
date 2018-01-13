// File: unknown_irq.c
//
// Description: unknown_irq handler.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "unknown_irq.h"

__attribute__((naked)) void unknown_irq_handler()
{
    __asm__(".intel_syntax;"
            "mov dx, 03f8h;"
            "mov al, 023h;"
            "out dx, al;"
            "mov al, 'I';"
            "out dx, al;"
            "mov al, '?';"
            "out dx, al;"
            "mov al, 0Ah;"
            "out dx, al;"
            "1:"
            "hlt;"
            "jmp 1b;");
}