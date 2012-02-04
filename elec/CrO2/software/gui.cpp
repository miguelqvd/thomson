/* CrO2 datassette emulator
 * Copyright 2012, Adrien Destugues <pulkomandy@pulkomandy.ath.cx>
 *
 * Distributed under the terms of the MIT licence.
 */

#include "gui.h"

#include "device.h"
#include "k5.h"

#include <stdint.h>
#include <string.h>
#include <sstream>
#include <iostream>

#include <iupcontrols.h>

	// Start status poller "thread"
int pollStatus(Ihandle* ih)
{
	try {
		Ihandle* motoron = (Ihandle*)IupGetAttribute(ih, "target");

		uint8_t status = Device::getDevice().getStatus();
		if (status & 8)
			IupSetAttribute(motoron, "VALUE", "0"); // motor OFF
		else
			IupSetAttribute(motoron, "VALUE", "1"); // motor ON
	} catch(const char*) {
		// Silently ignore exception if device is not available - not a good
		// idea to handle it from a timer...
		// Keep the timer running so it starts working when the device is
		// plugged
	}
	return IUP_DEFAULT;
}

void startPolling(Ihandle* target) {
	Ihandle* timer = IupTimer();

	IupSetAttribute(timer, "target", (const char*)target);

	IupSetAttribute(timer, "TIME", "300");
	IupSetCallback(timer, "ACTION_CB", pollStatus);
	IupSetAttribute(timer, "RUN", "YES");
}

/* UI */

Gui::Gui(int* argc, char*** argv)
{
	file = NULL;

	IupOpen(argc, argv);
	IupControlsOpen();

	Ihandle* menu_open = IupItem("Open", NULL);
	Ihandle* menu_exit = IupItem("Exit", NULL);
	Callback<Gui>::create(menu_open, "ACTION", this, &Gui::menu_open);
	Callback<Gui>::create(menu_exit, "ACTION", this, &Gui::menu_exit);

	Ihandle* menu = IupMenu(
		IupSubmenu("File",
			IupMenu(
				menu_open,		
				menu_exit,
				NULL
			)
		),
		NULL
	);

	// CONTROL
	Ihandle* motoron = IupProgressBar();
	IupSetAttribute(motoron, "RASTERSIZE", "16x16");

	Ihandle* playToggle = IupToggle("play", NULL);
	Callback<Gui, int, int>::create(playToggle, "ACTION", this, &Gui::setPlaying);

	// EXPLORE
	Ihandle* platformlist = IupList(NULL);
	IupSetAttribute(platformlist, "EXPAND", "HORIZONTAL");
	IupSetAttribute(platformlist, "DROPDOWN", "YES");
	IupSetAttribute(platformlist, "1", "MO5");
	IupSetAttribute(platformlist, "VALUE", "1");

	blocklist = IupTree();
	IupSetAttribute(blocklist, "EXPAND", "VERTICAL");
	IupSetAttribute(blocklist, "ADDEXPANDED", "NO");
	IupSetAttribute(blocklist, "ADDROOT", "NO");
	IupSetAttribute(blocklist, "IMAGELEAF", "IMGBLANK");
	IupSetAttribute(blocklist, "RASTERSIZE", "140x200");
	Callback<Gui, int, int, int>::create(blocklist, "SELECTION_CB", this, &Gui::selectBlock);

	Ihandle* hexEd = IupMatrix(NULL);

	// Setup title cells
	IupSetAttribute(hexEd, "NUMLIN", "16");
	IupSetAttribute(hexEd, "NUMCOL", "17");
	IupSetAttribute(hexEd, "WIDTHDEF", "12");
	IupSetAttribute(hexEd, "WIDTH17", "48");
	IupSetAttribute(hexEd, "USETITLESIZE", "YES");
	IupSetAttribute(hexEd, "FONT", "Courier, Bold 12");
	IupSetAttribute(hexEd, "EXPAND", "YES");
	Callback<Gui, const char*, int, int>::create(hexEd, "VALUE_CB", this, &Gui::matVal);
	
	// WINDOW LAYOUT
	Ihandle* tabs = IupTabs(
		IupVbox(
			IupHbox(
				IupLabel("Motor"),
				motoron,
				NULL
			),
			IupHbox(
				playToggle,
				IupToggle("REC",NULL),
				NULL
			),
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
					hexEd,
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

	// Run the timer
	startPolling(motoron);

	// TODO the IUP main loop is blocking - it may be wise to move it out of
	// the constructor...
	IupMainLoop();
}


Gui::~Gui()
{
	delete file;

	IupControlsClose();
	IupClose();
}


int Gui::menu_open()
{
	char name[65536];
	name[0] = 0;
	if (IupGetFile(name) == 0)
	{
		// Load file
		file = new K5(name);

		// Fill in EXPLORE tab
		int count = file->getBlockCount();
		int lastfile = -1;

		for (int i = 0; i < count; ++i)
		{
			const K5::Block& blk = file->getBlock(i);
			switch(blk.type)
			{
				case 0:
					//start block
					char name[12];
					memcpy(name, blk.data, 11);
					name[11] = 0;
					
					IupSetAttributeId(blocklist, "INSERTBRANCH", lastfile, name);
					lastfile = i;
					break;
				case 0xFF:
					// end block
					IupSetAttributeId(blocklist, "ADDLEAF", i-1, "EOF");
					IupSetAttributeId(blocklist, "IMAGE", i, "IMGLEAF");
					break;
				default:
					// regular block
					IupSetAttributeId(blocklist, "ADDLEAF", i-1, "DATA");
					break;
			}
		}
	}
	return IUP_DEFAULT;
}

int Gui::menu_exit()
{
	return IUP_CLOSE;
}

int Gui::selectBlock(int id, int what)
{
	if (what)
	{
		IupSetAttribute(hexEd, "REDRAW", "ALL");
	}

	return IUP_DEFAULT;
}

const char* Gui::matVal(int x, int y)
{
	if (x == 0)
	{
		switch(y)
		{
			case 0:
				return "0x";
			case 17:
				return "ASCII";
			default:
			{
				std::ostringstream name;
				name << std::hex;
				name << (y-1);
				return name.str().c_str();
			}
		}
	}

	if (y == 0)
	{
		return "C";
	}

	return "V";
}

int Gui::setPlaying(int state)
{
	if (state == 0)
	{
		// pause
	} else {
		// play
		Device::getDevice().write(*file);
	}

	return IUP_DEFAULT;
}
