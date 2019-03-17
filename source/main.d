// main.d - Entrypoint of the kernel
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module main;

extern(C) void main() {
    import io.vga:            initVGA;
    import system.cpu:        initCPU;
    import system.interrupts: firstStageInterrupts, secondStageInterrupts;
    import system.acpi:       getACPIInfo;
    import memory.e820:       getE820;
    import memory.physical:   initPhysicalBitmap;
    import memory.virtual:    mapGlobalMemory;
    import util.term:         print, panic;

    initVGA();

    print("Reached main(), booting up...\t\t\t\t\t\t\t\t:kongoudisgust:\n");

    firstStageInterrupts();

    initCPU();

    getE820();
    initPhysicalBitmap();
    mapGlobalMemory();

    getACPIInfo();

    secondStageInterrupts();

    panic("End of the kernel");
}
