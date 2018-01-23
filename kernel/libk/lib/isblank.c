// File: isblank.c
//
// Description: isblank function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "isblank.h"
#include "isspace.h"

int isblank(char c)
{
	return isspace(c) || c == '\t';
}