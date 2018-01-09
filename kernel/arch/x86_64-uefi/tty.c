// File: tty.c
//
// Description: TTY driver
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "../../includes/tty.h"
#include "archmain.h"

struct archmain archmain;

// set_pixel: Just a the setpixel function but without needing to cast a redundant struct.
KABI void set_pixel(int w, int h, uint32_t rgb);
// draw_line: Draws a line between 2 points defined with x and y coordinates.
KABI void draw_line(int x1, int y1, int x2, int y2, uint32_t rgb);
// draw_rect: Draws some rectangles given 2 points defined with x and y coordinates.
KABI void draw_rect(int x1, int y1, int x2, int y2, uint32_t rgb);

KABI void set_pixel(int w, int h, uint32_t rgb)
{
	set_pixel_GOP(&archmain.graphics, w, h, rgb);
} 

KABI void draw_line(int x1, int y1, int x2, int y2, uint32_t rgb)  
{
    int delta_y = y2 - y1;
    int delta_x = x2 - x1;
   	if (x1 != x2) /* The line it's not vertical */
    	if (x1 < x2) /* A line that goes from x1 to x2 */
    	{
    		/* Apply the general law for lines */ 
    		for (int x = x1; x < x2; x++){
    			int y = y1 + delta_y * (x - x1) / delta_x;
    			set_pixel(x, y, rgb);
    		}
    	}
    	if (x1 > x2) /* A line that goes from x2 to x1 */
    	{
    		/* Apply the general law for lines */ 
    		for (int x = x2; x < x1; x++){
    			int y = y2 + delta_y * (x - x2) / delta_x;
    			set_pixel(x, y, rgb);
    		}
    	}
    if (x1 == x2) /* Vertical line */
    	{
    		if (y1 < y2)
    		{
    			while (y1 <= y2){
    				set_pixel(x1, y1, rgb);
    				y1 ++;
    			}
    		}
    		if (y1 > y2)
    		{
    			while (y1 >= y2){
        			set_pixel(x2, y2, rgb);
                	y2 ++;
        		}
    		}
    }
}

KABI void draw_rect(int x1, int y1, int x2, int y2, uint32_t rgb)
{
	draw_line(x1, y1, x1, y2, rgb);
	draw_line(x2, y2, x2, y1, rgb);
	draw_line(x1, y1, x2, y1, rgb);
	draw_line(x1, y2, x2, y2, rgb);
}

// tty_init: Cleans the screen and setup all.
KABI void tty_init(void)
{
	// Colors
	uint32_t r = 64 << 16;
    uint32_t g = 64 << 8;
    uint32_t b = 64;

    // Fill the screen
    fill_screen_GOP(&archmain.graphics, r | g | b);
}