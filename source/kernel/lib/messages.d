module lib.messages;

public import core.stdc.stdarg;

import lib.string;
import lib.spinlock;

private immutable(char[]) conversionTable = "0123456789ABCDEF";

private shared SpinLock charLock   = unlocked;
private shared SpinLock stringLock = unlocked;
private shared SpinLock vprintLock = unlocked;
private shared SpinLock printLock  = unlocked;

private shared SpinLock logLock     = unlocked;
private shared SpinLock infoLock    = unlocked;
private shared SpinLock warningLock = unlocked;
private shared SpinLock panicLock   = unlocked;

private void putc(char c) {
    import io.qemu: qemuPutChar;

    acquireSpinlock(&charLock);

    debug {
        qemuPutChar(c);
    }

    releaseSpinlock(&charLock);
}

private void puts(cstring message) {
    acquireSpinlock(&stringLock);

    for (auto i = 0; message[i]; i++) {
        putc(message[i]);
    }

    releaseSpinlock(&stringLock);
}

private void printInteger(ulong x) {
    int i;
    char[21] buf;

    buf[20] = 0;

    if (!x) {
        putc('0');
        return;
    }

    for (i = 19; x; i--) {
        buf[i] = conversionTable[x % 10];
        x /= 10;
    }

    i++;
    puts(cast(immutable)&buf[i]);
}

private void printHex(ulong x) {
    int i;
    char[17] buf;

    buf[16] = 0;

    if (!x) {
        puts("0x0");
        return;
    }

    for (i = 15; x; i--) {
        buf[i] = conversionTable[x % 16];
        x /= 16;
    }

    i++;
    puts("0x");
    puts(cast(immutable)&buf[i]);
}

private extern(C) void vprintf(cstring format, va_list args) {
    acquireSpinlock(&vprintLock);

    for (auto i = 0; format[i]; i++) {
        if (format[i] != '%') {
            putc(format[i]);
            continue;
        }

        if (format[++i]) {
            switch (format[i]) {
                case 's':
                    cstring str;
                    va_arg(args, str);
                    puts(str);
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
                    putc('%');
                    putc(format[i]);
            }
        } else putc('%');
    }

    releaseSpinlock(&vprintLock);
}

private extern(C) void printf(cstring message, ...) {
    acquireSpinlock(&printLock);

    va_list args;
    va_start(args, message);

    vprintf(message, args);

    releaseSpinlock(&printLock);
}

/**
 * Log misc info in the terminal
 *
 * Params:
 *     message = String to format and print
 *     ...     = Extra arguments
 */
extern(C) void log(cstring message, ...) {
    import system.pit;

    acquireSpinlock(&logLock);

    va_list args;
    va_start(args, message);

    printf("[%u] \t", uptime);
    vprintf(message, args);
    putc('\n');

    releaseSpinlock(&logLock);
}

/**
 * Print Information about the runtime in the terminal
 *
 * Params:
 *     message = String to format and print
 *     ...     = Extra arguments
 */
extern(C) void info(cstring message, ...) {
    import system.pit;

    acquireSpinlock(&infoLock);

    va_list args;
    va_start(args, message);

    printf("[%u] \x1b[36m::\x1b[0m ", uptime);
    vprintf(message, args);
    putc('\n');

    releaseSpinlock(&infoLock);
}

/**
 * Print a warning to the terminal
 *
 * Params:
 *     message = String to format and print
 *     ...     = Extra arguments
 */
extern(C) void warning(cstring message, ...) {
    import system.cpu;
    import system.pit;

    acquireSpinlock(&warningLock);

    va_list args;
    va_start(args, message);

    printf("[%u] \x1b[33mA warning was reported (core #%u)\x1b[0m: ", uptime, currentCore());
    vprintf(message, args);
    putc('\n');
    printControlRegisters();

    releaseSpinlock(&warningLock);
}

/**
 * Panics printing a message, will also print registers and HCF
 *
 * Params:
 *     message = String to format and print
 *     ...     = Extra arguments
 */
extern(C) void panic(cstring message, ...) {
    import system.cpu;
    import system.cpu.ipi;
    import system.cpu.smp: availableCores;
    import system.pit;

    acquireSpinlock(&panicLock);

    va_list args;
    va_start(args, message);

    printf("[%u] \x1b[31mA panic occurred (core #%u)\x1b[0m: ", uptime, currentCore());
    vprintf(message, args);
    putc('\n');

    printControlRegisters();

    foreach (i; 0..availableCores) {
        if (i == currentCore()) {
            continue;
        }

        sendCoreIPI(i, ipiAbort);
    }

    log("\x1b[45mThe system will be halted\x1b[0m");

    asm {
        cli;
    L1:;
        hlt;
        jmp L1;
    }
}

private void printControlRegisters() {
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

    log("CR0=%x CR2=%x CR3=%x CR4=%x", cr0, cr2, cr3, cr4);
}
