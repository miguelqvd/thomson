#include "effect.h"
#include "../libdemo/trig.h"

uint8_t* screen = 0;

enum timings
{
	WAVES		= 			  300,
	TWISTER 	= WAVES 	+ 400,
	POISCAIE	= TWISTER 	+ 200,
	PLASMA		= POISCAIE 	+ 800
};

#define MEA_CMD *(volatile unsigned char*)(0xA7CF)
#define MEA_DATA *(volatile unsigned char*)(0xA7CE)

	static const unsigned char patterns[] =
	{
		0,0,0,1,0,0,0,1,0,2,0,1,2,2,1,1
	};

	static const unsigned char music[] =
	{

// 0000
			0xFF, 0xD0, 0x87, 0x80, // A
			0xF0, 0xD0, 0x87, 0x80, // A
			0xF0, 0xD0, 0x87, 0x80, // A
			0xF0, 0xD5, 0xAF, 0x80, // D

			0xFF, 0xD0, 0x87, 0x80, // A
			0xF0, 0xD3, 0x9F, 0x80, // C
			0xF0, 0xD5, 0xAF, 0x80, // D
			0xF0, 0xD5, 0xAF, 0x80, // D
// 0001
			0xFF, 0xD0, 0x87, 0x80, // A
			0xF1, 0xD0, 0x87, 0x80, // A
			0xF1, 0xD0, 0x87, 0x80, // A
			0xF1, 0xD5, 0xAF, 0x80, // D

			0xFF, 0xD0, 0x87, 0x80, // A
			0xF0, 0xD3, 0x9F, 0x80, // C
			0xF3, 0xD5, 0xAF, 0x89, // D
			0x00, 0xD3, 0x91, 0x80, // ---
// 0002			
			0xFF, 0xD3, 0x9F, 0x80, // C
			0xF1, 0xD3, 0x9F, 0x80, // C
			0xF1, 0xD3, 0x9F, 0x80, // C
			0xF1, 0xD5, 0xAF, 0x80, // D

			0xFF, 0xD0, 0x87, 0x80, // A
			0xF0, 0xD3, 0x9F, 0x80, // C
			0xF0, 0xD5, 0xAF, 0x86, // D
			0x00, 0xD3, 0x91, 0x80, // ---
	};

void p_music(void)
{
	static int i = 0;
	static int pos = 0;
	static int pat = 0;


	i++;
	if (i > 4) {
		if ((pos & 0x3) == 0)
		{
			MEA_CMD = 16 + 12;
			switch(patterns[pat]) {
				case 0:
					MEA_DATA = 220;
					break;
				case 1:
					MEA_DATA = 131;
					break;
				case 2:
					MEA_DATA = 147;
					break;
				default:
					MEA_DATA = 0xFF;
					break;
			}
		}

		for (int j = 0; j < 4; j++)
		{
			MEA_DATA = music[(patterns[pat] * 8*4) | j | (pos<<2)];
		}	
		i = 0;
		pos ++;
		if (pos >= 8)
		{
			pos = 0;

			pat++;
			if(pat >= sizeof(patterns)) pat = 0;
		}
	}

}

int main(void)
{
	int frame = 0;

	asm(" ORCC #$50"); // Disable interrupts (cursor blink)

	polysine();

	// show SHR&JFF logo + ondulations
	init_L();
	for(;frame < WAVES;) {
		p_music();
		draw_L(frame++);
		p_music();
		frame++;
	}

	// TODO clear screen, put on some nice background for the twister
	couleur();
	for(unsigned int* i = (unsigned int*)0; i < (unsigned int*)8000; i++)
		*i = 0;

	// TWISTER !!!
	init_T();
	for(;frame < TWISTER;) {
		p_music();
		p_music();
		draw_T(frame++);
	}

	// TODO clear color ram to some nice color while we prepare the picture
	couleur();
	for(unsigned int* i = (unsigned int*)0; i < (unsigned int*)8000; i++)
		*i = 0;

	// POISCAIE
	init_P();
	for(;frame < POISCAIE;) {
		p_music();
		asm("\n"
"w	TST	0xA7E7	\n"
"	BMI w		\n"
"q	TST	0xA7E7	\n"
"	BPL q		\n"
		);
		frame++;
	}
	
	// TODO, again, clear the the color ram while we setup the plasma
	couleur();
	for(unsigned int* i = (unsigned int*)0; i < (unsigned int*)8000; i++)
		*i = 0;
	
	init();
	for(;frame < PLASMA;) {
		p_music();
		p_music();
		p_music();
		draw(frame++);
	}

	// TODO and finally, clear the picture to setup the greetings
	couleur();
	for(unsigned int* i = (unsigned int*)0; i < (unsigned int*)8000; i++)
		*i = 0;

	// note: may be interesting to darken the plasma colorpalette to nicely
	// fade to black (or white), while the plasma is still moving
	init_G();
	for(;;) {
		p_music();
		draw_G(frame++);
	}
}

// FIXME use libthomson !
void forme(void)
{
	asm(" SWI	\n"
		" FCB	6"
	);
}

void couleur(void)
{
	asm(" SWI	\n"
		" FCB	4"
	);
}
