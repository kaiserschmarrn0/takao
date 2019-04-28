/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

module io.ports;

/**
 * Wrapper for the asm instruction
 *
 * Params:
 *     port = The port which will be readed using `in` in plain asm
 *
 * Returns: The contents of the requested `port`
 */
ubyte inb(ushort port) {
    ubyte value;

    asm {
        mov DX, port;
        in  AL, DX;
        mov value, AL;
    }

    return value;
}

/**
 * Wrapper for the asm instruction
 *
 * Params:
 *     port  = The requested port
 *     value = The information sent to such `port`
 */
void outb(ushort port, ubyte value) {
    asm {
        mov DX, port;
        mov AL, value;
        out DX, AL;
    }
}

/**
 * Implements a little IOPORT delay by sending nothing to `0x80`
 *
 * Useful for devices like the legacy PIC which need a bit of time to answer
 * between `outb` and `outb`
 */
void wait() {
    outb(0x80, 0x00);
}
