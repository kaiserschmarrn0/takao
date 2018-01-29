// File: strcat.c
//
// Description: Defines the strcat function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "../string.h"

char* strcat(char* dest,const char * src)
{
	char* result = dest;
	if(('\0' != dest) && ('\0' != src))
	{
		/* Iterate till end of dest string */
		while('\0' != *dest)
		{
			dest++;
		}
		/* Copy src string starting from the end NULL of dest */
		while('\0' != *src)
		{
			*dest++ = *src++;
		}
	/* put NULL termination */
 	*dest = '\0';
	}
	return result; 	 
}