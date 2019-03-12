// main.d - Entrypoint of the kernel
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module main;

extern(C) void main() {
    import io.term:           initTerm, print, panic;
    import system.cpu:        CPU, getInfo;
    import system.interrupts: firstStageInterrupts, secondStageInterrupts;
    import system.acpi:       initACPI;
    import memory.e820:       getE820;
    import memory.pmm:        initPMM;
    import memory.vmm:        initVMM;

    initTerm();

    print("Reached main(), booting up...\t\t\t\t\t\t\t\t:kongoudisgust:\n");

    firstStageInterrupts();

    auto cpu = getInfo();
    cpu.print();
    cpu.enableFeatures();
    cpu.checkDependencies();

    getE820();
    initPMM();
    initVMM();

    initACPI();

    secondStageInterrupts();

    print("\t%s\n\t%s\n\t%s\n", "Is anyone there?", "Oh..", "Hi!");

    panic("End of the kernel");
}
