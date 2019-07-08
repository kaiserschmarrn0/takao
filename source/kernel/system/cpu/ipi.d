module system.cpu.ipi;

import system.cpu;

immutable uint apicICR0 = 0x300;
immutable uint apicICR1 = 0x310;

immutable uint ipiBase      = 0x40;
immutable uint ipiAbort     = ipiBase;
immutable uint ipiResched   = ipiBase + 1;
immutable uint ipiAbortExec = ipiBase + 2;

/**
 * Send an IPI to an specific core
 *
 * Params:
 *     core  = The requested core to send IPI
 *     value = Value to send
 */
void sendCoreIPI(uint core, uint value) {
    import system.interrupts.apic;

    writeLAPIC(apicICR1, (cast(uint)cores[core].lapic) << 24);
    writeLAPIC(apicICR0, value);
}

void abortCore() {
    asm {
        naked;

        lock;
        inc qword ptr [GS:40];

        cli;
    L1:;
        hlt;
        jmp L1;
    }
}

void reschedCore() {
    asm {
        naked;

        lock;
        inc qword ptr [GS:40];

        cli;
    L1:;
        hlt;
        jmp L1;
    }
}

void abortExecCore() {
    asm {
        naked;

        lock;
        inc qword ptr [GS:40];

        cli;
    L1:;
        hlt;
        jmp L1;
    }
}
