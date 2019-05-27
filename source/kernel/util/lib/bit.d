/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

module util.lib.bit;

/**
 * Test a bit
 *
 * Params:
 *     var   = Address to test
 *     ofs   = Value to test
 */
extern(C) bool bitTest(uint var, uint ofs) {
    asm {
        naked;

        xor EAX, EAX;
        bt EDI, ESI;
        setc AL;
        ret;
    }
}
