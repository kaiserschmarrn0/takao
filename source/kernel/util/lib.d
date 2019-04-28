/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

module util.lib;

/**
 * Compare if 2 strings are equal
 *
 * Params:
 *     dst   = First string to compare
 *     src   = Second one
 *     count = Count of chars to compare
 *
 * Return: `true` if equals, `false` if not
 */
bool areEquals(const(char)* dst, const(char)* src, ulong count) {
    foreach (i; 0..count) {
        if (dst[i] != src[i]) {
            return false;
        }
    }

    return true;
}

/**
 * Compare if 2 strings are equal
 *
 * Params:
 *     dst   = First string to compare
 *     src   = Second one
 *
 * Return: `true` if equals, `false` if not
 */
bool areEquals(const(char)* dst, const(char)* src) {
    size_t i;

    for (i = 0; dst[i] == src[i]; i++) {
        if ((!dst[i]) && (!src[i])) {
            return false;
        }
    }

    return true;
}

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
