****************************
* PUTC3 EN 40 COLONNES     *
* REPRISE DE PUTC3         *
* ET DE PUTC80             * DISQUE
* TRANSLATABLE.            * RESEAU 1
* NOM : PUTC340            *
****************************

       ORG    $A000
       PSHS   U,Y,X,B,A,CC
       LDA    COUL,PCR
       CMPA   #16
       BHS    FIN
       LDA    COL,PCR
       CMPA   #39
       BHS    FIN
       LDA    LIG,PCR
       CMPA   #24
       BLS    S01
FIN    LDB    #$07
       JSR    >$E803
FIN1   PULS   CC,A,B,X,Y,U,PC
S01    LDB    #$08    *CALCULS :
       MUL
       LDA    #$28    *NO LIG
       MUL
       ADDD   #$4000  *ADR D'AFFICHA
       TFR    D,X
       LDB    COL,PCR
       ABX
       TFR    X,U     *U POINTE ADR
       LDX    TEX,PCR *X POINTE TEX
DEBUT  LDY    POL,PCR *Y POINTE POL
       LDA    ,X+     *NUMERO LETTRE
       CMPA   #$1F    *MODIFIE
       BLS    FIN1    *POUR CONFORMITE
       CMPA   #$7F    *ASCII
       BHI    FIN1
       CMPA   #64     *TEST SI A-Z
       BLS    S02
       CMPA   #91
       BHS    S02
       SUBA   #65
       BRA    SUIT
S02    CMPA   #96     *TEST SI a-z
       BLS    S03
       CMPA   #127
       BEQ    S05
       SUBA   #45
       BRA    SUIT
S03    CMPA   #47     *TEST SI 0-9
       BLS    S04
       CMPA   #58
       BHS    S04
       SUBA   #06
       BRA    SUIT
S04    CMPA   #36     *TEST SI -#
       BHS    S05
       SUBA   #06
       BRA    SUIT
S05    LDB    #30
       PSHS   U
       LEAU   TAB,PCR
S06    CMPA   ,U+
       BEQ    S07
       INCB
       CMPB   #42
       BNE    S06
S07    TFR    B,A
       PULS   U
SUIT   LDB    #8
       STA    NUM,PCR
       LSRA
       MUL
       LEAY   D,Y
       LDB    #$08
S09    LDA    ,Y+
       BSR    AFFI
       LEAU   $28,U
       DECB
       BNE    S09
       LEAU   -$140,U
       INC    COL,PCR
       LDA    COL,PCR
       CMPA   #40
       BNE    S08
       CLR    COL,PCR
       INC    LIG,PCR
       LDA    LIG,PCR
       CMPA   #25
       LBEQ   FIN
       LEAU   $118,U
S08    LEAU   $01,U
       LBRA   DEBUT
************************
****AFFICHAGE LETTRE****
************************
AFFI   PSHS   B       *A POINTE SUR
       BSR    RAMA    *FORME LETTRE
       LDB    NUM,PCR
       LSRB
       BCC    S11
       LSLA           *DECAL A SI NUM
       LSLA           *IMPAIRE.
       LSLA           *CAR 2 LETTRES
       LSLA           *PAR OCTET.
S11    LSLA
       BCC    SUIT1
       BSR    SUB2
SUIT1  LSLA
       BCC    SUIT2
       BSR    SUB3
SUIT2  BSR    RAMB
       LSLA
       BCC    SUIT3
       BSR    SUB2
SUIT3  LSLA
       BCC    SUIT4
       BSR    SUB3
SUIT4  PULS   B,PC
************
****SUB2****
************
SUB2   LDB    ,U
       ANDB   #$0F
       STB    ,U
       LDB    COUL,PCR
       ASLB
       ASLB
       ASLB
       ASLB
       ORB    ,U
       STB    ,U
       RTS
************
****SUB3****
************
SUB3   LDB    ,U
       ANDB   #$F0
       STB    ,U
       LDB    COUL,PCR
       ORB    ,U
       STB    ,U
       RTS
************
****RAMA****
************
RAMA   LDB    >$E7C3
       ORB    #$01
       STB    >$E7C3
       RTS
************
****RAMB****
************
RAMB   LDB    >$E7C3
       ANDB   #$FE
       STB    >$E7C3
       RTS
*************
****STOCK****
*************
COUL   FCB    $01
COL    FCB    $00
LIG    FCB    $00
TEX    FDB    $0000
POL    FDB    $0000
NUM    FCB    $00
TAB    FCC    \+-/*,\
       FCB    127
       FCC    \'?.=:$\
       END
