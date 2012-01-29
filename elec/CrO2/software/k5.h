/* CrO2 datassette emulator
 * Copyright 2012, Adrien Destugues <pulkomandy@pulkomandy.ath.cx>
 *
 * Distributed under the terms of the MIT licence.
 */

#include <stdint.h>
#include <vector>

class K5 {
	public:
		K5(const char* filename);

		class Block {
			public:
				Block(int length, uint8_t type);
				Block(const Block& other);
				~Block();

				int length;
				uint8_t* data;
				uint8_t type;
		};

		int getBlockCount();
		Block getBlock(int number);

	private:
		std::vector<Block> blocks;
};
