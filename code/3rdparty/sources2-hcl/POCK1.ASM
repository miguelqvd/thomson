****************************************
*              P  O  C  K              *
****************************************
              * externe *
              ***********

SCORE  EQU    $7905
TEXTE  EQU    $8000   contenu du scroll
RANDOM EQU    $8A00   table du hasard
INTRO  EQU    $8F75   préface (auteur)
FONTE  EQU    $9000   lettres du scroll
POCK   EQU    $9CFA   code du jeu POCK
G      EQU    $7BA4   le "shell" de pock
DIR    EQU    $9D     accès page direct
Z      EQU    $80     pour les variables
IMAGE  EQU    $9D77   MAP de l'écran

RAMA   EQU    $C14F
RAMB   EQU    RAMA-$2000
COULIB EQU    192     couleur segmt vide
BORDER EQU    184     hors carré de jeu

       ORG    G

       ORCC   #80
       LDS    #$6505
       LDX    #SCORE-5
       STX    $604F
       JSR    $E004
       LDD    #$4845
       CMPD   SCORE+248
       BEQ    *+3
       RTS
       LDA    #DIR
       TFR    A,DP
       LDD    #32
       STA    $E7DB
       STA    $E7DA
       DECB
       BNE    *-4
       LDX    #IMAGE
       STX    $616B
       LDD    #$FF0F
       STA    $6249
       STA    $6288
       STB    $E7E5
       DECB
       STB    $616D
       LDD    #$100
       STD    $61D6
       LDB    #69
       JSR    $EC0C
       LDD    #0
       STD    <Z+23
       STD    <Z+25
       INCB
       STD    <Z+27
       LDD    #TEXTE
       STD    <Z+29
       LDA    $E7C3
       ORA    #1
       STA    $E7C3
       LDA    #3
       STA    $E7E5
       LDU    #$5F40
       LDX    #$DF40
       LDA    ,-U
       STA    ,-X
       CMPX   #$C000
       BHI    *-7
       LDA    #BORDER
       STA    ,-X
       CMPX   #$A000
       BNE    *-5
       LDU    #RAMB+10
       LDX    #COULIB*256+COULIB
       JSR    CLRSCR
       LDY    #$4000  copie de
       LDX    #$CC91          GAME OVER
       LDD    #$2006
       JSR    COPY
       LDX    #$D190          PRESS FIRE
       LDD    #$2008
       JSR    COPY

       LDD    #$280
       STA    $E7E5
       STB    $E7DD
       LDX    #$A000
       LDD    #BORDER*256+BORDER
       STD    ,X++
       CMPX   #$C000
       BNE    *-5
       LDD    #0
       STD    ,X++
       CMPX   #$E000
       BNE    *-5
       LDY    #INTRO
PRES   LDX    #$C050
       LDB    ,Y+
       ANDB   #127
       ABX
       LDA    ,Y+
       LDB    #160
       MUL
       LEAX   D,X
       LDB    ,Y+
       BLT    *+7
       JSR    PUTC
       BRA    *-7
       LEAY   -1,Y
       CMPY   #FONTE-1
       BLO    PRES
       LDX    #$48D1
       LDY    #$CF10
       LDA    #24
       LDB    #3
       LDU    ,X++
       STU    ,Y++
       DECB
       BNE    *-5
       LEAX   34,X
       LEAY   34,Y
       DECA
       BNE    *-16
       LDA    #3
       STA    $E7E5

       LDX    #COLORS
       LDA    #255
       JSR    $EC00
       LDX    #RANDOM
ENCORE LDA    ,X+
       BEQ    *-5
       JSR    $E806
       BCC    *-7
       LDA    #$C0
       STA    $E7DD
       STX    <Z+10
       CMPB   #$90
       BHI    *+4
       LDB    #$90
       SUBB   #$8F
       CLRA
       CMPB   #10
       BLO    *+5
       LDD    #$100
       JSR    POCK

       LDU    #$B49C  effacement du next
       LDA    #16
       LDX    #COULIB*256+COULIB
       LEAY   ,X
       PSHU   Y,X
       LEAU   44,U
       DECA
       BNE    *-6
       CLR    <Z+9
       LDX    #SCORE+10
       JSR    MAJOR
       BCC    FINCMP
       LDB    #7
       STB    <Z+9
       LEAU   -10,X
       LEAX   20,X
       JSR    MAJOR
       BCC    *+8
       DEC    <Z+9
       BNE    *-12
       INC    <Z+9

       STU    <Z+4
       LDX    #SCORE
OUINS  CMPX   <Z+4
       BEQ    METNOM
       LDB    #20
       LDA    20,X
       STA    ,X+
       DECB
       BNE    *-6
       BRA    OUINS
METNOM LDA    #8      nom en attente
       LDB    #10
       STA    ,X+
       DECB
       BNE    *-3
       LDD    <Z+32
       ADDD   #$C0C
       STD    ,X++
       LDD    <Z+34
       ADDD   #$C0C
       STD    ,X++
       LDD    <Z+36
       ADDD   #$C0C
       STD    ,X++
       LDA    <Z+38
       ADDA   #12
       CLRB
       STD    ,X++
       LDD    <Z+41
       ADDD   #$C0C
       STD    ,X++

FINCMP
       LDU    #RAMB+10
       LDX    #COULIB*256+COULIB
       JSR    SYNSCR
       LDU    #RAMA+10
       LDX    #0
       JSR    CLRSCR

       LDX    #RAMA+163
       LDY    #SCORE+140
       LDA    #BORDER
       LDU    #$406
       STU    <Z
       LDB    ,Y+     high scores
       JSR    COLPUT
       DEC    <Z
       BNE    *-7
       LDX    #RAMA+482
       LDB    ,Y+
       JSR    COLPUT
       DEC    <Z+1
       BNE    *-7
       LDX    #RAMA+1040
       LDY    #SCORE+120
       LDA    #7
       STA    <Z+2
       LDA    #200

AFFSCO LDU    #$A0A
       STU    <Z
       LDB    ,Y+
       JSR    COLPUT
       DEC    <Z
       BNE    *-7
       LEAX   270,X
       SUBA   #72
       LDB    ,Y+
       JSR    COLPUT
       DEC    <Z+1
       BNE    *-7
       LEAX   390,X
       ADDA   #80
       LEAY   -40,Y
       DEC    <Z+2
       BNE    AFFSCO

       TST    <Z+9
       LBEQ   FINSCO
       LDX    #RAMA+145*40
       LDY    #SCORE+160
       LDD    #$A04
       STD    <Z
       LDA    #BORDER
       LDB    ,Y+
       JSR    COLPUT
       DEC    <Z
       BNE    *-7
       LDX    #RAMA+6123
       LDB    ,Y+
       JSR    COLPUT
       DEC    <Z+1
       BNE    *-7
       JSR    $E806
       BCS    *-3
       LDA    <Z+9
       LDX    #RAMA+1040
       DECA
       ASLA
       ASLA
       LDB    #170
       MUL
       LEAX   D,X     à l'écran
       STX    <Z+6
       LDY    <Z+4    en mémoire
       LDB    #10
       STB    <Z      lettres restantes
       BRA    GETNOM

       LEAY   -1,Y
       LEAX   -1,X
GETNOM JSR    $E806
       CMPB   #13
       BEQ    FINNOM
       CMPB   #8
       BEQ    DELETE
       CMPB   #29
       BEQ    DELETE
       JSR    KELCHR
       TSTB
       BLT    GETNOM
       STB    ,Y+
       JSR    PUTC
       TST    <Z
       BEQ    GETNOM-4
       DEC    <Z
       BNE    GETNOM
       BRA    GETNOM-4
DELETE LDA    <Z
       BEQ    *+10
       CMPA   #10
       BEQ    GETNOM
       LEAX   -1,X
       LEAY   -1,Y
       LDB    #8
       JSR    PUTC
       CLR    ,Y+
       INC    <Z
       BRA    GETNOM-4
FINNOM LDA    <Z
       BEQ    *+7
       CLR    ,Y+
       DECA
       BNE    *-3
       LDX    <Z+6
       LDY    <Z+4
       LDA    #10
       LDB    ,Y+
       JSR    PUTC
       DECA
       BNE    *-6
WRITE  LDU    #RAMA+143*40+10
       LDX    #0
       LEAY   ,X
       LDD    #16
       PSHU   Y,X,A
       PSHU   Y,X,A
       LEAU   50,U
       DECB
       BNE    *-8
       LDX    #SCORE-261
       STX    $604F
       LDB    #2
       STB    $6048
       CLR    SCORE-8
       JSR    $E82A
       LDD    #$4845
       CMPD   SCORE-8
       BNE    DSKERR
       LDB    #8
       STB    $6048
       LDX    #SCORE-5
       STX    $604F
       JSR    $E82A
       BCC    FINSCO
DSKERR LDY    #SCORE+174
       LDD    #$A0A
       STD    <Z
       LDX    #RAMA+145*40
       LDA    #BORDER
       LDB    ,Y+
       JSR    COLPUT
       DEC    <Z
       BNE    *-7
       LDX    #RAMA+153*40
       LDB    ,Y+
       JSR    COLPUT
       DEC    <Z+1
       BNE    *-7
       JSR    $E806
       BCS    *-3
       JSR    $E806
       BCC    *-3
       BRA    WRITE

FINSCO LDA    #64
       BITA   $E7CD
       BEQ    *-3
       LDX    #2496*50
       LEAX   -1,X
       BNE    *-2
       LDX    #RAMA+153*40
       LDY    #SCORE+150      press fire
       LDD    #BORDER*256+10
       STB    <Z
       LDB    ,Y+
       JSR    COLPUT
       DEC    <Z
       BNE    *-7

       LDA    #64
       BITA   $E7CD
       BNE    *-3
       LDA    #$80
       STA    $E7DD
       LDU    #RAMB+10
       LDX    #COULIB*256+COULIB
       JSR    CLRSCR
       JSR    $E806
       BCS    *-3
       LDX    <Z+10
       JMP    ENCORE

KELCHR CMPB   #45
       BNE    *+5
       LDB    #48
       RTS
       CMPB   #42
       BNE    *+5
       LDB    #49
       RTS
       CMPB   #33
       BNE    *+5
       LDB    #1
       RTS
       CMPB   #39
       BNE    *+5
       LDB    #4
       RTS
       CMPB   #32
       BNE    *+4
       CLRB
       RTS
       CMPB   #48
       BLO    NULL
       CMPB   #90
       BHI    NULL
       CMPB   #58
       BLO    OKAY
       CMPB   #65
       BLO    NULL
       SUBB   #7
OKAY   SUBB   #36
       RTS
NULL   LDB    #-1
       RTS
MAJOR  LDD    ,X      C=1 si score >= X
       SUBD   #$C0C
       CMPA   <Z+32
       BHI    NON
       BLO    OUI
       CMPB   <Z+33
       BHI    NON
       BLO    OUI
       LDD    2,X
       SUBD   #$C0C
       CMPA   <Z+34
       BHI    NON
       BLO    OUI
       CMPB   <Z+35
       BHI    NON
       BLO    OUI
       LDD    4,X
       SUBD   #$C0C
       CMPA   <Z+36
       BHI    NON
       BLO    OUI
       CMPB   <Z+37
       BHI    NON
       BLO    OUI
       LDA    6,X
       SUBA   #12
       CMPA   <Z+38
       BHI    NON
OUI    ORCC   #1
       RTS
NON    ANDCC  #254
       RTS
SYNSCR TST    $E7E7
       BPL    *-3
       TST    $E7E7
       BMI    *-3
CLRSCR LEAY   ,X
       TFR    X,D
       LDB    #160
       PSHU   Y,X,A
       PSHU   Y,X,A
       LEAU   50,U
       DECB
       BNE    *-8
       RTS
COPY   STD    <Z
       LDB    <Z+1
       STX    <Z+2
       LDA    ,X+
       STA    ,Y+
       DECB
       BNE    *-5
       LDX    <Z+2
       LEAX   40,X
       DEC    <Z
       BNE    COPY+2
       RTS
COLPUT LEAX   -$2000,X
       STA    -80,X
       STA    -40,X
       STA    ,X
       STA    40,X
       STA    80,X
       LEAX   $2000,X
PUTC   PSHS   D
       LDU    #FONTE
       LDA    #5
       MUL
       LEAU   D,U
       PULU   D
       STA    -80,X
       STB    -40,X
       PULU   D
       STA    ,X+
       STB    39,X
       LDA    ,U
       STA    79,X
       PULS   D,PC

COLORS FDB    0,15,240,255,3840,3855
       FDB    4080,123,5,80,85,1280,1285
       FDB    1360,52,4095

       END
