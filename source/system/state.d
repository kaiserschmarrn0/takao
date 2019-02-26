// state.d - System state: halt, etc
// (C) 2019 the takao authors (AUTHORS.md). All rights reserved
// This code is governed by a license that can be found in LICENSE.md

module system.state;

void halt() {
    asm {
        cli;
    hang:;
        hlt;
        jmp hang;
    }
}
