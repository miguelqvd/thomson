	.module picture.s
;	.area .text

;	INCLUDEBIN POI01.CRU
;forme
;	INCLUDEBIN POI03.CRU
;couleur

;	.globl _main
;_main
;	LDU	#couleur-1
;	LDX #forme-1
;	LBRA decrunchpic

	.area .text.dp

	.globl exo2
	INCLUDE ../../../../_TOOLS/exomizer206/rawdecrs/6809/exo2_final.asm
	; INPUT
	; X = PTR to FORME (last byte)
	; U = PTR to COULEUR (last byte)

	.globl decrunchpic
decrunchpic
	PSHS A

	LDA 0xA7C0
	ORA #1
	STA 0xA7C0

	PULS A

	LDY #8000
	LBSR exo2

	DEC	0xA7C0

	TFR X,U
	LDY #8000
	LBRA exo2

