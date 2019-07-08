module lib.bit;

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
