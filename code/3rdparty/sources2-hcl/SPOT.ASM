          ********************
          *                  *
      *****      H.C.L       *****
      *DOC*                  *DOC*
      ***** IN THE SPOTLIGHT *****
          *                  *
          ********************

SIGLE  EQU    $7200
VAGTAB EQU    $7EB0
REM    EQU    $8000
FONTES EQU    $8280
TEXTE  EQU    $8F00
ECRAN  EQU    $C014+40*190
MASK   EQU    $9000
STARS  EQU    $9780
TAMP   EQU    $98D0
DIR    EQU    $98
Z      EQU    $F0
ZZ     EQU    DIR*256+Z

       ORG    $9900
G      ORCC   #80
       LDA    #DIR
       EXG    A,DP
       STA    RDP+1
       STS    RDP-2

       LDX    #PRINT
       LDB    ,X+
       BEQ    *+7
       JSR    $E803
       BRA    *-7
       LDA    #2
       STA    $E7E5
       LDD    #0
       LDX    #$A000
       STD    ,X++
       CMPX   #$E000
       BNE    *-5

       LDX    #$B4C8
       LDU    #SIGLE
       LDD    ,U++
       STD    ,X++
       CMPX   #$C178
       BNE    *-7
       STU    ZZ+1
       LDA    #255
       LDX    #KOKO
       JSR    $EC00
       LDX    KOKO
       LEAY   ,X
       CLRA
       JSR    $EC00
       MUL
       LDX    #200
       MUL
       MUL
       MUL
       MUL
       ADDD   [,U++]
       LEAX   -1,X
       BNE    *-8
       LDA    $E7C3
       ORA    #1
       STA    $E7C3

VAG    LDA    #38
       STA    ZZ
       LDX    ZZ+1
       LDU    ,X++
       CMPX   #VAGTAB+$144
       BNE    *+5
       JMP    FVAG
       STX    ZZ+1
       LDS    #$40EA
COPY   FDB    $373E,$343E,$373E,$343E
       FDB    $373E,$343E,$373E,$343E
       FCB    50,232,68
       FDB    $373E,$343E,$373E,$343E
       FDB    $373E,$343E,$373E,$343E
       FCB    50,232,68
       FDB    $373E,$343E,$373E,$343E
       FDB    $373E,$343E,$373E,$343E
       FCB    50,232,68
       FDB    $373E,$343E,$373E,$343E
       FDB    $373E,$343E,$373E,$343E
       FCB    50,232,68
       FDB    $373E,$343E,$373E,$343E
       FDB    $373E,$343E,$373E,$343E
       FCB    50,232,68
       DEC    ZZ
       BNE    COPY
       LDA    #71
       DECA
       BNE    *-1
       JMP    VAG

FVAG   LDY    #40*312
       MUL
       MUL
       MUL
       MUL
       MUL
       LEAY   -1,Y
       BNE    FVAG+4
       LDS    RDP-2
       LDA    #12
       LDB    ,X+
       JSR    $E803
       DECA
       BNE    *-6
       LDU    #$4E1F
       JSR    AJUS
       LEAU   -12*40+7,U
       JSR    AJUS
       LDU    #$4000+138*40
       LDD    ,X++
       STD    ,U++
       CMPX   #$8280
       BNE    *-7

       LDU    #$4000
       LDX    #$A000
       LDD    #0
       STD    ,X++
       CMPX   #$C000
       BNE    *-5
       LDD    ,U++
       STD    ,X++
       CMPX   #$DF40
       BNE    *-7
       LDA    #128
       STA    $E7DD
       LDA    #DIR
       TFR    A,DP
       LDD    #$6410
       STD    <Z
       LDD    #$201
       STD    <Z+2
       LDD    #$A100
       STD    <Z+4
       LDD    #$0180
       STD    <Z+7
       LDA    #32
       STD    <Z+9
       ASLA
       STD    <Z+11
       LDD    #TEXTE
       STD    <Z+13
       LDX    #KOKO
       LDA    #255
       JSR    $EC00
       LDX    KOKO
       LEAY   ,X
       CLRA
       JSR    $EC00
       MUL

       LDX    #$D7+312*40
WAIT   MUL
       MUL
       MUL
       MUL
       ADDD   [,U++]
       LEAX   -1,X
       BNE    WAIT
       MUL
       MUL
       MUL
       MUL
       TST    ,--X

SPOT   LDU    #VIDE
       PULU   X,Y,S
       LDU    <Z+4
       LEAU   4,U
       LDA    #10
       PSHU   S,Y,X
       LEAU   46,U
       PSHU   S,Y,X
       LEAU   46,U
       PSHU   S,Y,X
       LEAU   46,U
       PSHU   S,Y,X
       LEAU   46,U
       DECA
       BNE    *-21

       LDD    #$E704
       TFR    A,DP
       STB    <$DB
       LDD    #5
       STB    <$DA
       STA    <$DA
       LDD    #15
       STB    <$DA
       STA    <$DA
       LDA    #DIR
       TFR    A,DP

       LDU    #STARS+$70
       LDA    #20
       STA    <Z+6
       CLRA
       LDB    <Z+8
       BEQ    M1
L1     LDB    <Z+8
       COMB
       LDX    ,U++
       ORB    $2000,X
       COMB
       STB    ,X
       MUL
       TST    [,X]
       LDB    <Z+8
       LSRB
       DEC    <Z+6
       BNE    L1
       BRA    N1
M1     LDB    #127
       LDX    ,U
       ORB    $2000,X
       COMB
       STD    ,X+
       CMPX   $70,U
       BEQ    *+6
       TST    [,U]
       BRA    *+7
       CLR    ,X
       LDX    -$70,U
       STX    ,U++
       DEC    <Z+6
       BNE    M1
       LDD    #64
N1     STB    <Z+8

       LDA    #16
       STA    <Z+6
       CLRA
       LDB    <Z+9
       BEQ    M2
L2     LDB    <Z+9
       COMB
       LDX    ,U++
       ORB    $2000,X
       COMB
       STB    ,X
       MUL
       TST    A,X
       LDB    <Z+9
       LSRB
       LSRB
       DEC    <Z+6
       BNE    L2
       BRA    N2
M2     LDB    #127
       LDX    ,U
       ORB    $2000,X
       COMB
       STD    ,X+
       CMPX   $70,U
       BEQ    *+6
       TST    [,U]
       BRA    *+7
       CLR    ,X
       LDX    -$70,U
       STX    ,U++
       DEC    <Z+6
       BNE    M2
       LDD    #32
N2     STB    <Z+9

       LDB    <Z+12
       COMB
       STB    M3+1
       LDA    #12
       STA    <Z+6
       CLRA
       LDB    <Z+10
       BEQ    M3
L3     LDB    <Z+10
       COMB
       LDX    ,U++
       ORB    $2000,X
       COMB
       STB    ,X
       MUL
       ABX
       NOP
       LDB    <Z+10
       LSRB
       LSRB
       LSRB
       DEC    <Z+6
       BNE    L3
       TST    [,U]
       TST    ,X+
       BRA    N3
M3     LDB    #0
       LDX    ,U
       ORB    $2000,X
       COMB
       STD    ,X+
       CMPX   $70,U
       BEQ    *+6
       TST    [,U]
       BRA    *+7
       CLR    ,X
       LDX    -$70,U
       STX    ,U++
       DEC    <Z+6
       BNE    M3
       LDB    <Z+12
       CMPB   #32
       BNE    *+10
       LDB    #128
       STB    <Z+12
       LDB    #4
       BRA    N3
       LSRB
       STB    DIR*256+Z+12
       LSRB
       LSRB
N3     STB    <Z+10

       LDA    #8
       STA    <Z+6
       CLRA
       LDB    <Z+11
       BEQ    M4
L4     LDB    <Z+11
       COMB
       LDX    ,U++
       ORB    $2000,X
       COMB
       STB    ,X
       MUL
       ABX
       LDB    <Z+11
       LSRB
       LSRB
       LSRB
       LSRB
       DEC    <Z+6
       BNE    L4
       BRA    N4
M4     LDB    #127
       LDX    ,U
       ORB    $2000,X
       COMB
       STD    ,X+
       CMPX   $70,U
       BEQ    *+6
       TST    [,U]
       BRA    *+7
       CLR    ,X
       LDX    -$70,U
       STX    ,U++
       DEC    <Z+6
       BNE    M4
       LDD    #8
N4     STB    <Z+11

       LDY    <Z+13
       LDX    #ECRAN
       LDA    #32
SCROL  ANDCC  #254
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
       LEAX   -40,X
       DECA
       BNE    SCROL
       DEC    <Z+7
       BEQ    NEXT

       LDB    #39
       NOP
       DECB
       BNE    *-1
RELAIS LDX    #ECRAN-32*40+15
       LDU    #TAMP
       LDA    #32
       STA    <Z+6

PREPA  LEAX   40,X
       LDB    ,X
       ANDB   #254
       LDA    ,U
       BITA   #128
       BEQ    *+5
       INCB
       BRA    *+4
       LDA    1,X
       STB    ,X
       ASL    ,U+
       DEC    <Z+6
       BNE    PREPA
       BRA    JOIN

NEXT   LDB    ,Y+
       BNE    *+10
       LDY    #TEXTE
       LDB    #52
       BRA    *+5
       DECB
       TST    A,X
       LDA    #32
       LDX    #FONTES-32
       LDU    #TAMP+32
       MUL
       LEAS   D,X
       PULS   D,X
       PSHU   X,D
       PULS   D,X
       PSHU   X,D
       PULS   D,X
       PSHU   X,D
       PULS   D,X
       PSHU   X,D
       PULS   D,X
       PSHU   X,D
       PULS   D,X
       PSHU   X,D
       PULS   D,X
       PSHU   X,D
       PULS   D,X
       PSHU   X,D
       LDD    #$800
       STA    <Z+7
       BRA    RELAIS

JOIN   STY    <Z+13
       LDA    #20
       STA    <Z+6
       LDU    #MASK
       LDX    #$B364
       LDA    <Z+1
       LDB    #40
       MUL
       LEAX   D,X
       LDA    <Z
       LDB    <Z
       LSRA
       LSRA
       LSRA
       LEAX   A,X
       STX    <Z+4
       ANDB   #7
       LDA    #240
       MUL
       LEAU   D,U
       LEAY   $2000,X
PROJO  PULU   D
       ANDA   -2,Y
       ORA    -2,X
       ANDB   -1,Y
       ORB    -1,X
       STD    -2,X
       PULU   D
       ANDA   ,Y
       ORA    ,X
       ANDB   1,Y
       ORB    1,X
       STD    ,X
       PULU   D
       ANDA   2,Y
       ORA    2,X
       ANDB   3,Y
       ORB    3,X
       STD    2,X
       LEAX   40,X
       LEAY   40,Y
       PULU   D
       ANDA   -2,Y
       ORA    -2,X
       ANDB   -1,Y
       ORB    -1,X
       STD    -2,X
       PULU   D
       ANDA   ,Y
       ORA    ,X
       ANDB   1,Y
       ORB    1,X
       STD    ,X
       PULU   D
       ANDA   2,Y
       ORA    2,X
       ANDB   3,Y
       ORB    3,X
       STD    2,X
       LEAX   40,X
       LEAY   40,Y
       DEC    <Z+6
       BNE    PROJO

       LDD    <Z
       ADDA   <Z+2
       CMPA   #4
       BHS    *+5
       NOP
       BRA    *+9
       CMPA   #244
       BHI    *+5
       ABX
       BRA    *+4
       NEG    <Z+2
       ADDB   <Z+3
       CMPB   #4
       BHS    *+5
       NOP
       BRA    *+9
       CMPB   #28
       BHI    *+5
       ABX
       BRA    *+4
       NEG    <Z+3
       STD    <Z

       MUL
       TST    ,--X
       LDD    #$E704
       TFR    A,DP
       STB    <$DB
       LDD    #$500
       STB    <$DA
       STA    <$DA
       LDD    #$F00
       STB    <$DA
       STA    <$DA
       LDA    #DIR
       TFR    A,DP

       LDA    $E7CC
       LDB    <Z+15
       BEQ    JOY
       DECB
       STB    DIR*256+Z+15
NJOY   LDA    #8
       DECA
       BNE    *-1
       ABX
       JMP    FJOY
JOY    LDB    #20     antirebond
       CMPA   #255
       BEQ    NJOY
       STB    <Z+15
       BITA   #1
       BEQ    NORD
       BITA   #8
       BEQ    EST
       BITA   #2
       BEQ    SUD
       ABX
       LDB    <Z+2
       BLT    *+5
       JMP    *+5
       CLRA
       NEGB
       LSRB
       TSTA
       BEQ    *+6
       LSR    <Z+2
       BRA    FJOY
       NEGB
       STB    <Z+2
       BRA    FJOY
SUD    ABX
       LDB    <Z+3
       BLT    *+5
       JMP    *+5
       CLRA
       NEGB
       LSRB
       TSTA
       BEQ    *+6
       LSR    <Z+3
       BRA    FJOY
       NEGB
       STB    <Z+3
       BRA    FJOY
EST    LDB    <Z+2
       BNE    *+9
       INC    <Z+2
       MUL
       TST    ,-X
       BRA    FJOY
       BLT    *+5
       JMP    *+5
       CLRA
       NEGB
       CMPB   #4
       BLO    *+6
       TST    [D,X]
       BRA    FJOY
       ASLB
       TSTA
       BEQ    *+6
       ASL    <Z+2
       BRA    FJOY
       NEGB
       STB    <Z+2
       BRA    FJOY
NORD   LDX    ,X
       LDB    <Z+3
       BNE    *+9
       INC    <Z+3
       MUL
       TST    ,-X
       BRA    FJOY
       BLT    *+5
       JMP    *+5
       CLRA
       NEGB
       CMPB   #4
       BLO    *+6
       TST    [D,X]
       BRA    FJOY
       ASLB
       TSTA
       BEQ    *+6
       ASL    <Z+3
       BRA    FJOY
       NEGB
       STB    <Z+3
       BRA    FJOY

FJOY   LDX    #158
       NOP
       LEAX   -1,X
       BNE    *-3
       TST    ,--X
       LDA    $E7C8
       BITA   #1
       LBEQ   SPOT

       LDS    #0
RDP    LDA    #0
       TFR    A,DP
       CLR    $E7DD
       LDX    #OUT
       LDB    ,X+
       JSR    $E803
       BNE    *-5
       LDA    #255
       LDX    #COLORS
       NOP
       JSR    $EC00
       SWI
AJUS   LDA    #12
       LDB    #4
       LSR    -1,U
       ROR    ,U
       ROR    1,U
       DECB
       BNE    *-7
       LEAU   40,U
       DECA
       BNE    AJUS+2
       RTS

PRINT  FDB    $1B5B,$1B59,$1B60,$1F4C
       FDB    $4F1B,$411B,$4D00
OUT    FDB    $1B5A,$1B4C
KOKO   FDB    0,4095,5,15
VIDE   FDB    0,0
COLORS FDB    0,15,240,255,3840,3855
       FDB    4080,4095,1911,826,931
       FDB    938,2611,2618,3815,123

       END
