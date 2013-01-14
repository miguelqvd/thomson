/* CrO2 datassette emulator
 * Copyright 2012, Adrien Destugues <pulkomandy@pulkomandy.ath.cx>
 *
 * Distributed under the terms of the MIT licence.
 */
#ifndef __TAPE_H__
#define __TAPE_H__

#include <stdint.h>
#include <string>
#include <vector>

class Tape {
	public:
		class Block {
			public:
				Block(int length);
				Block(const Block& other);
				virtual ~Block();
				const Block& operator=(const Block& other);

				virtual bool isFile() const = 0;
					// Does this block mark the start of a file ?
				virtual bool isControl() const = 0;
					// Is this block a control (sync, eof, ...) or data block ?
				virtual const std::string getName() const = 0;

				int length;
				uint8_t* data;
			private:
				Block() = delete;
		};

		virtual ~Tape();

		static Tape* load(const char* filename) throw (const char*);

		int getBlockCount() const;
		Block& getBlock(int number);
		const Block& getBlock(int number) const;
	protected:
		Tape() {};
		std::vector<Block*> blocks;
};

#endif

