/* BinXPloder - split a Thomson binary file in separate sections
 * Copyright 2013, Adrien Destugues <pulkomandy@pulkomandy.tk>
 * This file is distributed under the terms of the MIT Licence.
 */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "decb.cpp"

int main(int argc, char* argv[])
{
	bool listOnly = false;

	if (argc < 2 || strcmp(argv[1], "--help") == 0)
	{
		fprintf(stderr,
			"%s file.bin [-l]\n(-l: list only, don't write sections)\n",
			argv[0]);
		return 1;
	}

	if (argc > 2)
		listOnly = true; // FIXME use getopt or something

	FILE* f1, * f2;
	uint8_t i = 0;
	DECB_Chunk h;
	char* buf = NULL;

	f1 = fopen(argv[1], "rb");

	if (f1 < 0)
	{
		perror("Could not open input file");
		exit(-1);
	}

	if (!listOnly) 
		buf = (char*)malloc(strlen(argv[1] + 3));

	while(DECB_ReadChunk(f1, h))
	{
		printf("Type: %02x - Size: %04x - %s: %04x\n", h.type, h.length,
			h.type == 0xFF ? "Exec" : "Load", h.addr);

		if (!listOnly)
		{
			sprintf(buf, "%s.%02x", argv[1], i++);
			f2 = fopen(buf, "wb");

			fwrite(&h.data[0], h.length, 1, f2);

			fclose(f2);
		}
	}

	free(buf);
	fclose(f1);
	return 0;
}
