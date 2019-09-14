module util.term;

public import core.stdc.stdarg;

import lib;

private shared SpinLock charLock   = unlocked;
private shared SpinLock stringLock = unlocked;
private shared SpinLock vprintLock = unlocked;
private shared SpinLock printLock  = unlocked;

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
    print(cast(immutable)&buf[i]);
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
    print(cast(immutable)&buf[i]);
}

void print(char c) {
    import io.qemu: qemuPutChar;

    acquireSpinlock(&charLock);

    debug {
        qemuPutChar(c);
    }

    releaseSpinlock(&charLock);
}

void print(cstring message) {
    acquireSpinlock(&stringLock);

    for (auto i = 0; message[i]; i++) {
        print(message[i]);
    }

    releaseSpinlock(&stringLock);
}

extern(C) void vprint(cstring format, va_list args) {
    acquireSpinlock(&vprintLock);

    for (auto i = 0; format[i]; i++) {
        if (format[i] != '%') {
            print(format[i]);
            continue;
        }

        if (format[++i]) {
            switch (format[i]) {
                case 's':
                    cstring str;
                    va_arg(args, str);
                    print(str);
                    break;
                case 'x':
                    ulong h;
                    va_arg(args, h);
                    printHex(h);
                    break;
                case 'u':
                    ulong u;
                    va_arg(args, u);
                    printInteger(u);
                    break;
                default:
                    print('%');
                    print(format[i]);
            }
        } else print('%');
    }

    releaseSpinlock(&vprintLock);
}

extern(C) void print(cstring message, ...) {
    acquireSpinlock(&printLock);

    va_list args;
    va_start(args, message);

    vprint(message, args);

    releaseSpinlock(&printLock);
}
