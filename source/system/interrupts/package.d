// package.d - Enabling Interrupts
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module system.interrupts;

void firstStageInterrupts() {
    import system.interrupts.idt: setIDT;
    import util.messages: print;

    print("First Stage Interrupts: Disabling and IDT\n");

    asm {
        cli;
    }

    setIDT();
}

private extern extern(C) void flushIRQs();

void secondStageInterrupts() {
    import system.interrupts.apic: enableAPIC;
    import util.messages: print;

    print("Second Stage Interrupts: Flush IRQs and APIC\n");

    flushIRQs();
    enableAPIC();

    asm {
        sti;
    }
}
