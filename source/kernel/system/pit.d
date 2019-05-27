/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

module system.pit;

// The frequency in Hz that will be used for the PIT setup
immutable ushort pitFrequency = 1000;

// The uptime time in tics
__gshared ulong uptime = 0;

/**
 * Initialise the PIT at `pitFrequency` Hz
 */
void initPIT() {
    import io.ports;
    import system.interrupts.apic;
    import util.term;

    debug {
        log("Starting PIT at %uHz", pitFrequency);
    }

    // The value we send to the PIT is the value to divide it's input clock
    // (1193180 Hz) by, to get our required frequency. Important to note is
    // that the divisor must be small enough to fit into 16-bits.
    uint divisor = 1193180 / pitFrequency;

    // Send the command byte.
    outb(0x43, 0x36);

    // Divisor has to be sent byte-wise, so split here into upper/lower bytes.
    ubyte l = cast(ubyte)(divisor & 0xFF);
    ubyte h = cast(ubyte)((divisor >> 8) & 0xFF);

    // Send the frequency divisor.
    outb(0x40, l);
    wait();
    outb(0x40, h);
    wait();

    // Unmasking the PIT IRQ
    ioapicSetMask(0, 0, 1);
}

/**
 * Inner function called from the IDT IRQ0 PIT handler, that modifies `uptime`
 */
void pitInner() {
    import core.bitop;

    volatileStore(&uptime, volatileLoad(&uptime) + 1);
}

/**
 * Sleeps for an arbitrary ammount of miliseconds using the PIT
 *
 * Params:
 *     milis = The requested miliseconds
 *
 * Bugs:
 *     Will sleep forever if the PIT is not initialised (is it a bug at all?)
 */
void sleep(ulong milis) {
    import core.bitop;

    ulong finalTime = uptime + (milis * (pitFrequency / 1000));

    finalTime++;

    while (volatileLoad(&uptime) < finalTime) {}
}
