// handlers.d - Interrupt handlers
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module system.interrupts.handlers;

import io.term: warning, error;

// Generic interrupt handler
void defaultHandler() {
    error("An unhandled interrupt was raised!");
}

void miscSoftwareHandler() {
    warning("The Misc software handler interrupt is not implemented yet");
}
