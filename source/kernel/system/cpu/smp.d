/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

module system.cpu.smp;

import memory;
import system.cpu;
import system.pit;

immutable uint apicICR0 = 0x300;
immutable uint apicICR1 = 0x310;

__gshared ubyte availableCores = 1; /// The number of cores ready in the system

private extern(C) void loadTSS(CoreTSS*);
private extern(C) void* prepareTrampoline(void*, void*, void*, void*, void*);

/**
 * Initialise SMP by first configuring core #0 and then starting cores following
 * the `MADT` (ACPI)
 *
 * Once a new core is spawned, it will be put on halt
 * by `startCore` -> `coreKernelEntry` until an interrupt is received
 */
void initSMP() {
    import util.term;
    import system.acpi.madt;

    debug {
        print("\t\tConfiguring core #0\n");
    }

    initCore0();

    foreach (i; 1..madtLAPICCount) {
        debug {
            print("\t\tStarting up core #%u\n", i);
        }

        if (startCore(madtLAPICs[i].apicID, availableCores)) {
            warning("Failed to start core #%u", i);
            continue;
        }

        availableCores++;

        // wait a bit
        sleep(10);
    }
}

private void initCore0() {
    setupCore(0, 0);

    auto core = &cores[0];
    auto tss  = &coreTSSs[0];

    ushort tssLoad = 0x38;

    asm {
        // Load GS with the CPU local struct base address
        mov RDI, core;
        mov RSI, tss;

        mov AX, 0x1B;
        mov FS, AX;
        mov GS, AX;
        mov RCX, 0xC0000101;
        mov EAX, EDI;
        shr RDI, 32;
        mov EDX, EDI;
        wrmsr;

        // Enable SSE
        mov RAX, CR0;
        and AL, 0xFB;
        or AL, 0x02;
        mov CR0, RAX;
        mov RAX, CR4;
        or AX, 3 << 9;
        mov CR4, RAX;

        // Set up the PAT properly
        mov RCX, 0x277;
        rdmsr;
        mov EDX, 0x0105; // Write-protect and write-combining
        wrmsr;

        mov RDI, RSI;
        call loadTSS;

        ltr tssLoad;
    }
}

private void setupCore(ubyte coreNumber, ubyte lapic) {
    import memory.virtual;

    // Set up stack guard page
    unmapPage(pageMap, cast(size_t)&coreStacks[coreNumber].guardPage[0]);

    // Prepare CPU local
    cores[coreNumber].coreNumber  = coreNumber;
    cores[coreNumber].kernelStack = cast(size_t)&coreStacks[coreNumber].stack[coreStackSize - 1];
    cores[coreNumber].lapic       = lapic;

    // Prepare TSS
    coreTSSs[coreNumber].rsp0 = cast(ulong)&coreStacks[coreNumber].stack[coreStackSize - 1];
    coreTSSs[coreNumber].ist1 = cast(ulong)&coreStacks[coreNumber].stack[coreStackSize - 1];
}

private bool startCore(ubyte targetAPIC, ubyte coreNumber) {
    import util.term;
    import memory.virtual;
    import system.interrupts.apic;

    if (coreNumber >= maxCores) {
        warning("Core limit of %u exceeded", maxCores);
        return true;
    }

    setupCore(coreNumber, targetAPIC);

    auto core  = &cores[coreNumber];
    auto tss   = &coreTSSs[coreNumber];
    auto stack = &coreStacks[coreNumber].stack[coreStackSize - 1];

    void* trampoline = prepareTrampoline(&coreKernelEntry, cast(void*)pageMap,
                                         stack, core, tss);

    // Send the INIT IPI
    writeLAPIC(apicICR1, cast(uint)targetAPIC << 24);
    writeLAPIC(apicICR0, 0x500);
    sleep(10);

    // Send the Startup IPI
    writeLAPIC(apicICR1, (cast(uint)targetAPIC) << 24);
    writeLAPIC(apicICR0, 0x600 | cast(uint)cast(size_t)trampoline);
    sleep(1);

    if (checkCoreFlag()) {
        return false;
    } else {
        // Send the Startup IPI again
        writeLAPIC(apicICR1, (cast(uint)targetAPIC) << 24);
        writeLAPIC(apicICR0, 0x600 | cast(uint)cast(size_t)trampoline);
        sleep(1000);

        return !checkCoreFlag();
    }
}

private void coreKernelEntry() {
    import util.term;
    import system.interrupts.apic;

    // Cores jump here after initialisation
    debug {
        print("\t\tStarted up core #%u successfully\n", currentCore());
    }

    // Enable this core's LAPIC
    enableLAPIC();

    // Enable interrupts and wait for some job to be scheduled
    asm {
        sti;

    loopF:;
        hlt;
        jmp loopF;
    }
}

private int checkCoreFlag() {
    asm {
        naked;

        xor EAX, EAX;
        mov AL, byte ptr [0x510];
        ret;
    }
}
