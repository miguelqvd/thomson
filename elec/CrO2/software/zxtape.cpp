/* CrO2 datassette emulator
 * Copyright 2012, Adrien Destugues <pulkomandy@pulkomandy.ath.cx>
 *
 * Distributed under the terms of the MIT licence.
 */

#include "zxtape.h"

#include <fstream>
#include <iostream>
#include <string.h>

ZXTAP::ZXTAP(const char* name) throw (const char*)
{
	std::ifstream stream(name, std::ifstream::in | std::ifstream::binary);

	if (!stream.is_open()) throw "Could not open file.";
	if (!stream.good()) throw "File error.";

	uint16_t blksize;
	do {
		stream.read((char*)&blksize,sizeof(blksize));

		Block* block = new Block(blksize);
		stream.read((char*)block->data, block->length);

		blocks.push_back(block);
	} while (stream.good());

	stream.close();
}

ZXTAP::Block::Block(int length)
	: Tape::Block(length)
{
}

bool ZXTAP::Block::isFile() const
{
	return data[0] == 0;
}

bool ZXTAP::Block::isControl() const
{
	return isFile();
}

const std::string ZXTAP::Block::getName() const
{
	if (isFile())
	{
		char name[11];
		memcpy(name, data+2, 10);
		name[10] = 0;
		return std::string(name);
	}

	if (isControl()) return std::string("EOF");
	return std::string("DATA");
}
