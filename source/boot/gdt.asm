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
    dw GDTPointer.end   - GDTPointer.start - 1  ; GDT size
    dd GDTPointer.start - kernelPhysicalOffset  ; GDT start

align 16

GDTPointer:
    dw .start - .start - 1  ; GDT size
    dq .start               ; GDT start

align 16

.start:
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
.end:

section .text
global loadTSS:function (loadTSS.end - loadTSS)

loadTSS:
    ; addr in RDI
    push rbx
    mov eax, edi
    mov rbx, GDTPointer.TSSLow
    mov word [rbx], ax
    mov eax, edi
    and eax, 0xFF0000
    shr eax, 16
    mov rbx, GDTPointer.TSSMid
    mov byte [rbx], al
    mov eax, edi
    and eax, 0xFF000000
    shr eax, 24
    mov rbx, GDTPointer.TSSHigh
    mov byte [rbx], al
    mov rax, rdi
    shr rax, 32
    mov rbx, GDTPointer.TSSUpper32
    mov dword [rbx], eax
    mov rbx, GDTPointer.TSSFlags1
    mov byte [rbx], 10001001b
    mov rbx, GDTPointer.TSSFlags2
    mov byte [rbx], 0
    pop rbx
    ret
.end:
