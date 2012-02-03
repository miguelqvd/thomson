/* CrO2 datassette emulator
 * Copyright 2012, Adrien Destugues <pulkomandy@pulkomandy.ath.cx>
 *
 * Distributed under the terms of the MIT licence.
 */

#include "k5.h"

#include <fstream>
#include <string.h>

K5::Block::Block(int length,uint8_t type)
{
	this->length = length;
	data = new uint8_t[length];
	this->type = type;
}

K5::Block::Block(const Block& other)
{
	length = other.length;
	type = other.type;
	data = new uint8_t[length];
	memcpy(data, other.data, length);
}

const K5::Block& K5::Block::operator=(const Block& other)
{
	delete[] data;
		// May not be null ?

	length = other.length;
	type = other.type;
	data = new uint8_t[length];
	memcpy(data, other.data, length);

	return *this;
}

K5::Block::~Block()
{
	delete[] data;
}


K5::K5(const char* name)
{
	std::ifstream stream(name, std::ifstream::in | std::ifstream::binary);

	if (!stream.is_open()) throw "Could not open file.";
	if (!stream.good()) throw "File error.";

	uint8_t byte;

	do {
		do {
			byte = stream.get();
			if (stream.eof())
				return;
		} while (byte != 0x5A); // Skip pilot tone and sync bytes
		// TODO make sure this is a standard block ?

		uint8_t blktype = stream.get();
		int blksize = stream.get(); // includes checksum
		if (blksize == 0) blksize = 256;
		blksize --;
		Block block(blksize, blktype);
		stream.read((char*)block.data, block.length);

		blocks.push_back(block);
/*
		if (block.type == 0)
		{
			printf("FILE: %.11s\n",block.data);
		}
		
		printf("blk type %d size %d (%d)\n", block.type, block.length, (int)stream.tellg());
*/
	} while (stream.good());


	stream.close();
}

int K5::getBlockCount()
{
	return blocks.size();
}

K5::Block K5::getBlock(int id)
{
	return blocks[id];
}
