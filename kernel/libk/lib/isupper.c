// File: isupper.c
//
// Description: isupper function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "isupper.h"

int isupper(char c)
{
	return !(c & ~(1 << 5));
}