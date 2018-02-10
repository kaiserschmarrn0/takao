// main.cpp

// Description: Main kernel function

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#include "main.h"     // Just to declare the prototype
#include "includes.hpp" // All the kernel includes
#include "bootinfo.h" // Bootinfo struct

struct maininfo maininfo;

void kernel_main(struct bootinfo *bootinfo)
{
	// Init the serial port
	serial_port::init(); 
	
	// CPUID
	cpu::check(&maininfo.cpuinfo);
	
	// Memory
	mem::init();

	// Init interrupts
	syscall::idt::init();

	serial_port::print("Hi from the kernel!!!!!!!\n");

	// Kernel function reached end, panic
	err::panic(1);
}
