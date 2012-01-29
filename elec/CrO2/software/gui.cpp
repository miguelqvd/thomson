/* CrO2 datassette emulator
 * Copyright 2012, Adrien Destugues <pulkomandy@pulkomandy.ath.cx>
 *
 * Distributed under the terms of the MIT licence.
 */

#include "gui.h"

#include "device.h"
#include "k5.h"

#include <stdint.h>
#include <iup.h>
#include <iupcontrols.h>

///////////////////////////////////////////////////////////////////////////////
// Super awesome extended powerful ultimate deluxe C++ IUP callback system ;)

typedef int (Gui::*Callee)();

class Callback
{
	public:
		static int call(Ihandle* that);
		static int destroy(Ihandle* that);
		static void create(Ihandle* handle, const char* name, Gui* self, Callee what);

	private:
		Callback(Gui* self, Callee what);
		Callback(); // do not use

		Gui* self;
		Callee what;
};

void Callback::create(Ihandle* handle,const char* name, Gui* self, Callee what)
{
	Callback* cb = new Callback(self, what);
	IupSetAttribute(handle, "LCALLBACK", (char*)cb);
	IupSetCallback(handle, name, Callback::call);
	IupSetCallback(handle, "LDESTROY_CB", Callback::destroy);
}

Callback::Callback(Gui* self, Callee what)
{
	this->self = self;
	this->what = what;
}

int Callback::call(Ihandle* that)
{
	Callback* call = (Callback*)IupGetAttribute(that, "LCALLBACK");
	return ((call->self)->*(call->what))();
}

int Callback::destroy(Ihandle* that)
{
	Callback* call = (Callback*)IupGetAttribute(that, "LCALLBACK");
	delete call;
	return IUP_DEFAULT;
}

///////////////////////////////////////////////////////////////////////////////

	// Start status poller "thread"
	int pollStatus(Ihandle* ih)
	{
		Ihandle* motoron = (Ihandle*)IupGetAttribute(ih, "target");

		uint8_t status = Device::getDevice().getStatus();
		if (status & 8)
			IupSetAttribute(motoron, "VALUE", "0"); // motor OFF
		else
			IupSetAttribute(motoron, "VALUE", "1"); // motor ON
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

int menu_exit(Ihandle* that)
{
	return IUP_CLOSE;
}



Gui::Gui(int* argc, char*** argv)
{
	file = NULL;

	IupOpen(argc, argv);
//	IupControlsOpen();

	IupSetFunction("EXIT", menu_exit);

	Ihandle* menu_open = IupItem("Open", NULL);
	Callback::create(menu_open, "ACTION", this, &Gui::menu_open);

	Ihandle* menu = IupMenu(
		IupSubmenu("File",
			IupMenu(
				menu_open,		
				IupItem("Exit", "EXIT"),
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

	Ihandle* tabs = IupTabs(
		IupVbox(
			IupHbox(
				IupLabel("Motor"),
				motoron,
				NULL
			),
			IupHbox(
				IupToggle("play",NULL),
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
