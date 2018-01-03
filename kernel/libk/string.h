//File distributed under the LICENSE of the package (GNU GPL V3)
//Check LICENSE for more information

#pragma once

#include "systemapi.h"
#include "types.h"

// the functions
KABI int memcmp(const void *d1, const void *d2, uint64_t len);
KABI void memcpy(void *dest, const void *src, uint64_t len);
KABI void memset(void *dest, uint8_t b, uint64_t len);
KABI uint64_t strlen(const char *d);
KABI char* strcpy(char * dest, const char * src);
KABI char* strcat(char* dest,const char * src);