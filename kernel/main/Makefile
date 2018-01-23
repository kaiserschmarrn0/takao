# File: Makefile ( main folder one )
#
# Description: Makefile of the main kernel files
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

cflags_main = -ffreestanding -fno-stack-protector -fpic -fno-builtin -fshort-wchar -mno-red-zone \
	-Wall -Wextra -c -o

main = main.o

# export all
export

.PHONY: all clean

all: $(main)
	@echo "Copy the archives to output"
	cp $(main) ../../$(builddir)/
	@echo ""

clean:
	rm -rf $(main)

# Rule: .c archives
%.o: %.c
	@echo Compiling $<
	@$(ccompiler) $(cflags_main) -c $< -o $@