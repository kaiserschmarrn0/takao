// File: sprintf.c
//
// Description: Defines the sprintf function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "sprintf.h"  // sprintf function header
#include "vsprintf.h" // vsprintf

// sprintf: Uses vsprintf to put a formated char in a char.
int sprintf(char *s, const char *format, ...)
{
	va_list arg;
	int done;
	va_start(arg, format);
	
	done = vsprintf (s, format, arg);

	va_end(arg);
	return done;
}
