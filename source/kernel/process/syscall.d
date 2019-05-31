/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

module system.syscall;

shared(size_t) syscallEntryAddress;

static this() {
    syscallEntryAddress = cast(size_t)&syscallEntryAddress;
}

private extern(C) void syscallEntry() {
    asm {
        naked;

        sysret;
    }
}
