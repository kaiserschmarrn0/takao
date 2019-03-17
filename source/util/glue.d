// glue.d - Glue needed by compiler internals
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module util.glue;

extern (C) void __assert(const(char)* exp, const(char)* file, const(char)* line) {
    import util.term: panic;

    panic("Failed assertion!");
}

extern (C) void* memset(void* s, int c, uint n) {
    auto pointer = cast(ubyte*) s;

    foreach (i; 0..n) {
        pointer[i] = cast(ubyte) c;
    }

    return s;
}
