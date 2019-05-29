/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

module system.interrupts;

/**
 * Enable the first stage of interrupts: IDT and `cli`
 */
void firstStageInterrupts() {
    import system.interrupts.idt: setIDT;
    import util.lib.messages;

    info("First Stage Interrupts: Disabling and IDT");

    asm {
        cli;
    }

    setIDT();
}

private extern(C) void flushIRQs();

/**
 * Enable the second stage of interrupts: Flushing real mode IRQs, APIC and PIT.
 */
void secondStageInterrupts() {
    import system.interrupts.apic: enableAPIC;
    import util.lib.messages;
    import system.pit:             initPIT;

    info("Second Stage Interrupts: Flush IRQs, APIC and PIT");

    flushIRQs();
    enableAPIC();
    initPIT();

    asm {
        sti;
    }
}
