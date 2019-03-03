; paging.asm - Low level paging enabling and functions
; (C) 2019 the takao authors (AUTHORS.md). All rights reserved
; This code is governed by a license that can be found in LICENSE.md

%include "source/boot/constants.asm"

[bits 32]

section .bss
align 4096

pagemap:
.pml4:
    resb 4096
.pdptLow:
    resb 4096
.pdptHigh:
    resb 4096
.pd:
    resb 4096
.pt:
    resb 4096 * 16 ; 16 page tables == 32 MiB mapped
.end:

section .text
global enablePaging:function (enablePaging.end - enablePaging)

enablePaging:
    ; Zero out page tables
    xor eax, eax
    mov edi, pagemap - kernelPhysicalOffset
    mov ecx, (pagemap.end - pagemap) / 4
    rep stosd

    ; Set up page tables
    mov eax, 0x03
    mov edi, pagemap.pt - kernelPhysicalOffset
    mov ecx, 512 * 16

.loop0:
    stosd
    push eax
    xor eax, eax
    stosd
    pop eax
    add eax, 0x1000
    loop .loop0

    ; set up page directories
    mov eax, pagemap.pt - kernelPhysicalOffset
    or eax, 0x03
    mov edi, pagemap.pd - kernelPhysicalOffset
    mov ecx, 16

.loop1:
    stosd
    push eax
    xor eax, eax
    stosd
    pop eax
    add eax, 0x1000
    loop .loop1

    ; set up pdpt
    mov eax, pagemap.pd - kernelPhysicalOffset
    or eax, 0x03
    mov edi, pagemap.pdptLow - kernelPhysicalOffset
    stosd
    xor eax, eax
    stosd

    mov eax, pagemap.pd - kernelPhysicalOffset
    or eax, 0x03
    mov edi, pagemap.pdptHigh - kernelPhysicalOffset + 511 * 8
    stosd
    xor eax, eax
    stosd

    ; set up pml4
    mov eax, pagemap.pdptLow - kernelPhysicalOffset
    or eax, 0x03
    mov edi, pagemap.pml4 - kernelPhysicalOffset
    stosd
    xor eax, eax
    stosd

    mov eax, pagemap.pdptLow - kernelPhysicalOffset
    or eax, 0x03
    mov edi, pagemap.pml4 - kernelPhysicalOffset + 256 * 8
    stosd
    xor eax, eax
    stosd

    mov eax, pagemap.pdptHigh - kernelPhysicalOffset
    or eax, 0x03
    mov edi, pagemap.pml4 - kernelPhysicalOffset + 511 * 8
    stosd
    xor eax, eax
    stosd

    ; Before enabling paging, we will enable the Physical address extention
    ; (aka PAE)
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    ; And now, with PAE enabled we can finally enable paging in all its glory.
    mov eax, pagemap - kernelPhysicalOffset
    mov cr3, eax
    
    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    ret
.end:
