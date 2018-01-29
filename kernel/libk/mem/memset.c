// File: memset.c
//
// Description: Defines the memset function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "../mem.h"

void memset(void *dest, uint8_t e, uint64_t len) {
	uint8_t *d = dest;
	for(uint64_t i = 0; i < len; i++, d++) {
		*d = e;
	}
}