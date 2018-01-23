// File: vsprintf.c
//
// Description: Defines the vsprintf function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

#include <stdarg.h>

int vsprintf(char *buf, const char *fmt, va_list args);