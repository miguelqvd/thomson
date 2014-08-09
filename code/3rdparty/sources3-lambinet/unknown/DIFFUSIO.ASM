****** 10/10/89 *******
******  P.I.O.  *******
******  V 1.02  *******
******  EQUATES  ******

T      EQU    $8000
DIXIEM EQU    T
SECOND EQU    T+1
MINUTE EQU    T+2
HEURE  EQU    T+3
JOUR   EQU    T+4
MOIS   EQU    T+5
ANNEE  EQU    T+6
AFTIME EQU    T+7
TEXT   EQU    T+8
DEBTXT EQU    T+10
PTEXT  EQU    T+12
QUART  EQU    T+14
PTCAR  EQU    T+15

SAVS1  EQU    T+19
SAVS2  EQU    T+21
LINAFF EQU    T+23
ZONE   EQU    T+24
GECAR  EQU    T+26
VITES  EQU    T+28
FLVIT  EQU    T+29
COMPT  EQU    T+30
APPRO  EQU    T+31
SAVCAR EQU    T+32
TABCOU EQU    T+34
TABCO0 EQU    T+36
TABCOD EQU    T+244
NBRBOU EQU    T+372
TABBOU EQU    T+373   20 boucles maxi
TABSPG EQU    T+433   50 sprog maxi
TURBO0 EQU    T+533
TURBO1 EQU    TURBO0+$7D0
MEMSC0 EQU    TURBO1+$7D0
MEMSC1 EQU    MEMSC0+$2A0
PROG   EQU    MEMSC1+$2A0

TIMER  EQU    $E7C6

******  INITIALISATION  ******

       ORG    PROG
G      PSHS   U,Y,X,DP,B,A,CC
       LDB    #$14
       JSR    $E803
       LDA    $6019
       ORA    #2
       STA    $6019
       LDB    #$FA
       JSR    $E806
       LDD    #$FB04
       STA    $E7CC
       STB    $E7CE
       ORCC   #$50
       LDX    #$8000
       LDU    #0
CLEAR  STU    ,X++
       CMPX   #$8400
       BNE    CLEAR
       STS    SAVS1
       LDA    #3
       STA    APPRO
       STA    QUART
       LDA    #$24
       STA    $E7E6
       LDX    #$0004
       STX    DEBTXT
       STX    PTEXT
       LDX    #$0200
       STX    VITES
       LDX    #$9800
       STX    GECAR
       LDA    #8
       STA    $E7E5
       LDX    #TABCO0
       STX    TABCOU
       LDD    #$4080
C0     STA    64,X
       STB    48,X
       STB    32,X
       STA    16,X
       STB    ,X+
       ADDA   #8
       INCB
       CMPB   #$88
       BNE    C0
       CLRA
       CLRB
C1     STA    64,X
       STB    48,X
       STB    32,X
       STA    16,X
       STB    ,X+
       ADDA   #8
       INCB
       CMPB   #$8
       BNE    C1
       LDX    #TABCOD
       CLR    COMPT
C2     LDA    COMPT
       CMPA   #128
       BNE    C23
       LEAX   -256,X
C23    CLRB
       LSRA
       BCC    C3
       ORB    #8
C3     LSRA
       BCC    C4
       ORB    #$10
C4     LSRA
       BCC    C5
       ORB    #$20
C5     LSRA
       BCC    C6
       ORB    #1
C6     LSRA
       BCC    C7
       ORB    #2
C7     LSRA
       BCC    C8
       ORB    #4
C8     LSRA
       BCC    C9
       ORB    #$80
C9     LSRA
       BCC    C10
       ORB    #$40
C10    STB    ,X+
       INC    COMPT
       BNE    C2
       LDX    #TURBO0
       BSR    H10
       LDX    #TURBO1
       BSR    H10
       LDX    #TURBO1+6
       LDU    #MEMSC1+1
       STU    ,X
       LDA    #0
       STA    LINAFF
       LBRA   INTER

H10    LEAX   7,X
       LDY    #TURBO-1
       LDA    #16
I0     LDU    ,Y++
       LDB    #64
I1     STU    ,X
       LEAX   31,X
       DECB
       BNE    I1
       LEAX   -1982,X
       DECA
       BNE    I0
       LEAX   -39,X
       LDD    #$10FF
       LDU    #SAVS2
       STD    ,X++
       STU    ,X++
       LDB    #$CE
       LDU    #MEMSC0+1
       STD    ,X++
       STU    ,X
       LEAX   1986,X
       LDU    #$8400
       STU    ,X++
       LDU    #SAVS2
       LDB    #$FE
       STD    ,X++
       STU    ,X++
       LDA    #$39
       STA    ,X
       RTS

INITOU STB    LINAFF
       BSR    INIZON
       BSR    INICOU
       BSR    INIFOR
       LBSR   INIMS0
       LBSR   INIMS1
       LBRA   INITUR

TURBO  PULS   CC,A,B,DP,X,Y,U
       LEAS   -1,S
       PSHS   U,Y,X,DP,B,A,CC
       LEAS   -$5AC6,S
       PSHS   U,Y,X,DP,B,A,CC
       LEAS   50,S
       PSHS   U,Y,X,DP,B,A,CC
       LEAS   50,S
       PSHS   U,Y,X,DP,B,A,CC
       LEAS   50,S
       PSHS   U,Y,X,DP,B,A,CC
       LEAS   $5A63,S

INIZON LDA    LINAFF  Calcule la fin
       CMPA   #34       de la zone
       LBHI   FINIZO
       LDB    #160
       MUL
       ADDD   #$4A00
       STD    ZONE
FINIZO RTS

INICOU LDU    ZONE    Initial. des
       BSR    RAMB      couleurs
       LDX    #$C0C0
       LDY    #$C0C0
       LDD    #$C000
I3     PSHU   Y,X,A
       PSHU   Y,X,A
       DECB
       BNE    I3
       RTS

INIFOR LDU    ZONE    Efface la zone
       LDA    $E7C3   par initial. de
       ORA    #1      la forme à $F0
       STA    $E7C3
       LDX    #$F0F0
       LDY    #$F0F0
       LDD    #$F000
I2     PSHU   Y,X,A
       PSHU   Y,X,A
       DECB
       BNE    I2
RAMB   LDA    $E7C3
       ANDA   #$FE
       STA    $E7C3
       RTS

INIMS0 LDU    #MEMSC0+672
       LDX    TABCOU
       LDA    ,X
       ADDA   16,X
       TFR    A,B
       TFR    D,X
       TFR    D,Y
       LDB    #168
PI0    PSHU   X,Y
       DECB
       BNE    PI0
       RTS

INIMS1 LDU    #MEMSC1+672
       LDX    TABCOU
       LDA    16,X
       ADDA   32,X
       TFR    A,B
       TFR    D,X
       TFR    D,Y
       LDB    #168
PI1    PSHU   X,Y
       DECB
       BNE    PI1
       RTS

INITUR LDU    ZONE
       LEAU   -$9F6-MEMSC0,U
       LDY    #TURBO0+6
       TFR    U,D
       NEGA
       COMB
       TFR    D,X
       LEAX   -$162,X
       LDA    #16
I4     LDB    #4
I5     LEAY   10,Y
       STU    ,Y
       LEAY   21,Y
       STX    ,Y
       DECB
       BNE    I5
       LEAX   2,X
       STX    ,Y
       LEAU   $76,U
       LEAX   -$78,X
       DECA
       BNE    I4
       LDU    ZONE
       LEAU   -$9F6-MEMSC1,U
       LDY    #TURBO1+6
       TFR    U,D
       NEGA
       COMB
       TFR    D,X
       LEAX   -$162,X
       LDA    #16
I6     LDB    #4
I7     LEAY   10,Y
       STU    ,Y
       LEAY   21,Y
       STX    ,Y
       DECB
       BNE    I7
       LEAX   2,X
       STX    ,Y
       LEAU   $76,U
       LEAX   -$78,X
       DECA
       BNE    I6
       RTS

MEMZON LBSR   INIZON
       LDU    #MEMSC0+$29E
       LDY    ZONE
       LDA    #16
MZO0   LDB    #20
MZO1   LDX    ,--Y
       PSHU   X
       DECB
       BNE    MZO1
       LEAY   -$78,Y
       LEAU   -2,U
       DECA
       BNE    MZO0
       LBRA   INITUR

ATTRAM LDA    #$31
       STA    $E7C1
ATTRA0 LDA    $E7E7
       BPL    ATTRA0
TRAME  LDA    $E7E7
       BMI    TRAME
       LDA    #$30
       STA    $E7C1
       RTS

INTER  BSR    ATTRAM
       LDX    #$30D4
       STX    TIMER
       BSR    QUICK
UN     LDX    TIMER
       CMPX   #$2710
       BHI    UN
       BSR    QUICK
DEUX   LDX    TIMER
       CMPX   #$1D4C
       BHI    DEUX
       BSR    QUICK
TROIS  LDX    TIMER
       CMPX   #$1388
       BHI    TROIS
       BSR    QUICK
QUATRE LDX    TIMER
       CMPX   #$09C4
       BHI    QUATRE
       BSR    QUICK
       BRA    INTER

QUICK  LDA    $E7C3
       BITA   #8
       LBEQ   FINAL
       LDA    VITES
       CMPA   #1
       BNE    V023
       COM    FLVIT
       LBEQ   TURBO0
V023   LDA    QUART
       CMPA   APPRO
       BLO    ANCCAR
       LDX    PTEXT
       LDA    ,X+
       STX    PTEXT
       CMPA   #$20
       LBLO   CARSPC
       STA    SAVCAR
       CLR    QUART
       LDB    #64
       MUL
       ADDD   GECAR
       BRA    AFFICH
ANCCAR INCA
       STA    QUART
       CMPA   #4
       BLO    PASAPP
       LDD    #$800
       ADDD   GECAR
       BRA    AFFICH
PASAPP LDD    PTCAR
       ADDD   #16
AFFICH STD    PTCAR
       LDA    VITES
       BEQ    GLIMEM
       BSR    MODMEM
       LDA    VITES
       CMPA   #1
       BNE    V23
       LBRA   TURBO1
V23    LBSR   TURBO0
       LDA    VITES
       CMPA   #2
       BLS    SV
       INC    QUART
       LDD    PTCAR
       ADDD   #16
       STD    PTCAR
GLIMEM BSR    MODMEM
       LDU    #MEMSC0+1
       LDA    #16
GL0    LDB    #8
GL1    PULU   X,Y,DP
       LEAU   -1,U
       PSHU   X,Y,DP
       LEAU   6,U
       DECB
       BNE    GL1
       LEAU   2,U
       DECA
       BNE    GL0
SV     RTS
MODMEM LDX    PTCAR
       LDY    TABCOU
       LDU    #MEMSC0+41
B2     LDA    ,U
       ANDA   #$0F
       ORA    #$10
       LDB    A,Y
       LDA    ,X
       STA    ,U
       LSRA
       LSRA
       LSRA
       LSRA
       ADDB   A,Y
       STB    671,U
       ORA    #$10
       LDB    A,Y
       LDA    ,X+
       ANDA   #$0F
       ADDB   A,Y
       STB    -1,U
       LEAU   42,U
       CMPU   #MEMSC1
       BLO    B2
       RTS

CARSPC ORCC   #$50
       COM    FLVIT
       LDU    #DISPAT
       LSLA
       JMP    [A,U]

DISPAT FDB    NUL,APP,BOU,COU,DEB,EFF
       FDB    FIN,GEC,HEU,INV,JOU,KLI
       FDB    LAR,MIX,NUL,ORI,PAU,NUL
       FDB    REP,SPG,TRA,UTI,VIT,NUL
       FDB    NUL,NUL,NUL,NUL,NUL,NUL
       FDB    NUL,NUL

INPUT  LDB    ,X+
       CMPB   #10
       LBHI   QUICK
       LDA    #10
       MUL
       TFR    D,U
       LDB    ,X+
       CMPB   #10
       LBHI   QUICK
       LEAU   B,U
       TFR    U,D
       STX    PTEXT
       RTS

NUL    RTS

APP    LDA    ,X+
       STX    PTEXT
       CMPA   #3
       BHI    NUL
       ADDA   #3
       STA    APPRO
       LBRA   QUICK
BOU    LDA    NBRBOU
       INCA
       STA    NBRBOU
       CMPA   #16
       BLS    BOUD
BOUR   LDD    ,X+
       CMPD   #$0602
       BNE    BOUR
       STD    PTEXT
       DEC    NBRBOU
       BRA    NUL
BOUD   LDY    #TABBOU
       LEAY   A,Y
       LEAY   A,Y
       LEAY   A,Y
       BSR    INPUT
       STB    ,Y+
       BEQ    BOUR
       STX    ,Y
       LBRA   QUICK
COU    LDA    ,X+
       CMPA   #1
       BNE    COUI
       BSR    CINPUT
       BRA    COUA
CINPUT LDD    ,X++
       STX    PTEXT
       CMPA   #15
       LBHI   QUICK
       CMPB   #15
       LBHI   QUICK
       RTS
COUA   PSHS   A,B
       LDX    #TABCO0
       LEAY   48,X
       LDB    B,Y
       STB    A,X
       ORA    #$20
       STB    A,X
       PULS   B,A
       ORB    #$10
       LDB    B,Y
       ORA    #$10
       STB    A,X
       LBRA   QUICK
COUI   CMPA   #9
       BNE    COUP
       BSR    CINPUT
       PSHS   A,B
       LDX    #TABCO0
       LDA    B,X
       LDB    ,S
       LDB    B,X
       PSHS   B
       LDB    1,S
       STA    B,X
       PULS   B
       LDA    1,S
       STB    A,X
       LEAX   16,X
       LDB    1,S
       LDA    B,X
       LDB    ,S
       LDB    B,X
       PSHS   B
       LDB    1,S
       STA    B,X
       PULS   B
       LDA    1,S
       STB    A,X
       LDX    #TABCO0
       PULS   A,B
       LEAX   A,X
       LDA    ,X
       STA    32,X
       LDX    #TABCO0
       LEAX   B,X
       LDA    ,X
       STA    32,X
       LBRA   QUICK
COUP   CMPA   #16
       BNE    COUR
       CLRB
COUP0  LDU    #TABCO0
       LDA    ,X+
       CMPA   #15
       BHI    COUP1
       LEAY   A,U
       LEAU   B,U
       LDA    48,Y
       STA    ,U
       STA    32,U
       LDA    64,Y
       STA    16,U
COUP1  INCB
       CMPB   #16
       BNE    COUP0
       STX    PTEXT
       LBRA   QUICK
COUR   CMPA   #18
       BNE    COUT
       STX    PTEXT
       LDB    #8
       LDX    #TABCO0
BCOUR  LDU    64,X
       STU    16,X
       LDU    48,X
       STU    32,X
       STU    ,X++
       DECB
       BNE    BCOUR
       LBRA   QUICK
COUT   CMPA   #20
       BNE    SCOUT
       LDA    ,X+
       STX    PTEXT
       CMPA   #15
       BHI    SCOUT
       CMPA   #8
       BLO    ADDCOU
       ADDA   #$18
ADDCOU ADDA   #$60
       LDB    #$1B
       JSR    $E803
       TFR    A,B
       JSR    $E803
       LBSR   RAMB
SCOUT  LBRA   QUICK

DEB    LDX    DEBTXT
       STX    PTEXT
       LBRA   QUICK

EFF    LDU    #$5F40
       LDA    $E7C3
       ORA    #1
       STA    $E7C3
       LDA    #$F0
       TFR    A,DP
       LDX    #$F0F0
       LDY    #$F0F0
       LDA    #10
EFFT0  LDB    #160
EFFT1  PSHU   DP,X,Y
       DECB
       BNE    EFFT1
       DECA
       BNE    EFFT0
       LBSR   RAMB
       LDU    #$5F40
       LDX    TABCOU
       LDA    ,X
       ORA    16,X
       TFR    A,B
       TFR    A,DP
       TFR    D,X
       TFR    D,Y
       LDA    #10
EFFT2  LDB    #160
EFFT3  PSHU   DP,X,Y
       DECB
       BNE    EFFT3
       DECA
       BNE    EFFT2
       LBRA   ATTKLI

FIN    LDA    ,X+
       CMPA   #2
       LBHI   QUICK
       BEQ    FINB
FINAL  CLR    $E7E6
       LDD    #$F71F
       STA    $E7CC
       STB    $E7CE
       LDA    #$31
       STA    $E7C1
       LDS    SAVS1
K      PULS   CC,A,B,DP,X,Y,U,PC
FINB   CMPA   #2
       LBNE   QUICK
       LDA    NBRBOU
       LDU    #TABBOU
       LEAU   A,U
       LEAU   A,U
       LEAU   A,U
       DEC    ,U+
       BEQ    FINC
       LDX    ,U
       STX    PTEXT
       LBRA   QUICK
FINC   DEC    NBRBOU
       STX    PTEXT
       BRA    FINC-3

GEC    LDA    ,X+
       STX    PTEXT
       CMPA   #3
       LBHI   QUICK
       LDB    #8
       BITA   #2
       BEQ    GEC0
       LDB    #9
GEC0   STB    $E7E5
       BITA   #1
       BNE    GEC1
       LDX    #$9800
       BRA    GEC1+3
GEC1   LDX    #$B800
       STX    GECAR
       LBRA   QUICK

INV    LDX    #TABCO0
       LDD    ,X
       EXG    A,B
       STD    ,X
       STD    32,X
       LDD    16,X
       EXG    A,B
       STD    16,X
       LBRA   QUICK

KLI    LBSR   INPUT
       STB    COMPT
       LEAS   -1,S
BC     LDU    ZONE
       LDX    TABCOU
       LDA    ,X
       ADDA   16,X
       TFR    A,B
       TFR    D,X
       TFR    D,Y
       LDB    #$A0
BC0    PSHU   X,Y
       PSHU   X,Y
       PSHU   X,Y
       PSHU   X,Y
       DECB
       BNE    BC0
       LDX    #$6000
BC1    LEAX   -1,X
       BNE    BC1
       LDY    ZONE
       LEAY   -$A00+5,Y
       LDU    #MEMSC0
       LDA    #8
       STA    ,S
BC2    PULU   DP,A,B,X
       EXG    Y,U
       PSHU   X,B,A,DP
       LEAU   45,U
       PSHU   X,B,A,DP
       LEAU   45,U
       PSHU   X,B,A,DP
       LEAU   45,U
       PSHU   X,B,A,DP
       LEAU   -$6E,U
       EXG    Y,U
       DEC    ,S
       BNE    BC2
       LDA    #8
       STA    ,S
       LEAU   2,U
       LEAY   $78,Y
       CMPY   ZONE
       BLO    BC2
       LDX    #$C000
BC3    LEAX   -1,X
       BNE    BC3
       DEC    COMPT
       BNE    BC
       LEAS   1,S

ATTKLI LDX    TIMER
       CMPX   #$9FF
       BLO    ATTKLI
       RTS

ORI    LBSR   INPUT
       CMPB   #34
       LBHI   QUICK
       LBSR   INITOU
       LBRA   MEMZON

PAU    LBSR   INPUT
       LSLB
TEMPO  LDX    #0
       LEAX   -1,X
       BNE    TEMPO+3
       DECB
       BNE    TEMPO
       LBRA   ATTKLI

TRA    LBSR   INPUT
       CMPB   #34
       LBHI   QUICK
       SUBB   LINAFF
       LBEQ   QUICK
       BMI    MON0
       STB    COMPT
DES1   INC    LINAFF
       LBSR   INIZON
       LBSR   ATTRAM
       LDU    ZONE
       LEAU   -$A5,U
       LDA    #16
DES2   LDB    #8
DES3   PULU   X,Y,DP
       LEAU   $28,U
       PSHU   X,Y,DP
       LEAU   $2D,U
       PSHU   X,Y,DP
       LEAU   $2D,U
       PSHU   X,Y,DP
       LEAU   $2D,U
       PSHU   X,Y,DP
       LEAU   -$A5,U
       DECB
       BNE    DES3
       LEAU   -$78,U
       DECA
       BNE    DES2
       DEC    COMPT
       BNE    DES1
       BRA    TRAS
MON0   NEGB
       STB    COMPT
MON1   DEC    LINAFF
       LBSR   INIZON
       LDU    ZONE
       LEAU   -$960,U
       LDA    #16
MON2   LDB    #8
MON3   PULU   X,Y,DP
       LEAU   -$28,U
       PSHU   X,Y,DP
       LEAU   -$23,U
       PSHU   X,Y,DP
       LEAU   -$23,U
       PSHU   X,Y,DP
       LEAU   -$23,U
       PSHU   X,Y,DP
       LEAU   $A5,U
       DECB
       BNE    MON3
       LEAU   $78,U
       DECA
       BNE    MON2
       LBSR   ATTRAM
       DEC    COMPT
       BNE    MON1

TRAS   LBSR   MEMZON
       LBRA   ATTKLI

VIT    LDA    ,X+
       STX    PTEXT
       CMPA   #3
       LBHI   QUICK
       STA    VITES
       CMPA   #2
       LBEQ   QUICK
       CLR    FLVIT
       LDU    #TABCOD
       LDX    #MEMSC0
B3     LDB    #39
B4     LDA    ,X+
       ANDA   #$87
       LEAY   A,U
       LDA    ,X
       ANDA   #$78
       LDA    A,Y
       STA    $2A0,X
       DECB
       BNE    B4
       LEAX   3,X
       CMPX   #MEMSC1
       BLO    B3
       LBRA   QUICK


HEU    RTS
JOU    RTS
LAR    RTS
MIX    RTS
REP    RTS
SPG    RTS
UTI    RTS

       END
