# The CKA build process:
#### Author: TheStr3ak5

In CKA, the build process is modular, this means that the main parts of the kernel can be built separately, CKA has
4 main 'parts':

The arch dependent files = Built as archdependent.a, are the files that the kernel uses in the booting or the ones
that vary between architectures. Can be found in /arch

The arch independent files = Built as archindependent.a, are the common kernel drivers that don't vary between architectures.
Can be found in /common

The main kernel = Built as main.o, is the main kernel function, can be found in /main. 

The libk = Built as libk.a, is the kernel specific library, can be found in /libk.

These 4 files are linked together in the /build directory to generate a .bin fine, that then can be modified to
finish the build process.