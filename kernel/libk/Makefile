# File: Makefile ( libk )
#
# Description: Makefile of the libk
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

libk = 	mem/memcmp.o \
	mem/memcpy.o \
	mem/memset.o \
	\
	io/output/vsprintf.o \
	io/output/sprintf.o \
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