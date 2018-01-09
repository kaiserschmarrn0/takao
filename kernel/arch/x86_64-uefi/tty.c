// File: tty.c
//
// Description: TTY driver
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "../../includes/tty.h"
#include "archmain.h"
#include "font.h"

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

KABI void put_char(char c, uint8_t x, uint8_t y, uint32_t rgb) 
{
	uint8_t i,j;

	// Convert the character to an index
	c = c & 0x7F;
	if (c < ' ') {
		c = 0;
	} else {
 		c -= ' ';
	}

	// 'font' is a multidimensional array of [96][char_width]
	// which is really just a 1D array of size 96*char_width.
	const uint8_t* chr = font[c*CHAR_WIDTH];

	// Draw pixels
	for (j=0; j<CHAR_WIDTH; j++) {
		for (i=0; i<CHAR_HEIGHT; i++) {
			if (chr[j] & (1<<i)) {
				set_pixel(x+j, y+i, rgb);
			}
		}
	}
}

KABI void put_string(const char* str, uint8_t x, uint8_t y, uint32_t rgb) 
{
	while (*str) {
		put_char(*str++, x, y, rgb);
		x += CHAR_WIDTH;
	}
}

// tty_init: Cleans the screen and setup all.
KABI void tty_init(void)
{
	// Colors
	uint32_t r = 64 << 16;
	uint32_t g = 64 << 8;
	uint32_t b = 64;

	put_char("c", 1, 1, r | g | b);
}
