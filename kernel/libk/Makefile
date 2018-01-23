# File: Makefile ( libk )
#
# Description: Makefile of the libk
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

cflags_libk = -ffreestanding -fno-stack-protector -fpic -fno-builtin -fshort-wchar -mno-red-zone \
	-Wall -Wextra -c -o

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

all: $(libk)
	@echo "Copy the archives to output"
	cp $(libk) ../../$(builddir)/
	@echo ""

clean:
	rm -rf $(libk)

# Rule: .c archives
%.o: %.c
	@echo Compiling $<
	@$(ccompiler) $(cflags_libk) -c $< -o $@