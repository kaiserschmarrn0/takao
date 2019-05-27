/**
 * License: (C) 2019 the takao authors (AUTHORS.md). All rights reserved
 * This code is governed by a license that can be found in LICENSE.md
 */

module util.lib.random;

extern(C) size_t rdrandWrapper();

/**
 * Generates a random number
 */
size_t random() {
    import system.cpu;

    size_t seed;

    if (coreCPUIDs[currentCore()].hasRDRAND) {
        seed = rdrandWrapper();
    } else {
        seed = 1;
    }

	seed = seed * 1103515245 + 12345;
    return cast(size_t)(seed / 65536) % size_t.max;
}
