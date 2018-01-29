// File: isdigit.c
//
// Description: isdigit function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "isdigit.h"

int isdigit(char c)
{
	return c >= '0' && c <= '9';
}