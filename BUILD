Go into the kernel folder (kernel) and type:

"make prepare" and "make all" to get an output image. 
This output image can be used to booting, but is recommended to test it in a virtual machine, this 
will be accomplished with:

"make fat-image" <- will make a fat image ready to boot, this one can be burned to USB drives for example.
"make test-qemu" <- will open a QEMU virtual machine to test the kernel (it has some dependencies)

The kernel is modular when building, so different parts of it can be built with the following commands:
"make archdependent.a" <- Will build the arch dependent library in the /build directory
"make archindependent.a" <- The same as above, but with the arch independent things
"make main.o" <- This will make the object of the main kernel
"make libk.a" <- This will make the archive of the kernel library

x86_64 EFI TESTING:
When testing you will be dropped out in the EFI Shell, you will need to type this in order to boot:
  fs0: <- "loads the storage"
  cd EFI <- "enters the EFI directory"
  cka<version>.efi <- (you can use tab for autocomplete) "executes the kernel"
