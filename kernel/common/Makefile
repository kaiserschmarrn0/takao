# File: Makefile ( common )
#
# Description: Makefile of the main kernel files
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

common = io/serial.o \
	err/panic.o

.PHONY: compile

compile: $(common)

# Rule: .cpp archives
%.o: %.cpp
	@echo Compiling $<
	@$(cppcompiler) $(cppflags_common) -c $< -o $@
	@mv $@ $(builddir)/objects