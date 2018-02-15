// bootmain-inc.h

// Description: Includes of the bootloader main function

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#pragma once

#include "uefifunc.h"
#include "graphicsmode.h"

// A struct for storing some info
struct bootmain {
	struct uefi     uefi;
	struct graphics_info graphics_info;
};