; smputil.asm - SMP functions
; (C) 2019 the takao authors (AUTHORS.md). All rights reserved
; This code is governed by a license that can be found in LICENSE.md

[bits 64]

section .text
global smpInitCore0:function (smpInitCore0.end - smpInitCore0)

smpInitCore0:
    extern loadTSS

    ; Load GS with the CPU local struct base address
    mov ax, 0x1b
    mov fs, ax
    mov gs, ax
    mov rcx, 0xC0000101
    mov eax, edi
    shr rdi, 32
    mov edx, edi
    wrmsr

    ; enable SSE
    mov rax, cr0
    and al, 0xfb
    or al, 0x02
    mov cr0, rax
    mov rax, cr4
    or ax, 3 << 9
    mov cr4, rax

    ; set up the PAT properly
    mov rcx, 0x277
    rdmsr
    mov edx, 0x0105     ; write-protect and write-combining
    wrmsr

    mov rdi, rsi
    call loadTSS

    mov ax, 0x38
    ltr ax

    ret
.end:
