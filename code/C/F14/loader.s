
	ORG 0x2600
	INCLUDE ../../../../_TOOLS/exomizer206/rawdecrs/6809/exo2_final.asm

_main
	LDY #message
msg
	LDB ,Y+
	SWI
	FCB 2
	TSTB
	BNE msg

	LDY #0x7472
	LDU #demodata-1
	LBSR exo2

	LBRA 0x3371 ; Demo starts there

message
	FCB 0xC
	FCN "Decrunching..."

	INCLUDEBIN main.CRU
demodata
	END _main
