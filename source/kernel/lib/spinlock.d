module kernel.lib.spinlock;

import core.atomic;

/// Spinlock structure
alias SpinLock = ubyte;

immutable(SpinLock) unlocked = 0; /// Free spinlock value
immutable(SpinLock) locked   = 1; /// Locked spinlock value

/// Maximum spins that a spinlock will allow before being considered a deadlock
immutable(uint) deadlockCounter = 0x4000000;

/**
 * Adquire a spinlock
 *
 * Params:
 *     lock = Lock to adquire
 */
void acquireSpinlock(shared(SpinLock)* lock) {
    foreach (i; 0..deadlockCounter) {
        if (cas(lock, unlocked, locked)) {
            return;
        }
    }

    // panic("Deadlock after %u itinerations", deadlockCounter);
}

/**
 * Release a spinlock
 *
 * Params:
 *     lock  = Lock to release
 */
void releaseSpinlock(shared(SpinLock)* lock) {
    atomicStore(*lock, unlocked);
}
