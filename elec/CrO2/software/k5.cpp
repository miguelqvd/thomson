/* CrO2 datassette emulator
 * Copyright 2012, Adrien Destugues <pulkomandy@pulkomandy.ath.cx>
 *
 * Distributed under the terms of the MIT licence.
 */

#include "k5.h"

#include <fstream>
#include <string.h>

K5::K5(const char* name) throw (const char*)
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
		Block* block = new Block(blksize, blktype);
		stream.read((char*)block->data, block->length);

		blocks.push_back(block);
	} while (stream.good());


	stream.close();
}


K5::Block::Block(int length, uint8_t type)
	: Tape::Block(length)
{
	this->type = type;
}

bool K5::Block::isFile() const
{
	return type == 0;
}

bool K5::Block::isControl() const
{
	return (type == 0) || (type == 0xFF);
}

const std::string K5::Block::getName() const
{
	if (isFile())
	{
		char name[12];
		memcpy(name, data, 11);
		name[11] = 0;
		return std::string(name);
	}

	if (isControl()) return std::string("EOF");
	return std::string("DATA");
}
