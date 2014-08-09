****************************************
*         UNLIMITED BOBS DEMO          *
****************************************
*                                      *
*     Laurent HIRIART                  *
*     Les Enversgouttes                *
*     67420 COLROY-LA-ROCHE            *
*                                      *
****************************************


COS    EQU    $0000
SIN    EQU    $0800
SPRITE EQU    $1000
ZZ     EQU    $15A0
CODE   EQU    $D600
PILE   EQU    $4000

SCREEN EQU    $A000
CARTCH EQU    15
QUAD   EQU    512
DIR    EQU    ZZ/256
Z      EQU    ZZ-DIR*256


       ORG    CODE
G      ORCC   #80
       LDD    #32
       STA    $E7DB
       STA    $E7DA
       DECB
       BNE    *-4
       LDB    $E7E6
       PSHS   B,DP
       STS    RDP+2
       LDX    #$6000
       LDU    #$A000
GMONP0 LDD    ,X++
       STD    ,U++
       CMPX   #$8000
       BNE    GMONP0
       LDD    #$6000+256*CARTCH+DIR
       TFR    B,DP
       STA    $E7E6
       LDD    #$21C0
       STD    $E7DC
       JMP    >*+3-$C000

* Début Espace Cartouche

       LDS    #PILE
       LDA    #3
       STA    $E7E5
       LBSR   CLRSCR
       DECA
       BGE    *-7
       LDX    #COS
       LDU    #ZZ
       STX    ,U++
       STX    ,U++
       LDX    #SIN
       STX    ,U++
       STX    ,U++
       LDA    #255
       LDX    #COLORS-$C000+32
       JSR    $EC00

GOON   LDD    #$0C0
       STA    $E7E5
       STB    $E7DD
       BSR    SYNCRO
       LDD    #$100
       STA    $E7E5
       STB    $E7DD
       BSR    SYNCRO
       LDD    #$240
       STA    $E7E5
       STB    $E7DD
       BSR    SYNCRO
       LDD    #$380
       STA    $E7E5
       STB    $E7DD
       BSR    SYNCRO
       TST    $E7C8
       BEQ    GOON

       LDA    #CARTCH
       STA    $E7E5
       JMP    *+3

* Fin Espace Cartouche

       LDX    #$6000
       LDU    #$A000
PMONP0 LDD    ,U++
       STD    ,X++
       CMPX   #$8000
       BNE    PMONP0

RDP    LDS    #0
       PULS   DP,B
       STB    $E7E6
       LDD    #0
       STD    $E7DC
       DECA
       LDX    #COLORS
       JSR    $EC00
       SWI

SYNCRO TST    $E7E7
       BPL    *-3
       TST    $E7E7
       BMI    *-3
       LDB    [ZZ+4]
       ADDB   [ZZ+6]
       ADDB   #100    Y centre écran
       LDA    #40
       MUL
       LDX    #SCREEN-200
       LEAX   D,X

       LDB    [ZZ]
       SEX
       STD    <Z+8
       LDB    [ZZ+2]
       SEX
       ADDD   <Z+8
       ADDD   #152    X centre écran
       STB    <Z+8
       LSRA
       RORB
       LSRB
       LSRB
       ABX
       LDA    <Z+8
       ANDA   #7
       LDB    #180
       MUL
       LDU    #SPRITE+15
       LEAU   D,U
       LDA    #3
       STA    <Z+8

RAMA   LDD    -80,X   affichage d'1 ball
       ORA    -15,U
       ANDA   -12,U
       ORB    -14,U
       ANDB   -11,U
       STD    -80,X
       LDA    -78,X
       ORA    -13,U
       ANDA   -10,U
       STA    -78,X
       LDD    -40,X
       ORA    -9,U
       ANDA   -6,U
       ORB    -8,U
       ANDB   -5,U
       STD    -40,X
       LDA    -38,X
       ORA    -7,U
       ANDA   -4,U
       STA    -38,X
       LDD    ,X
       ORA    -3,U
       ANDA   ,U
       ORB    -2,U
       ANDB   1,U
       STD    ,X
       LDA    2,X
       ORA    -1,U
       ANDA   2,U
       STA    2,X
       LDD    40,X
       ORA    3,U
       ANDA   6,U
       ORB    4,U
       ANDB   7,U
       STD    40,X
       LDA    42,X
       ORA    5,U
       ANDA   8,U
       STA    42,X
       LDD    80,X
       ORA    9,U
       ANDA   12,U
       ORB    10,U
       ANDB   13,U
       STD    80,X
       LDA    82,X
       ORA    11,U
       ANDA   14,U
       STA    82,X
       LEAX   200,X
       LEAU   30,U
       DEC    <Z+8
       BNE    RAMA
       LEAX   $2000-600,X
       LDA    #3
       STA    <Z+8
RAMB   LDD    -80,X
       ORA    -15,U
       ANDA   -12,U
       ORB    -14,U
       ANDB   -11,U
       STD    -80,X
       LDA    -78,X
       ORA    -13,U
       ANDA   -10,U
       STA    -78,X
       LDD    -40,X
       ORA    -9,U
       ANDA   -6,U
       ORB    -8,U
       ANDB   -5,U
       STD    -40,X
       LDA    -38,X
       ORA    -7,U
       ANDA   -4,U
       STA    -38,X
       LDD    ,X
       ORA    -3,U
       ANDA   ,U
       ORB    -2,U
       ANDB   1,U
       STD    ,X
       LDA    2,X
       ORA    -1,U
       ANDA   2,U
       STA    2,X
       LDD    40,X
       ORA    3,U
       ANDA   6,U
       ORB    4,U
       ANDB   7,U
       STD    40,X
       LDA    42,X
       ORA    5,U
       ANDA   8,U
       STA    42,X
       LDD    80,X
       ORA    9,U
       ANDA   12,U
       ORB    10,U
       ANDB   13,U
       STD    80,X
       LDA    82,X
       ORA    11,U
       ANDA   14,U
       STA    82,X
       LEAX   200,X
       LEAU   30,U
       DEC    <Z+8
       BNE    RAMB

NEXT   LDX    <Z
       LEAX   17,X
       CMPX   #COS+4*QUAD
       BLO    *+6
       LEAX   -4*QUAD,X
       STX    <Z
       LDX    <Z+2
       LEAX   16,X
       CMPX   #COS+4*QUAD
       BLO    *+6
       LEAX   -4*QUAD,X
       STX    <Z+2
       LDX    <Z+4
       LEAX   17,X
       CMPX   #SIN+4*QUAD
       BLO    *+6
       LEAX   -4*QUAD,X
       STX    <Z+4
       LDX    <Z+6
       LEAX   16,X
       CMPX   #SIN+4*QUAD
       BLO    *+6
       LEAX   -4*QUAD,X
       STX    <Z+6
       RTS

CLRSCR LDX    #$A000
       LDU    #0
       STU    ,X++
       CMPX   #$E000
       BNE    *-5
       RTS

COLORS FDB    0,15,240,255,3840,3855
       FDB    4080,4095,1911,826,931
       FDB    938,2611,2618,3815,123
       FDB    0,$660,$FF0,$330

       END
