// File: main.cpp
//
// Description: The kernel main function, bow down.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "main.h"     // Just to declare the prototype
#include "includes.hpp" // All the kernel includes

struct maininfo maininfo;

void kernel_main(void)
{
	// Cpuid
	check_cpu(&maininfo.cpuinfo);
	
	// Init the serial port
	serial_port::serial_init(); 
	serial_port::serial_print("Hi from the kernel!!!!!!!\n");

	// Kernel function reached end, panic
	panic(1);
}
