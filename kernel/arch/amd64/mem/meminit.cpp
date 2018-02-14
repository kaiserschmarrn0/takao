// init.cpp

// Description: Inits all the things needed by the mem allocation

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#include <mem/init.hpp>
#include "paging.hpp"
#include "gdt.hpp"

void mem::init(void)
{
	// Init GDT
	gdt_init();
	
	// Init paging (paging.cpp/hpp)
	paging_init();
}

