// qemu.d - QEMU output functions
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module io.qemu;

public import core.stdc.stdarg;

void qemuPrint(char c) {
    import io.ports: outb;

    outb(0xE9, c);
}

void qemuPrint(const char* message) {
    for (auto i = 0; message[i]; i++) {
        qemuPrint(message[i]);
    }
}

extern(C) void qemuPrint(const char* format, ...) {
    import util.convert: toHex, toDecimal;

    va_list args;
    va_start(args, format);

    for (auto i = 0; format[i]; i++) {
        if (format[i] != '%') {
            qemuPrint(format[i]);
            continue;
        }

        if (format[++i]) {
            switch (format[i]) {
                case 's':
                    char* str;
                    va_arg(args, str);
                    qemuPrint(str);
                    break;
                case 'x':
                    ulong h;
                    va_arg(args, h);
                    qemuPrint(toHex(h));
                    break;
                case 'u':
                    ulong u;
                    va_arg(args, u);
                    qemuPrint(toDecimal(u));
                    break;
                default:
                    qemuPrint('%');
                    qemuPrint(format[i]);
            }
        } else qemuPrint('%');
    }
}
