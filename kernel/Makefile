#File distributed under the LICENSE of the package (GNU GPL V3)
#Check LICENSE for more information

#Kernel version details
VERS=0-0-6-2
KERNEL=cka
FINALFILE=$(KERNEL)$(VERS)
NICKNAME="prophet"

# C compìler (the use of gcc and flags)
CC=clang
CFLAGS_ARCHDEPENDENT=-I/usr/include/efi -I/usr/include/efi/x86_64 -I/usr/include/efi/protocol -fno-stack-protector -fpic -fno-builtin -fshort-wchar -mno-red-zone -DHAVE_USE_MS_ABI -Wall -Wextra -c -o
CFLAGS_ARCHINDEPENDENT=-ffreestanding -fno-stack-protector -fpic -fno-builtin -fshort-wchar -mno-red-zone -DHAVE_USE_MS_ABI -Wall -Wextra -c -o
CFLAGS_MAIN=-ffreestanding -fno-stack-protector -fpic -fno-builtin -fshort-wchar -mno-red-zone -DHAVE_USE_MS_ABI -Wall -Wextra -c -o
CFLAGS_LIBK=-ffreestanding -fno-stack-protector -fpic -fno-builtin -fshort-wchar -mno-red-zone -DHAVE_USE_MS_ABI -Wall -Wextra -c -o

# Linker (choosed program with flags)
LD=ld.lld-5.0
LD_FILE_GLOBAL=
LDFLAGS_GLOBAL=-nostdlib -znocombreloc -T /usr/lib/elf_x86_64_efi.lds -shared -Bsymbolic -L /usr/lib /usr/lib/crt0-efi-x86_64.o
LDFINALFLAGS_GLOBAL=-lefi -lgnuefi

# objcopy flags and etc
OBJCOPY=objcopy
OBJCOPYFLAGS_GLOBAL=-j .text -j .sdata -j .data -j .dynamic -j .dynsym  -j .rel -j .rela -j .reloc --target=efi-app-x86_64 

# the archiver and all the flags
AR=llvm-ar
ARFLAGS_ARCHDEPENDENT=rcs
ARFLAGS_ARCHINDEPENDENT=rcs
ARFLAGS_MAIN=
ARFLAGS_LIBK=rcs

# Qemu options and etc.
QEMU=qemu-system-x86_64
QEMUFLAGS=-L OVMF_dir/ -bios OVMF.fd -usb 
QEMUFINALFLAGS=-enable-kvm -m 64 -serial file:debug.log -device VGA 

# All about the files of the kernel, with empty lanes to separate:
ARCHDEPENDENT=x86_64-uefi/archmain.o \
	x86_64-uefi/lowpanic.o \
	x86_64-uefi/uefifunc.o \
	x86_64-uefi/cpu.o \
	x86_64-uefi/graphics.o \
	x86_64-uefi/set_pixel.o \
	x86_64-uefi/gdt.o \
	x86_64-uefi/ioport.o \
	x86_64-uefi/paging.o \
	x86_64-uefi/memmap.o \

ARCHINDEPENDENT=highpanic.o \
		serial.o 

MAIN=main.o 

LIBK=string/memcmp.o \
	string/memcpy.o \
	string/memset.o \
	string/strlen.o \
	string/strcpy.o \
	string/strcat.o \
	\
	stdio/sprintf.o \
	\
	stdlib/rand.o

ARCHDEPENDENT_FINAL=archdependent.a
ARCHINDEPENDENT_FINAL=archindependent.a
MAIN_FINAL=main.o
LIBK_FINAL=libk.a

FINALOBJ=build/$(ARCHDEPENDENT_FINAL) \
	build/$(ARCHINDEPENDENT_FINAL)\
	build/$(MAIN_FINAL) \
	build/$(LIBK_FINAL) 

BUILDDIR=build

# export all
export

.PHONY: prepare archdependent.a archindependent.a main.o libk.a all clean

# prepare : prepare some things before compilation
prepare:
	mkdir $(BUILDDIR)

# archindependent : calls "make all" in the 'arch' makefile
archdependent.a:
	cd arch && make all
	@echo ""
	@echo "$(ARCHDEPENDENT_FINAL) ready!"
	@echo ""

# archindependent : calls "make all" in the 'common' makefile
archindependent.a:
	cd common && make all
	@echo ""
	@echo "$(ARCHINDEPENDENT_FINAL) ready!"
	@echo ""

# main.o : calls "make all" in the 'main' makefile to make a .o archive
main.o:
	cd main && make all
	@echo ""
	@echo "$(MAIN_FINAL) ready!"
	@echo ""

# libk.a : calls "make all" in the 'libk' makefile to make a .a archive.
libk.a:
	cd libk && make all
	@echo ""
	@echo "$(LIBK_FINAL) ready!"
	@echo ""

# all : calls all the needed functions to provide a final product
all: archdependent.a archindependent.a main.o libk.a
	@echo ""
	@echo "        Compiling done"
	@echo "Linking object files..."
	@$(LD) $(LDFLAGS_GLOBAL) $(FINALOBJ) -o $(FINALFILE).bin $(LDFINALFLAGS_GLOBAL)
	@echo "        Linking done"
	@echo "'Objcopying' the images into a .efi application"
	@$(OBJCOPY) $(OBJCOPYFLAGS_GLOBAL) $(FINALFILE).bin $(FINALFILE).efi
	@echo "Build finished"
	@echo ""
	@echo "*NOTE: All the warnings related to end of non-void functions are harmless"
	@echo ""
	@echo "\033[92m$(KERNEL) $(VERS) ($(NICKNAME)) ready!\033[0m"
	@echo ""
	@echo "Now you should try the image with the command 'make test-qemu'"
	@echo "or type 'make fat-image' to make a fat disk image ready to burn and use."
	@echo ""

# fat-image: creates a fat-image using dd and other commands for testing purposes for example
fat-image:
	dd if=/dev/zero of=fat.img bs=1k count=1440
	mformat -i fat.img -f 1440 ::
	mmd -i fat.img ::/EFI
	mmd -i fat.img ::/EFI/BOOT
	mcopy -i fat.img $(FINALFILE).efi ::/EFI/

	@echo ""
	@echo "\033[92mFAT image ready, search for fat.img in the root of the source\033[0m"
	@echo "\033[92mdirectory\033[0m"
	@echo ""

# test-qemu: tests the fat-image
test-qemu: fat-image
	$(QEMU) $(QEMUFLAGS) -usbdevice disk::fat.img $(QEMUFINALFLAGS)

# clean : cleans the source code by calling the individual makefiles
clean:
	cd arch && make clean
	cd common && make clean
	cd main && make clean
	cd libk && make clean
	rm -rf fat.img
	rm -rf debug.log
	rm -rf $(FINALFILE).bin
	rm -rf $(FINALFILE).efi
	rm -rf common/handlerconventions.h
	rm -rf $(BUILDDIR)
