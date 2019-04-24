; flushirqs.asm - Wrapper for the real mode code
; (C) 2019 the takao authors (AUTHORS.md). All rights reserved
; This code is governed by a license that can be found in LICENSE.md

section .data

%define flushIRQsSize       flushIRQsEnd - flushIRQsBin
flushIRQsBin:               incbin "source/real/flushirqs.bin"
flushIRQsEnd:

[bits 64]

section .text
global flushIRQs:function (flushIRQs.end - flushIRQs)

; void flushIRQs()
flushIRQs:
    extern realRoutine

    push rbx
    push rbp
    push r12
    push r13
    push r14
    push r15

    mov rsi, flushIRQsBin
    mov rcx, flushIRQsSize
    call realRoutine

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    pop rbx
    ret
.end:
