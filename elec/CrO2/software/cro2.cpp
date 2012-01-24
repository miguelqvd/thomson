/* CrO2 datassette emulator
 * Copyright 2012, Adrien Destugues <pulkomandy@pulkomandy.ath.cx>
 *
 * Distributed under the terms of the MIT licence.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>

#include <iup.h>
#include <iupcontrols.h>

#include "device.h"

/* UI */
int menu_open(Ihandle* that)
{
	IupPopup(IupFileDlg(), IUP_CENTER, IUP_CENTER);
	return IUP_DEFAULT;
}

int menu_exit(Ihandle* that)
{
	return IUP_CLOSE;
}


void GUI_open(int* argc, char*** argv)
{
	IupOpen(argc, argv);
//	IupControlsOpen();

	IupSetFunction("OPEN", menu_open);
	IupSetFunction("EXIT", menu_exit);

	Ihandle* menu = IupMenu(
		IupSubmenu("File",
			IupMenu(
				IupItem("Open", "OPEN"),		
				IupItem("Exit", "EXIT"),
				NULL
			)
		),
		NULL
	);

	Ihandle* platformlist = IupList(NULL);
	IupSetAttribute(platformlist, "EXPAND", "HORIZONTAL");
	IupSetAttribute(platformlist, "DROPDOWN", "YES");
	IupSetAttribute(platformlist, "1", "MO5");
	IupSetAttribute(platformlist, "VALUE", "1");

	Ihandle* blocklist = IupTree();
	IupSetAttribute(blocklist, "EXPAND", "VERTICAL");

	Ihandle* tabs = IupTabs(
		IupVbox(
			IupLabel("Hello World"),
			NULL
		),
		IupVbox(
			IupHbox(
				IupLabel("Format:"),
				platformlist,
				NULL
			),
			IupHbox(
				blocklist,
				IupVbox(
//					IupMatrix(NULL),
					IupLabel("Checksum:"),
					NULL
				),
				NULL
			)
		),
		NULL
	);

	IupSetAttribute(tabs,"TABTITLE0", "Control");
	IupSetAttribute(tabs,"TABTITLE1", "Explore");

	Ihandle* dialog = IupDialog(tabs);
	IupSetAttribute(dialog, "TITLE", "CrO2 tape emulator");
	IupSetAttributeHandle(dialog, "MENU", menu);
	IupShow(dialog);

	IupMainLoop();

	IupClose();
}


int main(int argc, char **argv)
{
	//usb_dev_handle      *handle = NULL;
	unsigned char       buffer[275];
	int                 nBytes = 0;

    if(argc < 2){
		GUI_open(&argc, &argv);
		exit(0);
    }

	Device dev; // Constructor inits communication.
		// TODO handle thrown exceptions.

    if(strcmp(argv[1], "get") == 0){
		memset(buffer, 0, 275);
		nBytes = dev.read(buffer, sizeof(buffer));
    }else if(strcmp(argv[1], "put") == 0){

		while (dev.getStatus() & 8)
			usleep(1000000);

		FILE* fptr = fopen(argv[2], "rb");
		int blockid;
		uint8_t blktype, blksize;
		sscanf(argv[3], "%d", &blockid);

		do
		{
			do
			{
				fread(&blktype, 1, 1, fptr);
				if (feof(fptr))
				{
					fprintf(stderr, "end of file.\n");
					fclose(fptr);
					exit(0);
				}
			}
			while(blktype != 0x5A); // skip sync header

			fread(&blktype, 1, 1, fptr);
			fread(&blksize, 1, 1, fptr);
			blksize -= 2;
			fread(buffer, 1, blksize + 1, fptr);
			if (blktype == 0)
			{
				// new file
				printf("%.11s\n",buffer);
			}
		}
		while (blockid --);

		fclose(fptr);

		nBytes = dev.write(buffer, blksize, blktype);
    }else{
		GUI_open(&argc, &argv);
    }

	if (nBytes < 0) fprintf(stderr, "USB error %s\n", usb_strerror());
    return 0;
}

