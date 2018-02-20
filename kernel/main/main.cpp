// main.cpp

// Description: Main kernel function

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#include "main.h"       // Just to declare the prototype
#include "includes.hpp" // All the kernel includes
#include "bootinfo.h"   // Bootinfo struct
#include "info.hpp"     // Some info

void kernel_main(struct bootinfo bootinfo)
{
	const char* greeter = KERNEL " " VERSION "(" DATE_OF_RELEASE ") initted succesfully";

	// Init the serial port
	serial_port::init(); 
	
	// CPUID
	cpu::init();
	
	// Memory
	mem::init(&bootinfo);

	// Init interrupts
	syscall::idt::init();

	serial_port::puts(greeter);
	
	// Kernel function reached end, panic
	err::panic(1);
}
