section .data

%define flushIRQsSize       flushIRQsEnd - flushIRQsBin
flushIRQsBin:               incbin "source/kernel/real/flushirqs.bin"
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
