#include <text.h>

static const char* notes = "C C#D D#E F F#G G#A A#B --";

static const char FM1[] = {
2,'3',  4,'3', 5,'3',  6,'3', 7,'3',  9,'3', 10,'3', 11,'3',
0,'4',  2,'4', 3,'4',  4,'4', 5,'4',  6,'4',  7,'4',  8,'4',
// >> FM2
9,'4', 10,'4', 11,'4', 0,'5', 1,'5',  2,'5',  3,'5',  4,'5',
5,'5',  6,'5',  7,'5', 8,'5', 9,'5', 10,'5', 11,'5',  0,'6'
};

static const char FM2[] = {
9,'4', 10,'4', 11,'4', 0,'5', 1,'5',  2,'5',  3,'5',  4,'5',
5,'5',  6,'5',  7,'5', 8,'5', 9,'5', 10,'5', 11,'5',  0,'6',
// << FM1
1,'6',  2,'6',  3,'6', 5,'6', 6,'6',  7,'6',  8,'6',  9,'6',
10,'6', 0,'7',  1,'7',  2,'7', 4,'7', 5,'7',  7,'7',  8,'7'
};

static const char FM3[] = {
2,'6', 4,'6', 7,'6', 9,'6', 0,'7', 2,'7', 5,'7', 8,'7'
};

static const char FM4[] = { 9,'7' };

void printnote(char channel, char pos, char note)
{
	if (channel > 3) return;

	char n, o;
	pos *= 8;
	if (note >= 0)
	{
		note *= 2;
	switch (channel)
	{
		case 0:
			n = FM1[note]; o = FM1[note+1];
			break;
		case 1:
			n = FM2[note]; o = FM2[note+1];
			break;
		case 2:
			n = FM3[note]; o = FM3[note+1];
			break;
		case 3:
			n = FM4[note]; o = FM4[note+1];
			break;
	}
	} else {
		n = 12;
	}

	channel *= 5;
	n *= 2;
	drawchar(notes[n],     channel++, pos);
	drawchar(notes[n + 1], channel++, pos);
	drawchar(o,            channel,   pos);
}

void refreshchannels()
{
	int x,y;

	for(x = 0; x < 4; x++)
	for(y = 0; y < 16; y++)
	{
		printnote(x, y, 0);
	}
}
