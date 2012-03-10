/*-----------------------------------------------------------------------*/
/* Low level disk I/O module skeleton for Petit FatFs (C)ChaN, 2009      */
/* Driver for MO5/TO8 HxC floppy emulator direct access
 * Copyright 2011, Adrien Destugues <pulkomandy@pulkomandy.ath.cx>
-------------------------------------------------------------------------*/

#include "diskio.h"

#include "../macros.h"

/*******/
extern unsigned char* secbuf;
extern unsigned char mark[];

static DWORD prevsec = -1;
/*******/

/*-----------------------------------------------------------------------*/
/* Initialize Disk Drive                                                 */
/*-----------------------------------------------------------------------*/

DSTATUS disk_initialize (void)
{
	// Enter host mode
	seek();

	// Read header to check everything is ok
	read(255, 0, secbuf);

	// Check for HxCFEDA marker
	if (*(long*)(mark) != *(long*)(secbuf))
		return STA_NOINIT;
	if (*(long*)(mark+4) != *(long*)(secbuf+4))
		return STA_NOINIT;
	return 0;
}


void map_sector(DWORD sector, BYTE write)
{
	// Set LBA address
	int j = 8;
	mark[j++] = 1;
	mark[j++] = sector;
	mark[j++] = (sector>>8);
	mark[j++] = (sector>>16);
	mark[j++] = (sector>>24);
	mark[j++] = write;
	mark[j++] = 1; // Sector count
		// BEWARE of changing this to something else than 1 !
		// In write burst mode it could erase all the sectors you don't rewrite

	// TODO extract a send_hxc_command function from this
	for(; j <512; j++) mark[j] = 0;
	write(255,0,mark);
}


/*-----------------------------------------------------------------------*/
/* Read Partial Sector                                                   */
/*-----------------------------------------------------------------------*/

DRESULT disk_readp (
	BYTE* dest,			/* Pointer to the destination object */
	DWORD sector,		/* Sector number (LBA) */
	WORD sofs,			/* Offset in the sector */
	WORD count			/* Byte count (bit15:destination) */
)
{
	// TODO implement caching system
	//  * If sector is reachable with current LBA, don't change it

	if (prevsec != sector)
	{
		map_sector(sector, 0);
		prevsec = sector;
		// Read sector
		read(255,1,secbuf);
	}

	// Copy useful bytes to dest.
	sofs += (int)(secbuf);
	for(int j = 0; j <count;++j)
	{
	    *(char*)(dest+j) = *(char*)(j+sofs);
	}

	return RES_OK;
}



/*-----------------------------------------------------------------------*/
/* Write Partial Sector                                                  */
/*-----------------------------------------------------------------------*/

DRESULT disk_writep (
	const BYTE* buff,/* Pointer to the data to be written, NULL:Initiate/Finalize write operation */
	DWORD sc		/* Sector number (LBA) or Number of bytes to send */
)
{
	static WORD ptr;
	static char* wrbuf[256];
		// Separate buffer because we need to use map_sector, and it kills secbuf

	if (!buff) {
		if (sc) {
			mon_putc('A');
			// Initiate write process
			prevsec = sc;
			ptr = 0;
		} else {
			mon_putc('C');
			mon_putc(' ');
			printhex(ptr);
			// Called with both param = 0 - flush buffer to disk
			// First make sure it's zero-filled
			for(;ptr < 512; ++ptr)
			{
				*(wrbuf + ptr) = 0;
			}

			// map in the sector (no need to read from SD)
			map_sector(prevsec, 0xA5);

			for(int j = 0; j < 40; j++)
				printhex(*(char*)(wrbuf + j));

			write(255,1,wrbuf);
		}
	} else {
		mon_putc('B');
		// Here SC is a bytecount. copy that much bytes to the buffer
		for(int j = 0; j <sc;++j)
		{
	    	*(char*)(wrbuf+ptr) = *(char*)(ptr++ + buff);
		}
	}

	return RES_OK;
}

