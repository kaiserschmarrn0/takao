# Makefile

# Description: Makefile of the global lib

# Copyright 2016 The Takao Authors (AUTHORS.md). All rights reserved.
# Use of this source code is governed by a license that can be
# found in the LICENSE.md file, in the root directory of
# the source package.


lib = mem/mem.o \
	string/string.o

.PHONY: compile

compile: $(lib)

# Rule: .c archives
%.o: %.cpp
	@echo Compiling $<
	@$(cppcompiler) $(cppflags_lib) -c $< -o $@
	@mv $@ $(builddir)/objects