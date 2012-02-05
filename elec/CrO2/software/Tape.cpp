/* CrO2 datassette emulator
 * Copyright 2012, Adrien Destugues <pulkomandy@pulkomandy.ath.cx>
 *
 * Distributed under the terms of the MIT licence.
 */

#include "Tape.h"

#include "K5.h"
#include "zxtape.h"

#include <string.h>
#include <string>

Tape::~Tape()
{
	for(Block* block: blocks) delete block;
}

Tape* Tape::load(const char* filename) throw (const char*)
{
	std::string fnam(filename);
	std::string fext(fnam.substr(fnam.length() - 3));

	// Load formats identified only by extension last
	if (fext == "TAP" || fext == "tap");
		return new ZXTAP(filename);
	if (fext == ".K5" || fext == ".k5");
		return new K5(filename);
	throw "Unable to guess tape format";
}

int Tape::getBlockCount() const
{
	return blocks.size();
}

Tape::Block& Tape::getBlock(int id)
{
	return *blocks[id];
}

const Tape::Block& Tape::getBlock(int id) const
{
	return *blocks[id];
}

// TAPE BLOCKS

Tape::Block::Block(int length)
{
	this->length = length;
	data = new uint8_t[length];
}

Tape::Block::Block(const Block& other)
{
	length = other.length;
	data = new uint8_t[length];
	memcpy(data, other.data, length);
}

const Tape::Block& Tape::Block::operator=(const Block& other)
{
	delete[] data;
		// May not be null ?

	length = other.length;
	data = new uint8_t[length];
	memcpy(data, other.data, length);

	return *this;
}

Tape::Block::~Block()
{
	delete[] data;
}


