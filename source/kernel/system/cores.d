// cores.d - Core info and setting up
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module system.cores;

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

__gshared                 Core[maxCores]      cores;
__gshared align(16)       TSS[maxCores]       coreTSSs;
__gshared align(pageSize) CoreStack[maxCores] coreStacks;
