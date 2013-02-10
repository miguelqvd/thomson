// Libthomson - C wrapper for Thomson MO/TO monitor and hardware
// Copyright 2012-2013, Adrien Destugues <pulkomandy@pulkomandy.tk>
//
// This file is distributed under the terms of the MIT licence.

// You need the GCC-6809 compiler based on lwtools to use this file.
// http://www.boxofdoom.net/2011/09/22/how-to-compile-gcc-for-the-6809-processor-gcc6809/

#pragma once

// 5 : MO5 / 8: TO8
#ifndef PLATFORM
	#error "make TARGET=TO8 or make TARGET=MO5"
#endif

///////////////////////////////////////
// THOMSON.H
///////////////////////////////////////

/* MONITOR ZERO-PAGE */
struct Monitor {
	unsigned char TERMIN[0x18];
	unsigned char STATUS;
	unsigned char TABPT;
	unsigned char RANG;
	unsigned char COLN;
	unsigned char TOPTAB;
	unsigned char TOPRAN;
	unsigned char BOTTAB;
	unsigned char BOTRAN;
	unsigned int SCRPT;
	unsigned int STADR;
	unsigned int ENDDR;
	unsigned int BLOCZ;
	unsigned char FORME;
	unsigned char ATRANG;
	unsigned char COLOUR;
	unsigned char PAGFLG;
	unsigned char SCROLS;
	unsigned char CURSFL;
	unsigned char COPCHR;
	unsigned char EFCMPT;
	unsigned char ITCMPT;
	unsigned int PLOTX;
	unsigned int PLOTY;
	unsigned char CHDRAW;
	unsigned char KEY;
	unsigned char CMPKB;
	unsigned char _unused1;
	unsigned char TEMPO;
	unsigned char _unused2;
	unsigned char DUREE;
	unsigned char WAVE;
	unsigned int OCTAVE;
	unsigned char K7DATA;
	unsigned char K7LENG;
	unsigned char PROPC;
	unsigned char PRSTA;
	unsigned int TEMP;
	unsigned int SAVEST;
	unsigned char DKOPC;
	unsigned char DKDRV;
	unsigned int DKTRK;
	unsigned char DKSEC;
	unsigned char DKNUM;
	unsigned char DKSTA;
	unsigned int DKBUF;
	unsigned char DKTRACK[8];
	unsigned char SEQUCE;
	unsigned char US1;
	unsigned char ACCENT;
	unsigned char SS2GET;
	unsigned char SS3GET;
	unsigned int SWIPT;
	unsigned char _unused3;
	unsigned int TIMEPT;
	unsigned char SEMIRQ;
	unsigned int IRQPT;
	unsigned char _unused4;
	unsigned int FIRQPT;
	unsigned char _unused5;
	unsigned int SIMUL;
	unsigned char _unused6;
	unsigned int CHRPTR;
	unsigned char _unused7;
	unsigned int USERAF;
	unsigned char _unused8;
	unsigned int GENPTR;
	unsigned char _unused9;
	unsigned char LATCLV;
	unsigned char GRCODE;
	unsigned char DECALG;
	unsigned char _unusedA[6];
	unsigned char DEFDST;
	unsigned char DKFLG;
};

_Static_assert(sizeof(Monitor) == 0x80, "Problem with struct packing, Monitor Zero-Page has wrong size.");


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
	volatile Monitor* monitor = (volatile Monitor*)0x2000;
	#define FDCBASE	0xA7D0

	/* MONITOR ENTRY POINTS */

	static inline void MENU() {
		asm(" SWI	\n"
			" FCB	0"
		);
	}

	static inline void PUTC(unsigned char car) {
    	asm(" swi \n"
		    " fcb 2"
			::"B" (car)
		);
	}

	static inline void FRM0() {
		asm(" SWI	\n"
			" FCB	4"
		);
	}

	static inline void FRM1() {
		asm(" SWI	\n"
			" FCB	6"
		);
	}

	static inline void BEEP() {
		asm(" SWI	\n"
			" FCB	8"
		);
	}

	// TODO GETC and KTST return values in B,A and Z-flag. How to get these
	// back in C ?

	static inline void DRAW(int x, int y) {
		asm(" SWI	\n"
			" FCB	0xE"
			:: "X" (x), "Y" (y)
		);
	}

	static inline void PLOT(int x, int y) {
		asm(" SWI	\n"
			" FCB	0x10"
			:: "X" (x), "Y" (y)
		);
	}

	static inline void CHPL(int x, int y) {
		asm(" SWI	\n"
			" FCB	0x12"
			:: "X" (x), "Y" (y)
		);
	}

	// TODO GETP returns in B, LPIN in flag C, GETL flag C and regs XY
	// GETS and JOYS in A
	
	enum Note {
		DO  = 0,
		DOs = 1,
		RE  = 2,
		REs = 3,
		MI  = 4,
		FA  = 5,
		FAs = 6,
		SO  = 7,
		SOs = 8,
		LA  = 9,
		LAs = 9,
		SI  = 10,
		UT  = 11,
		// TODO what happens with other values ?
	};

	static inline void NOTE(enum Note note)
	{
		asm(" SWI	\n"
			" FCB	0x1E"
			:: "B" (note)
		);
	}


	/* FLOPPY DRIVE MONITOR ROM */
	// NOTE DKOPC was split into several commands to make it easier to use from
	// C code.
	static inline void write(unsigned char track, unsigned char sector, unsigned char* buffer) {
		DKTRK = (unsigned char)track;
		DKSEC = (unsigned char)sector;
		DKOPC = 8;
		DKBUF = (unsigned int)buffer;

    	asm(" swi \n"
		    " fcb 0x26"
		);
	}

static inline void read(unsigned char track, unsigned char sector, unsigned char* output)
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

	static inline void BOOT() {
		asm(" SWI	\n"
			" FCB	0x28"
		);
	}

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

	volatile Monitor* monitor = (volatile Monitor*)0x6000;

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
inline void read(unsigned char track, unsigned char sector,
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
#endif

