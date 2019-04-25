; setlongmode.asm - Set long mode mode
; (C) 2019 the takao authors (AUTHORS.md). All rights reserved
; This code is governed by a license that can be found in LICENSE.md

[bits 32]

section .text
global setLongMode:function (setLongMode.end - setLongMode)

setLongMode:
    ; Set the long mode bit in the EFER MSR.
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    ; And now we are in 32 bit compatibility mode
    ret
.end:
