# File: Makefile ( kernel )
#
# Description: Makefile of the kernel
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

.EXPORT_ALL_VARIABLES:
.PHONY: compile

compile:
	cd arch/$(arch) && make compile
	cd common && make compile
	cd main && make compile
	cd libk && make compile
