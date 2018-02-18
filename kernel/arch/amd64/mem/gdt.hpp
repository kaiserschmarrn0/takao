// gdt.hpp

// Description: GDT

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#pragma once

#include <lib.hpp>

void gdt_init(void);
void add_gdt_entry(uint64_t entry, uint16_t *byte);