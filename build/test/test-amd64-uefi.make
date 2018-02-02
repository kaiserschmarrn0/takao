# File: finalfile-amd64-uefi.make
#
# Description: Makefile of arch images
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

.PHONY: test-qemu

test-qemu:
	qemu-system-x86_64 -L OVMF_dir/ -bios OVMF.fd -usb -usbdevice disk::$(builddir)/fat.img \
	-enable-kvm -m 64 -serial file:$(builddir)/debug.log -device VGA