/* HcX floppy Emulator Host Software for TO8 and MO5
 * Copyright 2011, Adrien Destugues <pulkomandy@pulkomandy.ath.cx>
 * Distributed under the terms of the MIT Licence
 */

#include "pff/pff.h"
#include "macros.h"

void asm_write();

FILINFO DIRECTORY_BUFFER[23];

unsigned char mark[512 + 16] = "HxCFEDA";
unsigned char* secbuf = mark+16;

const char* HXCSDFECFG = "HXCSDFE.CFG";

void printhex(unsigned char n)
{
	unsigned char a = n >> 4;
	a += '0';
	if (a > '9')
		a += 'A'-10-'0';
	mon_putc(a)
	a = (n&0xF) + '0';
	if (a > '9')
		a += 'A'-10-'0';
	mon_putc(a)
}

// Program exit point (required by compiler...)
void __attribute__((noreturn)) exit(int a)
{
	for(;;);
}

// Error exit (required by compiler ...)
void __attribute__((noreturn)) abort()
{
	for(;;);
}

void my_puts(char* s)
{
	int j = 0;
	while(s[j]) mon_putc(s[j++]);
}

DIR d;
char path[256] = "";
char* pathend = path;

void chdir(char* dirname)
{
	*(pathend++) = '/';

	do {
		*(pathend++) = *(dirname++);
	} while(*(dirname) != 0);

	*(pathend) = 0;

	FRESULT r = pf_opendir(&d, path);

	if (r != 0) my_puts("directory error");
}

void parent(void)
{
	while(*(pathend) != '/' && pathend > path) pathend--;

	*(pathend) = 0;
	FRESULT r = pf_opendir(&d, path);
	if (r != 0) my_puts("directory error");
}

void ls(FILINFO* fp)
{
	for(int i = 23; i > 0; --i) {
		FRESULT r = pf_readdir(&d, fp);
		if (r != 0) my_puts("File error");
		if (*fp->fname == 0) break;

		fp ++;
	}
}

struct opt
{
	char* name;
	BYTE off;
	BYTE type;
};

static const struct opt options[7] =
{
	{"\x1B\x50\x0CHxC floppy emulator setup\r\n"
	"UP/DOWN move - +/- change\r\n"
	"space save - left quit\r\n\n"
		 "Step sound       ", 16, 0}, 
	{"\r\nGUI sound        ", 17, 0}, 
	{"\r\nBacklight delay  ", 18, 1}, 
	{"\r\nStandby delay    ", 19, 1}, 
	{"\r\nDrive selector   ", 20, 0}, 
	{"\r\nLoad last floppy ", 26, 0}, 
	{"\r\nLCD scroll speed ", 28, 1}, 
};

#define getcfg(off) *(char*)((int)confbuf+off)
#define putcfg(off, val) *(char*)((int)confbuf+off) = val

inline static void config()
{
	char confbuf[29];
	// If it's HXCSDFE.CFG, enter config mode
	// Read the config part of the file
	WORD byteCount = 29;
	FRESULT r = pf_read(confbuf, byteCount, &byteCount);
	if (r != 0 || byteCount != 29) 
	{
		my_puts("read error ");
		printhex(r);
		abort();
	}

	BYTE selected;
	for(;;) {
		for (int j = 0; j < 7; j++)
		{
			my_puts(options[j].name);
			mon_putc(0x1B); // Select back color
			mon_putc(selected == j ? 0x54: 0x50) // Blue
			if(options[j].type)
				printhex(getcfg(options[j].off));
			else
				my_puts(getcfg(options[j].off) ? "ON":"OFF");
			mon_putc(0x1B); // Select back color
			mon_putc(0x50); // Select back color
		}

		do {
			asm(" SWI\n"
				" FCB 0x0A\n");
		} while(KEY == 0);

		switch(KEY)
		{
			case 0x08: // UP
				// select next file
				if (selected != 0) --selected;
				// TODO next page ?
				break;

			case 0x19: // SPACE
				// save configuration
				pf_lseek(0);
				byteCount = 29;
				r = pf_write(confbuf, byteCount, &byteCount);
				if (r || byteCount != 29) {
					my_puts("can't write cfg");
					printhex(r);
					abort();
				}
				r = pf_write(0, 0, &byteCount); // flush sector
				if (r) {
					my_puts("can't close cfg");
					printhex(r);
					abort();
				}
				// fall through
			case 0x10: // LEFT
				// Quit (without saving)
				return;

			case 0x18: // DOWN
				// select previous file
				if (++selected > 6) selected = 6;
				// TODO previous page ?
				break;
			case 0x13: // -
				// decrease current option value
				if(options[selected].type)
					--*(char*)((int)confbuf+options[selected].off);
				else
					putcfg(options[selected].off, 0);
				break;
			case 0x0B: // +
				if(options[selected].type)
					++*(char*)((int)confbuf+options[selected].off);
				else
					putcfg(options[selected].off, 0xFF);
				break;
		}
	}
}

int __attribute__((noreturn)) start(void)
{
	my_puts("HxC host software for THOMSON\r\nCopyright 2016, PulkoMandy\r\n");

	// Detect HxC and print version code
	seek();
	read(255, 0, secbuf);
	my_puts("Firmware ");
	my_puts(secbuf + 8);

	// Read FAT / Init card
	FATFS fs;
	FRESULT r = pf_mount(&fs);

	if (r != 0) {
		my_puts("mount error ");
		printhex(r);
		exit(0);
	}

	// Enter "fixed timings" mode - make sure track 255 sends index pulses
	// every 200ms. Makes everything a bit slower, but the CD90-640 ROM
	// requires it.
	int j = 8;
	mark[j++] = 3;
	mark[j++] = 0xFF;
	for(; j <512; j++) mark[j] = 0;
	write(255,0,mark);

	// Open root directory
	pf_opendir(&d, "");

	// List files
	ls(DIRECTORY_BUFFER);

	int selected = 0;
	// Main input loop
	for(;;) {
		// TODO : refresh only the changed items ?
		mon_putc(0x1B) // Select back color
		mon_putc(0x50) // Black
		mon_putc(0x0C) // clear screen

		FILINFO* fp = DIRECTORY_BUFFER;
		int i = 0;
		while(*fp->fname != 0) {
			mon_putc(0x1B); // Select back color
			if (i++ == selected)
				mon_putc(0x54) // Blue
			else
				mon_putc(0x50) // Black

			mon_putc(0x1B); // Select front color
			if (fp->fattrib & AM_DIR)
				mon_putc(0x41) // Red
			else
				mon_putc(0x47) // white

			my_puts(fp->fname);	
			mon_putc('\n');
			mon_putc('\r');

			fp++;
		}
		if (selected > i) selected = i;

		// Allow the user to select a file
		do {
			asm(" SWI \n"
				" fcb 0x0A\n");
		} while(KEY == 0);

		switch(KEY)
		{
			case 0x08: // UP
				// select next file
				if (selected != 0) --selected;
				// TODO next page ?
				break;

			case 0x10: // LEFT
				parent();
				ls(DIRECTORY_BUFFER);
				break;

			case 0x18: // DOWN
				// select previous file
				if (selected++ >= i) selected = i-1;
				// TODO previous page ?
				break;

			case 0x19: // SPACE
				fp = DIRECTORY_BUFFER;
				fp += selected; // Point on the current direntry

				if(fp->fattrib & AM_DIR)
				{
					// If it's a dir, enter it
					chdir(fp->fname);
					selected = 0;
					ls(DIRECTORY_BUFFER);
				} else {
					const char* cmp = HXCSDFECFG;
					if (*(long*)(fp->fname) == *(long*)(cmp)
						&& *(long*)(fp->fname + 4) == *(long*)(cmp+4)
						&& *(long*)(fp->fname + 8) == *(long*)(cmp+8)
					)
					{
						FRESULT res = pf_open(cmp);
						if (res) {
							my_puts("Can't open CFG file: ");
							printhex(res);
							exit(0);
						}
						config();
					} else {
						my_puts("LOADING FILE");
						// If it's an HFE file, load it in HxCSDFE.CFG, then reboot
						
						// We need to open the file to get the starting cluster.
						// This is a PFF "limitation".
						pf_open(fp->fname);
						long off = LD_DWORD(&fs.org_clust);

						FRESULT res = pf_open(cmp);
						if (res) {
							my_puts("Can't open CFG file: ");
							printhex(res);
							exit(0);
						}
						pf_lseek(0x200);

						int count = 12;
						pf_write(fp->fname, count, &count);
						count = 1;
						pf_write(&fp->fattrib, count, &count);
						count = 4;
						pf_write(&off, count, &count);
						off = LD_DWORD(&fp->fsize);
						pf_write(&off, count, &count);
						count = 17;
						pf_write(fp->fname, count, &count);
						pf_write(0,0,&count);

						// reboot
						asm(" SWI\n"
							" FCB 0");
					}
				}
				break;

			default:
				printhex(KEY);
				break;
		}
	}
}
