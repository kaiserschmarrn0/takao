/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

module util.glue;

/**
 * Called by the D compiler when an `assert()` is invoked
 */
extern (C) void __assert(const(char)* exp, const(char)* file, uint line) {
    import util.lib;

    panic("In file '%s', line '%u'\n> %s\nFailed assertion", file, line, exp);
}

/**
 * Called by the D compiler when doing memory operations
 */
extern (C) void* memset(void* s, int c, ulong n) {
    auto pointer = cast(ubyte*)s;

    foreach (i; 0..n) {
        pointer[i] = cast(ubyte)c;
    }

    return s;
}
