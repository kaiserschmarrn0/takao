// ports.d - IO ports
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module io.ports;

ubyte inb(ushort port) {
    ubyte value;

    asm {
        mov DX, port;
        in  AL, DX;
        mov value, AL;
    }

    return value;
}

void outb(ushort port, ubyte value) {
    asm {
        mov DX, port;
        mov AL, value;
        out DX, AL;
    }
}

void wait() {
    outb(0x80, 0x00);
}