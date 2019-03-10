; multiboot.asm - Multiboot header
; (C) 2019 the takao authors (AUTHORS.md). All rights reserved
; This code is governed by a license that can be found in LICENSE.md

[bits 32]

; Declare constants for the multiboot header.
flags    equ  0                 ; This is the Multiboot 'flag' field
magic    equ  0x1BADB002        ; 'magic number' lets bootloader find the header
checksum equ -(flags + magic)   ; Checksum of above, to prove we are multiboot

section .multiboot
align 4
    dd magic
    dd flags
    dd checksum
