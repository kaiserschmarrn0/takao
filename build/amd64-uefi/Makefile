# File: Makefile ( amd64-uefi )
#
# Description: Makefile of the project (amd64-uefi branch)
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

linkerfile = linker/elf.lds
linker_flags = -nostdlib -znocombreloc -T $(linkerfile) -shared -Bsymbolic

objcopy_flags = -j .text -j .sdata -j .data -j .dynamic -j .dynsym  -j .rel -j .rela -j .reloc --target=efi-app-x86_64

qemu = qemu-system-x86_64 
qemu_flags = -L OVMF_dir/ -bios OVMF.fd -usb 
qemu_flags_final = -enable-kvm -m 64 -serial file:../../output/debug.log -device VGA

# export all
export

.PHONY: bootloader kernel all clean test-qemu

bootloader:
	# First we will build the bootloader
	cd .. && cd .. && cd boot && cd amd64-uefi && make all

kernel:
	# Now the kernel
	cd .. && cd .. && cd kernel && make all

all: bootloader kernel
	@echo "Linking..."
	$(linker) $(linker_flags) ../../output/* -o ../../output/$(FINALFILE).bin
	@echo "Objcopy..."
	$(objcopy) $(objcopy_flags) ../../output/$(FINALFILE).bin ../../output/$(FINALFILE).efi

clean:
	# Call the bootloader clean
	cd .. && cd .. && cd boot && cd amd64-uefi && make clean

	# Now the kernel
	cd .. && cd .. && cd kernel && make clean

fat-image:
	dd if=/dev/zero of=../../output/fat.img bs=1k count=1440
	mformat -i ../../output/fat.img -f 1440 ::
	mmd -i ../../output/fat.img ::/EFI
	mmd -i ../../output/fat.img ::/EFI/BOOT
	mcopy -i ../../output/fat.img ../../output/$(FINALFILE).efi ::/EFI/

test-qemu: fat-image
	$(qemu) $(qemu_flags) -usbdevice disk::../../output/fat.img $(qemu_flags_final)
