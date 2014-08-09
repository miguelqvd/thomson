**************** MAP>TRA1 **************
*                                      *
* TRANSCODEUR D'IMAGES TO.MAP > TRAMES *
*                                      *
* par Michel SAINT-BRIANT * 15/03/1992 *
*                                      *
* (c)    A.S.C.I.    Copyright    1992 *
*                                      *
****************************************

* TRANSCODAGE D'UNE IMAGE THOMSON EN UNE
* IMAGE DE 80 COLONNES EN 16 TRAMES /65

       ORG    $9800

       PSHS   A,B,CC,DP,X,Y,U

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
       LDD    ,X++
       ANDA   #$0F
       LEAU   A,U
       ANDB   #$0F
       LSLB
       LEAU   B,U
       TFR    U,D
       STB    ,Y+
       CMPX   #PALET+32
       BLO    NOUPAL

* CALCUL DES TRAMES EN FONCTION DE L'IN-
* TENSITE LUMINEUSE DANS TABGRI (16/65)

       LDU    #TABGRI
       LDX    #TRAME
       LDY    #TRAINI
       LDB    #16
NOUTRA LDA    #105
       SUBA   ,U+
       PSHS   A,B,X,U
       LDB    #158
       MUL
       ANDA   #$7C
       LEAU   A,Y
       LDB    #4
TRA0   LDA    ,U
       LSLA
       LSLA
       LSLA
       LSLA
       ORA    ,U+
       STA    4,X
       STA    ,X+
       DECB
       BNE    TRA0
       LDA    ,S
       ANDA   #3
       BEQ    FINTRA
       LDB    #3
TRA1   LDA    B,U
       LSLA
       LSLA
       LSLA
       LSLA
       ORA    B,X
       STA    B,X
       DECB
       BPL    TRA1
       LEAX   -4,X
       LDA    ,S
       ANDA   #3
       CMPA   #2
       BLO    FINTRA
       LDB    #3
TRA2   LDA    B,U
       ORA    B,X
       STA    B,X
       DECB
       BPL    TRA2
       LEAX   4,X
       LDA    ,S
       ANDA   #3
       CMPA   #3
       BLO    FINTRA
       LDB    #3
TRA3   LDA    B,U
       ORA    B,X
       STA    B,X
       DECB
       BPL    TRA3
FINTRA PULS   A,B,X,U
       LEAX   8,X
       DECB
       BNE    NOUTRA

* RECOPIE DE L'IMAGE EN $A000/$DFFF
* EN ENTRELACE

       LDB    #$14
       JSR    $E803
       LDA    $E7C3
       ORA    #$01
       STA    $E7C3
       LDX    #$4000
       LDY    #$A000
COPEC0 LDD    ,X++
       STA    ,Y++
       STB    ,Y++
       CMPX   #$5F40
       BLO    COPEC0
       LDA    $E7C3
       ANDA   #$FE
       STA    $E7C3
       LDX    #$4000
       LDY    #$A001
COPEC1 LDD    ,X++
       STA    ,Y++
       STB    ,Y++
       CMPX   #$5F40
       BLO    COPEC1

       LDX    #$A000
       LDY    #TRAME
       LDD    #$2807
       STA    COLON
       STB    LIGNE

NEWOCT LDD    #$0000
       PSHS   B,A
       LDA    #$C0
       STA    FILTRE
       TST    TYPE
       LBEQ   MODTO7
       LBMI   MODB16

MODBM4 CLRA
       ASL    ,X
       ROLA
       ASL    1,X
       ROLA
       LSLA
       LSLA
       LSLA
       LEAU   A,Y
       LDA    LIGNE
       LDA    A,U
       ANDA   FILTRE
       ORA    ,S
       STA    ,S
       LSR    FILTRE
       LSR    FILTRE
       BNE    MODBM4
       LDA    #$C0
       STA    FILTRE
MODBM5 CLRA
       ASL    ,X
       ROLA
       ASL    1,X
       ROLA
       LSLA
       LSLA
       LSLA
       LEAU   A,Y
       LDA    LIGNE
       LDA    A,U
       ANDA   FILTRE
       ORA    1,S
       STA    1,S
       LSR    FILTRE
       LSR    FILTRE
       BNE    MODBM5
       LBRA   FINMOD

MODTO7 LDA    1,X
       BITA   #$40
       BEQ    OCTET0
       ANDA   #$38
       BRA    OCTET1
OCTET0 ORA    #$40
OCTET1 ANDA   #$78
       STA    FORM0+1
       STA    FORM1+1
       LDA    1,X
       ANDA   #$07
       TST    1,X
       BMI    OCTET2
       ORA    #$08
OCTET2 LSLA
       LSLA
       LSLA
       STA    FOND0+1
       STA    FOND1+1
FORM0  LDA    #$00
       ASL    ,X
       BCS    POINT0
FOND0  LDA    #$00
POINT0 LEAU   A,Y
       LDA    LIGNE
       LDA    A,U
       ANDA   FILTRE
       ORA    ,S
       STA    ,S
       LSR    FILTRE
       LSR    FILTRE
       BNE    FORM0
       LDA    #$C0
       STA    FILTRE
FORM1  LDA    #$00
       ASL    ,X
       BCS    POINT1
FOND1  LDA    #$00
POINT1 LEAU   A,Y
       LDA    LIGNE
       LDA    A,U
       ANDA   FILTRE
       ORA    1,S
       STA    1,S
       LSR    FILTRE
       LSR    FILTRE
       BNE    FORM1
       BRA    FINMOD

MODB16 LDA    ,X
       ANDA   #$F0
       LSRA
       LEAU   A,Y
       LDA    LIGNE
       LDA    A,U
       ANDA   #$F0
       ORA    ,S
       STA    ,S
       LDA    ,X
       ANDA   #$0F
       LSLA
       LSLA
       LSLA
       LEAU   A,Y
       LDA    LIGNE
       LDA    A,U
       ANDA   #$0F
       ORA    ,S
       STA    ,S
       LDA    1,X
       ANDA   #$F0
       LSRA
       LEAU   A,Y
       LDA    LIGNE
       LDA    A,U
       ANDA   #$F0
       ORA    1,S
       STA    1,S
       LDA    1,X
       ANDA   #$0F
       LSLA
       LSLA
       LSLA
       LEAU   A,Y
       LDA    LIGNE
       LDA    A,U
       ANDA   #$0F
       ORA    1,S
       STA    1,S

FINMOD PULS   A,B
       STD    ,X++
       CMPX   #$DE80
       BHS    AFFTO
       DEC    COLON
       LBNE   NEWOCT
       LDA    #$28
       STA    COLON
       DEC    LIGNE
       LBPL   NEWOCT
       LDA    #7
       STA    LIGNE
       LBRA   NEWOCT

AFFTO  LDB    #$1B
       JSR    $E803
       LDB    #$5B
       JSR    $E803
       LDB    #$1B
       JSR    $E803
       LDB    #$40
       JSR    $E803
       LDB    #$1B
       JSR    $E803
       LDB    #$57
       JSR    $E803
       LDB    #$0C
       JSR    $E803
       LDB    #$14
       JSR    $E803
       LDX    #PALORI
       LDA    #$FF
       JSR    $EC00
       LDX    #$A001
       LDY    #$4000
       LDA    $E7C3
       ANDA   #$FE
       STA    $E7C3
RESULB LDA    ,X++
       LDB    ,X++
       STD    ,Y++
       CMPX   #$DE80
       BLO    RESULB
       LDX    #$A000
       LDY    #$4000
       LDA    $E7C3
       ORA    #1
       STA    $E7C3
RESULA LDA    ,X++
       LDB    ,X++
       STD    ,Y++
       CMPX   #$DE80
       BLO    RESULA

FIN    PULS   A,B,DP,CC,X,Y,U,PC

LIGNE  FCB    0
COLON  FCB    0
FILTRE FCB    0
PALET  RMB    32
TABGRI RMB    16

PALORI FDB    4095,0,240,255,3840,3855
       FDB    4080,4095,1911,826,931,938
       FDB    2611,2618,3815,123
TYPE   FCB    0
TRAINI FCB    0,0,0,0,0,0,8,0
       FCB    2,0,8,0,2,0,10,0
       FCB    10,0,10,0,10,0,10,4
       FCB    10,1,10,4,10,1,10,5
       FCB    10,5,10,5,10,5,14,5
       FCB    11,5,14,5,11,5,15,5
       FCB    15,5,15,5,15,5,15,13
       FCB    15,7,15,13,15,7,15,15
       FCB    15,15,15,15
TRAME  RMB    16*8

       END
