// File: toupper.h
//
// Description: toupper function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "toupper.h"

char toupper(char c)
{
	return c & ~(1 << 5);
}