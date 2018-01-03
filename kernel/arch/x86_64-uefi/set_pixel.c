//File distributed under the LICENSE of the package (GNU GPL V3)
//Check LICENSE for more information

#include "../../includes/set_pixel.h"
#include "archmain.h"

struct archmain archmain;

KABI void set_pixel(int w, int h, uint32_t rgb)
{
	set_pixel_GOP(&archmain.graphics, w, h, rgb);
}