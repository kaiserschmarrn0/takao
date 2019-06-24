.intel_syntax noprefix

.globl start
start:
.halt:
    hlt
    jmp .halt
