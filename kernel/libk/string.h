// File: string.h
//
// Description: internal string header
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

#include "systemapi.h"
#include "types.h"

// The functions
KABI uint64_t strlen(const char *d);
KABI char* strcpy(char * dest, const char * src);
KABI char* strcat(char* dest,const char * src);