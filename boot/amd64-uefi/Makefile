# Makefile

# Description: Makefile of the amd64-uefi bootloader

# Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
# Use of this source code is governed by a license that can be
# found in the LICENSE.md file, in the root directory of
# the source package.

bootloader = bootloader/bootmain.o \
	bootloader/uefifunc.o \
	bootloader/graphicsmode.o

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

.PHONY: compile clean

compile: $(bootloader) $(efilib)

# Rule: .c archives
%.o: %.c
	@echo "Compiling $<" 
	@$(ccompiler) $(cflags_bootloader) -c $< -o $@
	@mv $@ $(builddir)/objects

# Rule: .S archives
%.o: %.S
	@echo "Compiling $<"
	@$(ccompiler) $(cflags_bootloader) -c $< -o $@
	@mv $@ $(builddir)/objects
