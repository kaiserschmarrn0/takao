// ports.hxx

// Description: I/O ports

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#pragma once

#include "../../lib/lib.hxx"

namespace ioport {
	uint8_t outb(uint16_t port, uint8_t value);
	uint8_t inb(uint16_t port);
}