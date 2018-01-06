// File: mem.h
//
// Description: internal memory functions header
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

#include "systemapi.h"
#include "types.h"

// the functions
KABI int memcmp(const void *d1, const void *d2, uint64_t len);
KABI void memcpy(void *dest, const void *src, uint64_t len);
KABI void memset(void *dest, uint8_t b, uint64_t len);