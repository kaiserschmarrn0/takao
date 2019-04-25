// main.d - Entrypoint of the kernel
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module main;

extern(C) void main() {
    import io.vbe:            initVBE;
    import system.cpu.smp:    initSMP;
    import system.interrupts: firstStageInterrupts, secondStageInterrupts;
    import system.acpi:       getACPIInfo;
    import memory.e820:       getE820;
    import memory.physical:   initPhysicalBitmap;
    import memory.virtual:    mapGlobalMemory;
    import util.term:         initTerm, info, panic, error;

    firstStageInterrupts();

    getE820();
    initPhysicalBitmap();
    mapGlobalMemory();

    initVBE();
    initTerm();

    info("Reached main(), booting up...                  :kongoudisgust:");

    getACPIInfo();

    secondStageInterrupts();

    initSMP();

    panic("End of the kernel");
}
