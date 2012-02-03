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
    if(argc < 2){
		Gui gui(&argc, &argv);
		exit(0);
    }

	try {
		Device& dev = Device::getDevice(); // Constructor inits communication.

		if(strcmp(argv[1], "get") == 0){
			int                 nBytes = 0;
			unsigned char       buffer[275];
			memset(buffer, 0, 275);
			nBytes = dev.read(buffer, sizeof(buffer));
			if (nBytes < 0) fprintf(stderr, "USB error %s\n", usb_strerror());
		}else if(strcmp(argv[1], "put") == 0){

			// load file
			K5 file(argv[2]);

			dev.write(file);
		}else{
			// TODO print usage
			exit(2);
		}

		return 0;
	}
	catch(const char* error)
	{
		std::cerr << error << std::endl;
	}

	exit(0);
}

