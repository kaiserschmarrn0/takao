// qemu.d - QEMU output functions
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module io.qemu;

void qemuPutChar(char c) {
    import io.ports: outb;

    outb(0xE9, c);
}
