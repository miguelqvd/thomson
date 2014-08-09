****************************************
*                                      *
* SCROLLING VERTICAL POUR "FRACTALAND" *
*                                      *
****************************************
* Codé le 16-9-90 par doc Lô           *

FONTE  EQU    $8160
DEBANK EQU    3
ZZ     EQU    $9FF4
DIR    EQU    $9F
Z      EQU    $F4

       ORG    $9660
G      ORCC   #80
       LDA    #$E7
       EXG    A,DP
       STA    RDP+2
       STS    RDP+6
       LDD    #32
       STA    <$DB
       STA    <$DA
       DECB
       BNE    *-3
       LDA    #$21
       STA    <$DC
       CLR    <$DD
       LDA    <$C3
       ANDA   #254
       STA    <$C3
       LDX    #$4000
       CLR    ,X+
       CMPX   #$5F40
       BNE    *-5
       INC    <$C3
       CLR    ,-X
       CMPX   #$4000
       BNE    *-5
       LDX    #FONTE
       CLR    ,X+
       CMPX   #FONTE+256
       BNE    *-5
       LDA    #255
       LDX    #COULS
       JSR    $EC00
       LDA    #DEBANK
       STA    <$E5
       LDY    #$5F40
       LDD    #0
       STD    ,Y
       STD    2,Y
       STD    36,Y
       STD    38,Y
       STD    40,Y
       STD    42,Y
       STD    76,Y
       STD    78,Y

SYNCRO LDY    #$4028
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
       MUL
       BRA    *+2
       LDD    #$2A21
       STB    <$DC

SCROLL NOP
       STA    <$DC
       LDX    80,Y
       STX    ,Y
       LDU    82,Y
       STU    2,Y
       NOP
       STB    <$DC
       STX    36,Y
       STU    38,Y
       LEAY   40,Y
       JMP    *+3
       CMPY   #$5F40
       BNE    SCROLL
       STA    <$DC

       LDA    #DIR
       TFR    A,DP
       DEC    <Z
       BNE    SAME
       LDU    <Z+3
       LDA    ,U+
       BNE    *+5
       LDU    #TEXTE
       STU    <Z+3
       LDB    #128
       MUL
       LDU    #FONTE
       LEAU   D,U
       STU    <Z+1
       LDD    #17
       STB    <Z
       CLRB
       STD    ,Y
       STD    2,Y
       STD    36,Y
       STD    38,Y
       STD    40,Y
       STD    42,Y
       STD    76,Y
       STD    78,Y
       BRA    JOIN
SAME   LDU    <Z+1
       PULU   D,X
       STD    ,Y
       STX    2,Y
       STD    36,Y
       STX    38,Y
       PULU   D,X
       STD    40,Y
       STX    42,Y
       STD    76,Y
       STX    78,Y
       STU    <Z+1

JOIN   LDY    <Z+5
       CMPY   #$5F47
       BEQ    PADAFF
       LDA    #13
       LDS    <Z+7
LINE   PULS   U,X
       STU    ,Y
       DEC    $E7C3
       STX    ,Y++
       INC    $E7C3
       DECA
       BNE    LINE
       LEAY   14,Y
       STY    <Z+5
       STS    <Z+7
       LDA    #$E7
       TFR    A,DP
       TST    <$C8
       BNE    RDP
       LDS    RDP+6
       JMP    SYNCRO
PADAFF LDA    #$E7
       TFR    A,DP
       LDD    <$CC
       BITA   #8
       BNE    PAPLUS
       LDA    <$E5
       CMPA   #DEBANK+7
       BNE    *+4
       LDA    #DEBANK-1
       INCA
       BRA    NEWIMA
PAPLUS BITA   #4
       BNE    FIRE
       LDA    <$E5
       CMPA   #DEBANK
       BNE    *+4
       LDA    #DEBANK+8
       DECA
NEWIMA STA    <$E5
       LDX    #$4007
       STX    ZZ+5
       LDX    #$A000
       STX    ZZ+7
FIRE   BITB   #64
       BNE    MARRE
       DEC    ZZ+11
       BNE    MARRE
       LDX    #400
       LEAX   -1,X
       BNE    *-2
       LDX    ZZ+9
       LDB    #4
       STB    <$DB
       LDD    ,X++
       STB    <$DA
       STA    <$DA
       STB    <$DA
       STA    <$DA
       CMPX   #COLTEX+16
       BNE    *+5
       LDX    #COLTEX
       STX    ZZ+9
       LDA    #4
       STA    ZZ+11
MARRE  TST    <$C8
       LBEQ   SYNCRO

RDP    LDA    #0
       TFR    A,DP
       LDS    #0
       CLR    <$DC
       LDA    #255
       LDX    #COULS+8
       JSR    $EC00
       RTS

COULS  FDB    0,4095,$60,$60
       FDB    0,15,240,255,3840,3855
       FDB    4080,4095,1911,826,931,938
       FDB    2611,2618,3815,123
COLTEX FDB    0,6,$60,$66,$600,$606,$660
       FDB    $666
TEXTE  FCB    1,1,1,1,1,1,1,1,1,1,1

       ORG    ZZ
       FCB    1
       FDB    FONTE,TEXTE,$4007,$A000
       FDB    COLTEX+4,$0100
       END
