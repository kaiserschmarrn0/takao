//File distributed under the LICENSE of the package (GNU GPL V3)
//Check LICENSE for more information

#include "kernelincludes.h" // All the required "material"
#include "main.h" // Just to declare the prototype

// The function "arch_main" just dropped us in an enviroment with all the arch
// dependent and final booting stuff done.
// Now we just start building in the top off all.

KABI void kernel_main(void)
{
	// Start serial port
	init_serial();
	serial_print("[kernel_main] Kernel booting\n");

	// Reached the end of function so lets panic
	panic(1);
}
