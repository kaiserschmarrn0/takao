// syscall.hxx

// Description: Interrupts and other syscalls.

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#pragma once

#include "../lib/lib.hxx"

namespace syscall {}

#include "syscall/idt.hxx"
#include "syscall/handlers/int32.hxx"

