# File: Makefile (template one)
#
# Description: Makefile of the build dir
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

.EXPORT_ALL_VARIABLES:

# Variables and etc.
include makeconfig.local

# Now the flags, compilers, etc.
include build/$(arch)/$(arch).config
include build/$(arch)/$(arch)flags.config
include build/$(arch)/$(arch)-$(firmware)-bootflags.config

.PHONY: config all

config:
	@echo "Using makeconf.local as configuration"

all:
	cd $(srcdir) && $(MAKE) all

test:
	cd $(srcdir) && $(MAKE) test
	
