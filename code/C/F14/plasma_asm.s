	.module plasma_asm.s
	.area .text.dp2 # waiting for next LWTools release where we can easily align them all!

_SIN EXTERN
_screen EXTERN
_colors EXTERN
_backbuffer EXTERN

	.globl _draw
_draw:
	; Param: X = frame

	; Save registers to make the calling C code happy
	pshs	y,u
	STS <spt+2

	; SYNC with display
;w	LDA 0xA7E7
;	BMI w

	; white border
;	INC 0xA7C0
;	INC	0xA7C0

	; #########################################
	; U2 = SIN[frame] + frame
	ldb	_SIN,x
	abx
	stx	<u2-1

	; U5 = SIN + frame
	inc	<u5+3

	; U3 = 99 (current line)
	ldb	#50
	stb	<u3+1

	; U = Pointer to destination byte on screen
ini	ldu	#1630
L11:
	; U9 = U3 / 2 + U2 = line / 2 + frame + sin[frame]
u3	ldb	#00
	;asrb
	addb	<u2
	stb	<u9+1

	; U4 = U2 + *(U5+U13)
	ldx	<u5+2
	ldb	b,x
	addb	<u2
	stb	<u4+1

	; Y = 0
	ldy	#20
L10:
	; U13 = U9 + SIN[frame+col]
u5	ldb _SIN+256,y

u9	addb #00
	tfr d,s

	; B = U12*8 + U4
	tfr y,d
	aslb
	aslb
	;aslb
u4	addb #00

	; B = back[U13] + back[B]
	ldx		#_backbuffer+128
	ldb		b,x
	addb	_backbuffer,s

	; B = colors[B]
fra	ldx #_colors
	ldb b,x

	; *(U10++) = B
	;stb  39,u
	pshu b

	leay	,-y
	; while(Y++ < 20);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	bne	L10


	; U7 = U7 + 40
	leau	100,u

	; U3--
	dec	<u3+1
	; while(U3 >= 0)
	lbne	L11

	ldb ini+2
	addb #40
	cmpb #0x86
	beq ok
	inc <fra+2
	subb #80
ok	stb ini+2

;	DEC	0xA7C0
;	DEC	0xA7C0
	; Restore stack and regs
spt	LDS		#00
	puls	y,u,pc

	RMB 1
u2	RMB 1
	ALIGN	256

	.area .text

	INCLUDEBIN	MUSEUM02.CRU
	.globl color_plasma
color_plasma
	INCLUDEBIN	MUSEUM01.CRU
	.globl forme_plasma
forme_plasma
