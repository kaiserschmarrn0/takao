; getE820.asm - Real mode E820 caller
; (C) 2019 the takao authors (AUTHORS.md). All rights reserved
; This code is governed by a license that can be found in LICENSE.md

%include "source/boot/constants.asm"

[bits 64]

section .data

%define e820Size          e820End - e820Bin
e820Bin:                  incbin "source/kernel/real/e820.bin"
e820End:

section .text

; void get_e820(e820_entry_t *e820_map);
global get_e820:function (get_e820.end - get_e820)

get_e820:
    extern realRoutine

    push rbx
    push rbp
    push r12
    push r13
    push r14
    push r15

    mov rbx, rdi
    sub rbx, kernelPhysicalOffset
    mov rsi, e820Bin
    mov rcx, e820Size
    call realRoutine

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    pop rbx
    ret
.end:
