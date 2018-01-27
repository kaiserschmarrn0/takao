// File: strlen.c
//
// Description: Defines the strlen function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "../string.h"

uint64_t strlen(const char *data) {
	uint64_t r;
	for(r = 0; *data != '\0'; data++, r++);
	return r;
}
