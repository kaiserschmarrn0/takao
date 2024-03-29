module system.interrupts;

/**
 * Enable the first stage of interrupts: IDT and `cli`
 */
void firstStageInterrupts() {
    import system.interrupts.idt: setIDT;
    import lib.messages;

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
    import lib.messages;
    import system.pit:             initPIT;

    info("Second Stage Interrupts: Flush IRQs, APIC and PIT");

    flushIRQs();
    enableAPIC();
    initPIT();

    asm {
        sti;
    }
}
