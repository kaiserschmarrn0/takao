# Makefile

# Description: Makefile of the arch dependent kernel

# Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
# Use of this source code is governed by a license that can be
# found in the LICENSE.md file, in the root directory of
# the source package.

archobj = io/ports.o \
	cpu/check.o \
	mem/init.o \
	mem/paging.o \
	mem/gdt.o \
	syscall/idt.o \
	syscall/handlers/int32.o

# export all
export

.PHONY: compile

compile: $(archobj)

# Rule: .cpp archives
%.o: %.cpp
	@echo Compiling $<
	@$(cppcompiler) $(cppflags_arch) -c $< -o $@
	@mv $@ $(builddir)/objects