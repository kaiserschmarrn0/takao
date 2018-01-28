# File: Makefile ( Global one )
#
# Description: Makefile of the project
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

#Kernel version details
override KERNELNAME = cka
override VERS = 0-0-7-2
override NICKNAME = "prophet"
override FINALFILE = $(KERNELNAME)$(VERS)

# Var work
# All of this variables can be set up with the command line
# Ex: builddir=xD to override the output default

# Build dir
override builddir = output

# Arch that we are going to build.
arch ?= amd64-uefi

# C compiler (recommended clang and gcc, for flag compatibility)
ccompiler ?= clang

# C++ compiler (recommended clang++)
cppcompiler ?= clang++

# Linker
linker ?= ld.lld-5.0

# archiver
archiver ?= llvm-ar

# Objcopy program
objcopy ?= objcopy

#######################################################
ifeq ($(arch),amd64-uefi)
buildutils = build/amd64-uefi
else
@echo "arch dont recognized, defaulting to amd64-uefi"
buildutils = build/amd64-uefi
endif

# export all
export
#######################################################
.PHONY: check-env prepare bootloader kernel all clean test-qemu

check-env:
	@echo "Output dir (respect the makefle dir): $(builddir)"
	@echo "Choosed arch : $(arch)"
	@echo "C Compiler : $(ccompiler)"
	@echo "C++ Compiler : $(cppcompiler)"
	@echo "Linker : $(linker)"
	@echo "Archiver : $(archiver)"
	@echo "Objcopy : $(objcopy)"

prepare: check-env
	@echo ""
	mkdir -p $(builddir)

bootloader: prepare
	cd $(buildutils) && make bootloader

kernel: prepare
	cd $(buildutils) && make kernel

all: prepare
	cd $(buildutils) && make all
	@echo ""
	@echo "Build finished"
	@echo ""
	@echo "\033[92m$(KERNELNAME) $(VERS) ($(NICKNAME)) ready!\033[0m"
	@echo ""

test-qemu:
	cd $(buildutils) && make test-qemu

clean:
	cd $(buildutils) && make clean
	rm -rf $(builddir)