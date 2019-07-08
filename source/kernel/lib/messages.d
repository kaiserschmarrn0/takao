module lib.messages;

import util.term;
import lib.string;
import lib.spinlock;

private shared SpinLock logLock     = unlocked;
private shared SpinLock infoLock    = unlocked;
private shared SpinLock warningLock = unlocked;
private shared SpinLock panicLock   = unlocked;

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
extern(C) void info(cstring message, ...) {
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
extern(C) void warning(cstring message, ...) {
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
extern(C) void panic(cstring message, ...) {
    import system.cpu;
    import system.cpu.ipi;
    import system.cpu.smp: availableCores;
    import system.pit;

    acquireSpinlock(&panicLock);

    va_list args;
    va_start(args, message);

    print("[%u] \x1b[31mA panic occurred (core #%u)\x1b[0m: ", uptime, currentCore());
    vprint(message, args);
    print('\n');

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
