# Makefile

# Description: Makefile of the libk

# Copyright 2016 The Takao Authors (AUTHORS.md). All rights reserved.
# Use of this source code is governed by a license that can be
# found in the LICENSE.md file, in the root directory of
# the source package.


libk = 	mem/memcmp.o \
	mem/memcpy.o \
	mem/memset.o \
	\
	lib/rand.o \
	lib/isdigit.o \
	lib/isalnum.o \
	lib/isalpha.o \
	lib/isblank.o \
	lib/islower.o \
	lib/isspace.o \
	lib/isupper.o \
	lib/tolower.o \
	lib/toupper.o \
	\
	string/strcat.o \
	string/strcpy.o \
	string/strlen.o \
	string/strcmp.o

.PHONY: compile

compile: $(libk)

# Rule: .c archives
%.o: %.c
	@echo Compiling $<
	@$(ccompiler) $(cflags_libk) -c $< -o $@
	@mv $@ $(builddir)/objects