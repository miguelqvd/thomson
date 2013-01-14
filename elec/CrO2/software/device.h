/* CrO2 datassette emulator
 * Copyright 2012, Adrien Destugues <pulkomandy@pulkomandy.ath.cx>
 *
 * Distributed under the terms of the MIT licence.
 *
 * Handles device communication through libusb
 */

#include <stdint.h>
#include <string.h>

class Tape;

class Device
{
	public:
		// Implemented in subclasses object files. Only one of them is linked
		// and takes care of instanciating itself.
		static Device& getDevice() throw(const char*);

		// High-level layer (will call functions below)
		void write(const Tape& file) throw (const char*);

		// Low-level layer (to be implemented by subclasses
		virtual int read(uint8_t* buffer, size_t max) = 0;
			// Fill the buffer with data from device
		virtual int write(const uint8_t* buffer, size_t size, int blktype) = 0;
		virtual uint8_t getStatus() = 0;
			// Get the status word from the device

	protected:
		/* These are the vendor specific commands implemented by our USB device */
		static const int PSCMD_CONFIG = 0;
		static const int PSCMD_GET = 1;
		static const int PSCMD_PUT = 2;
		static const int PSCMD_STATUS = 3;

		static const uint32_t vid;
		static const uint32_t pid;
		static const char* vendor;
		static const char* product;
	private:
		static bool initOnce;
		static Device* instance;
};
