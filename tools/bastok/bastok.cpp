#include <map>
#include <vector>
#include <stdint.h>

#include <arpa/inet.h>

struct __attribute__((packed)) BAS_Data {
	uint8_t type;
	uint16_t length;
	std::vector<uint8_t> data;
};

bool BAS_ReadChunk(FILE* in, BAS_Data& out) {
	// Read the chunk header
	int value = fread(&out, 3, 1, in);
	if (value == 0)
		return false;

	// 6809 is little endian, take that into account...
	out.length = ntohs(out.length);

	// Resize the data member to the proper size and read the data to it.
	out.data.reserve(out.length);
	fread(&out.data[0], out.length, 1, in);

	return true;
};

struct __attribute__((packed)) BAS_Line {
	uint16_t offset;
	uint16_t number;
	uint8_t data[];
};

void BAStoASCII(BAS_Data& data)
{
	std::map<uint8_t, const char*> Opcodes;
	std::map<uint8_t, const char*> Functions;

	// FLOW CONTROL
	Opcodes[0x80] = "END";
	Opcodes[0x81] = "FOR";
	Opcodes[0x82] = "NEXT";
	Opcodes[0x83] = "DATA";
	Opcodes[0x84] = "DIM";
	Opcodes[0x85] = "READ";
	//
	Opcodes[0x87] = "GO";
	//
	Opcodes[0x89] = "IF";
	Opcodes[0x8A] = "RESTORE";
	Opcodes[0x8B] = "RETURN";
										Opcodes[0x8D] = "'";
										Opcodes[0x8E] = "STOP";
										Opcodes[0x8F] = "ELSE"; // FIXME must remove the : before it
	//
	Opcodes[0x93] = "DEFINT";
										Opcodes[0x96] = "ON";
										Opcodes[0x98] = "ERROR";
										Opcodes[0x99] = "RESUME";
	// CURSOR
	Opcodes[0x9C] = "LOCATE";
	Opcodes[0x9D] = "CLS";
										Opcodes[0x9E] = "CONSOLE";
										Opcodes[0x9F] = "PSET";
	// MACHINE
	Opcodes[0xA2] = "EXEC";
										Opcodes[0xA3] = "BEEP";
	// DISPLAY
	Opcodes[0xA4] = "COLOR";
	Opcodes[0xA5] = "LINE";
	Opcodes[0xA6] = "BOX";
	//
	Opcodes[0xA8] = "ATTRB";
	Opcodes[0xA9] = "DEF"; // FIXME DEFGR$
	Opcodes[0xAA] = "POKE";
	Opcodes[0xAB] = "PRINT";
	//
	Opcodes[0xAE] = "CLEAR";

										Opcodes[0xB0] = "KEY";
										Opcodes[0xB3] = "LOAD";
										Opcodes[0xB5] = "OPEN";
										Opcodes[0xB6] = "CLOSE";
										Opcodes[0xB7] = "INPEN";
	// SOUND
	Opcodes[0xB9] = "PLAY";

	// SUB-CODES
										Opcodes[0xBA] = "TAB(";
	Opcodes[0xBB] = "TO";
	Opcodes[0xBC] = "SUB";
										Opcodes[0xBD] = "FN";
	//
	Opcodes[0xBE] = "SPC(";
	Opcodes[0xBF] = "USING";
	//
										Opcodes[0xC1] = "ERL";
										Opcodes[0xC2] = "ERR";
	Opcodes[0xC4] = "THEN";
										Opcodes[0xC5] = "NOT";
	Opcodes[0xC6] = "STEP";

	// OPERATORS
	Opcodes[0xC7] = "+";
	Opcodes[0xC8] = "-";
	Opcodes[0xC9] = "*";
	Opcodes[0xCA] = "/";
	//
	Opcodes[0xCC] = "AND";
	Opcodes[0xCD] = "OR";
	Opcodes[0xCE] = "XOR";
	//
										Opcodes[0xD1] = "MOD";
										Opcodes[0xD2] = "@";
	Opcodes[0xD3] = ">";
	Opcodes[0xD4] = "=";
	Opcodes[0xD5] = "<";
										Opcodes[0xD6] = "DSKINI";
										Opcodes[0xDD] = "PUT";
										Opcodes[0xDE] = "GET";
										Opcodes[0xE6] = "COPY";
										Opcodes[0xEF] = "DO";
										Opcodes[0xF0] = "LOOP";
										Opcodes[0xF1] = "EXIT";
										Opcodes[0xF8] = "TURTLE";


	Functions[0x81] = "INT";
	Functions[0x82] = "ABS";
										Functions[0x8A] = "PEEK";
	Functions[0x8B] = "LEN";
										Functions[0x8D] = "VAL";
	Functions[0x8E] = "ASC";
	Functions[0x8F] = "CHR$";
										Functions[0x95] = "HEX$";
	Functions[0x99] = "GR$";
	Functions[0x9A] = "LEFT$";
	Functions[0x9C] = "MID$";
										Functions[0x9B] = "RIGHT$";
										Functions[0x9E] = "VARPTR";
	Functions[0x9F] = "RND";
	Functions[0xA0] = "INKEY$";
	Functions[0xA1] = "INPUT$";
										Functions[0xA2] = "CSRLIN";
	Functions[0xA4] = "SCREEN";
										Functions[0xA5] = "POS";
										Functions[0xA6] = "PTRIG";
										Functions[0xB0] = "SPACE$";
										Functions[0xB1] = "STRING$";
										Functions[0xB2] = "DSKI$";
										Functions[0xB3] = "FKEY$";
										Functions[0xBA] = "PALETTE";
										Functions[0xBB] = "BANK";
										Functions[0xBC] = "HEAD";
										Functions[0xBD] = "ROT";
										Functions[0xBE] = "SHOW";
										Functions[0xBF] = "ZOOM";

	/* ################################ */

	BAS_Line* currentLine;
	bool mo5mode;
	currentLine = (BAS_Line*)&data.data[0];

	// MO5 BASIC uses absolute addresses in the "offset" field. TO8 BASIC 512
	// instead puts the line length there, making the file relocatable. We try
	// to guess which format was used here
	mo5mode = (currentLine->offset & 0xFF) > 0x24;

	bool func = false;
	int acc = 0;
	while(currentLine->offset) {
		// Endianness fixup
		currentLine->offset = ntohs(currentLine->offset);
		currentLine->number = ntohs(currentLine->number);

		printf("%d ", currentLine->number);
		
		for (int i = 0; currentLine->data[i]; i++) {
			uint8_t c = currentLine->data[i];
			if (acc != 0) {
				if (acc < 0) {
					acc = c;
					if (c == 0x2E) {
						printf("→");
						acc = 0;
						// TODO handle other special characters...
					}
				} else switch((acc << 8) | c) {
					case 'Be':
						printf("é");
						acc = 0;
						break;
					default:
						printf("\nUNKNOWN ACCENT SEQUENCE 16 %02X %02X\n", acc, c);
						exit(EXIT_FAILURE);
				}
				continue;
			} else if (c == 0x16) {
				acc = -1;
				continue;
			} if (c < 128 && isprint(c))
				putchar(c);
			else if (c == 0xFF) {
				func = true;
				continue;
			} else if ((!func) && (Opcodes.find(c) != Opcodes.end()))
				printf("\x1B[31m%s\x1B[0m", Opcodes[c]);
			else if (func && (Functions.find(c) != Functions.end()))
				printf("\x1B[32m%s\x1B[0m", Functions[c]);
			else {
				printf("\n*** UNKNOWN %s %x ***\n", func?"FUNCTION":"OPCODE", c);
				for (int k = 0; currentLine->data[k]; k++)
					printf("%02X ", currentLine->data[k]);
				puts("");
				exit(EXIT_FAILURE);
			}
			func = false;
		}
		//currentLine = (BAS_Line*)&data.data[currentLine->offset - 0x25A4];
		currentLine = (BAS_Line*)((uint8_t*)currentLine + currentLine->offset);
		puts("");
	}
}

int main(int argc, char* argv[])
{
	if (argc < 2)
	{
		fprintf(stderr, "%s file.bas\n", argv[0]);
		return 1;
	}

	FILE* in;
	BAS_Data h;

	in = fopen(argv[1], "rb");

	while(BAS_ReadChunk(in, h))
	{
		BAStoASCII(h);
	};

}
