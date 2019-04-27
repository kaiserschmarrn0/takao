// main.d - Entrypoint of the kernel
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module main;

extern(C) void main() {
    import io.vbe:            initVBE;
    import system.cpu:        initCPU;
    import system.interrupts: firstStageInterrupts, secondStageInterrupts;
    import system.acpi:       getACPIInfo;
    import memory:            initMemoryManagers;
    import util.term:         initTerm, info, warning, panic;

    firstStageInterrupts();

    initMemoryManagers();

    initVBE();
    initTerm();

    info("Reached main(), booting up...                  :kongoudisgust:");

    getACPIInfo();

    secondStageInterrupts();

    initCPU();

    panic("End of the kernel");
}
