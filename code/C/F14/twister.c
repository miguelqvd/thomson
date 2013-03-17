#include "effect.h"

asm("\n"
"	.area .text \n"
"	INCLUDEBIN ../TWI03.CRU \n"
"color_twi		\n"
"	INCLUDEBIN ../TWI01.CRU \n"
"forme_twi		\n"
);

extern unsigned char SIN[256];

uint8_t backbuffer[256*32];

static void line(uint8_t x1, int y, uint8_t x2, char color)
{
	static const uint8_t start[] = {0xFF, 0x7F, 0x3F, 0x1F, 0x0F, 0x07, 0x03, 0x01};
	static const uint8_t end[] = {0x80, 0xC0, 0xE0, 0xF0, 0xF8, 0xFC, 0xFE, 0xFF};
	int x;
	if(x1 > x2) return;
	y *= 32;

	x = start[x1 & 7] & color;
	backbuffer[y + (x1>>3)] |= x;

	for(x = (x1>>3) +1; x < x2>>3; x++)
		backbuffer[y + x] = color;

	x = end[x2 & 7] & color;
	backbuffer[y + (x2>>3)] |= x;
}

void init_T()
{
	int y;

	for(y = 0; y < 128*32; y++)
	{
		((uint16_t*)backbuffer)[y] = 0;
	}

	for(y = 0; y < 256; y++)
	{
		uint8_t x1, x2, x4;

		// draw the twister on top of that
		// Minimal offset is 44 (we don't draw more than that on screen)
		// For a "standard" twister use:	SIN	OFF
		x1 = SIN[(y + 64) %256]/2 + 64; // 	+64  +64
		x2 = SIN[y            ]/2 + 64;	// 	+0   +64
		x4 = SIN[(y + 128)%256]/2 + 64; // 	+128 +64

		// Draw top part
		line(x1,y,x4,0xFF);
		line(x2,y,x1,0x55);
		// Draw bottom part
		line(255-x1,255-y,255-x2,0xFF);
		line(255-x4,255-y,255-x1,0x55);
	}

	// TODO we might as well load a texture, it will look nicer anyway
	// unless we add some animations to the color ram as well (machine time ?)
#if 0
	couleur();
	for(y = 0; y < 200; y++)
	{
		for(x = 8; x < 24; x++)
	   		screen[y*40 + x] = (x ^ y/8) & 0x4 ? 0x70:0xE4;
	   	screen[y*40 + 7] = 0x80;
	   	screen[y*40 + 24] = 0x80;
	}

	// TODO for this one it's definitely worth using a texture
	forme();
	for(y = 0; y < 200; y++)
	{
		screen[y * 40 + 7] = 0xFF;
		screen[y * 40 + 24] = 0xFF;
	}
#endif

	asm(
		" LDX #color_twi-1		\n"
		" LDU #forme_twi-1		\n"
		" LBSR decrunchpic			\n"
		:::"x","u", "y");
	
}

void draw_T(int frame)
{
	uint8_t x,y;
	int y40;
	uint16_t* scr16 = (uint16_t*)screen;
	uint16_t* bck16 = (uint16_t*)backbuffer;
	forme();

	y40 = 0;
	for(y = 0; y < 200; y++)
	{
		const uint8_t line = (y/4 + SIN[frame & 0xFF] + SIN[(frame / 4 + y / 4) & 0xFF]);
		for(x=4 ;x < 12; x++)
		{
			scr16[y40 + x] = bck16[(uint16_t)line * 16 + x];
			//screen[y40 + x] = backbuffer[(uint16_t)line * 32 + x];
		}

		y40 += 20;
	}
}
