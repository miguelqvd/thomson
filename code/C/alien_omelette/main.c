// Screen base = 0x4000
// Width = 320/8 = 40
// 0x4000 + X/8 + Y*40
#define C2A(X, Y) (unsigned char*)(0x4000 + (X) / 8 + (Y) * 40)

volatile unsigned* DUREE = (volatile unsigned*)0x6033;

struct guy;

struct span {
	unsigned char* where;
	unsigned char height;
};

struct guy {
	const struct guy* left;
	const struct guy* right;
	struct span span[6];
};

const struct span eggs[4][8] = {
	{ { C2A(88, 32), 7 }, { C2A(88, 46), 7 }, { C2A(88, 59), 7 },
	  { C2A(88, 73), 7 }, { C2A(88, 88), 7 }, { C2A(88, 103), 7 },
	  { C2A(88, 116), 7 }, { C2A(88, 129), 7 },},
	{ { C2A(144, 32), 7 }, { C2A(144, 46), 7 }, { C2A(144, 59), 7 },
	  { C2A(144, 73), 7 }, { C2A(144, 88), 7 }, { C2A(144, 103), 7 },
	  { C2A(144, 116), 7 }, { C2A(144, 129), 7 },},
	{ { C2A(200, 32), 7 }, { C2A(200, 46), 7 }, { C2A(200, 59), 7 },
	  { C2A(200, 73), 7 }, { C2A(200, 88), 7 }, { C2A(200, 103), 7 },
	  { C2A(200, 116), 7 }, { C2A(200, 129), 7 },},
	{ { C2A(256, 32), 7 }, { C2A(256, 46), 7 }, { C2A(256, 59), 7 },
	  { C2A(256, 73), 7 }, { C2A(256, 88), 7 }, { C2A(256, 103), 7 },
	  { C2A(256, 116), 7 }, { C2A(256, 129), 7 },},
};

const struct span* liveeggs[4];

const struct guy guyPos[4] = {
	{
		.left = &guyPos[0],	.right = &guyPos[1],
		{ {C2A(64,145), 16}, {C2A(72, 122), 38}, {C2A(80, 121), 37},
			{C2A(88,137), 5}, {C2A(88, 151), 7}, {C2A(96, 137), 3}}
	},
	{
		.left = &guyPos[0], .right = &guyPos[2],	
		{ {C2A(120,124), 6}, {C2A(120, 139), 21}, {C2A(128, 121), 36},
			{C2A(136, 122), 39}, {C2A(144, 141), 5}, {C2A(152,140), 4}}
	},
	{
		.left = &guyPos[1], .right = &guyPos[3],	
		{ {C2A(176,130), 31}, {C2A(184, 121), 40}, {C2A(192, 121), 37},
			{C2A(200, 137), 5}, {C2A(200,153), 6}, {C2A(208, 137), 3}}
	},
	{
		.left = &guyPos[2], .right = &guyPos[3],
		{ {C2A(224,151), 9}, {C2A(232, 123), 5}, {C2A(232, 131), 29},
			{C2A(240, 121), 40}, {C2A(248, 122), 22}, {C2A(256,137), 5}}
	},
};

const struct guy* theGuy = &guyPos[1];

#define hw_color() { \
	asm("LDA  \t0xE7C3\n " \
		"ANDA \t#0xFE\n  " \
		"STA  \t0xE7C3\n " \
		:::"a"); \
}

#define mon_putc(car) { \
   	asm("JSR \t0xE803  \t; TO8 PUTC\n"\
		::"B" ((unsigned char) (car))\
	); \
}

#define mon_note(note) { \
   	asm("JSR \t0xE81E  \t; TO8 NOTE\n"\
		::"B" ((unsigned char) (note))\
	); \
}

#define test_joystick(b) { \
    asm(" LDA \t%1\n" \
		" JSR \t0xE827  \t; TO8 JOYS\n" \
		: "=B"((unsigned char)b) : "K" (0)); \
}

static void erase_span(const struct span* span)
{
	unsigned char y;
	unsigned char* p;
	y = span->height;
	p = span->where;
	while (y != 0) {
		*p = 0xC0;
		p += 40;
		y--;
	}
}

static void draw_span(const struct span* span)
{
	unsigned char y;
	unsigned char* p;
	y = span->height;
	p = span->where;
	while (y != 0) {
		*p = 0xC8;
		p += 40;
		y--;
	}
}

static void erase(const struct guy* what)
{
	unsigned char i;
	for (i = 0; i < 6; i++) {
		erase_span(&what->span[i]);
	}
}

static void draw(const struct guy* what)
{
	unsigned char i;
	for (i = 0; i < 6; i++) {
		draw_span(&what->span[i]);
	}
}

enum key {
	left,
	right
};

void abort()
{
	for(;;);
}

void disp(unsigned int score)
{
	mon_putc(0xD);
	mon_putc(' ');
	if (score >= 100) {
		unsigned char h = score / 100;
		mon_putc(h + '0');
		score -= 100 * h;
	} else
		mon_putc(' ');
	if (score >= 10) {
		unsigned char h = score / 10;
		mon_putc(h + '0');
		score -= 10 * h;
	} else
		mon_putc(' ');
	mon_putc(score + '0');
	mon_note(0x35);
	if (DUREE != 0)
		DUREE--;
}

int start(void)
{
	mon_putc(0xA);
	mon_putc(0xA);
	mon_putc(0xA);
	unsigned int backup = DUREE;
	asm(" ORCC \t#0x55\n");
	for(;;) {
	unsigned char step = 0;
	unsigned char key = 0;
	unsigned char egg = 0;
	unsigned int score = 0;

	liveeggs[0] = 0;
	liveeggs[1] = 0;
	liveeggs[2] = 0;
	liveeggs[3] = 0;
	DUREE = backup;
	disp(0);

	// Clear all eggs
	// Clear all characters
	hw_color()
	erase(&guyPos[0]);
	erase(&guyPos[2]);
	erase(&guyPos[3]);

	const struct span* foo = &eggs[0][0];
	for (key = 0; key < 32; key++)
		erase_span(foo + key);
	
	// MAIN LOOP
	for (;;) {
		if (step == 0) {
			egg++;
			if (egg > 3) egg = 0;
		}
		test_joystick(key);
		if (key == 7) {
			mon_putc(7);
			hw_color()
			erase(theGuy);
			theGuy = theGuy->left;
			draw(theGuy);
		} else if (key == 3) {
			mon_putc(7);
			hw_color()
			erase(theGuy);
			theGuy = theGuy->right;
			draw(theGuy);
		} else {
			if (liveeggs[step] == 0) {
				if (egg == 0) {
					// New egg
					liveeggs[step] = &eggs[step][0];
					egg++;
					draw_span(liveeggs[step]);
				}
			} else {
				// Advance egg
				erase_span(liveeggs[step]);
				liveeggs[step]++;
				if ((liveeggs[step] == &eggs[1][0])) {
					if (theGuy == &guyPos[0]) {
						// 1 point
						score++;
						disp(score);
						liveeggs[step] = 0;
					} else {
						// Game over
						break;
					}
				} else if ((liveeggs[step] == &eggs[2][0])) {
					if (theGuy == &guyPos[1]) {
						// 1 point
						score++;
						disp(score);
						liveeggs[step] = 0;
					} else {
						// Game over
						break;
					}
				} else if ((liveeggs[step] == &eggs[3][0])) {
					if (theGuy == &guyPos[2]) {
						// 1 point
						score++;
						disp(score);
						liveeggs[step] = 0;
					} else {
						// Game over
						break;
					}
				} else if ((liveeggs[step] == &eggs[4][0])) {
					if (theGuy == &guyPos[3]) {
						// 1 point
						score++;
						disp(score);
						liveeggs[step] = 0;
					} else {
						// Game over
						break;
					}
				} else
				{
					draw_span(liveeggs[step]);
				}
			}
		}

		asm(" SYNC\n");
		mon_note(0x30);

		step++;
		if (step > 3) step = 0;
	}

	for (int i = 0; i < 3; i++) {
		erase_span(liveeggs[step] - 1);
		asm(" SYNC\n");
		mon_note(0x31);
		draw_span(liveeggs[step] - 1);
		asm(" SYNC\n");
		mon_note(0x30);
	}

	}
}
