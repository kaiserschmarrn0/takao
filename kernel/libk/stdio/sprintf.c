//File distributed under the LICENSE of the package (GNU GPL V3)
//Check LICENSE for more information

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
	/*
	// starting arguments
	va_list arg;
	va_start(arg, format);

	for (size_t i = 0; format[i] != '\0'; i++) 
	// Keep placing characters until we hit the null-terminating character ('\0')
	{
		if (format[i] != '%')
		{
			// Just copy the string component
		}

		if (format[i] == '%')
		{
			i++;
			switch(format[i])
			{
				case 's' : s = va_arg(arg,char *); //string representation
							// Put the string
							break;

				case 'x' : l = va_arg(arg, unsigned int); // hexadecimal representation
							// Put the hexa
							break;

				case 'o' : l = va_arg(arg, unsigned int); // octal representation
							// Put the octal
							break;

				case 'd' : l = va_arg(arg,int);
                        		if(l<0) 
                        		{ 
                            			l = -l;
                            			io_80x25putc('-'); 
                        		} 
					io_80x25puts(convert(i,10));
					break; 
			}

		}
	}
	// Close arguments for clean up
	va_end(arg);
	*/
}
