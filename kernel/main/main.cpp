// File: main.cpp
//
// Description: The kernel main function, bow down.
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "main.h"     // Just to declare the prototype
#include "includes.hpp" // All the kernel includes
#include "bootinfo.h" // Bootinfo struct

struct maininfo maininfo;

void kernel_main(struct bootinfo *bootinfo)
{
	// CPUID
	cpu::check(&maininfo.cpuinfo);
	
	// Memory
	mem::init();

	// Init interrupts
	syscall::idt::init();

	// Init the serial port
	serial_port::init(); 
	serial_port::print("Hi from the kernel!!!!!!!\n");

	// Kernel function reached end, panic
	err::panic(1);
}
