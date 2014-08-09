*VIDEOTEXT


*EDITEUR

COMPTX EQU    $9800
COMPTY EQU    $9801
LX     EQU    $9802
LY     EQU    $9803

       ORG    $9000

DEBUT  PSHS   A,B,CC,DP,X,Y,U
G      LDB    #$11
       JSR    $E803
       LDD    #$0600
       STD    LX
B0     LDY    #$A000
BOUCLE CMPY   #$A000
       BLO    B0
       CMPY   #$DF80
       BLO    B1
       LDY    #$DF78
B1     TFR    Y,X
       LBSR   AFFICH
CURSOR LDD    LX
       LBSR   LOCATE
*KTST  JSR    $E809
*      BCC    KTST
GETC   JSR    $E806
       BCC    GETC
ANAL   LDA    LX
       LDU    #TABLIN
KEY8   CMPB   #8
       BNE    KEY9
KEY81  DECA
       CMPA   #6
       BLO    KEY82
       TST    A,U
       BEQ    KEY81
       BRA    POSCUR
KEY82  LDA    #39
       BRA    POSCUR
KEY9   CMPB   #9
       BNE    KEY10
KEY91  INCA
       CMPA   #38
       BHI    KEY92
       TST    A,U
       BEQ    KEY91
       BRA    POSCUR
KEY92  LDA    #6
POSCUR STA    LX
       BRA    CURSOR
KEY10  CMPB   #10
       BNE    KEY11
KEY101 INC    LY
       LDA    LY
       CMPA   #25
       BLO    CURSOR
       DEC    LY
       LBRA   SCRHAU
KEY11  CMPB   #11
       BNE    AUTRE
KEY111 DEC    LY
       BPL    CURSOR
       INC    LY
       LBRA   SCRBAS
AUTRE  CMPB   #153
       LBEQ   K
       CMPB   #32
       BLO    GETC
       CMPB   #127
       BHI    GETC
       TST    A,U
       BPL    MODIF
       CMPB   #$30
       BLO    GETC
       CMPB   #$3A
       BLO    MODIF
       ANDB   #$DF
       CMPB   #$41
       BLO    GETC
       CMPB   #$46
       BHI    GETC
MODIF  TST    A,U
       BMI    CODHEX
       PSHS   B
       SUBA   #31
       LEAX   A,Y
       LDA    LY
       LDB    #8
       MUL
       LEAX   D,X
       PULS   A
       BRA    ECRIT
CODHEX SUBB   #$30
       CMPB   #10
       BLO    COD0
       SUBB   #7
COD0   PSHS   B
       LDB    A,U
       ANDB   #$0F
       PSHS   B
       LSRB
       LEAX   B,Y
       LDA    LY
       LDB    #8
       MUL
       LEAX   D,X
       PULS   A
       BITA   #1
       BEQ    GAUCHE
       PULS   B
       LDA    ,X
       LSRA
       LSRA
       LSRA
       LSRA
       LSLB
       LSLB
       LSLB
       LSLB
       LSRA
       RORB
       LSRA
       RORB
       LSRA
       RORB
       LSRA
       RORB
       TFR    B,A
       BRA    ECRIT
GAUCHE PULS   A
       LDB    ,X
       LSLB
       LSLB
       LSLB
       LSLB
       LSRA
       RORB
       LSRA
       RORB
       LSRA
       RORB
       LSRA
       RORB
       TFR    B,A
ECRIT  STA    ,X
       STX    $9900
       LDB    #9
       LDA    LY
       LDB    #8
       MUL
       LEAX   D,Y
       LDA    LY
       BSR    AFFLI
       LDA    LX
       CMPA   #38
       BNE    NOR1
       LDA    #31
       BRA    NOR2
NOR1   CMPA   #28
       BNE    NOR3
       LDA    #6
NOR2   STA    LX
       LBRA   KEY101
NOR3   LBRA   KEY91

K      NOP


****AFFICHAGE D'UNE PAGE DEPUIS X ****

AFFICH LDA    #25
       STA    COMPTY
NLIGNE BSR    LIGNE
       DEC    COMPTY
       BNE    NLIGNE
       RTS

**** affichage de la ligne no A

AFFLI  NEGA
       ADDA   #25
       STA    COMPTY

**** affichage d'une ligne

LIGNE  LDA    #8
       STA    COMPTX
       LDB    COMPTY
       NEGB
       ADDB   #25
       CLRA
       BSR    LOCATE
       BSR    HEXA4
       BSR    SPACE
       BSR    SPACE
HEXA   LDA    ,X+
       BSR    HEXA2
       BSR    SPACE
       DEC    COMPTX
       BNE    HEXA
       LEAX   -8,X
       LDA    #8
       STA    COMPTX
       BSR    SPACE
ASCII  LDB    ,X+
       CMPB   #$20
       BLO    POINT
       CMPB   #$80
       BLO    PRINT
POINT  LDB    #$2E
PRINT  JSR    $E803
       DEC    COMPTX
       BNE    ASCII
       RTS

****LOCATE A,B

LOCATE PSHS   A
       PSHS   B
       LDB    #$1F
       JSR    $E803
       PULS   B
       ADDB   #$40
       JSR    $E803
       PULS   B
       ADDB   #$41
       JMP    $E803

****HEXA4 AFF. DU NBRE X DE 4 CH.EN HEXA

HEXA4  TFR    X,D
       PSHS   B
       BSR    HEXA2
       PULS   A

****HEXA2 AFF. DU NBRE A DE 2 CH.EN HEXA

HEXA2  TFR    A,B
       LSRB
       LSRB
       LSRB
       LSRB
       CMPB   #10
       BLO    HEXA21
       ADDB   #7
HEXA21 ADDB   #$30
       JSR    $E803
       TFR    A,B
       ANDB   #$0F
       CMPB   #10
       BLO    HEXA22
       ADDB   #7
HEXA22 ADDB   #$30
       JMP    $E803

**** SPACE: AFF. DE A ESPACES

SPACE  LDB    #$20
       JMP    $E803

**** scroll haut

SCRHAU PSHS   X,Y,U
       LDB    #$14
       JSR    $E803
       LDX    #$4140
       LDY    #$4000
       LDA    #192
SH0    LDU    ,X++
       STU    ,Y++
       LDU    ,X++
       STU    ,Y++
       LDU    ,X++
       STU    ,Y++
       LDU    ,X++
       STU    ,Y++
       LDU    ,X++
       STU    ,Y++
       LDU    ,X++
       STU    ,Y++
       LDU    ,X++
       STU    ,Y++
       LDU    ,X++
       STU    ,Y++
       LDU    ,X++
       STU    ,Y++
       LDU    ,X++
       STU    ,Y++
       LDU    ,X++
       STU    ,Y++
       LDU    ,X++
       STU    ,Y++
       LDU    ,X++
       STU    ,Y++
       LDU    ,X++
       STU    ,Y++
       LDU    ,X++
       STU    ,Y++
       LDU    ,X++
       STU    ,Y++
       LDU    ,X++
       STU    ,Y++
       LDU    ,X++
       STU    ,Y++
       LDU    ,X++
       STU    ,Y++
       LDU    ,X++
       STU    ,Y++
       DECA
       BNE    SH0
       LDB    #$11
       JSR    $E803
       PULS   X,Y,U
       LDA    #24
       LEAY   8,Y
       LEAX   192,Y
       LBSR   AFFLI
       LBRA   CURSOR

**** scroll bas

SCRBAS PSHS   X,Y,U
       LDB    #$14
       JSR    $E803
       LDX    #$5E00
       LDY    #$5F40
       LDA    #192
SB0    LDU    ,--X
       STU    ,--Y
       LDU    ,--X
       STU    ,--Y
       LDU    ,--X
       STU    ,--Y
       LDU    ,--X
       STU    ,--Y
       LDU    ,--X
       STU    ,--Y
       LDU    ,--X
       STU    ,--Y
       LDU    ,--X
       STU    ,--Y
       LDU    ,--X
       STU    ,--Y
       LDU    ,--X
       STU    ,--Y
       LDU    ,--X
       STU    ,--Y
       LDU    ,--X
       STU    ,--Y
       LDU    ,--X
       STU    ,--Y
       LDU    ,--X
       STU    ,--Y
       LDU    ,--X
       STU    ,--Y
       LDU    ,--X
       STU    ,--Y
       LDU    ,--X
       STU    ,--Y
       LDU    ,--X
       STU    ,--Y
       LDU    ,--X
       STU    ,--Y
       LDU    ,--X
       STU    ,--Y
       LDU    ,--X
       STU    ,--Y
       DECA
       BNE    SB0
       LDB    #$11
       JSR    $E803
       PULS   X,Y,U
       CLRA
       LEAY   -8,Y
       TFR    Y,X
       LBSR   AFFLI
       LBRA   CURSOR







TABLIN FCB    0,0,0,0,0,0,$80,$81,0,$82
       FCB    $83,0,$84,$85,0,$86,$87,0
       FCB    $88,$89,0,$8A,$8B,0,$8C
       FCB    $8D,0,$8E,$8F,0,0
       FCB    1,1,1,1,1,1,1,1,0

       END
