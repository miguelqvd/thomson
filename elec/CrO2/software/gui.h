/* CrO2 datassette emulator
 * Copyright 2012, Adrien Destugues <pulkomandy@pulkomandy.ath.cx>
 *
 * Distributed under the terms of the MIT licence.
 */

#include "iupplusplus.h"

#include <cstdio>

class Tape;

class Gui {
	public:
		Gui(int* argc, char*** argv);
		~Gui();

	private:
		int menu_open();
		int menu_exit();

		Tape* file;

		// Control
		int setPlaying(int state);

		// Explore
		int selectBlock(int id, int what);
		int setMatVal(int x, int y, const char* newVal);
		const char* matVal(int y, int x);
		const char* toHex(int val);
		
		int selblock;
		Ihandle* blocklist;
		Ihandle* hexEd;
};
