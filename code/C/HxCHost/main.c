/* HcX floppy Emulator Host Software for TO8 and MO5
 * Copyright 2011, Adrien Destugues <pulkomandy@pulkomandy.ath.cx>
 * Distributed under the terms of the MIT Licence
 */

#include "pff/pff.h"
#include "macros.h"

void asm_write();

#if PLATFORM == 5
	#define DIRECTORY_BUFFER (FILINFO*)0x3000
#else
	// Thomson TO8 code
	#define DIRECTORY_BUFFER (FILINFO*)0xA000
#endif

unsigned char mark[512 + 16] = "HxCFEDA";
unsigned char* secbuf = mark+16;

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

int main(void)
{
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

	mon_putc('z');

	// Open root directory
	pf_opendir(&d, "");
	mon_putc('y');

	// List files
	ls(DIRECTORY_BUFFER);
	mon_putc('x');

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
			asm("SWI \t    \t;\n"
				".fcb \t0x0A\t;GETC\n");
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
					// TODO file open
					// If it's HXCSDFE.CFG, enter config mode
					// If it's a file, load it in HxCSDFE.CFG, then reboot
				}
				break;

			default:
				printhex(KEY);
				break;
		}
	}

	// Leave LBA mode
	/*

*/

	// Reboot
	exit(0);
}
