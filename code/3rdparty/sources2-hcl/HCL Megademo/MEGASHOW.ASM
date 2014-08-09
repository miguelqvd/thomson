          ********************
          *                  *
          *   INTRODUCTION   *
          *                  *
          * AU MEGASHOW1 HCL *
          *                  *
          ********************


ECRAN  EQU    $DD74
TEXTE  EQU    $8A00
FONTE  EQU    $8FC8
MASK   EQU    $9100
DIR    EQU    $98
Z      EQU    $80
ZZ     EQU    DIR*256+Z
PISTE1 EQU    56


       ORG    ZZ
       FCB    $B0,0,$B0,0,1
       FDB    TEXTE,20,0,$200,$200,$4000
       FCB    200,0,120,0,1,255,1,0
       FDB    0,0,PISTE1
       FCB    0
G      ORCC   #80
       LDA    #$E7
       EXG    A,DP
       STA    RDP+1
       STS    RDP-2
       LDD    #32
       STA    <$DB
       STA    <$DA
       DECB
       BNE    *-3
       STA    <$E5
       LDX    #$A000
       STD    ,X++
       CMPX   #$E000
       BNE    *-5
       LDX    #COOPER+368
       STX    $616B
       LDD    #$FF0E
       STA    $6249
       STB    $616D
       INCB
       STB    <$E5
       LDD    #$100
       STD    $61D6
       LDD    #$FF45
       STA    $6288
       JSR    $EC0C
       LDD    #$2104
       STD    <$DC
       LDD    #$1102
       STB    <$DB
       STA    <$DA
       STA    <$DA
       CLRA
       STA    <$E5

SYNCRO LDD    #$20E7
       TFR    B,DP
       LDX    #ZZ+9
       BITA   <$E7
       BEQ    *-2
       BITA   <$E7
       BNE    *-2
       STA    ,X+
       MUL
       MUL
       MUL
       MUL
       LDA    ,-X
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
       MUL
       NOP
       LDX    #$421
       LDA    #4
       STA    <$DB

       LDU    #COOPER
COOP   PULU   D
       STD    REP+1
       ADDD   #$555
       STD    REP+8
REP    LDD    #0
       STB    <$DA
       STA    <$DA
       LDD    #0
       STB    <$DA
       STA    <$DA
       STX    <$DB
       LDD    1,U
       CMPU   #COOPER+2*184
       BNE    COOP

       LDB    #DIR
       TFR    B,DP
       LDA    $E7CC
       ANDA   #15
       CMPA   #15
       BEQ    JOY1
       LDB    <Z+11
       BITA   #4      ouest 1
       BNE    PO1
       CMPB   #0
       BEQ    PE1
       DECB
       BNE    *+4
       STB    <Z+10
PO1    BITA   #8      est 1
       BNE    PE1-2
       CMPB   #8
       BEQ    *+3
       INCB
       STB    <Z+11
PE1    LDB    <Z+13
       BITA   #2      sud 1
       BNE    PS1
       CMPB   #0
       BEQ    PN1
       DECB
       BNE    *+4
       STB    <Z+12
PS1    BITA   #1      nord1
       BNE    PN1-2
       CMPB   #8
       BEQ    *+3
       INCB
       STB    <Z+13
PN1    BRA    SPOT

JOY1   LDA    $E7CC
       LDB    <Z+21
       BITA   #64     ouest 2
       BNE    PO2
       CMPB   #0
       BEQ    PO2
       DECB
       BNE    *+4
       STB    <Z+20
PO2    BITA   #128    est 2
       BNE    PE2-2
       CMPB   #8
       BEQ    *+3
       INCB
       STB    <Z+21
PE2    LDB    <Z+23
       BITA   #32     sud 2
       BNE    PS2
       CMPB   #0
       BEQ    SPOT
       DECB
       BNE    *+4
       STB    <Z+22
PS2    BITA   #16     nord 2
       BNE    SPOT-2
       CMPB   #8
       BEQ    *+3
       INCB
       STB    <Z+23

SPOT   LDU    #MASK-10
       PULU   X,Y,S
       LDU    <Z
       LDA    #5
       PSHU   S,Y,X
       LEAU   46,U
       PSHU   S,Y,X
       LEAU   46,U
       PSHU   S,Y,X
       LEAU   46,U
       PSHU   S,Y,X
       LEAU   46,U
       PSHU   S,Y,X
       LEAU   46,U
       PSHU   S,Y,X
       LEAU   46,U
       PSHU   S,Y,X
       LEAU   46,U
       PSHU   S,Y,X
       LEAU   46,U
       DECA
       BNE    *-41
       LDU    <Z+2
       LDA    #5
       PSHU   S,Y,X
       LEAU   46,U
       PSHU   S,Y,X
       LEAU   46,U
       PSHU   S,Y,X
       LEAU   46,U
       PSHU   S,Y,X
       LEAU   46,U
       PSHU   S,Y,X
       LEAU   46,U
       PSHU   S,Y,X
       LEAU   46,U
       PSHU   S,Y,X
       LEAU   46,U
       PSHU   S,Y,X
       LEAU   46,U
       DECA
       BNE    *-41

       LDX    #ECRAN
       LDU    #ZZ+24
       LDA    #5
SCROL  ASL    ,U+
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
       ROL     9,X
       ROL     8,X
       ROL     7,X
       ROL     6,X
       ROL     5,X
       ROL     4,X
       ROL     3,X
       ROL     2,X
       ROL     1,X
       ROL     ,X
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
       BNE    SCROL
       DEC    <Z+4
       BNE    JOIN

       LDX    <Z+5
       LDA    ,X+
       BNE    *+5
       LDX    #TEXTE
       STX    <Z+5
       LDB    #5
       MUL
       LDU    #FONTE
       LEAS   D,U
       PULS   B,X,Y
       LDU    #ZZ+29
       PSHU   Y,X,B
       LDA    #8
       STA    <Z+4

JOIN   LDX    <Z+7    abcisse
       LDD    <Z+10
       TSTA
       BEQ    *+3
       NEGB
       LEAX   D,X
       CMPX   #327
       BLO    *+6
       LDX    #327
       COMA
       CMPX   #48
       BHI    *+6
       LDX    #48
       COMA
       STA    <Z+10
       STX    <Z+7

       LDX    <Z+14   ordonnée
       LDD    <Z+12
       TSTA
       BEQ    *+3
       NEGB
       LEAX   D,X
       CMPX   #188
       BLO    *+6
       LDX    #188
       COMA
       CMPX   #32
       BGT    *+6
       LDX    #32
       COMA
       STA    <Z+12
       STX    <Z+14

       LDA    <Z+15   adresse écran
       LDB    #40
       MUL
       LDX    #$9B00
       LEAX   D,X
       LDD    <Z+7
       ASRA
       RORB
       LSRB
       LSRB
       ABX
       STX    <Z

       LDA    <Z+8    adresse du masque
       ANDA   #7
       LDB    #240
       MUL
       LDU    #MASK
       LEAU   D,U

       LDA    #10
       LEAS   ,X
SPOT1  PULU   X,Y,B,DP
       PSHS   B,DP,Y,X
       LEAS   46,S
       PULU   X,Y,B,DP
       PSHS   B,DP,Y,X
       LEAS   46,S
       PULU   X,Y,B,DP
       PSHS   B,DP,Y,X
       LEAS   46,S
       PULU   X,Y,B,DP
       PSHS   B,DP,Y,X
       LEAS   46,S
       DECA
       BNE    SPOT1

       LDA    #DIR
       TFR    A,DP
       LDX    <Z+16   abcisse 2
       LDD    <Z+20
       TSTA
       BEQ    *+3
       NEGB
       LEAX   D,X
       CMPX   #327
       BLO    *+6
       LDX    #327
       COMA
       CMPX   #48
       BGT    *+6
       LDX    #48
       COMA
       STA    <Z+20
       STX    <Z+16

       LDX    <Z+18   ordonnée 2
       LDD    <Z+22
       TSTA
       BEQ    *+3
       NEGB
       LEAX   D,X
       CMPX   #192
       BLO    *+6
       LDX    #192
       COMA
       CMPX   #32
       BGT    *+6
       LDX    #32
       COMA
       STA    <Z+22
       STX    <Z+18

       LDA    <Z+19   adresse écran 2
       LDB    #40
       MUL
       LDX    #$9B00
       LEAX   D,X
       LDD    <Z+16
       ASRA
       RORB
       LSRB
       LSRB
       ABX
       STX    <Z+2

       LDA    <Z+17   adresse masque 2
       ANDA   #7
       LDB    #240
       MUL
       LDU    #MASK
       LEAU   D,U

       LEAS   -4,X
       LDX    #20
SPOT2  PULU   D
       ORA    -2,S
       ORB    -1,S
       STD    -2,S
       PULU   D
       ORA    ,S
       ORB    1,S
       STD    ,S
       PULU   D
       ORA    2,S
       ORB    3,S
       STD    2,S
       LEAS   40,S
       PULU   D
       ORA    -2,S
       ORB    -1,S
       STD    -2,S
       PULU   D
       ORA    ,S
       ORB    1,S
       STD    ,S
       PULU   D
       ORA    2,S
       ORB    3,S
       STD    2,S
       LEAS   40,S
       LEAX   -1,X
       BNE    SPOT2
       LDB    $E7CD
       BITB   #64
       LBNE   SYNCRO

       LDD    #32
       STA    $E7DB
       STA    $E7DA
       DECB
       BNE    *-4
       LDD    #$7B00
       STD    $E7DC
       LDS    #ZZ+24

SANFIN LDA    #2
       STA    $E7E5
       BSR    READ
       LDA    #$80
       STA    <$DD
       LDA    #3
       STA    $E7E5
       BSR    READ
       LDA    #$C0
       STA    <$DD
       BRA    SANFIN

READ   LDA    #$60
       TFR    A,DP
       LDU    #ZZ+29
       LDX    #$A000
       STX    <$4F
       LDA    #2
       LDB    2,U
       STD    <$48
       LDA    1,U
       LDB    #1
       STD    <$4B

       LDA    #$A0    buffer
       LDB    #1      secteur
       LDX    ,U      piste

CHARGE TST    $E7C8
       BNE    RDP-4
       JSR    $E004
       BCS    CHARGE
       INCB
       CMPB   #17
       BNE    GOON+2
       LDB    #1
       LEAX   1,X
       CMPX   #80
       BNE    GOON
       LDX    #0
       LDB    2,U
       EORB   #1
       BNE    *+3
       LDX    #PISTE1
       STB    2,U
GOON   STX    <$4A
       STB    <$4C
       INCA
       STA    <$4F
       CMPA   #$E0
       BNE    CHARGE

       STX    ,U
       LDB    #$E7
       TFR    B,DP
WAIT   LDA    <$CD
       BITA   #64
       BNE    RDP-8
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
       BPL    *-7
       MUL
       MUL
       MUL
       MUL
       MUL
       TST    <$E7
       BMI    *-7
       LDA    #160
       TST    ,X+
       ABX
       DECA
       BNE    *-4
       STA    <$DB
       LDX    #$DF40
PALS   LDD    ,X++
       STB    <$DA
       STA    <$DA
       CMPX   #$DF60
       BNE    PALS
       RTS
       TST    <$C8
       BEQ    WAIT

       LDS    #0
RDP    LDA    #0
       TFR    A,DP
       CLR    $E7DD
       CLR    $E7DC
       LDA    #255
       LDX    #COLORS
       JSR    $EC00
       RTS

       FDB    0,0
COLORS FDB    0,15,240,255,3840,3855
       FDB    4080,4095,1911,826,931
       FDB    938,2611,2618,3815,123
COOPER
       END
