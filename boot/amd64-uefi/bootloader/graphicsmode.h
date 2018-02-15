// graphicsmode.h

// Description: Set graphic mode

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#pragma once

#include "uefifunc.h"
#include "utils.h"

#define GRAPHICS_MOST_APPROPRIATE_H 1080
#define GRAPHICS_MOST_APPROPRIATE_W 1920

struct graphics_info {
	EFI_GRAPHICS_OUTPUT_PROTOCOL         *protocol;
	uint32_t                             mode_id;
	EFI_GRAPHICS_OUTPUT_MODE_INFORMATION output_mode;
	void*                                buffer_base;
	uint64_t                             buffer_size;
	uint32_t                             height;
	uint32_t                             width;
};

// MUST be called while boot services are available.
EFI_STATUS init_graphics(const struct uefi *uefi, struct graphics_info *gs);
