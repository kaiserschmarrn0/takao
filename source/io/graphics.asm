; graphics.asm - Graphics real mode callers
; (C) 2019 the takao authors (AUTHORS.md). All rights reserved
; This code is governed by a license that can be found in LICENSE.md

[bits 64]

extern realRoutine

global getVBEInfo
global getEDIDInfo
global getVBEModeInfo
global setVBEMode
global dumpVGAFont

%define kernelPhysicalOffset 0xFFFFFFFFC0000000

section .data

%define getVBEInfo_size        getVBEInfo_end - getVBEInfo_bin
getVBEInfo_bin:                incbin "source/io/getvbeinfo.bin"
getVBEInfo_end:

%define getEDIDInfo_size       getEDIDInfo_end - getEDIDInfo_bin
getEDIDInfo_bin:               incbin "source/io/edidinfo.bin"
getEDIDInfo_end:

%define getVBEModeInfo_size    getVBEModeInfo_end - getVBEModeInfo_bin
getVBEModeInfo_bin:            incbin "source/io/vbemodeinfo.bin"
getVBEModeInfo_end:

%define setVBEMode_size        setVBEMode_end - setVBEMode_bin
setVBEMode_bin:                incbin "source/io/setvbemode.bin"
setVBEMode_end:

%define dumpVGAFont_size       dumpVGAFont_end - dumpVGAFont_bin
dumpVGAFont_bin:               incbin "source/io/vgafont.bin"
dumpVGAFont_end:

section .text

getVBEInfo:
    ; void getVBEInfo(vbe_info_struct_t* vbe_info_struct);
    push rbx
    push rbp
    push r12
    push r13
    push r14
    push r15

    mov rbx, rdi
    sub rbx, kernelPhysicalOffset
    mov rsi, getVBEInfo_bin
    mov rcx, getVBEInfo_size
    call realRoutine

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    pop rbx
    ret

getEDIDInfo:
    ; void getEDIDInfo(edid_info_struct_t* edid_info_struct);
    push rbx
    push rbp
    push r12
    push r13
    push r14
    push r15

    mov rbx, rdi
    sub rbx, kernelPhysicalOffset
    mov rsi, getEDIDInfo_bin
    mov rcx, getEDIDInfo_size
    call realRoutine

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    pop rbx
    ret

getVBEModeInfo:
    ; void getVBEModeInfo(get_vbe_t* get_vbe);
    push rbx
    push rbp
    push r12
    push r13
    push r14
    push r15

    mov rbx, rdi
    sub rbx, kernelPhysicalOffset
    mov rsi, getVBEModeInfo_bin
    mov rcx, getVBEModeInfo_size
    call realRoutine

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    pop rbx
    ret

setVBEMode:
    ; void setVBEMode(uint16_t mode);
    push rbx
    push rbp
    push r12
    push r13
    push r14
    push r15

    mov rbx, rdi
    mov rsi, setVBEMode_bin
    mov rcx, setVBEMode_size
    call realRoutine

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    pop rbx
    ret

dumpVGAFont:
    ; void dumpVGAFont(uint8_t *bitmap);
    push rbx
    push rbp
    push r12
    push r13
    push r14
    push r15

    mov rbx, rdi
    sub rbx, kernelPhysicalOffset
    mov rsi, dumpVGAFont_bin
    mov rcx, dumpVGAFont_size
    call realRoutine

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    pop rbx
    ret
