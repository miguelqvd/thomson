// 5 : MO5 / 8: TO8

#ifndef PLATFORM
	#error "make TARGET=TO8 or make TARGET=MO5"
#endif

#define FCB "fcb"

///////////////////////////////////////
// THOMSON.H
///////////////////////////////////////

/* MONITOR ZERO-PAGE */
#define KEY	  (*(volatile unsigned char*)(MONBASE + 0x37))
#define DKOPC (*(volatile unsigned char*)(MONBASE + 0x48))
#define DKDRV (*(volatile unsigned char*)(MONBASE + 0x49))
/* 204A is unused */
#define DKTRK (*(volatile unsigned char*)(MONBASE + 0x4B))
#define DKSEC (*(volatile unsigned char*)(MONBASE + 0x4C))
#define DKSTA (*(volatile unsigned char*)(MONBASE + 0x4E))
#define DKBUF (*(volatile unsigned int*)(MONBASE + 0x4F))

#define DKint1 (*(volatile unsigned int*)(MONBASE + 0x52))

void printhex(unsigned char i);
extern unsigned char mark[];

/* HARDWARE */
#define FDC_STATUS (*(volatile unsigned char*)(FDCBASE))

////////////////////////////////////////
// MO5.H
////////////////////////////////////////

#if PLATFORM == 5
/*****************************************************************************
 * MOx CODE
 ****************************************************************************/
	#define MONBASE 0x2000
	#define FDCBASE	0xA7D0

	/* MONITOR ENTRY POINTS */
	#define mon_putc(car) { \
    	asm(" swi \n"\
		    " fcb 2"\
			::"B" ((unsigned char) (car))\
		); \
	}


#define write(track, sector, buffer) {\
		DKTRK = (unsigned char)track;\
		DKSEC = (unsigned char)sector;\
		DKOPC = 8;\
		DKBUF = (unsigned int)buffer;\
\
    	asm(" swi \n"\
		    " fcb 0x26"\
			); \
	}

	/* FLOPPY DRIVE MONITOR ROM */
inline void read(unsigned char track, unsigned char sector, unsigned char* output)
{
	for(;;)
	{
		DKTRK = (unsigned char)track;
		DKSEC = (unsigned char)sector;
		DKOPC = 2;
		DKBUF = (unsigned int)output;

    	asm(" swi \n"
		    " fcb 0x26"
			);

		if (DKSTA == 0x44 || DKSTA == 0) return; // Sector read ok!
		printhex(DKSTA);
	}
}


/*
#define write(track, sector, buffer) {\
	DKBUF = (unsigned int)buffer; \
	asm("ORCC \t#0x50  \t \n"\
		"LDX  \t#0xA7D0 \t \n"\
		"LDU  \t0x204F  \t;DKBUF \n"\
		"STD  \t1,X    \t \n"\
		"LEAY \t3,X    \t \n"\
		"LDA  \t#0xA8  \t \n"\
		"STA  \t,X     \t \n"\
		"BSR  \t_delay  \t \n"\
		"BRA  \tdo     \t \n"\
		"load: \tSTA \t,U+ \n"\
		"do:  \tLDA \t,Y\n"\
		"wai: \tLDB \t,X\n"\
		"BITB \t#2     \t \n"\
		"BNE  \tload   \t \n"\
		"BITB \t#1     \t \n"\
		"BNE  \twai    \t \n"\
		"ANDCC \t#0xAF \t \n"\
		::"d" ((unsigned int)(track<<8|sector))\
		:"x","y","u");\
}*/

// seeking with the system functions work fine on MO5
#define seek() ;

#else
/*****************************************************************************
 * TOx CODE
 ****************************************************************************/
	/* MONITOR ENTRY POINTS */
	#define mon_putc(car) { \
    	asm("JSR \t0xE803  \t; TO8 PUTC\n"\
			::"B" ((unsigned char) (car))\
		); \
	}

	#define MONBASE 0x6000

#define write(track, sector, buffer) {\
		DKTRK = (unsigned char)track;\
		DKSEC = (unsigned char)sector;\
		DKOPC = 8;\
		DKBUF = (unsigned int)buffer;\
\
    	asm("JSR \t 0xE004 \t; TO8 DKCONT\n"\
		); \
	}

	/* FLOPPY DRIVE MONITOR ROM */
static inline void read(unsigned char track, unsigned char sector,
	unsigned char* output)
{
	for(;;)
	{
		DKTRK = (unsigned char)track;
		DKSEC = (unsigned char)sector;
		DKOPC = 2;
		DKBUF = (unsigned int)output;

    	asm("JSR \t 0xE004 \t \n"); \

		if (DKSTA == 0x44 || DKSTA == 0) return; // Sector read ok!
		printhex(DKSTA);
	}
}

// The TO8 floppy ROM has a limitation at 127 tracks. We have to hack around
// it. to get to track 255.
static inline void seek()
{
	// first, go on track 127
	DKTRK = 127;
	DKOPC = 0x40;
    asm("JSR \t 0xE004 \t \n"); \

	// Make the system think it's on track 79 (as that's what it will read from the HxC)
	DKint1 = 79;
	// Ask it to go to track 127 again (so we get to 127+79 = 206)
	DKTRK = 127;
	DKOPC = 0x40;
    asm("JSR \t 0xE004 \t \n"); \
	DKint1 = 79;
	// Ask it to go to track 127 again (so we get to 127+127 = 254)
	DKTRK = 127;
	DKOPC = 0x40;
    asm("JSR \t 0xE004 \t \n"); \
	DKint1 = 79;
	// Ask it to go to track 127 again (so we get to 127+127 = 254)
	DKTRK = 127;
	DKOPC = 0x40;
    asm("JSR \t 0xE004 \t \n"); \
	DKint1 = 79;
	// Ask it to go to track 127 again (so we get to 127+127 = 254)
	DKTRK = 127;
	DKOPC = 0x40;
    asm("JSR \t 0xE004 \t \n"); \
	DKint1 = 79;
	// Ask it to go to track 127 again (so we get to 127+127 = 254)
	DKTRK = 127;
	DKOPC = 0x40;
    asm("JSR \t 0xE004 \t \n"); \

	// Make the system think it's on track 255, so next commands don't try to
	// seek to it again the broken way
	DKint1 = 255;
}
#endif

