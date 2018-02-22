# Makefile

# Description: Makefile of the no arch dependent kernel

# Copyright 2016 The Takao Authors (AUTHORS.md). All rights reserved.
# Use of this source code is governed by a license that can be
# found in the LICENSE.md file, in the root directory of
# the source package.


common = io/serial.o \
	err/panic.o

.PHONY: compile

compile: $(common)

# Rule: .cxx archives
%.o: %.cxx
	@echo Compiling $<
	@$(cppcompiler) $(cppflags_common) -c $< -o $@
	@mv $@ $(builddir)/objects