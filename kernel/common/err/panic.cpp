// File: panic.cpp
//
// Description: Panic function
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "../../includes/serial.hpp"
#include "../../includes/err/panic.hpp"

namespace err {
	void panic(int errorcode)
	{
		// Print the error code with a standarized message
		serial_port::serial_print("\n");
		serial_port::serial_print("[PANIC] System halted! (Busy stop)\n");

		for(;;);
	}
}