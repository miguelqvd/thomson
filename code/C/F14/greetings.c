#include "effect.h"
#include "text.h"

asm("\n"
"	.area .text \n"
"	INCLUDEBIN ../THOM02.CRU \n"
"color_thom		\n"
"	INCLUDEBIN ../THOM01.CRU \n"
"forme_thom		\n"
);

static int m = 0;
static int chr = 0;

void init_G()
{
	asm("	LDX		#color_thom-1	\n"
		"	LDU		#forme_thom-1	\n"
		"	LBSR	decrunchpic		\n"
	:::"x","u","y");

	couleur();

	int x;

	for(int y = 0; y <= 32; y++)
	for(x = 10; x < 29; x++)
	{
		if (y > 8 || x < 28)
			*(char*)((70  + y) * 40 + x) &= 0xF;
		if (y > 8 || x > 11)
			*(char*)((135 - y) * 40 + x) &= 0xF;
	}

	m = 0;
	chr = 0;
}

static const char* const messages[] = {
"This is the end of\n"
"\n"
"       F-14\n"
"  \"Forever Young\"\n"
"\n"
"        by\n"
"\n"
"   SHINRA and JFF\0",
//        X         X

"Code:\n"
"     PulkoMandy/SHR\n"
"\n"
"Graphics:\n"
"         Exocet/JFF\n"
"\n"
"Music:\n"
"     PulkoMandy/SHR",
//       XX         X


"This demo is the\n"
"result of 3 years\n"
"of hard work...\n"
"\n"
"Coding the effects\n"
"but also the tools\n"
"for MO5 development\n",
//       XX         X


"\n"
"The following tools\n"
"were used (thanks!)\n"
"\n"
"GCC-6809\n"
" by   Eric Botcazou\n"
"       Brian Dominy\n"
"      William Astle\n",
//       XX         X


"lwtools\n"
" by   William Astle\n"
"dcmo5\n"
" by   Daniel Coulom\n"
"Exomizer 2\n"
" by     Magnus Lind\n"
"     Edouard Forler\n",
//       XX         X


"The following were\n"
"developped for our\n"
"very special needs\n"
"\n"
"CrO2, f2k5 and\n"
"MEATracker\n"
" by      PulkoMandy",
//       XX         X


"png2mo5\n"
" by     Shinra Team\n"
"\n"
"\n"
"GrafX2\n"
" by     Shinra Team\n"
"      Sunset Design",
//       XX        X


"   We would also\n"
"   like to greet\n"
"\n"
"the Haiku project\n"
"          for Haiku\n"
"TECGRAF\n"
"    for IUP and Lua",
//       XX        X


"\n"
"the GNU project\n"
"       for GNU Make\n"
"\n"
"\n"
"Bram Moleenar\n"
"            for Vim",
//       XX        X


"Of course, some\n"
"greetings to the\n"
"demoscene members\n"
"(current and past)\n"
"\n"
"Mike/Zeroteam and\n"
"the Forever team",
//       XX        X


"Sucres en Morceaux\n"
"ARKOS  BND  FUTUR'S\n"
" and the CPC Scene\n"
"Dimension HCL PULS\n"
" the Thomson guys\n"
"Linefeed LFT AA-Grp\n"
"   elsewhere...\n",
//       XX        X


" See you next year\n"
"    at Forever!\n"
"        <=\n"
"        []\n"
"\n"
"(C) MMXIII SHR&JFF\n"
"shinra.cpcscene.com\n"
//       XX        X
};

int nextchar();
int erase();

void draw_G(int frame)
{
	static int state = 1;
	forme();

	// actually wait for a frame
asm("\n"
"waitvbl	TST 0xA7E7 \n"
"   		BPL waitvbl\n"
"waitmore	TST 0xA7E7 \n"
"   		BMI waitmore\n"
);

	switch(state)
	{
		case 1:
			state = erase();
			break;
		case 0:
			if (frame & 0x3) return;
			state = nextchar();
			break;
		default:
			state = 0;
	}
}

int nextchar()
{
	static int x = 10;
	static int y = 70;

	char c = messages[m][chr];

	switch(c)
	{
	case 0:
	{
		x = 10;
		y = 70;
		chr = 0;

		if (m > 10) {
			*(volatile unsigned char*)(0xA7CF) = 255;
			for(;;);
		}
		m++;

		return 1;
	}
	case '\n':
	{
		x = 10;
		y += 8;
		chr++;
		break;
	}
	case ' ':
	{
		x++;
		chr++;
		break;
	}
	default:
	{
		drawchar(c, x++, y);
		chr++;
	}
	}

	return 0;
}

int erase()
{
	static int y = 0;
	int x;

	for(x = 10; x < 29; x++)
	{
		if (y >= 8 || x < 28)
			*(char*)((70  + y) * 40 + x) = 0;
		if (y >= 8 || x > 11)
			*(char*)((135 - y) * 40 + x) = 0;
	}

	y++;

	if (y > 32) {
		y = 0;
		return 0;
	} else {
		return 1;
	}
}
