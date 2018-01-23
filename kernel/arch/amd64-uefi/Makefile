# File: Makefile ( amd64-uefi kernel )
#
# Description: Makefile of the amd64 bootloader
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

cflags_arch = -I ../../../boot/amd64-uefi/efi-lib/includes -I ../../../boot/amd64-uefi/efi-lib/includes/x86_64 -I ../../../boot/amd64-uefi/efi-lib/includes/protocol \
	-fno-stack-protector -fpic -fno-builtin \
	-fno-builtin-fshort-wchar -mno-red-zone -DCONFIG_x86_64 -DGNU_EFI_USE_MS_ABI -c -o

archobj = ioport.o

# export all
export

.PHONY: all clean

all: $(archobj)
	@echo "Copy the archives to output"
	cp $(archobj) ../../../$(builddir)/
	@echo ""

clean:
	rm -rf $(archobj)

# Rule: .c archives
%.o: %.c
	@echo Compiling $<
	@$(ccompiler) $(cflags_arch) -c $< -o $@