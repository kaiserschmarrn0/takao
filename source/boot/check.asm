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

    ; Copy FLAGS in to EAX via stack
    pushfd
    pop eax
 
    ; Copy to ECX as well for comparing later on
    mov ecx, eax
 
    ; Flip the ID bit
    xor eax, 1 << 21
 
    ; Copy EAX to FLAGS via the stack
    push eax
    popfd
 
    ; Copy FLAGS back to EAX (with the flipped bit if CPUID is supported)
    pushfd
    pop eax
 
    ; Restore FLAGS from the old version stored in ECX (i.e. flipping the ID bit
    ; back if it was ever flipped).
    push ecx
    popfd
 
    ; Compare EAX and ECX. If they are equal then that means the bit wasn't
    ; flipped, and CPUID isn't supported, in that case we just panic
    xor eax, ecx
    jz .noCPUID
    ret

.noCPUID:
    mov esi, .CPUIDErrorMessage - kernelPhysicalOffset
    call earlyError

.CPUIDErrorMessage db "CPUID not supported, kernel halted", 0
.end:

global checkLongMode:function (checkLongMode.end - checkLongMode)

checkLongMode:
    extern earlyError;

    ; We know CPUID is supported, now we have to check if the so called
    ; 'extended functions' are supported, so we can enable long mode
    mov eax, 0x80000000          ; Set the A-register to 0x80000000.
    cpuid                        ; CPU identification.
    cmp eax, 0x80000001          ; Compare the A-register with 0x80000001.
    jb .noLongMode               ; It is less, there is no long mode.

    ; Now that we know that extended functions are available we can use it
    ; to detect long mode
    mov eax, 0x80000001          ; Set the A-register to 0x80000001.
    cpuid                        ; CPU identification.
    test edx, 1 << 29            ; Test if the LM-bit, which is bit 29, is set 
                                 ; in the D-register.
    jz .noLongMode               ; They aren't, there is no long mode.
    ret

.noLongMode:
    mov esi, .LongModeErrorMessage - kernelPhysicalOffset
    call earlyError

.LongModeErrorMessage db "Long mode not supported, kernel halted", 0
.end:
