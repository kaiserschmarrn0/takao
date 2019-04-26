// smp.d - SMP support
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module system.smp;

import memory.constants;

immutable uint maxCores      = 128;
immutable uint coreStackSize = 16384; // 16 KiB

struct Core {
    // DO NOT MOVE THESE MEMBERS FROM THESE LOCATIONS
    // DO NOT CHANGE THEIR TYPES
    size_t coreNumber;
    size_t kernelStack;
    size_t threadKernelStack;
    size_t threadUserStack;
    size_t threadErrmp;
    size_t ipiAbortReceived;

    // Feel free to move every other member, and use any type as you see fit
    ubyte lapicID;
    int ipi_abortexec_received;
    int ipi_resched_received;
}

struct TSS {
    align(1):

    align(16) uint unused0;

    ulong rsp0;
    ulong rsp1;
    ulong rsp2;
    ulong unused1;
    ulong ist1;
    ulong ist2;
    ulong ist3;
    ulong ist4;
    ulong ist5;
    ulong ist6;
    ulong ist7;
    ulong unused2;
    uint  iopbOffset;
}

struct CoreStack {
    align(pageSize) ubyte[pageSize]      guardPage;
    align(pageSize) ubyte[coreStackSize] stack;
}

private extern(C) void smpInitCore0(void*, void*);
private extern(C) void* smpPrepareTrampoline(void*, void*, void*, void*, void*);
private extern(C) int smpCheckCoreFlag();

__gshared                 Core[maxCores]      cores;
__gshared align(16)       TSS[maxCores]       coreTSSs;
__gshared align(pageSize) CoreStack[maxCores] coreStacks;

private __gshared uint coreCount = 1; // We must have booted in something

void initSMP() {
    import util.term;
    import system.pit;
    import system.acpi.madt;

    info("Starting up SMP");

    debug {
        print("\tSetting up core #0...\n");
    }

    initCore0();

    for (uint i = 1; i < madtLocalAPICCount; i++) {
        debug {
            print("\tFound core #%u: Starting...\n", i);
        }

        if (startCore(madtLocalAPICs[i].apicID, coreCount)) {
            error("Failed to start core #%u", i);
            continue;
        }

        coreCount++;

        // Wait a bit
        sleep(10);
    }
}

private void initCore0() {
    setupCoreLocal(0, 0);

    auto core = &cores[0];
    auto tss  = &coreTSSs[0];

    smpInitCore0(core, tss);
}

private void setupCoreLocal(int coreNumber, ubyte lapicID) {
    import memory.virtual;

    // Set up stack guard page
    unmapPage(pageMap, cast(size_t)&coreStacks[coreNumber].guardPage[0]);

    // Prepare CPU local
    cores[coreNumber].coreNumber  = coreNumber;
    cores[coreNumber].kernelStack = cast(size_t)&coreStacks[coreNumber].stack[coreStackSize - 1];
    cores[coreNumber].lapicID     = lapicID;

    // Prepare TSS
    coreTSSs[coreNumber].rsp0 = cast(ulong)&coreStacks[coreNumber].stack[coreStackSize - 1];
    coreTSSs[coreNumber].ist1 = cast(ulong)&coreStacks[coreNumber].stack[coreStackSize - 1];
}

private bool startCore(ubyte lapicID, uint coreNumber) {
    import util.term;
    import system.pit;
    import system.acpi.madt;
    import memory.virtual;
    import system.interrupts.apic;

    if (coreNumber >= maxCores) {
        warning("Core limit exceeded, wont enable #%u", coreNumber);
        return true;
    }

    setupCoreLocal(coreNumber, lapicID);

    auto core  = &cores[coreNumber];
    auto tss   = &coreTSSs[coreNumber];
    auto stack = &coreStacks[coreNumber].stack[coreStackSize - 1];

    void* trampoline = smpPrepareTrampoline(&coreKernelEntry, cast(void*)pageMap,
                                            stack, core, tss);

    // Send the INIT IPI
    writeLocalAPIC(apicICR1, (cast(uint)lapicID) << 24);
    writeLocalAPIC(apicICR0, 0x500);
    // wait 10ms
    sleep(10);

    // Send the Startup IPI
    writeLocalAPIC(apicICR1, (cast(uint)lapicID) << 24);
    writeLocalAPIC(apicICR0, 0x600 | cast(uint)trampoline);
    // wait 1ms
    sleep(1);

    if (smpCheckCoreFlag()) {
        return false;
    } else {
        // Send the Startup IPI again
        writeLocalAPIC(apicICR1, lapicID << 24);
        writeLocalAPIC(apicICR0, 0x600 | cast(uint)trampoline);
        // wait 1s
        sleep(1000);

        if (smpCheckCoreFlag()) {
            return false;
        } else return true;
    }

    return false;
}

private void coreKernelEntry() {
    import util.term;
    import system.interrupts.apic;

    // Cores jump here after initialisation

    debug {
        print("\tStarted up core #%u\n", coreCount - 1);
    }

    // Enable this core's local APIC
    enableLocalAPIC();

    // Enable interrupts
    asm {
        sti;
    }

    // Wait for some job to be scheduled
    for (;;) {
        asm {
            hlt;
        }
    }
}
