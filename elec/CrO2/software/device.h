/* CrO2 datassette emulator
 * Copyright 2012, Adrien Destugues <pulkomandy@pulkomandy.ath.cx>
 *
 * Distributed under the terms of the MIT licence.
 *
 * Handles device communication through libusb
 */

#include <stdint.h>

#include <lusb0_usb.h>    /* this is libusb, see http://libusb.sourceforge.net/ */

class Device
{
	public:
		static Device& getDevice() throw(const char*);

		~Device();

		int read(uint8_t* buffer, size_t max); // Fill the buffer with data from device
		int write(uint8_t* buffer, size_t size, int blktype);
		uint8_t getStatus();

	private:
		Device() throw(const char*); // Open device and set it up for communication
		Device(const Device& other);


		usb_dev_handle* handle;

		static bool initOnce;
		static Device* instance;

		static const uint32_t vid;
		static const uint32_t pid;
		static const char* vendor;
		static const char* product;
};
