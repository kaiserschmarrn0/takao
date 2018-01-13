// File: pf.c
//
// Description: pf handler.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "pf.h"

__attribute__((naked)) void pf_handler()
{
    __asm__(".intel_syntax;"
            "cli;"
            "mov dx, 03f8h;"
            "mov al, 023h;"
            "out dx, al;"
            "mov al, 'P';"
            "out dx, al;"
            "mov al, 'F';"
            "out dx, al;"
            "mov al, 0Ah;"
            "out dx, al;"
            "1:"
            "hlt;"
            "jmp 1b;");
}