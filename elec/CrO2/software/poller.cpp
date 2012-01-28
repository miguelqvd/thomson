#include "poller.h"

#include "device.h"

#include <stdint.h>


	// Start status poller "thread"
	int pollStatus(Ihandle* ih)
	{
		uint8_t status = Device::getDevice().getStatus();
		if (status & 8)
			IupSetAttribute(motoron, "VALUE", "0"); // motor OFF
		else
			IupSetAttribute(motoron, "VALUE", "1"); // motor ON
		return IUP_DEFAULT;
	}

void startPolling() {
	Ihandle* timer = IupTimer();
	IupSetAttribute(timer, "TIME", "300");
	IupSetCallback(timer, "ACTION_CB", pollStatus);
	IupSetAttribute(timer, "RUN", "YES");
}
