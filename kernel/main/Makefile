# File: Makefile ( main folder one )
#
# Description: Makefile of the main kernel files
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

main = main.o

.PHONY: compile

compile: $(main)

# Rule: .cpp archives
%.o: %.cpp
	@echo Compiling $<
	@$(cppcompiler) $(cppflags_main) -c $< -o $@
	@mv $@ $(builddir)/objects