// File: isalnum.c
//
// Description: isalnum function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "isalnum.h" // isalnum header
#include "isalpha.h" // isalpha function
#include "isdigit.h" // isdigit function

int isalnum(char c)
{
	return isdigit(c) || isalpha(c);
}