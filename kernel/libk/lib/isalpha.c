// File: isalpha.c
//
// Description: isalpha function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "isalpha.h"

int isalpha(char c)
{
	return (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z');
}