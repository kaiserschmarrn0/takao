# Makefile

# Description: Makefile of the build dir

# Copyright 2016 The Takao Authors (AUTHORS.md). All rights reserved.
# Use of this source code is governed by a license that can be
# found in the LICENSE.md file, in the root directory of
# the source package.

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
	
