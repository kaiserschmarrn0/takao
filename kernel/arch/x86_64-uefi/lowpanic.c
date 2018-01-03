//File distributed under the LICENSE of the package (GNU GPL V3)
//Check LICENSE for more information

#include "lowpanic.h"

KABI void low_panic(int errorcode)
{
	// Stuff here

	for(;;) __asm__ volatile("cli; hlt");	
}
