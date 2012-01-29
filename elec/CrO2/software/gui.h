/* CrO2 datassette emulator
 * Copyright 2012, Adrien Destugues <pulkomandy@pulkomandy.ath.cx>
 *
 * Distributed under the terms of the MIT licence.
 */

#include "iupplusplus.h"

#include <cstdio>

class K5;

class Gui {
	public:
		Gui(int* argc, char*** argv);
		~Gui();

	private:
		int menu_open();
		int menu_exit();

		K5* file;
};
