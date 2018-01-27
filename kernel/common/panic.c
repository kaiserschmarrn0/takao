// File: panic.c
//
// Description: Panic function
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "../includes/serial.h"
#include "../includes/panic.h"

void panic(int errorcode)
{
	// Print the error code with a standarized message
	serial_print("\n");
	serial_print("[PANIC] System halted! (Busy stop)\n");

	for(;;);

}