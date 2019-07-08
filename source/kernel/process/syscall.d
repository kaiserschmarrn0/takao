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
