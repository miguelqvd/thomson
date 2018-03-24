/*
 * fd2sd.c
 * Copyright (C) 2018 pulkomandy <pulkomandy@kitt>
 *
 * Converts FD files to SD, for use with SDMOTO
 * Essentially this just pads 256 byte sectors to 512 bytes.
 *
 * Distributed under terms of the MIT license.
 */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
	if (argc < 3 || strcmp(argv[1], "--help") == 0)
	{
		fprintf(stderr,
			"%s infile outfile\n",
			argv[0]);
		return 1;
	}

	FILE* f1;
   	FILE* f2;

	f1 = fopen(argv[1], "rb");

	if (f1 < 0) {
		perror("Could not open input file");
		exit(-1);
	}

	f2 = fopen(argv[2], "wb");

	if (f2 < 0) {
		perror("Could not open output file");
		exit(-2);
	}

	char buffer[512];
	int i = 0;

	for (;;) {
		int v = fread(buffer, 1, 256, f1);
		if (v <= 0)
			break;
		fwrite(buffer, 1, v, f2);
		memset(buffer, 0xFF, 512 - v);
		fwrite(buffer, 1, 512 - v, f2);
		printf("Wrote %d bytes in sector %d.\n", v, i++);
	}

	return 0;
}
