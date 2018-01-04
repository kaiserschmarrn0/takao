//File distributed under the LICENSE of the package (GNU GPL V3)
//Check LICENSE for more information

#include "../string.h"

// strcpy: copies the string pointed to, by src to dest.
// Ex:
// int main () {
//    char src[40];
//    char dest[100];
//  
//    memset(dest, '\0', sizeof(dest));
//    strcpy(src, "xD");
//    strcpy(dest, src);
//
//    printf("Final copied string : %s\n", dest);
//   
//    return(0);
// }
// The output would be: 
// Final copied string : xD
KABI char* strcpy(char * dest, const char * src)
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