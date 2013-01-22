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

class DeviceScanner: public BUSBRoster
{
	public:
		DeviceScanner(uint32_t vid, uint32_t pid, const char* vendor, const char* product);

		// BUSBRoster
		status_t DeviceAdded(BUSBDevice* device);
		void DeviceRemoved(BUSBDevice* device);

		BUSBDevice* handle;
	private:
		uint32_t vid, pid;
		const char* vendor, *product;
};

// Gets the device instance. Throws an error message if something bad happens.
Device& Device::getDevice() throw(const char*)
{
	if (instance == NULL) {
		DeviceScanner* scanner = new DeviceScanner(vid, pid, vendor, product);

		while(scanner->handle == NULL); // FIXME don't hog CPU, and timeout
		//throw "Device not found. Is the USB cable plugged correctly?";

		// We have our device, don't need the roster anymore.
		delete scanner;

		instance = new HaikuDevice(scanner->handle);
	}

	return *instance;
}


HaikuDevice::HaikuDevice(BUSBDevice* handle) throw(const char*)
{
	this->handle = handle;
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


DeviceScanner::DeviceScanner(uint32_t vid, uint32_t pid, const char* vendor, const char* product)
	: vid(vid)
	, pid(pid)
	, vendor(vendor)
	, product(product)
{
}


status_t DeviceScanner::DeviceAdded(BUSBDevice* device)
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


void DeviceScanner::DeviceRemoved(BUSBDevice* device)
{
	// This is only called for devices we accepted in DeviceAdded. We accept
	// only one, so we can safely remove it.
	handle = NULL;
}

