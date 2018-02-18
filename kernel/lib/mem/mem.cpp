// mem.cpp

// Description: mem functions, memcpy, memset, etc.

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#include "../mem.hpp"

int lib::memcmp(const void* buf1, const void* buf2, size_t count)
{
	if(!count)
		return(0);

	while(--count && *(char*)buf1 == *(char*)buf2 ) {
		buf1 = (char*)buf1 + 1;
		buf2 = (char*)buf2 + 1;
	}

	return(*((unsigned char*)buf1) - *((unsigned char*)buf2));
}

void *lib::memcpy(void *dest, const void *src, uint64_t len)
{
	uint8_t *buf = (uint8_t *)dest;
	uint8_t *intermediary = (uint8_t *)src;
	while (len--)
	{
		*buf++ = *intermediary++;
	}
	return dest;
}

void *lib::memset(void *dest, uint8_t b, uint64_t len)
{
	uint8_t *buf = (uint8_t *)dest;
	while (len--)
	{
		*buf++ = (uint8_t)b;
	}
	return dest;
}
