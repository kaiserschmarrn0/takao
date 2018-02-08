// File: panic.cpp
//
// Description: Panic function
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include <io/serial.hpp>
#include <err/panic.hpp>
#include <syscall/idt.hpp>

namespace err {
	void panic(int errorcode)
	{
		// Print the error code with a standarized message
		serial_port::print("\n");
		serial_port::print("[PANIC] System halted! (Busy stop)\n");

		syscall::idt::cli();
		
		for(;;);
	}
}