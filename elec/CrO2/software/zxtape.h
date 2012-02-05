/* CrO2 datassette emulator
 * Copyright 2012, Adrien Destugues <pulkomandy@pulkomandy.ath.cx>
 *
 * Distributed under the terms of the MIT licence.
 */

#include "Tape.h"

class ZXTAP: public Tape {
	public:
		friend class Tape;

		class Block: public Tape::Block
		{
			public:
				Block(int length);

				bool isFile() const;
				bool isControl() const;
				const std::string getName() const;
			private:
				Block() = delete;
		};

	private:
		ZXTAP(const char* filename) throw(const char*);
		ZXTAP() = delete;
};
