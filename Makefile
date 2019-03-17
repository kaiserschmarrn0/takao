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

DFLAGS = -O2

LDFLAGS = --oformat elf_amd64 --Bstatic --nostdlib -T $(buildDir)/linker.ld

DFLAGS_INTERNAL := $(DFLAGS) -mtriple=x86_64-elf -relocation-model=static \
	-code-model=kernel -mattr=-sse,-sse2,-sse3,-ssse3 -disable-red-zone \
	-betterC -op -I=./source

QEMU_FLAGS := -m 5G -net none \
	-drive file=$(ISO),index=0,media=disk,format=raw \

ifneq ($(DEBUG), on)
QEMU_FLAGS := $(QEMU_FLAGS) -monitor stdio
endif

ifeq ($(DEBUG), on)
DFLAGS_INTERNAL := $(DFLAGS_INTERNAL) -gc -d-debug=1
QEMU_FLAGS := $(QEMU_FLAGS) -debugcon stdio
endif

ifeq ($(KVM), on)
QEMU_FLAGS := $(QEMU_FLAGS) -enable-kvm -cpu host
endif

realModeSource = $(shell find $(sourceDir) -type f -name '*.real')
dSource = $(shell find $(sourceDir) -type f -name '*.d')
asmSource = $(shell find $(sourceDir) -type f -name '*.asm')

binaries = $(realModeSource:.real=.bin)
objects = $(dSource:.d=.o) $(asmSource:.asm=.o)

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
	@qemu-system-x86_64 $(QEMU_FLAGS)

clean:
	@rm -f $(objects) $(binaries) $(image) $(ISO)
