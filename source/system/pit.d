// pit.d - PIT initialisation
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module system.pit;

immutable auto pitFrequency = 1000;

void enablePIT() {
    import io.ports:      outb, wait;
    import util.messages: print, panic;

    print("PIT: Setting up with frequency %uHz\n", pitFrequency);

    /*
    ushort x = 1193182 / pitFrequency;

    if ((1193182 % pitFrequency) > (pitFrequency / 2)) {
        x++;
    }

    outb(0x40, cast(ubyte)(x & 0x00FF));
    wait();
    outb(0x40, cast(ubyte)((x & 0xFF00) >> 8));
    wait();

    debug {
        print("\tFrequency updated, unmasking PIT IRQ...\n");
    }

    setIOAPICMask(0, 0, 1);
    */
}
