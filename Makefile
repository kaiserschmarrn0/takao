# Makefile - makefile of the project
# (C) 2019 the takao authors (AUTHORS.md). All rights reserved
# This code is governed by a license that can be found in LICENSE.md

override kernel = takao
override image = $(kernel).elf
override ISO = $(kernel).iso

override sourceDir = source
override buildDir = build

DC = ldc2
LD = ld.lld
AS = nasm

DFLAGS = -O2 -gc

DFLAGS_INTERNAL := $(DFLAGS) -mtriple=x86_64-elf -relocation-model=static \
	-code-model=kernel -mattr=-sse,-sse2,-sse3,-ssse3 -disable-red-zone \
	-betterC -op -I=./source

LDFLAGS = -nostdlib -T $(buildDir)/linker.ld

realModeSource = $(shell find $(sourceDir) -type f -name '*.real')
DSource = $(shell find $(sourceDir) -type f -name '*.d')
ASMSource = $(shell find $(sourceDir) -type f -name '*.asm')

binaries = $(realModeSource:.real=.bin)
objects = $(DSource:.d=.o) $(ASMSource:.asm=.o)

.PHONY: all iso test clean

all: $(binaries) $(objects)
	@echo "\033[0;35mLinking\033[0m '$(image)'..."
	@$(LD) $(LDFLAGS) $(objects) -o $(image)

%.o: %.d
	@echo "\033[0;35m$(DC)\033[0m '$@'..."
	@$(DC) $(DFLAGS_INTERNAL) -c $< $@

%.o: %.asm
	@echo "\033[0;35m$(AS)\033[0m '$@'..."
	@$(AS) $< -f elf64 -o $@

%.bin: %.real
	@echo "\033[0;35m$(AS) (Real mode)\033[0m '$@'..."
	@$(AS) $< -f bin -o $@

iso: all
	@mkdir -p isodir/boot/grub
	@cp $(image) isodir/boot/$(image)
	@cp $(buildDir)/grub.cfg isodir/boot/grub/grub.cfg
	@sed -i "s/NAME/$(kernel)/g" isodir/boot/grub/grub.cfg
	@sed -i "s/IMAGE/$(image)/g" isodir/boot/grub/grub.cfg
	@grub-mkrescue -o $(ISO) isodir
	@rm -rf isodir

test: iso
	@qemu-system-x86_64 -m 2G -net none -enable-kvm -monitor stdio \
	-drive file=$(ISO),index=0,media=disk,format=raw \
	-cpu host -d cpu_reset

clean:
	@rm -f $(objects) $(binaries) $(image) $(ISO)
