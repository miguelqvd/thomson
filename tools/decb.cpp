/* DECB - parse DECB file format.
 * Copyright 2013-2015, Adrien Destugues <pulkomandy@pulkomandy.tk>
 * This file is distributed under the terms of the MIT Licence.
 */

#include <vector>

#include <arpa/inet.h>

struct __attribute__((packed)) DECB_Chunk {
	uint8_t type;
	uint16_t length;
	uint16_t addr;
	std::vector<uint8_t> data;
};


bool DECB_ReadChunk(FILE* in, DECB_Chunk& out) {
	// Read the chunk header
	int value = fread(&out, 5, 1, in);
	if (value == 0)
		return false;

	// 6809 is little endian, take that into account...
	out.length = ntohs(out.length);
	out.addr = ntohs(out.addr);

	// Resize the data member to the proper size and read the data to it.
	out.data.reserve(out.length);
	fread(&out.data[0], out.length, 1, in);

	return true;
};
