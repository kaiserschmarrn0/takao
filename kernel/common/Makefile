# File: Makefile ( common )
#
# Description: Makefile of the main kernel files
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

cflags_common = -ffreestanding -fno-stack-protector -fpic -fno-builtin -fshort-wchar -mno-red-zone \
	-Wall -Wextra -c -o

common = serial.o

# export all
export

.PHONY: all clean

all: $(common)
	@echo "Copy the archives to output"
	cp $(common) ../../$(builddir)/
	@echo ""

clean:
	rm -rf $(common)

# Rule: .c archives
%.o: %.c
	@echo Compiling $<
	@$(ccompiler) $(cflags_common) -c $< -o $@