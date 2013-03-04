/* GFX2mo5 - libraw2mo5.c
 * CloudStrife - 20080921
 * PulkoMandy - 20101221, 20130213
 * Diffusé sous licence libre CeCILL v2
 * Voir LICENCE
 */

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

unsigned char *raw2mo5(unsigned char *input, bool fixup)
{
  unsigned char *tmpBuffer;
  int x,y;
  int previous = 0;

  tmpBuffer = (unsigned char*)calloc(0x4000,1);
  if (tmpBuffer == NULL)
  {
    printf("Allocation tmpBuffer raté\n");
    exit(4);
  }
	#define width 320

  bool lfo = false;
  for (y = 0; y < 200; y++)
	for (x = 0; x < 320; x+=8) {
		int fore = 255;
		int back = 255;
		int pix;
		bool oldlfo = lfo;

		for(pix = 0; pix < 8; pix++) {
			int nc = input[y*width+x+pix];
			if (nc > 15) printf("Color over limit!\n");
			if (back == nc) {
				// Pixel is in backcolor, set FORME to 0
				lfo = false;
			} else if (fore == nc) {
				// Pixel is in forecolor, set FORME to 1
	  			tmpBuffer[(y*320+x)/8] |= 0x80>>pix;
				lfo = true;
			} else if (back==255) {
				// Pixel is in unknown color, back is free : allocate backcolor
				back = nc;
				lfo = false;
			} else if (fore == 255) {
				// Pixel is unknown color, back is allocated : allocate front and set FORME
				fore = nc;
	  			tmpBuffer[(y*320+x)/8] |= 0x80>>pix;
				lfo = true;
			} else {
				printf("Color clash at %d %d : %d %d %d\n",x+pix,y,fore, back,
					input[y*width+x+pix]);
			}
		}

		if (fore == 255) fore = 7;
		if (fore != 255) {
			previous &= 0xF;
			previous |= fore << 4;
		}
		if (back != 255) {
			previous &= 0xF0;
			previous |= back;
		}

		// Make sure the last pixel of this GPL and the first of the next GPL
		// are both FORME or both FOND, else we get an ugly glitch on the
		// EFGJ033 Gate Array MO5!
		if(fixup && oldlfo == !(tmpBuffer[(y*320+x)/8] & 0x80))
		{
			previous = (previous >> 4) | (previous << 4);
	  		tmpBuffer[(y*320+x)/8] ^= 0xFF;

			lfo = !lfo;
		}

		tmpBuffer[0x2000+(y*320+x)/8] = previous;
  }

  return tmpBuffer;
}
