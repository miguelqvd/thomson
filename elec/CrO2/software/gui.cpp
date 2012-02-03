/* CrO2 datassette emulator
 * Copyright 2012, Adrien Destugues <pulkomandy@pulkomandy.ath.cx>
 *
 * Distributed under the terms of the MIT licence.
 */

#include "gui.h"

#include "device.h"
#include "k5.h"

#include <stdint.h>
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
//	IupControlsOpen();

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

	// EXPLORE
	Ihandle* platformlist = IupList(NULL);
	IupSetAttribute(platformlist, "EXPAND", "HORIZONTAL");
	IupSetAttribute(platformlist, "DROPDOWN", "YES");
	IupSetAttribute(platformlist, "1", "MO5");
	IupSetAttribute(platformlist, "VALUE", "1");

	Ihandle* blocklist = IupTree();
	IupSetAttribute(blocklist, "EXPAND", "VERTICAL");

	Ihandle* playToggle = IupToggle("play", NULL);
	Callback<Gui, int>::create(playToggle, "ACTION", this, &Gui::setPlaying);

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

	// Run the timer
	startPolling(motoron);

	IupMainLoop();

	IupClose();
}


Gui::~Gui()
{
	delete file;
}


int Gui::menu_open()
{
	char name[65536];
	name[0] = 0;
	if (IupGetFile(name) == 0)
	{
		// Load file
		file = new K5(name);
	}
	return IUP_DEFAULT;
}

int Gui::menu_exit()
{
	return IUP_CLOSE;
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
