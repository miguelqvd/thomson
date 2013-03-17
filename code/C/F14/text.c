/*
 * Copyright 2013, Adrien Destugues <pulkomandy@pulkomandy.tk>
 * Distributed under the terms of the MIT licence
 *
 * Text printing routines for F-14 (easily reusable...)
 *
 * A character is stored as 8 bytes
 * This code assumes that the color RAM is set properly and does not modify it.
 *
 * Each char is stored as 8 bytes, they can be copied on the screen (no masking)
 * To erase a char, just store 0s over the 8 bytes. Easy.
 *
 * TODO: optimize this ! Should be easy to get it way faster by using asm code...
 */

#include "text.h"

extern uint8_t font[];

/* x in bytes [0..39]
 * y in pixel-lines [0..192]
 */
void drawchar(char c, uint8_t x, uint8_t y)
{
	uint8_t* ptr = &font[(c-32) * 8];
	uint8_t* dest = (uint8_t*)(y * 40 + x);

	*dest     = *ptr++;
	*(dest+40)  = *ptr++;
	*(dest+80)  = *ptr++;
	*(dest+120) = *ptr++;
	*(dest+160) = *ptr++;
	*(dest+200) = *ptr++;
	*(dest+240) = *ptr++;
	*(dest+280) = *ptr++;
}

void drawstring(const char* str, uint8_t x, uint8_t y)
{
	int inix = x;
	while(*str != 0)
	{
		if(*str == '\n') {
			x = inix;
			y += 8;
			str++;
			continue;
		}

		drawchar(*str++, x++, y);
	}
}
