# Makefile - makefile of the project
# (C) 2019 the takao authors (AUTHORS.md). All rights reserved
# This code is governed by a license that can be found in LICENSE.md

override kernel = takao
override image  = $(kernel).elf
override ISO    = $(kernel).iso

override sourceDir = source
override buildDir  = build

DC = ldc2
LD = ld.lld
AS = nasm

DFLAGS = -O2

LDFLAGS = -O2 -gc-sections

QEMUFLAGS = -m 2G

DFLAGS_INTERNAL := $(DFLAGS) -mtriple=x86_64-elf -relocation-model=static \
	-code-model=kernel -mattr=-sse,-sse2,-sse3,-ssse3 -disable-red-zone \
	-betterC -op -I=./source -d-version=amd64

LDFLAGS_INTERNAL := $(LDFLAGS) --oformat elf_amd64 --Bstatic --nostdlib \
    -T $(buildDir)/linker.ld

QEMUFLAGS_INTERNAL := $(QEMUFLAGS) \
	-drive file=$(ISO),index=0,media=disk,format=raw \

ifeq ($(DEBUG), on)
DFLAGS_INTERNAL := $(DFLAGS_INTERNAL) -gc -d-debug=1

QEMUFLAGS_INTERNAL := $(QEMUFLAGS_INTERNAL) -debugcon stdio
endif

ifeq ($(KVM), on)
QEMUFLAGS_INTERNAL := $(QEMUFLAGS_INTERNAL) -enable-kvm -cpu host
endif

realModeSource = $(shell find $(sourceDir) -type f -name '*.real')
dSource        = $(shell find $(sourceDir) -type f -name '*.d')
asmSource      = $(shell find $(sourceDir) -type f -name '*.asm')

binaries = $(realModeSource:.real=.bin)
objects  = $(dSource:.d=.o) $(asmSource:.asm=.o)

.PHONY: all iso test clean

all: $(binaries) $(objects)
	@printf "\e[0;35m$(LD)\e[0m '$(image)'...\n"
	@$(LD) $(LDFLAGS_INTERNAL) $(objects) -o $(image)

%.o: %.d
	@printf "\e[0;35m$(DC)\e[0m '$@'...\n"
	@$(DC) $(DFLAGS_INTERNAL) -c $< $@

%.o: %.asm
	@printf "\e[0;35m$(AS)\e[0m '$@'...\n"
	@$(AS) $< -f elf64 -o $@

%.bin: %.real
	@printf "\e[0;35m$(AS) (Real mode)\e[0m '$@'...\n"
	@$(AS) $< -f bin -o $@

iso: all
	mkdir -p isodir/boot/grub
	cp $(image) isodir/boot/$(image)
	cp $(buildDir)/grub.cfg isodir/boot/grub/grub.cfg
	sed -i "s/NAME/$(kernel)/g" isodir/boot/grub/grub.cfg
	sed -i "s/IMAGE/$(image)/g" isodir/boot/grub/grub.cfg
	grub-mkrescue -o $(ISO) isodir
	rm -rf isodir

test: iso
	qemu-system-x86_64 $(QEMUFLAGS_INTERNAL)

clean:
	rm -f $(objects) $(binaries) $(image) $(ISO)
