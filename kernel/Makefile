# File: Makefile ( kernel )
#
# Description: Makefile of the kernel
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

.PHONY: all clean

all:
	cd arch/$(arch) && make all
	cd common && make all
	cd main && make all
	cd libk && make all

clean:
	cd arch/$(arch) && make clean
	cd common && make clean
	cd main && make clean
	cd libk && make clean
