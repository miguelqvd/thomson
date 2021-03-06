/* CrO2 datassette emulator
 * Copyright 2012, Adrien Destugues <pulkomandy@pulkomandy.ath.cx>
 *
 * Distributed under the terms of the MIT licence.
 *
 * Handles device communication through libusb
 */

#include "device_libusb.h"
#include "k5.h"

#include <typeinfo>

bool Device::initOnce = false;
Device* Device::instance = NULL;

const uint32_t Device::vid = 0x16C0;
const uint32_t Device::pid = 0x05DC;
const char* Device::vendor = "pulkomandy.ath.cx";
const char* Device::product = "CrO2";

/* These are the vendor specific commands implemented by our USB device */
#define PSCMD_CONFIG  0
#define PSCMD_GET   1
#define PSCMD_PUT   2
#define PSCMD_STATUS   3


// Gets the device instance. Throws an error message if something bad happens.
Device& Device::getDevice() throw(const char*)
{
	if (instance == NULL)
		instance = new LibUsbDevice();

	return *instance;
}


/* USB device lookup by VID and PID, then Vendor and Product strings, as we use
 * V-USB shared ID. */
static int  usbGetStringAscii(usb_dev_handle *dev, int index, int langid,
	char *buf, int buflen)
{
char    buffer[256];
int     rval, i;

    if((rval = usb_control_msg(dev, USB_ENDPOINT_IN, USB_REQ_GET_DESCRIPTOR,
			(USB_DT_STRING << 8) + index, langid, buffer, sizeof(buffer), 1000)) < 0)
        return rval;
    if(buffer[1] != USB_DT_STRING)
        return 0;
    if((unsigned char)buffer[0] < rval)
        rval = (unsigned char)buffer[0];
    rval /= 2;
    /* lossy conversion to ISO Latin1 */
    for(i=1;i<rval;i++){
        if(i > buflen)  /* destination buffer overflow */
            break;
        buf[i-1] = buffer[2 * i];
        if(buffer[2 * i + 1] != 0)  /* outside of ISO Latin1 range */
            buf[i-1] = '?';
    }
    buf[i-1] = 0;
    return i-1;
}

LibUsbDevice::LibUsbDevice() throw(const char*)
{
	handle = NULL;

	if (!initOnce)
	{
		initOnce = true;
		usb_init();
	}

    usb_find_busses();
    usb_find_devices();

    for(struct usb_bus* bus=usb_get_busses(); bus; bus=bus->next)
	{
		for(struct usb_device* dev=bus->devices; dev; dev=dev->next)
		{
			if(dev->descriptor.idVendor != vid || dev->descriptor.idProduct != pid)
				continue;

			// Found device with correct VID and PID. Now try to match the 
			// vendor and product strings
			char    string[256];
			int     len;
			handle = usb_open(dev);
				/* we need to open the device in order to query strings */
			if(!handle){
				continue;
			}
			/* now check whether the names match: */
			len = usbGetStringAscii(handle, dev->descriptor.iManufacturer,
				0x0409, string, sizeof(string));
			if(len >= 0)
			{
				if(strcmp(string, vendor) == 0){
					len = usbGetStringAscii(handle, dev->descriptor.iProduct,
						0x0409, string, sizeof(string));
					if(len >= 0){
						if(strcmp(string, product) == 0)
							break;
					}
				}
			}
			usb_close(handle);
			handle = NULL;
		}
		if(handle)
			break;
	}

	// At this point, either we have found a device and handle is pointing to it,
	// or we failed and handle is NULL.
	if (!handle)
		throw "Device not found. Is the USB cable plugged correctly?";
}


LibUsbDevice::~LibUsbDevice()
{
	usb_close(handle);
}


int LibUsbDevice::read(uint8_t* buffer, size_t max)
{
	return usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
		PSCMD_GET, 0,0, (char*)buffer, max, 5000);

}


int LibUsbDevice::write(const uint8_t* buffer, size_t size, int blktype)
{
	int rqtype = (size == 0) ? USB_ENDPOINT_IN:USB_ENDPOINT_OUT;
	return usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | rqtype,
		PSCMD_PUT, blktype,0 /*checksum*/, (char*)buffer, size, 5000);

}


uint8_t LibUsbDevice::getStatus()
{
	uint8_t status;
	usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN,
			PSCMD_STATUS, 0,0, (char*)&status, 1, 5000);
		// TODO handle errors (return value)
	return status;
}
