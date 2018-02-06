# File: Makefile ( amd64-uefi kernel )
#
# Description: Makefile of the amd64 arch specifics
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

archobj = io/ports.o \
	cpu/cpucheck.o \
	mem/init.o \
	mem/paging.o

# export all
export

.PHONY: compile

compile: $(archobj)

# Rule: .cpp archives
%.o: %.cpp
	@echo Compiling $<
	@$(cppcompiler) $(cppflags_arch) -c $< -o $@
	@mv $@ $(builddir)/objects