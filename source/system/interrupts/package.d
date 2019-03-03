// package.d - Enabling Interrupts
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module system.interrupts;

import system.cpu;

void enableInterrupts() {
    import system.interrupts.idt:  setIDT;
    import system.interrupts.apic: enableAPIC;
  
    // Disable the interrupts
    asm {
        cli;
    }

    enableAPIC();
    setIDT();

    // Finish setting up the interrupts by enabling them
    asm {
        sti;
    }
}
