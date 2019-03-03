; gdt.asm - GDT declaration and enabling
; (C) 2019 the takao authors (AUTHORS.md). All rights reserved
; This code is governed by a license that can be found in LICENSE.md

%include "source/boot/constants.asm"

[bits 64]

global GDTPointer
global GDTPointerLowerHalf

; This one will be the GDT we will load
section .data
align 16

GDTPointerLowerHalf:
    dw GDTPointer.GDTEnd   - GDTPointer.GDTStart - 1  ; GDT size
    dd GDTPointer.GDTStart - kernelPhysicalOffset     ; GDT start

align 16

GDTPointer:
    dw .GDTEnd - .GDTStart - 1  ; GDT size
    dq .GDTStart                ; GDT start

align 16

.GDTStart:
.nullDescriptor:
    dw 0x0000           ; Limit
    dw 0x0000           ; Base (low 16 bits)
    db 0x00             ; Base (mid 8 bits)
    db 00000000b        ; Access
    db 00000000b        ; Granularity
    db 0x00             ; Base (high 8 bits)

; 64 bit mode kernel
.kernelCode64:
    dw 0x0000           ; Limit
    dw 0x0000           ; Base (low 16 bits)
    db 0x00             ; Base (mid 8 bits)
    db 10011010b        ; Access
    db 00100000b        ; Granularity
    db 0x00             ; Base (high 8 bits)

.kernelData:
    dw 0x0000           ; Limit
    dw 0x0000           ; Base (low 16 bits)
    db 0x00             ; Base (mid 8 bits)
    db 10010010b        ; Access
    db 00000000b        ; Granularity
    db 0x00             ; Base (high 8 bits)

; 64 bit mode user code
.userData64:
    dw 0x0000           ; Limit
    dw 0x0000           ; Base (low 16 bits)
    db 0x00             ; Base (mid 8 bits)
    db 11110010b        ; Access
    db 00000000b        ; Granularity
    db 0x00             ; Base (high 8 bits)

.userCode64:
    dw 0x0000           ; Limit
    dw 0x0000           ; Base (low 16 bits)
    db 0x00             ; Base (mid 8 bits)
    db 11111010b        ; Access
    db 00100000b        ; Granularity
    db 0x00             ; Base (high 8 bits)

; Unreal mode
.unrealCode:
    dw 0xFFFF           ; Limit
    dw 0x0000           ; Base (low 16 bits)
    db 0x00             ; Base (mid 8 bits)
    db 10011010b        ; Access
    db 10001111b        ; Granularity
    db 0x00             ; Base (high 8 bits)

.unrealData:
    dw 0xFFFF           ; Limit
    dw 0x0000           ; Base (low 16 bits)
    db 0x00             ; Base (mid 8 bits)
    db 10010010b        ; Access
    db 10001111b        ; Granularity
    db 0x00             ; Base (high 8 bits)

.TSS:
    dw 104 ; TSS length
  .TSSLow:
    dw 0
  .TSSMid:
    db 0
  .TSSFlags1:
    db 10001001b
  .TSSFlags2:
    db 00000000b
  .TSSHigh:
    db 0
  .TSSUpper32:
    dd 0
  .TSSReserved:
    dd 0
.GDTEnd: