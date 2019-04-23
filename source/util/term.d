// messages.d - Output functions
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module util.messages;

public import core.stdc.stdarg;

private const char[] conversionTable = "0123456789ABCDEF";

private void printInteger(ulong x) {
    int i;
    char[21] buf;

    buf[20] = 0;

    if (!x) {
        print('0');
        return;
    }

    for (i = 19; x; i--) {
        buf[i] = conversionTable[x % 10];
        x /= 10;
    }

    i++;
    print(&buf[i]);
}

private void printHex(ulong x) {
    int i;
    char[17] buf;

    buf[16] = 0;

    if (!x) {
        print("0x0");
        return;
    }

    for (i = 15; x; i--) {
        buf[i] = conversionTable[x % 16];
        x /= 16;
    }

    i++;
    print("0x");
    print(&buf[i]);
}

void print(char character) {
    import io.vga:  vgaPutChar;
    import io.qemu: qemuPutChar;

    debug {
        qemuPutChar(character);
    }

    vgaPutChar(character);
}

void print(const char* message) {
    for (auto i = 0; message[i]; i++) {
        print(message[i]);
    }
}

extern(C) void print(const char* format, ...) {
    va_list args;
    va_start(args, format);

    for (auto i = 0; format[i]; i++) {
        if (format[i] != '%') {
            print(format[i]);
            continue;
        }

        if (format[++i]) {
            switch (format[i]) {
                case 's':
                    char* str;
                    va_arg(args, str);
                    print(str);
                    break;
                case 'x':
                    ulong h;
                    va_arg(args, h);
                    printHex(h);
                    break;
                case 'u':
                    ulong h;
                    va_arg(args, h);
                    printInteger(h);
                    break;
                default:
                    print('%');
                    print(format[i]);
            }
        } else print('%');
    }
}

void warning(const char* message) {
    print("\x1b[35mThe kernel reported a warning\x1b[37m: %s\n", message);
    printControlRegisters();
}

void error(const char* message) {
    print("\x1b[33mThe kernel reported an error\x1b[37m: %s\n", message);
    printControlRegisters();
}

void panic(const char* message) {
    print("\x1b[31mThe kernel panicked!\x1b[37m: %s\n", message);
    print("\x1b[45mThe system will be halted\x1b[40m\n");
    printControlRegisters();

    asm {
        cli;
    L1:;
        hlt;
        jmp L1;
    }
}

void printControlRegisters() {
    ulong cr0, cr2, cr3, cr4;

    asm {
        mov RAX, CR0;
        mov cr0, RAX;
        mov RAX, CR2;
        mov cr2, RAX;
        mov RAX, CR3;
        mov cr3, RAX;
        mov RAX, CR4;
        mov cr4, RAX;
    }

    print("CR0=%x, CR2=%x, CR3=%x\n", cr0, cr2, cr3);
    print("CR4=%x\n", cr4);
}
