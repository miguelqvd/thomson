/* CrO2 datassette emulator
 * Copyright 2012, Adrien Destugues <pulkomandy@pulkomandy.ath.cx>
 *
 * Distributed under the terms of the MIT licence.
 *
 * Handles device communication through libusb
 */

#include <stdint.h>
#include <lusb0_usb.h>

class Tape;

class LibUSBDevice: public Device
{
	public:
		~LibUSBDevice();

		int read(uint8_t* buffer, size_t max);
			// Fill the buffer with data from device
		int write(const uint8_t* buffer, size_t size, int blktype);
		uint8_t getStatus();

	private:
		LibUSBDevice() throw(const char*);
			// Open device and set it up for communication
		LibUSBDevice(const Device& other);


		usb_dev_handle* handle;
};
