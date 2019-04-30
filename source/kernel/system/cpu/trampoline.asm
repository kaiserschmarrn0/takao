; trampoline.asm - SMP trampoline
; (C) 2019 the takao authors (AUTHORS.md). All rights reserved
; This code is governed by a license that can be found in LICENSE.md

section .data

%define smptrampolineSize  smptrampoline_end - smptrampoline
smptrampoline:             incbin "source/kernel/real/smptrampoline.bin"
smptrampoline_end:

[bits 64]

section .text

%define trampolineAddress  0x1000
%define pageSize           4096

extern loadTSS

global prepareTrampoline:function (prepareTrampoline.end - prepareTrampoline)

; Store trampoline data in low memory and return the page index of the
; trampoline code.
prepareTrampoline:
    ; entry point in rdi, page table in rsi
    ; stack pointer in rdx, cpu local in rcx
    ; tss in r8

    ; prepare variables
    mov byte [0x510], 0
    mov qword [0x520], rdi
    mov qword [0x540], rsi
    mov qword [0x550], rdx
    mov qword [0x560], rcx
    ; mov qword [0x570], syscallEntry once we have a syscall entry
    sgdt [0x580]
    sidt [0x590]

    ; Copy trampoline blob to 0x1000
    mov rsi, smptrampoline
    mov rdi, trampolineAddress
    mov rcx, smptrampolineSize
    rep movsb

    mov rdi, r8
    call loadTSS

    mov rax, trampolineAddress / pageSize
    ret
.end:
