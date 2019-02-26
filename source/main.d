// main.d - Entrypoint of the kernel
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module main;

extern(C) void main() {
    import io.term:           Colour, initTerm, printLine, error;
    import system.interrupts: enableInterrupts;
    import system.cpu:        CPU, getInfo;

    initTerm();

    printLine("Reached main()\t\t\t\t:kongoudisgust:", Colour.LightMagenta);
    printLine("Booting up...");

    enableInterrupts();

    auto cpu = getInfo();
    cpu.print();
    cpu.enableFeatures();
    cpu.checkDependencies();

    error("End of the kernel");
}
