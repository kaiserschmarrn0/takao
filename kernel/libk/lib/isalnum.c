// File: isalnum.c
//
// Description: isalnum function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "isalnum.h"
#include "isalpha.h"
#include "isdigit.h"

int isalnum(char c)
{
	return isdigit(c) || isalpha(c);
}