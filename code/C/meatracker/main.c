/* MEA Tracker
 * Copyright 2013, Adrien Destugues <pulkomandy@pulkomandy.tk>
 *
 * This file is distributed under the terms of the MIT licence.
 */

#include "display.h"
#include "input.h"

volatile unsigned char* MEA_DATA = (unsigned char*)0xA7CE;
extern unsigned char music[8][16];

uint8_t isplaying = 1;

int main(void)
{
	asm(" ORCC #$50"); // Disable interrupts (cursor blink)
	refreshchannels();


	for(int frame = 0;;frame++)
	{
		if((frame & 0x3) == 0)
			input();
		
		if(isplaying)
		{
			/*
			*MEA_DATA = music[0][frame & 0xF];
			*MEA_DATA = music[1][frame & 0xF];
			*MEA_DATA = music[2][frame & 0xF];
			*MEA_DATA = music[3][frame & 0xF];
			*/

			*(MEA_DATA + 1) = 0x12;
			*MEA_DATA = 110;

			// BW
			*MEA_DATA = (music[1][frame & 0xF] << 6) |
						(music[3][frame & 0xF] << 4) |
						(music[5][frame & 0xF] << 2) |
						(music[7][frame & 0xF]);

			// FREQ
			*MEA_DATA = (music[2][frame & 0xF] << 5) |
						(music[4][frame & 0xF]);

			// FREQ / AMPL
			*MEA_DATA = (music[0][frame & 0xF] << 3) | 0xF; // TODO AMPL

			// AMPL / DUR / PERIODCHANGE
			*MEA_DATA = 0xD1; // TODO AMPL / DUR / PERIODCHANGE
		}

		asm("\n"
"z	TST	0xA7E7	\n"
"	BMI z		\n"
"bb	TST	0xA7E7	\n"
"	BPL bb		\n"
		);
	}

	return 0;
}
