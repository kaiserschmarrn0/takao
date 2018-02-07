# test-amd64-uefi.make

# Description: Test of the arch

# Copyright 2016 The Takao Authors (AUTHORS.md). All rights reserved.
# Use of this source code is governed by a license that can be
# found in the LICENSE.md file, in the root directory of
# the source package.

.PHONY: test-qemu

test-qemu:
	qemu-system-x86_64 -L OVMF_dir/ -bios OVMF.fd -usb -usbdevice disk::$(builddir)/fat.img \
	-enable-kvm -m 64 -serial file:$(builddir)/debug.log -device VGA