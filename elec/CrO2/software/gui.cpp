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
#include <ios>

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

	hexEd = IupMatrix(NULL);

	// Setup title cells
	IupSetAttribute(hexEd, "FONT", "Courier, 10");
	IupSetAttribute(hexEd, "FONT*:17", "Courier, 10");
	IupSetAttribute(hexEd, "NUMCOL", "17");
	IupSetAttribute(hexEd, "WIDTHDEF", "10");
	IupSetAttribute(hexEd, "WIDTH17", "105");
	IupSetAttribute(hexEd, "WIDTH0", "12");
	IupSetAttribute(hexEd, "HEIGHT0", "8");
	IupSetAttribute(hexEd, "SIZE", "400x230");
	IupSetAttribute(hexEd, "EXPAND", "YES");
	IupSetAttribute(hexEd, "ALIGNMENT", "ALEFT");
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
		try {
			file = Tape::load(name);
		} catch (const char* error) {
			puts(error);
			return IUP_DEFAULT;
		}

		// Fill in EXPLORE tab
		int count = file->getBlockCount();
		int lastfile = -1;

		IupSetAttribute(blocklist, "DELNODE", "ALL");

		for (int i = 0; i < count; ++i)
		{
			const Tape::Block& blk = file->getBlock(i);
			if (blk.isFile())
			{
				IupSetAttributeId(blocklist, "INSERTBRANCH", lastfile, blk.getName().c_str());
				lastfile = i;
			} else {
				IupSetAttributeId(blocklist, "ADDLEAF", i-1, blk.getName().c_str());
				if (blk.isControl())
					IupSetAttributeId(blocklist, "IMAGE", i, "IMGLEAF");
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
		selblock = id;
		std::ostringstream att;
		att << (file->getBlock(id).length / 16);
		IupSetAttribute(hexEd, "NUMLIN", att.str().c_str());

		IupSetAttribute(hexEd, IUP_REDRAW, "ALL");
	} else if (selblock == id) {
		selblock = -1;
	}

	return IUP_DEFAULT;
}

const char* Gui::matVal(int y, int x)
{
	if (y == 0)
	{
		switch(x)
		{
			case 0:
				return "0x";
			case 17:
				return "ASCII";
			default:
			{
				std::ostringstream name;
				name << std::hex;
				name << (x-1);
				return name.str().c_str();
			}
		}
	}

	if (x == 0)
	{
		std::ostringstream name;
		name << std::hex;
		name << (y-1)*16;
		return name.str().c_str();
	}

	if (file == NULL || selblock < 0 || selblock >= file->getBlockCount())
		return "";
	const Tape::Block& block = file->getBlock(selblock);

	if (x == 17)
	{
		int off = (y-1)*16;
		std::ostringstream txt;
		for(int j = 0; j < 16; j++)
		{
			if (off + j >= block.length)
				break;
			char c = block.data[off+j];
			if (isprint(c))
				txt << c;
			else
				txt << '.';
		}
		return txt.str().c_str();
	} else {

		int pos = (y-1) * 16 + (x-1);
		if (pos >= block.length)
			return "";

		return toHex(block.data[pos]);
	}
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

const char* Gui::toHex(int val)
{
	std::ostringstream str;
	str.flags(std::ios_base::hex | std::ios_base::uppercase);
	str.width(2);
	str.fill('0');
	str << val;
	return str.str().c_str();
}
