/* CrO2 datassette emulator
 * Copyright 2013, Adrien Destugues <pulkomandy@pulkomandy.tk>
 *
 * Distributed under the terms of the MIT licence.
 *
 * High-level device management functions shared by all implementations.
 */

#include "device.h"
#include "k5.h"
#include "Tape.h"

#include <typeinfo>
#include <unistd.h>


bool Device::initOnce = false;
Device* Device::instance = NULL;

const uint32_t Device::vid = 0x16C0;
const uint32_t Device::pid = 0x05DC;
const char* Device::vendor = "pulkomandy.ath.cx"; // FIXME update
const char* Device::product = "CrO2";


void Device::write(const Tape& file) throw (const char*)
{
	for (int k = 0; k < file.getBlockCount(); k++)
	{
		// wait for motor on
		while (getStatus() & 8)
			usleep(1000 * 1000);

		const Tape::Block& block = file.getBlock(k);
		try {
			const K5::Block& moblock = dynamic_cast<const K5::Block&>(block); 
			write(moblock.data, moblock.length - 1, moblock.type);
				// TODO error handling on write
		} catch (std::bad_cast x) {
			throw "Only MO5 files supported so far. Sorry!";
		};

		// TODO wait for correct time (read status from usb OR compute from size+type)
		usleep(1400 * 1000);
	}
}

