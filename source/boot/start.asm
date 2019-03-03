; start.asm - Kernel's bootstrap
; (C) 2019 the takao authors (AUTHORS.md). All rights reserved
; This code is governed by a license that can be found in LICENSE.md

%include "source/boot/constants.asm"

[bits 32]

section .text
global start:function (start.end - start)

start:
    extern checkCPUID          ; Check if we can CPUID and enter long mode
    extern checkLongMode
    extern setLongMode         ; Entering 32-bit compatibility mode
    extern enablePaging        ; Enable paging
    extern GDTPointer          ; GDT
    extern GDTPointerLowerHalf
    extern main                ; The main kernel function

    ; Setup the stack
    mov esp, 0xEFFFF0

    ; Lets see if we can CPUID and long mode, if not it will just halt
    call checkCPUID    
    call checkLongMode

    ; Enter long mode, 32-bit compatibility mode
    call setLongMode
    
    ; Lets enable paging
    call enablePaging

    ; Now that we're almost in long mode, there's one issue left: we are in the 
    ; 32-bit compatibility submode, and we actually wanted to enter 64-bit
    ; long mode.
    ; We should just load a GDT with the 64-bit flags set in the code and data
    ; selectors to accomplish this.
    lgdt [GDTPointerLowerHalf - kernelPhysicalOffset]
    jmp 0x08:.longMode - kernelPhysicalOffset

.longMode:
    [bits 64]
    mov ax, 0x10
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Jump to the higher half
    mov rax, .higherHalf
    jmp rax

.higherHalf:
    mov rsp, kernelPhysicalOffset + 0xEFFFF0

    lgdt [GDTPointer]

    ; The kernel wont return
    call main
.end:
