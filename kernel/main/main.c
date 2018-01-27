// File: main.c
//
// Description: The kernel main function, bow down.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "main.h"     // Just to declare the prototype
#include "includes.h" // All the kernel includes

struct main main;

void kernel_main(void)
{
	// Cpuid
	check_cpu(&main.cpuinfo);
	
	// Init the serial port
	serial_init(); 
	serial_print("Hi from the kernel!!!!!!!\n");

	// Kernel function reached end, panic
	panic(1);
}
