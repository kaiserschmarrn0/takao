// File: memcpy.c
//
// Description: Defines the memcpy function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "../mem.h"

void memcpy(void *dest, const void *src, uint64_t len) {
	uint8_t *d = dest;
	const uint8_t *s = src;
	for(uint64_t i = 0; i < len; i++, d++, s++) {
		*d = *s;
	}
}