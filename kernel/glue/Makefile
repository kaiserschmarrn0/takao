# Makefile

# Description: Makefile of the glue that hold together C++

# Copyright 2016 The Takao Authors (AUTHORS.md). All rights reserved.
# Use of this source code is governed by a license that can be
# found in the LICENSE.md file, in the root directory of
# the source package.

# Note: We will use same flags than common kernel, dont ask why (no reason at all)

glue = cxa_pure_virtual.o

.PHONY: compile

compile: $(glue)

# Rule: .cpp archives
%.o: %.cpp
	@echo Compiling $<
	@$(cppcompiler) $(cppflags_common) -c $< -o $@
	@mv $@ $(builddir)/objects