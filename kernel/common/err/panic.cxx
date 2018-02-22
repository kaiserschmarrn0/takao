// panic.cxx

// Description: Panic function

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#include <io/serial.hxx>
#include <err/panic.hxx>
#include <syscall/idt.hxx>

namespace err {
	void panic(int errorcode)
	{
		// Print the error code with a standarized message
		serial_port::puts("\n");
		serial_port::puts("[PANIC] System halted! (Busy stop)\n");
		serial_port::puts("Error code: ");
		serial_port::printf("%d", errorcode);

		syscall::idt::cli();
		
		for(;;);
	}
}