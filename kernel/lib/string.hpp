// string.hpp

// Description: String functions, like strcat, strlen, etc.

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#pragma once

#include "types.hpp"

namespace lib {
	char* strcat(char* dest,const char * src);
	int strcmp(const char* s1, const char* s2);
	char* strcpy(char * dest, const char * src);
	uint64_t strlen(const char *d);
}
