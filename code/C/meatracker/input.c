#include "display.h"

unsigned char cursorx = 0, cursory = 7;

extern const char FM1[], FM2[], FM3[];
extern unsigned char music[8][16];
void printnote(unsigned char x, unsigned char y);

// maps keycodes to notes
static const unsigned char notemap[] =
{
	[0x60] = 0,  // W
	[0x50] = 2,  // X
	[0x64] = 4,  // C
	[0x54] = 6,  // V
	[0x44] = 8,  // B
	[0x00] = 10, // N
	[0x10] = 12, // ,
	[0x20] = 14, // .
	[0x30] = 16, // @
   	[0x22] = 18, // back
   	[0x56] = 20, // Q
   	[0x46] = 22, // S
   	[0x36] = 24, // D
   	[0x26] = 26, // F
   	[0x16] = 28, // G
   	[0x06] = 30, // H
	[0x04] = 32, // J
	[0x14] = 34, // K
	[0X24] = 36, // L
	[0x34] = 38, // M
	[0x5A] = 40, // A
	[0x4A] = 42, // Z
	[0x3A] = 44, // E
	[0x2A] = 46, // R
	[0x1A] = 48, // T
	[0x0A] = 50, // Y
	[0x08] = 52, // U
	[0x18] = 54, // I
	[0x28] = 56, // O
	[0x38] = 58, // P
	[0x48] = 60, // /
	[0x58] = 61, // *
	// JKLM AZERTY UIOP/*
};

void input()
{
	// scan keyboard
	volatile unsigned char* volatile PIA_B = (volatile unsigned char* volatile)0xA7C1;

	for(unsigned char k = 0; k < 127; k+= 2)
	{
		*PIA_B = k;

		if(!(*PIA_B & 0x80))
		{
			// We have a keypress !
			switch(k)
			{
				case 0x32: //RIGHT
					if(cursorx == 11) break;
					cursor(cursorx,cursory);
					cursorx ++;
					cursor(cursorx,cursory);
					break;
				case 0x42: //DOWN
					if(cursory == 15) break;
					cursor(cursorx,cursory);
					cursory ++;
					cursor(cursorx,cursory);
					break;
				case 0x52: //LEFT
					if(cursorx == 0) break;
					cursor(cursorx,cursory);
					cursorx --;
					cursor(cursorx,cursory);
					break;
				case 0x62: //UP
					if (cursory == 0) break;
					cursor(cursorx,cursory);
					cursory --;
					cursor(cursorx,cursory);
					break;

				// TODO handle octave / width / more ?
				default:
				{
				// direclty assigning from array to array generates buggy code
					uint8_t note = notemap[k];
					switch(cursorx)
					{
						case 0:
						case 2:
						case 4:
						case 6:
							music[cursorx][cursory] = note;
							printnote(cursorx, cursory);
							cursor(cursorx, cursory);
							break;

						case 1:
						case 3:
						case 5:
						case 7:
						{
							uint8_t channel = cursorx - 1;
							if(k == 0x5E)
								music[channel + 1][cursory] = 0;
							else if (k == 0x4E)
								music[channel + 1][cursory] = 1;
							else if (k == 0x3E)
								music[channel + 1][cursory] = 2;
							else if (k == 0x2E)
								music[channel + 1][cursory] = 3;
							printnote(cursorx - 1, cursory);
							cursor(cursorx, cursory);
						}
					}
					break;
				}
			}
		}
	}
	
	// TODO extra widgets besides the tracker ? diskop, etc ?
}
