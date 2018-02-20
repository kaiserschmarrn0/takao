// serial.hpp

// Description: Serial port driver

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#pragma once

#include "../../lib/lib.hpp"
#include <stdarg.h>

namespace serial_port {
    void init(void);
    uint64_t port_write(uint8_t *buffer, uint64_t size);
    int puts(const char *print);
    void printf(char* format,...);
}