/* BinXPloder - split a Thomson binary file in separate sections
 * Copyright 2013, Adrien Destugues <pulkomandy@pulkomandy.tk>
 * This file is distributed under the terms of the MIT Licence.
 */

#include <arpa/inet.h>

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct __attribute__((packed)) Header {
	uint8_t type;
	uint16_t length;
	uint16_t addr;
};

int main(int argc, char* argv[])
{
	FILE* f1, * f2;
	Header h;

	if (argc < 2)
	{
		fprintf(stderr, "%s file.bin\n", argv[0]);
		return 1;
	}

	f1 = fopen(argv[1], "rb");

	char* buf = (char*)malloc(strlen(argv[1] + 3));
	uint8_t i;

	while(fread(&h, sizeof(h), 1, f1))
	{
		// 6809 is little endian, take that into account...
		h.length = ntohs(h.length);
		h.addr = ntohs(h.addr);

		printf("Type: %02x - Size: %04x - Load: %04x\n", h.type, h.length, h.addr);

		sprintf(buf, "%s.%02x", argv[1], i++);
		f2 = fopen(buf, "wb");

		char* b2 = (char*)malloc(h.length);
		fread(b2, h.length, 1, f1);
		fwrite(b2, h.length, 1, f2);

		free(b2);
		fclose(f2);
	}

	free(buf);

	fclose(f1);

	return 0;
}
