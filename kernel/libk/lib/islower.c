// File: islower.c
//
// Description: islower function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "islower.h"

int islower(char c)
{
    return c & (1 << 5);
}