// File: set_pixel.c
//
// Description: Provides a freestanding interface for using graphic output of graphics.c
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "../../includes/set_pixel.h"
#include "archmain.h"

struct archmain archmain;

KABI void set_pixel(int w, int h, uint32_t rgb)
{
	set_pixel_GOP(&archmain.graphics, w, h, rgb);
}