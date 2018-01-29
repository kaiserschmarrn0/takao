// File: strcmp.c
//
// Description: Defines the strcmp function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "../string.h"

int strcmp(const char* s1, const char* s2)
{
	while(*s1 && (*s1 == *s2))
	{
		s1++;
		s2++;
	}
	return *(const unsigned char*)s1 - *(const unsigned char*)s2;
}