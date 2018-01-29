# File: Makefile ( amd64 bootloader )
#
# Description: Makefile of the amd64 bootloader
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

cflags_bootloader = -I ../efi/includes -I ../efi/includes/x86_64 -I ../efi/includes/protocol \
	-fno-stack-protector -fpic -fno-builtin \
	-fno-builtin-fshort-wchar -mno-red-zone -DCONFIG_x86_64 -DGNU_EFI_USE_MS_ABI -c -o

bootloader = bootloader/bootmain.o \
	bootloader/graphics.o \
	bootloader/uefifunc.o

efilib = ../efi/efiboot/crt0-efi-amd64.o \
	../efi/efiboot/reloc_amd64.o \
	\
	../efi/efilib/boxdraw.o \
	../efi/efilib/cmdline.o \
	../efi/efilib/console.o \
	../efi/efilib/crc.o \
	../efi/efilib/data.o \
	../efi/efilib/debug.o \
	../efi/efilib/dpath.o \
	../efi/efilib/error.o \
	../efi/efilib/event.o \
	../efi/efilib/exit.o \
	../efi/efilib/guid.o \
	../efi/efilib/hand.o \
	../efi/efilib/hw.o \
	../efi/efilib/init.o \
	../efi/efilib/lock.o \
	../efi/efilib/misc.o \
	../efi/efilib/print.o \
	../efi/efilib/smbios.o \
	../efi/efilib/sread.o \
	../efi/efilib/str.o \
	../efi/efilib/runtime/efirtlib.o \
	../efi/efilib/runtime/rtdata.o \
	../efi/efilib/runtime/rtlock.o \
	../efi/efilib/runtime/rtstr.o \
	../efi/efilib/runtime/vm.o \
	../efi/efilib/amd64/callwrap.o \
	../efi/efilib/amd64/efi_stub.o \
	../efi/efilib/amd64/initplat.o \
	../efi/efilib/amd64/math.o \
	../efi/efilib/amd64/setjmp.o

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