// init.hpp

// Description: Init all memory things before any allocation

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#pragma once

#include "../mem.hpp"
#include "../../main/bootinfo.h"

namespace mem {
	void init(struct bootinfo *bootinfo);
}