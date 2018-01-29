// File: sprintf.h
//
// Description: Defines the sprintf function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

#include <stdarg.h>

// sprintf: Uses vsprintf to put a formated char in a char.
int sprintf(char *s, const char *format, ...);
