// glue.d - Glue needed by compiler internals
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module util.glue;

extern (C) void __assert(char* exp, char* file, uint line) {
    import util.term: panic;

    panic("In file '%s', line '%u'\n> %s\nFailed assertion", file, line, exp);
}

extern (C) void* memset(void* s, int c, ulong n) {
    auto pointer = cast(ubyte*)s;

    foreach (i; 0..n) {
        pointer[i] = cast(ubyte)c;
    }

    return s;
}
