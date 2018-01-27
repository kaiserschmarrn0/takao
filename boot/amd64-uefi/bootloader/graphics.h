// File: graphics.h
//
// Description: Main header of graphics.c
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#pragma once

#include "utils.h"
#include "uefifunc.h"

#define GRAPHICS_MOST_APPROPRIATE_H 1080
#define GRAPHICS_MOST_APPROPRIATE_W 1920

struct graphics {
	EFI_GRAPHICS_OUTPUT_PROTOCOL         *protocol;
	uint32_t                             mode_id;
	EFI_GRAPHICS_OUTPUT_MODE_INFORMATION output_mode;
	void*                                buffer_base;
	uint64_t                             buffer_size;
};

// must be called while boot services are available.
EFI_STATUS init_graphics(const struct uefi *uefi, struct graphics *gs);
void set_pixel(const struct graphics *gs, int w, int h, uint32_t rgb);
