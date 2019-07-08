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
