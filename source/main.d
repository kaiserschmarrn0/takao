// main.d - Entrypoint of the kernel
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module main;

extern(C) void main() {
    import io.term:           initTerm, printLine, error;
    import system.cpu:        CPU, getInfo;
    import system.interrupts: firstStageInterrupts, secondStageInterrupts;
    import memory.e820:       getE820;
    import memory.pmm:        initPMM, alloc, free;
    import memory.vmm:        initVMM;

    initTerm();

    printLine("Reached main(), booting up...\t\t\t\t\t\t\t\t:kongoudisgust:");

    firstStageInterrupts();

    auto cpu = getInfo();
    cpu.print();
    cpu.enableFeatures();
    cpu.checkDependencies();

    getE820();
    initPMM();
    initVMM();

    secondStageInterrupts();

    error("End of the kernel");
}
