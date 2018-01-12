// File: highpanic.c
//
// Description: Freestanding panic function
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "../includes/utils/highpanic.h"
#include "../includes/output/serial.h"

KABI void panic(int error_code)
{
	serial_print("[panic] Kernel halted due to an error!\n");
	serial_print("\tError code :");
	serial_print("\n");
	// Stuff here
	for (;;);
}