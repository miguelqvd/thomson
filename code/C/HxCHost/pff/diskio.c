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
	static DWORD prevsec = -1;
	// TODO implement caching system
	//  * If sector is reachable with current LBA, don't change it

	printhex(sector>>24);
	printhex(sector>>16);
	printhex(sector>>8);
	printhex(sector);
	mon_putc(' ');

	if (prevsec != sector)
	{

		// Set LBA address
		int j = 8;
		mark[j++] = 1;
		mark[j++] = sector;
		mark[j++] = (sector>>8);
		mark[j++] = (sector>>16);
		mark[j++] = (sector>>24);
		mark[j++] = 0; // Write disabled
		mark[j++] = 6; // Sector count
		for(; j <512; j++) mark[j] = 0;
		write(255,0,mark);

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
	// TODO write it
	// Beware of using the sector buffer, read is doing caching there...
	DRESULT res = RES_ERROR;


	if (!buff) {
		if (sc) {

			// Initiate write process

		} else {

			// Finalize write process

		}
	} else {

		// Send data to the disk

	}

	return res;
}

