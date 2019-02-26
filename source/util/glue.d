// glue.d - Glue needed by compiler internals
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module utils.glue;

extern (C) void __assert(const(char)* exp, const(char)* file, uint line) {
    // kprint(KPRN_ERR, "failed assertion: %s", exp);
    // kprint(KPRN_ERR, "file: %s", file);
    // kprint(KPRN_ERR, "line: %u", line);
    for (;;) {}
}

extern (C) void* memset(void *s, int c, size_t n) {
    ubyte* ptr = cast(ubyte*)s;

    for (size_t i = 0; i < n; i++) ptr[i] = cast(ubyte)c;

    return s;
}
