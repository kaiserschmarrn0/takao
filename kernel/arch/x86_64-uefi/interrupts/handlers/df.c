// File: df.c
//
// Description: df handler.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "df.h"

__attribute__((naked)) void df_handler()
{
    __asm__(".intel_syntax;"
            "mov dx, 03f8h;"
            "mov al, 023h;"
            "out dx, al;"
            "mov al, 'D';"
            "out dx, al;"
            "mov al, 'F';"
            "out dx, al;"
            "mov al, 0Ah;"
            "out dx, al;"
            "1:"
            "hlt;"
            "jmp 1b;");
}