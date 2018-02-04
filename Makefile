# File: Makefile ( Global one )
#
# Description: Makefile of the project
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

# First define the kernel version and etc, this is overrided, and cant be
# modified by command line.

#Dont blame me for that comments, makefile behaves weird when inline comments
override kernel_name = Takao# Kernel name
override kernel_vers = ALPHA# Kernel version
override kernel_nick = kensei# Kernel nickname
override kernel_file = $(kernel_name)$(kernel_vers)# Name of the final file (no extension)

# Now lets start
.EXPORT_ALL_VARIABLES:
.PHONY: all

ifeq ($(strip $(builddir)), )
# builddir is not set, so we print a small how to.

all:
	@echo ""
	@echo "Welcome to $(kernel_name) build! But you are doing it wrong!"
	@echo "Do the following to prepare and build $(kernel_name)."
	@echo ""
	@echo "  1. Run 'make builddir=<absolute path of nonexisting directory>'"
	@echo "     The directory will be used exclusively to build the system"
	@echo "  2. Cd into the specified build directory"
	@echo "  3. Verify the settings in makeconf.local"
	@echo "  4. Run 'make all' again"
	@echo "";
	@exit 0

else ifeq ($(strip $(srcdir)), )
# builddir is set, not the case of srcdir, so we use the specified build dir

all:
	@echo ""
	@# Check if the path is absolute or not, exit if not. 
	@if [ "/" != "`echo $(builddir) | cut -c1`" ]; then \
		echo "$(builddir) is not an absolute path"; \
		echo ""; \
		echo "exiting with error code 1..."; \
		echo ""; \
		exit 1; \
	fi

	@# Check if the dir exist, if it exist exit.
	@if [ -d $(builddir) ]; then \
		echo "$(builddir) exist already! Use a non existent directory"; \
		echo ""; \
		echo "exiting with error code 1..."; \
		echo ""; \
		exit 1; \
	fi

	@# The builddir is fine, now we create it
	mkdir -p $(builddir)

	@# Now lets start with the build

	@# Now we will copy the config template (in build/template) to the builddir
	@cp -r build/template/* $(builddir)

	@# Adjust the makeconfig.template and make a makeconfig.local, remove template
	@(grep -v srcdir $(builddir)/makeconfig.template ; \
	  echo "srcdir = $(CURDIR)") >> $(builddir)/makeconfig.local
	@rm -f $(builddir)/makeconfig.template

	@# The end of the setup.
	@echo ""
	@echo "Directory prepared for build, change to it."
	@echo ""
	
else
# scrdir and builddir are set, lets start the real build

compile: 
	mkdir -p $(builddir)/objects
	cd boot/$(arch)-$(firmware) && $(MAKE) compile
	cd kernel && $(MAKE) compile

link:
	$(linker) $(linker_flags) $(builddir)/objects/* -o $(builddir)/$(kernel_file).bin

image:
	cd build/images && $(MAKE) -f finalimages-$(arch)-$(firmware).make

test:
	cd build/test && $(MAKE) -f test-$(arch)-$(firmware).make

all: compile link image

endif