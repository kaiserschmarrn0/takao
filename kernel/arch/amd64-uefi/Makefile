# File: Makefile ( amd64-uefi kernel )
#
# Description: Makefile of the amd64 arch specifics
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

cppflags_arch = -fno-stack-protector -fpic -fno-builtin \
	-fno-builtin-fshort-wchar -mno-red-zone -fno-exceptions -fno-rtti -c -o

archobj = ioport.o \
	cpu/cpucheck.o

# export all
export

.PHONY: all clean

all: $(archobj)
	@echo "Copy the archives to output"
	cp $(archobj) ../../../$(builddir)/
	@echo ""

clean:
	rm -rf $(archobj)

# Rule: .cpp archives
%.o: %.cpp
	@echo Compiling $<
	@$(cppcompiler) $(cppflags_arch) -c $< -o $@