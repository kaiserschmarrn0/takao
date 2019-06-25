.intel_syntax noprefix

.globl start
start:
    call main # Main kernel function

0:  # Loop forever
    hlt
    jmp 0b
