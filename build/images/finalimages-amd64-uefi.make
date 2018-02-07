# finalimages-amd64-uefi.make

# Description: Image gen of the arch

# Copyright 2016 The Takao Authors (AUTHORS.md). All rights reserved.
# Use of this source code is governed by a license that can be
# found in the LICENSE.md file, in the root directory of
# the source package.

.PHONY: images

images:
	objcopy -j .text -j .sdata -j .data -j .dynamic -j .dynsym  -j .rel -j .rela -j .reloc \
	--target=efi-app-x86_64 $(builddir)/$(kernel_file).bin $(builddir)/$(kernel_file).efi
	
	@dd if=/dev/zero of=$(builddir)/fat.img bs=1k count=1440
	@mformat -i $(builddir)/fat.img -f 1440 ::
	@mmd -i $(builddir)/fat.img ::/EFI
	@mmd -i $(builddir)/fat.img ::/EFI/BOOT
	@mcopy -i $(builddir)/fat.img $(builddir)/$(kernel_file).efi ::/EFI/