/* CrO2 datassette emulator
 * Copyright 2013, Adrien Destugues <pulkomandy@pulkomandy.tk>
 *
 * Distributed under the terms of the MIT licence.
 *
 * Handles device communication through libusb
 */

#include "device_bekit.h"
#include "k5.h"

#include <typeinfo>
#include <USBKit.h>


// Gets the device instance. Throws an error message if something bad happens.
Device& Device::getDevice() throw(const char*)
{
	if (instance == NULL) {
		instance = new HaikuDevice();
	}

	return *instance;
}


HaikuDevice::HaikuDevice() throw(const char*)
{
	// At this point, either we have found a device and handle is pointing to it,
	// or we failed and handle is NULL.
	if (!handle)
		throw "Device not found. Is the USB cable plugged correctly?";
}


HaikuDevice::~HaikuDevice()
{
	delete handle;
}


int HaikuDevice::read(uint8_t* buffer, size_t max)
{
	return handle->ControlTransfer(USB_REQTYPE_VENDOR | USB_REQTYPE_ENDPOINT_IN,
		PSCMD_GET, 0,0, max, (char*)buffer);

}


int HaikuDevice::write(const uint8_t* buffer, size_t size, int blktype)
{
	int rqtype = (size == 0) ? USB_REQTYPE_ENDPOINT_IN:USB_REQTYPE_ENDPOINT_OUT;
	return handle->ControlTransfer(USB_REQTYPE_VENDOR | rqtype,
		PSCMD_PUT, blktype,0 /*checksum*/, size, (char*)buffer);

}


uint8_t HaikuDevice::getStatus()
{
	uint8_t status;
	handle->ControlTransfer(USB_REQTYPE_VENDOR | USB_REQTYPE_ENDPOINT_IN,
			PSCMD_STATUS, 0,0, 1, (char*)&status);
		// TODO handle errors (return value)
	return status;
}


status_t HaikuDevice::DeviceAdded(BUSBDevice* device)
{
	if (handle != NULL) {
		// We already have a device !
		return B_ERROR;
	}

	// Check if the device matches what we can handle
	
	if (device->VendorID() != vid && device->ProductID() != pid)
		return B_ERROR;

	// Since we use V-USB shared vid/pid pair, we also have to check the
	// manufacturer and product strings to actually identify the device amongst
	// other users of the pair.
	if (strcmp(device->ManufacturerString(), vendor) != 0)
		return B_ERROR;

	if (strcmp(device->ProductString(), product) != 0)
		return B_ERROR;

	// Ok, we have found our device !
	handle = device;
	return B_OK;
}


void HaikuDevice::DeviceRemoved(BUSBDevice* device)
{
	// This is only called for devices we accepted in DeviceAdded. We accept
	// only one, so we can safely remove it.
	handle = NULL;
}

