/* CrO2 datassette emulator
 * Copyright 2012, Adrien Destugues <pulkomandy@pulkomandy.ath.cx>
 *
 * Distributed under the terms of the MIT licence.
 */

#include "Tape.h"

class K5: public Tape {
	public:
		friend class Tape;

		class Block: public Tape::Block
		{
			public:
				Block(int length, uint8_t type);

				bool isFile() const;
				bool isControl() const;
				const std::string getName() const;

				uint8_t type;
			private:
				Block() = delete;
		};

	private:
		K5(const char* filename) throw (const char*);
		K5() = delete;
};
