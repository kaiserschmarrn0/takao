// main.d - Entrypoint of the kernel
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module main;

extern(C) void main() {
    import io.term:           initTerm;
    import system.cpu:        initCPU;
    import system.interrupts: firstStageInterrupts, secondStageInterrupts;
    import system.acpi:       initACPI;
    import system.pit:        enablePIT;
    import memory.e820:       getE820;
    import memory.pmm:        initPMM;
    import memory.vmm:        initVMM;
    import util.messages:     print, panic;

    initTerm();

    print("Reached main(), booting up...\t\t\t\t\t\t\t\t:kongoudisgust:\n");

    firstStageInterrupts();

    initCPU();

    getE820();
    initPMM();
    initVMM();

    initACPI();

    secondStageInterrupts();

    enablePIT();

    panic("End of the kernel");
}
