// File: main.c
//
// Description: The kernel main function, bow down.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "main.h" // Just to declare the prototype
#include "../includes/serial.h"

void kernel_main(void)
{
	serial_init(); 
	serial_print("Hi from the kernel!!!!!!!\n");
}
