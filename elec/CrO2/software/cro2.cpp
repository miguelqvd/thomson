/* CrO2 datassette emulator
 * Copyright 2012, Adrien Destugues <pulkomandy@pulkomandy.ath.cx>
 *
 * Distributed under the terms of the MIT licence.
 */

#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>


#include "device.h"
#include "k5.h"
#include "gui.h"

int main(int argc, char **argv)
{
	int                 nBytes = 0;

    if(argc < 2){
		Gui gui(&argc, &argv);
		exit(0);
    }

	try {
		Device& dev = Device::getDevice(); // Constructor inits communication.

		if(strcmp(argv[1], "get") == 0){
			unsigned char       buffer[275];
			memset(buffer, 0, 275);
			nBytes = dev.read(buffer, sizeof(buffer));
		}else if(strcmp(argv[1], "put") == 0){

			// load file
			K5 file(argv[2]);

			for (int k = 0; k < file.getBlockCount(); k++)
			{
				// wait for motor on
				while (dev.getStatus() & 8)
					Sleep(1000);

				K5::Block block = file.getBlock(k);

				nBytes = dev.write(block.data, block.length - 1, block.type);

				// TODO wait for correct time (read status from usb OR compute from size+type)
				Sleep(1400);
			}
		}else{
			// TODO print usage
			exit(2);
		}

		if (nBytes < 0) fprintf(stderr, "USB error %s\n", usb_strerror());
		return 0;
	}
	catch(const char* error)
	{
		std::cerr << error << std::endl;
	}

	exit(0);
}

