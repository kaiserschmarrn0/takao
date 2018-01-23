// File: strcpy.c
//
// Description: Defines the strcpy function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "../string.h"

char* strcpy(char * dest, const char * src)
{
	char* result = dest;
	if(('\0' != dest) && ('\0' != src))
	{
		/* Start copy src to dest */
		while ('\0' != *src)
		{
			*dest++ = *src++;
		}
		/* put '\0' termination */
		*dest = '\0';
	}
	return result;
 	 
}