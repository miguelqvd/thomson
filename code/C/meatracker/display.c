#include "display.h"

#include <text.h>

char music[8][16];

static const char* notes = "C C#D D#E F F#G G#A A#B --";

const char FM1[] = {
2,'3',  4,'3', 5,'3',  6,'3', 7,'3',  9,'3', 10,'3', 11,'3',
0,'4',  2,'4', 3,'4',  4,'4', 5,'4',  6,'4',  7,'4',  8,'4',
// >> FM2
9,'4', 10,'4', 11,'4', 0,'5', 1,'5',  2,'5',  3,'5',  4,'5',
5,'5',  6,'5',  7,'5', 8,'5', 9,'5', 10,'5', 11,'5',  0,'6'
};

const char FM2[] = {
9,'4', 10,'4', 11,'4', 0,'5', 1,'5',  2,'5',  3,'5',  4,'5',
5,'5',  6,'5',  7,'5', 8,'5', 9,'5', 10,'5', 11,'5',  0,'6',
// << FM1
1,'6',  2,'6',  3,'6', 5,'6', 6,'6',  7,'6',  8,'6',  9,'6',
10,'6', 0,'7',  1,'7',  2,'7', 4,'7', 5,'7',  7,'7',  8,'7'
};

const char FM3[] = {
2,'6', 4,'6', 7,'6', 9,'6', 0,'7', 2,'7', 5,'7', 8,'7'
};

static const char FM4[] = { 9,'7' };

void printnote(unsigned char channel, unsigned char pos)
{
	if (channel > 6) return;

	uint8_t note = music[channel][pos];
	char fbw = '1' + music[channel+1][pos];

	uint8_t n = 12, o = '?';
	if (note >= 0)
	{
		note *= 2;
	switch (channel)
	{
		case 0:
			n = FM1[note]; o = FM1[note+1];
			break;
		case 2:
			n = FM2[note]; o = FM2[note+1];
			break;
		case 4:
			n = FM3[note]; o = FM3[note+1];
			break;
		case 6:
			n = FM4[note]; o = FM4[note+1];
			break;
	}
	}


	pos *= 8;

	if(channel == 2) channel = 5;
	else if(channel == 4) channel = 10;
	else if(channel == 6) channel = 15;

	n *= 2;

	drawchar(notes[n],     channel++, pos);
	drawchar(notes[n + 1], channel++, pos);
	drawchar(o,            channel++, pos);
	drawchar(fbw,          channel,   pos);
}

void refreshchannels()
{
	int x,y;

	for(x = 0; x < 8; x+=2)
	for(y = 0; y < 16; y++)
	{
		printnote(x, y);
	}

	// TODO HEADER
	// FM1  FM2  FM3  FM4  GEN
	// nnnW nnnW nnnW nnnW sldCRVD
	// ---  ---  ---  ---  nnnCR                   

	cursor(cursorx, cursory);
}

void cursor(uint8_t x, uint8_t y)
{
	uint8_t* destp = (uint8_t*)(x*2) + y * 8 * 40;

	if(x>1) ++destp;
	if(x>3) ++destp;
	if(x>5) ++destp;
	if(x>7) ++destp;

	int val = 0xFFFF;
	if(x == 1 || x == 3 || x == 5 || x == 7) val = 0xFF;
	uint16_t* dest = (uint16_t*)destp;
	*dest ^= val; dest +=20;
	*dest ^= val; dest +=20;
	*dest ^= val; dest +=20;
	*dest ^= val; dest +=20;
	*dest ^= val; dest +=20;
	*dest ^= val; dest +=20;
	*dest ^= val; dest +=20;
	*dest ^= val; dest +=20;
}
