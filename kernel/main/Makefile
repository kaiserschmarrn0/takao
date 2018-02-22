# Makefile

# Description: Makefile of the main kernel

# Copyright 2016 The Takao Authors (AUTHORS.md). All rights reserved.
# Use of this source code is governed by a license that can be
# found in the LICENSE.md file, in the root directory of
# the source package.


main = main.o

.PHONY: compile

compile: $(main)

# Rule: .cpp archives
%.o: %.cxx
	@echo Compiling $<
	@$(cppcompiler) $(cppflags_main) -c $< -o $@
	@mv $@ $(builddir)/objects