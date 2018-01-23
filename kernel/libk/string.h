// File: string.h
//
// Description: internal string header
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

#include "types.h"

// The functions
uint64_t strlen(const char *d);
char* strcpy(char * dest, const char * src);
char* strcat(char* dest,const char * src);
int strcmp(const char* s1, const char* s2);