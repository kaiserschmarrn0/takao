// handlers.d - Interrupt handlers
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module system.interrupts.handlers;

void defaultSoftwareHandler() {
    import util.messages: panic;

    panic(cast(char*)"An unhandled software interrupt was raised!");
}

void defaultHardwareHandler() {
    import util.messages: panic;

    panic(cast(char*)"An unhandled hardware interrupt was raised!");
}

void miscSoftwareHandler() {
    import util.messages: w = warning;

    w(cast(char*)"The misc software handler interrupt is not implemented yet");
}
