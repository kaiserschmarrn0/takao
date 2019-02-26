; setlongmode.asm - Set long mode mode
; (C) 2019 the takao authors (AUTHORS.md). All rights reserved
; This code is governed by a license that can be found in LICENSE.md

[bits 32]

section .text
global setLongMode:function (setLongMode.end - setLongMode)

setLongMode:
    ; Set the long mode bit in the EFER MSR.
    mov ecx, 0xC0000080 ; Set eax to 0xC0000080, which is the IA32EFER MSR.
    rdmsr               ; Read from the model-specific register.
    or eax, 1 << 8      ; Set the long mode bit, which is the 9th bit.
    wrmsr               ; Write to the model-specific register.
    ; And now we are in 32 bit compatibility mode
    ret
.end:
