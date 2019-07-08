align 16

GDTPointer:
    dw .end - .start - 1  ; GDT size
    dq .start             ; GDT start

align 16
.start:

; Null descriptor (required)
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

.userData64:
    dw 0x0000           ; Limit
    dw 0x0000           ; Base (low 16 bits)
    db 0x00             ; Base (mid 8 bits)
    db 11110010b        ; Access
    db 00000000b        ; Granularity
    db 0x00             ; Base (high 8 bits)

.end:
