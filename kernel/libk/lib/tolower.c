// File: tolower.c
//
// Description: tolower function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "tolower.h"

char tolower(char c)
{
	return c | (1 << 5);
}