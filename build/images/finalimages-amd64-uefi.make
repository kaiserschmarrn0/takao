# File: finalfile-amd64-uefi.make
#
# Description: Makefile of arch images
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

.PHONY: images

images:
	objcopy -j .text -j .sdata -j .data -j .dynamic -j .dynsym  -j .rel -j .rela -j .reloc \
	--target=efi-app-x86_64 $(builddir)/$(kernel_file).bin $(builddir)/$(kernel_file).efi
	
	@dd if=/dev/zero of=$(builddir)/fat.img bs=1k count=1440
	@mformat -i $(builddir)/fat.img -f 1440 ::
	@mmd -i $(builddir)/fat.img ::/EFI
	@mmd -i $(builddir)/fat.img ::/EFI/BOOT
	@mcopy -i $(builddir)/fat.img $(builddir)/$(kernel_file).efi ::/EFI/