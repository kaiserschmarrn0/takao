; check.asm - Long mode and etc checking
; (C) 2019 the takao authors (AUTHORS.md). All rights reserved
; This code is governed by a license that can be found in LICENSE.md

%include "source/boot/constants.asm"

[bits 32]

section .text
global checkCPUID:function (checkCPUID.end - checkCPUID)

checkCPUID:
    extern earlyError;

    ; We will check if CPUID is supported by attempting to flip the ID
    ; bit (bit 21) in the FLAGS register.
    ; If we can flip it, CPUID is available.

    pushfd
    pop eax

    mov ecx, eax

    ; Flip the ID bit
    xor eax, 1 << 21

    push eax
    popfd

    pushfd
    pop eax

    push ecx
    popfd

    xor eax, ecx
    jz .noCPUID
    ret

.noCPUID:
    mov esi, .errorMessage - kernelPhysicalOffset
    call earlyError

.errorMessage db "CPUID not supported, kernel halted", 0
.end:

global checkLongMode:function (checkLongMode.end - checkLongMode)

checkLongMode:
    extern earlyError;

    ; We know CPUID is supported, now we have to check if the so called
    ; 'extended functions' are supported, so we can enable long mode
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb .noLongMode

    ; Now that we know that extended functions are available we can use it
    ; to detect long mode
    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29

    jz .noLongMode
    ret

.noLongMode:
    mov esi, .errorMessage - kernelPhysicalOffset
    call earlyError

.errorMessage db "Long mode not supported, kernel halted", 0
.end:
