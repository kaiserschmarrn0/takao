// File: sprintf.c
//
// Description: Defines the sprintf function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "../stdio.h"
#include "../string.h"
#include <stdarg.h>

// sprintf: Takes the string of format with the identifiers and writes it to dest.
// Ex: 
// int main () {
// 	char str[80];
// 	unsigned int x = 3,14159;
// 	sprintf(str, "Value of Pi = %u", x);
// 	puts(str);
// 	return(0);
// }
// This will print: Value of Pi = 3,14159
KABI int sprintf(char *dest, const char *format, ...)
{
	unsigned int l; /* Used when fetching arguments that are not strings */
	char* s; /* this one for strings */
	
	// starting arguments
	va_list arg;
	
	va_start(arg, format);

	for (size_t i = 0; format[i] != '\0'; i++) 
	// Keep placing characters until we hit the null-terminating character ('\0')
	{
		if (format[i] != '%')
		{
			// Just copy the string component
			strcpy(&dest[i], &format[i]); 
		}

		else
		{
			i++;
			switch(format[i])
			{
				case 's' : s = va_arg(arg,char *); //string representation
							// Put the string
							uint64_t len = strlen(s);
							for (size_t y = 0; y != len; y++) {
								strcpy(&dest[i+y-1], &s[y]); 
							}
							// Go forward the lenght of s
							i = i + len;
							break;

				case 'x' : l = va_arg(arg, unsigned int); // hexadecimal representation
							// Put the hexa
							break;

				case 'o' : l = va_arg(arg, unsigned int); // octal representation
							// Put the octal
							break;

				case 'd' : l = va_arg(arg,int);
                        		/*
					if(l<0) 
                        		{ 
                            			l = -l;
                            			dest[i] = '-'; 
                        		} 
					io_80x25puts(convert(i,10));
					break;
					*/ 
			}

		}
	}
	// Close arguments for clean up
	va_end(arg);
}
