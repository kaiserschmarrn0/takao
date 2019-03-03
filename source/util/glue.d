// glue.d - Glue needed by compiler internals
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module utils.glue;

extern (C) void __assert(const(char)* exp, const(char)* file, uint line) {
    import io.term: error;
    /*
    error("failed assertion: %s", exp);
    error("file: %s", file);
    error("line: %u", line);
    */
    error("Failed assertion!");
}

extern (C) void* memset(void *s, int c, size_t n) {
    auto pointer = cast(ubyte*) s;

    for (auto i = 0; i < n; i++) pointer[i] = cast(ubyte) c;

    return s;
}
