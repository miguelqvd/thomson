// Here's the trick:
//  - unpack the logo to screen memory
//  - The color RAM doesn't move. Part with the logo is shown as expected,
//  below it is an area of single color (we can use the forme part without
//  visible artifacts)
//  - The pixel RAM has the visible copy of the logo, and an hidden copy of the
//  waving part below it
//  - We run over the logo lines, pick from the invisible part and copy to the 
//  visible one
//  - Easy way: only vertical ondulations are done.
//  - To do horizontal ondulations, we'd need 8 versions of the logo, each
//  shifted one byte from the previous. This would fill a lot of RAM !

#include <effect.h>

extern unsigned char SIN[256];

asm("\n"
"	.area .text \n"
"	INCLUDEBIN ../LOGO01.CRU \n"
"forme_logo		\n"
);

void init_L()
{
	// TODO clear screen to white
	couleur();
	for(unsigned int* i = (unsigned int*)(0); i < (unsigned int*)8000; i++)
	{
		*i = 0x7777;
	}
	
	forme();

	asm("\n"
"		LDY		#5000			\n"
"		LDU		#forme_logo-1	\n"
"		LBSR	exo2			\n"
	:::"x", "y");

	// Copy the bottom part of the logo to the top of the screen (pixels only)
	// We will use this as a source for distorting the actual logo below.
	unsigned int* src;
	unsigned int* dest;
	dest = (unsigned int*)1280;
	for(src = (unsigned int*)5000; src >= (unsigned int*)3720;)
		*dest-- = *src--;

	couleur();

	for(int y = 2280; y < 3560; y+=40)
	{
		for(int x = 0; x < 40; x+=2)
			*(unsigned int*)(x+y) = 0x0707;
		for(int x = 20; x < 28; x+=2)
			*(unsigned int*)(x+y) = 0x1717;
	}

	for(int y = 3560; y < 5000; y+=40)
	{
		for(int x = 0; x < 40; x+=2)
			*(unsigned int*)(x+y) = 0x8787;
		for(int x = 20; x < 28; x+=2)
			*(unsigned int*)(x+y) = 0x9797;
	}

	forme();

	return;
}


void draw_L(int frame)
{
	for(int y = 0; y < 32; y++)
	{
		int offset = (y + (SIN[((y+frame)*4) & 0xFF] >> 6)) * 40;
		for(int x = 0; x < 40; x++) {
			*(unsigned int*)(x + y * 40 + 3720) =
			*(unsigned int*)(x + offset);
		}
	}

	asm("\n"
"z	TST	0xA7E7	\n"
"	BMI z		\n"
"bb	TST	0xA7E7	\n"
"	BPL bb		\n"
	);
}

