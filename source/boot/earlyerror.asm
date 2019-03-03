; earlyerror.asm - Early error reporting.
; (C) 2019 the takao authors (AUTHORS.md). All rights reserved
; This code is governed by a license that can be found in LICENSE.md

%include "source/boot/constants.asm"

[bits 32]

section .text
global earlyError:function (earlyError.end - earlyError)

; The string comes in esi
earlyError:
    pusha
    mov edi, 0xB8000
.loop:
    lodsb
    test al, al
    jz .out
    stosb
    inc edi
    jmp .loop
.out:
    popa
    cli
.hang:
    hlt
    jmp .hang
    ret
.end:
