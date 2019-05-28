/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

module util.lib.spinlock;

import util.term: panic;

immutable auto maxLockItinerations = 0x4000000;

/// Lock structure
alias Lock = int;

immutable Lock newLock = 1;

/**
 * Adquire a spinlock
 *
 * Params:
 *     lock  = Lock to adquire
 */
void acquireSpinlock(Lock* lockVal) {
    foreach (i; 0..maxLockItinerations) {
        ubyte lockStatus;

        asm {
            mov RBX, lockVal;
            lock;
            btr int ptr [RBX], 0;
            setc AL;
            mov lockStatus, AL;
        }

        if (lockStatus) {
            return;
        }
    }

    panic("Deadlock");
}

/**
 * Release a spinlock
 *
 * Params:
 *     lock  = Lock to release
 */
void releaseSpinlock(Lock* lockVal) {
    asm {
        mov RBX, lockVal;
        lock;
        bts int ptr [RBX], 0;
    }
}
