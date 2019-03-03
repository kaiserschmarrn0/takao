; real.asm - Real mode switch
; (C) 2019 the takao authors (AUTHORS.md). All rights reserved
; This code is governed by a license that can be found in LICENSE.md

[bits 64]

section .data

%define realInitSize  realInitEnd - realInit
realInit:             incbin "source/real/init.bin"
realInitEnd:

section .text

global realRoutine:function (realRoutine.end - realRoutine)

realRoutine:
    ; RSI = routine location
    ; RCX = routine size
    
    push rsi
    push rcx

    ; Real mode init blob to 0000:1000
    mov rsi, realInit
    mov rdi, 0x1000
    mov rcx, realInitSize
    rep movsb
    
    ; Routine's blob to 0000:8000
    pop rcx
    pop rsi
    mov rdi, 0x8000
    rep movsb
    
    ; Call module
    mov rax, 0x1000
    call rax
    
    ret
.end:
