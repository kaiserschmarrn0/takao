# File: Makefile ( common )
#
# Description: Makefile of the main kernel files
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

cppflags_common = -ffreestanding -fno-stack-protector -fpic -fno-builtin -fshort-wchar -mno-red-zone \
	-Wall -Wextra -fno-exceptions -fno-rtti -c -o

common = serial.o \
	err/panic.o

# export all
export

.PHONY: all clean

all: $(common)
	@echo "Copy the archives to output"
	cp $(common) ../../$(builddir)/
	@echo ""

clean:
	rm -rf $(common)

# Rule: .cpp archives
%.o: %.cpp
	@echo Compiling $<
	@$(cppcompiler) $(cppflags_common) -c $< -o $@