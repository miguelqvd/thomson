****************************************
*                                      *
* TRANSCODEUR D'IMAGES TO7-70,BM4,BM16 *
*                                      *
* en IMAGES pour MINITEL en car. grap. *
*                                      *
* par Michel SAINT-BRIANT * 15/03/1992 *
*                                      *
* (c)    A.S.C.I.    Copyright    1992 *
*                                      *
****************************************

       ORG    $9800

       PSHS   A,B,CC,DP,X,Y,U

       LDB    #$14    ARRET CLIGNOTEMENT
       JSR    $E803
       LDA    $605F   TYPE DE CONSOLE
       LSLA
       STA    TYPE

* ETABLISSEMENT DE LA TABLE DES GRIS

       LDU    #PALET+32
       LDA    #15
LIPAL  LDX    #$FFFF
       LDY    #0
       JSR    $EC00
       STX    ,--U
       DECA
       BPL    LIPAL

       LDX    #PALET
       LDY    #TABGRI
NOUPAL LDD    ,X
       BITA   #$10
       BNE    CALGRI
       COMA
       COMB
       STD    ,X
CALGRI CLRA
       ANDB   #$F0
       LSRB
       LSRB
       TFR    D,U
       LDD    ,X
       ANDA   #$0F
       LEAU   A,U
       ANDB   #$0F
       LSLB
       LEAU   B,U
       TFR    U,D
       STB    ,Y+
       CLRA
RECPA0 SUBB   #7
       BMI    RECPA1
       INCA
       BRA    RECPA0
RECPA1 PSHS   A
       LDB    #17
       MUL
       PULS   A
       ORA    #$10
       STD    ,X++
       CMPX   #PALET+32
       BLO    NOUPAL
       LDX    #PALET
       LDA    #$FF
       JSR    $EC00

* DECODAGE DE L'IMAGE EN FONCTION DU
* TYPE ET STOCKAGE EN RAM

       LDX    #$A000
       LDU    #0
BZERO  STU    ,X++
       CMPX   #$E000
       BLO    BZERO

       LDU    #$A800
       LDX    #$4000
       LDA    #20     20 LIGNES MINITEL
       STA    COMPTL
LIGNE  LDA    #40     40 COLONNES
       STA    COMPTO
COLON  LDA    #3
       LBSR   CALZON
       LEAX   120,X
       LDA    #4
       LBSR   CALZON
       LEAX   160,X
       LDA    #3
       LBSR   CALZON

       LDD    -12,U
       ADDD   -10,U
       ADDD   -4,U
       ADDD   -2,U
       TFR    D,Y
       LEAY   D,Y
       LEAY   D,Y
       LDD    -8,U
       ADDD   -6,U
       LEAY   D,Y
       LEAY   D,Y
       LEAY   D,Y
       LEAY   D,Y
       LDD    #0
       EXG    D,Y
       CMPD   #320
       BLS    MOYEN1
MOYEN0 SUBD   #320
       LEAY   16,Y
       CMPD   #320
       BHI    MOYEN0
MOYEN1 CMPD   #20
       BLS    MOYEN3
MOYEN2 SUBD   #20
       LEAY   1,Y
       CMPD   #20
       BHI    MOYEN2
MOYEN3 STY    ,U
       LEAU   4,U
       LEAX   -279,X
       DEC    COMPTO
       LBNE   COLON
       LEAX   360,X
       DEC    COMPTL
       LBNE   LIGNE

       LDY    #$A800
CARAC  LDX    12,Y
       STX    COMP+2
       LDD    #5
       PSHS   A,B
       STA    COMPTO
       LDU    #0
ANAL   LDD    ,Y++
COMP   CMPD   #0000
       BCS    SUPER
       LEAU   D,U
       INC    COMPTO
SUPER  ROR    ,S
       DEC    1,S
       BMI    AUTRE
       BNE    ANAL
       ROR    ,S
       BRA    ANAL
AUTRE  PULS   A,B
       COMA
       LSRA
       LDX    ,Y++
       STA    ,Y+
       TFR    X,D
       LEAX   D,X
       LEAX   D,X
       TFR    X,D
       LEAX   D,X
       TFR    U,D
       COMA
       COMB
       ADDD   #1
       LEAX   D,X
       LDB    #6
       SUBB   COMPTO
       BEQ    PADIVI
       CMPB   #6
       BRA    DIVI0
PADIVI LDA    #$7F
       STA    -1,Y
STOCOL LDA    #0
       ADDA   -3,Y
       BRA    COPOCT
DIVI0  STB    DECPT0+2
       LDD    #$FFFF
       EXG    D,X
DECPT0 SUBD   #0
       LEAX   1,X
       BPL    DECPT0
       TFR    X,D
       LSLA
       LSLA
       LSLA
       STA    STOCOL+1
       STA    ,Y
       LDA    COMPTO
       STA    DECPT1+2
       LDD    #$FFFF
       EXG    D,U
DECPT1 SUBD   #0
       LEAU   1,U
       BPL    DECPT1
       TFR    U,D
       ORA    ,Y
COPOCT STA    ,Y+
       CMPY   #$DA00
       LBNE   CARAC

*HARMONISATION DES SUITES DE COULEURS

       LDX    #$A80F
       LDA    #$FF
       STA    VALA+1
       STA    VALB+1
HARMO  LDA    ,X
       TFR    A,B
       ANDA   #7
       LSRB
       LSRB
       LSRB
       PSHS   A,B
VALB   CMPA   #0
       BEQ    CHGO
VALA   CMPB   #0
       BNE    CHGN
CHGO   LSLA
       LSLA
       LSLA
       STA    ,X
       ORB    ,X
       LDA    -1,X
       COMA
       ANDA   #$7F
       ORA    #$20
       STD    -1,X
       PULS   A,B
       EXG    A,B
       BRA    CHGF
CHGN   PULS   A,B
CHGF   STA    VALA+1
       STB    VALB+1
       LEAX   16,X
       CMPX   #$DA00
       BLO    HARMO


       LDU    #TABLE
       LDY    #$A001
       LDX    #$A80E
       LDD    #$0C0E
       STD    ,Y++
       LDA    #$FF
       STA    COLOR+1
       STA    COLOR0+1
       STA    COLOR2+1
AFFMIN LDA    #$1B
       LDB    1,X
COLOR  CMPB   #0
       BEQ    COMPAC
       ANDB   #7
COLOR0 CMPB   #0
       BEQ    COLOR1
       STB    COLOR0+1
       LDB    B,U
       ORB    #$40
       STD    ,Y++
COLOR1 LDB    1,X
       STB    COLOR+1
       LSRB
       LSRB
       LSRB
COLOR2 CMPB   #0
       BEQ    COLOR3
       STB    COLOR2+1
       LDB    B,U
       ORB    #$50
       STD    ,Y++
COLOR3 LDA    ,X
REPRIS STA    ,Y+
       LEAX   16,X
REPSUI CMPX   #$DA00
       BLO    AFFMIN
       LDD    #$0F1B
       STD    ,Y++
       LDA    #$47
       STD    ,Y++
       LDD    #$50FF
       STD    ,Y++
       LBRA   AFFICH

* COMPACTAGE SI CODES REPETES > 3 FOIS

COMPAC LDA    ,X
       CMPA   -16,X
       BNE    REPRIS
       PSHS   X,U
       CLRB
       LDU    ,X
       STU    COMCOM+2
COMCO0 LEAX   16,X
       INCB
       LDU    ,X
COMCOM CMPU   #0
       BEQ    COMCO0
       PULS   X,U
       CMPB   #3
       BLO    REPRIS
       CMPB   #64
       BLO    PASTRO
       LDB    #64
PASTRO LDA    #$12    REPETITION
       ADDB   #64
       STD    ,Y++
       LDA    #16
       SUBB   #64
       MUL
       LEAX   D,X
       BRA    REPSUI


CALZON PSHS   X,A
       SUBA   #3
       STA    TAILLE
CLZ0   BSR    CALOC
       LEAX   40,X
       DEC    ,S
       BNE    CLZ0
       LDX    ,U
       LBSR   XMUL
       STX    ,U++
       LDX    ,U
       LBSR   XMUL
       STX    ,U++
       PULS   A,X,PC

CALOC  PSHS   X,Y
       LDY    #TABGRI
       LDA    $E7C3
       ANDA   #$FE
       STA    $E7C3
       LDB    ,X
       TFR    B,DP
       ORA    #1
       STA    $E7C3
       TST    TYPE
       LBEQ   CALOC7
       BMI    CALOCH

CALOC4 PSHS   DP
       LDA    ,X
       LDX    ,U
       CLRB
       LSLA
       ROLB
       LSL    ,S
       ROLB
       LDB    B,Y
       ABX
       CLRB
       LSLA
       ROLB
       LSL    ,S
       ROLB
       LDB    B,Y
       ABX
       CLRB
       LSLA
       ROLB
       LSL    ,S
       ROLB
       LDB    B,Y
       ABX
       CLRB
       LSLA
       ROLB
       LSL    ,S
       ROLB
       LDB    B,Y
       ABX
       STX    ,U
       LDX    2,U
       CLRB
       LSLA
       ROLB
       LSL    ,S
       ROLB
       LDB    B,Y
       ABX
       CLRB
       LSLA
       ROLB
       LSL    ,S
       ROLB
       LDB    B,Y
       ABX
       CLRB
       LSLA
       ROLB
       LSL    ,S
       ROLB
       LDB    B,Y
       ABX
       CLRB
       LSLA
       ROLB
       LSL    ,S
       ROLB
       LDB    B,Y
       ABX
       STX    2,U
       PULS   A,X,Y,PC

CALOCH LDB    ,X
       LDX    ,U
       PSHS   B
       LSRB
       LSRB
       LSRB
       LSRB
       LDB    B,Y
       ABX
       ABX
       PULS   B
       ANDB   #$0F
       LDB    B,Y
       ABX
       ABX
       STX    ,U
       TFR    DP,B
       LSRB
       LSRB
       LSRB
       LSRB
       LDB    B,Y
       LDX    2,U
       ABX
       ABX
       TFR    DP,B
       ANDB   #$0F
       LDB    B,Y
       ABX
       ABX
       STX    2,U
       PULS   X,Y,PC

CALOC7 LDA    ,X
       ANDB   #$87
       BMI    PAST0
       ORB    #8
PAST0  ANDB   #$0F
       LDB    B,Y
       EXG    B,DP
       ANDB   #$78
       BITB   #$40
       BNE    PAST1
       ORB    #$40
       BRA    PAST2
PAST1  ANDB   #$38
PAST2  LSRB
       LSRB
       LSRB
       LDB    B,Y
       EXG    B,DP
       PSHS   B,DP
       LDX    ,U
       CLRB
       LSLA
       ROLB
       LDB    B,S
       ABX
       CLRB
       LSLA
       ROLB
       LDB    B,S
       ABX
       CLRB
       LSLA
       ROLB
       LDB    B,S
       ABX
       CLRB
       LSLA
       ROLB
       LDB    B,S
       ABX
       STX    ,U
       LDX    2,U
       CLRB
       LSLA
       ROLB
       LDB    B,S
       ABX
       CLRB
       LSLA
       ROLB
       LDB    B,S
       ABX
       CLRB
       LSLA
       ROLB
       LDB    B,S
       ABX
       CLRB
       LSLA
       ROLB
       LDB    B,S
       ABX
       STX    2,U
       PULS   A,B,X,Y,PC

XMUL   PSHS   X
       TFR    X,D
       TST    TAILLE
       BEQ    X13D8
X39D32 LSLB
       ROLA
       LSLB
       ROLA
       LEAX   D,X
       TFR    X,D
       LSLB
       ROLA
       LSLB
       ROLA
       LSLB
       ROLA
       TFR    D,X
       PULS   D
       COMA
       COMB
       ADDD   #1
       LEAX   D,X
       TFR    X,D
       LSRA
       RORB
       LSRA
       RORB
       BRA    FINXD
X13D8  LSLB
       ROLA
       LEAX   D,X
       TFR    X,D
       LSLB
       ROLA
       LSLB
       ROLA
       PULS   X
       LEAX   D,X
       TFR    X,D
FINXD  LSRA
       RORB
       LSRA
       RORB
       LSRA
       RORB
       LDX    CORREC
       LEAX   D,X
       CMPX   #0
       BPL    COR0
       LDX    #0
       BRA    COR1
COR0   CMPX   #$800
       BLO    COR1
       LDX    #$7FF
COR1   RTS

AFFICH TST    FLAGAF
       LBNE   TOMIN

* AFFICHAGE TO8

AFFTO  LDB    #$1B
       JSR    $E803
       LDB    #$5A
       JSR    $E803
       LDB    #$0C
       JSR    $E803
       LDB    #$14
       JSR    $E803
       LDX    #PALGRI
       LDA    #$FF
       JSR    $EC00

       LDU    #TABCOL
       LDX    #$B000
       LDY    #$A003
CD1    LDB    COUL
CD2    LDA    ,Y+
       CMPA   #$12
       BEQ    REPETE
       CMPA   #$1B
       BNE    CD4
       LDA    ,Y+
       SUBA   #$40
       CMPA   #8
       BLO    CD3
       ANDB   #$38
       SUBA   #8
       ORB    A,U
       BRA    CD2
CD3    ANDB   #7
       ORB    A,U
       BRA    CD2
CD4    ORB    #$C0
       STB    COUL
       STB    2400,X
       CLRB
       LSRA
       BCC    CD5
       ORB    #$F0
CD5    LSRA
       BCC    CD6
       ORB    #$0F
CD6    STB    1600,X
       CLRB
       LSRA
       BCC    CD7
       ORB    #$F0
CD7    LSRA
       BCC    CD8
       ORB    #$0F
CD8    STB    800,X
       CLRB
       LSRA
       BCC    CD9
       ORB    #$F0
CD9    LSRA
       LSRA
       BCC    CD10
       ORB    #$0F
CD10   STB    ,X+
       BRA    CD11

REPETE LDA    ,Y+
       SUBA   #$40
       PSHS   A,X
       LEAX   2400,X
       LDB    -1,X
REP0   STB    ,X+
       DECA
       BNE    REP0
       PULS   A,X
       PSHS   A,X
       LEAX   1600,X
       LDB    -1,X
REP1   STB    ,X+
       DECA
       BNE    REP1
       PULS   A,X
       PSHS   A,X
       LEAX   800,X
       LDB    -1,X
REP2   STB    ,X+
       DECA
       BNE    REP2
       PULS   A,X
       LDB    -1,X
REP3   STB    ,X+
       DECA
       BNE    REP3

CD11   CMPX   #$B000+800
       LBLO   CD1

       LDA    $E7C3
       ANDA   #$FE
       STA    $E7C3
       LDX    #$B000+2400
       LDY    #$4000
       LDA    #20
CD12   LDB    #20
CD13   LDU    ,X++
       STU    40,Y
       STU    80,Y
       STU    120,Y
       STU    160,Y
       STU    200,Y
       STU    240,Y
       STU    280,Y
       STU    320,Y
       STU    360,Y
       STU    ,Y++
       DECB
       BNE    CD13
       LEAY   360,Y
       DECA
       BNE    CD12

       LDA    $E7C3
       ORA    #1
       STA    $E7C3
       LDX    #$B000
       LDY    #$4000
       LDA    #20
CD14   LDB    #20
CD15   LDU    1600,X
       STU    ,Y
       STU    40,Y
       STU    80,Y
       LDU    800,X
       STU    120,Y
       STU    160,Y
       STU    200,Y
       STU    240,Y
       LDU    ,X++
       STU    280,Y
       STU    320,Y
       STU    360,Y
       LEAY   2,Y
       DECB
       BNE    CD15
       LEAY   360,Y
       DECA
       BNE    CD14
FINAF  JSR    $E806
       TSTB
       BEQ    FINAF
       LDX    #PALORI
       LDA    #$FF
       JSR    $EC00
       LBRA   FIN

TOMIN  LDD    #$1B3A
       STD    ,Y++
       LDD    #$6AFE
       STD    ,Y++
       LDD    #$E7FD
       TFR    A,DP
       STB    <$C2
       LDU    #$A000
       LBSR   ROUT1
       LDX    #$1000
TEMP1  LEAX   -1,X
       BNE    TEMP1
       CLRB
       ORCC   #$50
TOMI0  LDA    #$07
       STA    ,S
       BSR    ROUT1
       LDX    #$0060
       STX    <$C6
       LDA    #$A2
       STA    <$C5
       CLRA
       BSR    ROUT2
TOMI1  LSRB
       BCC    TOMI2
       BSR    ROUT1
       INCA
       BRA    TOMI3
TOMI2  BSR    ROUT2
TOMI3  DEC    ,S
       BNE    TOMI1
       BITA   #$01
       BNE    TOMI4
       BSR    ROUT2
       BRA    TOMI5
TOMI4  BSR    ROUT1
TOMI5  LDB    ,U+
       BPL    TOMI0
       CMPB   #$FF
       BNE    FINAF
       LDB    ,U+
       BRA    TOMI0

ROUT1  PSHS   X,A
       LDA    <$C5
       ORA    #$80
       BRA    TOMI6
ROUT2  PSHS   X,A
       LDA    <$C5
       ANDA   #$7F
       BRA    TOMI6
TOMI6  STA    <$C5
       LDX    #$0061
TEMP2  LEAX   -1,X
       BNE    TEMP2
       PULS   A,X,PC


* sauvegarde

SAVE   PSHS   A,B,CC,DP,X,Y,U
       LDX    #FILE
       LDA    ,X++
       SUBA   #$30
       STA    $6049
       LDU    #$624B
       LDD    #$2003
       STD    ,U++
       LDA    #$FF
       STA    ,U++
       LDB    #8
COPS   LDA    ,X+
       STA    ,U+
       DECB
       BNE    COPS
       LDD    #$5445  'TE'
       STD    ,U++
       LDD    #$4C09  'L'+8 octets
COPC   STA    ,U+
       LDA    ,X+
       DECB
       BNE    COPC

       LDB    #3      CODE DE OPEN
       JSR    $EC0C   OUVERTURE
       LDX    #$A001  #FICHIER
COPEN0 LDA    ,X+
       BMI    QUITTE
       LDB    #4
       JSR    $EC0C
       BRA    COPEN0

QUITTE LDB    #6      CLOSE
       JSR    $EC0C
FIN    PULS   A,B,DP,CC,X,Y,U,PC

TABLE  FCB    0,4,1,5,2,6,3,7
TABCOL FCB    0,16,32,48,8,24,40,56
       FCB    0,2,4,6,1,3,5,7

COUL   FCB    0
COMPTO FCB    0
COMPTL FCB    0
TAILLE FCB    0

PALET  RMB    32
TABGRI RMB    16
PALGRI FDB    0,546,1092,1638,2184,2730
       FDB    3276,3822,4095,4095,4095
       FDB    4095,4095,4095,4095,4095
PALORI FDB    0,15,240,255,3840,3855
       FDB    4080,4095,1911,826,931,938
       FDB    2611,2618,3815,123
TYPE   FCB    0

CORREC FDB    0
FLAGAF FCB    0
FILE   FCC    #4:        #
COMMEN FCC    #PhotoTEL#

       END
