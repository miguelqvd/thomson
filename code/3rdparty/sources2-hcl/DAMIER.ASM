****************************************
*                                      *
*    DAMIER : HCL LEADS THOU FURTHER   *
*                                      *
****************************************


SCRCOL EQU    $9400
TEXTE  EQU    $A580
DERPAG EQU    TEXTE+136*16
CHUTES EQU    $AE00
DEGRA  EQU    $B000
ETAPS  EQU    $B082
BUF    EQU    $B0BA
FONTES EQU    $B100
CHRSET EQU    $B900
SCRTEX EQU    $BCC0
SCRECR EQU    $41A4
DAMECR EQU    $4B18
BASCUB EQU    $5684

       ORG    BUF+3
       FDB    TEXTE+1
       FCB    1
       FDB    $B84,$B86,$B88,$B8A
       FDB    $B8C,$B8E,$B90,$B92
       FDB    $B94,$B96,$B98,$B9A
       FDB    $B9C,$B9E,$BA0,$BA2
       FDB    0,0,0,0,0,0
       FDB    SCRTEX

       ORG    $C760
G      ORCC   #80
       LDA    #$E7
       EXG    A,DP
       STA    BUF+2
       LDD    #32
       STA    <$DB
       STA    <$DA
       DECB
       BNE    *-3
       LDA    <$E6
       STA    FIN+3
       STS    FIN+8
       ANDA   #191
       STA    <$E6
       LDD    #$2104
       STD    <$DC
       LDA    <$C3
       ORA    #1
       STA    <$C3
       LDX    #$4000
       CLR    ,X+
       CMPX   #$5F40
       BNE    *-5
       DEC    <$C3
       CLR    ,-X
       CMPX   #$4000
       BNE    *-5
       LDX    #DAMECR
       LDU    #DAMPIC
       LDD    ,U++
       STD    ,X++
       CMPX   #$5F40
       BNE    *-7
       LDU    #SCRDEG
       LDX    #SCRCOL
       LDA    #6
       STA    BUF
       LEAY   24,X
       LDD    ,U++
       BEQ    CYCLE-8
REPER  STD    ,X++
       STD    ,--Y
       ADDD   -2,U
       DEC    BUF
       BNE    REPER
       LEAX   12,X
       BRA    REPER-12
       LDA    #255
       LDX    #COLORS
       JSR    $EC00

CYCLE  LDD    #BANDE
       STD    BANDE-2
       LDY    #ETAPS
       LDA    #4
       STA    BUF+1
       JSR    SYNCRO
       LEAY   14,Y
       DEC    BUF+1
       BNE    *-8
       LDD    #BAND2
       STD    BANDE-2
       LDY    #ETAPS
       LDA    #4
       STA    BUF+1
       JSR    SYNCRO
       LEAY   14,Y
       DEC    BUF+1
       BNE    *-8
       TST    <$C8
       BEQ    CYCLE

FIN    CLR    <$DC
       LDA    #0
       STA    <$E6
       LDS    #0
       CLR    <$DD
       LDA    #255
       LDX    #COLORS+10
       JSR    $EC00
       LDA    BUF+2
       TFR    A,DP
       RTS

SYNCRO STY    BANDE-5
       LDA    #32
       BITA   <$E7
       BEQ    *-2
       BITA   <$E7
       BNE    *-2
       PSHS   A
       MUL
       MUL
       MUL
       MUL
       PULS   A
       BITA   <$E7
       BEQ    *-10
       MUL
       MUL
       MUL
       MUL
       MUL
       TST    <$E7
       BMI    *-7
       MUL
       MUL
       MUL
       MUL
       MUL
       TST    <$E7
       BPL    *-7

       STS    RETURN-2
       LDX    #SCRECR
SCROL1 ASL    BUF+38
       ROL    19,X
       ROL    18,X
       ROL    17,X
       ROL    16,X
       ROL    15,X
       ROL    14,X
       ROL    13,X
       ROL    12,X
       ROL    11,X
       ROL    10,X
       ROL    9,X
       ROL    8,X
       ROL    7,X
       ROL    6,X
       ROL    5,X
       ROL    4,X
       ROL    3,X
       ROL    2,X
       ROL    1,X
       ROL    ,X
       ROL    -1,X
       ROL    -2,X
       ROL    -3,X
       ROL    -4,X
       ROL    -5,X
       ROL    -6,X
       ROL    -7,X
       ROL    -8,X
       ROL    -9,X
       ROL    -10,X
       ROL    -11,X
       ROL    -12,X
       ROL    -13,X
       ROL    -14,X
       ROL    -15,X
       ROL    -16,X
       ROL    -17,X
       ROL    -18,X
       ROL    -19,X
       ROL    -20,X
       ASL    BUF+49
       LDX    #SCRECR+440
       ROL    19,X
       ROL    18,X
       ROL    17,X
       ROL    16,X
       ROL    15,X
       ROL    14,X
       ROL    13,X
       ROL    12,X
       ROL    11,X
       ROL    10,X
       ROL    9,X
       ROL    8,X
       ROL    7,X
       ROL    6,X
       ROL    5,X
       ROL    4,X
       ROL    3,X
       ROL    2,X
       ROL    1,X
       ROL    ,X
       ROL    -1,X
       ROL    -2,X
       ROL    -3,X
       ROL    -4,X
       ROL    -5,X
       ROL    -6,X
       ROL    -7,X
       ROL    -8,X
       ROL    -9,X
       ROL    -10,X
       ROL    -11,X
       ROL    -12,X
       ROL    -13,X
       ROL    -14,X
       ROL    -15,X
       ROL    -16,X
       ROL    -17,X
       ROL    -18,X
       ROL    -19,X
       ROL    -20,X
       LDU    #BUF+39
       LDX    #SCRECR+40

       TST    1,S
       MUL
       LDA    #11
       STA    BUF
       LDS    #SCRCOL+98
COPPER PULS   D
       STD    *+8
       LDA    #2
       STA    <$DB
       LDD    #0
       STB    <$DA
       STA    <$DA
       STY    RETURN+2
       MUL
       TST    ,U
       DEC    BUF
       BNE    COPPER

       LDA    #10
SCROL2 ASL    ,U+
       ROL    19,X
       ROL    18,X
       ROL    17,X
       ROL    16,X
       ROL    15,X
       ROL    14,X
       ROL    13,X
       ROL    12,X
       ROL    11,X
       ROL    10,X
       ROL    9,X
       ROL    8,X
       ROL    7,X
       ROL    6,X
       ROL    5,X
       ROL    4,X
       ROL    3,X
       ROL    2,X
       ROL    1,X
       ROL    ,X
       ROL    -1,X
       ROL    -2,X
       ROL    -3,X
       ROL    -4,X
       ROL    -5,X
       ROL    -6,X
       ROL    -7,X
       ROL    -8,X
       ROL    -9,X
       ROL    -10,X
       ROL    -11,X
       ROL    -12,X
       ROL    -13,X
       ROL    -14,X
       ROL    -15,X
       ROL    -16,X
       ROL    -17,X
       ROL    -18,X
       ROL    -19,X
       ROL    -20,X
       LEAX   40,X
       DECA
       BNE    SCROL2
       LEAU   1,U
       DEC    BUF+5
       BEQ    NEXT
       LDA    #19
       DECA
       BNE    *-1
       BRA    FINSCR

NEXT   LDX    ,U
       LDB    ,X+
       BNE    *+7
       LDX    #SCRTEX
       BRA    *+4
       TST    ,U
       STX    ,U
       LDX    #CHRSET
       LDA    #12
       MUL
       LEAS   D,X
       PULS   D,X,Y
       PSHU   Y,X,D
       PULS   D,X,Y
       PSHU   Y,X,D
       LDB    #8
       STB    BUF+5

FINSCR MUL
       MUL
       TST    1,U
       INC    <$C3

       LDX    #DEGRA
       LDU    #ETAPS
       JMP    BANDE
BANDE  LDA    ,U+
       STA    BUF
LIGNE  LDB    ,X+
       CLRA
       STA    <$DB
       STB    <$DA
       STB    <$DA
       STA    <$DA
       STB    <$DA
       ADDA   [A,X]
       DEC    BUF
       BEQ    *+7
       MUL
       NOP
       NOP
       BRA    LIGNE
       CMPX   #DEGRA+130
       BHS    FDEG
BAND2  LDA    ,U+
       STA    BUF
LIGN2  LDB    ,X+
       CLRA
       STA    <$DB
       STA    <$DA
       STB    <$DA
       STB    <$DA
       STB    <$DA
       ADDA   [A,X]
       DEC    BUF
       BEQ    *+7
       MUL
       NOP
       NOP
       BRA    LIGN2
       CMPX   #DEGRA+130
       BLO    BANDE
FDEG   LDX    COPPER-2
       LDD    -2,X
       STD    *+11
       CLRA
       STA    <$DB
       STA    <$DA
       STA    <$DA
       LDD    #0
       STB    <$DA
       STA    <$DA

       LDY    BUF+3
       LDS    #BUF+6
       LDB    #16
       STB    BUF
LETTER LDX    ,S
       LDD    #0
       STD    -120,X
       STD    -80,X
       STD    -40,X
       STD    ,X
       CMPX   #BASCUB
       BHS    *+6
CHUTE  FDB    $3089,$00A0
       STX    ,S++
       LDA    ,Y+
       STS    RECU-2
       EXG    X,Y
       STX    RECU+2
       LDB    #32
       MUL
       LDU    #FONTES
       LEAS   D,U
       PULS   D,X,U
       STD    -120,Y
       STX    -80,Y
       STU    -40,Y
       PULS   D,X,U
       STD    ,Y
       STX    40,Y
       STU    80,Y
       PULS   D,X,U
       STD    120,Y
       LEAY   280,Y
       STX    -120,Y
       STU    -80,Y
       PULS   D,X,U
       STD    -40,Y
       STX    ,Y
       STU    40,Y
       PULS   D,X,U
       STD    80,Y
       STX    120,Y
       STU    160,Y
       LDD    ,S
       STD    200,Y
       LDS    #0
RECU   LDY    #0
       INC    CHUTE-3
       DEC    BUF
       BNE    LETTER
       LDB    CHUTE-3
       SUBB   #16
       STB    CHUTE-3
       LDX    BUF+6
DERNIE CMPX   #BASCUB
       BLO    RETURN-10
       CMPX   #BASCUB-640*7+39
       BHI    MEMPAG
       LDA    <$CD
       BITA   #64
       BEQ    *+5
       JMP    RETURN-10
       CMPY   #DERPAG
       BNE    *+6
       LDY    #TEXTE
       LDD    #BASCUB
       BRA    *+8
MEMPAG LDA    CHUTE-4
       SUBD   #640
       STD    CHUTE-4
       STD    DERNIE+1
       LDA    ,Y
       ANDA   #15
       LDB    #40
       MUL
       STB    CHUTE+3
       LDB    ,Y+
       ANDB   #240
       LDA    #2
       MUL
       LDU    #CHUTES
       LDS    #BUF+6
       LEAU   D,U
       PULU   D
       STD    ,S++
       STD    *+11
       LDD    #$100
       PULU   X
       STX    ,S++
       CMPX   #0
       BHI    *+7
       STX    *-4
       TFR    A,B
       INCA
       CMPA   #16
       BNE    *-17
       LDX    #BUF+6
       ASLB
       ABX
       STX    DERNIE-2
       BRA    *+4
       LEAY   -16,Y
       STY    BUF+3
       LDS    #0
RETURN LDY    #0
       DEC    <$C3
       LDA    <$CC
       LDX    COPPER-2
       BITA   #1
       BNE    *+12
       LEAX   -2,X
       CMPX   #SCRCOL
       BNE    *+5
       LDX    #SCRCOL+168
       BITA   #2
       BNE    *+12
       LEAX   2,X
       CMPX   #SCRCOL+172
       BNE    *+5
       LDX    #SCRCOL+4
       STX    COPPER-2
       RTS

SCRDEG FDB    1,16,17,256,257,272,273,1
COLORS FDB    0,514,15,15,0
       FDB    0,15,240,255,3840,3855
       FDB    4080,4095,1911,826,931
       FDB    938,2611,2618,3815,123
       FCC    / HCL /
DAMPIC
       END
