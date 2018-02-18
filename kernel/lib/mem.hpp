// mem.hpp

// Description: Memory related functions, like memcpy, memset, etc.

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#pragma once

#include "types.hpp"

namespace lib {
	int memcmp(const void* buf1, const void* buf2, size_t count);
	void *memcpy(void *dest, const void *src, uint64_t len);
	void *memset(void *dest, uint8_t b, uint64_t len);
}
