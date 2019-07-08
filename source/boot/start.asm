%include "source/boot/constants.asm"

[bits 32]

section .multiboot
align 4
    dd 0x1BADB002   ; Magic number, that makes the bootloader find the header
    dd 0            ; Multiboot 'flag' field
    dd -0x1BADB002  ; Checksum, -(flags + magic)

section .text
global start:function (start.end - start)

start:
    extern checkCPUID
    extern checkLongMode
    extern setLongMode
    extern enablePaging
    extern GDTPointer
    extern GDTPointerLowerHalf
    extern main

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

    call main
.end:
