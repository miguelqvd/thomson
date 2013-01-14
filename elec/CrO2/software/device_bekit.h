/* CrO2 datassette emulator
 * Copyright 2013, Adrien Destugues <pulkomandy@pulkomandy.tk>
 *
 * Distributed under the terms of the MIT licence.
 *
 * Handles device communication through Haiku USB Kit
 */

#include "device.h"

#include <stdint.h>
#include <USBKit.h>

class Tape;

class HaikuDevice: public Device, BUSBRoster
{
	public:
		~HaikuDevice();

		// Device
		int read(uint8_t* buffer, size_t max);
			// Fill the buffer with data from device
		int write(const uint8_t* buffer, size_t size, int blktype);
		uint8_t getStatus();

		// BUSBRoster
		status_t DeviceAdded(BUSBDevice* device);
		void DeviceRemoved(BUSBDevice* device);
	private:
		HaikuDevice() throw(const char*);
			// Open device and set it up for communication
		HaikuDevice(const Device& other);

		BUSBDevice* handle;

		friend Device& Device::getDevice();
};
