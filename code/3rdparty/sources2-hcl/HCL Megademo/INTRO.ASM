****************************************
*                                      *
*  INTRODUCTION MORBIDE A LA MEGADEMO  *
*                                      *
****************************************
*    Codé le 10-10-90 par doctor Lô    *


SPRITE EQU    $7000
SINE   EQU    $9800
FONTE  EQU    $9980-8
TEXTE  EQU    $9A98
DIR    EQU    $9B
Z      EQU    $E0
ZZ     EQU    DIR*256+Z
SINDEP EQU    SINE+96
       ORG    ZZ
       FDB    $A500,$A500,$A500,$A500
       FDB    $A500,$A500,$A500,$A500
       FDB    SINDEP+64,SINDEP
       FCB    0
       FDB    TEXTE,$468,90,$DE78

       ORG    $9C00
G      ORCC   #80
       LDA    #$E7
       EXG    A,DP
       STA    RDP+1
       STS    RDS+2
       LDD    #32
       STA    <$DB
       STA    <$DA
       DECB
       BNE    *-3
       LDD    #$2100
       STD    <$DC
       STB    <$E5
       LDX    #$A000
       CLR    ,X+
       CMPX   #$E000
       BNE    *-5
       LDA    #15
       STA    <$E5
       LDX    #MAP
       STX    $616B
       LDD    #$FF0E
       STA    $6249
       STB    $616D
       LDD    #$105
       STD    $61D6
       CLR    $6288
       LDB    #69
       JSR    $EC0C
       LDX    #COLORS+32
       LDA    #255
       JSR    $EC00
       LDA    #0
       STA    <$E5

SYNCRO LDA    #32
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
       BPL    *-7
       MUL
       MUL
       MUL
       MUL
       MUL
       TST    <$E7
       BMI    *-7
       LDA    #4
       STA    <$DB
       LDD    #3840
       STB    <$DA
       STA    <$DA

       LDU    #COLORS-3
       PULU   Y,S,DP
       LDB    #8
       LDX    #ZZ
       LDU    ,X++
       LDA    #4
RUB    PSHU   DP,S,Y
       LEAU   45,U
       PSHU   DP,S,Y
       LEAU   45,U
       PSHU   DP,S,Y
       LEAU   45,U
       PSHU   DP,S,Y
       LEAU   45,U
       PSHU   DP,S,Y
       LEAU   45,U
       PSHU   DP,S,Y
       LEAU   45,U
       PSHU   DP,S,Y
       LEAU   45,U
       PSHU   DP,S,Y
       LEAU   45,U
       DECA
       BNE    RUB
       DECB
       BNE    RUB-4

       LDA    #DIR
       TFR    A,DP
       LDA    #8
       STA    <Z+20
       LDY    #ZZ
AFFOUR LDS    #$A085
       LDX    #ZZ+16
       LDU    2,X     sinus
       LDA    ,U
       LEAU   32,U
       CMPU   #SINE+256
       BLO    *+6
       LEAU   -256,U
       STU    2,X
       LDB    #40
       MUL
       LEAS   D,S
       LDU    ,X
       LDB    ,U
AJUS   ADDB   #0
       LSRB
       LSRB
       LSRB
       LEAS   B,S
       LDB    ,U
ASUJ   ADDB   #0
       LEAU   32,U
       CMPU   #SINE+320
       BLO    *+6
       LEAU   -256,U
       STU    ,X
       ANDB   #7
       LDA    #160
       MUL
PSPRI  LDU    #SPRITE
       LEAU   D,U
       STS    ,Y++
       STY    RECU+2
       LDA    #8
AFCRA  PULU   X,Y,B
       PSHS   B,Y,X
       LEAS   45,S
       PULU   X,Y,B
       PSHS   B,Y,X
       LEAS   45,S
       PULU   X,Y,B
       PSHS   B,Y,X
       LEAS   45,S
       PULU   X,Y,B
       PSHS   B,Y,X
       LEAS   45,S
       DECA
       BNE    AFCRA
RECU   LDY    #0
       DEC    <Z+20
       BNE    AFFOUR
       LDX    <Z+16
VITX   LEAX   2,X
       CMPX   #SINDEP+96
       BNE    NORM
       LDX    #SINDEP+64
       STX    <Z+16
       LDX    #SINDEP
       STX    <Z+18
       BRA    JOIN
NORM   STX    <Z+16
       LDX    <Z+18
VITY   LEAX   2,X
       STX    <Z+18

JOIN   LDB    <Z+23
       LDA    $E7CC
       BITA   #1
       BNE    DOWN
UP     CMPB   #3
       BEQ    EST
       DECB
       BRA    EST
DOWN   BITA   #2
       BNE    EST
       CMPB   #29
       BEQ    EST
       INCB
EST    STB    <Z+23
       LDB    <Z+24
       BITA   #8
       BNE    WEST
       CMPB   #188
       BEQ    FJOY
       INCB
       BRA    FJOY
WEST   BITA   #4
       BNE    FJOY
       CMPB   #40
       BEQ    *+3
       DECB
FJOY   STB    <Z+24
       LDX    #$A000
       LSRB
       LSRB
       LSRB
       ABX
       LDD    <Z+23
       ANDB   #7
       STB    AJUS+1
       STB    ASUJ+1
       LDB    #40
       MUL
       LEAX   D,X
       STX    AFFOUR+2
       LDB    <Z+25
       BNE    ANTIRE
       LDA    $E7CD
       BITA   #64
       BNE    ANTIRE+2
       LDX    PSPRI+1
       LEAX   8*160,X
       CMPX   #SPRITE+160*64
       BNE    *+5
       LDX    #SPRITE
       STX    PSPRI+1
       LDA    #16
       STA    <Z+25
       BRA    *+4
ANTIRE DEC    <Z+25

       LDX    <Z+21
       LDA    ,X
       BEQ    MOVEUP
       LBMI   FBOUC
       DEC    <Z+26
       LBNE   FBOUC
       LDB    <Z+1
       ANDB   #15
       INCB
       STB    <Z+26
       LEAX   1,X
       STX    <Z+21
       LDB    #8
       MUL
       LDU    #FONTE
       LEAU   D,U
       LDX    <Z+27
       PULU   D
       STA    160,X
       STB    120,X
       PULU   D
       STA    80,X
       STB    40,X
       PULU   D
       STA    ,X+
       STB    -41,X
       PULU   D
       STA    -81,X
       STB    -121,X
       STX    <Z+27
       BRA    FBOUC

MOVEUP LDU    <Z+27
       LDA    <Z+26
       CMPU   #$DE78
       BEQ    *+9
       LDU    #$DE78
       STU    <Z+27
       LDA    #19
       DECA
       STA    <Z+26
       CMPA   #11
       BNE    *+6
       LEAX   1,X
       STX    <Z+21
       LDB    #31
       STB    <Z+20
       LDU    #$DA80
MOVE   PULU   D,X,Y,S
       LEAU   -40,U
       PSHU   S,Y,X,D
       LEAU   32,U
       PULU   D,X,Y,S
       LEAU   -40,U
       PSHU   S,Y,X,D
       LEAU   32,U
       PULU   D,X,Y,S
       LEAU   -40,U
       PSHU   S,Y,X,D
       LEAU   32,U
       PULU   D,Y,X,S
       LEAU   -40,U
       PSHU   S,Y,X,D
       LEAU   104,U
       DEC    <Z+20
       BNE    MOVE
       BRA    RDS

FBOUC  LDX    #576
       LEAX   -1,X
       BNE    *-2
       LDA    $E7CD
       BMI    RDS
       LDA    <Z+17
       LSRA
       ASLA
       STA    <Z+17
       LDA    <Z+19
       LSRA
       ASLA
       STA    <Z+19
       LDA    #2
       LDB    VITX+1
       CMPB   #1
       BEQ    *+3
       DECA
       STA    VITX+1
       STA    VITY+1
RDS    LDS    #0
       LDD    #$E720
       TFR    A,DP
       BITB   <$E7
       BEQ    *-2
       BITB   <$E7
       BNE    *-2
       MUL
       MUL
       MUL
       MUL
       MUL
       LDA    #4
       STA    <$DB
       MUL
       MUL
       MUL
       MUL
       MUL
       TST    ,X
       LDD    #240
       STB    <$DA
       STA    <$DA

       JSR    $E806
       CMPB   #78
       BNE    *+5
       JMP    $FDC8
       CMPB   #79
       LBNE   SYNCRO

RDP    LDA    #0
       TFR    A,DP
       CLR    $E7DC
       CLR    $E7DD
       LDA    #255
       LDX    #COLORS
       JSR    $EC00
       RTS

       FCB    0,0,0
COLORS FDB    0,15,240,255,3840,3855
       FDB    4080,4095,1911,826,931,938
       FDB    2611,2618,3815,123
       FDB    0,4095,3840,4095
MAP
       END
