// File: sprintf.c
//
// Description: Defines the sprintf function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "../../string.h"
#include "sprintf.h"
#include "vsprintf.h"

int sprintf(char *s, const char *format, ...)
{
	va_list arg;
	int done;
	va_start(arg, format);
	
	done = vsprintf (s, format, arg);

	va_end(arg);
	return done;
}
