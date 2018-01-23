# File: Makefile ( amd64 bootloader)
#
# Description: Makefile of the amd64 bootloader
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

cflags_bootloader = -I efi-lib/includes -I efi-lib/includes/x86_64 -I efi-lib/includes/protocol \
	-fno-stack-protector -fpic -fno-builtin \
	-fno-builtin-fshort-wchar -mno-red-zone -DCONFIG_x86_64 -DGNU_EFI_USE_MS_ABI -c -o

bootloader = bootloader/bootmain.o \
	bootloader/graphics.o \
	bootloader/uefifunc.o

efilib = efi-lib/efiboot/crt0-efi-x86_64.o \
	efi-lib/efiboot/reloc_x86_64.o \
	\
	efi-lib/efilib/boxdraw.o \
	efi-lib/efilib/cmdline.o \
	efi-lib/efilib/console.o \
	efi-lib/efilib/crc.o \
	efi-lib/efilib/data.o \
	efi-lib/efilib/debug.o \
	efi-lib/efilib/dpath.o \
	efi-lib/efilib/error.o \
	efi-lib/efilib/event.o \
	efi-lib/efilib/exit.o \
	efi-lib/efilib/guid.o \
	efi-lib/efilib/hand.o \
	efi-lib/efilib/hw.o \
	efi-lib/efilib/init.o \
	efi-lib/efilib/lock.o \
	efi-lib/efilib/misc.o \
	efi-lib/efilib/print.o \
	efi-lib/efilib/smbios.o \
	efi-lib/efilib/sread.o \
	efi-lib/efilib/str.o \
	efi-lib/efilib/runtime/efirtlib.o \
	efi-lib/efilib/runtime/rtdata.o \
	efi-lib/efilib/runtime/rtlock.o \
	efi-lib/efilib/runtime/rtstr.o \
	efi-lib/efilib/runtime/vm.o \
	efi-lib/efilib/x86_64/callwrap.o \
	efi-lib/efilib/x86_64/efi_stub.o \
	efi-lib/efilib/x86_64/initplat.o \
	efi-lib/efilib/x86_64/math.o \
	efi-lib/efilib/x86_64/setjmp.o

.PHONY: all clean

all: $(bootloader) $(efilib)
	@echo ""
	@echo "Copy the archives to output"
	cp $(bootloader) $(efilib) ../../$(builddir)/
	@echo ""

clean:
	rm -rf $(bootloader)
	rm -rf $(efilib)


# Rule: .c archives
%.o: %.c
	@echo Compiling $< 
	@$(ccompiler) $(cflags_bootloader) -c $< -o $@

# Rule: .S archives
%.o: %.S
	@echo Compiling $< 
	@$(ccompiler) $(cflags_bootloader) -c $< -o $@