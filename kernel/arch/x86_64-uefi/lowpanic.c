// File: lowpanic.c
//
// Description: Arch dependent panic function.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "lowpanic.h"

KABI void low_panic(int errorcode)
{
	// Stuff here

	for(;;) __asm__ volatile("cli; hlt");	
}
