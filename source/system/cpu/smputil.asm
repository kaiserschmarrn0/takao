; smputil.asm - SMP functions
; (C) 2019 the takao authors (AUTHORS.md). All rights reserved
; This code is governed by a license that can be found in LICENSE.md

[bits 64]

%define trampolineAddress  0x1000
%define pageSize           4096

section .data

%define smpTrampoline_size  smpTrampoline_end - smpTrampoline
smpTrampoline:              incbin "source/real/smptrampoline.bin"
smpTrampoline_end:

section .text
global smpPrepareTrampoline:function (smpPrepareTrampoline.end - smpPrepareTrampoline)

; Store trampoline data in low memory and return the page index of the
; trampoline code.
smpPrepareTrampoline:
    extern loadTSS
    ; entry point in rdi, page table in rsi
    ; stack pointer in rdx, cpu local in rcx
    ; tss in r8

    ; prepare variables
    mov byte [0x510], 0
    mov qword [0x520], rdi
    mov qword [0x540], rsi
    mov qword [0x550], rdx
    mov qword [0x560], rcx
    sgdt [0x580]
    sidt [0x590]

    ; Copy trampoline blob to 0x1000
    mov rsi, smpTrampoline
    mov rdi, trampolineAddress
    mov rcx, smpTrampoline_size
    rep movsb

    mov rdi, r8
    call loadTSS

    mov rax, trampolineAddress / pageSize
    ret
.end:

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

global smpCheckCoreFlag:function (smpCheckCoreFlag.end - smpCheckCoreFlag)

smpCheckCoreFlag:
    xor rax, rax
    mov al, byte [0x510]
    ret
.end:
