# Makefile

# Description: Makefile of the kernel

# Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
# Use of this source code is governed by a license that can be
# found in the LICENSE.md file, in the root directory of
# the source package.

.EXPORT_ALL_VARIABLES:
.PHONY: compile

compile:
	cd arch/$(arch) && make compile
	cd common && make compile
	cd main && make compile
	cd lib && make compile
	cd glue && make compile
