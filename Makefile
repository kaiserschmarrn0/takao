# Makefile - makefile of the project
# (C) 2019 the takao authors (AUTHORS.md). All rights reserved
# This code is governed by a license that can be found in LICENSE.md

override kernel = takao
override image = $(kernel).elf
override ISO = $(kernel).iso

override sourceDir = $(realpath source)
override buildDir = $(realpath build)

DC = dmd
LD = ld
AS = nasm

DFLAGS = -betterC -op -I=$(sourceDir)
LDFLAGS = -nostdlib -T $(buildDir)/linker.ld

DSource = $(shell find $(sourceDir) -type f -name '*.d')
ASMSource = $(shell find $(sourceDir) -type f -name '*.asm')

objects = $(DSource:.d=.o) $(ASMSource:.asm=.o)

.PHONY: all iso test clean

all: $(binaries) $(objects)
	@echo "\033[0;35mLinking\033[0m '$(image)'..."
	@$(LD) $(LDFLAGS) $(objects) -o $(image)

%.o: %.d
	@echo "\033[0;35mCompiling\033[0m '$<' into '$@'..."
	@$(DC) $(DFLAGS) -c $< $@

%.o: %.asm
	@echo "\033[0;35mCompiling\033[0m '$<' into '$@'..."
	@$(AS) $< -f elf64 -o $@

iso: all
	mkdir -p isodir/boot/grub
	cp $(image) isodir/boot/$(image)
	cp $(buildDir)/grub.cfg isodir/boot/grub/grub.cfg
	sed -i "s/NAME/$(kernel)/g" isodir/boot/grub/grub.cfg
	sed -i "s/IMAGE/$(image)/g" isodir/boot/grub/grub.cfg
	grub-mkrescue -o $(ISO) isodir
	rm -rf isodir

test: iso
	qemu-system-x86_64 -m 2G -net none -enable-kvm -monitor stdio \
	-drive file=$(ISO),index=0,media=disk,format=raw \
    -cpu host

clean:
	rm -rf $(objects) $(binaries) $(image) $(ISO)
