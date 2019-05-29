/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

module util.lib.messages;

import util.term;
import util.lib.spinlock;

private __gshared Lock logLock     = newLock;
private __gshared Lock infoLock    = newLock;
private __gshared Lock warningLock = newLock;
private __gshared Lock panicLock   = newLock;

/**
 * Log misc info in the terminal
 *
 * Params:
 *     message = String to format and print
 *     ...     = Extra arguments
 */
extern(C) void log(const(char)* message, ...) {
    import system.pit;

    acquireSpinlock(&logLock);

    va_list args;
    va_start(args, message);

    print("[%u] \t", uptime);
    vprint(message, args);
    print('\n');

    releaseSpinlock(&logLock);
}

/**
 * Print Information about the runtime in the terminal
 *
 * Params:
 *     message = String to format and print
 *     ...     = Extra arguments
 */
extern(C) void info(const(char)* message, ...) {
    import system.pit;

    acquireSpinlock(&infoLock);

    va_list args;
    va_start(args, message);

    print("[%u] \x1b[36m::\x1b[0m ", uptime);
    vprint(message, args);
    print('\n');

    releaseSpinlock(&infoLock);
}

/**
 * Print a warning to the terminal
 *
 * Params:
 *     message = String to format and print
 *     ...     = Extra arguments
 */
extern(C) void warning(const(char)* message, ...) {
    import system.cpu;
    import system.pit;

    acquireSpinlock(&warningLock);

    va_list args;
    va_start(args, message);

    print("[%u] \x1b[33mA warning was reported (core #%u)\x1b[0m: ", uptime, currentCore());
    vprint(message, args);
    print('\n');
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
extern(C) void panic(const(char)* message, ...) {
    import system.cpu;
    import system.cpu.smp: availableCores;
    import system.pit;

    acquireSpinlock(&panicLock);

    va_list args;
    va_start(args, message);

    print("[%u] \x1b[31mA panic occurred (core #%u)\x1b[0m: ", uptime, currentCore());
    vprint(message, args);
    print('\n');
    print("\x1b[45mThe system will be halted\x1b[0m\n");
    printControlRegisters();

    // Send an abort IPI to all other cores
    foreach (i; 0..availableCores) {
        if (i == currentCore()) {
            continue;
        }

        sendCoreIPI(i, 0x40); // 0x40 is ABORT
    }

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

    print("CR0=%x CR2=%x CR3=%x CR4=%x\n", cr0, cr2, cr3, cr4);
}
