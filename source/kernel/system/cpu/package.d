// package.d - Core and CPU variables and structures
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module system.cpu;

import memory;

immutable uint maxCores      = 128;
immutable uint coreStackSize = 16384; // 16 KiB

struct Core {
    // DO NOT MOVE THESE MEMBERS FROM THESE LOCATIONS
    // DO NOT CHANGE THEIR TYPES
    size_t coreNumber;
    size_t kernelStack;
    size_t threadKernelStack;
    size_t threadUserStack;
    size_t threadErrno;
    size_t ipiAbortReceived;

    // Feel free to move every other member, and use any type as you see fit
    ubyte lapic;
}

struct CoreTSS {
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

__gshared                 Core[maxCores]      cores;
__gshared align(16)       CoreTSS[maxCores]   coreTSSs;
__gshared align(pageSize) CoreStack[maxCores] coreStacks;

void initCPU() {
    import util.term;
    import system.cpu.smp;

    info("Initialising CPU");

    debug {
        print("\tSetting up SMP\n");
    }

    initSMP();
}

size_t currentCore() {
    size_t number;

    asm {
        mov RAX, qword ptr GS:[0];
        mov number, RAX;
    }

    return number;
}
