// smp.d - SMP support
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module system.smp;

import memory.constants;

immutable uint maxCores      = 128;
immutable uint coreStackSize = 0xF4240; // 1 MiB in bytes

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

private __gshared                 Core[maxCores]      cores;
private __gshared align(16)       TSS[maxCores]       coreTSSs;
private __gshared align(pageSize) CoreStack[maxCores] coreStacks;

private uint coreCount = 1; // We must have booted in something

void initSMP() {
    import util.term;
    import system.acpi.madt;

    info("Starting up SMP");

    debug {
        print("\tSetting up core #0...\n");
    }

    initCore0();

    for (auto i = 1; i < madtLocalAPICCount; i++) {
        print("\tFound core #%u: Starting...", i);

        if (startCore(madtLocalAPICs[i].apicID, coreCount)) {
            error("\tFailed to start core #%u", i);
            continue;
        }

        coreCount++;

        // Wait a bit
        // ksleep(10);
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
    cores[coreNumber].kernelStack = cast(size_t)&coreStacks[coreNumber].stack[coreStackSize];
    cores[coreNumber].lapicID     = lapicID;

    // Prepare TSS
    coreTSSs[coreNumber].rsp0 = cast(ulong)&coreStacks[coreNumber].stack[coreStackSize];
    coreTSSs[coreNumber].ist1 = cast(ulong)&coreStacks[coreNumber].stack[coreStackSize];
}

private bool startCore(ubyte targetAPICID, int coreNumber) {
  /*  if (coreNumber == maxCores) {
        warning("Core limit exceeded, wont enable #%u", coreNumber);
        return false;
    }

    setupCoreLocal(coreNumber, targetAPICID);

    struct cpu_local_t *cpu_local = &cpu_locals[cpu_number];
    struct tss_t *tss = &cpu_tss[cpu_number];
    uint8_t *stack = &cpu_stacks[cpu_number].stack[CPU_STACK_SIZE];

    auto core  = &cores[0];
    auto tss   = &coreTSSs[0];
    auto stack =

    void *trampoline = smp_prepare_trampoline(ap_kernel_entry, (void *)kernel_pagemap->pml4,
                                              stack, cpu_local, tss);

    // Send the INIT IPI
    lapic_write(APICREG_ICR1, ((uint32_t)target_apic_id) << 24);
    lapic_write(APICREG_ICR0, 0x500);
    // wait 10ms
    ksleep(10);
    // Send the Startup IPI
    lapic_write(APICREG_ICR1, ((uint32_t)target_apic_id) << 24);
    lapic_write(APICREG_ICR0, 0x600 | (uint32_t)(size_t)trampoline);
    // wait 1ms
    ksleep(1);

    if (smp_check_ap_flag()) {
        return 0;
    } else {
        // Send the Startup IPI again
        lapic_write(APICREG_ICR1, ((uint32_t)target_apic_id) << 24);
        lapic_write(APICREG_ICR0, 0x600 | (uint32_t)(size_t)trampoline);
        // wait 1s
        ksleep(1000);
        if (smp_check_ap_flag())
            return 0;
        else
            return -1;
    }*/
    return false;
}
