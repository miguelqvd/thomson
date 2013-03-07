/* Fast and inexact trigonometry routines
 * Copyright 2013, Adrien Destugues <pulkomandy@pulkomandy.tk>
 *
 * This file is distributed under the terms of the MIT licence
 */
#include <stdint.h>


unsigned char SIN[512];

// TODO rewrite this in assembler and optimize it ! It should be possible to get
// a very small code for it. Fast doesn't really matter as this is called once
// at demo init.

/**
 * Generate an approximation of a sine wave using a polynomial (x-3)²-1.
 * http://codebase64.org/doku.php?id=base:generating_approximate_sines_in_assembly
 *
 * Output is unsigned 8bit, in the range 0-255.
 * Deviates from an actual sinewave by about 6%, which is ok for dirty trig, but
 * also more interesting when you derive (get a triangle) or integrate. So this
 * adds some distorsion which is nice for plasma curves, and so on.
 *
 * Call this once, then use the SIN table to lookup your samples. We *should* be
 * using a signed char as an offset in the table, which could be used to make
 * this code a bit more 6809 optimized. For now we don't...
 */
void polysine()
{
	// Value is the computed valu of the sine at the current point.
	// Delta is the acceleration we use to build the polynomial iteratively
	uint16_t value = 0, delta = 0;
	// These are indices into the wavetable. We compute only 64 points and the
	// others are built by symetry.
	uint8_t y = 0x3F, x = 0;

	do
	{
		// Compute the value for the next point
		value += delta;
		
		// The last half of the sinewave is positive and symetric
		SIN[256 + 0xC0 + x] = SIN[0xC0 + x] = value >> 8;
		SIN[256 + 0x80 + y] = SIN[0x80 + y] = value >> 8;
		// The fist half is negative and a mirror of the last
		SIN[256 + 0x40 + x] = SIN[0x40 + x] = (value >> 8) ^ 0xFF;
		SIN[256 +        y] = SIN[       y] = (value >> 8) ^ 0xFF;

		// Increase delta (else we get a triangle wave)
		// Tweak this value if you need the sinewave to have a different amplitude
		delta += 0x10;

		// Move on to the next sample
		x++;
	} while(y-- > 0);
}
