# Makefile - makefile of the project
# (C) 2019 the takao authors (AUTHORS.md). All rights reserved
# This code is governed by a license that can be found in LICENSE.md

override kernel = takao
override image  = $(kernel).elf
override ISO    = $(kernel).iso

override sourceDir = source
override buildDir  = build
override docsDir   = docs

DC = ldc2
LD = ld.lld
AS = nasm

DFLAGS = -O2 -de

LDFLAGS = -O2 -gc-sections

QEMUFLAGS = -m 2G -smp 4

DFLAGS_INTERNAL := $(DFLAGS) -mtriple=x86_64-elf -relocation-model=static \
	-code-model=kernel -mattr=-sse,-sse2,-sse3,-ssse3 -disable-red-zone \
	-betterC -op -I=$(sourceDir)/kernel

LDFLAGS_INTERNAL := $(LDFLAGS) --oformat elf_amd64 --Bstatic --nostdlib \
    -T $(buildDir)/linker.ld

QEMUFLAGS_INTERNAL := $(QEMUFLAGS) \
	-drive file=$(ISO),index=0,media=disk,format=raw \

ifeq ($(DEBUG), on)
DFLAGS_INTERNAL := $(DFLAGS_INTERNAL) -gc -d-debug

QEMUFLAGS_INTERNAL := $(QEMUFLAGS_INTERNAL) -debugcon stdio
endif

ifeq ($(DOCS), on)
DFLAGS_INTERNAL := $(DFLAGS_INTERNAL) -Dd=$(docsDir)
endif

ifeq ($(KVM), on)
QEMUFLAGS_INTERNAL := $(QEMUFLAGS_INTERNAL) -enable-kvm -cpu host
endif

realModeSource = $(shell find $(sourceDir) -type f -name '*.real')
dSource        = $(shell find $(sourceDir) -type f -name '*.d')
asmSource      = $(shell find $(sourceDir) -type f -name '*.asm')

shcolour = $(shell tput sgr0)$(shell tput setaf 5)
shreset  = $(shell tput sgr0)

binaries = $(realModeSource:.real=.bin)
objects  = $(dSource:.d=.o) $(asmSource:.asm=.o)

.PHONY: all iso test clean

all: $(binaries) $(objects)
	@echo "$(shcolour)$(LD)$(shreset) '$(image)'..."
	@$(LD) $(LDFLAGS_INTERNAL) $(objects) -o $(image)

%.o: %.d
	@echo "$(shcolour)$(DC)$(shreset) '$@'..."
	@$(DC) $(DFLAGS_INTERNAL) -c $< $@

%.o: %.asm
	@echo "$(shcolour)$(AS)$(shreset) '$@'..."
	@$(AS) $< -f elf64 -o $@

%.bin: %.real
	@echo "$(shcolour)$(AS) (Real mode)$(shreset) '$@'..."
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
	rm -rf $(objects) $(binaries) $(image) $(ISO) $(docsDir)
