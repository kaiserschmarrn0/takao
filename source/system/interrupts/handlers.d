// handlers.d - Interrupt handlers
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module system.interrupts.handlers;

void defaultSoftwareHandler() {
    import io.term: error;

    error("An unhandled software interrupt was raised!");
}

void defaultHardwareHandler() {
    import io.term: error;

    error("An unhandled hardware interrupt was raised!");
}

void miscSoftwareHandler() {
    import io.term: warning;

    warning("The misc software handler interrupt is not implemented yet");
}
