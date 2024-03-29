module lib.spinlock;

import core.atomic;
import lib.messages;

/// Spinlock structure
alias SpinLock = ubyte;

immutable SpinLock unlocked = 0; /// Free spinlock value
immutable SpinLock locked   = 1; /// Locked spinlock value

/// Maximum spins that a spinlock will allow before being considered a deadlock
immutable auto deadlockCounter = 0x4000000;

pragma(inline, true) void acquireSpinlock(shared(SpinLock)* lock) {
    foreach (i; 0..deadlockCounter) {
        if (cas(lock, unlocked, locked)) {
            return;
        }
    }

    panic("Deadlock after %u iterations", deadlockCounter);
}

/**
 * Release a spinlock
 *
 * Params:
 *     lock  = Lock to release
 */
pragma(inline, true) void releaseSpinlock(shared(SpinLock)* lock) {
    atomicStore(*lock, unlocked);
}
