// File: strcat.c
//
// Description: Defines the strcat function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "../string.h"

// strcat: appends the string pointed to by src to the end of the string pointed to by dest.
// Ex:
// int main () {
//    char src[50], dest[50];
//
//    strcpy(src,  "This is source");
//    strcpy(dest, "This is destination");
//
//    strcat(dest, src);
//
//    printf("Final destination string : |%s|", dest);
//   
//    return(0);
// }
// The output would be:
// Final destination string : |This is destinationThis is source|
KABI char* strcat(char* dest,const char * src)
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